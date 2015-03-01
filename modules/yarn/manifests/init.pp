class yarn {
  file { '/etc/profile.d/environment.sh':
    source => '/vagrant/modules/yarn/files/environment.sh'
  }

  include yarn::packages
  include yarn::users
  include yarn::hadoop

}
