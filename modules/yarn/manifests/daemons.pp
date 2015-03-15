class yarn::daemons {
	file { "/etc/init.d/hadoop":
		ensure => file,
		mode => 0755,
		owner => 'root',
		content => template('yarn/hadoop.erb')
	}

	exec { "Enable hadoop":
		path => '/sbin:/usr/sbin:/bin:/usr/bin',
		command => 'update-rc.d -f hadoop defaults && update-rc.d -f hadoop enable',
		require => File["/etc/init.d/hadoop"]
	}
}