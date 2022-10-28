from data_ingestion.utils.helper import Helper
from rdflib import Namespace,Graph,URIRef,RDF,Literal
from rdflib.namespace import XSD
import math,pathlib
import re

# Defining constants to keep things organized
ONTOLOGY_URI="https://www.dei.unipd.it/Database2/CPS-NBA/"
PERSON_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Person#"
PLAYER_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Player#"
PERSON_WAS_PLAYER="wasPlayer"
PLAYER_REFERS_TO="refersTo"

# Creating the Namespaces that will be used for the triples and creating the graph   
BASE= Namespace(ONTOLOGY_URI)
PERSON = Namespace(PERSON_CLASS_URI)
PLAYER = Namespace(PLAYER_CLASS_URI)   

# Creating the Graph and binding URIs to it
graph = Graph()
graph.bind("person",PERSON)
graph.bind("nba-cps",BASE)
graph.bind("player",PLAYER)

# Instanciating the helper class
helper=Helper()


# Adds to the graph the triples related to the Player with the country where he/she was born
def process_person_join(players_path,players_details_path):
    print("processing \'wasPlayer\' and \'refersTo\'...")
    # Getting the dataframe from the .csv file containing the players with their caractheristics (height,weight...)
    players_details_df = helper.read_csv(players_details_path, ",")
    players_details_df = players_details_df[players_details_df['season'] > str("2003-04")]
    players_details_df = players_details_df[players_details_df['season'] < str("2021-22")]
    players_details_df = players_details_df[['player_name', 'player_height', 'player_weight','draft_year','season']]

    # Getting the dataframe from the .csv file containing the players with their ids
    players_df = helper.read_csv(players_path, ",")
    players_df = players_df.drop_duplicates(subset='PLAYER_ID', keep="first")
    players_df = players_df.rename(columns={'PLAYER_NAME': 'player_name','PLAYER_ID': 'player_id'})
    players_df = players_df[['player_name','player_id']]

    # Merging the dataframes to obtain the final dataframe of players
    players_complete_df = players_df.merge(players_details_df, how='left',on='player_name')
    players_complete_df = players_complete_df.sort_values(by='player_name')
    players_complete_df = players_complete_df.reset_index(drop=True)

    # Adding to graph the triples
    for index,row in players_complete_df.iterrows():
        person_id=row['player_id']
        season=row['season']
        
        person_uri = URIRef(PERSON + str(person_id))
        player_uri=URIRef(PLAYER+str(person_id)+"_"+str(season)[0:4])

        graph.add((player_uri, BASE[PLAYER_REFERS_TO], person_uri))
        graph.add((person_uri, BASE[PERSON_WAS_PLAYER], player_uri))

    
    serialization_path=str(pathlib.Path(__file__).parent.resolve())+"/serialization/person_player_join.ttl"
    print("serializing...")

    # Serializing the graph to a .ttl file
    helper.serialize(graph, serialization_path)

players_details_path=helper.get_csv_path('players_details')
players_path=helper.get_csv_path('players')

process_person_join(players_path,players_details_path)