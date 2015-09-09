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

          it do should contain_file('/home/bamboo/logs')
            .with_ensure('directory')
            .with_owner('bamboo')
            .with_owner('bamboo')
          end

          it do should contain_file('/opt/bamboo/atlassian-bamboo-5.7.2/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties')
            .with_ensure('file')
            .with_owner('bamboo')
            .with_owner('bamboo')
            .with_mode('0755')
            .with_content(/bamboo\.home=\/home\/bamboo/)
          end

          it do should contain_file('/opt/bamboo/atlassian-bamboo-5.7.2/bin/setenv.sh')
            .with_ensure('file')
            .with_owner('bamboo')
            .with_owner('bamboo')
            .with_content(/JAVA_HOME=\/opt\/java/)
            .with_content(/BAMBOO_HOME="\/home\/bamboo"/)
            .with_content(/JVM_SUPPORT_RECOMMENDED_ARGS="-XX:-HeapDumpOnOutOfMemoryError"/)
            .with_content(/JVM_MINIMUM_MEMORY="256m"/)
            .with_content(/JVM_MAXIMUM_MEMORY="1024m"/)
            .with_content(/BAMBOO_MAX_PERM_SIZE=256m/)
          end

          #TODO: Augeas stuff
          it do should contain_file('/opt/bamboo/atlassian-bamboo-5.7.2/conf/server.xml')
            .with_mode('0600')
            .with_owner('bamboo')
            .with_owner('bamboo')
            .with_content(/<Connector port="8085"/)
            .with_content(/maxThreads="150"/)
            .with_content(/acceptCount="100"/)
            .without_content(/proxyName=/)
            .without_content(/proxyPort=/)
            .without_content(/scheme=/)
          end
        end
      end
    end
  end
end
