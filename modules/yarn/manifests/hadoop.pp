class yarn::hadoop (
  $namenode_port = 9000,
  $dfs_replication = 3,
  $hadoop_archive = "http://mirror.olnevhost.net/pub/apache/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz",
  $hadoop_name = "hadoop-2.6.0"
) {
    exec { 'hadoop_download':
      command => "wget ${hadoop_archive} && tar -xzvf ${hadoop_name}.tar.gz && mv ${hadoop_name} /usr/local/hadoop && rm ${hadoop_name}.tar.gz && chown hadoop:hadoop /usr/local/hadoop -R && chmod 0774 /usr/local/hadoop -R",
      path => '/bin:/usr/bin:/usr/sbin',
      onlyif => "[ ! -d /usr/local/hadoop ]",
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

    file { '/usr/local/hadoop/logs':
      ensure => directory,
      group => 'hadoop',
      mode => 0774
    }

    file { '/etc/init.d/start-hadoop':
      source => '/vagrant/modules/yarn/files/start-hadoop',
      group => 'root',
      mode => 0775
    }

    exec { 'format hdfs':
      command => '/usr/local/hadoop/bin/hdfs namenode -format',
      environment => ['JAVA_HOME=/usr/lib/jvm/java-8-oracle'],
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
          '/var/log/hadoop/yarn',
          '/usr/local/hadoop/logs'
        ],
        Package['oracle-java8-set-default']
      ]
    }
    exec { 'Add service':
      command => 'sysv-rc-conf start-hadoop enable && sysv-rc-conf start-hadoop --level 13 on',
      cwd => '/',
      user => 'root',
      path => '/usr/sbin',
      require => [
        File[
          '/etc/init.d/start-hadoop'
        ],
        Package['sysv-rc-conf']
      ]
    }
}