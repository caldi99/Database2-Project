from data_ingestion.utils.helper import Helper
from rdflib import Namespace,Graph,URIRef,RDF,Literal
from rdflib.namespace import XSD
import math,pathlib
import re


# Defining constants to keep things organized
ONTOLOGY_URI="https://www.dei.unipd.it/Database2/CPS-NBA/"
PLAYER_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Player#"
COUNTRY_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Country#"
APPEARANCE_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Appearance#"
TEAM_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Team#"
PLAYER_NAME="name"
PLAYER_DRAFT_YEAR="draftYear"
PLAYER_HEIGHT="height"
PLAYER_WEIGHT="weight"
PLAYER_APPEARANCE="hasPlayedInMatch"
PLAYER_BORN="wasBornIn"
PLAYER_TEAM="playsIn"

# Creating the Namespaces that will be used for the triples and creating the graph   
ONTOLOGY= Namespace(ONTOLOGY_URI)
PLAYER = Namespace(PLAYER_CLASS_URI)    
COUNTRY = Namespace(COUNTRY_CLASS_URI)
TEAM = Namespace(TEAM_CLASS_URI)
APPEARANCE = Namespace(APPEARANCE_CLASS_URI)

graph = Graph()
graph.bind("player",PLAYER)
graph.bind("country",COUNTRY)
graph.bind("team",TEAM)
graph.bind("appearance",APPEARANCE)
graph.bind("nba-cps",ONTOLOGY)

# Instanciating the helper class
helper=Helper()





# Adds to the graph the triples related to the Player playing for a team on a given year
def process_plays_in(players_path):
    print("processing \'playsIn\'...")
    players_df = helper.read_csv(players_path, ",")
    for i,row in players_df.iterrows():
        player_id=row["PLAYER_ID"]
        season=row["SEASON"]
        team_id=row["TEAM_ID"]
        player_subj_uri = URIRef(PLAYER + str(player_id))
        team_obj_uri= URIRef(TEAM+ str(team_id)+"_"+str(season))
        graph.add((player_subj_uri, ONTOLOGY[PLAYER_TEAM], team_obj_uri))

# Adds to the graph the triples related to the Player with its Data-Properties
def process_player(players_path,players_details_path):
    print("processing \'Player\'...")
    # Getting the dataframe from the .csv file containing the players with their caractheristics (height,weight...)
    players_details_df = helper.read_csv(players_details_path, ",")
    players_details_df = players_details_df[players_details_df['season'] > str("2003-04")]
    players_details_df = players_details_df[players_details_df['season'] < str("2021-22")]
    players_details_df = players_details_df[['player_name', 'player_height', 'player_weight','draft_year']]

    # Getting the dataframe from the .csv file containing the players with their ids
    players_df = helper.read_csv(players_path, ",")
    players_df = players_df.drop_duplicates(subset='PLAYER_ID', keep="first")
    players_df = players_df.rename(columns={'PLAYER_NAME': 'player_name','PLAYER_ID': 'player_id'})
    players_df = players_df[['player_name','player_id']]

    # Merging the dataframes to obtain the final dataframe of players with their properties
    players_complete_df = players_df.merge(players_details_df, how='left',on='player_name')
    players_complete_df = players_complete_df.sort_values(by='player_name')
    players_complete_df = players_complete_df.reset_index(drop=True)
    
    # Iterating over the players to create the triples to be added to the graph
    i=0
    while i<len(players_complete_df):
        player_name=players_complete_df.loc[i, "player_name"]
        player_id=players_complete_df.loc[i, "player_id"]
        player_weight=players_complete_df.loc[i, "player_weight"]
        player_height=players_complete_df.loc[i, "player_height"]
        player_draft_year=players_complete_df.loc[i, "draft_year"]

        # The following while loop is used to calculate averages of heights and weights over the years for a given player
        n_col=1
        k=i+1
        while k<len(players_complete_df):
            if(player_name==players_complete_df.loc[k, "player_name"]):
                if(math.isnan(player_weight) or math.isnan(player_height)):
                    k+=1
                    continue
                    
                player_weight+=players_complete_df.loc[i, "player_weight"]
                player_height+=players_complete_df.loc[i, "player_height"]
                n_col+=1
            else:
                break
            k+=1
        
        if(not math.isnan(player_weight) and not math.isnan(player_height)):
            player_weight/=n_col
            player_height/=n_col
        
        # Adding the rdf triples to the graph
        player_subj_uri = URIRef(PLAYER + str(player_id))
        graph.add((player_subj_uri, RDF.type, URIRef(ONTOLOGY.Player)))
        graph.add((player_subj_uri, ONTOLOGY[PLAYER_NAME], Literal(player_name, lang="en")))
        
        if(str(player_draft_year)!="Undrafted"):
            graph.add((player_subj_uri, ONTOLOGY[PLAYER_DRAFT_YEAR], Literal(player_draft_year, datatype = XSD.integer)))

        if(not math.isnan(player_weight) and not math.isnan(player_height)):
            player_weight/=n_col
            player_height/=n_col
            graph.add((player_subj_uri, ONTOLOGY[PLAYER_WEIGHT], Literal(player_weight, datatype = XSD.float)))
            graph.add((player_subj_uri, ONTOLOGY[PLAYER_HEIGHT], Literal(player_height, datatype = XSD.float)))
       
        i=k

# Adds to the graph the triples related to the Player with the country where he/she was born
def process_born_in(players_path,players_details_path):
    print("processing \'wasBornIn\'...")
    # Getting the dataframe from the .csv file containing the players with their caractheristics (height,weight...)
    players_details_df = helper.read_csv(players_details_path, ",")
    players_details_df = players_details_df[players_details_df['season'] > str("2003-04")]
    players_details_df = players_details_df[players_details_df['season'] < str("2021-22")]
    players_details_df = players_details_df.drop_duplicates(subset='player_name', keep="first")
    players_details_df = players_details_df[['player_name', 'country']]

    # Getting the dataframe from the .csv file containing the players with their ids
    players_df = helper.read_csv(players_path, ",")
    players_df = players_df.drop_duplicates(subset=['PLAYER_ID'], keep="first")
    players_df = players_df.rename(columns={'PLAYER_NAME': 'player_name','PLAYER_ID': 'player_id'})
    players_df = players_df[['player_name','player_id']]

    # Merging the dataframes to obtain the final dataframe of players with their properties
    players_complete_df = players_df.merge(players_details_df, how='left',on='player_name')
    players_complete_df = players_complete_df.sort_values(by='player_name')
    players_complete_df = players_complete_df.reset_index(drop=True)

    # Adding to graph the triples of type 'player bornIn country'
    for index,row in players_complete_df.iterrows():
        player_id=row['player_id']
        
        player_country=row['country']
        player_subj_uri = URIRef(PLAYER + str(player_id))
        country_obj_uri= URIRef(COUNTRY+ re.sub(r'\W+', '', str(player_country)))
        graph.add((player_subj_uri, ONTOLOGY[PLAYER_BORN], country_obj_uri))


# Adds to the graph the triples related to the Player with the corrisponding played matches
def process_has_played_in_match(players_path,match_details_path):
    print("processing \'hasPlayedInMatch\'...")
    # Getting the dataframe from the .csv file containing the match details
    match_details_df = helper.read_csv(match_details_path, ",")
    match_details_df = match_details_df[['PLAYER_ID','GAME_ID']]

    players_df = helper.read_csv(players_path, ",")
    players_df = players_df.drop_duplicates(subset=['PLAYER_ID'], keep="first")
    players_df=players_df[['PLAYER_ID']]

    players_complete_df = players_df.merge(match_details_df, how='inner',on='PLAYER_ID')


    # Adding to graph the triples of type 'player hasPlayedInMatch appearance'
    for index,row in players_complete_df.iterrows():
        player_id=row['PLAYER_ID']
        game_id=row['GAME_ID']
        player_subj_uri = URIRef(PLAYER + str(player_id))
        
        game_obj_uri= URIRef(APPEARANCE+ str(game_id)+"_"+str(player_id))
        graph.add((player_subj_uri, ONTOLOGY[PLAYER_APPEARANCE], game_obj_uri))
    

# Processes the players from the dataset and serializes them in a .ttl file
def process_players():

    players_details_path=helper.get_csv_path('players_details')
    players_path=helper.get_csv_path('players')
    match_details_path=helper.get_csv_path('games_details')

    
    # Processing the instances of the class Player with their Data-Properties
    process_player(players_path,players_details_path)

    # Processing the instances of the Player Object-Property playsIn
    process_plays_in(players_path)

    # Processing the instances of the Player Object-Property wasBornIn
    process_born_in(players_path,players_details_path)

    # Processing the instances of the PLayer Object-Property hasPlayedInMatch
    process_has_played_in_match(players_path,match_details_path)

    
    
    serialization_path=str(pathlib.Path(__file__).parent.resolve())+"/serialization/players.ttl"
    print("serializing...")

    # Serializing the graph to a .ttl file
    helper.serialize(graph, serialization_path)

process_players()