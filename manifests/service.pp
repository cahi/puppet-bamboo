# == Class bamboo::service
#
class bamboo::service(
  $service_name = $bamboo::service_name,
  $service_manage = $bamboo::service_manage,
  $service_ensure = $bamboo::service_ensure,
  $service_enable = $bamboo::service_enable,
  $service_file_location = $bamboo::params::service_file_location,
  $service_file_template = $bamboo::params::service_file_template,
  $service_lockfile = $bamboo::params::service_lockfile,
) {

  validate_bool($service_manage)

  file { $service_file_location:
    content => template($service_file_template),
    mode    => '0755',
  }

  if $bamboo::service_manage {

    validate_string($service_ensure)
    validate_bool($service_enable)

    if $::osfamily == 'RedHat' and $::operatingsystemmajrelease == '7' {
      exec { 'refresh_systemd':
        command     => 'systemctl daemon-reload',
        refreshonly => true,
        subscribe   => File[$service_file_location],
        before      => Service['bamboo'],
      }
    }

    service { $service_name:
      ensure     => $service_ensure,
      enable     => $service_enable,
      hasstatus  => true,
      hasrestart => true,
    }

  }
}
