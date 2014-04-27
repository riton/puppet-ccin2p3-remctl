# vim: tabstop=4 shiftwidth=4 softtabstop=4
require 'spec_helper'

oses_specs = @oses_specs

describe 'remctl::client', :type => :class do

    oses_specs.each do |osname, specs|

        describe "running on #{osname}" do

            let :package_name do
                specs[:remctl_client_package]
            end

            let :facts do {
                :osfamily               => specs[:osfamily],
                :operatingsystem        => specs[:operatingsystem]
            } end

            describe '#ensure' do

                context 'with default values' do
                    let :params do {
                    } end

                    it 'should have client package' do
                        should contain_package(package_name).with({
                            'ensure'    => 'present'
                        })
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
                end # context with custom value

            end # describe #ensure

            describe '#package_name' do

                context 'with default values' do
                    let :params do {
                    } end

                    it 'should have client package' do
                        should contain_package(package_name)
                    end

                end # context with default values

                context 'with bad value' do
                    let :params do {
                        :package_name   => false
                    } end

                    it 'should raise error' do
                        expect {
                            should compile
                        }.to raise_error(Puppet::Error, / is not a string/)
                    end
                end # context with bad value

                context 'with custom value' do
                    let :params do {
                        :package_name   => 'somepackage'
                    } end

                    it 'should have passed value' do
                        should contain_package('somepackage').with_ensure('present')
                    end
                end # context with custom value

            end # describe #package_name

        end # describe running on

    end # oses_facts.each

end
