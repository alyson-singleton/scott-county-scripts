# goal here is to output a single text file that has the sum of the total_incidence
#   columns for each out our output Incidence_Reports

# ______________________________________________________________________________

# For command line arguments.
import sys
#print ("This is the name of the script: ", sys.argv[0])
#print ("Number of arguments: ", len(sys.argv))
print (str(sys.argv)) #"The arguments are: "

# Output File Construction
#FILENAME = look up "command line argument"
filename = sys.argv[1] #"edgelist_test_dict.txt"
incidence_sums_temp = open("incidence_sums_temp.txt", 'a')

# to type into the VNC : find *.txt -exec python thesisnetworkanalysis.py {} \;
# ______________________________________________________________________________

def create_edgelist_dict(filename):

    with open(filename, 'r') as file:
         rows = ( line.split('\n') for line in file )
         final_rows = ( row[0].split() for row in rows)
         listy = [row[0:] for row in final_rows]
    return(listy[1:])

edgelist = create_edgelist_dict(filename)
print(edgelist)

def output_sum(edgelist_input):
    listy = [int(i[2]) for i in edgelist_input]
    summy = sum(listy)
    return(summy)

incidence = output_sum(edgelist)
#print(incidence)

# ______________________________________________________________________________

# Output file ! Don't forget to add a index // title column with "FILENAME" addition

incidence_sums_temp.write("{filename}\t{totalinc}\n".format(
    filename=filename,
    totalinc=incidence))
