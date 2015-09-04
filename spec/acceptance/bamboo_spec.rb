require 'spec_helper_acceptance'

download_url = ENV['download_url'] if ENV['download_url']
if ENV['download_url'] then
  download_url = ENV['download_url']
else
  download_url = 'undef'
end
if download_url == 'undef' then
  java_url = "'http://download.oracle.com/otn-pub/java/jdk/8u45-b14/'"
else
  java_url = download_url
end

describe 'bamboo class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      $jh = $osfamily ? {
        default   => '/opt/java',
      }
      if versioncmp($::puppetversion,'3.6.1') >= 0 {
        $allow_virtual_packages = hiera('allow_virtual_packages',false)
        Package {
          allow_virtual => $allow_virtual_packages,
        }
      }
      deploy::file { 'jdk-8u45-linux-x64.tar.gz':
        target          => '/opt/java',
        fetch_options   => '-q -c --header "Cookie: oraclelicense=accept-securebackup-cookie"',
        url             => #{java_url},
        download_timout => 1800,
        strip           => true,
      } ->
      class { 'bamboo':
        downloadURL       => #{download_url},
        javahome          => $jh,
        manage_server_xml => 'template',
      } 
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      sleep 180 
      shell 'wget -q --tries=20 --retry-connrefused --read-timeout=10 localhost:8085'
      shell 'wget -q --tries=2 --retry-connrefused --read-timeout=2 localhost:8085', :acceptable_exit_codes => [0]
      apply_manifest(pp, :catch_changes  => true)
    end
    
    describe process("java") do
      it { should be_running }
    end

    describe port(8085) do
      it { is_expected.to be_listening }
    end
  
    describe service('bamboo') do
      it { should be_enabled }
    end
  
    describe user('bamboo') do
      it { should exist }
      it { should belong_to_group 'bamboo' }
      it { should have_login_shell '/bin/true' }
    end
  
    describe command('curl -L http://localhost:8085') do
      its(:stdout) { should match /Bamboo evaluation license/ }
    end
   
  end
end
