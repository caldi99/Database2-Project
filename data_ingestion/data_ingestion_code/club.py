"""
    Author : Francesco Caldivezzi
"""

from data_ingestion_code.utils.helper import Helper
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
# Read teams.csv file
# --------------------------------------------------------------------------
print("READING DATA FROM CSV FILE ..")
club_csv_path = helper.get_csv_path("clubs")
club_dataframe = helper.read_csv(club_csv_path, ",")

# --------------------------------------------------------------------------
# Convert Cols to corret type
# --------------------------------------------------------------------------

print(club_dataframe.info())

# --------------------------------------------------------------------------
# Construct Club Ontology Namespace
# --------------------------------------------------------------------------
print("CREATING NAMESPACES OF THE ONTOLOGY ..")
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
graph.bind("club",CLUB)
graph.bind("base",BASE)

# --------------------------------------------------------------------------
# Create triples and populate the graph
# --------------------------------------------------------------------------
print("POPULATING THE GRAPH ..")
for index, row in club_dataframe.iterrows():

    club_subject = URIRef(CLUB + str(row['TEAM_ID']))    
    graph.add((club_subject, RDF.type, BASE.Club))
            
    #Nickname
    graph.add((club_subject, BASE['nickname'], Literal(row['NICKNAME'], datatype = XSD.string)))
    
    #Abbreviation
    graph.add((club_subject, BASE['abbreviation'], Literal(row['ABBREVIATION'], datatype = XSD.string)))
    
    #Year
    graph.add((club_subject, BASE['firstYear'], Literal(row['MIN_YEAR'], datatype = XSD.gYear)))

    #City
    graph.add((club_subject, BASE['city'], Literal(row['CITY'], datatype = XSD.string)))

# --------------------------------------------------------------------------
# Serialize the graph
# --------------------------------------------------------------------------
print("SERIALIZING ..")
serialization_path=str(Path(__file__).resolve().parent.parent)+"/serialization/club.ttl"
helper.serialize(graph, serialization_path)