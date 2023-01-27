from data_ingestion_code.utils.helper import Helper
from rdflib import Namespace,Graph,URIRef,RDF,Literal
from pathlib import Path
import re

# Defining constants to keep things organized
ONTOLOGY_URI="https://www.dei.unipd.it/Database2/CPS-NBA/"
COUNTRY_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Country#"
COUNTRY_NAME="name"


# Creating the Namespaces that will be used for the triples and creating the graph
COUNTRY = Namespace(COUNTRY_CLASS_URI)
ONTOLOGY= Namespace(ONTOLOGY_URI)
graph = Graph()
graph.bind("country",COUNTRY_CLASS_URI)
graph.bind("base",ONTOLOGY)

# Instanciating the helper class
helper=Helper()

# Adds to the graph the triples related to the Countries
def process_countries():
    print("processing \'country\'...")
    players_details_path=helper.get_csv_path('players_details')

    # Getting the dataframe from the .csv file containing the players with their caractheristics (height,weight...)
    players_details_df = helper.read_csv(players_details_path, ",")
    players_details_df = players_details_df[players_details_df['season'] >= str("2003-04")]
    players_details_df = players_details_df[players_details_df['season'] <= str("2021-22")]
    players_details_df = players_details_df.drop_duplicates(subset='country', keep="first")
    players_details_df = players_details_df[['country']]


    # Adding to graph the triples of type 'country a Country'
    for index,row in players_details_df.iterrows():
        country=row['country']
        country_subj_uri= URIRef(COUNTRY+ re.sub(r'\W+', '', country))
        graph.add((country_subj_uri, ONTOLOGY[COUNTRY_NAME], Literal(str(country),lang="en")))
        graph.add((country_subj_uri, RDF.type, URIRef(ONTOLOGY.Country)))
    
    serialization_path=str(Path(__file__).resolve().parent.parent)+"/serialization/country.ttl"
    print("serializing...")

    # Serializing the graph to a .ttl file
    helper.serialize(graph, serialization_path)

process_countries()