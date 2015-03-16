class { 'base':
	scala_version => '10.5'
}

class { 'yarn':
	hadoop_included => true,
	master => true
}

class { 'spark':
	with_yarn => true,
	slave => false,
	spark_included => true
}