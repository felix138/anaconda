# 基于官方的 Anaconda 镜像
FROM continuumio/anaconda3

# 更新源列表，使用较新的 buster 版本的源
RUN echo 'deb http://deb.debian.org/debian/ buster main contrib non-free' > /etc/apt/sources.list && \
    echo 'deb-src http://deb.debian.org/debian/ buster main contrib non-free' >> /etc/apt/sources.list && \
    echo 'deb http://security.debian.org/debian-security buster/updates main' >> /etc/apt/sources.list && \
    echo 'deb-src http://security.debian.org/debian-security buster/updates main' >> /etc/apt/sources.list
    
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    openjdk-11-jdk \
    net-tools \
    curl \
    netcat \
    gnupg \
    libsnappy-dev \
    tzdata \
    iputils-ping \
    telnet \
    procps \
    vim \ 
    && rm -rf /var/lib/apt/lists/*

# 设置 JAVA_HOME 环境变量
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH
# 安装 PySpark 和 PyMySQL
#RUN conda install -y pyspark=3.0.0 pymysql
RUN conda install -y python=3.9 pyspark=3.0.0 pymysql
# install lsp for jupyter tips
RUN pip install python-lsp-server
# 设置环境变量，以便 PySpark 找到 Hadoop 和 Spark
ENV HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
ENV SPARK_HOME=/opt/spark
ENV PYSPARK_PYTHON=/opt/conda/bin/python

# 下载并安装 Hadoop
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz -O /tmp/hadoop.tar.gz && \
    tar -xzvf /tmp/hadoop.tar.gz -C /opt/ && \
    mv /opt/hadoop-3.2.1 /opt/hadoop && \
    rm /tmp/hadoop.tar.gz

# 下载并安装 Spark
RUN wget https://archive.apache.org/dist/spark/spark-3.0.0/spark-3.0.0-bin-hadoop3.2.tgz -O /tmp/spark.tgz && \
    tar -xzvf /tmp/spark.tgz -C /opt/ && \
    mv /opt/spark-3.0.0-bin-hadoop3.2 /opt/spark && \
    rm /tmp/spark.tgz

# 设置默认命令，启动 Jupyter Lab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
