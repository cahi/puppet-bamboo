require 'spec_helper'
require 'pp'

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

        # no support for shared examples :/
        context "bamboo::service class without any parameters" do
          case facts[:osfamily]
          when 'RedHat'
            if facts[:operatingsystemmajrelease] == '7'
              it do should contain_file('/usr/lib/systemd/system/bamboo.service')
                .with_content(/Environment=JAVA_HOME="\/opt\/java"/)
                .with_content(/User=bamboo/)
                .with_content(/ExecStart=\/opt\/bamboo\/atlassian-bamboo-5\.7\.2\/bin\/startup\.sh/)
                .with_content(/ExecStop=\/opt\/bamboo\/atlassian-bamboo-5\.7\.2\/bin\/shutdown\.sh/)
              end
            elsif facts[:operatingsystemmajrelease] == '7'
              it do should contain_file('/etc/init.d/bamboo')
                .with_content(/USER=bamboo/)
                .with_content(/BASE=\/opt\/bamboo\/atlassian-bamboo-5\.7\.2/)
                .with_content(/JAVA_HOME=\/opt\/java/)
                .with_content(/Dcatalina\.base=\/opt\/bamboo\/atlassian-bamboo-5\.7\.2/)
              end
            end
          when 'Debian'
            if facts[:lsbmajdistrelease] =~ /(7|12|14)/
              it do should contain_file('/etc/init.d/bamboo')
                .with_content(/USER=bamboo/)
                .with_content(/BASE=\/opt\/bamboo\/atlassian-bamboo-5\.7\.2/)
                .with_content(/JAVA_HOME=\/opt\/java/)
                .with_content(/Dcatalina\.base=\/opt\/bamboo\/atlassian-bamboo-5\.7\.2/)
              end
            elsif facts[:operatingsystemmajrelease] == '8'
              it do should contain_file('/usr/lib/systemd/system/bamboo.service')
                .with_content(/Environment=JAVA_HOME="\/opt\/java"/)
                .with_content(/User=bamboo/)
                .with_content(/ExecStart=\/opt\/bamboo\/atlassian-bamboo-5\.7\.2\/bin\/startup\.sh/)
                .with_content(/ExecStop=\/opt\/bamboo\/atlassian-bamboo-5\.7\.2\/bin\/shutdown\.sh/)
              end
            end
          end
        end

        context "RedHat with unsupported operatingsystemmajrelease" do
          let(:facts) {{
            :osfamily => 'RedHat',
            :operatingsystemmajrelease => '100'
          }}

          it { expect { is_expected.to contain_class('bamboo') }.to \
            raise_error(Puppet::Error, /RedHat 100 not supported/)
          }

        end

        context "Debian with unsupported operatingsystemmajrelease" do
          let(:facts) {{
            :osfamily => 'Debian',
            :lsbmajdistrelease => '100'
          }}

          it { expect { is_expected.to contain_class('bamboo') }.to \
            raise_error(Puppet::Error, /Debian 100 not supported/)
          }

        end

        if facts[:osfamily] == 'RedHat' and facts[:operatingsystemmajrelease] == '7'
          it do should contain_exec('refresh_systemd')
            .with_command('systemctl daemon-reload')
            .with_refreshonly(true)
            .that_subscribes_to('File[/usr/lib/systemd/system/bamboo.service]')
            .that_comes_before('Service[bamboo]')
          end
        end

        it do should contain_service('bamboo')
          .with_ensure('running')
          .with_enable(true)
        end
      end
    end
  end
end
