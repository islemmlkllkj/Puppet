
exec {
    'tar xavf dokuwiki.tgz':
        cwd => '/usr/src',
        path => ['/usr/bin', '/usr/sbin']
}