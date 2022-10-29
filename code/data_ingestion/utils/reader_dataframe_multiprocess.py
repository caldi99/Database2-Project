"""
    Author : Francesco Caldivezzi
"""

from multiprocessing import Process
import pandas 
from rdflib import Graph

class ReaderDataframeMultiprocess:
    """
        This class allows to process a dataframe with multithreading.
    """
    def __init__(self,dataframe : pandas.DataFrame, function_chunk_dataframe : function, binding_parameters : map  ,cores : int) -> None:
        """
            Constructor
            Parameters :
                dataframe : pandas.Dataframe
                    The dataframe that must be processed in parallel
                function_dataframe : function
                    A fuction that will process a single chunk of a dataframe, it must accepts a Graph object
                binding_parameters : map
                    A key-value pair of prefix and their Namespaces
                cores : int
                    The number of cores to use to process the dataframe
        """
        self.dataframe = dataframe
        self.function_chunk_dataframe = function_chunk_dataframe
        self.cores = cores
        self.binding_parameters = binding_parameters

    def split_dataframe(self) -> list:
        """
            This function returns a list of chunks of the dataframe to process.
            Returns :
                The list of chunks of dataframes to process in parallel.
        """
        list_dataframes = []        
        size_chunk = int(self.dataframe.shape[0] / self.cores)
        for i in range(0,self.dataframe.shape[0],size_chunk):
            list_dataframes.append(self.dataframe.iloc[i : i + size_chunk])
        
        return list_dataframes
        
    def init_graph(self) -> Graph:
        """
            Initialize a rdflib.Graph with the binding_paramters provided.
            Returns :
                The Graph initialized.
        """
        graph = Graph()

        for key, value in self.binding_parameters:
            graph.bind(key,value)
        
        return graph

    def run(self) -> None:
        """
            This function will start the process of reading with multithreading the dataframe.
        """
        dataframe_parts = self.split_dataframe()
        processes = []

        graph = self.init_graph

        for dataframe_part in dataframe_parts:
            process = Process(target = self.function_chunk_dataframe, args=(dataframe_part,))
            process.start()
            processes.append(process)
        
        for process in processes:
            process.join()