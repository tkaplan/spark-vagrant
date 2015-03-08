class yarn (
	$hadoop_included = false
) {
  file { '/etc/profile.d/environment.sh':
    source => '/vagrant/modules/yarn/files/environment.sh'
  }

  include yarn::users
  
  class { 'yarn::download':
  	hadoop_included => $hadoop_included
  }

  include yarn::daemons
  include yarn::fs

}
