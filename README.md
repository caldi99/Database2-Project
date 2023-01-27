# Database2-Project
This repository is carried out by group **NBA-CPS** at the University of Padua as a homework of the [Database 2](https://iiia.dei.unipd.it/education/database-2/) course.
The homework consists in developing an **Ontology** related to the NBA world (players, teams, matches...) from 2004 to 2022. The Ontology will be then imported
into **GraphDB** and some **SPARQL** queries will be run to obtain data.

## Overview ##
* [Group Members](#group-members)
* [Datasets](#datasets)
* [Data Ingestion](#data-ingestion)
* [Web Application](#web-application)
    * [Web Application Description](#web-application-description)
    * [Preliminary Steps](#preliminary-steps)
    * [Web Application Execution](#web-application-execution)
* [Queries](#queries)
    

## Group members ##
| Surname       | Name          | ID            |
| ------------- | ------------- | ------------- |
| Caldivezzi	| Francesco	    | 2037893	    |
| Pasin		    | Andrea	    | 2041605       |
| Singh	        | Harjot	    | 2053081	    |

## Datasets ##
The datasets used for this project are : 
* [NBA Players](https://www.kaggle.com/datasets/justinas/nba-players-data)
* [NBA games data](https://www.kaggle.com/datasets/nathanlauga/nba-games?select=games_details.csv)

Notice that, those two datasets are **open** datasets. Moreover, only part of the `.csv` files have been pre-processed in order to avoid **NULL** values during the **Data Ingestion** phase.

## Data Ingestion ##
The **Data Ingestion** code, that processes the dataset can be found under the directory `data_ingestion`.  
In order to execute the **Data Ingestion** code follow these steps :
- Create a folder called `serialization` folder : 
    - `mkdir ./serialization`.
- Make sure that, **rdflib** and **pandas** libraries are installed, if not, execute the following commands to install them :
    - `cd data_ingestion`.
    - `pip install -r requirments.txt`.
- Execute the `main.py` file : `python3 main.py`.

The above steps can be skipped by downloading the `.ttl` files directly from this [link](https://mega.nz/file/pFdgxRCJ#uzAVPhZT2zl6_ToRT9f_lNLKRltx3C4-JcobGIK_u2E).
Notice that, those files downloaded must be **placed** under the `serialization` folder created at the **beginning**.

## Web Application ##
This project contains a **Web Application** under the directory `flutter_web_app` developed with **Flutter** Open-Source Framework, **GraphDB** and the use of **Docker** and **Docker-Compose**.
Notice that, in a production environment, it is better to use the State-Of-The-Art orchestrator that is, [Kubernetes](https://kubernetes.io/) provided by Google.

### Web Application Description ###
This project uses **Docker** and **Docker Compose** to run the **GraphDB** server and the Web-App **backend** by means of separated containers. This was done to have a common working environment avoiding incompatibilities that could rise up from our host machines and, also, in a production environment, the various part would be effectively separated granting more flexibility.
The `docker-compose.ylm` can be found in the root of the project and orchestrate the two **containers** : 
- **GraphDB** container that represents the database.
- **backend** container that manages the **requests** coming from the Web Application and forwards them to the GraphDB container.

In particular, the GraphDB container uses a the **khaller/graphdb-free** docker image while, the backend container uses an **Ubuntu 20.04** docker image.

### Preliminary Steps ###
**Before** executing the Web Application make sure that :
- there **exists** a folder called `config` in the root of the project containing the file `config.ttl`, if the directory is not present create it i.e. `mkdir config` ,and, if the file is not present download it from this [link](https://mega.nz/file/kZcHyaQR#gBiyU2oQpGW2MjP9YRv3Tqg0GT2-QqosEzf1iXtqJ-c) and place it inside the folder.
- there **exists** a folder called `ontology` in the root of the project containing the file `ontology.owl`, if the directory is not present create it i.e. `mkdir ontology` ,and, if the file is not present download it from this [link](https://mega.nz/file/hZUCzarB#Ig2C30tArp5OKSoRYcmHzdH3rLK742F2UMAiHvTk_bI) and place it inside the folder.
- the previous steps for **Data Ingestion** were executed.
- [Docker](https://www.docker.com/) is installed in the machine from which you are trying to execute the code.
- the Web Application has been **built** ; the built web application should be found under the `flutter_web_app/build/web directory` , if not :
    - check if [Flutter](https://flutter.dev/) is installed in the machine from which you are trying to execute the code.
    - go inside the `flutter_web_app` folder i.e. `cd flutter_web_app`.
    - **build** the web application :
        ```
        flutter build web
        ```
### Web Application Execution ###
In order to execute the Web Application follow these steps :
- In the **root** of the project **execute** : 
    ```
    sudo docker compose up
    ```
- Open a new tab on a browser and go to http://localhost:8080

## Queries ##
You can see the performed queries both in our Web-Application and in the file `queries.txt` . In both cases, we provide a brief explanation of the aim of each query.