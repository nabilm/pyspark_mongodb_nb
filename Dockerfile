# Copyright (c) Mohamed Nabil HAfez.
# Distributed under the terms of the Modified BSD License.

# Locking the jupyter/pyspark-notebook image version to latest tested release to avoid any unexpected updates, this
# should be upgraded manually when newer images are released and tested
FROM jupyter/pyspark-notebook:72cca2a7f3ea

USER root

# Util to help with kernel spec later
RUN apt-get -y update && apt-get -y install jq && apt-get clean && rm -rf /var/lib/apt/lists/*


# Spark dependencies
ENV APACHE_SPARK_VERSION 2.1.0
RUN apt-get -y update && \
    apt-get -y install default-jdk python-setuptools build-essential python-dev python-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN bash -c '. activate python2 && pip install pymongo==3.4'

# Install mongodb-hadoop dependencies
ENV SPARK_HOME /usr/local/spark
ENV MONGO_SPARK_PATH /usr/local/mongo-spark
ENV JARS org.mongodb.spark:mongo-spark-connector_2.11:2.0.0
ENV CLASSPATH ${MONGO_SPARK_PATH}/mongo-spark-connector_2.11-2.0.0.jar
# Manually setting PYSPARK_PYTHON for workers to use python2 (https://github.com/jupyter/docker-stacks/issues/231)
ENV PYSPARK_PYTHON $CONDA_DIR/envs/python2/bin/python
# Install/configure mongodb driver
ENV MONGO_SPARK_URL http://repo1.maven.org/maven2/org/mongodb/spark/mongo-spark-connector_2.11/2.0.0/mongo-spark-connector_2.11-2.0.0.jar
# Install/configure mongodb driver
RUN cd /usr/local/  && \
        mkdir ${MONGO_SPARK_PATH} && \
        cd ${MONGO_SPARK_PATH} && \
        wget  ${MONGO_SPARK_URL}

# Set spark config file
RUN echo "spark.jars.packages ${JARS}" >> $SPARK_HOME/conf/spark-defaults.conf
RUN echo "export SPARK_DRIVER_MEMORY=\"1g\"" >> $SPARK_HOME/conf/spark-env.sh

ENV PYSPARK_DRIVER_PYTHON /usr/local/bin/jupyter
ENV PYSPARK_DRIVER_PYTHON_OPTS " --NotebookApp.open_browser=False --NotebookApp.ip='*' --NotebookApp.port=8888 --NotebookApp.password='' --NotebookApp.token=''"

RUN mkdir /pyspark
RUN chown $NB_USER /pyspark
USER $NB_USER
WORKDIR /pyspark
ENV GRANT_SUDO "True"
ENTRYPOINT ["tini", "--"]
CMD ["start-notebook.sh"," --NotebookApp.open_browser=False --NotebookApp.ip='*' --NotebookApp.port=8888 --NotebookApp.password='' --NotebookApp.token=''"]
