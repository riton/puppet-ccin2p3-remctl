define remctl::server::command (
    $subcommand,
    $executable,
    $options            = {},
    $acls               = []
) {

    if ! defined(Class['remctl::server']) {
        fail('You must include the remctl::server class before using any remctl::server::command resources')
    }

    # validate_re($name, "[^\.]") # This do not work as expected
    validate_string($subcommand)
    validate_string($executable)
    validate_hash($options)
    validate_array($acls)

    $cmdfile = "${remctl::server::confdir}/${name}"

    file { $cmdfile:
        ensure      => file,
        mode        => '0440',
        owner       => $remctl::server::user,
        group       => $remctl::server::group,
        content     => template("remctl/server/command.erb")
    }
}
