class yarn::hadoop (
  $namenode_port = 9000,
  $dfs_replication = 3,
  $hadoop_archive = "http://mirror.olnevhost.net/pub/apache/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz",
  $spark_archive = "http://d3kbcqa49mib13.cloudfront.net/spark-1.2.1-bin-hadoop2.4.tgz",
  $hadoop_name = "hadoop-2.6.0",
  $spark_name =  "spark-1.2.1-bin-hadoop2.4"
) {
    exec { 'hadoop_download':
      command => "wget ${hadoop_archive} && tar -xzvf ${hadoop_name}.tar.gz && mv ${hadoop_name} /usr/local/hadoop && rm ${hadoop_name}.tar.gz",
      path => '/bin:/usr/bin:/usr/sbin',
      require => Package['wget']
    }

    exec { 'spark_download':
      command => "wget ${spark_archive} && tar -xzvf ${spark_name}.tgz && mv ${spark_name} /usr/local/spark && rm ${spark_name}.tgz",
      path => '/bin:/usr/bin:/usr/sbin',
      require => Package['wget']
    }

    file { [
      '/var/data',
      '/var/data/hadoop',
      '/var/log/hadoop'
      ]:
      ensure => 'directory',
      owner => 'hadoop',
      group => 'hadoop',
      mode => 0750
    }

  	file { [
  		'/var/data/hadoop/hdfs',
  		'/var/data/hadoop/hdfs/nn',
  		'/var/data/hadoop/hdfs/snn',
  		'/var/data/hadoop/hdfs/dn'
  		]:
  		ensure => 'directory',
  		owner => 'hdfs',
  		group => 'hadoop',
      require => File['/var/data','/var/data/hadoop'],
  		mode => 0750
  	}

  	file { [
  		'/var/log/hadoop/yarn'
  		]:
  		ensure => 'directory',
  		owner => 'yarn',
      require => File['/var/log/hadoop'],
  		group => 'hadoop',
  		mode => 0750
  	}

    file { [
      '/usr/local/hadoop/etc/hadoop/core-site.xml'
    ]:
      require => Exec['hadoop_download'],
      ensure => file,
      content => template('yarn/core-site.xml.erb')
    }

    file { [
      '/usr/local/hadoop/etc/hadoop/hdfs-site.xml'
    ]:
      require => Exec['hadoop_download'],
      ensure => file,
      content => template('yarn/hdfs-site.xml.erb')
    }
}