# ______________________________________________________________________________
# ______________________________________________________________________________

# For networkx package.
import networkx as nx
import statistics

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
TITAN_network_metrics_output_RR_results5 = open("TITAN_network_metrics_output_RR_results5.txt", 'a')

# to type into the VNC : find *.txt -exec python thesisnetworkanalysis.py {} \;

# ______________________________________________________________________________
# Build list from edge list output text file.

def create_edgelist_dict(filename):

#   with open(filename, 'r') as file:
#         rows = ( line.split('\t') for line in file )
#         dict = { row[0]:row[1:] for row in rows }      #here could try and get an index working
#    return(listy)

    with open(filename, 'r') as file:
         rows = ( line.split('\n') for line in file )
         final_rows = ( row[0].split() for row in rows)
         listy = [row[0:] for row in final_rows]
    return(listy)

edgelist = create_edgelist_dict(filename)
#print(edgelist)

# ______________________________________________________________________________
# Build dictionary from edge list output text file with proper indices.

edgelist_dict = dict(enumerate(edgelist))
#print(edgelist_dict)

# ______________________________________________________________________________
# Build edge list of all edges to build larger graph.

def create_edgelist(edgelistex):
    ed_list_output = [(v[0], v[6]) for k, v in edgelistex.items()]
    return(ed_list_output)

final_edgelist = create_edgelist(edgelist_dict)
#print(final_edgelist)

# ______________________________________________________________________________
# Creation of an undirected, simple graph.

G = nx.Graph()
G.add_edges_from(final_edgelist)

#print(G.number_of_nodes())
totalnodecount = G.number_of_nodes()
#print(G.number_of_edges())
totaledgecount = G.number_of_edges()

# ______________________________________________________________________________
# Build edge list of just IDU users to build connected component, C.

# first helper
# recall edgelist_dict is our indexed dictionary
# Outputs a list of keys that are relationships that include at least one IDU
def pull_IDU_key_value_pairs(edgelist_dictionary_input):
    listyy = []
    for k,v in edgelist_dictionary_input.items():
        if 'IDU' in v:
            listyy.append(k)
    return(listyy)

IDU_keys_list = pull_IDU_key_value_pairs(edgelist_dict)
#print(IDU_keys_list)


# second helper
# Outputs a subdictionary of all keys that have at least one IDU and all their values
def create_IDU_subdictionary(edgelist_dictionary_input, IDU_keys_list_input):
    dict = {k:edgelist_dictionary_input[k] for k in IDU_keys_list_input}
    return(dict)
IDU_subdictionary = create_IDU_subdictionary(edgelist_dict, IDU_keys_list)
#print(IDU_subdictionary)


# third helper
# Outputs edgelist from subdictionary in same way as above to create graph I.
def create_IDU_final_edgelist(IDU_edgelistex):
    ed_list_output = [(v[0], v[7]) for k, v in IDU_edgelistex.items()]
    return(ed_list_output)

IDU_final_edgelist = create_IDU_final_edgelist(IDU_subdictionary)
#print(IDU_final_edgelist)

# ______________________________________________________________________________
# Creation of graph of IDU users.

I = nx.Graph()
I.add_edges_from(IDU_final_edgelist)

#print(I.number_of_nodes())
#print(I.number_of_edges())

# ______________________________________________________________________________
# Creation of the connected component of interest.

# first helper
# Outputs list of nodes that are in the maximal component of I.
largest_CC_set_of_nodes = max(nx.connected_components(I), key=len)
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
    CC_ed_list_output = [(v[0], v[7]) for k, v in CC_edgelistex.items()]
    return(CC_ed_list_output)

CC_final_edgelist = create_CC_final_edgelist(CC_subdictionary)
#print(CC_final_edgelist)

# ______________________________________________________________________________
# Creation of graph of largest connected component.

C = nx.Graph()
C.add_edges_from(CC_final_edgelist)
#print(C.nodes())
#print(C.number_of_edges())

CCnodescount = C.number_of_nodes()
CCedgescount = C.number_of_edges()

# ______________________________________________________________________________
# ______________________________________________________________________________

#Creation of an undirected, simple graph.

#G = nx.read_edgelist(filename, nodetype = int)

# Define the initial infection.
#initial_infection = 1703

# Creation of node and edge lists.
#G.add_nodes_from([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
#G.add_edges_from([(1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8)])
#G.add_edges_from([(11, 12), (2, 3), (8, 9)])

# Define the connected component of interest (i.e. the connected component where
#   the initial infection (i) is introduced.

#C = nx.Graph()

# Pull nodes that are connected to i and write into a list, list_connected_nodes.
#list_connected_nodes = list(connected_components.node_connected_component(G,initial_infection))
#C.add_nodes_from(list_connected_nodes)

# Finish constructing the connected component, C by grabbing all edges each node
#   in C had in G.
#list_connected_nodes1 = list(connected_components.node_connected_component(G,initial_infection))
#for i in list_connected_nodes1:
#    C.add_edges_from(G.edges(i))

# Print edge list for C.
# C.edges()

# ______________________________________________________________________________

# Tests
#print(G.number_of_nodes())
#print(G.number_of_edges())
#print(C.number_of_nodes())
#print(C.number_of_edges())
#print(G.adj)

# ______________________________________________________________________________
# ______________________________________________________________________________

# [1] Degree centrality
# Def : the number of nodes that each node is connected to.
# degree_alg.degree_centrality(G) --> produces fraction of nodes, not integer
#   Outputs dictionary of nodes with degree centrality (fraction) as the value.
#   Num : number of neighbors, Denom : n-1 where n is the number of nodes in the graph.
# We want:
#   - degree of vertex through which the initial infection is introduced
#   - avg degree of all HIV infected vertices

# First helper
# Outputs a dictionary of nodes with int degree values
def int_degree_dict(dict_input):
    dict = {key:value*(len(G.nodes())-1) for key,value in dict_input.items()}
    return(dict)

final_int_degree_dict = int_degree_dict(degree_alg.degree_centrality(G))
#print(final_int_degree_dict)

# Second helper
# Outputs list of nodes that are HIV-infected
def pull_HIV_infected_nodes(int_degree_dict_input):
    listyy = []
    for k,v in int_degree_dict_input.items():
        if 'True' in v[6]:
            listyy.append(v[0])
        if 'True' in v[13]:
            listyy.append(v[7])
    return(listyy)

HIV_infected_nodes_list = pull_HIV_infected_nodes(edgelist_dict)
#print(HIV_infected_nodes_list)
#print(len(HIV_infected_nodes_list))

# New helper
# pull only nodes in CCC out of HIV_infected_nodes_list
def pull_HIV_CC_nodes_list(HIV_infected_nodes_list, CC_nodes_list):
    listy = []
    for i in HIV_infected_nodes_list:
        if i in CC_nodes_list:
            listy.append(i)
        else: pass
    return(listy)

HIV_CC_nodes_list = list(set(pull_HIV_CC_nodes_list(HIV_infected_nodes_list, C.nodes())))
#print(HIV_CC_nodes_list)

# Third helper
# Outputs dictionary that is a subditionary of final_int_degree_dict with only
#   HIV infected nodes and their int degree
def HIV_infected_int_degree_dict(int_degree_dict, HIV_infected_nodes_list_input):
    dict = {m:int_degree_dict[m] for m in HIV_infected_nodes_list_input}
    return(dict)

HIV_infected_int_degree_subdictionary = HIV_infected_int_degree_dict(final_int_degree_dict, HIV_CC_nodes_list)
#print(HIV_infected_int_degree_subdictionary)
#print(len(HIV_infected_int_degree_subdictionary))

# Our two desired outputs
# [A] Average degree of all HIV infected vertices at t=0.

def avg_degree_HIV_infected_nodes_calc(HIV_infected_int_degree_subdictionary):
    if len(HIV_infected_int_degree_subdictionary) > 0:
        return(sum(HIV_infected_int_degree_subdictionary.values()) / len(HIV_infected_int_degree_subdictionary))
    else:
        return(0)


avg_degree_HIV_infected_nodes = avg_degree_HIV_infected_nodes_calc(HIV_infected_int_degree_subdictionary)
#print(avg_degree_HIV_infected_nodes)

# [B] Max degree of all of the HIV infected nodes at t=0.

def max_degree_HIV_infected_nodes_calc(HIV_infected_int_degree_subdictionary):
    if len(HIV_infected_int_degree_subdictionary) > 0:
        return(max(HIV_infected_int_degree_subdictionary.values()))
    else:
        return(0)

max_degree_HIV_infected_nodes = max_degree_HIV_infected_nodes_calc(HIV_infected_int_degree_subdictionary)
#print(max_degree_HIV_infected_nodes)

# [C] Find key of the max_degree_HIV_infected (effictively the initial_infection)
def find_ii_key(HIV_infected_int_degree_subdictionary, max_degree_HIV_infected_nodes):
    for k,v in HIV_infected_int_degree_subdictionary.items():
        if v==max_degree_HIV_infected_nodes:
            return k
        else:
            pass

ii_key = find_ii_key(HIV_infected_int_degree_subdictionary, max_degree_HIV_infected_nodes)
#print(ii_key)

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

# [2a] betweenness_centrality of the initial_infection

ii_betweenness_centrality = betweenness_centrality.betweenness_centrality(C)[ii_key]
#print(ii_betweenness_centrality)

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

ii_random_walk_betweenness_centrality = random_walk_betweenness_centrality.current_flow_betweenness_centrality(C)[ii_key]
#print(ii_random_walk_betweenness_centrality)

# [3b] closeness_centrality of the initial_infection

ii_closeness_centrality = closeness_centrality.closeness_centrality(C)[ii_key]

# [3c] eigenvector_centrality of the initial_infection

ii_eigenvector_centrality = eigenvector_centrality.eigenvector_centrality(C, max_iter=1000)[ii_key]

# [4] Component Size
# Def : a connected component of a graph as a subgraph of a simple graph G in
#   which every vertex is connected to every other vertex in the subgraph by a path.
# Def : the number of nodes in the connected component that contains i
# Outputs an int.

component_size = C.number_of_nodes()
number_connected_components = connected_components.number_connected_components(G)


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

# [6a] geodesic distance of the initial_infection

ii_geodesic_distance = max(geodesic_distance.single_source_shortest_path_length(C, source=ii_key).values())

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

# [8a] is the initial_infection in a 2-core
#   binary output: 1 for yes, 0 for no

def ii_two_core_test(C,ii_key):
    if core.core_number(C)[ii_key]==2:
        return(1)
    else:
        return(0)

ii_two_core_test=ii_two_core_test(C,ii_key)
#print(ii_two_core_test)


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
TITAN_network_metrics_output_RR_results5.write("{filename}\t{adHIVpn}\t{mdHIVpn}\t{abc}\t{ii_bc}\t{arwbc}\t{ii_rwbc}\t{ii_cc}\t{ii_ec}\t{cs}\t{ncc}\t{cd}\t{tnc}\t{tec}\t{ccnc}\t{ccec}\t{agd}\t{ii_gd}\t{cent}\t{ap2c}\t{tran}\t{diam}\n".format(
    filename=filename,
    adHIVpn=avg_degree_HIV_infected_nodes,
    mdHIVpn=max_degree_HIV_infected_nodes,
    abc=average_betweenness_centrality,
    ii_bc=ii_betweenness_centrality,
    arwbc=average_random_walk_betweenness_centrality,
    ii_rwbc=ii_random_walk_betweenness_centrality,
    ii_cc=ii_closeness_centrality,
    ii_ec=ii_eigenvector_centrality,
    cs=component_size,
    ncc=number_connected_components,
    cd=component_density,
    tnc=totalnodecount,
    tec=totaledgecount,
    ccnc=CCnodescount,
    ccec=CCedgescount,
    agd=average_geodesic_dist,
    ii_gd=ii_geodesic_distance,
    cent=centralization,
    ap2c=average_proportion_2_cores,
    ii_tct=ii_two_core_test,
    tran=transitivity,
    diam=diameter))


# Output file for 2-core testing ! Don't forget to add a index // title column with "FILENAME" addition

#network_metrics_output_second_attempt.write("{filename}\t{ap2c}\n".format(
#    filename=filename,
#    ap2c=average_proportion_2_cores))

# Output file for distance functions (fixed geodesic distance and added diameter funcetion)

#network_metrics_output_dist.write("{filename}\t{agd}\t{ii_gd}\t{diam}\n".format(
#    filename=filename,
#    agd=average_geodesic_dist,
#    ii_gd=ii_geodesic_distance,
#    diam=diameter))
