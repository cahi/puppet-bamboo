# == Class bamboo::params
#
# This class is meant to be called from bamboo.
# It sets variables according to platform.
#
class bamboo::params {
  case $::kernel {
    'Linux': {
      $service_name = 'bamboo'
    }
    default: {
      fail("${::kernel} not supported")
    }
  }
}
