# Database2-Project
This repository is carried out by group NBA-CPS at the University of Padua as a homework of the [Database 2](https://iiia.dei.unipd.it/education/database-2/) course.
The homework consists in developing an Ontology related to the NBA world (players, teams, matches...) from 2004 to 2019. The Ontology will be then imported
into GraphDB and some SPARQL queries will be run to obtain data.

## Group members ##
| Surname       | Name          | ID            |
| ------------- | ------------- | ------------- |
| Caldivezzi	| Francesco	    | 2037893	    |
| Pasin		    | Andrea	    | 2041605       |
| Singh	        | Harjot	    | 2053081	    |


## Datasets ##
We have used the following open datasets that have been created using the NBA Stats API:
* [NBA Players](https://www.kaggle.com/datasets/justinas/nba-players-data)
* [NBA games data](https://www.kaggle.com/datasets/nathanlauga/nba-games?select=games_details.csv)
We took only part of the .csv files and we pre-processed the data to avoid having NULL values during the data-ingestion phase.
