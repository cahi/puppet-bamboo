# == Class bamboo::service
#
class bamboo::service(
  $service_name   = $bamboo::service_name,
  $service_manage = $bamboo::service_manage,
  $service_ensure = $bamboo::service_ensure,
  $service_enable = $bamboo::service_enable,
) {
  if $bamboo::service_manage {
    service { $service_name:
      ensure     => $service_ensure,
      enable     => $service_enable,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
