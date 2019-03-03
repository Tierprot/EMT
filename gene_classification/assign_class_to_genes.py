import json
from pprint import pprint
from multiprocessing import Pool

gene_pairs_json_file = "../gene_pairs_checked.json"

bases = {"Transcription factor" : "List_of_human_transcriprion_factors.txt"}
handlers = [open(x, "r") for x in bases.values()]
files = []
for h in handlers:
    lines = h.readlines()
    for line in lines:
        line.rstrip("\n")
    files.append(set(lines))
for f in handlers: f.close()

with open(gene_pairs_json_file) as f:    
    gene_pairs_json = json.load(f)

def process_article(entry):
    global bases,files
    pmid,article = entry
    pairs_to_delete = []
    for k,pair in zip(article["genes"].keys(),article["genes"].values()):
        if pair["database"] == "":
            pairs_to_delete.append(k)
            continue
        g1 = pair["gene_1_name"]
        g2 = pair["gene_2_name"]
        for base,lines in zip(bases.keys(),files):
            if (g1 in lines) | (g2 in lines):
                pair["type"] = base
    for k in pairs_to_delete:
        del article["genes"][k]
    article["genes"]
    print(pmid)
    return((pmid, article))

#entries = gene_pairs_json.values()
#foreach(process_article,entries,threads=2)
pool = Pool(16)
res = pool.map(process_article, zip(gene_pairs_json.keys(),gene_pairs_json.values()))

# print(res)

out = {}
for pmid,article in res:
   out[pmid] = article

with open("../gene_pairs_checked_classified.json", "w") as f:
    json.dump(out, f, indent = "\t", separators=(", ", " : "))

