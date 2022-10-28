"""
    Author : Andrea Pasin
"""

from data_ingestion.utils.helper import Helper
from rdflib import Namespace
from rdflib import Graph
from rdflib import URIRef
from rdflib import RDF
from rdflib import Literal
from rdflib.namespace import XSD
from pathlib import Path

helper = Helper()

# --------------------------------------------------------------------------
# Read games.csv and games_details.csv file
# --------------------------------------------------------------------------
print("READING DATA FROM CSV FILE ..")
player_csv_path = helper.get_csv_path("players")
player_dataframe = helper.read_csv(player_csv_path, ",")

player_detail_path = helper.get_csv_path("players_details")
player_detail_dataframe = helper.read_csv(player_detail_path,",")

# --------------------------------------------------------------------------
# Rename columns
# --------------------------------------------------------------------------
print("RENAME COLUMNS ..")
player_detail_dataframe = player_detail_dataframe.rename(columns={'player_name': 'PLAYER_NAME'})

# --------------------------------------------------------------------------
# Merge dataframes
# --------------------------------------------------------------------------
print("MERGING TWO DATAFRAMES ..")

player_merged_dataframe = player_detail_dataframe.merge(player_dataframe, how='inner', on = 'PLAYER_NAME')[
    ['PLAYER_ID','PLAYER_NAME','TEAM_ID','season']].rename(columns = {'season':'SEASON'}).drop_duplicates()

# --------------------------------------------------------------------------
# Filter Seasons 
# --------------------------------------------------------------------------
player_merged_dataframe = player_merged_dataframe[player_merged_dataframe['SEASON'] >= '2003-04']

player_merged_dataframe.info()

# --------------------------------------------------------------------------
# Construct Club Ontology Namespace
# --------------------------------------------------------------------------
print("CREATING NAMESPACES OF THE ONTOLOGY ..")
CLUB = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/Club#")
PLAYER = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/Player#")
BASE = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/")

# --------------------------------------------------------------------------
# Create the graph
# --------------------------------------------------------------------------
print("INITILIAZING THE GRAPH ..")
graph = Graph()

# --------------------------------------------------------------------------
# Bind namespaces to a prefix for a better output
# --------------------------------------------------------------------------
print("BINDING NAMASPACES TO PREFIXES ..")
graph.bind("club",CLUB)
graph.bind("player",PLAYER)
graph.bind("base",BASE)

for index, row in player_merged_dataframe.iterrows():
    
    #Subject
    player_club_subject_uri = URIRef(PLAYER + str("{}_{}_{}".format(row['PLAYER_ID'],row['SEASON'].split('-')[0],int(row['SEASON'].split('-')[0]) + 1)))
    
    #Predicate
    player_club_predicate_uri = URIRef(BASE + "playedFor")

    #Object
    player_club_object_uri = URIRef(CLUB + str(row['TEAM_ID']))

    graph.add((player_club_subject_uri,player_club_predicate_uri,player_club_object_uri))

# --------------------------------------------------------------------------
# Serialize the graph
# --------------------------------------------------------------------------
print("SERIALIZING ..")
serialization_path=str(Path(__file__).parent.resolve())+"/serialization/player_club_join.ttl"
helper.serialize(graph, serialization_path)


    








