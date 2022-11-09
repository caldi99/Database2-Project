from data_ingestion_code.utils.helper import Helper
from rdflib import Namespace,Graph,URIRef
from pathlib import Path

# Defining constants to keep things organized
ONTOLOGY_URI="https://www.dei.unipd.it/Database2/CPS-NBA/"
PLAYER_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Player#"
APPEARANCE_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Appearance#"
PLAYER_APPEARANCE="appearsIn"

# Creating the Namespaces that will be used for the triples and creating the graph   
BASE= Namespace(ONTOLOGY_URI)
PLAYER = Namespace(PLAYER_CLASS_URI)
APPEARANCE = Namespace(APPEARANCE_CLASS_URI)

# Creating the Graph and binding URIs to it
graph = Graph()
graph.bind("player",PLAYER)
graph.bind("appearance",APPEARANCE)
graph.bind("base",BASE)

# Instanciating the helper class
helper=Helper()

# Adds to the graph the triples related to the Player with the corrisponding played matches
def process_has_played_in_match(match_details_path,games_path):
    print("processing \'appearsIn\'...")
    # Getting the dataframe from the .csv file containing the match details
    match_details_df = helper.read_csv(match_details_path, ",")
    match_details_df = match_details_df[['PLAYER_ID','GAME_ID']]

    games_df = helper.read_csv(games_path, ",")
    games_df=games_df[['GAME_ID','GAME_DATE_EST']]
    
    games_df_complete=games_df.merge(match_details_df, how='inner',on=['GAME_ID'])

    for index,row in games_df_complete.iterrows():
        date_vals=str(row['GAME_DATE_EST']).split('-')
        year=int(date_vals[0])
        month=int(date_vals[1])
        if(month<7):
            year=year-1
        games_df_complete.at[index,'GAME_DATE_EST']=year
    
    games_df_complete = games_df_complete.rename(columns={'GAME_DATE_EST': 'SEASON'})


    # Adding to graph the triples of type 'player hasPlayedInMatch appearance'
    for index,row in games_df_complete.iterrows():
        player_id=row['PLAYER_ID']
        game_id=row['GAME_ID']
        season=row['SEASON']
        player_subj_uri = URIRef(PLAYER + str(player_id)+"_"+str(season)+"_"+str(season+1))
        
        appearance_obj_uri= URIRef(APPEARANCE+ str(game_id)+"_"+str(player_id)+"_"+str(season)+"_"+str(season+1))
        graph.add((player_subj_uri, BASE[PLAYER_APPEARANCE], appearance_obj_uri))

    serialization_path=str(Path(__file__).resolve().parent.parent)+"/serialization/player_appearance_join.ttl"
    print("serializing...")

    # Serializing the graph to a .ttl file
    helper.serialize(graph, serialization_path)

match_details_path=helper.get_csv_path('games_details')
games_path=helper.get_csv_path('games')

process_has_played_in_match(match_details_path,games_path)