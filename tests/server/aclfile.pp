
include remctl
class {'remctl::server': }

remctl::server::aclfile {'acl_file1': 
    acls            => ['princ:test@TEST.REALM.ORG']
}

# vim: tabstop=4 shiftwidth=4 softtabstop=4
