class remctl::params {

    $debug                      = false
    $krb5_service               = 'remctl'
    $port                       = 4373
    $disable                    = true

    case $::osfamily {
        'RedHat': {
            $confdir            = '/etc/remctl.d'
            $conffile           = '/etc/remctl.conf'
            $package_name       = 'remctl'
            $krb5_keytab        = '/etc/krb5.keytab'
            $server_bin         = '/usr/sbin/remctld'
        }

        default: {
            fail("remctl: module does not support osfamily ${::osfamily}")
        }
    }

}
