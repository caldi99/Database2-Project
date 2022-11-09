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
# Read games.csv file
# --------------------------------------------------------------------------
print("READING DATA FROM CSV FILE ..")
game_csv_path = helper.get_csv_path("games")
game_dataframe = helper.read_csv(game_csv_path, ",")

# --------------------------------------------------------------------------
# Drop NA values
# --------------------------------------------------------------------------
print("DROP NA VALUES ..")
game_dataframe = game_dataframe.dropna()

# --------------------------------------------------------------------------
# Convert Cols to corret type
# --------------------------------------------------------------------------
print("CONVERT COLS TO CORRECT TYPE ..")
game_dataframe['PTS_home'] = game_dataframe['PTS_home'].astype(int)
game_dataframe['PTS_away'] = game_dataframe['PTS_away'].astype(int)
game_dataframe['AST_home'] = game_dataframe['AST_home'].astype(int)
game_dataframe['AST_away'] = game_dataframe['AST_away'].astype(int)
game_dataframe['REB_home'] = game_dataframe['REB_home'].astype(int)
game_dataframe['REB_away'] = game_dataframe['REB_away'].astype(int)

print(game_dataframe.info())
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
for index, row in game_dataframe.iterrows():
    game_subject = URIRef(GAME + str(row['GAME_ID']))    
    graph.add((game_subject, RDF.type, BASE.Game))
    
    #Date
    graph.add((game_subject, BASE['matchDate'], Literal(row['GAME_DATE_EST'], datatype = XSD.date)))
    
    #Info home team
    graph.add((game_subject, BASE['ptsHome'], Literal(row['PTS_home'], datatype = XSD.integer)))
    graph.add((game_subject, BASE['fgptcHome'], Literal(row['FG_PCT_home'], datatype = XSD.float)))
    graph.add((game_subject, BASE['ftpctHome'], Literal(row['FT_PCT_home'], datatype = XSD.float)))
    graph.add((game_subject, BASE['fg3pctHome'], Literal(row['FG3_PCT_home'], datatype = XSD.float)))
    graph.add((game_subject, BASE['astHome'], Literal(row['AST_home'], datatype = XSD.integer)))
    graph.add((game_subject, BASE['rebHome'], Literal(row['REB_home'], datatype = XSD.integer)))

    #Info away team
    graph.add((game_subject, BASE['ptsAway'], Literal(row['PTS_away'], datatype = XSD.integer)))
    graph.add((game_subject, BASE['fgptcAway'], Literal(row['FG_PCT_away'], datatype = XSD.float)))
    graph.add((game_subject, BASE['ftpctAway'], Literal(row['FT_PCT_away'], datatype = XSD.float)))
    graph.add((game_subject, BASE['fg3pctAway'], Literal(row['FG3_PCT_away'], datatype = XSD.float)))
    graph.add((game_subject, BASE['astAway'], Literal(row['AST_away'], datatype = XSD.integer)))
    graph.add((game_subject, BASE['rebAway'], Literal(row['REB_away'], datatype = XSD.integer)))

    #Info win home
    graph.add((game_subject, BASE['winHome'], Literal(row['HOME_TEAM_WINS'], datatype = XSD.integer)))

# --------------------------------------------------------------------------
# Serialize the graph
# --------------------------------------------------------------------------
print("SERIALIZING ..")
serialization_path=str(Path(__file__).resolve().parent.parent)+"/serialization/game.ttl"
helper.serialize(graph, serialization_path)