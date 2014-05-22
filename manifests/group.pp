# == Define: tac_plus::group
#
# This class creates tac_plus groups
#
# === Options:
#
# [*group*]
#   name of the group
#
# [*default_service*]
#   the group's default service
#
# [*service*]
#   service definitions as hashes
#   ***each key's value should be a hash with option keys
#      opts and protocol***
#   ***SEE EXAMPLE IN README***
#
# [*protocol*]
#   protocol definitions as hashes
#   ***each key's value should be in a single array***
#
# [*cmd*]
#   command definitions as hashes
#   ***each key's value should be in a single array***
#
# [*additional_attrs*]
#   any additional definitions as a single array
#   ***each attribute receives only one value***
#
define tac_plus::group (
  $group           = $name,
  $default_service = '',
  $service         = {},
  $protocol        = {},
  $cmd             = {},
  $addtional_attrs = {},
) {

  concat::fragment {"group-${group}":
    target  => $::tac_plus::tac_plus_conf,
    content => template('tac_plus/group.erb'),
    order   => '20',
  }
}
