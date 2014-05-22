# == Define: tac_plus::user
# This class creates tac_plus users
#
# === Options:
#
# [*user*]
#   username
#
# [*login*]
#   user's password using tac_plus syntax (des, cleartext, etc.)
#
# [*pap*]
#   user's password for pap logins
#
# [*member*]
#   group to which user belongs
#
# [*default_service*]
#   set the user's default service.  should be either permit or deny.
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
# [*acl*]
#   ACL to be applied to user
#
# [*additional_attrs*]
#   any additional definitions as a single array
#   ***each attribute receives only one value***
#
define tac_plus::user (
  $user             = $name,
  $login            = '',
  $pap              = '',
  $member           = '',
  $default_service  = '',
  $service          = {},
  $protocol         = {},
  $cmd              = {},
  $acl              = '',
  $additional_attrs = [],
) {

  concat::fragment { "user-${user}":
    target  => $::tac_plus::tac_plus_conf,
    content => template('tac_plus/user.erb'),
    order   => '10',
  }
}
