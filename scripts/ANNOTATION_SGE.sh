
#!/bin/bash
#$ -V
#$ -q all.q
#$ -l h_vmem=40G
#$ -cwd
#$ -o annotation_log
#$ -e annotation_err
#$ -S /bin/bash

export PATH=/share/apps/anaconda2/bin:$PATH

source activate py2-numpy-pandas


# #################################################################
#
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/scripts


python ./annotation_downloads_ro.py
#################################################################

# check that all of the downloaded files exist before proceeding.

cd /home/sbijch/ANNOTATION_AUTO_ROCKS/downloads

files=(MGI_EntrezGene.rpt  gene_info.gz MGI_PhenoGenoMP.rpt gene2go.gz homologene.data MPheno_OBO.ontology go-basic.obo)

for file in ${files[*]}
do
  if [ -s $file ]
  then
    echo "$0: File '${file}' has downloaded."
  else
    echo "$0: File '${file}' does not exist or is empty."
    exit 1
  fi
done

# ################################################################################
# ################################################################################

# process mouse annotations
# cd to the directory containing all the scripts to process the data.
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/scripts

# mouse ID mapping

python ./MGI_Marker_ID_to_entrez_ro.py

cd /home/sbijch/ANNOTATION_AUTO_ROCKS/processed/MOUSE_ID_MAPPING

# check that the output files exist
ID_mapping_files=(MGI_markerID_to_entrezID_ALL.txt	MGI_markerID_to_entrezID_pc.txt)


for file in ${ID_mapping_files[*]}
do
  if [ -s $file ]
  then
    echo "$0: File '${file}' exists and is not empty."
  else
    echo "$0: File '${file}' does not exist or is empty."
    exit 1
  fi
done

################################################################################
# cd to the directory containing all the scripts to process the data.
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/scripts

#construct the evidence files:

python ./Mouse_pheno_JH_ro.py


# check that the evidence files exist
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/processed/MOUSE_EVIDENCE

evidence_files=(MGI_PhenoGeno_single_gene_ALL.txt	MGI_PhenoGeno_single_protein_coding_gene.txt)


for file in ${evidence_files[*]}
do
  if [ -s $file ]
  then
    echo "$0: File '${file}' exists and is not empty."
  else
    echo "$0: File '${file}' does not exist or is empty."
    exit 1
  fi
done

#################################################################################
# Extracting mouse phenotype ontology to tree

cd /home/sbijch/ANNOTATION_AUTO_ROCKS/scripts

python ./obo_to_tree_mouse_ro.py

# check that the tree files exist
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/processed/MOUSE_TREES

mouse_trees_files=(MP_tree.txt MP_attr.txt)

for file in ${mouse_trees_files[*]}
do
  if [ -s $file ]
  then
    echo "$0: File '${file}' exists and is not empty."
  else
    echo "$0: File '${file}' does not exist or is empty."
    exit 1
  fi
done

################################################################################
# Process mouse trees files to create paths and update the attributes files.
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/scripts

python ./obo_tree_to_paths_JH2_ro.py

# check that the path and updated attributes files exist
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/processed/MOUSE_TREES

mouse_paths_files=(MP_paths.txt MP_attr_level.txt)

for file in ${mouse_paths_files[*]}
do
  if [ -s $file ]
  then
    echo "$0: File '${file}' exists and is not empty."
  else
    echo "$0: File '${file}' does not exist or is empty."
    exit 1
  fi
done

################################################################################
# expand the mouse annotations.
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/scripts

python ./expand_pheno_mouse_ro.py

# check that the final output files 'expand.txt' exist
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/processed/MOUSE_EXPAND

mouse_expand_files=(MGI_single_gene_Pheno_protein_coding_annotation.txt)

for file in ${mouse_expand_files[*]}
do
  if [ -s $mouse_expand_files ]
  then
    echo "$0: File '${mouse_expand_files}' exists and is not empty."
  else
    echo "$0: File '${mouse_expand_files}' does not exist or is empty."
    exit 1
  fi
done

###############################################################################
echo "MOUSE_PHENO Processing complete at $(date)"

##########################################################################
##########################################################################
# Process the homolgene data


cd /home/sbijch/ANNOTATION_AUTO_ROCKS/downloads

# extract mouse and human data as two separate files:

awk '$2 == "9606" {print $0 > "/home/sbijch/ANNOTATION_AUTO_ROCKS/processed/HOMOLOGENE/human_homologene_jh.txt" }' homologene.data

awk '$2 == "10090" {print $0 > "/home/sbijch/ANNOTATION_AUTO_ROCKS/processed/HOMOLOGENE/mouse_homologene_jh.txt" }' homologene.data

# check that the homologene_cut files exist
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/processed/HOMOLOGENE

cut_files=(human_homologene_jh.txt mouse_homologene_jh.txt )

for file in ${cut_files[*]}
do
  if [ -r $file ]
  then
    echo "$0: File '${file}' exists."
  else
    echo "$0: File '${file}' does not exist."
    exit 1
  fi
done

#######################

# extract human and mouse gene information from the NCBI gene file and make homologene gene sets

cd /home/sbijch/ANNOTATION_AUTO_ROCKS/scripts
#

python ./homologene_gene_set_extractor_ro.py

# check that the human and mouse NCBI gene files exist

cd /home/sbijch/ANNOTATION_AUTO_ROCKS/processed/HOMOLOGENE

homologene_gene_sets=(homologene_human_protein_coding.txt homologene_mouse_protein_coding.txt homologene_human_all_minus_pseudo.txt homologene_mouse_all_minus_pseudo.txt)

for file in ${homologene_gene_sets[*]}
do
  if [ -s $file ]
  then
    echo "$0: File '${file}' exists and is not empty."
  else
    echo "$0: File '${file}' does not exist or is empty."
    exit 1
  fi
done

############################################################################
# extract the one-to-one, one-to many etc relationships between the human and mouse homologene gene sets.

cd /home/sbijch/ANNOTATION_AUTO_ROCKS/scripts

python ./homologene_merge_auto_ro.py

# check that the homologene_merge files exist
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/processed/HOMOLOGENE

homologene_merge_files=(hm_many_to_many_homol_ALL.txt	hm_one_to_many_homol_ALL.txt hm_many_to_many_homol_PC.txt	hm_one_to_many_homol_PC.txt hm_many_to_one_homol_ALL.txt \
hm_one_to_one_homol_ALL.txt hm_many_to_one_homol_PC.txt	hm_one_to_one_homol_PC.txt)

for file in ${homologene_merge_files[*]}
do
  if [ -s $file ]
  then
    echo "$0: File '${file}' exists and is not empty."
  else
    echo "$0: File '${file}' does not exist or is empty."
    exit 1
  fi
done

#############################################################################

# Extract human homologues of mouse genes from phenotypes with single gene manipulations.

cd /home/sbijch/ANNOTATION_AUTO_ROCKS/scripts


python ./Mouse_pheno_to_human_PC_gene_ro.py

# check that the mouse_to_human files exist

cd /home/sbijch/ANNOTATION_AUTO_ROCKS/processed/MOUSE_TO_HUMAN_GENES

mouse_pheno_to_human_gene_files=(MGI_single_gene_Pheno_to_human_protein_coding_gene.txt)

for file in ${mouse_pheno_to_human_gene_files[*]}
do
  if [ -s $file ]
  then
    echo "$0: File '${file}' exists and is not empty."
  else
    echo "$0: File '${file}' does not exist or is empty or is empty."
    exit 1
  fi
done

echo "homologene processing complete at $(date)"
################################################################################
################################################################################
# Process GO ontology.
# cd to the directory containing all the scripts to process the data.
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/scripts

# construct the evidence files:

python ./human_gene2go_extract_ro.py

# check that the evidence files exist
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/processed/GO_EVIDENCE

evidence_files=(Gene_to_GO_ALL_ev_ALL_genes_evidence.txt Gene_to_GO_ALL_ev_PC_genes_evidence.txt Gene_to_GO_STRICT_ev_ALL_genes_evidence.txt Gene_to_GO_STRICT_ev_PC_genes_evidence.txt )

for file in ${evidence_files[*]}
do
  if [ -s $file ]
  then
    echo "$0: File '${file}' exists and is not empty."
  else
    echo "$0: File '${file}' does not exist or is empty or is empty."
    exit 1
  fi
done

###############################################################################
# Process the GO obo file to generate three ontology trees and their attribute files
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/scripts

python ./GO_obo_to_tree_ro.py

# check that the trees files exist
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/processed/GO_TREES

trees_files=(BP_tree.txt CC_tree.txt MF_tree.txt)

for file in ${trees_files[*]}
do
  if [ -s $file ]
  then
    echo "$0: File '${file}' exists and is not empty."
  else
    echo "$0: File '${file}' does not exist or is empty or is empty."
    exit 1
  fi
done

#check that the attributes files exist
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/processed/GO_ATTRIBUTES

attr_files=(BP_attr.txt	CC_attr.txt	MF_attr.txt)

for file in ${attr_files[*]}
do
  if [ -s $file ]
  then
    echo "$0: File '${file}' exists and is not empty."
  else
    echo "$0: File '${file}' does not exist or is empty or is empty."
    exit 1
  fi
done

###############################################################################
# Process GO trees files to create paths and update the attributes files.
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/scripts

python ./GO_trees_to_paths_ro.py

#check that the paths files exist
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/processed/GO_PATHS

paths_files=(BP_paths.txt CC_paths.txt MF_paths.txt)

for file in ${paths_files[*]}
do
  if [ -s $file ]
  then
    echo "$0: File '${file}' exists and is not empty."
  else
    echo "$0: File '${file}' does not exist or is empty or is empty."
    exit 1
  fi
done


# check that the updated attributes files exist

cd /home/sbijch/ANNOTATION_AUTO_ROCKS/processed/GO_ATTRIBUTES_UPDATED

attr_level_files=(BP_attr_level.txt CC_attr_level.txt MF_attr_level.txt)

for file in ${attr_level_files[*]}
do
  if [ -s $file ]
  then
    echo "$0: File '${file}' exists and is not empty."
  else
    echo "$0: File '${file}' does not exist or is empty or is empty."
    exit 1
  fi
done

###############################################################################
# expand the GO term to gene annotations.
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/scripts

python ./expand_GO_ro.py

# check that the final output files 'expand.txt' exist
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/processed/GO_EXPAND

GO_expand_files=(BP_expand.txt CC_expand.txt MF_expand.txt)

for file in ${GO_expand_files[*]}
do
  if [ -s $file ]
  then
    echo "$0: File '${file}' exists and is not empty."
  else
    echo "$0: File '${file}' does not exist or is empty or is empty."
    exit 1
  fi
done

################################################################################
# Make id:gene_set: parents file for each ontology
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/scripts

python ./GO_gene_checker_ro.py

# check that the final output files 'expand.txt' exist
cd /home/sbijch/ANNOTATION_AUTO_ROCKS/processed/GO_GENE_CHECK

GO_id_genes_parents_files=(BP_id_genes_parents.txt CC_id_genes_parents.txt MF_id_genes_parents.txt)

for file in ${GO_id_genes_parents_files[*]}
do
  if [ -s $file ]
  then
    echo "$0: File '${file}' exists and is not empty."
  else
    echo "$0: File '${file}' does not exist or is empty."
    exit 1
  fi
done

# ################################################################################
echo "Processing complete at $(date)"
