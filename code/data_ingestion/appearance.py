from data_ingestion.utils.helper import Helper
from rdflib import Namespace,Graph,URIRef,RDF,Literal
from rdflib.namespace import XSD
import math,pathlib
from datetime import datetime

# Defining constants to keep things organized
ONTOLOGY_URI="https://www.dei.unipd.it/Database2/CPS-NBA/"
APPEARANCE_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Appearance#"
TEAM_CLASS_URI="https://www.dei.unipd.it/Database2/CPS-NBA/Team#"
APPEARANCE_MINUTES="minutes"
APPEARANCE_SECONDS="seconds"
APPEARANCE_COMMENT="comment"
APPEARANCE_FGM="fgm"
APPEARANCE_FGA="fga"
APPEARANCE_FG_PCT="fgp"
APPEARANCE_FG3A="fg3a"
APPEARANCE_FG3M="fg3m"
APPEARANCE_FG3_PCT="fg3p"
APPEARANCE_FTM="ftm"
APPEARANCE_FTA="fta"
APPEARANCE_FT_PCT="ftp"
APPEARANCE_OREB="oreb"
APPEARANCE_DREB="dreb"
APPEARANCE_REB="reb"
APPEARANCE_AST="ast"
APPEARANCE_STL="stl"
APPEARANCE_BLK="blk"
APPEARANCE_TO="to"
APPEARANCE_PF="pf"
APPEARANCE_PTS="pts"
APPEARANCE_PLUS_MINUS="plusminus"
APPEARANCE_APPEARS_IN="appearsIn"

# Creating the Namespaces that will be used for the triples and creating the graph
APPEARANCE = Namespace(APPEARANCE_CLASS_URI)
ONTOLOGY= Namespace(ONTOLOGY_URI)
GAME = Namespace("https://www.dei.unipd.it/Database2/CPS-NBA/Game#")
graph = Graph()
graph.bind("appearance",APPEARANCE)
graph.bind("nba-cps",ONTOLOGY)
graph.bind("game",GAME)

# Instanciating the helper class
helper=Helper()


def process_apperas_in():
    print("processing \'appearsIn\'...")
    players_path=helper.get_csv_path('players')
    
    match_details_path=helper.get_csv_path('games_details')
    games_csv_path = helper.get_csv_path("games")


    games_df = helper.read_csv(games_csv_path, ",")
    games_df=games_df[['GAME_ID']]
    match_details_df = helper.read_csv(match_details_path, ",")
    match_details_df=match_details_df[['PLAYER_ID','GAME_ID']]

    complete_df = games_df.merge(match_details_df, how='inner',on='GAME_ID')

    for index,row in complete_df.iterrows():
        player_id=row['PLAYER_ID']
        game_id=row['GAME_ID']
        appearance_subj_uri= URIRef(APPEARANCE+ str(game_id)+"_"+str(player_id))
        game_obj_uri= URIRef(GAME+str(game_id))
        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_APPEARS_IN], game_obj_uri))





def process_appearances_instances():
    print("processing \'appearance\'...")
    players_path=helper.get_csv_path('players')
    match_details_path=helper.get_csv_path('games_details')

    match_details_df = helper.read_csv(match_details_path, ",")

    players_df = helper.read_csv(players_path, ",")
    players_df = players_df.drop_duplicates(subset=['PLAYER_ID'], keep="first")
    players_df=players_df[['PLAYER_ID']]

    players_complete_df = players_df.merge(match_details_df, how='inner',on='PLAYER_ID')

    time_vector=[]
    # Adding to graph the triples of type 'player hasPlayedInMatch appearance'
    for index,row in players_complete_df.iterrows():
        if(index%10000==0):
            print("processing: {}%".format(100*index/len(players_complete_df)))
        player_id=row['PLAYER_ID']
        game_id=row['GAME_ID']
        
        if str(row['MIN'])== "nan":
            time_vector=[0,0]
        else:
            time_vector=str(row['MIN']).split(":")
            if(len(time_vector)==1):
                time_vector.append(0)
        
        
        appearance_subj_uri= URIRef(APPEARANCE+ str(game_id)+"_"+str(player_id))
        graph.add((appearance_subj_uri, RDF.type, URIRef(ONTOLOGY.Appearance)))
        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_MINUTES], Literal(time_vector[0], datatype= XSD.integer)))
        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_SECONDS], Literal(time_vector[1], datatype= XSD.integer)))
        if(str(row['COMMENT'])!="nan"):
            graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_COMMENT], Literal(str(row['COMMENT']), lang="en")))
        
        if(time_vector[0]==0 and time_vector[1]==0):
            continue

        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_FGM], Literal(int(row['FGM']), datatype= XSD.integer)))
        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_FGA], Literal(int(row['FGA']), datatype= XSD.integer)))
        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_FG_PCT], Literal(row['FG_PCT'], datatype= XSD.float)))
        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_FG3A], Literal(int(row['FG3A']), datatype= XSD.integer)))
        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_FG3M], Literal(int(row['FG3M']), datatype= XSD.integer)))
        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_FG3_PCT], Literal(row['FG3_PCT'], datatype= XSD.float)))
        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_FTA], Literal(int(row['FTA']), datatype= XSD.integer)))
        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_FTM], Literal(int(row['FTM']), datatype= XSD.integer)))
        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_FT_PCT], Literal(row['FT_PCT'], datatype= XSD.float)))
        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_OREB], Literal(int(row['OREB']), datatype= XSD.integer)))
        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_DREB], Literal(int(row['DREB']), datatype= XSD.integer)))
        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_REB], Literal(int(row['REB']), datatype= XSD.integer)))
        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_AST], Literal(int(row['AST']), datatype= XSD.integer)))
        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_STL], Literal(int(row['STL']), datatype= XSD.integer)))
        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_BLK], Literal(int(row['BLK']), datatype= XSD.integer)))
        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_TO], Literal(int(row['TO']), datatype= XSD.integer)))
        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_PF], Literal(int(row['PF']), datatype= XSD.integer)))
        graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_PTS], Literal(int(row['PTS']), datatype= XSD.integer)))
        if(str(row['PLUS_MINUS'])!="nan"):
            graph.add((appearance_subj_uri, ONTOLOGY[APPEARANCE_PLUS_MINUS], Literal(int(row['PLUS_MINUS']), datatype= XSD.integer)))
        

    


def process_appearances():
    process_appearances_instances()
    process_apperas_in()
    serialization_path=str(pathlib.Path(__file__).parent.resolve())+"/serialization/appearances.ttl"
    print("serializing...")

    # Serializing the graph to a .ttl file
    helper.serialize(graph, serialization_path)

process_appearances()