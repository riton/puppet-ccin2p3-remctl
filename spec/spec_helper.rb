dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(dir, 'lib')

# Use latest version of rspec-puppet
$LOAD_PATH.unshift File.join(dir, 'fixtures/modules/rspec-puppet/lib')

require 'rubygems'
require 'rspec-puppet'
require 'puppetlabs_spec_helper/module_spec_helper'

begin
    require 'simplecov'

    SimpleCov.start do
        add_filter 'fixtures/modules/'
    end
rescue Exception => e
    warn 'Code coverage has been disabled'
end

# RSpec.configure do |c|
#     c.filter_run :focus => true
# end

@common_specs = {
    :basedir                    => '/etc/remctl',
    :confdir                    => '/etc/remctl/conf.d',
    :conffile                   => '/etc/remctl/remctl.conf',
    :acldir                     => '/etc/remctl/acl',

    :krb5_keytab                => '/etc/krb5.keytab',
    :server_bin                 => '/usr/sbin/remctld',

    :debug                      => false,
    :port                       => 4373,
    :disable                    => true
}

@oses_specs = {

    'RedHat'            => @common_specs.merge({
        :operatingsystem            => 'RedHat',
        :osfamily                   => 'RedHat',

        :remctl_client_package      => 'remctl',
        :remctl_server_package      => 'remctl',
    }),

    'Debian'            => @common_specs.merge({
        :operatingsystem            => 'Debian',
        :osfamily                   => 'Debian',

        :remctl_client_package      => 'remctl-client',
        :remctl_server_package      => 'remctl-server',
    }),
}
