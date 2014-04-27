# vim: tabstop=4 shiftwidth=4 softtabstop=4
require 'spec_helper'

oses_specs = @oses_specs

describe 'remctl::server::command', :type => :define do

    let :title do
        'rspec-command'
    end

    let :confdir do
        '/etc/remctl/conf.d'
    end

    let :default_user do
        'root'
    end

    let :default_group do
        'root'
    end

    let :default_file_mode do
        '0440'
    end

    let :cmdfile do
        "#{confdir}/#{title}"
    end

    context 'without remctl::server' do

        let :params do {
            :command    => 'true',
            :subcommand => 'truetrue',
            :executable => '/bin/true',
            :acls       => ['dummy']
        } end

        it 'should fail' do
            expect {
                should compile
            }.to raise_error(/You must include the remctl::server class before/)
        end
    end # context 'without remctl::server'

    oses_specs.each do |osname, specs|

        describe "running on #{osname}" do

            let :pre_condition do
                'class { "remctl::server": }'
            end

            let :facts do {
                :osfamily               => specs[:osfamily],
                :operatingsystem        => specs[:operatingsystem]
            } end

            describe '#command / #subcommand / #executable / #options / #acls' do
                context 'with bad executable' do
                    let :params do {
                        :command        => 'somecmd',
                        :subcommand     => 'subcmd',
                        :acls           => ['dummy'],
                        :executable     => './bin/true',
                    } end

                    it 'should raise error' do
                        expect {
                            should compile
                        }.to raise_error(/ is not an absolute path/)
                    end
                end # context 'with bad executable'

                context 'with empty acls' do
                    let :params do {
                        :command        => 'somecmd',
                        :subcommand     => 'subcmd',
                        :executable     => '/bin/true',
                        :acls           => []
                    } end

                    it 'should raise error' do
                        expect {
                            should compile
                        }.to raise_error(/Missing acls for commmand 'somecmd\/subcmd'/)
                    end
                end # context 'with empty acls'

                context 'with default options' do
                    let :params do {
                        :command        => 'kadmin',
                        :subcommand     => 'change_pw',
                        :executable     => '/usr/kerberos/sbin/kadmin',
                        :acls           => ['princ:goodguy@IN2P3.FR', 'unixgroup:goodguys']
                    } end

                    it 'should have command file' do
                        should contain_file(cmdfile).with({
                            :ensure     => 'file',
                            :mode       => default_file_mode,
                            :owner      => default_user,
                            :group      => default_group,
                            :content    => %r'^kadmin\s+change_pw\s+\\\n/usr/kerberos/sbin/kadmin\s+\\\n^princ:goodguy@IN2P3.FR\s+unixgroup:goodguys$'m
                        })
                    end
                end # context 'with default options'


                context 'with custom options' do
                    let :params do {
                        :command        => 'kadmin',
                        :subcommand     => 'change_pw',
                        :executable     => '/usr/kerberos/sbin/kadmin',
                        :acls           => ['unixgroup:goodguys'],
                        :options        => {
                            'help'  => '-h',
                            'user'  => 'nobody'
                        }
                    } end

                    it 'should have correct options' do
                        should contain_file(cmdfile).with({
                            :ensure     => 'file',
                            :mode       => default_file_mode,
                            :owner      => default_user,
                            :group      => default_group,
                            :content    => %r'^/usr/kerberos/sbin/kadmin\s+\\\n(user=nobody|help=-h)\s+\\\n(help=-h|user=nobody)\s+\\\n^unixgroup:goodguys$'m
                        })
                    end
                end # context 'with custom options'

            end # describe '#command / #subcommand / #executable'
           
            describe '#ensure' do

                context 'with bad value' do
                    let :params do {
                        :ensure         => false,
                        :command        => 'kadmin',
                        :subcommand     => 'change_pw',
                        :executable     => '/usr/kerberos/sbin/kadmin',
                        :acls           => ['princ:goodguy@IN2P3.FR', 'unixgroup:goodguys']
                    } end

                    it 'should raise error' do
                        expect {
                            should compile
                        }.to raise_error(/\s+false does not match\s+/)
                    end

                end # context with bad value

                context 'with ensure present' do
                    let :params do {
                        :ensure         => 'present',
                        :command        => 'kadmin',
                        :subcommand     => 'change_pw',
                        :executable     => '/usr/kerberos/sbin/kadmin',
                        :acls           => ['princ:goodguy@IN2P3.FR', 'unixgroup:goodguys']
                    } end

                    it 'should have acl file present' do
                        should contain_file(cmdfile).with_ensure('file')
                    end

                end # context with ensure present

                context 'with ensure absent' do
                    let :params do {
                        :ensure         => 'absent',
                        :command        => 'kadmin',
                        :subcommand     => 'change_pw',
                        :executable     => '/usr/kerberos/sbin/kadmin',
                        :acls           => ['princ:goodguy@IN2P3.FR', 'unixgroup:goodguys']
                    } end

                    it 'should have acl file absent' do
                        should contain_file(cmdfile).with_ensure('absent')
                    end

                end # context with ensure absent

            end # describe #ensure

        end # describe running on

    end # oses_facts.each

end
