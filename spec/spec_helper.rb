dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

require 'rubygems'
require 'rspec-puppet'
require 'puppetlabs_spec_helper/module_spec_helper'

@oses_facts = {

    'RedHat'            => {
        :operatingsystem            => 'RedHat',
        :osfamily                   => 'RedHat',
    },

    'Scientific Linux'  => {
        :operatingsystem            => 'Scientific',
        :osfamily                   => 'RedHat',
    },

    'Debian'            => {
        :operatingsystem            => 'Debian',
        :osfamily                   => 'Debian',
    },
}
