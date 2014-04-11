
include remctl
class {'remctl::server': }

remctl::server::command { 'my_test_command':
    command             => 'command_name',
    subcommand          => 'ALL',
    executable          => '/bin/test',
    acls                => ['princ:test@TEST.REALM.ORG']
}

# vim: tabstop=4 shiftwidth=4 softtabstop=4
