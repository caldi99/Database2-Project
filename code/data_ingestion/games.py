"""
    Author : Francesco Caldivezzi
"""

from utils.helper import Helper
from rdflib import Namespace
from rdflib import Graph
from rdflib import URIRef
from rdflib import RDF
from rdflib.namespace import XSD


helper = Helper()


# --------------------------------------------------------------------------
# Read games_details.csv file
# --------------------------------------------------------------------------

games_csv_path = helper.get_csv_path("games.csv")
games_dataframe = helper.read_csv(game_csv_path, ",")
print(games_dataframe.info())

# --------------------------------------------------------------------------
# Contruct Game Ontology Namespace
# --------------------------------------------------------------------------
GAME = Namespace("htpps://www.dei.unipd.it/Database2/CPS-NBA/Game#")

# --------------------------------------------------------------------------
# Create the graph
# --------------------------------------------------------------------------
graph = Graph()

# --------------------------------------------------------------------------
# Bind namespaces to a prefix for a better output
# --------------------------------------------------------------------------
graph.bind("game",GAME)

# --------------------------------------------------------------------------
# Create triples and populate the graph
# --------------------------------------------------------------------------
for index, row in movies.iterrows():
    

    gameSubjectURI = URIRef(GAME[index])
    
    graph.add((gameSubjectURI, RDF.type, GAME.Game))


    graph.add((gameSubjectURI, GAME['matchDate'], Literal(row['GAME_DATE_EST'], XSD.date)))
    
    graph.add((gameSubjectURI, GAME['ptsHome'], Literal(row['PTS_home'], XSD.integer)))
    graph.add((gameSubjectURI, GAME['fgptcHome'], Literal(row['FG_PCT_home'], XSD.float)))
    graph.add((gameSubjectURI, GAME['ftpctHome'], Literal(row['FT_PCT_home'], XSD.float)))
    graph.add((gameSubjectURI, GAME['fg3pctHome'], Literal(row['FG3_PCT_home'], XSD.float)))
    graph.add((gameSubjectURI, GAME['astHome'], Literal(row['AST_home'], XSD.integer)))
    graph.add((gameSubjectURI, GAME['rebHome'], Literal(row['REB_home'], XSD.integer)))

    graph.add((gameSubjectURI, GAME['ptsAway'], Literal(row['PTS_away'], XSD.integer)))
    graph.add((gameSubjectURI, GAME['fgptcAway'], Literal(row['FG_PCT_away'], XSD.float)))
    graph.add((gameSubjectURI, GAME['ftpctAway'], Literal(row['FT_PCT_away'], XSD.float)))
    graph.add((gameSubjectURI, GAME['fg3pctAway'], Literal(row['FG3_PCT_away'], XSD.float)))
    graph.add((gameSubjectURI, GAME['astAway'], Literal(row['AST_away'], XSD.integer)))
    graph.add((gameSubjectURI, GAME['rebAway'], Literal(row['REB_away'], XSD.integer)))


# --------------------------------------------------------------------------
# Serialize the graph
# --------------------------------------------------------------------------
helper.serialize(graph,"../serialization/games.ttl")