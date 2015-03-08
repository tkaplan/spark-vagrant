class yarn::daemons {
	file { "/etc/init.d/hadoop":
		ensure => file,
		mode => 0755,
		user => root,
		source => template('yarn/hadoop.erb')
	}

	// Enable hadoop
	exec { "Enable hadoop":
		path => '/sbin:/usr/sbin:/bin:/usr/bin',
		command => 'update-rc.d -f hadoop defaults && update-rc.d -f hadoop enable',
		require => "/etc/init.d/hadoop"
	}
}