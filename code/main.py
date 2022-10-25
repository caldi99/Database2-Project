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
# Run data ingestion
# -------------------------------------------------------
exec(open(code_dir+"/data_ingestion/games.py").read())
exec(open(code_dir+"/data_ingestion/clubs.py").read())
exec(open(code_dir+"/data_ingestion/club_games_join.py").read())
exec(open(code_dir+"/data_ingestion/player.py").read())
exec(open(code_dir+"/data_ingestion/country.py").read())
exec(open(code_dir+"/data_ingestion/appearance.py").read())

# -------------------------------------------------------
# Zip files inside serialization folder
# -------------------------------------------------------
helper.zip_files("serialization/","serialization/serialization.zip")

