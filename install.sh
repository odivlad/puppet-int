#!/bin/sh
#
# Installation script for RHEL-based systems

rpm -q puppetserver || yum install -y https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum install puppetserver -y

curl https://raw.githubusercontent.com/odivlad/puppet-int/master/sync_code.pp > /tmp/sync_code.pp
/opt/puppetlabs/bin/puppet apply /tmp/sync_code.pp
rm -f /tmp/sync_code.pp
