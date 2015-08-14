# == Class pgbouncer::params
#
# This class is meant to be called from pgbouncer
# It sets variables according to platform
#
class pgbouncer::params {
  $auth_file    = '/etc/pgbouncer/userlist.txt'
  $configfile   = '/etc/pgbouncer/pgbouncer.ini'
  $package_name = 'pgbouncer'
  $service_name = 'pgbouncer'

  case $::osfamily {
    'Debian': {
      $logfile         = '/var/log/postgresql/pgbouncer.log'
      $pidfile         = '/var/run/postgresql/pgbouncer.pid'
      $unix_socket_dir = '/var/run/postgresql'
      $owner           = 'postgres'
      $group           = 'postgres'
    }
    'RedHat': {
      $logfile         = '/var/log/pgbouncer.log'
      $pidfile         = '/var/run/pgbouncer/pgbouncer.pid'
      $owner           = 'pgbouncer'
      $group           = 'pgbouncer'
      $unix_socket_dir = '/tmp'
    }
    'Suse': {
      $logfile         = '/var/log/pgbouncer/pgbouncer.log'
      $pidfile         = '/var/run/pgbouncer/pgbouncer.pid'
      $owner           = 'pgbouncer'
      $group           = 'pgbouncer'
      $unix_socket_dir = '/tmp'
    }
    'OpenBSD': {
      $logfile         = '/var/log/pgbouncer/pgbouncer.log'
      $pidfile         = '/var/run/pgbouncer/pgbouncer.pid'
      $owner           = '_pgbouncer'
      $group           = '_pgbouncer'
      $unix_socket_dir = '/tmp'
    }
    default: {
      fail("${::module_name}: OS family ${::osfamily} not supported")
    }
  }
}
