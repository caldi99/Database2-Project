"""
    Author : Andrea Pasin, Francesco Caldivezzi
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
player_csv_path = helper.get_csv_path("players")
player_dataframe = helper.read_csv(player_csv_path, ",")

player_detail_path = helper.get_csv_path("players_details")
player_detail_dataframe = helper.read_csv(player_detail_path,",")

club_csv_path = helper.get_csv_path("clubs")
club_dataframe = helper.read_csv(club_csv_path,",")

# --------------------------------------------------------------------------
# Rename fields, select correct interval of seasons
# --------------------------------------------------------------------------
print("RENAMING FIELDS ..")
club_dataframe = club_dataframe.rename(columns={'ABBREVIATION':'team_abbreviation'})
player_detail_dataframe = player_detail_dataframe[player_detail_dataframe['season'] >= str("2003-04")]
player_detail_dataframe = player_detail_dataframe[player_detail_dataframe['season'] <= str("2021-22")]
player_detail_dataframe = player_detail_dataframe[['player_name', 'player_height', 'player_weight','draft_year','season','team_abbreviation']]
player_dataframe = player_dataframe.rename(columns={'PLAYER_NAME': 'player_name','PLAYER_ID': 'player_id'})
player_dataframe = player_dataframe[['player_name','player_id']]

# --------------------------------------------------------------------------
# Merge Dataframes
# --------------------------------------------------------------------------
print("MERGINIG DATAFRAMES ..")
players_complete_df = player_dataframe.merge(player_detail_dataframe, how='inner',on='player_name').drop_duplicates()
merged = players_complete_df.merge(club_dataframe,how='inner',on='team_abbreviation').drop_duplicates()

merged.info()

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

for index, row in merged.iterrows():
    
    #Subject
    player_club_subject_uri = URIRef(PLAYER + str("{}_{}_{}".format(row['player_id'],row['season'].split('-')[0],int(row['season'].split('-')[0]) + 1)))
    
    #Predicate
    player_club_predicate_uri = URIRef(BASE + "playedFor")

    #Object
    player_club_object_uri = URIRef(CLUB + str(row['TEAM_ID']))

    graph.add((player_club_subject_uri,player_club_predicate_uri,player_club_object_uri))

# --------------------------------------------------------------------------
# Serialize the graph
# --------------------------------------------------------------------------
print("SERIALIZING ..")
serialization_path=str(Path(__file__).resolve().parent.parent)+"/serialization/player_club_join.ttl"
helper.serialize(graph, serialization_path)


    








