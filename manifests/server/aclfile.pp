define remctl::server::aclfile (
    $acldir         = $remctl::server::acldir,
    $acls           = []
) {

    if ! defined(Class['remctl::server']) {
        fail('You must include the remctl::server class before using any remctl::server::acl resources')
    }

    validate_array($acls)

    if $acls and size($acls) > 0 {
        file { "${acldir}/${name}":
            ensure      => file,
            owner       => $remctl::server::user,
            group       => $remctl::server::group,
            mode        => '0440',
            content     => template('remctl/server/aclfile.erb')
        }
    }

}
