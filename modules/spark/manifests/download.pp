class spark::download (
  $spark_archive = "http://d3kbcqa49mib13.cloudfront.net/spark-1.2.1-bin-hadoop2.4.tgz",
  $spark_name =  "spark-1.2.1-bin-hadoop2.4",
  $spark_included = false
) {

	if !$spark_included {
		exec { 'spark_download':
		  command => "wget ${spark_archive} && tar -xzvf ${spark_name}.tgz && mv ${spark_name} /usr/local/spark && rm ${spark_name}.tgz && chown spark:spark /usr/local/spark -R && chmod 0775 /usr/local/spark -R",
		  path => '/bin:/usr/bin:/usr/sbin',
		  timeout => 0,
		  require => [
		    Package['wget'],
		    User['spark']
		  ]
		}
	} else {
		exec { 'spark_download':
		  command => "tar -xzvf /vagrant/spark*.tgz && mv spark* /usr/local/spark && chown spark:spark /usr/local/spark -R && chmod 0775 /usr/local/spark -R",
		  path => '/bin:/usr/bin:/usr/sbin',
		  timeout => 0,
		  require => [
		    Package['wget'],
		    User['spark']
		  ]
		}
	}
}