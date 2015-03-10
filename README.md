# spark-vagrant
Spark Cluster
This vagrant setup that will build a spark master with with 3 slaves ontop of hadoop yarn and hdfs.

## Getting started
Do either 1 A) or 1 B) but not both

1 A)
If you don't want to bother downloading the tar's of hadoop/ spark and throwing them into this vagrant directory AND you don't mind waiting 3 hours for setup... you can simply go into /manifests/spark-master.pp as well as /manifests/spark-slave.pp and switch with_yarn to false.

class { 'spark':
	with_yarn => true, // switch this to false and hadoop/ spark precompiled binaries will be downloaded on all machines
	slave => false,
	spark_included => true
}

1 B)

However to get the machines up and running asap, simply run bash download-binaries.sh. This makes provisioning MUCH MUCH faster since the binaries are downloaded only once.

2) vagrant up

3) vagrant reload

  The services on the vm's are started by way of init.d. That means that once you are finished provisioning, the spark services won't immediately boot up. Instead you must restart the machines with vagrant reload.
  
## About the cluster

The master and master slave resides on 10.0.0.2.
Access to webapp hadoop:
In your browser go to ->
10.0.0.2:8088

Access to webapp hdfs:

In your browser go to ->

localhost:50070 (10.0.0.2:50070 doesn't not work because it binds to localhost address, I don't care to figure out the configuration to correct this. Please submit a PR if you can fix this)

Access to spark cluster:

In your browser go to ->

10.0.0.2:8080


10.0.0.2
- Master
- Slave


10.0.0.3
- Slave0


10.0.0.4
- Slave1
