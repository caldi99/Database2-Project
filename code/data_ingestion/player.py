from data_ingestion.utils.helper import Helper
from rdflib import Namespace,Graph,URIRef,RDF,Literal
from rdflib.namespace import XSD
import math,pathlib
import re


# Defining constants to keep things organized
ONTOLOGY_URI="https://www.dei.unipd.it/Database2/CPS-NBA/"
PLAYER_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Player#"
PLAYER_NAME="name"
PLAYER_DRAFT_YEAR="draftYear"
PLAYER_HEIGHT="height"
PLAYER_WEIGHT="weight"

# Creating the Namespaces that will be used for the triples and creating the graph   
BASE= Namespace(ONTOLOGY_URI)
PLAYER = Namespace(PLAYER_CLASS_URI)    

# Creating the Graph and binding URIs to it
graph = Graph()
graph.bind("player",PLAYER)
graph.bind("nba-cps",BASE)

# Instanciating the helper class
helper=Helper()


# Adds to the graph the triples related to the Player with its Data-Properties
def process_players(players_path,players_details_path):
    print("processing \'Player\'...")
    # Getting the dataframe from the .csv file containing the players with their caractheristics (height,weight...)
    players_details_df = helper.read_csv(players_details_path, ",")
    players_details_df = players_details_df[players_details_df['season'] > str("2003-04")]
    players_details_df = players_details_df[players_details_df['season'] < str("2021-22")]
    players_details_df = players_details_df[['player_name', 'player_height', 'player_weight','draft_year']]

    # Getting the dataframe from the .csv file containing the players with their ids
    players_df = helper.read_csv(players_path, ",")
    players_df = players_df.drop_duplicates(subset='PLAYER_ID', keep="first")
    players_df = players_df.rename(columns={'PLAYER_NAME': 'player_name','PLAYER_ID': 'player_id'})
    players_df = players_df[['player_name','player_id']]

    # Merging the dataframes to obtain the final dataframe of players with their properties
    players_complete_df = players_df.merge(players_details_df, how='left',on='player_name')
    players_complete_df = players_complete_df.sort_values(by='player_name')
    players_complete_df = players_complete_df.reset_index(drop=True)
    
    # Iterating over the players to create the triples to be added to the graph
    i=0
    while i<len(players_complete_df):
        player_name=players_complete_df.loc[i, "player_name"]
        player_id=players_complete_df.loc[i, "player_id"]
        player_weight=players_complete_df.loc[i, "player_weight"]
        player_height=players_complete_df.loc[i, "player_height"]
        player_draft_year=players_complete_df.loc[i, "draft_year"]

        # The following while loop is used to calculate averages of heights and weights over the years for a given player
        n_col=1
        k=i+1
        while k<len(players_complete_df):
            if(player_name==players_complete_df.loc[k, "player_name"]):
                if(math.isnan(player_weight) or math.isnan(player_height)):
                    k+=1
                    continue
                    
                player_weight+=players_complete_df.loc[i, "player_weight"]
                player_height+=players_complete_df.loc[i, "player_height"]
                n_col+=1
            else:
                break
            k+=1
        
        if(not math.isnan(player_weight) and not math.isnan(player_height)):
            player_weight/=n_col
            player_height/=n_col
        
        # Adding the rdf triples to the graph
        player_subj_uri = URIRef(PLAYER + str(player_id))
        graph.add((player_subj_uri, RDF.type, URIRef(BASE.Player)))
        graph.add((player_subj_uri, BASE[PLAYER_NAME], Literal(player_name, lang="en")))
        
        if(str(player_draft_year)!="Undrafted"):
            graph.add((player_subj_uri, BASE[PLAYER_DRAFT_YEAR], Literal(player_draft_year, datatype = XSD.integer)))

        if(not math.isnan(player_weight) and not math.isnan(player_height)):
            player_weight/=n_col
            player_height/=n_col
            graph.add((player_subj_uri, BASE[PLAYER_WEIGHT], Literal(player_weight, datatype = XSD.float)))
            graph.add((player_subj_uri, BASE[PLAYER_HEIGHT], Literal(player_height, datatype = XSD.float)))
       
        i=k

    serialization_path=str(pathlib.Path(__file__).parent.resolve())+"/serialization/players.ttl"
    print("serializing...")

    # Serializing the graph to a .ttl file
    helper.serialize(graph, serialization_path)


players_details_path=helper.get_csv_path('players_details')
players_path=helper.get_csv_path('players')

process_players(players_path,players_details_path)