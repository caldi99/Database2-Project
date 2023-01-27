from data_ingestion_code.utils.helper import Helper
from rdflib import Namespace,Graph,URIRef
from pathlib import Path
import re

# Defining constants to keep things organized
ONTOLOGY_URI="https://www.dei.unipd.it/Database2/CPS-NBA/"
PERSON_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Person#"
COUNTRY_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Country#"
PERSON_FROM="isFrom"

# Creating the Namespaces that will be used for the triples and creating the graph   
BASE= Namespace(ONTOLOGY_URI)
PERSON = Namespace(PERSON_CLASS_URI)    
COUNTRY = Namespace(COUNTRY_CLASS_URI)

# Creating the Graph and binding URIs to it
graph = Graph()
graph.bind("person",PERSON)
graph.bind("country",COUNTRY)
graph.bind("base",BASE)

# Instanciating the helper class
helper=Helper()


# Adds to the graph the triples related to the Player with the country where he/she was born
def process_is_from(players_path,players_details_path):
    print("processing \'isFrom\'...")
    # Getting the dataframe from the .csv file containing the players with their caractheristics (height,weight...)
    players_details_df = helper.read_csv(players_details_path, ",")
    players_details_df = players_details_df[players_details_df['season'] >= str("2003-04")]
    players_details_df = players_details_df[players_details_df['season'] <= str("2021-22")]
    players_details_df = players_details_df.drop_duplicates(subset='player_name', keep="first")
    players_details_df = players_details_df[['player_name', 'country']]

    # Getting the dataframe from the .csv file containing the players with their ids
    players_df = helper.read_csv(players_path, ",")
    players_df = players_df.drop_duplicates(subset=['PLAYER_ID'], keep="first")
    players_df = players_df.rename(columns={'PLAYER_NAME': 'player_name','PLAYER_ID': 'player_id'})
    players_df = players_df[['player_name','player_id']]

    # Merging the dataframes to obtain the final dataframe of players with their properties
    players_complete_df = players_df.merge(players_details_df, how='inner',on='player_name').drop_duplicates()

    # Adding to graph the triples of type 'player bornIn country'
    for index,row in players_complete_df.iterrows():
        player_id=row['player_id']        
        player_country=row['country']
        player_subj_uri = URIRef(PERSON + str(player_id))
        country_obj_uri= URIRef(COUNTRY+ re.sub(r'\W+', '', str(player_country)))
        graph.add((player_subj_uri, BASE[PERSON_FROM], country_obj_uri))

    
    serialization_path=str(Path(__file__).resolve().parent.parent)+"/serialization/person_country_join.ttl"
    print("serializing...")

    # Serializing the graph to a .ttl file
    helper.serialize(graph, serialization_path)

players_details_path=helper.get_csv_path('players_details')
players_path=helper.get_csv_path('players')

process_is_from(players_path,players_details_path)