"""
    Author : Francesco Caldivezzi
"""

from utils.helper import Helper

helper = Helper()


# --------------------------------------------------------------------------
# Read teams.csv file
# --------------------------------------------------------------------------

games = helper.read_csv(helper.get_csv_path("teams"), "," , )