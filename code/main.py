from xml.etree import ElementTree
import sys



# Parses the xml configuration file providing a dictionary with the paths to the datasets
def get_dataset_paths(config_path):
    tree = ElementTree.parse(config_path)
    root = tree.getroot()
    paths={}
    for child in root.iter('path'):
        paths[child.attrib['name']]=child.attrib['value']
    return paths


paths={}
try:
    # Get the first arg passed through CLI which is the path_config.xml path
    # 'paths' is a dictionary with couples (key,path)
    paths=get_dataset_paths(sys.argv[1])

except:
    print("Please execute this script by passing the path to the 'path_config.xml' file as first argument")
    exit()

#
# Invoke here the python files to serialize ttl files
#

