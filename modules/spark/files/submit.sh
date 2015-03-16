/usr/local/spark/bin/spark-submit --class $1 --deploy-mode cluster --master spark://spark.master:7077 hdfs:///spark/$2
