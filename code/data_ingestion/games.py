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
games_csv_path = helper.get_csv_path("games")
games_dataframe = helper.read_csv(games_csv_path, ",")

# --------------------------------------------------------------------------
# Drop NA values
# --------------------------------------------------------------------------
print("DROP NA VALUES ..")
games_dataframe = games_dataframe.dropna()

# --------------------------------------------------------------------------
# Convert Cols to corret type
# --------------------------------------------------------------------------
print("CONVERT COLS TO CORRECT TYPE ..")
games_dataframe['PTS_home'] = games_dataframe['PTS_home'].astype(int)
games_dataframe['PTS_away'] = games_dataframe['PTS_away'].astype(int)
games_dataframe['AST_home'] = games_dataframe['AST_home'].astype(int)
games_dataframe['AST_away'] = games_dataframe['AST_away'].astype(int)
games_dataframe['REB_home'] = games_dataframe['REB_home'].astype(int)
games_dataframe['REB_away'] = games_dataframe['REB_away'].astype(int)

print(games_dataframe.info())
# --------------------------------------------------------------------------
# Construct Game Ontology Namespace
# --------------------------------------------------------------------------
print("CREATING NAMESPACES OF THE ONTOLOGY ..")
GAME = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/Game#")
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
graph.bind("game",GAME)
graph.bind("base",BASE)

# --------------------------------------------------------------------------
# Create triples and populate the graph
# --------------------------------------------------------------------------
print("POPULATING THE GRAPH ..")
for index, row in games_dataframe.iterrows():
    gameSubjectURI = URIRef(GAME + str(row['GAME_ID']))    
    graph.add((gameSubjectURI, RDF.type, BASE.Game))
    
    #Date
    graph.add((gameSubjectURI, GAME['matchDate'], Literal(row['GAME_DATE_EST'], datatype = XSD.date)))
    
    #Info home team
    graph.add((gameSubjectURI, GAME['ptsHome'], Literal(row['PTS_home'], datatype = XSD.integer)))
    graph.add((gameSubjectURI, GAME['fgptcHome'], Literal(row['FG_PCT_home'], datatype = XSD.float)))
    graph.add((gameSubjectURI, GAME['ftpctHome'], Literal(row['FT_PCT_home'], datatype = XSD.float)))
    graph.add((gameSubjectURI, GAME['fg3pctHome'], Literal(row['FG3_PCT_home'], datatype = XSD.float)))
    graph.add((gameSubjectURI, GAME['astHome'], Literal(row['AST_home'], datatype = XSD.integer)))
    graph.add((gameSubjectURI, GAME['rebHome'], Literal(row['REB_home'], datatype = XSD.integer)))

    #Info away team
    graph.add((gameSubjectURI, GAME['ptsAway'], Literal(row['PTS_away'], datatype = XSD.integer)))
    graph.add((gameSubjectURI, GAME['fgptcAway'], Literal(row['FG_PCT_away'], datatype = XSD.float)))
    graph.add((gameSubjectURI, GAME['ftpctAway'], Literal(row['FT_PCT_away'], datatype = XSD.float)))
    graph.add((gameSubjectURI, GAME['fg3pctAway'], Literal(row['FG3_PCT_away'], datatype = XSD.float)))
    graph.add((gameSubjectURI, GAME['astAway'], Literal(row['AST_away'], datatype = XSD.integer)))
    graph.add((gameSubjectURI, GAME['rebAway'], Literal(row['REB_away'], datatype = XSD.integer)))

# --------------------------------------------------------------------------
# Serialize the graph
# --------------------------------------------------------------------------
print("SERIALIZING ..")
serialization_path=str(Path(__file__).parent.resolve())+"/serialization/games.ttl"
helper.serialize(graph, serialization_path)