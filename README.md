Docker machine contents:

 - PySpark 1.6.1
 - Conda
 - Jupyter Notebook
 - mongodb-hadoop driver 1.5.2


How to start the docker machine?
---------------------------------
    1- Clone the repo

    2- Build the docker machine from the repo directory by:
            $ sudo docker build -t pyspark_mongo_nb .

    3- Create shared directory on you host
            $ sudo mkdir /pyspark
    3- Execute:
            $ sudo docker run -d -p 8888:8888 -p 4040:4040 -p 4041:4041 -v /pysprak/:/pyspark --name pyspark_mongo_nb pyspark_mongo_nb

    note:
        - You can access the jupyter notebook on http://localhost:8888
        - You can access spark UI using http://localhost:4040

To Access the docker machine using normal user you need to execute:
-------------------------------------------------------------------
    $ sudo docker exec -i -t pyspark_mongo_nb /bin/bash

To access the docker machine using root user you need to execute:
-----------------------------------------------------------------
    $ sudo docker exec -i -u 0 -t pyspark_mongo_nb /bin/bash

Download using docker hub
--------------------------
    $ sudo docker pull nabilm/pyspark_mongo_nb
    
 
Test that things are working
----------------------------
To use Spark in a Python 3 notebook, add the following code at the start of the notebook:
```
import os
# make sure pyspark tells workers to use python3
os.environ['PYSPARK_PYTHON'] = '/opt/conda/bin/python3'
```
Run the [Using Spark Local Mode](https://github.com/jupyter/docker-stacks/tree/master/pyspark-notebook#using-spark-local-mode) tutorial to test that everything is working

**Note That**: The docker machine is based on [jupyter/pyspark-notebook](https://github.com/jupyter/docker-stacks/tree/master/pyspark-notebook)
