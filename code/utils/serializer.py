"""
    Author : Francesco Caldivezzi
"""

from rdflib import Graph

class Serializer:
    """
        This is a helper class for serializing graphs or the rdflib library
    """

    SERIALIZATION_TYPE = "turtle"    
    CODEC = "utf-8"
    
    def serialize(self,graph: Graph, output_path: str)-> None :
        """
            Serializa graph in output_path
            Parameters 
            graph : rdflib.Graph
                        The graph to serialize
            output_path : str
                        The output path where to serialize the graph
        """
        with open(output_path) as file:
            file.write(graph.serialize(format = self.SERIALIZATION_TYPE).decode(self.CODEC))        