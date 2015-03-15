class spark::daemons (
	$master = true
) {

	file { "/etc/init.d/spark-slave":
		ensure => file,
		mode => 0755,
		owner => 'root',
		content => template('spark/spark-slave.erb')
	}

	exec { "Enable spark slave":
		path => '/sbin:/usr/sbin:/bin:/usr/bin',
		command => 'update-rc.d -f spark-slave defaults && update-rc.d -f spark-slave enable',
		require => File["/etc/init.d/spark-slave"]
	}

	if $master {
		file { "/etc/init.d/spark-master":
			ensure => file,
			mode => 0755,
			owner => 'root',
			content => template('spark/spark-master.erb')
		}

		exec { "Enable spark master":
			path => '/sbin:/usr/sbin:/bin:/usr/bin',
			command => 'update-rc.d -f spark-master defaults && update-rc.d -f spark-master enable',
			require => File["/etc/init.d/spark-master"]
		}
	}
}