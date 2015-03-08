include base
class { 'yarn':
	hadoop_included => true
}
class { 'spark':
	slave => true,
	spark_included => true
}