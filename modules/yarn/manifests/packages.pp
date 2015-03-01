class yarn::packages {
	package { 'wget':
		ensure => installed
	}

	package { 'rsync':
		ensure => installed
	}
}