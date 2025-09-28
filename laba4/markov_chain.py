import matplotlib.pyplot as plt
import networkx as nx
import numpy as np

#define matrix
P = [
    [5, 5, 0, 0],
    [5, 5, 3, 4],
    [3, 3, 0, 0],
    [3, 3, 2, 1]
]

#normalized
for i in range(len(P)):
    row_sum = sum(P[i])
    for j in range(len(P[i])):
        P[i][j] /= row_sum

#graph object
G = nx.Graph() 

# define and add nodes
nodes = [x for x in range(1,len(P),1)]
G.add_nodes_from(nodes)

# add edges and weights
for i in range(len(P)):
    for j in range(len(P[i])):
        if P[i][j] != 0: 
            #choice color
            if(P[i][j] <= 0.25):
                color = "red"
            elif(P[i][j] <= 0.5 and P[i][j] > 0.25):
                color = "orange"
            elif(P[i][j] <= 0.75 and P[i][j] > 0.5):
                color = "yellow"
            else:
                color = "green"

            G.add_edge(i+1, j+1, weight=P[i][j], color=color)

pos = nx.spring_layout(G)

#define labels
labels = {1:"Healthy", 2:"Unwell", 3:"Sick", 4:"Very sick"}
#get colors
edge_colors = [G[u][v]["color"] for u, v in G.edges()]
# show graph
nx.draw(G, edge_color = edge_colors,  node_size=500)
nx.draw_networkx_labels(G, pos ,labels=labels, font_size=12, font_color="black")
plt.show()