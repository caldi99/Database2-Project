"""
    Author : Francesco Caldivezzi
"""

from data_ingestion.utils.helper import Helper
from rdflib import Namespace
from rdflib import Graph
from rdflib import URIRef
from rdflib import RDF
from rdflib import Literal
from rdflib.namespace import XSD
from pathlib import Path

# --------------------------------------------------------------------------
# Create helper object
# --------------------------------------------------------------------------
helper = Helper()

# --------------------------------------------------------------------------
# Read games.csv file
# --------------------------------------------------------------------------
print("READING DATA FROM CSV FILE ..")
game_csv_path = helper.get_csv_path("games")
game_details_csv_path = helper.get_csv_path("games_details")
game_dataframe = helper.read_csv(game_csv_path, ",")
game_details_dataframe = helper.read_csv(game_details_csv_path,",")

# --------------------------------------------------------------------------
# Drop NA values
# --------------------------------------------------------------------------
print("DROP NA VALUES ..")
game_dataframe = game_dataframe.dropna()

# --------------------------------------------------------------------------
# Restrict game_dataframe to only GAME_ID
# --------------------------------------------------------------------------
game_dataframe = game_dataframe[['GAME_ID']]

# --------------------------------------------------------------------------
# Join two dataframe
# --------------------------------------------------------------------------
merged_dataframe = game_details_dataframe.merge(game_dataframe, how='inner',on='GAME_ID')

print(merged_dataframe.info())
# --------------------------------------------------------------------------
# Construct Game Ontology Namespace
# --------------------------------------------------------------------------
print("CREATING NAMESPACES OF THE ONTOLOGY ..")
GAME = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/Game#")
BASE = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/")
APPEARANCE = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/Appearance#")

# --------------------------------------------------------------------------
# Create the graph
# --------------------------------------------------------------------------
print("INITILIAZING THE GRAPH ..")
graph = Graph()

# --------------------------------------------------------------------------
# Bind namespaces to a prefix for a better output
# --------------------------------------------------------------------------
print("BINDING NAMASPACES TO PREFIXES ..")
graph.bind("game",GAME)
graph.bind("base",BASE)
graph.bind("appearance",APPEARANCE)

# --------------------------------------------------------------------------
# Create triples and populate the graph
# --------------------------------------------------------------------------
print("POPULATING THE GRAPH ..")
for index, row in merged_dataframe.iterrows():
    #Subject 
    appearance_game_subject_uri = URIRef(APPEARANCE + row[index])

    #Predicate
    appearance_game_predicate_uri = URIRef(BASE + "playIn")

    #Object
    appearance_game_object_uri = URIRef(GAME + row['GAME_ID'])

    #Add to graph
    graph.add((appearance_game_subject_uri,appearance_game_predicate_uri,appearance_game_object_uri))


# --------------------------------------------------------------------------
# Serialize the graph
# --------------------------------------------------------------------------
print("SERIALIZING ..")
serialization_path=str(Path(__file__).parent.resolve())+"/serialization/appearance_game_join.ttl"
helper.serialize(graph, serialization_path)