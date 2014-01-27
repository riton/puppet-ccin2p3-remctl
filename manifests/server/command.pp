define remctl::server::command (
    $subcommand,
    $executable,
    $options            = {},
    $acls               = []
) {
    # validate_re($name, "[^\.]") # This do not work as expected
    validate_string($subcommand)
    validate_string($executable)
    validate_hash($options)

    $cmdfile = "${remctl::server::confdir}/${name}"

    file { $cmdfile:
        ensure      => file,
        mode        => '0440',
        owner       => $remctl::server::user,
        group       => $remctl::server::group,
        content     => template("remctl/server/command.erb")
    }
}
