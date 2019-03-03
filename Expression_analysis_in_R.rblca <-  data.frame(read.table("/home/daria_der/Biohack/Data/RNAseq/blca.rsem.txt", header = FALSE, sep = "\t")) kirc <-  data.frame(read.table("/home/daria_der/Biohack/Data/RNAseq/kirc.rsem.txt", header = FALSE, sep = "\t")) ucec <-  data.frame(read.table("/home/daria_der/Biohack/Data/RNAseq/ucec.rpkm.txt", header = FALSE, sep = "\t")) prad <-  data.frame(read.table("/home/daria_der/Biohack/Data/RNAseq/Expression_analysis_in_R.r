
require(bestNormalize)

require(lattice)

### 

remove_outliers <- function(x, na.rm = TRUE, ...) {
  qnt <- quantile(x, probs=c(.25, .75), na.rm = na.rm, ...)
  H <- 1.5 * IQR(x, na.rm = na.rm)
  y <- x
  y[x < (qnt[1] - H)] <- NA
  y[x > (qnt[2] + H)] <- NA
  y
}


## data import

blca <-  data.frame(read.table("/home/daria_der/Biohack/Data/RNAseq/blca.rsem.txt", header = FALSE, sep = "\t"))
kirc <-  data.frame(read.table("/home/daria_der/Biohack/Data/RNAseq/kirc.rsem.txt", header = FALSE, sep = "\t"))
ucec <-  data.frame(read.table("/home/daria_der/Biohack/Data/RNAseq/ucec.rpkm.txt", header = FALSE, sep = "\t"))
prad <-  data.frame(read.table("/home/daria_der/Biohack/Data/RNAseq/prad.rsem.txt", header = FALSE, sep = "\t"))



gene_list_one <- c("CD44", "CD24","CDH1","TWIST", "FOXC2", "SNAL1", "VIM", "ZFHX1B", "SNAL2", "TWIST2", "FN")
gene_list_bladder <- c("Neoplasms","19a","5-HT1B","ACTA2","AKR1C1","AKT","AKT2","ALCAM","ALKBH","ALKBH2","ANXA2","AP-1","AR","ARID1A","ARMc8","AS1","ASMA","ATF6","ATG3","ATG5","AXIN2","Akt","Argonaute2","Armadillo repeat-containing protein 8","Astrocyte elevated gene-1","Aurora kinase A","B-cell translocation gene 2","B7-H4","B7-homolog 4","BAMBI","BMI-1","BMI1","BMP","BMP2","BTG2","Bax","Bcl-2","Bcl-xl","Bmi1","C-C chemokine receptor type 7","CA9","CADM1","CCL2","CCR7","CD-31","CD11b","CD163","CD24","CD31","CD34","CD44","CD56","CDH1","CDH2","CDK4/6","CDKN1A","CIP1","CIP2A","CK20","CK5/6","CLASP2","CLCA4","COL13A1","COL4A1","COL5A2","COL6A3","COX-1","COX-2","COX2","CREB1","CRK","CRK-II","CTHRC1","CTLA4","CUL4B","CXCR4","CXCR7","Caspase-3","Caspase-8","Caspase3","Cell adhesion molecule 1","Collagen type VI alpha 3","Cox","Cox-2","Cyclin D1","Cyclin-D1","Cyclooxygenase-2","Cytokeratin-18","Cytoplasmic linker-associated protein 2","DAB2IP","DANCR","DEPTOR","DGCR5","DIO3","DLK1","DNA methyltrans-ferase (DNMT)3B","DNA methyltransferase 1","DNMT1","DNMT3B","DOC-2/DAB2 interactive protein","DR5","Dhh","DiGeorge syndrome critical region gene 5","Dicer","E- and N-cadherin","E-Cadherin","E-cadherin","E-cadherin) and muscarinic receptor","E2F1","E2F3","EDEM1","EGF","EGFR","EGR1","EIF5A2","EMT","EN2","ERBB2","ERBB2/3","ERBB3","ERK","ERK 1/2","ERK1/2","ERK2","ERK5","ERRFI-1","ERRFI-1/luciferase","ERdj4","EZH2","Engrailed 2","ErbB3","FAK","FAP","FERMT1","FGF","FGF-1","FGF-2","FGF2","FGF6","FGF8","FGFR1","FGFR2","FGFR3","FGFR4","FOXO3a","FOXQ1","FSCN1","Fak","Feline sarcoma-related protein","Fer","Fermitin family member 1","Fibroblast Growth Factor-1","Fibronectin","FoxC2","G-CSF","GATA3","GDF15","GLI family zinc finger 1","GLUT1","GP73","GSK3beta","Gab1","Gli-1","Gli2","Golgi membrane protein 73","Gr1","GrB","Granzyme B","Grb2","Growth differentiation factor-15","H19","H2A.Z","H2A.Z.1","H2A.Z.2","H2AFV","H2AFZ","HAF","HGF","HIF-1alpha","HK2","HMGA2","HMGB1","HMGN5","HOTAIR","HRAS","HRAS*","Heterogeneous nuclear ribonucleoprotein L","High mobility group protein2","Hipk2","Homeodomain-interacting protein kinase-2","IDO","IDO1","IL-10","IL-6","IL-6R","IL-8","IL2","IL6","ILK","IRE1","ITGA3","Indoleamine 2","3-dioxygenase 1","Integrin-linked kinase","Itch","JNK","Jagged 1","Jarid2","Jun N-terminal kinase","KAI1","KLF4","KLF8","KLbeta","KRAS","KRT5/6","Ki-67","Kindlin-1","Kindlin-2","Kip1","LAMB3","LAMC2","LAPTM5","LASS2","LDHB","LINC01296","LINC01605","LSINCT5","Lkb1","MACC1","MAEL","MALAT-1","MAPK","MAPK1","MASPIN","MCP-1","MCT1","MDM2","ME1","MEG3","MEK","MFGE8","MIR503","MIR503HG","MITF","MLKL","MMP","MMP-2","MMP-7","MMP-9","MMP1","MMP10","MMP2","MMP2","9","MMP2/9","MMP7","MMP9","MMPs","MSI2","MTSS1","MUC1","MYCN","Matrix metalloproteinase-9","Matrix metalloproteinases 9","Mdm2","MiR","MiR-429","MicroRNA-124-3p","MicroRNA-200c","Monocarboxylate transporter isoform 1","N- cadherin","N-Cadherin","N-cadherin","N-myc","N-myc downstream regulated gene 1","NACC1","NANOG","NCYM","NDRG1","NDRG2","NDRG3","NF-kappaB","NGAL","NOTCH1","NOTCH2","NSBP1","NUAK Family Kinase 1","NUAK1","Nanog","Nedd4","Nfe2l2","Nkx2.8","Notch","Notch 1","Nrf2","OX40L","Oct4","P21","PAICS","PARP","PARP-1","PCMT1","PCNA","PD-L1","PD-L2","PD1","PDCD4","PDCD4-pcDNA3","PDEF","PDGFR","PEDF","POK erythroid myeloid ontogenic factor","PP2A","PPAR","PPM1A","PRSS8","PTEN","Par3","Par6","Periostin","Peroxisome Proliferator-Activated Receptor","Pigment epithelium-derived factor","Pokemon","Prostasin","Ptch2","Pten","RAS GAP","RAS GTPase-activating protein","RASAL2","RI","RIPK1","RNase A","ROC1","ROCK1","ROCK2","ROR","RWD domain containing 4","RWDD4","Rab","Rab25","Rac1","Raf","Regulator of cullins-1","RelA","Ribonuclease inhibitor","Rip2","Ror-2","Ror2","S100A4","SATB1","SDF1","SENP2","SF/HGF","SH3 domain binding glutamic acid-rich protein like 3","SH3BGRL3","SIP1","SIRT1","SKI-like proto-oncogene","SKIL","SLUG","SMA","SMAD3","SNAI1","SNAI2","SNAIL","SNAIL1","SNHG6","SOX2","STAT-6","STAT3","STAT5","STMN1","SUFU","Sema4D","Shh","Slug","Smad-3","Smad2","Smad2/3","Smad3","Snail","Snail-1","Snail1/2","SnoN","Sonic hedgehog","Sox2","Special AT-rich sequence-binding protein-1","Src","T-cell factor","TACC1","TACC3","TCF","TFRC","TGF-alpha","TGF-beta","TGF-beta type I receptor","TGF-beta1","TGFalpha","TIMP-1","TIMP1","TM","TNF alpha","TNFRSF10A","TNFRSF10B","TNM","TP53","TP73","TRIM65","TRPM7","TSP-1","TUG1","TWIST","TWIST1","Tenascin-C","Thrombomodulin","Tn-C","Transforming growth factor beta1","Transient receptor potential melastatin 7","Trim59","Twist","Twist 1","Twist-1","Twist1","UCA1","USP21","VEGF","VEGFA","VEGFR","VEGFR2","VGLL1","VGLL4","Vestigial Like Family Member 4","Vimentin","WAF1","WIF-1","WT1","Wnt","Wnt inhibitory factor 1","Wnt/c-myc","Wnt4","Wnt5a","Wnt7a","X inactive specific transcript","XIST","YAP","ZEB1","ZEB1/2","ZEB2","ZEB2-AS1","ZEB2NAT","ZO-1","ZO1","Zeb-1","Zeb-2","Zeb1","Zeb2","activator protein 1","aldo-keto reductase 1C1","alpha-SMA","androgen receptor","angiogenin","annexin A2","astrocyte elevated gene-1","beta-Klotho (KLbeta)","beta-catenin","bone morphogenetic protein","c-Fos","c-Jun","c-MET","c-Met","c-Src","c-myc","carbonic anhydrase 9","caspase-3","caspase-3"," -8 and -9","caspase-8","cathepsin B","chemokine (C-C motif) ligand 2","claudin-1","cofilin","collagen type V alpha 2","cullin 4B","cyclin D1","cyclin dependent kinase 2","cyclin-dependent kinase 2","cyclinD1","cyclinE1","cyclooxygenase 2","cyclooxygenase-2","cytokeratin 18","cytokeratin 5/6","cytokeratin 7","e-cadherin","eIF5A2","early growth response gene 1","epidermal growth factor receptor","eukaryotic translation initiation factor 5A2","extracellular regulated protein kinase 5","extracellular regulated protein kinases 1 and 2","extracellular regulated protein kinases 5","extracellular signal-regulated kinase","fibroblast growth factor receptor-2","fibroblast growth factor-1","fibronectin","focal adhesion kinase","glycogen synthase kinase 3beta","granulocyte macrophage colony-stimulating factor","granulocytic colony stimulating factor","hTERT","hepatocyte growth factor","hepatoma-derived growth factor","high mobility group box 1","high-mobility group protein A2","histone deacetylase (HDAC)1/2","hnRNP-L","hypoxia-associated factor","hypoxia-inducible factor (HIF)-1alpha","indoleamine 2","3-dioxygenase","integrin alpha3","integrin-linked kinase","interleukin (IL)-6","interleukin (IL)-8","kindlin-1","lactadherin","mTOR","maelstrom","malat1","malic enzyme 1","mammalian target of rapamycin","mammary serine protease inhibitor","matrix metalloprotease 9","matrix metalloprotein-2","matrix metalloproteinase (MMP)-2","matrix metalloproteinase 10","matrix metalloproteinase 9","matrix metalloproteinase-2","matrix metalloproteinase-9","metastasis suppressor 1","miR","miR-107","miR-10b","miR-124-3","miR-124-3p","miR-141","miR-143","miR-145","miR-146a","miR-149","miR-155","miR-186","miR-192","miR-200b","miR-200c","miR-203","miR-205","miR-205HG","miR-21","miR-22","miR-221","miR-224","miR-23b","miR-29b","miR-301b","miR-30c","miR-331","miR-34a","miR-3658","miR-374b","miR-409","miR-424","miR-429","miR-433","miR-451","miR-506","miR-612","miR-92","miR-92b","miR-96","miR141","miR506","miRNA-23b","miRNA-29c","microRNA-429","mir-34a","mitogen-activated protein kinase 1","monocyte chemotactic protein (MCP)-1","musashi RNA binding protein 2","n-cadherin","neuronal cadherin","nm23-H1","nucleus accumbens-associated protein 1","p-c-Jun","p14","p16","p19","p21","p27","p38","p38 mitogen-activated protein kinase","p53","p63","p63alpha","pT1","periostin","phosphatidylinositol 3-kinase","phospho-epithelial growth factor receptor","phosphoinositide 3-kinase","platelet derived growth factor receptor","prostasin","protein l-isoaspartate (d-aspartate) O-methyltransferase","ribonuclease inhibitor","ribonuclease inhibitor (RI)","semaphorin 4D","si-Twist1","signal transducer and activator of transcription 3","sirtuin 1","snail","snail-1","snoRNA host gene 6","suppressor of zeste 12","suz12","tNOX","telomerase reverse transcriptase","thrombospondin-1","tight junction protein ZO-1","transforming growth factor (TGF)-beta1","transforming growth factor beta","tricellulin","tumor inhibitor of metalloproteinase-1","tumor-associated NADH oxidase","uPAR","urokinase-type plasminogen activator","vascular endothelial growth factor","vascular endothelial growth factor receptor","vimentin","vitronectin","zeb1","zeb2","zinc finger E-box binding homeobox 1","zinc finger E-box binding homeobox 1 and 2","zinc finger E-box-binding homeobox 1")
gene_list_kidney <- c("3-phosphoinositide-dependent protein kinase 1","AAA+ ATPase pontin","ADAM10","ADAM17","AE1","AE3","AKT","AMAP1","AR","ARF6","AXL","Akt","Alpha B-crystallin","Arf6","Bax","Bcl-2","Bnip3","CCL2","CD103","CD132","CD204","CD274","CD34","CD44","CK2alpha","CK2beta","CREB","CRIM1","CRYAB","CTNNB1","CXCR4","CYP3A4","Calpain small subunit 1","Capn4","Cav1","Cyclic-AMP-responsive element-binding protein","DCLK1","DDR1","DIO2","DMRT2","Doublecortin-like kinase 1","E- cadherin","E-cadherin","EFA6","EGFR","EMT","EPB41L5","ERK","Egfr","FAK","FH","FLCN","FOXO3","FOXO3a","GATA3","GEP100","Galectin-1","Gsn","HIF-1 alpha","HIF1alpha","HIF2alpha","HPIP","HSPB5","Hsp-27","IL-1 beta","IL-15","IL-15Ralpha","IL-17","IL-6","Itgb2","JMJD3","JNK","KCNJ15","KDM6B","KERATIN7","KLF8","L1-CAM","LDH","LDH-A","LIF","LIM1","Lgals3","Lim homeobox 1","Lim1","MAN1C1","MICA","MITF","MK","MMP-2","MMP-9","MMP14","MMP2","MMP9","Major histocompatibility complex class I-related chains A","Mcl-1","N-Cadherin","N-cadherin","NANOG","NF-kappaB","NKG2D) receptor","OCT4","Oct 4","PAX2","PD-L1","PDK1","PIK3R1","PKC","PMS1 homolog 2","PMS2","Pax-2","Pax8","Podoplanin","RANKL","RCAN1","RTK","Regulator of calcineurin 1","RhoA","S100A4","SCC","SCP","SIP1","SIRT1","SLUG","SNAI1","SNAIL","SNAIL1","SOX2","SOX4","SPOP","SREBP-1c","STAT1","STAT3","Six1","Slug","Smad-interacting protein 1","Snail","Snail1","TCF21","TCF4","TFAP2B","TFCP2L1","TGF-beta","TGF-beta(1","TGF-beta(1)","TGF-beta1","TNF-alpha","TNM","TPD52","TSC2","Transforming growth factor-beta1","Tuberous Sclerosis Complex 2","Twist1","VEGFA","VEGFD","VEGFR1","VHL","VIM","Vimentin","WT-1","WT1","ZEB-1","ZEB1","ZEB2","ZO-1","Zeb1","androgen receptor","beta(1)-subunit of Na","K-ATPase","beta-catenin","c-Met","c-jun N-terminal kinase","chemokine (C-C motif) ligand 2","claudin-1","cyclin D1","cyclin-dependent kinase inhibitor 1B","cytokeratin19","epidermal growth factor receptor","fibroblast growth factor receptor 2","fibronectin","focal adhesion kinase","folliculin","fumarate hydratase","galectin-1","galectin-1-CXCR4","interleukin-15","mTOR","mammalian target of rapamycin","matrix metalloproteinase (MMP) 2","matrix metalloproteinase (MMP)-7","matrix metalloproteinase-2","melanogenesis-associated transcription factor","miR-141","miR-192","miR-200a","miR-200b","miR-200c","miR-205","miR-21","miR-22","miR-34a","miR-429","microRNA-21","microRNA-22","midkine","p21","p53","p63","pRCC","pontin","prostate specific antigen","receptor tyrosine kinase","signal transducer and activator of transcription 3","speckle-type POZ protein","transforming growth factor (TGF)-beta","tumor necrosis factor alpha","tumor necrosis factor-alpha","v-akt murine thymoma viral oncogene homolog 1","vascular endothelial growth factor A","vascular endothelial growth factor receptor 1","vimentin","von Hippel-Lindau")
gene_list_uterine <- c("AE1","AE3","B-catenin","E-cadherin","N-cadherin","PAX8","TWIST1","ZEB1","ZEB2","cyclin D1","deltaEF1","fascin","p16","p53")

### data normalisation


for (i in (1 : nrow(blca))){
  print(i)
  blca[i, 2:ncol(blca)] <- c(remove_outliers(as.numeric(boxcox(as.numeric(blca[i,2:ncol(blca)]), standardize = TRUE)$x.t)))
}


write.table(blca,file="blca_normalised.txt")

for (i in (1 : nrow(kirc))){
  kirc[i, 2:ncol(kirc)] <- c(remove_outliers(as.numeric(boxcox(as.numeric(kirc[i,2:ncol(kirc)]), standardize = TRUE)$x.t)))
}

write.table(kirc,file="Kirk_normalised.txt")

for (i in (1 : nrow(ucec))){
  ucec[i, 2:ncol(ucec)] <- c(remove_outliers(as.numeric(boxcox(as.numeric(ucec[i,2:ncol(ucec)]), standardize = TRUE)$x.t)))
  }
  
write.table(ucec,file="Ucec_normalised.txt")
  

for (i in (i : nrow(prad))){
    prad[i, 2:ncol(prad)] <- c(remove_outliers(as.numeric(boxcox(as.numeric(prad[i,2:ncol(prad)]), standardize = TRUE)$x.t)))
  }

write.table(prad,file="prad_normalised.txt")




## add annotations


## import data
prad_real_normalised <- data.frame(read.table("/home/daria_der/prad_normalised.txt"))
ucec_real_normalised <- data.frame(read.table("/home/daria_der/Ucec_normalised.txt"))
blca_real_normalised <- data.frame(read.table("/home/daria_der/blca_normalised.txt"))
kirk_real_normalised <- data.frame(read.table("/home/daria_der/kirk_normalised.txt"))

kirk_real_normalised = kirc.new

### data annotation






rownames(prad_real_normalised) = prad[,1]
rownames(ucec_real_normalised) = ucec[,1]
rownames(blca_real_normalised) = blca[,1]
rownames(kirk_real_normalised) = kirc[,1]
colnames(prad_real_normalised) = colnames(prad)
colnames(ucec_real_normalised) = colnames(ucec)
colnames(blca_real_normalised) = colnames(blca)
colnames(kirk_real_normalised) = colnames(kirc)



### len testing
ncol(prad_real_normalised)
ncol(ucec_real_normalised)
ncol(blca_real_normalised)
ncol(kirc_real_normalised)

nrow(prad_real_normalised)
nrow(ucec_real_normalised)
nrow(blca_real_normalised)
nrow(kirc_real_normalised)



##### normalised average

ucec_real_summs <- data.frame(rowSums(sapply(ucec_real_normalised[1:nrow(ucec_real_normalised), 2:ncol(ucec_real_normalised)], as.numeric))/ncol(ucec_real_normalised))
blca_real_summs <- data.frame(rowSums(sapply(blca_real_normalised[1:nrow(blca_real_normalised), 2:ncol(blca_real_normalised)], as.numeric))/ncol(blca_real_normalised))
prad_real_summs <- data.frame(rowSums(sapply(prad_real_normalised[1:nrow(prad_real_normalised), 2:ncol(prad_real_normalised)], as.numeric))/ncol(prad_real_normalised))
kirk_real_summs <- data.frame(rowSums(sapply(kirk_real_normalised[1:nrow(kirk_real_normalised), 2:ncol(kirk_real_normalised)], as.numeric))/ncol(kirk_real_normalised))


rownames(prad_real_summs) = prad[,1]
rownames(ucec_real_summs) = ucec[,1]
rownames(blca_real_summs) = blca[,1]
rownames(kirk_real_summs) = kirc[,1]
colnames(prad_real_summs) = c("prad")
colnames(ucec_real_summs) = c("ucec")
colnames(blca_real_summs) = c("blca")
colnames(kirk_real_summs) = c("kirc")



library(dplyr)


all_real_summs <- cbind(ucec_real_summs, blca_real_summs, prad_real_summs, kirc_real_summs)
kirc_blca_prad_summs <- cbind(blca_real_summs, prad_real_summs)


blca_prad_kirk_summs.new <- blca_prad_kirk_summs %>% filter(row.names(blca_prad_kirk_summs) %in% gene_list_one )
rownames(blca_prad_kirk_summs.new) <- c( "CD44",
                 "CD24",
                 "CDH1",
                 "FOXC2",
                 "VIM",
                 "TWIST2")
levelplot(as.matrix(blca_prad_kirk_summs.new),par.settings=BuRdTheme()) 

require(rasterVis)
install.packages("rasterVis")
# Custom theme (from rasterVis package)
my.theme <- BuRdTheme()

blca_prad_kirk_summs.new <- blca_prad_kirk_summs %>% filter(row.names(blca_prad_kirk_summs) %in% gene_list_kidney )
rownames(blca_prad_kirk_summs.new) <- c(
  "ADAM10",
  "ADAM17",
  "AR",
  "ARF6",
  "AXL",
  "CCL2",
  "CD274",
  "CD34",
  "CD44",
  "CRIM1",
  "CRYAB",
  "CTNNB1",
  "CXCR4",
  "CYP3A4",
  "DCLK1",
  "DDR1",
  "DIO2",
  "DMRT2",
  "EGFR",
  "EPB41L5",
  "FH",
  "FLCN",
  "FOXO3",
  "GATA3",
  "KCNJ15",
  "KDM6B",
  "KLF8",
  "LIF",
  "MAN1C1",
  "MICA",
  "MITF",
  "MMP14",
  "MMP2",
  "MMP9",
  "NANOG",
  "PAX2",
  "PDK1",
  "PIK3R1",
  "PMS2",
  "RCAN1",
  "S100A4",
  "SIP1",
  "SIRT1",
  "SNAI1",
  "SOX2",
  "SOX4",
  "SPOP",
  "STAT1",
  "STAT3",
  "TCF21",
  "TCF4",
  "TFAP2B",
  "TFCP2L1",
  "TPD52",
  "TSC2",
  "VEGFA",
  "VHL",
  "VIM",
  "WT1",
  "ZEB1",
  "ZEB2")
levelplot(as.matrix(blca_prad_kirk_summs.new),aspect="iso", scales=list(x=list(rot=90)), par.settings=BuRdTheme())

gene_prostate <- list("A1"," D1 and E1","ABCA2","ABCB1","ABCG2","ABHD5","ACVR2A","ADAM metalloproteinase domain 9","ADAM10","ADAM17","ADAM9","ADN","AE1","AE3","AGO2","AGR2","AKR1C3","AKT","AKT2","ALDH1","ALDH1A1","ALDH7A1","ALK-5","ALK1","ALK5","ALP","ALPL","AMACR","AMPK","ANGPTL1","ANGPTL7","ANXA1","ANXA2","AP-1","AP1","AP4","AR","ARCaP","ASAP1","ATF-2","ATF2","ATGL","ATM","ATP Binding Cassette G2","ATP-binding cassette B1","ATP-binding cassette transporter 2","AURKB","AXL","Abca2","Ace-1","Adiponectin","Akt","Akt1","Akt2","Akt3","Aldehyde dehydrogenase 1","Alpha-beta Hydrolase Domain Containing 5","Amot","Amotl1","Amotl2","Androgen receptor","Angiomotin","Annexin A1","Annexin A2","AnxA1","Arp2","Atg5","Aurora kinase A","Axin1","Axl","B-cell lymphoma-2-associated X protein","B-cell translocation gene 2","B2M","BAK","BAX","BCL-2","BCL-XL","BCL11A","BCL2","BIRC5","BMI1","BMP","BMP- 7","BMP-2","BMP-7","BMP2","BMP7","BMX","BRCA1","BTG2","Bace2","Bak","Basic fibroblast growth factor","Bax","Bcl-2","Bcl-XL","Bcl-xL","Bcl-xl","Bcl2","Bmi-1","Bone morphogenic protein 7","C-C chemokine ligand 2","C-Raf","C-src","C-terminal binding protein 1","C13orf25","C1GALT1","C1orf116","C4-2","CA IX","CAF","CAFs","CAT","CB1","CBP","CBP/p300-interacting transactivator with E","CC chemokine receptor 7","CCAAT-displacement protein","CCAT2","CCL2","CCL4","CCL5","CCN-4","CCN3","CCNB1","CCND1","CCNE1","CCR2","CCR5","CCR7","CD133","CD146","CD147","CD226","CD24","CD276","CD31","CD34","CD4","CD44","CD45","CD49f","CD8","CD82","CDC42","CDCP1","CDF","CDH1","CDH2","CDK1","CDK1/2","CDK4","CDK4/6","CDK5","CDK5R1","CDK6","CDKN1A","CDKN2A","CDKN2D","CDX2","CENPF","CIP2A","CITED2","CK1","CK14","CK18","CK19","CK5","CK5/6","CK8","CK8/18","CKAP2","CLCA2","CLU","CNN2","COL4A1","COX2","CRAF","CREB","CRIPTO","CRM1","CRMP1","CSF2","CSPC","CT150","CTBP1","CTGF","CTNNB1","CTR","CX3CL1","CXC chemokine receptor 4","CXCL1","CXCL12","CXCL16","CXCL2","CXCL5","CXCR4","CXCR6","CXCR7","CYP1B1","Cad11","Cadherin","Caspase-3","Cat L","Cathepsin L","Cdc42","Cdk4","Cdkn2a","Chk1","Chk2","Chromogranin-A","Ck5","Ck8","Claudin-1","Collapsin response mediator protein-1","Connective tissue growth factor","Cripto-1 (CR-1","Cryptic","Cub-Domain Containing Protein-1","Cul3","Cullin3","Cux1","Cx43","Cyclin A","Cyclin B1","Cyclin D1","Cyclin-D1","CyclinD1","Cytochrome P450 1B1","DAB2IP","DCTPP1","DEC1","DEC2","DHRS7","DIO2","DIO3","DKK-1","DKK3","DLK1","DN-LRP5","DNA methyltransferase 1","DNAJC12","DNMT","DNMT1","DNMT3A","DPYSL3","DSC3","DUSP6","DVL3","Desmocollin 3","Dicer","E- and N-cadherin","E-CADHERIN","E-Cadherin","E-cad","E-cadherin","E-prostanoid-4 receptor","E2 and E4","E26 transformation-specific 1","E2F1","E2F5","E74-like factor 5","EBAG9","ECAD","ECM","ED-B","EDB","EED","EGF","EGFR","EGLN1","EHF","ELF1","ELF5","EMMPRIN","EMT","ENA78","EP300","EP4","EPCAM","EPLIN","EPT1","ERG","ERG3","ERK","ERK1/2","ERK2","ERbeta","ESE3","ESM1","ESR1","ESR2","ESRP1","ESRP2","ET(A)","ET(B)","ET-1","ET-A","ET-B","ETS1","ETS1p","ETV1","ETV4","ETV5","EZH2","Ebag9","Egl nine homolog 1","Egr-1","Elf5","Endo180","Endothelial cell specific molecule-1","Endothelin-1","Eotaxin-1","EpCAM","EphA2","Ephrin-A1","Epidermal growth factor","Epithelial Splicing Regulatory Protein 1","Epithelial cadherin","ErbB","ErbB3","Ereg","Erk","Erk1/2","Erk2","Ets-related gene","Ets2","FAK","FAM101B","FAM3B","FAM3C","FAS","FDPS","FGD4","FGF","FGF10","FGF19","FGF2","FGF6","FGF8","FGF9","FGFR substrate 2","FGFR1","FGFR1/2","FGFR2","FGFR3","FGFR4","FKBP5","FKHRL1","FLI1","FLT3","FOS","FOSL1","FOXA1","FOXC2","FOXE1","FOXM1","FOXN5","FOXO1","FOXO3A","FOXO3a","FOXO6","FOXP1","FOXP2","FOXP3","FOXQ1","FOXR1","FRAT1","FSP1","FZD4","FZD5","FZD8","Fak","Fibroblast Growth Factor Receptor-1","Fibroblast Specific Protein-1","Fibroblast growth factor 2","Fibroblast growth factor receptor 2","Fibronectin","Flot-1","Flot2","Flotillin-1","Flotillin-2","Forkhead Box Protein C2","Forkhead box M1","FoxA1","FoxA2","FoxM1","Foxa1","Foxo3a","Fra1","Frzb","Fzd2","Fzd4","GADD45B","GAS6","GATA3","GCN5","GDF-9","GH","GHRH","GLI family zinc finger 1","GLI-1","GLUT1","GPC5","GPRC6A","GPX1","GPX4","GRHL1","GRHL2","GRP78","GRPr","GSK-3beta","GSK3","GSK3beta","Galectin-4","Gas6","Gli-1","Gli-1"," androgen receptor","Gli1","Gli2","Glo1","Glucose regulated protein 78","Glut-1","Glyoxalase 1","Glypican 5","Grainyhead-like 2","Grb2","Growth hormone-releasing hormone","H-ras","H1.1","H11","HAT1","HB-EGF","HDAC","HDAC1","HDAC6","HDGF","HECTD2","HEF1","HER2","HER2/neu","HGF","HIC1","HIF-1","HIF-1alpha","HIF1","HIF1alpha","HIST1","HIST1H1A","HMGA2","HMGB1","HOTAIR","HOXB7","HPRT1","HSET","HSP90","HSPB1","HULC","Heat-shock protein 90","Hepatocyte Growth Factor","Hepatocyte growth factor","Hepatoma-derived growth factor","Her2","Hes1","High mobility group A2","High mobility group box 1","High-mobility group AT-hook 2","Hoxa9","Hsp27","Hsp90","Hsulf-2","Huh7","Hypoxia inducible factor-1alpha","Hypoxia-inducible factor 1","Hypoxia-inducible factor-1alpha","I-TAC","I309","IDO1","IFIT5","IFNgamma","IGF binding protein-3","IGF-1","IGF-I","IGF-II","IGF-IR","IGF1","IGF1R","IGF2","IGFBP-3","IGFBP-3KO:Myc","IGFBP3","IKKalpha","IL-17","IL-17 receptor C","IL-17-MMP7-EMT","IL-6","IL-6 receptor","IL-6R","IL-8","IL1","IL1R2","IL6R","IL8","ILEI","ILK","INK4a","INPP4B","INSR","IQGAP1","ITGB4","Id-1","Id1","Id2","Igf1","Igfbp3","Igfbp5","IkappaB kinase alpha","Interleukin-17","Interleukin-6","Interleukin-like EMT inducer","JAK2","JAM2","JNK","JUNB","Jagged1","Jagged2","Jak2","K-ras","KAI1","KAT","KAT5","KDM2B","KLF4","KLF8","KLHL20","KLK2","KLK3","KLK4","KRT18","KRT19","Kallikrein 4","Kat2b","Kat5","Kat8","Keratin-18","Keratin-8","Klf10","Klf4","Kras","Kruppel-like factor 8","LAMC2","LAMP3","LARGE2","LASP1","LBH","LCN2","LEDGF/p75","LEF-1","LEF1","LEF1-AS1","LGR4","LIMA-1","LIMK1","LINC01296","LIV-1","LKB1","LMNA","LOX-1","LPA receptor 1","LPAR1","LRP","LRP5","LSD1","Lamin A/C","Lgr4","Lin28B","Lipocalin 2","Lung Resistant Protein","Lymphoid enhancer-binding factor 1","Lymphoid enhancer-binding factor-1","MAGL","MAOA","MAPK","MAPK9","MARCKS","MAZ","MBNL3","MCAK","MCAM","MCM3","MCP-1","MCP-3","MCT1","MCT4","MDM2","MEIS1","MEIS1-1","MEK","MEK1","MEK1/2","MEK2","MEK6","MIC-1","MIEN1","MIR34A","MITF","MKI67","MLL","MMP","MMP 9","MMP)-2","MMP-1","MMP-1"," -3"," -10","MMP-14","MMP-2","MMP-2 and -9","MMP-2/9","MMP-3","MMP-9","MMP1","MMP13","MMP2","MMP3","MMP7","MMP9","MMPs","MMSET","MPP8","MRC2","MSP","MT-MMP1","MT1","MT1-MMP","MTA1","MTA1/Epi-miR-22","MTBP","MUC1","MUC18","MXI1","MYC","MYC associated zinc finger protein","MYOF","Mak","Maspin","Mcl-1","Mdm2","Med19","Mediator Complex Subunit 19","MiR-145","MiR-15a","MiR-182","MiR-22","MiR-331","MiR-34b","MiR-519d","MiR-652","MiR-95","MicroRNA-203","Migration and invasion enhancer 1","Mir-1","Mir34a","Mmp2","Mmp7","Monoacylglycerol lipase","Monoamine oxidase A","Myb","Myc","Myeloid ecotropic viral integration site 1","N Cadherin","N-CAM","N-Cadherin","N-acetylcysteine (NAC)]","N-cad","N-cadherin","N-cadherin 2","N-chimaerin","N-myc downstream-regulated gene 1","NANOG","NCWP and EMT","NCWP-EMT","NDR1","NDRG1","NE","NECTIN2","NEDD9","NES","NET1","NF-kappaB","NFKB1","NFKBIA","NK1","NKX3-1","NKX3.1","NOD","NODAL","NOVA1","NR6A1","NRBP1","NRP1","NSP","NUCB-2","NUSAP1","Nanog","Nedd4-2","Neuropilin 2 and nucleus accumbens-associated protein 1","Nfe2l2","Nicastrin","Nkx3-1","Nkx3.1","Notch","Notch-1","Notch-4","Notch1","Notch2","Nrf2","Nucleobindin-2","OCLN","OCT3/4","OCT4","OPN","ORAI1","OVOL1","OVOL2","Oct-4","Oct3/4","Oct4","Osteopontin","Ovol2","P-gp","P16","P21-activated kinase1","P27","P2X7","P2Y2","P38","P38-MAPK","P53","P62","PAI-1","PAK","PAK4","PAK6","PAQR3","PAR3","PAR6","PARP","PARP-1","PARP1","PC-3","PC3","PC3-AR","PC3-EMT","PC3-Epi/EMT","PCA3","PCAF","PCAT3","PCAT9","PCGEM1","PCNA","PD-L1","PDCD4","PDEF","PDGF-D","PDI","PDK1","PDLIM5","PDZ and LIM domain 5","PEBP4","PHD2","PHLPP","PI3K/AKT","PI3Kalpha","PI3Kdelta","PIK3C3","PIK3CA","PIK3CB","PKC","PKCdelta","PKD","PKD1","PKD2","PKD3","PKM2","PLA2G7","PLCB3","PLK1","PLS3","PML","POU5F1","PP2","PP2A","PPARG","PPARGC1A","PPP2CA","PPP2R3A","PRKAR2B","PRL","PRL-3","PRLR","PRMT5","PROM1","PROX1","PSA","PSCA","PSMA","PSP94","PTEN","PTEN(fl/fl)","PTHrP","PTK6","PTPRN2","PTTG1","PTX-3","PVR","PVT1","Pak1","Par-4","Par6","Parathyroid hormone-related protein","Patched-1","Patched-2","Patched1","Periostin","Phosphatase and tensin homologue","Phosphatidylethanolamine-binding protein 4","Pin1","Plasmacytoma variant translocation 1","PlncRNA-1","Polo-like kinase 1","Poly (ADP-ribose) polymerase","Presenilin1","Prominin-1","Prospero-related homeobox 1","Prostate cancer antigen 3","Prostate transglutaminase","Prostate-specific antigen (PSA)","Protein Kinase D","Protein kinase D1","Pten","RAB1A","RAB27A","RAGE","RANK-RANKL","RANKL","RB1","RBFOX2","RBPJ","RECK","RELA","RHOA","RKIP","ROCK-1","ROCK1 and 2","RON","ROR2","RPS6KB1","RPS7","RSK","RUNX2","Rab11a","Rab1a","Rab1b","Rac1","Rac3","Raf","Raf Kinase Inhibitory Protein","Raf kinase inhibitor protein","Raf kinase inhibitory protein","Raf-1","Raptor","RbBP5","Receptor Activator of NF-kappaB Ligand","RelA","RhoA","RhoB","RhoC","RhoC GTPase","RhoG","Rictor","RunX2","Runx2","S100A14","SAM pointed domain containing ETS transcription factor","SAMC","SATB1","SCA-1","SCF","SCHLAP1","SDC-1","SDF-1","SDK1","SDR34C1","SEMA3C","SENP1","SERPINB1","SET8","SFN","SGK1","SGO1","SH3 domain binding protein 1","SH3BP1","SIK2","SIP1","SIRT1","SIRT3","SIRT7","SKP2","SLCO2B1","SLUG","SMA","SMAD2","SMAD2/3","SMAD3","SMAD4","SMAD7","SNAI1","SNAI2","SNAIL","SNAIL1","SNAIL2","SOCS1","SOCS2","SOD","SOD1","SOD2","SOX1","SOX2","SOX4","SOX5","SOX9","SPDEF","SPINK1","SPINT1","SQSTM1","SRD5A2","SRF","SRPX2","SSBP2","SSH1","SSX","SSX2","STAT-3","STAT1","STAT3","STIM1","SULF2","SUZ12","Semaphorin 3C","Serum Response Factor","Shh","Ship2","Shp2","Sir2","Sirt6","Skp2","Slug","Sma","Smad","Smad 4","Smad1/4","Smad2","Smad2/3","Smad3","Smad3/4","Smad4","Smad7","Snail","Snail-1","Snail-2","Snail1","Snail2","Sonic hedgehog","Sox-2","Sox1","Sox2","Sox5","Sox9","Sp3","Special AT-rich sequence binding protein 1","Special AT-rich sequence-binding protein-1","Src","Stat-3","Stat3","Stat5a","Stem cell factor","Stromal cell-derived factor-1","Sumo1","Superoxide Dismutase","Suppressor Of Cytokine Signaling 1","Survivin","Sushi repeat-containing protein X-linked 2","Syndecan 1","Syndecan-1","Syndecan-3")


for(i in gene_prostate){
  if(i %in% row.names(blca_prad_kirk_summs)){
    print(i)
  }}
blca_prad_kirk_summs.new <- blca_prad_kirk_summs %>% filter(row.names(blca_prad_kirk_summs) %in% gene_list_uterine )
rownames(blca_prad_kirk_summs.new) <- c("PAX8", "TWIST1", "ZEB1", "ZEB2")
levelplot(as.matrix(blca_prad_kirk_summs.new),par.settings=BuRdTheme())

