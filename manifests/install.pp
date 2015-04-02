# == Class etcd::install
#
class etcd::install {
  # Create group and user if required
  if $etcd::manage_user {
    group { $etcd::group: ensure => 'present' }

    user { $etcd::user:
      ensure  => 'present',
      gid     => $etcd::group,
      require => Group[$etcd::group],
      before  => Package['etcd']
    }
  }

  # Create etcd data dir if required
  if $etcd::manage_data_dir {
    file { $etcd::data_dir:
      ensure => 'directory',
      owner  => $etcd::user,
      group  => $etcd::group,
      mode   => '0750',
      before => Package['etcd']
      after => User[$etcd::user]
    }
  }

  # Create etcd log dir if required
  if $etcd::manage_log_dir {
    file { $etcd::log_dir:
      ensure => 'directory',
      owner  => $etcd::user,
      group  => $etcd::group,
      mode   => '0750',
      before => Package['etcd']
      after => User[$etcd::user]
    }
  }

  # Install the required package
  package { 'etcd':
    ensure => $etcd::package_ensure,
    name   => $etcd::package_name,
  }
}
