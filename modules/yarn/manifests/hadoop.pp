class yarn::hadoop (
  $namenode_port = 9000,
  $dfs_replication = 3,
  $hadoop_archive = "http://mirror.olnevhost.net/pub/apache/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz",
  $spark_archive = "http://d3kbcqa49mib13.cloudfront.net/spark-1.2.1-bin-hadoop2.4.tgz",
  $hadoop_name = "hadoop-2.6.0",
  $spark_name =  "spark-1.2.1-bin-hadoop2.4"
) {
    exec { 'hadoop_download':
      command => "wget ${hadoop_archive} && tar -xzvf ${hadoop_name}.tar.gz && mv ${hadoop_name} /usr/local/hadoop && rm ${hadoop_name}.tar.gz && chown hadoop:hadoop /usr/local/hadoop -R && chmod 0774 /usr/local/hadoop -R",
      path => '/bin:/usr/bin:/usr/sbin',
      timeout => 0,
      require => [
        Package['wget'],
        User['hadoop']
      ]
    }

    file { [
      '/var/data',
      '/var/data/hadoop',
      '/var/log/hadoop'
      ]:
      ensure => 'directory',
      owner => 'hadoop',
      group => 'hadoop',
      mode => 0774,
      require => User[
        'hadoop',
        'yarn',
        'hdfs',
        'mapred'
      ]
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
  		mode => 0774
  	}

  	file { [
  		'/var/log/hadoop/yarn'
  		]:
  		ensure => 'directory',
  		owner => 'yarn',
      require => File['/var/log/hadoop'],
  		group => 'hadoop',
  		mode => 0774
  	}

    file { [
      '/usr/local/hadoop/etc/hadoop/core-site.xml'
    ]:
      require => Exec['hadoop_download'],
      ensure => file,
      group => 'hadoop',
      mode => 0774,
      content => template('yarn/core-site.xml.erb')
    }

    file { [
      '/usr/local/hadoop/etc/hadoop/hdfs-site.xml'
    ]:
      require => Exec['hadoop_download'],
      ensure => file,
      group => 'hadoop',
      mode => 0774,
      content => template('yarn/hdfs-site.xml.erb')
    }

    exec { 'format hdfs':
      command => '/usr/local/hadoop/bin/hdfs namenode -format &> format_hdfs.log',
      user => 'hdfs',
      cwd => '/usr/local/hadoop',
      require => [
        File[
          '/usr/local/hadoop/etc/hadoop/core-site.xml',
          '/usr/local/hadoop/etc/hadoop/hdfs-site.xml',
          '/var/data/hadoop/hdfs',
          '/var/data/hadoop/hdfs/nn',
          '/var/data/hadoop/hdfs/snn',
          '/var/data/hadoop/hdfs/dn',
          '/var/log/hadoop/yarn'
        ],
        Package['oracle-java8-set-default']
      ]
    }

    exec { 'start hdfs':
      command => '/usr/local/hadoop/sbin/hadoop-daemon.sh start namenode && /usr/local/hadoop/sbin/hadoop-daemon.sh start secondarynamenode && /usr/local/hadoop/sbin/hadoop-daemon.sh start datanode &> start_hdfs.log',
      cwd => '/usr/local/hadoop',
      user => 'hdfs',
      require => Exec['format hdfs']
    }

    exec { 'start cluster':
      command => '/usr/local/hadoop/sbin/yarn-daemon.sh start resourcemanager && /usr/local/hadoop/sbin/yarn-daemon.sh start nodemanager &> start_cluster.log',
      cwd => '/usr/local/hadoop',
      user => 'yarn',
      require => Exec['start hdfs']
    }
}