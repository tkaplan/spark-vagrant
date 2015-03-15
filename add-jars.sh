vagrant rsync
vagrant ssh spark-slave0 -c "bash remove-jars.sh"
vagrant ssh spark-slave0 -c "bash add-jars.sh"
