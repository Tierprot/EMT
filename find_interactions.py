# gene_1 = "BRCA1"
# gene_2 = "ATF1"
# gene_1 = "A2M"
# gene_2 = "KLKB1"
gene_1 = "TLR4_HUMAN"
gene_2 = "LY96_HUMAN"

bases = ["BIOGRID-ALL-3.5.170.tab2/BIOGRID-ALL-3.5.170.tab2.txt",
         "Innate/innatedb_all.mitab",
         "Reactome/Reactome_ALL.txt",
         "RNA/RNA_all.txt"]

def parse_db_line(ref, line):
    keys = ref.rstrip().split("\t")
    values = line.rstrip().split("\t")
    return(dict(zip(keys,values)))

for base in bases:
    with open(base) as f:
        first_line = True
        for line in f:
            if first_line:
                ref = line
                first_line = False
            if base == "RNA/RNA_all.txt":
                if not ("Homo sapiens" in line):
                    continue
            if base == "Innate/innatedb_all.mitab":
                if not (("HUMAN" in line) | ("human" in line) | ("Human" in line)):
                    continue
            if (gene_1 in line) & (gene_2 in line):
                d = parse_db_line(ref, line)
                # print(d)
                if base == "Innate/innatedb_all.mitab":
                    score = d["confidence_score"]
                    type_1 = d["interactor_type_A"]
                    type_2 = d["interactor_type_B"]
                elif base == "RNA/RNA_all.txt":
                    score = ""
                    type_1 = d["Category1"]
                    type_2 = d["Category2"]
                else:
                    score = ""
                    type_1 = ""
                    type_2 = ""
                header = "gene_1,gene_2,type_1,type_2,database"
                # s = "%s,%s,%s,%s,%s\n" % (gene_1,gene_2,type_1,type_2,base)
                s ="+"
                # print(header)
                # print(s)
