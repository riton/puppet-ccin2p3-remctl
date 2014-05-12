
class {'remctl::server': }

remctl::server::command { 'my_test_command':
    command             => 'command_name',
    subcommand          => 'ALL',
    executable          => '/bin/test',
    acls                => ['princ:test@TEST.REALM.ORG']
}

remctl::server::command { 'kadmin_cpw':
    command         => 'kadmin',
    subcommand      => 'change_password',
    executable      => '/usr/sbin/kadmin',
    options         => {
        help      => '--help',
        'summary' => '--summary',
    },
    acls            => ['ANYUSER']
}

remctl::server::command { 'kadmin_lock':
    command         => 'kadmin',
    subcommand      => 'lock_user',
    executable      => '/usr/sbin/kadmin',
    options         => {
        'help'      => '--help',
        'summary'   => '--summary',
    },
    acls            => ['princ:admin@EXAMPLE.ORG']
}


# vim: tabstop=4 shiftwidth=4 softtabstop=4
