# vim: tabstop=4 shiftwidth=4 softtabstop=4
require 'spec_helper'

oses_specs = @oses_specs

describe 'remctl::server', :type => :class do

    let :xservice_name do
        'remctl'
    end

    let :augeas_name do
        'remctl_etc_services'
    end

    let :default_user do
        'root'
    end

    let :default_group do
        'root'
    end

    context 'running on unsupported osfamily' do

        let :facts do {
            :osfamily       => 'something-unsupported',
        } end

        it 'should fail' do
            expect {
                should compile
            }.to raise_error(Puppet::Error, /remctl: module does not support osfamily #{facts[:osfamily]}/)
        end

    end # context running on unsupported osfamily

    oses_specs.each do |osname, specs|

        describe "running on #{osname}" do

            let :package_name do
                specs[:remctl_server_package]
            end

            let :facts do {
                :osfamily               => specs[:osfamily],
                :operatingsystem        => specs[:operatingsystem]
            } end

            describe '#ensure' do

                context 'with default values' do
                    let :params do {
                    } end

                    it 'should have server package' do
                        should contain_package(package_name).with_ensure('present')
                    end

                    it 'should have xinetd service' do
                        should contain_xinetd__service(xservice_name).with_ensure('present')
                    end

                    it 'should have base remctl directory' do
                        should contain_file(specs[:basedir]).with({
                            'ensure'        => 'directory',
                            'mode'          => '0750',
                            'owner'         => default_user,
                            'group'         => default_group
                        }).that_comes_before("File[#{specs[:confdir]}]")
                    end

                    it 'should have remctl configuration directory' do
                        should contain_file(specs[:confdir]).with({
                            'ensure'        => 'directory',
                            'mode'          => '0750',
                            'owner'         => default_user,
                            'group'         => default_group
                        }).that_comes_before("File[#{specs[:acldir]}]")
                    end

                    it 'should have remctl ACLs directory' do
                        should contain_file(specs[:acldir]).with({
                            'ensure'        => 'directory',
                            'mode'          => '0750',
                            'owner'         => default_user,
                            'group'         => default_group
                        }).that_comes_before("File[#{specs[:conffile]}]")
                    end

                    it 'should have remctl configuration file' do
                        should contain_file(specs[:conffile]).with({
                            'ensure'        => 'file',
                            'mode'          => '0640',
                            'owner'         => default_user,
                            'group'         => default_group
                        }).that_comes_before("Augeas[#{augeas_name}]")
                    end

                end # context with default values

                context 'with bad value' do
                    let :params do {
                        :ensure     => false
                    } end

                    it 'should raise error' do
                        expect {
                            should compile
                        }.to raise_error(Puppet::Error, / is not a string/)
                    end

                end # context with bad value

                context 'with custom value' do
                    let :params do {
                        :ensure     => 'absent'
                    } end

                    it 'should have passed value' do
                        should contain_package(package_name).with_ensure('absent')
                    end

                    it 'should have xinetd service' do
                        should contain_xinetd__service(xservice_name).with_ensure('absent')
                    end

                end # context with custom value

                describe 'interaction with #manage_user' do

                    context 'with ensure absent' do
                        let :params do {
                            :ensure         => 'absent',
                            :manage_user    => true,
                            :user           => 'someuser'
                        } end
                        
                        it 'should have user absent' do
                            should contain_user('someuser').with_ensure('absent')
                        end
                    end

                    context 'with ensure present' do
                        let :params do {
                            :ensure         => 'present',
                            :manage_user    => true,
                            :user           => 'someuser'
                        } end
                        
                        it 'should have user present' do
                            should contain_user('someuser').with_ensure('present')
                        end
                    end
                end # describe 'interaction with #manage_user' do

                describe 'interaction with #manage_group' do

                    context 'with ensure absent' do
                        let :params do {
                            :ensure         => 'absent',
                            :manage_group   => true,
                            :group          => 'somegroup'
                        } end
                        
                        it 'should have group absent' do
                            should contain_group('somegroup').with_ensure('absent')
                        end
                    end

                    context 'with ensure present' do
                        let :params do {
                            :ensure         => 'present',
                            :manage_group   => true,
                            :group          => 'somegroup'
                        } end
                        
                        it 'should have group present' do
                            should contain_group('somegroup').with_ensure('present')
                        end
                    end
                end # describe 'interaction with #manage_group' do

            end # describe #ensure

            describe '#debug' do

                context 'with default values' do
                    let :params do {
                    } end

                    it 'should NOT have debug enabled' do
                        should_not contain_xinetd__service(xservice_name).with({
                            'server_args'       => /^-d\s+/
                        })
                    end

                end # context with default values

                context 'with bad value' do
                    let :params do {
                        :debug      => 'astring'
                    } end

                    it 'should raise error' do
                        expect {
                            should compile
                        }.to raise_error(Puppet::Error, / is not a boolean/)
                    end

                end # context with bad value

                context 'with custom value' do
                    let :params do {
                        :debug      => true
                    } end

                    it 'should have debug enabled' do
                        should contain_xinetd__service(xservice_name).with({
                            'server_args'       => /^-d\s+/
                        })
                    end
                end # context with custom value

            end # describe #debug

            describe '#disable' do

                context 'with default values' do
                    let :params do {
                    } end

                    it 'should have xinetd service disabled' do
                        should contain_xinetd__service(xservice_name).with({
                            'disable'       => 'yes' 
                        })
                    end

                end # context with default values

                context 'with bad value' do
                    let :params do {
                        :disable    => 'astring'
                    } end

                    it 'should raise error' do
                        expect {
                            should compile
                        }.to raise_error(Puppet::Error, / is not a boolean/)
                    end

                end # context with bad value

                context 'with custom value' do
                    let :params do {
                        :disable    => false
                    } end

                    it 'should have debug enabled' do
                        should contain_xinetd__service(xservice_name).with({
                            'disable'       => 'no'
                        })
                    end
                end # context with custom value

            end # describe #disable

            describe '#krb5_service' do

                context 'with default values' do
                    let :params do {
                    } end

                    it 'should NOT have -s option in server args' do
                        should_not contain_xinetd__service(xservice_name).with({
                            'server_args'       => /-s .+/
                        })
                    end

                end # context with default values

                context 'with bad value' do
                    let :params do {
                        :krb5_service   => false
                    } end

                    it 'should raise error' do
                        expect {
                            should compile
                        }.to raise_error(Puppet::Error, / is not a string/)
                    end

                end # context with bad value

                context 'with custom value' do
                    let :params do {
                        :krb5_service   => 'remctl'
                    } end

                    it 'should have passed value for -s option' do
                        should contain_xinetd__service(xservice_name).with({
                            'server_args'       => /-s remctl\s+/
                        })
                    end
                end # context with custom value

            end # describe #krb5_service

            describe '#krb5_keytab' do

                context 'with default values' do
                    let :params do {
                    } end

                    it 'should have proper xinetd server args' do
                        should contain_xinetd__service(xservice_name).with({
                            'server_args'       => /-k \/etc\/krb5\.keytab\s+/
                        })
                    end

                end # context with default values

                context 'with bad value' do
                    let :params do {
                        :krb5_keytab    => false
                    } end

                    it 'should raise error' do
                        expect {
                            should compile
                        }.to raise_error(Puppet::Error, / is not a string/)
                    end

                end # context with bad value

                context 'with custom value' do
                    let :params do {
                        :krb5_keytab    => '/path/remctl.keytab'
                    } end

                    it 'should have passed value' do
                        should contain_xinetd__service(xservice_name).with({
                            'server_args'       => /-k \/path\/remctl\.keytab\s+/
                        })
                    end
                end # context with custom value

            end # describe #krb5_keytab

            describe '#port' do

                context 'with default values' do
                    let :params do {
                    } end

                    it 'should have default port' do
                        should contain_xinetd__service(xservice_name).with({
                            'port'      =>  specs[:port]
                        })
                    end

                    it 'should have remctl augeas resource' do
                        should contain_augeas(augeas_name).with({
                            'context'   => '/files/etc/services',
                            'changes'   => [
                                'defnode remctltcp service-name[.="remctl"][protocol = "tcp"] remctl',
                                "set \$remctltcp/port #{specs[:port]}",
                                'set $remctltcp/protocol tcp',
                                'set $remctltcp/#comment "remote authenticated command execution"',
                            ]
                        })
                    end

                    it 'should have NULL xinetd service type' do
                        should contain_xinetd__service(xservice_name).with({
                            'service_type'  => nil
                        })
                    end

                end # context with default values

                context 'with bad value' do
                    let :params do {
                        :port       => 'NaN'
                    } end

                    it 'should raise error' do
                        expect {
                            should compile
                        }.to raise_error(Puppet::Error, /"NaN" does not match/)
                    end

                end # context with bad value

                context 'with custom value' do
                    let :params do {
                        :port       => 12345
                    } end

                    it 'should have passed port' do
                        should contain_xinetd__service(xservice_name).with({
                            'port'      => 12345
                        })
                    end

                    it 'should have remctl augeas resource with official port' do
                        should contain_augeas(augeas_name).with({
                            'context'   => '/files/etc/services',
                            'changes'   => [
                                'defnode remctltcp service-name[.="remctl"][protocol = "tcp"] remctl',
                                "set \$remctltcp/port #{specs[:port]}",
                                'set $remctltcp/protocol tcp',
                                'set $remctltcp/#comment "remote authenticated command execution"',
                            ]
                        })
                    end

                    it 'should have UNLISTED xinetd service type' do
                        should contain_xinetd__service(xservice_name).with({
                            'service_type'  => 'UNLISTED'
                        })
                    end

                end # context with custom value

            end # describe #port

            describe '#user / #manage_user' do

                context 'with default values' do
                    let :params do {
                    } end

                    it 'should NOT have user' do
                        should_not contain_user(default_user)
                    end

                end # context with default values

                context 'with bad user value' do
                    let :params do {
                        :user   => false,
                    } end

                    it 'should raise error' do
                        expect {
                            should compile
                        }.to raise_error(Puppet::Error, / is not a string/)
                    end

                end # context with bad user value

                context 'with bad manage_user value' do
                    let :params do {
                        :manage_user    => 'astring'
                    } end

                    it 'should raise error' do
                        expect {
                            should compile
                        }.to raise_error(Puppet::Error, / is not a boolean/)
                    end

                end # context with manage_user value

                context 'with custom value' do
                    let :params do {
                        :manage_user    => true,
                        :user           => 'username'
                    } end

                    it 'should have user' do
                        should contain_user('username')
                    end

                    it 'should not work when user is root'

                end # context with custom value

            end # describe #user / #group

        end # describe running on

        break

    end # oses_facts.each

end
