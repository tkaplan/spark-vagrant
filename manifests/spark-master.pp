include base
class { 'yarn':
	hadoop_included => true
}
class { 'spark':
	slave => false,
	spark_included => true
}