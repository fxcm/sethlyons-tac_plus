# == Define: tac_plus
#
# This class installs and configures tac_plus
# Requires: puppetlabs/concat
#
# === Options:
#
# [*key*]
#   encryption key to be used on clients
#
# [*accounting_file*]
#   location of tac_plus accounting file
#
# [*package_name*]
#   package name of tac_plus
#
# [*package_ensure*]
#   present/latest/installed/etc.
#
# [*tac_plus_dir*]
#   location of tac_plus directory
#
# [*tac_plus_conf*]
#   location of tac_plus configuration file
#
# [*tac_plus_flags*]
#   tac_plus runtime options
#
# [*tac_plus_service*]
#   name of tac_plus daemon
#
# [*config_owner*]
#   file owner for $tac_plus_conf
#
# [*config_group*]
#   file group for $tac_plus_conf
#
class tac_plus (
  $key              = '',
  $accounting_file  = '',
  $package_name     = $::tac_plus::params::package_name,
  $package_ensure   = $::tac_plus::params::package_ensure,
  $package_source   = undef,
  $tac_plus_dir     = $::tac_plus::params::tac_plus_dir,
  $tac_plus_conf    = $::tac_plus::params::tac_plus_conf,
  $tac_plus_flags   = '',
  $tac_plus_service = $::tac_plus::params::tac_plus_service,
  $config_owner     = $::tac_plus::params::config_owner,
  $config_group     = $::tac_plus::params::config_group,
  ) inherits tac_plus::params {

  package { $package_name:
    ensure => $package_ensure,
    source => $package_source,
  }

  concat { $tac_plus_conf:
    owner   => $config_owner,
    group   => $config_group,
    mode    => '0640',
    notify  => Service['tac_plus'],
  }

  concat::fragment { 'server_settings':
    target  => $tac_plus_conf,
    content => template('tac_plus/server_settings.erb'),
    order   => '05',
  }

  if $tac_plus_dir {
    file { $tac_plus_dir:
      ensure => directory,
      mode   => '0700',
      owner  => $config_owner,
      group  => $config_group,
      before => Concat[$tac_plus_conf],
    }
  }

  case $::osfamily {
    'Debian': {
      file { '/etc/default/tacacs+':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => "# tac_plus init configuration via Puppet\nDAEMON_OPTS=\"-C ${tac_plus_conf} ${tac_plus_flags}\"",
        notify  => Service['tac_plus'],
      }
    }
    'FreeBSD': {
      if $tac_plus_flags!='' {
        file_line { 'rc.conf tac_plus_flags':
          path    => '/etc/rc.conf',
          line    => "tac_plus_flags=\"${tac_plus_flags}\"",
          notify  => Service['tac_plus'],
        }
      }

      file_line { 'rc.conf tac_plus_configfile':
        path    => '/etc/rc.conf',
        line    => "tac_plus_configfile=\"${tac_plus_conf}\"",
        notify  => Service['tac_plus'],
      }
    }
  }

  service { 'tac_plus':
    name      => $tac_plus_service,
    enable    => true,
    ensure    => running,
    require   => [
      Package[$package_name],
      Concat[$tac_plus_conf],
    ],
  }
}
