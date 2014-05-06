define remctl::server::command (
    $command,
    $subcommand,
    $executable,
    $acls,
    $options            = {},
    $ensure             = 'present'
) {

    if ! defined(Class['remctl::server']) {
        fail('You must include the remctl::server class before using any remctl::server::command resources')
    }

    validate_string($command)
    validate_string($subcommand)
    validate_absolute_path($executable)
    validate_hash($options)
    validate_array($acls)
    validate_re($ensure, '^(present|absent)$')

    $cmdfile = "${remctl::server::confdir}/${name}"
    $_files_ensure = $ensure ? { 'present' => 'file', 'absent' => 'absent' }

    if (!$acls or size($acls) == 0) {
        fail("Missing acls for commmand '${command}/${subcommand}'")
    }

    file { $cmdfile:
        ensure      => $_files_ensure,
        mode        => '0440',
        owner       => $remctl::server::user,
        group       => $remctl::server::group,
        content     => template("remctl/server/command.erb")
    }
}

# vim: tabstop=4 shiftwidth=4 softtabstop=4
