"""
    Author : Francesco Caldivezzi
"""

from data_ingestion_code.utils.helper import Helper
from rdflib import Namespace
from rdflib import Graph
from rdflib import URIRef
from pathlib import Path

helper = Helper()


# --------------------------------------------------------------------------
# Read games.csv and teams.csv file
# --------------------------------------------------------------------------
print("READING DATA FROM CSV FILE ..")
club_csv_path = helper.get_csv_path("clubs")
club_dataframe = helper.read_csv(club_csv_path, ",")

game_csv_path = helper.get_csv_path("games")
game_dataframe = helper.read_csv(game_csv_path, ",")

# --------------------------------------------------------------------------
# Drop NA values
# --------------------------------------------------------------------------
print("DROP NA VALUES ..")
game_dataframe = game_dataframe.dropna()

print(game_dataframe.info())
print(club_dataframe.info())

# --------------------------------------------------------------------------
# Construct Club Ontology Namespace
# --------------------------------------------------------------------------
print("CREATING NAMESPACES OF THE ONTOLOGY ..")
CLUB = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/Club#")
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
graph.bind("club",CLUB)
graph.bind("game",GAME)
graph.bind("base",BASE)

# --------------------------------------------------------------------------
# Create triples and populate the graph
# --------------------------------------------------------------------------
print("POPULATING THE GRAPH ..")
for index, row in game_dataframe.iterrows():
    #Subject
    game_club_subject = URIRef(GAME + str(row['GAME_ID']))

    #Predicate and Object home
    game_club_home_object = URIRef(CLUB + str(row['HOME_TEAM_ID']))
    game_club_home_predicate = URIRef(BASE + "hasHomeClub") 

    #Predicate and Object away
    game_club_away_object = URIRef(CLUB + str(row['VISITOR_TEAM_ID']))
    game_club_away_predicate = URIRef(BASE + "hasAwayClub") 


    #Add Triples
    graph.add((game_club_subject, game_club_away_predicate ,game_club_away_object))
    graph.add((game_club_subject, game_club_home_predicate, game_club_home_object))        

# --------------------------------------------------------------------------
# Serialize the graph
# --------------------------------------------------------------------------
print("SERIALIZING ..")
serialization_path=str(Path(__file__).resolve().parent.parent)+"/serialization/game_club_join.ttl"
helper.serialize(graph, serialization_path)