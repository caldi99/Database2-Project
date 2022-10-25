from xml.etree import ElementTree
from pathlib import *


code_dir=str(Path(__file__).parent.resolve())
# Invoking here the python files to serialize ttl files
exec(open(code_dir+"/data_ingestion/games.py").read())
exec(open(code_dir+"/data_ingestion/clubs.py").read())
exec(open(code_dir+"/data_ingestion/club_games_join.py").read())
exec(open(code_dir+"/data_ingestion/player.py").read())
exec(open(code_dir+"/data_ingestion/country.py").read())
exec(open(code_dir+"/data_ingestion/appearance.py").read())


