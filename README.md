# Database2-Project
This repository is carried out by group **NBA-CPS** at the University of Padua as a homework of the [Database 2](https://iiia.dei.unipd.it/education/database-2/) course.
The homework consists in developing an **Ontology** related to the NBA world (players, teams, matches...) from 2004 to 2022. The Ontology will be then imported
into GraphDB and some SPARQL queries will be run to obtain data.

## Overview ##
* [Group Members](#group-members)
* [Datasets](#datasets)
* [Data Ingestion](#data-ingestion)
* []
* []

## Group members ##
| Surname       | Name          | ID            |
| ------------- | ------------- | ------------- |
| Caldivezzi	| Francesco	    | 2037893	    |
| Pasin		    | Andrea	    | 2041605       |
| Singh	        | Harjot	    | 2053081	    |

## Datasets ##
The dataset used for this project are : 
* [NBA Players](https://www.kaggle.com/datasets/justinas/nba-players-data)
* [NBA games data](https://www.kaggle.com/datasets/nathanlauga/nba-games?select=games_details.csv)

Notice that, those two datasets are **open** datasets. Moreover, only part of the `.csv` files have been pre-processed in order to avoid **NULL** values during the **Data Ingestion** phase.

## Data Ingestion ##
The **Data Ingestion** code, that process the dataset can be found under the directory `data-ingestion`.  
In order to execute the **Data Ingestion** code follow these steps :
- Create a folder called `serialization` inside the `code` folder : 
    - `mkdir ./data-ingestion/serialization`.
- Create a folder called `zip` inside the `code` folder : 
    - `mkdir ./data-ingestion/zip`.
- Make sure that, **rdflib** and **pandas** libraries are installed, if not, execute the following commands to install them :
    - `cd data-ingestion`.
    - `pip install -r requirments.txt`.
- Execute the `main.py` file : `python3 main.py`.

The above steps can be skipped by downloading the `.ttl` files directly from this [link](https://mega.nz/file/pFdgxRCJ#uzAVPhZT2zl6_ToRT9f_lNLKRltx3C4-JcobGIK_u2E).

## Installation Istructions ##
We used Docker to run our GraphDB server and our Web-App backend by means of separated containers. This was done to have a common working environment avoiding incompatibilities that could rise up from our host machines.
Also in a production environment, the various part would be effectively separated granting more flexibility.

### Web-App backend ###
The Docker container used can be found ...
It's necessary to copy the 'build/web' folder inside of it. Once done, just run the backend script with the following command to startup a basic http server:
```
python3 scriptname.py
```

### GraphDB ###
The GraphDB docker container used can be found [here](https://hub.docker.com/r/khaller/graphdb-free) . 
To download the image just type the following command:
```
sudo docker pull khaller/graphdb-free
```

It's necessary to create a GraphDB repository inside of it to make it work. To create it...

### Container orchestrator ###
We used [Docker Compose](https://github.com/docker/compose) as orchestrator. Docker Compose is suited for testing purposes. In a production environment the State-Of-The-Art orchestrator is Kubernetes provided by Google.
To install Docker Compose on Ubuntu you just have to open the terminal and type the following commands:

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

Now you can verify if the installation went correctly by typing in the terminal the following command:
```
docker-compose --version
```
This should show the Docker Compose version installed.

Once both Docker and Docker Compose have been installed, just run the 'docker-compose.yml' file by opening the terminal to the file location and typing the following command:
```
docker compose up
```
