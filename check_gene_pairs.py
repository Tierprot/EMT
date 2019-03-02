from find_interactions import *
import json
from pprint import pprint

gene_pairs_json_file = "gene_pairs.json"

with open(gene_pairs_json_file) as f:    
    gene_pairs_json = json.load(f)

for article in gene_pairs_json.values():
    gene_pairs = []
    # pairs = article["genes"].values()
    for pair in article["genes"].values():
        gene_pairs.append((pair["gene_1_name"],pair["gene_2_name"]))
    check = check_interactions(gene_pairs)
    for pair,c in zip(article["genes"].values(),check):
        pair["database"] = c

with open("gene_pairs_checked.json", "w") as f:
    json.dump(gene_pairs_json, f, indent = "\t", separators=(", ", " : "))
