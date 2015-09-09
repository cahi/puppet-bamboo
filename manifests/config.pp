# == Class bamboo::config
#
class bamboo::config(
  $javahome            = $bamboo::javahome,
  $installdir          = $bamboo::installdir,
  $homedir             = $bamboo::homedir,
  $user                = $bamboo::user,
  $group               = $bamboo::group,
  $webappdir           = $bamboo::webappdir,
  $jvm_xms             = $bamboo::jvm_xms,
  $jvm_xmx             = $bamboo::jvm_xmx,
  $jvm_permgen         = $bamboo::jvm_permgen,
  $jvm_args            = $bamboo::jvm_support_recommended_args,
  $tomcat_port         = $bamboo::tomcat_port,
  $tomcat_max_threads  = $bamboo::tomcat_max_threads,
  $tomcat_accept_count = $bamboo::tomcat_accept_count,
  $tomcat_proxy        = $bamboo::tomcat_proxy,
  $tomcat_extras       = $bamboo::tomcat_extras,
  $manage_server_xml   = $bamboo::manage_server_xml,
) {

  File {
    owner => $user,
    group => $group,
  }

  file { "${homedir}/logs":
    ensure  => directory,
  }

  file { "${webappdir}/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties":
    ensure  => 'file',
    content => template('bamboo/bamboo-init.properties.erb'),
    mode    => '0755',
  }

  file { "${webappdir}/bin/setenv.sh":
    ensure  => 'file',
    content => template('bamboo/setenv.sh.erb'),
    mode    => '0755',
  }

  if $manage_server_xml == 'augeas' {
    $_tomcat_max_threads  = { maxThreads  => $tomcat_max_threads }
    $_tomcat_accept_count = { acceptCount => $tomcat_accept_count }
    $_tomcat_port         = { port        => $tomcat_port }
  
    $parameters = merge($_tomcat_max_threads, $_tomcat_accept_count, $tomcat_proxy, $tomcat_extras, $_tomcat_port )
  
    if versioncmp($::augeasversion, '1.0.0') < 0 {
      fail('This module requires Augeas >= 1.0.0')
    }
  
    $path = "Server/Service[#attribute/name='Tomcat-Standalone']"
  
    if ! empty($parameters) {
      $_parameters = suffix(prefix(join_keys_to_values($parameters, " '"), "set ${path}/Connector/#attribute/"), "'")
    } else {
      $_parameters = undef
    }
  
    $changes = delete_undef_values([$_parameters])
  
    if ! empty($changes) {
      augeas { "${webappdir}/conf/server.xml":
        lens    => 'Xml.lns',
        incl    => "${webappdir}/conf/server.xml",
        changes => $changes,
      }
    }

  } elsif $manage_server_xml == 'template' {

    file { "${webappdir}/conf/server.xml":
      content => template('bamboo/server.xml.erb'),
      mode    => '0600',
    }

  }
}
