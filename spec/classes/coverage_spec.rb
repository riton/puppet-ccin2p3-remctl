
# Note(remi):
# Uggly explicit filter list...
# if someone knows how to handle this properly
# please, do so !
['Class[Stdlib::Stages]', 'Class[Xinetd::Params]',
 'Class[Stdlib]', 'Class[Remctl::Params]',
 'File[/etc/xinetd.conf]', 'File[/etc/xinetd.d/remctl]',
 'File[/etc/xinetd.d]', 'Service[xinetd]',
 'Package[xinetd]', 'Stage[deploy]', 'Stage[deploy_app]',
 'Stage[deploy_infra]', 'Stage[runtime]', 'Stage[setup]',
 'Stage[setup_app]', 'Stage[setup_infra]',
 'Remctl::Server::Aclfile[rspec-aclfile]',
 'Remctl::Server::Command[rspec-command]'].each do |f|
    RSpec::Puppet::Coverage.filters << f
end

at_exit { RSpec::Puppet::Coverage.report! }
