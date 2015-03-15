class yarn::fs (
  $master = false,
  $namenode_port = 8020,
  $dfs_replication = 3,
  $resourcemanager_hostname = 'spark.master'
) {

    exec { 'set hosts':
      command => 'echo "$(cat /vagrant/tmp/master) spark.master" >> /etc/hosts',
      path => '/usr/bin:/bin:/usr/local/sbin'
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
        'hdfs'
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

    file { [
      '/usr/local/hadoop/etc/hadoop/yarn-site.xml'
    ]:
      require => Exec['hadoop_download'],
      ensure => file,
      group => 'hadoop',
      mode => 0774,
      content => template('yarn/yarn-site.xml.erb')
    }

    file { '/usr/local/hadoop/logs':
      ensure => directory,
      group => 'hadoop',
      mode => 0774
    }
}