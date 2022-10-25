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

helper = Helper()


# --------------------------------------------------------------------------
# Read games.csv and teams.csv file
# --------------------------------------------------------------------------
print("READING DATA FROM CSV FILE ..")
clubs_csv_path = helper.get_csv_path("clubs")
clubs_dataframe = helper.read_csv(clubs_csv_path, ",")

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
print(clubs_dataframe.info())

# --------------------------------------------------------------------------
# Construct Club Ontology Namespace
# --------------------------------------------------------------------------
print("CREATING NAMESPACES OF THE ONTOLOGY ..")
CLUB = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/Club#")
GAME = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/Game#")

AWAY_CLUB = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/awayClub")
HOME_CLUB = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/homeClub")

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
graph.bind("game",GAME)
graph.bind("awayClub",AWAY_CLUB)
graph.bind("homeClub",HOME_CLUB)

# --------------------------------------------------------------------------
# Create triples and populate the graph
# --------------------------------------------------------------------------
print("POPULATING THE GRAPH ..")
for index, row in games_dataframe.iterrows():
    #Game id
    gameIdSubject = URIRef(CLUB + str(row['GAME_ID']))

    #Home team
    homeClubObjectURI = URIRef(CLUB + str(row['HOME_TEAM_ID']))
    
    #Away team
    awayClubObjectURI = URIRef(CLUB + str(row['VISITOR_TEAM_ID']))

    #Add Triples
    graph.add((gameIdSubject,URIRef(AWAY_CLUB),awayClubObjectURI))
    graph.add((gameIdSubject,URIRef(HOME_CLUB),homeClubObjectURI))        

# --------------------------------------------------------------------------
# Serialize the graph
# --------------------------------------------------------------------------
print("SERIALIZING ..")
serialization_path=str(Path(__file__).parent.resolve())+"/serialization/clubs_games_join.ttl"
helper.serialize(graph, serialization_path)