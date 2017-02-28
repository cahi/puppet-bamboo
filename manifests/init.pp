# == Class: bamboo
#
# Full description of class bamboo here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class bamboo (

  # JVM Settings
  $javahome,

  # Bamboo Settings
  $version      = '5.7.2',
  $product      = 'bamboo',
  $format       = 'tar.gz',
  $installdir   = '/opt/bamboo',
  $homedir      = '/home/bamboo',
  $user         = 'bamboo',
  $group        = 'bamboo',
  $shell        = '/bin/true',

  # Misc Settings
  $downloadURL  = 'http://www.atlassian.com/software/bamboo/downloads/binary',

  # Manage service
  $service_name   = $bamboo::params::service_name,
  $service_manage = true,
  $service_ensure = 'running',
  $service_enable = true,

  # JVM Tunables
  $jvm_xms      = '256m',
  $jvm_xmx      = '1024m',
  $jvm_permgen  = '256m',
  $jvm_support_recommended_args = '-XX:-HeapDumpOnOutOfMemoryError',

  # Tomcat Tunables
  # Should we use augeas to manage server.xml or a template file
  $manage_server_xml   = 'template',
  $tomcat_port         = 8085,
  $tomcat_max_threads  = 150,
  $tomcat_accept_count = 100,
  # Reverse https proxy setting for tomcat
  $tomcat_proxy = {},
  # Any additional tomcat params for server.xml
  $tomcat_extras = {},

# TODO: Configure the database as part of install
#  # Database Settings
#  $db           = 'postgresql',
#  $dbuser       = 'bambooadm',
#  $dbpassword   = 'mypassword',
#  $dbserver     = 'localhost',
#  $dbname       = 'bamboo',
#  $dbport       = '5432',
#  $dbdriver     = 'org.postgresql.Driver',
#  $dbtype       = 'postgres72',
#  $poolsize     = '15',
) inherits ::bamboo::params {

  validate_re($version, '^(?:(\d+)\.)?(?:(\d+)\.)?(?:(\d+)\.)?(\*|\d+)(|[a-z])$')
  validate_absolute_path($installdir)
  validate_absolute_path($homedir)

  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

  $webappdir    = "${installdir}/atlassian-${product}-${version}"
  $file = "atlassian-${bamboo::product}-${bamboo::version}.${bamboo::format}"

  anchor { 'bamboo::start': } ->
  class { '::bamboo::install': } ->
  class { '::bamboo::config': } ~>
  class { '::bamboo::service': } ->
  anchor { 'bamboo::end': }

}
