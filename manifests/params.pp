# == Class bamboo::params
#
# This class is meant to be called from bamboo.
# It sets variables according to platform.
#
class bamboo::params {
  case $::osfamily {
    'RedHat': {
      if $::operatingsystemmajrelease == '7' {
        $service_file_location   = '/usr/lib/systemd/system/bamboo.service'
        $service_file_template   = 'bamboo/bamboo.service.erb'
        $service_lockfile        = '/var/lock/subsys/bamboo'
      } elsif $::operatingsystemmajrelease == '6' {
        $service_file_location   = '/etc/init.d/bamboo'
        $service_file_template   = 'bamboo/bamboo.initscript.redhat.erb'
        $service_lockfile        = '/var/lock/subsys/bamboo'
      } else {
        fail("${::osfamily} ${::operatingsystemmajrelease} not supported")
      }
    } 'Debian': {
      if $::lsbmajdistrelease =~ /(7|12|14)/ {
        $service_file_location   = '/etc/init.d/bamboo'
        $service_file_template   = 'bamboo/bamboo.initscript.debian.erb'
        $service_lockfile        = '/var/lock/bamboo'
      } elsif $::operatingsystemmajrelease == '8' {
        $service_file_location   = '/usr/lib/systemd/system/bamboo.service'
        $service_file_template   = 'bamboo/bamboo.service.erb'
        $service_lockfile        = '/var/lock/subsys/bamboo'
      } else {
        fail("${::osfamily} ${::lsbmajdistrelease} not supported")
      }
    } default: {
      fail("${::osfamily} not supported")
    }
  }
  $service_name = 'bamboo'
}
