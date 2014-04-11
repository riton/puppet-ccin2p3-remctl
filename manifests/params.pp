class remctl::params {

    $debug                      = false
    $port                       = 4373
    $disable                    = true

    case $::osfamily {
        'RedHat': {
            $basedir            = '/etc/remctl'
            $confdir            = "${basedir}/conf.d"
            $conffile           = "${basedir}/remctl.conf"
            $acldir             = "${basedir}/acl"
            $package_name       = 'remctl'
            $krb5_keytab        = '/etc/krb5.keytab'
            $server_bin         = '/usr/sbin/remctld'
        }

	'Debian': {
            $basedir            = '/etc/remctl'
            $confdir            = "${basedir}/conf.d"
            $conffile           = "${basedir}/remctl.conf"
            $acldir             = "${basedir}/acl"
            $package_name       = 'remctl-server'
            $krb5_keytab        = '/etc/krb5.keytab'
            $server_bin         = '/usr/sbin/remctld'
	}

        default: {
            fail("remctl: module does not support osfamily ${::osfamily}")
        }
    }

}

# vim: tabstop=4 shiftwidth=4 softtabstop=4

