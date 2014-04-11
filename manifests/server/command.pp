define remctl::server::command (
    $command,
    $subcommand,
    $executable,
    $options            = {},
    $acls               = []
) {

    if ! defined(Class['remctl::server']) {
        fail('You must include the remctl::server class before using any remctl::server::command resources')
    }

    validate_string($command)
    validate_string($subcommand)
    validate_absolute_path($executable)
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

# vim: tabstop=4 shiftwidth=4 softtabstop=4
