$tmp_dir = '/tmp/puppet-int/'

Exec {
  path => '/bin/',
}

File {
  ensure             => directory,
  force              => true,
  purge              => true,
  recurse            => true,
  source_permissions => use,
}

package { 'puppetlabs-release-pc1':
  ensure   => installed,
  provider => rpm,
  source   => 'https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm',
}

package { ['puppetserver', 'puppet', 'git']:
  ensure => installed,
}

file { $tmp_dir:
  ensure => absent,
}

exec { 'git_clone':
  command => "git clone https://github.com/odivlad/puppet-int.git ${tmp_dir}",
}

file { 'sync_code':
  ensure => file,
  path   => '/etc/puppetlabs/code/sync_code.pp',
  source => "${tmp_dir}/sync_code.pp"
}

file { 'puppet_sync':
  ensure => file,
  path   => '/usr/sbin/psync',
  source => "${tmp_dir}/psync.sh",
}

$files = [ 'manifests' ]
$files.each | $file | {
  file { "/etc/puppetlabs/code/environments/production/${file}":
    source => "${tmp_dir}/${file}",
  }
}
