dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

require 'rubygems'
require 'rspec-puppet'
require 'puppetlabs_spec_helper/module_spec_helper'

@oses_specs = {

    'RedHat'            => {
        :operatingsystem            => 'RedHat',
        :osfamily                   => 'RedHat',

        :remctl_client_package      => 'remctl',
    },

    'Scientific Linux'  => {
        :operatingsystem            => 'Scientific',
        :osfamily                   => 'RedHat',

        :remctl_client_package      => 'remctl',
    },

    'Debian'            => {
        :operatingsystem            => 'Debian',
        :osfamily                   => 'Debian',

        :remctl_client_package      => 'remctl-client',
    },
}
