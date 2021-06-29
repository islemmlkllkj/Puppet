class dokuwiki {
    $path_src = '/usr/src'
    $path_bin = '/usr/bin'
    $path_web = '/var/www'

    package { 'apache2':
            ensure => present
    }

    package { 'php7.3':
            ensure => present
    }

    file { 'download-dokuwiki':
            ensure => present,
            source => 'https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz',
            path   => "${path_src}/dokuwiki.tgz"
    }

    exec { 'extract-dokuwiki':
            command => 'tar xavf dokuwiki.tgz',
            cwd     => "${path_src}",
            path    => ["${path_bin}"],
            require => File['download-dokuwiki'],
            unless  => "test -d ${path_src}/dokuwiki-2020-07-29"
    }

    file { 'rename-dokuwiki-2020-07-29':
            ensure  => present,
            source  => "${path_src}/dokuwiki-2020-07-29",
            path    => "${path_src}/dokuwiki",
            require => Exec['extract-dokuwiki']
    }
}

class dokuwiki_deploy {
    $path_src = '/usr/src'
    $path_web = '/var/www'
	
    file { "create new directory for ${env}.wiki in ${path_web} and allow apache to write in":            
            ensure  => directory,
            source  => "${path_src}/dokuwiki",
            path    => "${path_web}/${env}.wiki",
            recurse => true,
            owner   => 'www-data',
            group   => 'www-data',
            require => File['rename-dokuwiki-2020-07-29']
    }
}

node 'server0' {
    #$env = 'recettes'
    include dokuwiki
    #include dokuwiki_deploy
    
    deploy_dokuwiki { "recettes.wiki":
        env => "recettes.wiki",
    }

    deploy_dokuwiki { "tajineworld.com":
        env => "tajineworld.com",
    }
}

node 'server1' {
    #$env = 'politique'
    include dokuwiki
    #include dokuwiki_deploy
    deploy_dokuwiki { "politique.wiki":
        env => "politique.wiki",
    }
}