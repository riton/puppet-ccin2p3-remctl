
class remctl::server (
    $ensure             = 'present',
    $debug              = $remctl::params::debug,
    $disable            = $remctl::params::disable,
    $krb5_service       = 'undef',
    $krb5_keytab        = $remctl::params::krb5_keytab,
    $port               = $remctl::params::port,
    $user               = 'root',
    $group              = 'root',
    $manage_user        = false,
    $manage_group       = false,
    $only_from          = [ '0.0.0.0' ],

    $package_name       = $remctl::params::server_package_name
) inherits remctl::params {

    require stdlib

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
    validate_string($package_name)

    #
    # Computed values
    #
    $_directories_ensure = $ensure ? { 'present' => 'directory', 'absent' => 'absent' }
    $_files_ensure = $ensure ? { 'present' => 'file', 'absent' => 'absent' }

    if ($port == $remctl::params::port) {
        $_xinetd_service_type = undef
    }
    else {
        $_xinetd_service_type = 'UNLISTED'
    }

    if $debug {
        $_debug = "-d "
    }
    else {
        $_debug = ""
    }

    if $krb5_service != 'undef' {
        $_krb5_service = "-s ${krb5_service} "
    }
    else {
        $_krb5_service = ""
    }

    if $conffile {
        $_conffile = "-f ${conffile} "
    }
    else {
        $_conffile = ""
    }

    if $krb5_keytab {
        $_krb5_keytab = "-k ${krb5_keytab} "
    }
    else {
        $_krb5_keytab = ""
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
        if $group != "root" and $group != 0 {
            group { $group:
                ensure      => $ensure,
                notify      => User[$user]
            }
        }
    }

    if $manage_user {
        if $user != "root" and $user != 0 {
            user { $user:
                ensure      => $ensure,
                comment     => 'remctl user',
                gid         => $group,
                notify      => Package[$package_name]
            }
        }
    }

    package { $package_name:
        ensure      => $ensure,
    }

    ->

    file { $basedir:
        ensure      => $_directories_ensure,
        mode        => '0750',
        owner       => $user,
        group       => $group
    }

    ->

    file { $confdir:
        ensure      => $_directories_ensure,
        mode        => '0750',
        owner       => $user,
        group       => $group
    }

    ->

    file { $acldir:
        ensure      => $_directories_ensure,
        mode        => '0750',
        owner       => $user,
        group       => $group
    }

    ->

    file { $conffile:
        ensure      => $_files_ensure,
        content     => template("remctl/remctl.conf"),
        mode        => '0640',
        owner       => $user,
        group       => $group,
    }

    ->

    # Note(remi):
    # As suggested by Russ A.:
    # - Only update /etc/services if official remctl port was used.
    # - Do not register UDP service anymore as it's very unlikely that
    #   UDP will be used someday.
    augeas { 'remctl_etc_services':
        context     => '/files/etc/services',
        changes     => [
            'defnode remctltcp service-name[.="remctl"][protocol = "tcp"] remctl',
            "set \$remctltcp/port $remctl::params::port",
            'set $remctltcp/protocol tcp',
            'set $remctltcp/#comment "remote authenticated command execution"',
        ],
    }

    ->

    xinetd::service { 'remctl':
        ensure          => $ensure,
        port            => $port, # Dupplicate with /etc/services info but xinetd::service requires it
        service_type    => $_xinetd_service_type,
        server          => $server_bin,
        server_args     => "${_debug}${_krb5_keytab}${_krb5_service}${_conffile}",
        disable         => $_disable,
        protocol        => 'tcp',
        socket_type     => 'stream',
        user            => $user,
        group           => $group,
        only_from       => $_only_from
    }
}

# vim: tabstop=4 shiftwidth=4 softtabstop=4
