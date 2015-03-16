vagrant rsync
vagrant ssh spark-master -c "sudo -u hadoop JAVA_HOME=$JAVA_HOME /usr/local/hadoop/bin/hdfs dfs -rm /spark/*"
vagrant ssh spark-master -c "bash add-jars.sh"
