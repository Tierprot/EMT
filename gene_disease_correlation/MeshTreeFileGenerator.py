import pickle
from tree import MeSHTree

root_node_address = "C04.588"
MESH = MeSHTree()

with open('mesh.pubmed') as inp:
    for item in inp:
        MESH.addNode(item)

nds = MESH.getAllChildrenNodes(root_node_address)
# print(len(nds))
names = []
for n in nds:
    names.append(n.text)
    print(n.id,"\t", n.text)

# for item in sorted(names):
#     print(item)
















# # first level
# nodes = MESH.getFirstChildrenList()
# nodes += root_node_childrens

# #second level
# for node in root_node_childrens.Children:
#     nodes2 += node.Children


# for node in nodes1:
#     for x in MESH.getFirstChildrenList(node.adress): nodes2.append(x)
# for node in nodes2:
#     for x in MESH.getFirstChildrenList(node.adress): nodes3.append(x)

# nodes = nodes1 + nodes2 + nodes3
# print(len(nodes))
# nodes = set(nodes)
# print(len(nodes))

# for node in nodes:
#     print(node.id)
# with open("tree.pickle", 'wb') as out:
#     pickle.dump(MESH, out, pickle.HIGHEST_PROTOCOL)

# print(MESH.getFirstChildren('D23.529.374.465'))
