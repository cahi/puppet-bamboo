require 'spec_helper'

describe 'bamboo' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end
        let(:params) {{
          :javahome => '/opt/java',
        }}


        context "bamboo class without any parameters" do

          it do should contain_user('bamboo')
            .with_shell('/bin/true')
            .with_home('/home/bamboo')
          end

          it do should contain_file('/opt/bamboo')
            .with_ensure('directory')
            .with_owner('bamboo')
            .with_owner('bamboo')
            .that_comes_before('File[/opt/bamboo/atlassian-bamboo-5.7.2]')
          end

          it do should contain_file('/opt/bamboo/atlassian-bamboo-5.7.2')
            .with_ensure('directory')
            .with_owner('bamboo')
            .with_owner('bamboo')
          end

          it do should contain_staging__file('atlassian-bamboo-5.7.2.tar.gz')
            .with_source('http://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-5.7.2.tar.gz')
            .with_timeout('1800')
          end

          it do should contain_staging__extract('atlassian-bamboo-5.7.2.tar.gz')
            .with_target('/opt/bamboo/atlassian-bamboo-5.7.2')
            .with_creates('/opt/bamboo/atlassian-bamboo-5.7.2/conf')
            .with_user('bamboo')
            .with_group('bamboo')
            .that_notifies('Exec[chown_/opt/bamboo/atlassian-bamboo-5.7.2]')
            .that_comes_before('File[/home/bamboo]')
            .that_requires('File[/opt/bamboo]')
            .that_requires('User[bamboo]')
            .that_requires('File[/opt/bamboo/atlassian-bamboo-5.7.2]')
          end

          it do should contain_file('/home/bamboo')
            .with_ensure('directory')
            .with_owner('bamboo')
            .with_owner('bamboo')
            .that_requires('User[bamboo]')
          end

          it do should contain_exec('chown_/opt/bamboo/atlassian-bamboo-5.7.2')
            .with_command('/bin/chown -R bamboo:bamboo /opt/bamboo/atlassian-bamboo-5.7.2')
            .with_refreshonly(true)
            .that_subscribes_to('User[bamboo]')
          end

          it do should contain_file('/opt/bamboo/latest')
            .with_ensure('link')
            .with_target('/opt/bamboo/atlassian-bamboo-5.7.2')
          end

        end

      end
    end
  end
end
