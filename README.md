﻿# anaconda
Use docker to install anaconda and connect to mysql and spark hadoop environments. Use jupyter to write programs and run.
python verison 3.9
pyspark 3.0.0

in bash run command:
docker exec -it anaconda bash
when you login anaconda container  run command : wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.30/mysql-connector-java-8.0.30.jar
and copy mysql-connector-java-8.0.30.jar to /opt/spark/jars/
then in your ipynb you can set the spark jars for JDBC . 
.set("spark.jars","/opt/spark/jars/mysql-connector-java-8.0.30.jar")
