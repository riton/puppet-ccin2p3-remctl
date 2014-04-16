
class remctl::client (
    $package_ensure     = 'latest',
    $package_name       = $remctl::params::client_package_name
) inherits remctl::params {

    require stdlib

    validate_string($package_ensure)
    validate_string($package_name)

    if ! defined(Package[$package_name]) {
        package { $package_name:
            ensure      => $package_ensure,
        }
    }
}
