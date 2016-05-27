# Copyright (c) Mohamed Nabil HAfez.
# Distributed under the terms of the Modified BSD License.
FROM jupyter/pyspark-notebook

MAINTAINER nabilm <m.nabil.hafez@gmail.com>

USER root

# Util to help with kernel spec later
RUN apt-get -y update && apt-get -y install jq && apt-get clean && rm -rf /var/lib/apt/lists/*

# Spark dependencies
ENV APACHE_SPARK_VERSION 1.6.0
RUN apt-get -y update && \
    apt-get install -y --no-install-recommends openjdk-7-jre-headless python-setuptools build-essential python-dev python-pip openjdk-7-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install mongodb-hadoop dependencies
ENV MONGO_HADOOP_VERSION 1.5.2
ENV MONGO_HADOOP_COMMIT r1.5.2
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
#ENV SPARK_HOME /usr/local/spark
ENV MONGO_HADOOP_URL https://github.com/mongodb/mongo-hadoop/archive/${MONGO_HADOOP_COMMIT}.tar.gz
ENV MONGO_HADOOP_LIB_PATH /usr/local/mongo-hadoop/build/libs
ENV MONGO_HADOOP_JAR  ${MONGO_HADOOP_LIB_PATH}/mongo-hadoop-${MONGO_HADOOP_VERSION}.jar
ENV MONGO_HADOOP_SPARK_PATH /usr/local/mongo-hadoop/spark
ENV MONGO_HADOOP_SPARK_JAR ${MONGO_HADOOP_SPARK_PATH}/build/libs/mongo-hadoop-spark-${MONGO_HADOOP_VERSION}.jar
ENV SPARK_DRIVER_EXTRA_CLASSPATH ${MONGO_HADOOP_JAR}:${MONGO_HADOOP_SPARK_JAR}
ENV CLASSPATH ${SPARK_DRIVER_EXTRA_CLASSPATH}
ENV JARS ${MONGO_HADOOP_JAR},${MONGO_HADOOP_SPARK_JAR}
ENV PYSPARK_DRIVER_PYTHON $CONDA_DIR/envs/python2/bin/python
ENV PYTHONPATH ${MONGO_HADOOP_SPARK_PATH}/src/main/python:$PYTHONPATH
# Install/configure mongodb driver
RUN wget -qO - ${MONGO_HADOOP_URL} | tar -xz -C /usr/local/ \
    && mv /usr/local/mongo-hadoop-${MONGO_HADOOP_COMMIT} /usr/local/mongo-hadoop \
    && cd /usr/local/mongo-hadoop \
    && ./gradlew jar

# install python mongo
RUN bash -c '. activate python2 && conda install pymongo=3.0.3'

# Set spark config file
RUN echo "spark.driver.extraClassPath   ${CLASSPATH}" > $SPARK_HOME/conf/spark-defaults.conf
RUN echo "export SPARK_DRIVER_MEMORY=\"2g\"" > $SPARK_HOME/conf/spark-env.sh

USER jovyan

RUN jq --arg v "$CONDA_DIR/envs/python2/bin/python" \
        '.["env"]["PYSPARK_DRIVER_PYTHON"]=$v' \
        $CONDA_DIR/share/jupyter/kernels/python2/kernel.json > /tmp/kernel.json && \
        mv /tmp/kernel.json $CONDA_DIR/share/jupyter/kernels/python2/kernel.json
