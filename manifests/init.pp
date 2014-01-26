class remctl (
    $package_name       = $remctl::params::package_name,
    $package_ensure     = 'latest',
) inherits remctl::params {

    package { $package_name:
        ensure      => $package_ensure,
    }

}
