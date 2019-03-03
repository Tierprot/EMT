import json
from MeshTreeFileGenerator import pick_diseases

db = "../gene_pairs.json"

def all_diseases(db):
    with open(db) as f:
        data = json.load(f)
    all_diseases = []
    for article in data.values():
        for dis_name,dis_MESH in zip(article["diseases"].keys(), article["diseases"].values()):
            all_diseases.append((dis_name, dis_MESH))
    # return list of tuples
    return(all_diseases)

def unique_diseases(db):
    all_dis = all_diseases(db)
    names = [x[0] for x in all_dis]
    MESHs = [x[1] for x in all_dis]

    unique_diseases_MESH = set(MESHs)
    unique_diseases_names = []
    # print(len(unique_diseases_MESH))

    for m in unique_diseases_MESH:
        for n,mesh in all_dis:
            if m == mesh:
                unique_diseases_names.append(n)
                break

    return(dict(zip(unique_diseases_names,unique_diseases_MESH)))

# dis = unique_diseases(db)
# print(len(dis))

# get list of associated genes for picked diseases
picked_diseases = [("D001749", "Urinary Bladder Neoplasms"),
                   ("D007680", "Kidney Neoplasms"),
                   ("D014594", "Uterine Neoplasms"),
                   ("D011471", "Prostatic Neoplasms")]
picked_diseases = pick_diseases()                   

genes_for_deseases = {}

# load our json
our_dbEMT = []
with open(db) as f:
    our_dbEMT_json = json.load(f)

for mesh,name in picked_diseases:
    list_of_genes = []
    for article in our_dbEMT_json.values():
        art_diseases = set(article["diseases"].values())
        if mesh in art_diseases:
            for pair in article["genes"].values():
                list_of_genes.append(pair["gene_1_name"])
                list_of_genes.append(pair["gene_2_name"])
    genes_for_deseases[mesh] = set(list_of_genes)
    print("Number of associated genes with %s:" % name,len(genes_for_deseases[mesh]))

with open("report.txt","w") as f:
    for mesh,name in picked_diseases:
        s = [str(name)]
        s += [gene for gene in sorted(genes_for_deseases[mesh])]
        # s += ["\n"]
        f.write((",").join(s))
        f.write("\n")
        # s.append()
        # f.write(str(name)+str(sorted(genes_for_deseases[mesh]))+"\n")


# with open("report_4.txt","w") as f:
#     for mesh,name in picked_diseases:
#         f.write(str(sorted(genes_for_deseases[mesh]))+"\n")


