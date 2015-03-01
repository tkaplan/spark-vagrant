class yarn::users {
	group { 'hadoop':
		name => 'hadoop',
		ensure => present
	}

	user { 'hadoop':
		name => 'hadoop',
		ensure => present
	}

	user { 'yarn':
		ensure => present,
		groups => ['hadoop']
	}

	user { 'hdfs':
		ensure => present,
		groups => ['hadoop']
	}

	user { 'mapred':
		ensure => present,
		groups => ['hadoop']
	}

	user { 'spark':
		ensure => present,
		groups => ['hadoop']
	}
}