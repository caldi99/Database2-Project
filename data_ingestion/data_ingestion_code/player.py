from data_ingestion_code.utils.helper import Helper
from rdflib import Namespace,Graph,URIRef,RDF,Literal
from rdflib.namespace import XSD
import math
from pathlib import Path


# Defining constants to keep things organized
ONTOLOGY_URI="https://www.dei.unipd.it/Database2/CPS-NBA/"
PLAYER_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Player#"
PLAYER_HEIGHT="height"
PLAYER_WEIGHT="weight"
PLAYER_START_SEASON="startYear"
PLAYER_END_SEASON="endYear"

# Creating the Namespaces that will be used for the triples and creating the graph   
BASE= Namespace(ONTOLOGY_URI)
PLAYER = Namespace(PLAYER_CLASS_URI)    

# Creating the Graph and binding URIs to it
graph = Graph()
graph.bind("player",PLAYER)
graph.bind("base",BASE)

# Instanciating the helper class
helper=Helper()


# Adds to the graph the triples related to the Player with its Data-Properties
def process_players(players_path,players_details_path):
    print("processing \'Player\'...")
    # Getting the dataframe from the .csv file containing the players with their caractheristics (height,weight...)
    players_details_df = helper.read_csv(players_details_path, ",")
    players_details_df = players_details_df[players_details_df['season'] >= str("2003-04")]
    players_details_df = players_details_df[players_details_df['season'] <= str("2021-22")]
    players_details_df = players_details_df[['player_name', 'player_height', 'player_weight','draft_year','season']]

    # Getting the dataframe from the .csv file containing the players with their ids
    players_df = helper.read_csv(players_path, ",")
    players_df = players_df.rename(columns={'PLAYER_NAME': 'player_name','PLAYER_ID': 'player_id'})
    players_df = players_df[['player_name','player_id']]

    # Merging the dataframes to obtain the final dataframe of players with their properties
    players_complete_df = players_df.merge(players_details_df, how='inner',on='player_name').drop_duplicates()

    # Iterating over the players to create the triples to be added to the graph
    for index,row in players_complete_df.iterrows():
        player_id=row['player_id']
        player_weight=row['player_weight']
        player_height=row['player_height']
        season=row['season']
        start_year=int(str(season).split('-')[0])
        end_year=int(str(season).split('-')[1])+2000

        # Adding the rdf triples to the graph
        player_subj_uri = URIRef(PLAYER + str(player_id)+"_"+str(season)[0:4]+"_"+str(int(str(season)[0:4]) + 1))
        graph.add((player_subj_uri, RDF.type, URIRef(BASE.Player)))
        if(not math.isnan(player_weight) and not math.isnan(player_height)):
            graph.add((player_subj_uri, BASE[PLAYER_WEIGHT], Literal(player_weight, datatype = XSD.float)))
            graph.add((player_subj_uri, BASE[PLAYER_HEIGHT], Literal(player_height, datatype = XSD.float)))
        
        graph.add((player_subj_uri, BASE[PLAYER_START_SEASON], Literal(start_year, datatype = XSD.gYear)))
        graph.add((player_subj_uri, BASE[PLAYER_END_SEASON], Literal(end_year, datatype = XSD.gYear)))

    serialization_path=str(Path(__file__).resolve().parent.parent)+"/serialization/player.ttl"
    print("serializing...")

    # Serializing the graph to a .ttl file
    helper.serialize(graph, serialization_path)


players_details_path=helper.get_csv_path('players_details')
players_path=helper.get_csv_path('players')

process_players(players_path,players_details_path)