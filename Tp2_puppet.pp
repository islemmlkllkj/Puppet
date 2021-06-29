$pathsrc = '/usr/src'
$pathbin = '/usr/bin'
$pathweb = '/var/www'

class dokuwiki {
    package { 'apache2':
            ensure => present
    }

    package { 'php7.3':
            ensure => present
    }
	
    file { 'download-dokuwiki':
            ensure => present,
            source => 'https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz',
            path   => "${pathsrc}/dokuwiki.tgz"
    }

    exec { 'extract-dokuwiki':
            command => 'tar xavf dokuwiki.tgz',
            cwd     => "${pathsrc}",
            path    => ["${pathbin}"],
            require => File['download-dokuwiki'],
            unless  => "test -d ${pathsrc}/dokuwiki-2020-07-29"
    }

    file { 'rename-dokuwiki-2020-07-29':
            ensure  => present,
            source  => "${pathsrc}/dokuwiki-2020-07-29",
            path    => "${pathsrc}/dokuwiki",
            require => Exec['extract-dokuwiki']
    }
}

class dokuwikirecettes {
    file { 'create new directory for recettes.wiki in /var/www and allow apache to write in':
            ensure  => directory,
            source  => "${pathsrc}/dokuwiki",
            path    => "${pathweb}/recettes.wiki",
            recurse => true,
            owner   => 'www-data',
            group   => 'www-data',
            require => File['rename-dokuwiki-2020-07-29']
    }
}

class dokuwikipolitique {
    file { 'create new directory for politique.wiki in /var/www and allow apache to write in':            ensure  => directory,
            source  => "${pathsrc}/dokuwiki",
            path    => "${pathweb}/politique.wiki",
            recurse => true,
            owner   => 'www-data',
            group   => 'www-data',
            require => File['rename-dokuwiki-2020-07-29']
    }
}

node 'server0' {
    include dokuwiki
    include dokuwikirecettes
}

node 'server1' {
    include dokuwiki
    include dokuwikipolitique
}