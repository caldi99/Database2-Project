"""
    Author : Andrea Pasin
"""

from xml.etree import ElementTree
from pathlib import *
from data_ingestion.utils.helper import Helper

# -------------------------------------------------------
# Create Helper object
# -------------------------------------------------------
helper = Helper()

# -------------------------------------------------------
# Create code_dir path
# -------------------------------------------------------
code_dir = str(Path(__file__).parent.resolve())

# -------------------------------------------------------
# Run data ingestion individuals "not join"
# -------------------------------------------------------
exec(open(code_dir+"/data_ingestion/appearance.py").read())
exec(open(code_dir+"/data_ingestion/arena.py").read())
exec(open(code_dir+"/data_ingestion/club.py").read())
exec(open(code_dir+"/data_ingestion/country.py").read())
exec(open(code_dir+"/data_ingestion/game.py").read())
exec(open(code_dir+"/data_ingestion/player.py").read())
exec(open(code_dir+"/data_ingestion/person.py").read())

# -------------------------------------------------------
# Run data ingestion individuals "join"
# -------------------------------------------------------
exec(open(code_dir+"/data_ingestion/club_arena_join.py").read())
exec(open(code_dir+"/data_ingestion/game_club_join.py").read())
exec(open(code_dir+"/data_ingestion/player_appearance_join.py").read())
exec(open(code_dir+"/data_ingestion/player_club_join.py").read())
exec(open(code_dir+"/data_ingestion/appearance_game_join.py").read())
exec(open(code_dir+"/data_ingestion/person_country_join.py").read())
exec(open(code_dir+"/data_ingestion/person_player_join.py").read())

# -------------------------------------------------------
# Zip files inside serialization folder
# -------------------------------------------------------
#helper.zip_files(code_dir + "/serialization/",code_dir + "/zip/serialization.zip")

