"""
    Author : Francesco Caldivezzi
"""
import math,pandas as pd,numpy as np
from nba_api.stats.static import players
from utils.helper import Helper

helper = Helper()

path_players_details = helper.get_csv_path("players_details")
players_details_dataframe = helper.read_csv(path_players_details,",")

#print(players_details_dataframe.isnull())

for index,row in players_details_dataframe.iterrows():
    

    print(np.where(players_details_dataframe.applymap(lambda x: x == '')))
    if(pd.isnull(row['player_height'])):
        print(row['player_name'])

"""
    if(row['player_weight'].isna()):
        print(row['player_name'])
    
    if(row['draft_year'].isnull()):
        print(row['player_name'])

    if(row['country'].isnull()):
        print(row['player_name'])
"""

    

