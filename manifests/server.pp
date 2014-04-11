
class remctl::server (
    $ensure             = 'present',
    $debug              = $remctl::params::debug,
    $disable            = $remctl::params::disable,
    $krb5_service       = undef,
    $krb5_keytab        = $remctl::params::krb5_keytab,
    $port               = $remctl::params::port,
    $user               = 'root',
    $group              = 'root',
    $manage_user        = false,
    $manage_group       = false,
    $only_from          = [ '0.0.0.0' ]
) inherits remctl::params {

    require stdlib

    if ! defined(Class['Remctl']) {
        fail('You must include the remctl class before using any remctl::server resources')
    }

    if ! defined(Class['Xinetd']) {
        include xinetd
    }

    validate_string($ensure)
    validate_string($user)
    validate_string($group)
    validate_bool($debug)
    validate_bool($disable)
    validate_bool($manage_user)
    validate_bool($manage_group)
    validate_string($krb5_service)
    validate_string($krb5_keytab)
    validate_re($port, '^\d+$')
    validate_array($only_from)

    if $debug {
        $_debug = "-d "
    }
    else {
        $_debug = ""
    }

    if $krb5_service {
        $_krb5_service = "-s ${krb5_service} "
    }
    else {
        $_krb5_service = ""
    }

    if $conffile {
        $_conffile = "-f ${conffile}"
    }
    else {
        $_conffile = ""
    }

    if $only_from {
        $_only_from = join($only_from, " ")
    }
    else {
        $_only_from = undef
    }

    if $disable {
        $_disable = "yes"
    }
    else {
        $_disable = "no"
    }

    if $manage_group {
        if $group != "root" {
            group { $group:
                ensure      => present,
                notify      => User[$user]
            }
        }
    }

    if $manage_user {
        if $user != "root" {
            user { $user:
                ensure      => present,
                comment     => 'remctl user',
                gid         => $group,
                notify      => Package[$package_name]
            }
        }
    }

    file { $basedir:
        ensure      => directory,
        mode        => '0750',
        owner       => $user,
        group       => $group
    }

    ->

    file { $confdir:
        ensure      => directory,
        mode        => '0750',
        owner       => $user,
        group       => $group
    }

    ->

    file { $acldir:
        ensure      => directory,
        mode        => '0750',
        owner       => $user,
        group       => $group
    }

    ->

    file { $conffile:
        ensure      => file,
        content     => template("remctl/remctl.conf"),
        mode        => '0640',
        owner       => $user,
        group       => $group,
    }

    ->

    augeas { 'remctl_etc_services':
        context     => '/files/etc/services',
        changes     => [
            'defnode remctltcp service-name[.="remctl"][protocol = "tcp"] remctl',
            "set \$remctltcp/port $port",
            'set $remctltcp/protocol tcp',
            'set $remctltcp/#comment "remote authenticated command execution"',

            'defnode remctludp service-name[.="remctl"][protocol = "udp"] remctl',
            "set \$remctludp/port $port",
            'set $remctludp/protocol udp',
            'set $remctludp/#comment "remote authenticated command execution"'
        ]
    }

    ->

    xinetd::service { 'remctl':
        ensure      => $ensure,
        port        => $port, # Dupplicate with /etc/services info but xinetd::service requires it
        server      => $server_bin,
        server_args => "${_debug}${_krb5_service}${_conffile}",
        disable     => $_disable,
        protocol    => 'tcp',
        socket_type => 'stream',
        user        => $user,
        group       => $group,
        only_from   => $_only_from
    }
}

# vim: tabstop=4 shiftwidth=4 softtabstop=4
