# == Class bamboo::install
#
# This class is called from bamboo for install.
#
class bamboo::install (
  $javahome     = $bamboo::javahome,
  $installdir   = $bamboo::installdir,
  $homedir      = $bamboo::homedir,
  $user         = $bamboo::user,
  $group        = $bamboo::group,
  $shell        = $bamboo::shell,
  $webappdir    = $bamboo::webappdir,
  $downloadURL  = $bamboo::downloadURL,
  $file         = $bamboo::file,
) {

  user { $user:
    comment          => 'Bamboo daemon account',
    shell            => $shell,
    home             => $homedir,
    password         => '*',
    password_min_age => '0',
    password_max_age => '99999',
    managehome       => true,
    system           => true,
  } ->

  file { $webappdir:
    ensure => 'directory',
    owner  => $user,
    group  => $group,
  }

  file { $installdir:
    ensure => 'directory',
    owner  => $user,
    group  => $group,
  }

  staging::file { $file:
    source  => "${downloadURL}/${file}",
    timeout => 1800,
  } ->

  staging::extract { $file:
    target  => $webappdir,
    creates => "${webappdir}/conf",
    strip   => 1,
    user    => $user,
    group   => $group,
    notify  => Exec["chown_${webappdir}"],
    before  => File[$homedir],
    require => [
      File[$installdir],
      User[$user],
      File[$webappdir] ],
  }

  file { $homedir:
    ensure => 'directory',
    owner  => $user,
    group  => $group,
  }

  exec { "chown_${webappdir}":
    command     => "/bin/chown -R ${user}:${group} ${webappdir}",
    refreshonly => true,
    subscribe   => User[$user]
  }

  file { "${installdir}/latest":
    ensure => link,
    target => $webappdir,
  }

}
