from data_ingestion.utils.helper import Helper
from rdflib import Namespace,Graph,URIRef,RDF,Literal
from rdflib.namespace import XSD
import math,pathlib
import re

# Defining constants to keep things organized
ONTOLOGY_URI="https://www.dei.unipd.it/Database2/CPS-NBA/"
PLAYER_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Player#"
COUNTRY_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Country#"
PLAYER_BORN="wasBornIn"

# Creating the Namespaces that will be used for the triples and creating the graph   
BASE= Namespace(ONTOLOGY_URI)
PLAYER = Namespace(PLAYER_CLASS_URI)    
COUNTRY = Namespace(COUNTRY_CLASS_URI)

# Creating the Graph and binding URIs to it
graph = Graph()
graph.bind("player",PLAYER)
graph.bind("country",COUNTRY)
graph.bind("nba-cps",BASE)

# Instanciating the helper class
helper=Helper()


# Adds to the graph the triples related to the Player with the country where he/she was born
def process_born_in(players_path,players_details_path):
    print("processing \'wasBornIn\'...")
    # Getting the dataframe from the .csv file containing the players with their caractheristics (height,weight...)
    players_details_df = helper.read_csv(players_details_path, ",")
    players_details_df = players_details_df[players_details_df['season'] > str("2003-04")]
    players_details_df = players_details_df[players_details_df['season'] < str("2021-22")]
    players_details_df = players_details_df.drop_duplicates(subset='player_name', keep="first")
    players_details_df = players_details_df[['player_name', 'country']]

    # Getting the dataframe from the .csv file containing the players with their ids
    players_df = helper.read_csv(players_path, ",")
    players_df = players_df.drop_duplicates(subset=['PLAYER_ID'], keep="first")
    players_df = players_df.rename(columns={'PLAYER_NAME': 'player_name','PLAYER_ID': 'player_id'})
    players_df = players_df[['player_name','player_id']]

    # Merging the dataframes to obtain the final dataframe of players with their properties
    players_complete_df = players_df.merge(players_details_df, how='left',on='player_name')
    players_complete_df = players_complete_df.sort_values(by='player_name')
    players_complete_df = players_complete_df.reset_index(drop=True)

    # Adding to graph the triples of type 'player bornIn country'
    for index,row in players_complete_df.iterrows():
        player_id=row['player_id']
        
        player_country=row['country']
        player_subj_uri = URIRef(PLAYER + str(player_id))
        country_obj_uri= URIRef(COUNTRY+ re.sub(r'\W+', '', str(player_country)))
        graph.add((player_subj_uri, BASE[PLAYER_BORN], country_obj_uri))

    
    serialization_path=str(pathlib.Path(__file__).parent.resolve())+"/serialization/player_country_join.ttl"
    print("serializing...")

    # Serializing the graph to a .ttl file
    helper.serialize(graph, serialization_path)

players_details_path=helper.get_csv_path('players_details')
players_path=helper.get_csv_path('players')

process_born_in(players_path,players_details_path)