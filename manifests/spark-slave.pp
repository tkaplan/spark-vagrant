include base
class { 'yarn':
	hadoop_included => true,
	master => false
}
class { 'spark':
	slave => true,
	spark_included => true
}