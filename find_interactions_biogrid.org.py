# https://wiki.thebiogrid.org/doku.php/biogridrest
import requests
import json

# setup request parameters
URL = "https://webservice.thebiogrid.org/interactions/"
params = {"accesskey" : "1ebc479d99a15ab52f9e3e231ea43bf9",
          "format" : "json",
          "interSpeciesExcluded" : "true",
          "selfInteractionsExcluded" : "true",
          "includeInteractors" : "false",
          "includeInteractorInteractions" : "false",
          "searchSynonyms" : "true",
          "searchIds" : "false",
          "searchNames" : "true",
          "max" : "10"}

# dummy gene names for search in BioGrid
gene_1 = "BRCA1"
gene_2 = "ATF1"


# perform request
params["geneList"] = "|".join([str(gene_1), str(gene_2)])
r = requests.get(URL, params)

# process respond for output

r = json.loads(json.dumps(r.json()))

if len(r)>0:
    print("+")
else:
    print("-")
# print(json.dumps(r, indent=4, sort_keys=True))


