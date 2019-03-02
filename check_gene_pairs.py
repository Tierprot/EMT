from find_interactions import *
import json
from pprint import pprint
from handythread import *

gene_pairs_json_file = "gene_pairs.json"

with open(gene_pairs_json_file) as f:    
    gene_pairs_json = json.load(f)

N = len(gene_pairs_json.keys())
counter = 0

def process_article(article):
    global counter,N
    gene_pairs = []
    # pairs = article["genes"].values()
    for pair in article["genes"].values():
        gene_pairs.append((pair["gene_1_name"],pair["gene_2_name"]))
    check = check_interactions(gene_pairs)
    for pair,c in zip(article["genes"].values(),check):
        pair["database"] = c
    counter += 1
    print("%d/%d" % (counter,N))


entries = gene_pairs_json.values()
foreach(process_article,entries,threads=16)

with open("gene_pairs_checked.json", "w") as f:
    json.dump(gene_pairs_json, f, indent = "\t", separators=(", ", " : "))
