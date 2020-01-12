# ______________________________________________________________________________
# ______________________________________________________________________________

# For networkx package.
import networkx as nx
import statistics
import numpy as np

import networkx.readwrite.edgelist

# For network visualization.
import matplotlib.pyplot as pylab

# For network metrics.
import networkx.algorithms.centrality.degree_alg as degree_alg
import networkx.classes.graph as G
import networkx.algorithms.centrality.betweenness as betweenness_centrality
import networkx.algorithms.centrality.current_flow_betweenness as random_walk_betweenness_centrality
import networkx.algorithms.centrality.closeness as closeness_centrality
import networkx.algorithms.centrality.eigenvector as eigenvector_centrality
import networkx.algorithms.components.connected as connected_components
import networkx.classes.function as component_density
import networkx.algorithms.core as core
import networkx.algorithms.cluster as transitivity
import networkx.algorithms.distance_measures as diameter
import networkx.algorithms.shortest_paths as geodesic_distance

# For command line arguments.
import sys
#print ("This is the name of the script: ", sys.argv[0])
#print ("Number of arguments: ", len(sys.argv))
print(str(sys.argv)) #"The arguments are: "

# Output File Construction
#FILENAME = look up "command line argument"
filename = sys.argv[1] #"edgelist_test_dict.txt"
#network_metrics_output_dist = open("network_metrics_output_dist.txt", 'a')

# to type into the VNC : find *.txt -exec python thesisnetworkanalysis.py {} \;

# ______________________________________________________________________________
# Build list from edge list output text file.

'''def create_edgelist_dict(filename):

#   with open(filename, 'r') as file:
#         rows = ( line.split('\t') for line in file )
#         dict = { row[0]:row[1:] for row in rows }      #here could try and get an index working
#    return(listy)

    with open(filename, 'r') as file:
         rows = ( line.split('\n') for line in file )
         final_rows = ( row[0].split() for row in rows)
         listy = [row[0:] for row in final_rows]
    return(listy)

edgelist = create_edgelist_dict(filename)'''
#print(edgelist)

# ______________________________________________________________________________
# Build list from edge list output csv file.

import csv
def create_edgelist_dict(filename):
    with open(filename, 'r') as f:
        reader = csv.reader(f)
        your_list = list(reader)
    return(your_list)

edgelist = create_edgelist_dict(filename)
#print(edgelist)

# ______________________________________________________________________________
# Build dictionary from edge list output text file with proper indices.

edgelist_dict = dict(enumerate(edgelist))
#print(edgelist_dict)

# ______________________________________________________________________________
# Build edge list of all edges to build larger graph.

def create_edgelist(edgelistex):
    ed_list_output = [(v[0], v[1]) for k, v in edgelistex.items()]
    return(ed_list_output)

final_edgelist = create_edgelist(edgelist_dict)
#print(final_edgelist)



# ______________________________________________________________________________
# Creation of an undirected, simple graph.

G = nx.Graph()
G.add_edges_from(final_edgelist)

print(G.number_of_nodes())
print(G.number_of_edges())


# ______________________________________________________________________________
# Determine degree distributions of sex v idu/both

def idu_section(edgelist_dict):
    idu_section_output = []
    for k, v in edgelist_dict.items():
        if v[2]=='idu' or v[2]=='both':
        #if v[2]=='sex':
            idu_section_output.append(k)
    return(idu_section_output)

idu_section_output = idu_section(edgelist_dict)

def create_idu_subdictionary(edgelist_dict, idu_section_output):
    idu_dict = {k:edgelist_dict[k] for k in idu_section_output}
    return(idu_dict)

idu_dict = create_idu_subdictionary(edgelist_dict, idu_section_output)
#print(len(idu_dict))
#print((idu_dict))


# ______________________________________________________________________________
# Create just the IDU Graph

def create_edgelist(edgelistex):
    ed_list_output = [(v[0], v[1]) for k, v in edgelistex.items()]
    return(ed_list_output)

idu_edgelist = create_edgelist(idu_dict)
#print(idu_edgelist)

I = nx.Graph()
I.add_edges_from(idu_edgelist)
print(I.number_of_nodes())
print(I.number_of_edges())

# Now get degree info

# ______________________________________________________________________________
# Create just the IDU Graph

# [1] Degree centrality
# First helper
# Outputs a dictionary of nodes with int degree values
def int_degree_dict(dict_input):
    dict = {key:value*(len(G.nodes())-1) for key,value in dict_input.items()}
    return(dict)

final_int_degree_dict = int_degree_dict(degree_alg.degree_centrality(G))
#print(final_int_degree_dict)

def degree_list(final_int_degree_dict):
    listyy = []
    for k,v in final_int_degree_dict.items():
        listyy.append(int(v))
    return(listyy)

final_degree_list = degree_list(final_int_degree_dict)
print(final_degree_list)
print(np.bincount(final_degree_list))
print(statistics.mean(final_degree_list))
