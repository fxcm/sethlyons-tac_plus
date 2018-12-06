## This class sets some tac_plus parameters

class tac_plus::params {
  case $::osfamily {
    'Debian': {
      $package_name     = 'tacacs+'
      $package_ensure   = 'installed'
      $tac_plus_dir     = '/etc/tacacs+'
      $tac_plus_conf    = '/etc/tacacs+/tac_plus.conf'
      $tac_plus_flags   = ''
      $tac_plus_service = 'tacacs_plus'
      $config_owner     = 'root'
      $config_group     = 'root'
    }
    'FreeBSD': {
      $package_name     = 'tac_plus'
      $package_ensure   = 'installed'
      $tac_plus_dir     = '/usr/local/etc/tac_plus'
      $tac_plus_conf    = '/usr/local/etc/tac_plus/tac_plus.conf'
      $tac_plus_flags   = ''
      $tac_plus_service = 'tac_plus'
      $config_owner     = 'tacacs'
      $config_group     = 'tacacs'
    }

    default: {
      fail("${::osfamily} is not supported")
    }
  }
}
