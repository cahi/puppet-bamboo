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

        #TODO: Add more custom param tests
        describe 'With custom parameters' do
          context 'With custom user parameters' do
            let(:params) {{
              :javahome => '/opt/java',
              :shell    => '/bin/bash',
              :homedir  => '/my/home',
            }}
      
            context 'resources in bamboo::install class' do
              it do should contain_user('bamboo')
                .with_shell('/bin/bash')
                .with_home('/my/home')
              end
              it { should contain_file('/my/home') }
            end

            context 'resources in bamboo::config class class' do
              it { should contain_file('/my/home/logs') }
            end

          end
        end
      end
    end
  end
end
