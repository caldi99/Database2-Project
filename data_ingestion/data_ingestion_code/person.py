from data_ingestion_code.utils.helper import Helper
from rdflib import Namespace,Graph,URIRef,Literal
from rdflib.namespace import XSD
from pathlib import Path

# Defining constants to keep things organized
ONTOLOGY_URI="https://www.dei.unipd.it/Database2/CPS-NBA/"
PERSON_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Person#"
PERSON_NAME="name"

# Creating the Namespaces that will be used for the triples and creating the graph   
BASE= Namespace(ONTOLOGY_URI)
PERSON = Namespace(PERSON_CLASS_URI)

# Creating the Graph and binding URIs to it
graph = Graph()
graph.bind("person",PERSON)
graph.bind("base",BASE)

# Instanciating the helper class
helper=Helper()


# Adds to the graph the triples related to the Player with the country where he/she was born
def process_person(players_path):
    print("processing \'Person\'...")

    # Getting the dataframe from the .csv file containing the players with their ids
    players_df = helper.read_csv(players_path, ",")
    players_df = players_df[['PLAYER_NAME','PLAYER_ID']]

    # Adding to graph the triples of type 'player bornIn country'
    for index,row in players_df.iterrows():
        player_id=row['PLAYER_ID']
        player_name=row['PLAYER_NAME']
        
        player_subj_uri = URIRef(PERSON + str(player_id))
        graph.add((player_subj_uri, XSD.type, BASE.Person))
        graph.add((player_subj_uri, BASE[PERSON_NAME], Literal(str(player_name),datatype=XSD.string)))

    
    serialization_path=str(Path(__file__).resolve().parent.parent)+"/serialization/person.ttl"
    print("serializing...")

    # Serializing the graph to a .ttl file
    helper.serialize(graph, serialization_path)

players_details_path=helper.get_csv_path('players_details')
players_path=helper.get_csv_path('players')

process_person(players_path)