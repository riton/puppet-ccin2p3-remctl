
class remctl (
    $package_ensure     = 'latest',
) inherits remctl::params {

    package { $package_name:
        ensure      => $package_ensure,
    }

}

# vim: tabstop=4 shiftwidth=4 softtabstop=4
