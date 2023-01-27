"""
    Author : Francesco Caldivezzi
"""

from data_ingestion_code.utils.helper import Helper
from rdflib import Namespace
from rdflib import Graph
from rdflib import URIRef
from pathlib import Path

helper = Helper()

# --------------------------------------------------------------------------
# Read games.csv and games_details.csv file
# --------------------------------------------------------------------------
print("READING DATA FROM CSV FILE ..")
game_csv_path = helper.get_csv_path("games")
game_dataframe = helper.read_csv(game_csv_path, ",")

game_detail_csv_path = helper.get_csv_path("games_details")
game_detail_dataframe = helper.read_csv(game_detail_csv_path, ",")

# --------------------------------------------------------------------------
# Drop NA values
# --------------------------------------------------------------------------
print("DROP NA VALUES ..")
game_dataframe = game_dataframe.dropna()

# --------------------------------------------------------------------------
# Merge two dataframes
# --------------------------------------------------------------------------
print("MERGING TWO DATAFRAMES ..")
merged_dataframe = game_dataframe.merge(game_detail_dataframe, how='left',on='GAME_ID')[
    ['GAME_ID','PLAYER_ID','SEASON','START_POSITION','MIN','FGM','FGA','FG_PCT','FG3M',
    'FG3A','FG3_PCT','FTM','FTA','FT_PCT','OREB','DREB','REB','AST','STL','BLK','TO','PTS','PF']] 

# --------------------------------------------------------------------------
# Convert to correct type columns
# --------------------------------------------------------------------------
print("CONVERT TO CORRECT TYPE COLS ..")
merged_dataframe['MIN'] = merged_dataframe['MIN'].astype(str)

game_dataframe.info()
game_detail_dataframe.info()
merged_dataframe.info()

# --------------------------------------------------------------------------
# Construct Appearance Ontology Namespace
# --------------------------------------------------------------------------
print("CREATING NAMESPACES OF THE ONTOLOGY ..")
APPEARANCE = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/Appearance#")
BASE = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/")
GAME = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/Game#")

# --------------------------------------------------------------------------
# Create the graph
# --------------------------------------------------------------------------
print("INITILIAZING THE GRAPH ..")
graph = Graph()

# --------------------------------------------------------------------------
# Bind namespaces to a prefix for a better output
# --------------------------------------------------------------------------
print("BINDING NAMASPACES TO PREFIXES ..")
graph.bind("appearance",APPEARANCE)
graph.bind("base",BASE)
graph.bind("game",GAME)

# --------------------------------------------------------------------------
# Create triples and populate the graph
# --------------------------------------------------------------------------
for index,row in merged_dataframe.iterrows():
    #Subject
    appearance_game_subject_uri = URIRef(APPEARANCE + str("{}_{}_{}_{}".format(row['GAME_ID'],row['PLAYER_ID'],row['SEASON'],row['SEASON'] + 1)))
        
    #Predicate
    appearance_game_predicate_uri = URIRef(BASE + "refersTo")

    #Object
    appearance_game_object_uri = URIRef(GAME + str(row['GAME_ID']))

    #Add to graph
    graph.add((appearance_game_subject_uri,appearance_game_predicate_uri,appearance_game_object_uri))
               
# --------------------------------------------------------------------------
# Serialize the graph
# --------------------------------------------------------------------------
print("SERIALIZING ..")
serialization_path=str(Path(__file__).resolve().parent.parent)+"/serialization/appearance_game_join.ttl"
helper.serialize(graph, serialization_path)
