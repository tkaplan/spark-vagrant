class yarn (
	$hadoop_included = false,
	$master = false
) {
  file { '/etc/environment':
    source => '/vagrant/modules/yarn/files/environment'
  }

  include yarn::users
  
  class { 'yarn::download':
  	hadoop_included => $hadoop_included
  }

  include yarn::daemons
  class { 'yarn::fs':
  	master => $master
  }

}
