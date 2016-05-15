Docker machine contents:

 - pyspark 1.6.0
 - Conda
 - jubyter notebook
 - mongodb-hadoop driver 1.5.1


How to start the docker machine?
---------------------------------
    1- Clone the repo

    2- Build the docker machine from the repo directory by:
            $ sudo docker build --build-arg -t yaoota_pyspark_mongo_nb .

    3- Create shared directory on you host
            $ sudo mkdir /pyspark
    3- Execute:
            $ sudo docker run -d -p 8888:8888 -p 4040:4040 -p 4041:4041 -v /pysprak/:/pyspark pyspark_mongo_nb

    note:
        - You can access the jupyter notebook on http://localhost:8888
        - You can access spark UI using http://localhost:4040

To Access the docker machine using normal user you need to execute:
-------------------------------------------------------------------
    $ sudo docker ps # to know the id of the docker container

    $ sudo docker exec -i -t container-id /bin/bash

To access the docker machine using root user you need to execute:
-----------------------------------------------------------------
    $ sudo docker exec -i -u 0 -t container-id /bin/bash

Note That : The docker machine is based on jupyter pyspark-notebook
    https://github.com/jupyter/docker-stacks/tree/master/pyspark-notebook