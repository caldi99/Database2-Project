"""
    Author : Francesco Caldivezzi
"""

from data_ingestion_code.utils.helper import Helper
from rdflib import Namespace
from rdflib import Graph
from rdflib import URIRef
from pathlib import Path
import re

# --------------------------------------------------------------------------
# Create helper object
# --------------------------------------------------------------------------
helper = Helper()

# --------------------------------------------------------------------------
# Read games.csv file
# --------------------------------------------------------------------------
print("READING DATA FROM CSV FILE ..")
club_arena_csv_path = helper.get_csv_path("clubs")
club_arena_dataframe = helper.read_csv(club_arena_csv_path, ",")

# --------------------------------------------------------------------------
# Print info of dataframe
# --------------------------------------------------------------------------
print(club_arena_dataframe.info())

# --------------------------------------------------------------------------
# Construct Game Ontology Namespace
# --------------------------------------------------------------------------
print("CREATING NAMESPACES OF THE ONTOLOGY ..")
ARENA = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/Arena#")
CLUB = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/Club#")
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
graph.bind("arena",ARENA)
graph.bind("club",CLUB)
graph.bind("base",BASE)

# --------------------------------------------------------------------------
# Create triples and populate the graph
# --------------------------------------------------------------------------
print("POPULATING THE GRAPH ..")
for index, row in club_arena_dataframe.iterrows():
    #Subject
    club_arena_subject_uri = URIRef(CLUB + str(row['TEAM_ID']))
    
    #Predicate
    club_arena_predicate_uri = URIRef(BASE + "hasStadium")

    #Object
    club_arena_object_uri = URIRef(ARENA + str(re.sub(r'\W+', '', row['ARENA'])))   

    #Add Triples
    graph.add((club_arena_subject_uri, club_arena_predicate_uri ,club_arena_object_uri))  

# --------------------------------------------------------------------------
# Serialize the graph
# --------------------------------------------------------------------------
print("SERIALIZING ..")
serialization_path=str(Path(__file__).resolve().parent.parent)+"/serialization/club_arena_join.ttl"
helper.serialize(graph, serialization_path)