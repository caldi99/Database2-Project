from data_ingestion.utils.helper import Helper
from rdflib import Namespace,Graph,URIRef,RDF,Literal
from rdflib.namespace import XSD
import math,pathlib
import re

# Defining constants to keep things organized
ONTOLOGY_URI="https://www.dei.unipd.it/Database2/CPS-NBA/"
PLAYER_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Player#"
APPEARANCE_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Appearance#"
PLAYER_APPEARANCE="hasPlayedInMatch"

# Creating the Namespaces that will be used for the triples and creating the graph   
BASE= Namespace(ONTOLOGY_URI)
PLAYER = Namespace(PLAYER_CLASS_URI)
APPEARANCE = Namespace(APPEARANCE_CLASS_URI)

# Creating the Graph and binding URIs to it
graph = Graph()
graph.bind("player",PLAYER)
graph.bind("appearance",APPEARANCE)
graph.bind("nba-cps",BASE)

# Instanciating the helper class
helper=Helper()

# Adds to the graph the triples related to the Player with the corrisponding played matches
def process_has_played_in_match(players_path,match_details_path):
    print("processing \'hasPlayedInMatch\'...")
    # Getting the dataframe from the .csv file containing the match details
    match_details_df = helper.read_csv(match_details_path, ",")
    match_details_df = match_details_df[['PLAYER_ID','GAME_ID']]

    players_df = helper.read_csv(players_path, ",")
    players_df = players_df.drop_duplicates(subset=['PLAYER_ID'], keep="first")
    players_df=players_df[['PLAYER_ID']]

    players_complete_df = players_df.merge(match_details_df, how='inner',on='PLAYER_ID')

    # Adding to graph the triples of type 'player hasPlayedInMatch appearance'
    for index,row in players_complete_df.iterrows():
        player_id=row['PLAYER_ID']
        game_id=row['GAME_ID']
        player_subj_uri = URIRef(PLAYER + str(player_id))
        
        game_obj_uri= URIRef(APPEARANCE+ str(game_id)+"_"+str(player_id))
        graph.add((player_subj_uri, BASE[PLAYER_APPEARANCE], game_obj_uri))

    serialization_path=str(pathlib.Path(__file__).parent.resolve())+"/serialization/player_appearance_join.ttl"
    print("serializing...")

    # Serializing the graph to a .ttl file
    helper.serialize(graph, serialization_path)

players_path=helper.get_csv_path('players')
match_details_path=helper.get_csv_path('games_details')

process_has_played_in_match(players_path,match_details_path)