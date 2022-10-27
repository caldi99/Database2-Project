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
arena_csv_path = helper.get_csv_path("clubs")
arena_dataframe = helper.read_csv(arena_csv_path, ",")

# --------------------------------------------------------------------------
# Convert Cols to corret type
# --------------------------------------------------------------------------

print(arena_dataframe.info())
# --------------------------------------------------------------------------
# Construct Game Ontology Namespace
# --------------------------------------------------------------------------
print("CREATING NAMESPACES OF THE ONTOLOGY ..")
ARENA = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/Arena#")
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

# --------------------------------------------------------------------------
# Create triples and populate the graph
# --------------------------------------------------------------------------
print("POPULATING THE GRAPH ..")
for index, row in arena_dataframe.iterrows():
    gameSubjectURI = URIRef(BASE + str(row['GAME_ID']))    
    graph.add((gameSubjectURI, RDF.type, BASE.Game))
    
    #Date
    graph.add((gameSubjectURI, BASE['matchDate'], Literal(row['GAME_DATE_EST'], datatype = XSD.date)))
    
    #Info home team
    graph.add((gameSubjectURI, BASE['ptsHome'], Literal(row['PTS_home'], datatype = XSD.integer)))
    graph.add((gameSubjectURI, BASE['fgptcHome'], Literal(row['FG_PCT_home'], datatype = XSD.float)))
    graph.add((gameSubjectURI, BASE['ftpctHome'], Literal(row['FT_PCT_home'], datatype = XSD.float)))
    graph.add((gameSubjectURI, BASE['fg3pctHome'], Literal(row['FG3_PCT_home'], datatype = XSD.float)))
    graph.add((gameSubjectURI, BASE['astHome'], Literal(row['AST_home'], datatype = XSD.integer)))
    graph.add((gameSubjectURI, BASE['rebHome'], Literal(row['REB_home'], datatype = XSD.integer)))

    #Info away team
    graph.add((gameSubjectURI, BASE['ptsAway'], Literal(row['PTS_away'], datatype = XSD.integer)))
    graph.add((gameSubjectURI, BASE['fgptcAway'], Literal(row['FG_PCT_away'], datatype = XSD.float)))
    graph.add((gameSubjectURI, BASE['ftpctAway'], Literal(row['FT_PCT_away'], datatype = XSD.float)))
    graph.add((gameSubjectURI, BASE['fg3pctAway'], Literal(row['FG3_PCT_away'], datatype = XSD.float)))
    graph.add((gameSubjectURI, BASE['astAway'], Literal(row['AST_away'], datatype = XSD.integer)))
    graph.add((gameSubjectURI, BASE['rebAway'], Literal(row['REB_away'], datatype = XSD.integer)))

# --------------------------------------------------------------------------
# Serialize the graph
# --------------------------------------------------------------------------
print("SERIALIZING ..")
serialization_path=str(Path(__file__).parent.resolve())+"/serialization/games.ttl"
helper.serialize(graph, serialization_path)