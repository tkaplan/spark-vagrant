class base {
  include apt
  exec { "apt-update":
    command => "/usr/bin/apt-get update"
  }
  apt::ppa { 'ppa:webupd8team/java': }
  exec { 'accept_oracle_java_license':
    command => 'echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections',
    path => "/usr/bin/:/bin/",
    logoutput => true,
  }
  package { 'oracle-java8-installer':
    require => [Apt::Ppa['ppa:webupd8team/java'], Exec['accept_oracle_java_license']],
    ensure => installed
  }
  package { 'oracle-java8-set-default':
    require => Package['oracle-java8-installer'],
    ensure => installed
  }
  package { 'maven':
    require => Package['oracle-java8-set-default'],
    ensure => installed
  }
  package { 'scala':
    require => Package['oracle-java8-set-default'],
    ensure => installed
  }
}
