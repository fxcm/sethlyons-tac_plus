## This class sets some tac_plus parameters

class tac_plus::params {
  case $::osfamily {
    'FreeBSD': {
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
