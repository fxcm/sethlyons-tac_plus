#tac_plus

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with tac_plus](#setup)
    * [What tac_plus affects](#what-tac_plus-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with tac_plus](#beginning-with-tac_plus])
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Contributors](#contributors)

##Overview

Puppet module to manage Shrubbery's tac_plus

##Module Description

This module installs, configures, and manages tac_plus.  It lets you define any number of tac_plus users, groups, and ACLs and then builds a configuration file.  It also ensures that tac_plus is running.
It currently works only on FreeBSD but can be easily ported for other operating systems.

##Setup

###What tac_plus affects
* installs tac_plus
* creates configuration file $tac_plus_conf in $tac_plus_dir

###Setup Requirements
* REQUIRES:  puppetlabs/concat

###Beginning with tac_plus
To run tac_plus with all default options
```puppet
class { 'tac_plus':
}
```

##Usage
Even after setting up the tac_plus application (above), you will still need to create users/group/ACLs

To run tac_plus and override OS defaults
```puppet
class { 'tac_plus':
  tac_plus_conf => '/my/new/conf/file',
}
```

Adding a user
```puppet
tac_plus::user { 'test_user':
  login          => 'des <des-hashed-password>',
  pap            => 'des <des-hashed-password>',
  member         => 'cisco_users',
  service        => {
    'ppp'        => {
      'protocol' => {
        'ip'     => [
          'option1 = value1',
          'option2 = value2',
        ],
      },
    },
  },
  acl     => 'test_acl',
}
```

Adding a group
```puppet
tac_plus::group { 'test_group':
  default_service   => 'deny',
  service           => {
    'exec'          => {
      'opts'        => [
        'priv-lvl = 15',
        'idletime = 10',
      ],
    },
  },
  cmd             => {
    'terminal'    => [
      'permit length.*',
    ],
    'show'        => [
      'permit ip.arp.*',
      'permit mac-address-table.*',
    ],
  },
}
```

Adding an ACL
```puppet
tac_plus::acl { 'test acl':
  line => [
    'permit = 1.1.1.1',
    'permit = 2.2.2.2',
    'deny = .*'
  ],
}
```

Note on `additional_attrs`:  there can be many additional_attrs, but each attribute can only have one value.
```puppet
tac_plus::user { 'test_user':
  login                => 'des <des-hashed-password>',
  pap                  => 'des <des-hashed-password>',
  member               => 'cisco_users',
  service              => {
    'ppp'              => {
      'protocol'       => {
        'ip'           => [
          'option1 = value1',
          'option2 = value2',
        ],
      },
    },
  },
  acl                  => 'test_acl',
  additional_attrs     => [
    'chap = <chap settings>',
    'expires = <date>',
  ],
}
```

##Reference

###Classes

####Public Class
* `tac_plus`: Guides the basic setup of tac_plus

####Private Class
* `tac_plus::params`: Sets OS defaults

###Defined Types

####Public Defined Types
* `tac_plus::user`: Creates tac_plus users
* `tac_plus::group`: Create tac_plus groups
* `tac_plus::acl`: Creates tac_plus ACLs

###Templates
The tac_plus module relies on server settings, user, group, and ACL templates that get concatenated into a single configuration file.

##Limitations
This module currently works only on FreeBSD.  It was written with a framework in place to easily add support for additional operating systems.

##Contributors
Special thanks to the following individuals for their help:
* fetep
* tehdr
