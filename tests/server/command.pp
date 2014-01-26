
include remctl
class {'remctl::server': }

remctl::server::command { 'my_test_command':
    subcommand          => 'ALL',
    executable          => '/bin/test',
    acls                => ['princ:test@TEST.REALM.ORG']
}

# vim: tabstop=4 shiftwidth=4 softtabstop=4
