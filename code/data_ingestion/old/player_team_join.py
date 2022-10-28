from data_ingestion.utils.helper import Helper
from rdflib import Namespace,Graph,URIRef,RDF,Literal
from rdflib.namespace import XSD
import math,pathlib
import re

# Defining constants to keep things organized
ONTOLOGY_URI="https://www.dei.unipd.it/Database2/CPS-NBA/"
PLAYER_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Player#"
COUNTRY_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Country#"
TEAM_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Team#"
PLAYER_TEAM="playsIn"

# Creating the Namespaces that will be used for the triples and creating the graph   
BASE= Namespace(ONTOLOGY_URI)
PLAYER = Namespace(PLAYER_CLASS_URI)    
TEAM = Namespace(TEAM_CLASS_URI)

# Creating the Graph and binding URIs to it
graph = Graph()
graph.bind("player",PLAYER)
graph.bind("nba-cps",BASE)
graph.bind("team",TEAM)

# Instanciating the helper class
helper=Helper()


# Adds to the graph the triples related to the Player playing for a team on a given year
def process_plays_in(players_path):
    print("processing \'playsIn\'...")
    players_df = helper.read_csv(players_path, ",")
    for i,row in players_df.iterrows():
        player_id=row["PLAYER_ID"]
        season=row["SEASON"]
        team_id=row["TEAM_ID"]
        player_subj_uri = URIRef(PLAYER + str(player_id))
        team_obj_uri= URIRef(TEAM+ str(team_id)+"_"+str(season))
        graph.add((player_subj_uri, BASE[PLAYER_TEAM], team_obj_uri))

    
    serialization_path=str(pathlib.Path(__file__).parent.resolve())+"/serialization/player_team_join.ttl"
    print("serializing...")

    # Serializing the graph to a .ttl file
    helper.serialize(graph, serialization_path)

players_details_path=helper.get_csv_path('players_details')
players_path=helper.get_csv_path('players')

process_plays_in(players_path,players_details_path)