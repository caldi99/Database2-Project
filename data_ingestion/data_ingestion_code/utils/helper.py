"""
    Author : Francesco Caldivezzi
"""

import pandas as pd
from rdflib import Graph
from xml.etree import ElementTree
from pathlib import *
import os
from zipfile import ZipFile

class Helper:
    """
        This is a helper class for doing all the dirty jobs.
    """

    SERIALIZATION_TYPE = "turtle"    
    CODEC = "utf-8"
    PATHS_XML_PATH = str(Path(__file__).parent.parent.parent.resolve())+"/config/paths.xml"
    
    PATH_NODE_XML = "path"
    NAME_ATTRIBUTE_XML = "name"
    VALUE_ATTRIBUTE_XML = "value"
    

    def serialize(self,graph: Graph, output_path: str) -> None :
        """
            Serialize graph in output_path
            Parameters 
            graph : rdflib.Graph
                        The graph to serialize
            output_path : str
                        The output path where to serialize the graph
        """
        #windows complain with wb
        with open(output_path,'w') as file:
            file.write(graph.serialize(format = self.SERIALIZATION_TYPE))        

    def read_csv(self, path_csv: str, sep: str, index_col: str = None) -> pd.DataFrame:
        """
            Read the csv file
            Paramters :
                path_csv : str
                    The path where the csv is located
                sep : str
                    The separator of elements inside the csv file
                index_col : str
                    The column to consider as a key of the produced table
            Returns :
                The dataframe with the elements of the csv inside
        """
        return pd.read_csv(path_csv, sep = sep, index_col = index_col)

    
    def get_csv_path(self, name_file: str) -> str:
        """
            Returns the path of the name_file 
            Parameters :
                name_file : str 
                    The name of the .csv file
            Returns
                Path of the .csv file
        """

        base_dir=Path(self.PATHS_XML_PATH).parent.parent.parent.resolve()
        tree = ElementTree.parse(Path(self.PATHS_XML_PATH))
        root = tree.getroot()
        for child in root.iter(self.PATH_NODE_XML):
            if(child.attrib[self.NAME_ATTRIBUTE_XML] == name_file):

                # If the path is relative, make it relative to the root folder and not to the folder in which we run the script
                if(not os.path.isabs(child.attrib[self.VALUE_ATTRIBUTE_XML])):
                    p=str(base_dir)+child.attrib[self.VALUE_ATTRIBUTE_XML][1:]
                    return p
                else:
                    return child.attrib[self.VALUE_ATTRIBUTE_XML]
        raise Exception("There is no such file!")
