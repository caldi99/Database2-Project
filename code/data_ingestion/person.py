from data_ingestion.utils.helper import Helper
from rdflib import Namespace,Graph,URIRef,RDF,Literal
from rdflib.namespace import XSD
import math,pathlib
import re

# Defining constants to keep things organized
ONTOLOGY_URI="https://www.dei.unipd.it/Database2/CPS-NBA/"
PERSON_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Person#"
PERSON_NAME="name"

# Creating the Namespaces that will be used for the triples and creating the graph   
BASE= Namespace(ONTOLOGY_URI)
PERSON = Namespace(PERSON_CLASS_URI)

# Creating the Graph and binding URIs to it
graph = Graph()
graph.bind("person",PERSON)
graph.bind("nba-cps",BASE)

# Instanciating the helper class
helper=Helper()


# Adds to the graph the triples related to the Player with the country where he/she was born
def process_person(players_path):
    print("processing \'Person\'...")

    # Getting the dataframe from the .csv file containing the players with their ids
    players_df = helper.read_csv(players_path, ",")
    players_df = players_df[['player_name','player_id']]

    # Adding to graph the triples of type 'player bornIn country'
    for index,row in players_df.iterrows():
        player_id=row['player_id']
        player_name=row['player_name']
        
        player_subj_uri = URIRef(PERSON + str(player_id))
        graph.add((player_subj_uri, XSD.type, BASE.Person))
        graph.add((player_subj_uri, BASE[PERSON_NAME], Literal(str(player_name),type=XSD.string)))

    
    serialization_path=str(pathlib.Path(__file__).parent.resolve())+"/serialization/person.ttl"
    print("serializing...")

    # Serializing the graph to a .ttl file
    helper.serialize(graph, serialization_path)

players_details_path=helper.get_csv_path('players_details')
players_path=helper.get_csv_path('players')

process_person(players_path)