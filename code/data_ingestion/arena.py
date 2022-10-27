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
import re

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

#arena_dataframe['ARENA'] = arena_dataframe["ARENA"].astype(str)
# --------------------------------------------------------------------------
# Substitute NA values with 0
# --------------------------------------------------------------------------
arena_dataframe['ARENACAPACITY'] = arena_dataframe['ARENACAPACITY'].fillna(0)

# --------------------------------------------------------------------------
# Compute the avg of arena capacities
# --------------------------------------------------------------------------
sum = 0
arenasNumberCapacityNotZero = 0

for capacity in arena_dataframe['ARENACAPACITY']:
    if(capacity != 0):
        sum += capacity
        arenasNumberCapacityNotZero += 1 

avgArenaCapacity = int(sum / arenasNumberCapacityNotZero)

# --------------------------------------------------------------------------
# Substitute 0 values of ARENACAPACITY with the avarage of the other ones
# --------------------------------------------------------------------------
arena_dataframe["ARENACAPACITY"] = arena_dataframe["ARENACAPACITY"].replace(0,avgArenaCapacity)

# --------------------------------------------------------------------------
# Print info of dataframe
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
graph.bind("base",BASE)

# --------------------------------------------------------------------------
# Create triples and populate the graph
# --------------------------------------------------------------------------
print("POPULATING THE GRAPH ..")
for index, row in arena_dataframe.iterrows():

    #create Uri arena
    arenaSubjectuUri = URIRef(ARENA + str(re.sub(r'\W+', '', row['ARENA'])))
    
    #add to graph uri arena
    graph.add((arenaSubjectuUri, RDF.type, BASE.Arena))

    #Name of the arena
    graph.add((arenaSubjectuUri, BASE['name'], Literal(row['ARENA'], datatype = XSD.string)))
    
    #Capacity
    graph.add((arenaSubjectuUri, BASE['capacity'], Literal(row['ARENACAPACITY'], datatype = XSD.integer)))
       

# --------------------------------------------------------------------------
# Serialize the graph
# --------------------------------------------------------------------------
print("SERIALIZING ..")
serialization_path=str(Path(__file__).parent.resolve())+"/serialization/arenas.ttl"
helper.serialize(graph, serialization_path)