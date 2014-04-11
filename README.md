#remctl

[![Build Status](https://travis-ci.org/ccin2p3/puppet-ccin2p3-remctl.svg?branch=travis-ci)](https://travis-ci.org/ccin2p3/puppet-ccin2p3-remctl)

####Table of Contents

1. [Overview - What is the remctl module](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with remctl](#setup)
    * [What remctl affects](#what-[modulename]-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with remctl](#beginning-with-remctl)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Classes and Defined Types](#classes-and-defined-types)
        * [Class: remctl](#class-remctl)
        * [Class: remctl::server](#class-remctlserver)
        * [Defined Type: remctl::server::aclfile](#defined-type-remctlserveraclfile)
        * [Defined Type: remctl::server::command](#defined-type-remctlservercommand)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
        * [Public Classes](#public-classes)
        * [Private Classes](#private-classes)
    * [Defined Types](#defined-types)
        * [Public defined types](#public-defined-types)
6. [Limitations - OS compatibility, etc.](#limitations)

##Overview

The remctl module allows you to set up remctl server through xinetd but also remctl command and ACL files via puppet manifests.

##Module Description

remctl is a client/server application that supports remote execution of specific commands, using Kerberos GSS-API for authentication and confidentiality.
This module provides simplified way to deploy server, command and ACL files.

##Setup

###What remctl affects

* configuration files and directories (created and written to) 
* package and configuration files for remctl
* xinetd service
* listened-to ports

###Beginning with remctl    

To install remctl server

```puppet
    class { 'remctl::server':
        debug           => false,
        only_from       => [ '0.0.0.0' ],
        disable         => false
    } 
```
To create an ACL file

```puppet
    remctl::server::aclfile { 'administrators':
        acls            => ['pcre:.+/admin@TEST.REALM.ORG']
    }
```

To create a new puppet managed command

```puppet
    remctl::server::command { 'reboot':
        command         => 'reboot',
        subcommand      => 'ALL',
        executable      => '/sbin/reboot',
        options         => {
            help    => '--help',
        },
        acls            => ["file:${remctl::server::acldir}/administrators"]
    }
```

##Usage


###Classes and Defined Types

####Class: `remctl`

Base class that handles package installation.

**Parameters within `remctl`:**

#####`package_ensure`

`ensure` property, passed to puppet `package` type.

####Class: `remctl::server`

This class MUST be declared in order to be able to use ACL or command types.

**Parameters within `remctl::server`:**

#####`ensure`

`ensure` property, passed to `xinetd::service`.

#####`debug`

Enable verbose debug logging (see `remctld(8)` `-d` option). Defaults to 'false'.

#####`disable`

Disable xinetd service. Defaults to 'true'.

#####`krb5_service`

Specifies which principal is used as the server identity for client authentication (see `remctld(8)` `-s` option). By default, remctld accepts any principal with a key in the specified keytab file.

#####`krb5_keytab`

Specifies keytab to use as the keytab for server credentials rather than the system default or the value of the KRB5_KTNAME environment variable (see `remctld(8)` `-k` option). Defaults to `undef`.

#####`port`

Specifies port to use. Defaults to `4373`.

#####`user`

User to run xinetd service as. Defaults to `root`.

#####`group`

Group to run xinetd service as. Defaults to `root`.

#####`manage_user`

Should we ensure that `user` is present.

#####`manage_group`

Should we ensure that `group` is present.

#####`only_from`

List of resources that are allowed to access this xinetd service (see `xinetd.conf(5)` `only_from` option for format). Defaults to `0.0.0.0`.

####Defined Type: `remctl::server::aclfile`

remctl ACL file resource type.
This class should be used to describe a set of resources that will be granted access to a set of remctl commands.

**Parameters within `remctl::server::aclfile`:**

#####`acldir`

Directory where we want to save aclfile. MUST be an absolute path. Defaults to `/etc/remctl.d`.

#####`acls`

Array of ACLs as desribed in `remctld(8)` `acl` section.

####Defined Type: `remctl::server::command`

remctl command file resource type.
This class should be used to describe a command that will be available through the remctl interface.

**Parameters within `remctl::server::command`:**

#####`command`

Required. command as described in `remctld(8)` `command` section.

#####`subcommand`

Required. subcommand as described in `remctld(8)` `subcommand` section.

#####`executable`

Required. executable as described in `remctld(8)` `executable` section. Must be an absolute path.

#####`options`

Hash of options as described in `remctld(8)` `option=value` section. Defaults to `{}`.

```puppet
    remctl::server::command { 'reboot':
        [...],
        options         => {
            help    => '--help',
            summary => '--summary',
            user    => 'remctl'
        },
    }
```

#####`acls`

Array of acls as desribed in `remctld(8)` `acl` section.

```puppet
    remctl::server::command { 'reboot':
        [...],
        acls        => ['princ:testuser@TEST.REALM.ORG'],
    }
```

##Reference

###Classes

####Public Classes

* [`remctl`](#class-remctl): Install remctl
* [`remctl::server`](#class-remctlserver): Configure remctl server through xinetd and handles configuration file

####Private Classes

* `remctl::params`: Manages remctl parameters

###Defined Types

####Public Defined Types

* [`remctl::server::aclfile`](#defined-type-remctlserveraclfile): Creates an ACL file conform to remctl ACL file format.
* [`remctl::server::command`](#defined-type-remctlservercommand): Creates a new command definition.

##Limitations

This module currently only work on `RedHat` and `Debian` os families and expects that the `remctl` package is available with your current repository configuration.
