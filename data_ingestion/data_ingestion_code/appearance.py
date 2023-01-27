"""
    Author : Andrea Pasin, Francesco Caldivezzi
"""

from data_ingestion_code.utils.helper import Helper
from rdflib import Namespace
from rdflib import Graph
from rdflib import URIRef
from rdflib import RDF
from rdflib import Literal
from rdflib.namespace import XSD
from pathlib import Path

helper = Helper()

# --------------------------------------------------------------------------
# Read games.csv and games_details.csv file
# --------------------------------------------------------------------------
print("READING DATA FROM CSV FILE ..")
game_csv_path = helper.get_csv_path("games")
game_dataframe = helper.read_csv(game_csv_path, ",")

game_detail_csv_path = helper.get_csv_path("games_details")
game_detail_dataframe = helper.read_csv(game_detail_csv_path, ",")

# --------------------------------------------------------------------------
# Drop NA values
# --------------------------------------------------------------------------
print("DROP NA VALUES ..")
game_dataframe = game_dataframe.dropna()

# --------------------------------------------------------------------------
# Merge two dataframes
# --------------------------------------------------------------------------
print("MERGING TWO DATAFRAMES ..")
merged_dataframe = game_dataframe.merge(game_detail_dataframe, how='left',on='GAME_ID')[
    ['GAME_ID','PLAYER_ID','SEASON','START_POSITION','MIN','FGM','FGA','FG_PCT','FG3M',
    'FG3A','FG3_PCT','FTM','FTA','FT_PCT','OREB','DREB','REB','AST','STL','BLK','TO','PTS','PF','COMMENT']] 

# --------------------------------------------------------------------------
# Convert to correct type columns
# --------------------------------------------------------------------------
print("CONVERT TO CORRECT TYPE COLS ..")
merged_dataframe['MIN'] = merged_dataframe['MIN'].astype(str)

game_dataframe.info()
game_detail_dataframe.info()
merged_dataframe.info()

# --------------------------------------------------------------------------
# Construct Appearance Ontology Namespace
# --------------------------------------------------------------------------
print("CREATING NAMESPACES OF THE ONTOLOGY ..")
APPEARANCE = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/Appearance#")
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
graph.bind("appearance",APPEARANCE)
graph.bind("base",BASE)

# --------------------------------------------------------------------------
# Serialization Variables
# --------------------------------------------------------------------------
BLOCK_SERIALIZATION_SIZE = 200000 
index_file = 0
base_serialization_path=str(Path(__file__).resolve().parent.parent)+"/serialization"
path_list_file_merge = []

# --------------------------------------------------------------------------
# Create triples and populate the graph
# --------------------------------------------------------------------------
for index,row in merged_dataframe.iterrows():
    appearance_subject_uri = URIRef(APPEARANCE + str("{}_{}_{}_{}".format(row['GAME_ID'],row['PLAYER_ID'],row['SEASON'],row['SEASON'] + 1)))
    graph.add((appearance_subject_uri, RDF.type, BASE.Appearance))

    #if the player has played
    if(row['MIN'] != 'nan'):        
        #Data
        graph.add((appearance_subject_uri, BASE['role'], Literal(row['START_POSITION'],datatype = XSD.string)))

        if(len(row['MIN'].split(':')) == 2):
            graph.add((appearance_subject_uri, BASE['minutes'], Literal(int(row['MIN'].split(':')[0]),datatype = XSD.integer)))
            graph.add((appearance_subject_uri, BASE['seconds'], Literal(int(row['MIN'].split(':')[1]),datatype = XSD.integer)))
        elif (len(row['MIN'].split(':')) == 1):
            graph.add((appearance_subject_uri, BASE['minutes'], Literal(int(row['MIN'].split(':')[0]),datatype = XSD.integer)))
            graph.add((appearance_subject_uri, BASE['seconds'], Literal(0,datatype = XSD.integer)))
            
        graph.add((appearance_subject_uri, BASE['fgm'], Literal(int(row['FGM']),datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['fga'], Literal(int(row['FGA']),datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['fgpct'], Literal(row['FG_PCT'],datatype = XSD.float)))
        graph.add((appearance_subject_uri, BASE['fg3m'], Literal(int(row['FG3M']),datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['fg3a'], Literal(int(row['FG3A']),datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['fg3pct'], Literal(row['FG3_PCT'],datatype = XSD.float)))
        graph.add((appearance_subject_uri, BASE['ftm'], Literal(int(row['FTM']),datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['fta'], Literal(int(row['FTA']),datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['ftpct'], Literal(row['FT_PCT'],datatype = XSD.float)))
        graph.add((appearance_subject_uri, BASE['oReb'], Literal(int(row['OREB']),datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['dReb'], Literal(int(row['DREB']),datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['reb'], Literal(int(row['REB']),datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['ast'], Literal(int(row['AST']),datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['stl'], Literal(int(row['STL']),datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['blk'], Literal(int(row['BLK']),datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['tO'], Literal(int(row['TO']),datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['pF'], Literal(int(row['PF']),datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['pts'], Literal(int(row['PTS']),datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['comment'], Literal("",datatype = XSD.string)))
    else:
        #Data
        graph.add((appearance_subject_uri, BASE['role'], Literal("",datatype = XSD.string)))
        graph.add((appearance_subject_uri, BASE['minutes'], Literal(0,datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['seconds'], Literal(0,datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['fgm'], Literal(0,datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['fga'], Literal(0,datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['fgpct'], Literal(0.0,datatype = XSD.float)))
        graph.add((appearance_subject_uri, BASE['fg3m'], Literal(0,datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['fg3a'], Literal(0,datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['fg3pct'], Literal(0.0,datatype = XSD.float)))
        graph.add((appearance_subject_uri, BASE['ftm'], Literal(0,datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['fta'], Literal(0,datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['ftpct'], Literal(0.0,datatype = XSD.float)))
        graph.add((appearance_subject_uri, BASE['oReb'], Literal(0,datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['dReb'], Literal(0,datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['reb'], Literal(0,datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['ast'], Literal(0,datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['stl'], Literal(0,datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['blk'], Literal(0,datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['tO'], Literal(0,datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['pF'], Literal(0,datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['pts'], Literal(0,datatype = XSD.integer)))
        graph.add((appearance_subject_uri, BASE['comment'], Literal(row['COMMENT'],datatype = XSD.string)))
    

    # --------------------------------------------------------------------------
    # Serialize at blocks
    # --------------------------------------------------------------------------    
    if(index != 0 and (index % BLOCK_SERIALIZATION_SIZE == 0)):
        serialization_path = base_serialization_path + "/appearance{}.ttl".format(index_file)
        path_list_file_merge.append(serialization_path)
        index_file += 1
        helper.serialize(graph,serialization_path)
        #graph.remove((None,None,None))
        graph = Graph()
        graph.bind("appearance",APPEARANCE)
        graph.bind("base",BASE)
    elif(index == (merged_dataframe.shape[0]-1)):
        print("SERIALIZING ..")
        serialization_path = base_serialization_path + "/appearance{}.ttl".format(index_file)
        path_list_file_merge.append(serialization_path)
        helper.serialize(graph,serialization_path)
