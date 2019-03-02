# gene_1 = "BRCA1"
# gene_2 = "ATF1"
# gene_1 = "A2M"
# gene_2 = "KLKB1"
# gene_1 = "TLR4_HUMAN"
# gene_2 = "LY96_HUMAN"

# import time

def parse_db_line(ref, line):
    keys = ref.rstrip().split("\t")
    values = line.rstrip().split("\t")
    return(dict(zip(keys,values)))

def check_interactions(gene_pairs, bases, files):
    # gene_pairs = [("BRCA1", "ATF1"),
    #               ("A2M", "KLKB1"),
    #               ("TLR4_HUMAN", "LY96_HUMAN")]

    interaction_check = []

    # header = "gene_1,gene_2,type_1,type_2,database"
    # print(header)

    # start = time.time()

    for gene_1,gene_2 in gene_pairs:
        check = 0
        for base,f in zip(bases.keys(), files):
            first_line = True
            for line in f:
                if first_line:
                    ref = line
                    first_line = False
                d = parse_db_line(ref, line)
                if base == "BIOGRID":
                    ref_1 = d["Official Symbol Interactor A"].strip()
                    ref_2 = d["Official Symbol Interactor B"].strip()
                elif base == "REACTOME":
                    ref_1 = d["Gene1"].strip()
                    ref_2 = d["Gene2"].strip()
                elif base == "RNA":
                    ref_1 = d["Interactor1"].strip()
                    ref_2 = d["Interactor2"].strip()
                if set([ref_1, ref_2]) == set([gene_1, gene_2]):
                    check += 1
                    # print(ref_1, ref_2,gene_1, gene_2)

                # if (gene_1 in line) & (gene_2 in line):
                #     # d = parse_db_line(ref, line)
                #     # # print(d)
                #     # if base == "INNATE":
                #     #     score = d["confidence_score"]
                #     #     type_1 = d["interactor_type_A"]
                #     #     type_2 = d["interactor_type_B"]
                #     # elif base == "RNA":
                #     #     score = ""
                #     #     type_1 = d["Category1"]
                #     #     type_2 = d["Category2"]
                #     # else:
                #     #     score = ""
                #     #     type_1 = ""
                #     #     type_2 = ""
                    
                #     # s = "%s,%s,%s,%s,%s" % (gene_1,gene_2,type_1,type_2,base)
                #     check += 1
                #     # print(gene_1,gene_2,s)
        if check > 0:
            interaction_check.append(base)
        else:
            interaction_check.append("")
        # end = time.time()
        # print(end - start)
    return(interaction_check)

# gene_pairs = [("BRCA1", "ATF1"),
#               ("A2M", "KLKB1"),
#               ("A2M", "LY96_HUMAN"),
#               ("TLR4_HUMAN", "LY96_HUMAN")]

# a = check_interactions(gene_pairs)
# print(a)