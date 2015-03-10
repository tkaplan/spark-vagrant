include base
class { 'yarn':
	hadoop_included => true,
	master => false
}
class { 'spark':
	with_yarn => true,
	slave => true,
	spark_included => true
}