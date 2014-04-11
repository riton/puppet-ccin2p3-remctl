#### 2014-04-11 - Remi Ferrand <puppet@cc.in2p3.fr> - 1.1.0
##### New features
* subcommands array
* dedicated `remctl::client` class

##### Bugfixes
* This version allow usage of subcommands array (one command with multiple subcommands,
  each with specific options or ACL) which was previously impossible.
* `/etc/services` is left untouched if user specifies a non standard remctl port.

##### Known bugs
* Adding support for *subcommand arrays* requires us to add a mandatory `command`
parameter to `remctl::server::command` class. Users of prior versions must fix their manifest
or puppet will complain about a mandatory parameter that is missing.
* Usage of puppet `undef` value could make this module imcompatible with puppet 2.x.

##### TODO
* Write proper `rspec` test suite
