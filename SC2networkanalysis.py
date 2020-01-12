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
TITAN_SC_network_metrics_output = open("TITAN_SC_network_metrics_output.txt", 'a')

# to type into the VNC : find *.txt -exec python thesisnetworkanalysis.py {} \;

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
# Creation of an undirected, simple graph.

G = nx.Graph()
G.add_edges_from(edgelist)


print(G.number_of_nodes())
print(G.number_of_edges())

# ______________________________________________________________________________
# Creation of the connected component of interest.

# first helper
# Outputs list of nodes that are in the maximal component of I.
largest_CC_set_of_nodes = max(nx.connected_components(G), key=len)
#print(largest_CC_set_of_nodes)
#print(len(largest_CC_set_of_nodes))

# second helper
# Outputs the list of keys corresponding to all of the nodes identified with largest_CC_set_of_nodes.
#   NOTE : only runs through v[0] because otherwise will double count.
def pull_CC_key_value_pairs(CC_edgelist_dictionary_input, largest_CC_set_of_nodes_input):
    listyy = []
    for k,v in CC_edgelist_dictionary_input.items():
        for i in largest_CC_set_of_nodes_input:
            if str(i)==v[0]:
                listyy.append(k)
    return(listyy)

CC_keys_list = pull_CC_key_value_pairs(edgelist_dict, largest_CC_set_of_nodes)
#print(CC_keys_list)
#print(len(CC_keys_list))

# third helper function
# Outputs a subdictionary of the keys identified above (ie all edges included in
#   connected component) and appending all their values.
def create_CC_subdictionary(CC_edgelist_dictionary_input, CC_keys_list_input):
    dict = {k:CC_edgelist_dictionary_input[k] for k in CC_keys_list_input}
    return(dict)
CC_subdictionary = create_CC_subdictionary(edgelist_dict, CC_keys_list)
#print(CC_subdictionary)

# fourth helper
# Outputs edgelist from subdictionary in same way as above to create graph C.
def create_CC_final_edgelist(CC_edgelistex):
    CC_ed_list_output = [v for k, v in CC_edgelistex.items()]
    return(CC_ed_list_output)

CC_final_edgelist = create_CC_final_edgelist(CC_subdictionary)
#print(CC_final_edgelist)

# ______________________________________________________________________________
# Creation of graph of largest connected component.

C = nx.Graph()
C.add_edges_from(CC_final_edgelist)
print(C.number_of_nodes())
print(C.number_of_edges())
print(nx.number_connected_components(G))
print([len(c) for c in sorted(nx.connected_components(G), key=len, reverse=True)])

# ______________________________________________________________________________
# ______________________________________________________________________________

# [1] Degree centrality
# First helper
# Outputs a dictionary of nodes with int degree values
def int_degree_dict(dict_input):
    dict = {key:value*(len(C.nodes())-1) for key,value in dict_input.items()}
    return(dict)

final_int_degree_dict = int_degree_dict(degree_alg.degree_centrality(C))
#print(final_int_degree_dict)

def degree_list(final_int_degree_dict):
    listyy = []
    for k,v in final_int_degree_dict.items():
        listyy.append(int(v))
    return(listyy)

final_degree_list = degree_list(final_int_degree_dict)
#print(final_degree_list)
#print(np.bincount(final_degree_list))



# Narrow down to ones w degree exactly two

'''def degreetwo(final_int_degree_dict):
    listyy = []
    for k,v in final_int_degree_dict.items():
        if v==2.0:
            listyy.append(k)
    return(listyy)

degree_two_list_output = degreetwo(final_int_degree_dict)
#print(degree_two_list_output)

def degreeeight(final_int_degree_dict):
    listyy = []
    for k,v in final_int_degree_dict.items():
        if v==8.0:
            listyy.append(k)
    return(listyy)

degree_eight_list_output = degreeeight(final_int_degree_dict)
#print(degree_eight_list_output)

def degreesix(final_int_degree_dict):
    listyy = []
    for k,v in final_int_degree_dict.items():
        if v==6.0:
            listyy.append(k)
    return(listyy)

degree_six_list_output = degreesix(final_int_degree_dict)
#print(degree_six_list_output)'''

# [2] Betweenness centrality
# Def : the fraction of shortest paths between some pair of nodes, n1 and n2,
#   that pass through the node of interest.
# betweenness_centrality.betweenness_centrality(C)
#   Outputs dictionary of nodes with betweenness centrality as the value.
#   Only takes in connected graphs.
# We want : average betweenness centrality of the component containing the vertext
# through which initial infection is introduced

# Outputs a float representing the average betweenness centrality of component
#   containing i.

average_betweenness_centrality = float(
    sum(
    betweenness_centrality.betweenness_centrality(C).values())) / len(
    betweenness_centrality.betweenness_centrality(C))

# [3] Random Walk Centrality
# Note: Referred to as current flow in networkx.
# Def : the number of times a random walk from n1 to n2 passes through
#   the node of interest averaged over all nodes.
# random_walk_betweenness_centrality.current_flow_betweenness_centrality(C)
#   Outputs dictionary of nodes with random walk betweenness centrality as the value.
#   Only takes in connected graphs.
# We want : the average random walk betweenness centrality of component containing i.

# Outputs a float representing the average random walk betweenness centrality of
#   component containing i.

average_random_walk_betweenness_centrality = float(
    sum(
    random_walk_betweenness_centrality.current_flow_betweenness_centrality(C).values())) / len(
    random_walk_betweenness_centrality.current_flow_betweenness_centrality(C))

# [3a] random_walk_betweenness_centrality of the initial_infection

# [4] Component Size
# Def : a connected component of a graph as a subgraph of a simple graph G in
#   which every vertex is connected to every other vertex in the subgraph by a path.
# Def : the number of nodes in the connected component that contains i
# Outputs an int.

component_size = C.number_of_nodes()

# [5] Component Density
# Def : the number of edges in the graph divided by the number of total possible
#   edges the graph might have.
# Outputs a float.

component_density = component_density.density(C)

# [6] Geodesic Distance
# Def : the number of edges on the shortest path between two vertices. We want
#   the average geodesic distance for the component containing i.
# geodesic_distance.closeness_centrality(C)
#   Outputs a dictionary of nodes with closeness_centrality as the value. Reciprocal
#       of how defined in latex document.
# We want : the average geodesic distance in the component where the initial infection
#   is fist introduced

# Outputs a float representing the average geodesic distance in the component where
#   the initial infection is fist introduced

# AGD was computed by summing all geodesic lengths and dividing by the number of geodesics.

average_geodesic_dist = geodesic_distance.average_shortest_path_length(C)


# [7] Centralization
# Idea : "used to calculate the degree to which the network was centralized
#   around one or a few actors," "value reflects the extent to which the network
#   resembles a maximally centralized network in which all network members
#   are connected through one maximally central actor"
# Def : CentD = sum [(largest observed degree index) - (all degree indices in set)]
#                /  [(len(G.nodes)-1)(len(G.nodes)-2)]

# first helper
def int_degree_dict(dict_input):
    dict = {key:value*(len(C.nodes())-1) for key,value in dict_input.items()}
    return(dict)

# definitions
final_int_degree_dict = int_degree_dict(degree_alg.degree_centrality(C))
max_degree_val = max(final_int_degree_dict.values())
degree_vals = final_int_degree_dict.values()

# second helper function, not actually currently in use
# def subtract_dict(dict_input1):
#    dict = {key:max_degree_val-value for key,value in dict_input1.items()}
#    return(dict)

#subtracted_dict = subtract_dict(final_int_degree_dict)

centralization = ((max_degree_val * len(C.nodes())) - sum(degree_vals)) / ((
                    len(C.nodes())-1)*(len(C.nodes())-2))

#print(centralization)


# [8] k-cores
# Def : a maximal subgraph of G that contains vertices with degree at least k
# core.core_number(C)
#   Outputs dictionary of nodes with the core number for each vertex.

# Outputs a float representing the proportion of nodes in 2-cores in component
#   containing initial infection.

number_two_cores = ((sum(1 for x in core.core_number(C).values() if x==2)))
#print(number_two_cores)
#print(len(C.nodes()))

average_proportion_2_cores = float(number_two_cores) / len(C.nodes())
#print(average_proportion_2_cores)


# [9] Transitivity
# Def : the proportion of all triads that exhibit closure in the network
#   Outputs a float representing 3 (triangles / triads).

transitivity = transitivity.transitivity(C)

# [10] Diameter

# Def : The diameter is the maximum eccentricity.
#   The eccentricity of a node v is the maximum distance from v to all other nodes in G.

diameter = diameter.diameter(C)

# ______________________________________________________________________________

# How to display the network. pylab.show() is necessary if not in the interactive
#   mode. Enter into interactive mode by typing ipython -pylab in the cmd.

options = {
    'node_color': 'grey',
    'node_size': 1000,
    'width': 3,
}
#nx.draw_shell(C, with_labels=True, **options)
#pylab.show()

# ______________________________________________________________________________


# Writes to the file path.png in the local directory.
#plt.savefig("path.png")


# ______________________________________________________________________________

# Output file ! Don't forget to add a index // title column with "FILENAME" addition

TITAN_SC_network_metrics_output.write("{filename}\t{abc}\t{arwbc}\t{cs}\t{cd}\t{agd}\t{cent}\t{ap2c}\t{tran}\t{diam}\n".format(
    filename=filename,
    #adHIVpn=avg_degree_HIV_infected_nodes,
    #mdHIVpn=max_degree_HIV_infected_nodes,
    abc=average_betweenness_centrality,
    #ii_bc=ii_betweenness_centrality,
    arwbc=average_random_walk_betweenness_centrality,
    #ii_rwbc=ii_random_walk_betweenness_centrality,
    #ii_cc=ii_closeness_centrality,
    #ii_ec=ii_eigenvector_centrality,
    cs=component_size,
    cd=component_density,
    agd=average_geodesic_dist,
    #ii_gd=ii_geodesic_distance,
    cent=centralization,
    ap2c=average_proportion_2_cores,
    #ii_tct=ii_two_core_test,
    tran=transitivity,
    diam=diameter))
