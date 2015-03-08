class yarn::users {
	group { 'hadoop':
		name => 'hadoop',
		ensure => present
	}

	user { 'vagrant':
		name => 'vagrant',
		groups => ['vagrant','hadoop','root']
	}

	user { 'hadoop':
		name => 'hadoop',
		ensure => present,
		require => Group['hadoop']
	}

	user { 'yarn':
		ensure => present,
		groups => ['hadoop'],
		require => User['hadoop']
	}

	user { 'hdfs':
		ensure => present,
		groups => ['hadoop'],
		require => User['hadoop']
	}
}