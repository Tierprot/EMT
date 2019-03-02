from find_interactions import *
import json
from pprint import pprint
from handythread import *
from multiprocessing import Pool

gene_pairs_json_file = "gene_pairs.json"

bases = {"BIOGRID" : "interaction_databases/BIOGRID/BIOGRID-ORGANISM-Homo_sapiens-3.5.170.tab2.txt",
         "REACTOME" : "interaction_databases/Reactome/Reactome.txt",
         "RNA" : "interaction_databases/RNA/RNA_all_reduced.txt"}

handlers = [open(x, "r") for x in bases.values()]
files = [x.readlines() for x in handlers]
for f in handlers: f.close()

with open(gene_pairs_json_file) as f:    
    gene_pairs_json = json.load(f)

def process_article(entry):
    global counter,N,bases,files
    pmid,article = entry
    gene_pairs = []
    # pairs = article["genes"].values()
    for pair in article["genes"].values():
        gene_pairs.append((pair["gene_1_name"],pair["gene_2_name"]))
    check = check_interactions(gene_pairs,bases,files)
    for pair,c in zip(article["genes"].values(),check):
        pair["database"] = c
    print(pmid, check)
    return((pmid, article))

#entries = gene_pairs_json.values()
#foreach(process_article,entries,threads=2)
pool = Pool(16)
res = pool.map(process_article, zip(gene_pairs_json.keys(),gene_pairs_json.values()))

# print(res)

out = {}
for pmid,article in res:
   out[pmid] = article

with open("gene_pairs_checked.json", "w") as f:
    json.dump(out, f, indent = "\t", separators=(", ", " : "))
