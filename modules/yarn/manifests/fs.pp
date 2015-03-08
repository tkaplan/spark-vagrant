class yarn::fs {
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
}