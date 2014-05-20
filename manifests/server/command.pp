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

    $cmdfile = "${remctl::server::confdir}/${command}"
    $_files_ensure = $ensure ? { 'present' => 'file', 'absent' => 'absent' }

    if (!$acls or size($acls) == 0) {
        fail("Missing acls for commmand '${command}/${subcommand}'")
    }

    if ! defined(Concat[$cmdfile]) {
        concat { $cmdfile:
            ensure  => present,
            mode    => '0440',
            force   => false,
            owner   => $remctl::server::user,
            group   => $remctl::server::group
        }

        concat::fragment { "${command}_puppet_header":
            ensure          => $ensure,
            target          => $cmdfile,
            order           => '01',
            content         => "# This file is being maintained by Puppet.\n# DO NOT EDIT\n"
        }
    }

    concat::fragment { "${command}_${subcommand}":
        ensure          => $ensure,
        target          => $cmdfile,
        order           => '02',
        content         => template('remctl/server/command.erb'),
    }
}

# vim: tabstop=4 shiftwidth=4 softtabstop=4
