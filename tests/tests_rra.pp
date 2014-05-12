# kadmin change_passwd /root/command.pl logmask=3,4 \
#     ANYUSER
# kadmin check_passwd  /root/command.pl logmask=3 \
#     /etc/remctl/acl/kadmin-examine /etc/remctl/acl/its-idg
#
# kadmin create        /root/command.pl logmask=3 \
#     /etc/remctl/acl/kadmin-create
#
# kadmin delete        /root/command.pl \
#     /etc/remctl/acl/kadmin-delete
#
# kadmin disable       /root/command.pl \
#     /etc/remctl/acl/kadmin-enable
#
# kadmin enable        /root/command.pl \
#     /etc/remctl/acl/kadmin-enable
#
# kadmin examine       /root/command.pl \
#     /etc/remctl/acl/kadmin-examine /etc/remctl/acl/its-idg \
#     /etc/remctl/acl/security /etc/remctl/acl/data-admin \
#     /etc/remctl/acl/data-view
#
# kadmin help          /root/command.pl \
#     ANYUSER
#
# kadmin instance      /root/command.pl logmask=5 \
#     /etc/remctl/acl/kadmin-instance
#
# kadmin reset_passwd  /root/command.pl logmask=3 \
#     /etc/remctl/acl/kadmin-reset
#
# kadmin check_expire  /root/command.pl \
#     /etc/remctl/acl/kadmin-check-expire
#
# kadmin expiration    /root/command.pl \
#     /etc/remctl/acl/kadmin-expiration
#
# kadmin pwexpiration  /root/command.pl \
#     /etc/remctl/acl/kadmin-expiration
#

include remctl
class {'remctl::server':
}

$_remctl_acl_kadmin_enable = "file:${remctl::server::acldir}/kadmin-enable"
$_remctl_acl_kadmin_expiration = "file:${remctl::server::acldir}/kadmin-expiration"
$_remctl_acl_its_idg = "file:${remctl::server::acldir}/its-idg"
$_remctl_acl_security = "file:${remctl::server::acldir}/security"

remctl::server::command { 'kadmin_pwexpiration':
    command             => 'kadmin',
    subcommand          => 'pwexpiration',
    executable          => '/root/command.pl',
    acls                => [
        $_remctl_acl_kadmin_expiration
    ]
}

remctl::server::command { 'kadmin_expiration':
    command             => 'kadmin',
    subcommand          => 'expiration',
    executable          => '/root/command.pl',
    acls                => [
        'princ:rferrand@IN2P3.FR',
        $_remctl_acl_kadmin_expiration
    ]
}

remctl::server::command { 'kadmin_check_expire':
    command             => 'kadmin',
    subcommand          => 'check_expire',
    executable          => '/root/command.pl',
    acls                => [
        'princ:rferrand@IN2P3.FR',
        "file:${remctl::server::acldir}/kadmin-check-expire",
    ]
}

remctl::server::command { 'kadmin_reset_passwd':
    command             => 'kadmin',
    subcommand          => 'reset_passwd',
    executable          => '/root/command.pl',
    options             => {
        'logmask'   => '3',
    },
    acls                => [
        'princ:rferrand@IN2P3.FR',
        "file:${remctl::server::acldir}/kadmin-reset",
    ]
}

remctl::server::command { 'kadmin_instance':
    command             => 'kadmin',
    subcommand          => 'instance',
    executable          => '/root/command.pl',
    options             => {
        'logmask'   => '5',
    },
    acls                => [
        'princ:rferrand@IN2P3.FR',
        "file:${remctl::server::acldir}/kadmin-instance",
    ]
}

remctl::server::command { 'kadmin_ALL':
    command             => 'kadmin',
    subcommand          => 'ALL',
    executable          => '/root/command.pl',
    options             => {
        'summary'   => '--summary',
        'help'      => '--help'
    },
    acls                => [ 'ANYUSER' ]
}

remctl::server::command { 'kadmin_help':
    command             => 'kadmin',
    subcommand          => 'help',
    executable          => '/root/command.pl',
    acls                => [ 'ANYUSER' ]
}

remctl::server::command { 'kadmin_examine':
    command             => 'kadmin',
    subcommand          => 'examine',
    executable          => '/root/command.pl',
    acls                => [
        "file:${remctl::server::acldir}/kadmin-examine",
        $_remctl_acl_its_idg,
        $_remctl_acl_security,
        "file:${remctl::server::acldir}/data-admin",
        "file:${remctl::server::acldir}/data-view",
        'princ:rferrand@IN2P3.FR',
    ]
}

remctl::server::command { 'kadmin_enable':
    command             => 'kadmin',
    subcommand          => 'enable',
    executable          => '/root/command.pl',
    acls                => [
        $_remctl_acl_kadmin_enable,
        'princ:rferrand@IN2P3.FR',
    ]
}

remctl::server::command { 'kadmin_disable':
    command             => 'kadmin',
    subcommand          => 'disable',
    executable          => '/root/command.pl',
    acls                => [
        $_remctl_acl_kadmin_enable,
        'princ:rferrand@IN2P3.FR',
    ]
}

remctl::server::command { 'kadmin_delete':
    command             => 'kadmin',
    subcommand          => 'delete',
    executable          => '/root/command.pl',
    acls                => [
        "file:${remctl::server::acldir}/kadmin-delete",
        'princ:rferrand@IN2P3.FR',
    ]
}

remctl::server::command { 'kadmin_create':
    command             => 'kadmin',
    subcommand          => 'create',
    executable          => '/root/command.pl',
    options             => {
        'logmask'   => '3'
    },
    acls                => [
        "file:${remctl::server::acldir}/kadmin-create",
        'princ:rferrand@IN2P3.FR',
    ]
}

remctl::server::command { 'kadmin_change_passwd':
    command             => 'kadmin',
    subcommand          => 'change_passwd',
    executable          => '/root/command.pl',
    options             => {
        'logmask'   => '3,4',
        'summary'   => '--summary'
    },
    acls                => ['ANYUSER']
}

remctl::server::command { 'kadmin_check_passwd':
    command             => 'kadmin',
    subcommand          => 'check_passwd',
    executable          => '/root/command.pl',
    options             => {
        'logmask'   => '3',
        'summary'   => '--summary',
        'help   '   => '--help'
    },
    acls                => [
        "file:${remctl::server::acldir}/kadmin-examine",
        $_remctl_acl_its_idg,
        'princ:rferrand@IN2P3.FR',
    ]
}

