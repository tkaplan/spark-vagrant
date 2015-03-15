class spark::fs (
	$with_yarn = false
) {

	file { '/home/vagrant/add-jars.sh':
		source => '/vagrant/modules/spark/files/add-jars.sh',
		ensure => 'file',
		owner => 'vagrant',
		mode => 0775
	}

	file { '/home/vagrant/submit.sh':
		source => '/vagrant/modules/spark/files/submit.sh',
		ensure => 'file',
		owner => 'vagrant',
		mode => 0775
	}

	file { '/usr/local/spark/conf/spark-env.sh':
		mode => 0775,
		owner => 'spark',
		content => template('spark/spark-env.sh.erb'),
		require => Exec['spark_download']
	}

	file { '/usr/local/spark/conf/spark-defaults.conf':
		ensure => 'file',
		content => template('spark/spark-defaults.conf.erb'),
		group => 'spark',
		mode => 0775,
		owner => 'spark',
		require => Exec['spark_download']
	}
}