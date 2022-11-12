"""
    Author : Andrea Pasin
"""

from xml.etree import ElementTree
from pathlib import *
from data_ingestion_code.utils.helper import Helper

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
exec(open(code_dir+"/data_ingestion_code/appearance.py").read())
exec(open(code_dir+"/data_ingestion_code/arena.py").read())
exec(open(code_dir+"/data_ingestion_code/club.py").read())
exec(open(code_dir+"/data_ingestion_code/country.py").read())
exec(open(code_dir+"/data_ingestion_code/game.py").read())
exec(open(code_dir+"/data_ingestion_code/player.py").read())
exec(open(code_dir+"/data_ingestion_code/person.py").read())

# -------------------------------------------------------
# Run data ingestion individuals "join"
# -------------------------------------------------------
exec(open(code_dir+"/data_ingestion_code/club_arena_join.py").read())
exec(open(code_dir+"/data_ingestion_code/game_club_join.py").read())
exec(open(code_dir+"/data_ingestion_code/player_appearance_join.py").read())
exec(open(code_dir+"/data_ingestion_code/player_club_join.py").read())
exec(open(code_dir+"/data_ingestion_code/appearance_game_join.py").read())
exec(open(code_dir+"/data_ingestion_code/person_country_join.py").read())
exec(open(code_dir+"/data_ingestion_code/person_player_join.py").read())