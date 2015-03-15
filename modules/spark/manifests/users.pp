class spark::users (
	$with_yarn = true
) {

	group { 'spark':
		name => 'spark',
		ensure => present
	}
	if $with_yarn {
		user { 'spark':
			name => 'spark',
			ensure => present,
			groups => ['hadoop', 'spark'],
			require => [
				User['hadoop'],
				Group['spark']
			]
		}
	} else {
		user { 'spark':
			name => 'spark',
			ensure => present,
			groups => ['spark'],
			require => Group['spark']
		}
	}
}