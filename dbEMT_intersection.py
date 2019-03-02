import json

def flatten_json(y):
    out = {}

    def flatten(x, name=''):
        if type(x) is dict:
            for a in x:
                flatten(x[a], name + a + '_')
        elif type(x) is list:
            i = 0
            for a in x:
                flatten(a, name + str(i) + '_')
                i += 1
        else:
            out[name[:-1]] = x

    flatten(y)
    return out

# load dbEMT
path_to_dbEMT = "interaction_databases/dbEMT/emt.hsa.info_seq.txt"
dbEMT = []
with open(path_to_dbEMT) as f:
    for line in f:
        dbEMT.append(line.split("\t")[1].strip())
dbEMT_genes = set(dbEMT)

# load our json and get list of genes
path_to_json = "gene_pairs.json"
our_dbEMT = []
with open(path_to_json) as f:
    our_dbEMT_json = json.load(f)
for article in our_dbEMT_json.values():
    for pair in article["genes"].values():
        our_dbEMT.append(pair["gene_1_name"])
        our_dbEMT.append(pair["gene_2_name"])
our_dbEMT_genes = set(our_dbEMT)

# report
print("Genes in dbEMT:",len(dbEMT_genes))
print("Genes in our_dbEMT:",len(our_dbEMT_genes))

intersection = our_dbEMT_genes.intersection(dbEMT_genes)
diffefence = dbEMT_genes.difference(our_dbEMT_genes)

print("Shared genes:",len(intersection))
print("Number of genes not found in our_dbEMT:",len(diffefence))

print("%.0f %% of dbEMT genes is in our_dbEMT" % (100.0-100.0*len(diffefence)/len(dbEMT_genes)))
print("%d genes from dbEMP are not in our_dbEMT" % len(diffefence))
