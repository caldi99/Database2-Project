"""
    Author : Francesco Caldivezzi
"""

from utils.helper import Helper
from rdflib import Namespace
from rdflib import Graph
from rdflib import URIRef
from rdflib import RDF
from rdflib import Literal
from rdflib.namespace import XSD

helper = Helper()


# --------------------------------------------------------------------------
# Read games_details.csv file
# --------------------------------------------------------------------------
print("READING DATA FROM CSV FILE ..")
clubs_csv_path = helper.get_csv_path("clubs")
clubs_dataframe = helper.read_csv(clubs_csv_path, ",")

# --------------------------------------------------------------------------
# Convert Cols to corret type
# --------------------------------------------------------------------------

print(clubs_dataframe.info())

# --------------------------------------------------------------------------
# Construct Club Ontology Namespace
# --------------------------------------------------------------------------
print("CREATING NAMESPACES OF THE ONTOLOGY ..")
CLUB = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/Club#")

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

# --------------------------------------------------------------------------
# Create triples and populate the graph
# --------------------------------------------------------------------------
print("POPULATING THE GRAPH ..")
for index, row in clubs_dataframe.iterrows():

    clubSubjectURI = URIRef(CLUB + str(index))    
    graph.add((clubSubjectURI, RDF.type, CLUB.Club))
            
    #Nickname
    graph.add((clubSubjectURI, CLUB['name'], Literal(row['NICKNAME'], datatype = XSD.string)))
    
    #Abbreviation
    graph.add((clubSubjectURI, CLUB['abbreviation'], Literal(row['ABBREVIATION'], datatype = XSD.string)))
    
    #Year
    graph.add((clubSubjectURI, CLUB['firstYear'], Literal(row['MIN_YEAR'], datatype = XSD.gYear)))

    #City
    graph.add((clubSubjectURI, CLUB['city'], Literal(row['CITY'], datatype = XSD.string)))

# --------------------------------------------------------------------------
# Serialize the graph
# --------------------------------------------------------------------------
print("SERIALIZING ..")
helper.serialize(graph, "../serialization/clubs.ttl")