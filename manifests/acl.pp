# == Define: tac_plus::acl
# This class creates tac_plus ACLs
#
# === Options:
#
# [*acl*]
#   name of the ACL
#
# [*line*]
#   the lines of the ACL as an array
#
#
define tac_plus::acl (
  $acl  = $name,
  $line = [],
) {

  concat::fragment {"acl-${acl}":
    target  => $::tac_plus::tac_plus_conf,
    content => template('tac_plus/acl.erb'),
    order   => '30',
  }
}
