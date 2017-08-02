#!/bin/bash
#
# == Set SGE options:
#
    # The following 3 options lines (start with #$), do the following:
    # 1)- ensure BASH is used, regardless of queue configuration;
    # 2)- run the job in the current-working-directory;
    # 3)- submit the job to the "all.q" queue;
    # 4) the name of the job

#$ -S /bin/bash
#$ -cwd
#$ -q all.q
#$ -N HARWOOD_ANNO

# #set an environment variable
# PYPATH=/opt/python/bin/python2.7
#
#
# # == The job itself:
# $PYPATH Pythontest_jhv2.py
#
# echo " "
# echo "Job finished at: "
# /bin/date
# echo "Finish - `date`"

echo "Process began at $(date)"

# activate the py2-numpy-pandas environment.

source activate py2-numpy-pandas

# #################################################################
#
# cd /home/sbijch/ANNOTATION_AUTO_ROCKS/scripts
#
# echo running annotation_downloads.py
# python annotation_downloads.py
#
# #################################################################
#
# # check that all of the downloaded files exist before proceeding.
#
# cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/downloads
#
# files=(MGI_EntrezGene.rpt  gene_info.gz MGI_PhenoGenoMP.rpt gene2go.gz homologene.data MPheno_OBO.ontology go-basic.obo)
#
# for file in ${files[*]}
# do
#   if [ -s $file ]
#   then
#     echo "$0: File '${file}' has downloaded."
#   else
#     echo "$0: File '${file}' does not exist or is empty."
#     exit 1
#   fi
# done
#
# ################################################################################
# ################################################################################
#
# # process mouse annotations
# # mouse ID mapping
# # cd to the directory containing all the scripts to process the data.
# cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/scripts
#
# #ID mapping:
# echo running MGI_Marker_ID_to_entrez_ID_auto.py
# python MGI_Marker_ID_to_entrez_ID_auto.py
#
# cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/processed/MOUSE_ID_MAPPING
#
# # check that the output files exist
# ID_mapping_files=(MGI_markerID_to_entrezID_ALL.txt	MGI_markerID_to_entrezID_pc.txt)
#
#
# for file in ${ID_mapping_files[*]}
# do
#   if [ -s $file ]
#   then
#     echo "$0: File '${file}' exists and is not empty."
#   else
#     echo "$0: File '${file}' does not exist or is empty."
#     exit 1
#   fi
# done
#
# ################################################################################
# # cd to the directory containing all the scripts to process the data.
# cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/scripts
#
# construct the evidence files:
# echo running Mouse_pheno_JH_rewrite3.py
# python Mouse_pheno_JH_rewrite3.py
#
# # !!!! not sure how well script above is working!!!
#
# # check that the evidence files exist
# cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/processed/MOUSE_EVIDENCE
#
# evidence_files=(MGI_PhenoGeno_single_gene_ALL.txt	MGI_PhenoGeno_single_protein_coding_gene.txt)
#
#
# for file in ${evidence_files[*]}
# do
#   if [ -s $file ]
#   then
#     echo "$0: File '${file}' exists and is not empty."
#   else
#     echo "$0: File '${file}' does not exist or is empty."
#     exit 1
#   fi
# done
#
# #################################################################################
# # Extracting mouse phenotype ontology to tree
#
# cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/scripts
# echo running obo_to_tree_mouse.py
# python obo_to_tree_mouse.py
#
# # check that the tree files exist
# cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/processed/MOUSE_TREES
#
# mouse_trees_files=(MP_tree.txt MP_attr.txt)
#
# for file in ${mouse_trees_files[*]}
# do
#   if [ -s $file ]
#   then
#     echo "$0: File '${file}' exists and is not empty."
#   else
#     echo "$0: File '${file}' does not exist or is empty."
#     exit 1
#   fi
# done
#
# ################################################################################
# # Process mouse trees files to create paths and update the attributes files.
# cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/scripts
# echo running obo_tree_to_paths_JH2.py
# python obo_tree_to_paths_JH2.py
#
# # check that the path and updated attributes files exist
# cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/processed/MOUSE_TREES
#
# mouse_paths_files=(MP_paths.txt MP_attr_level.txt)
#
# for file in ${mouse_paths_files[*]}
# do
#   if [ -s $file ]
#   then
#     echo "$0: File '${file}' exists and is not empty."
#   else
#     echo "$0: File '${file}' does not exist or is empty."
#     exit 1
#   fi
# done
#
# ################################################################################
# # expand the mouse annotations.
# cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/scripts
# echo running expand_pheno_mouse_auto.py
# python expand_pheno_mouse_auto.py
#
# # check that the final output files 'expand.txt' exist
# cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/processed/MOUSE_EXPAND
#
# mouse_expand_files=(MGI_single_gene_Pheno_protein_coding_annotation.txt)
#
# for file in ${mouse_expand_files[*]}
# do
#   if [ -s $mouse_expand_files ]
#   then
#     echo "$0: File '${mouse_expand_files}' exists and is not empty."
#   else
#     echo "$0: File '${mouse_expand_files}' does not exist or is empty."
#     exit 1
#   fi
# done
#
# ###############################################################################
# echo "MOUSE_PHENO Processing complete at $(date)"

##########################################################################
##########################################################################
# Process the homolgene data

echo "Processing homologene data at $(date)"
cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/downloads

# extract mouse and human data as two separate files:

awk '$2 == "9606" {print $0 > "/Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/processed/HOMOLOGENE/human_homologene_jh.txt" }' homologene.data

awk '$2 == "10090" {print $0 > "/Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/processed/HOMOLOGENE/mouse_homologene_jh.txt" }' homologene.data

# check that the homologene_cut files exist
cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/processed/HOMOLOGENE

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

cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/scripts
#
echo running homologene_gene_set_extractor.py
python homologene_gene_set_extractor.py

# check that the human and mouse NCBI gene files exist

cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/processed/HOMOLOGENE

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

cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/scripts

echo running homologene_merge_auto.py
python homologene_merge_auto.py

# check that the homologene_merge files exist
cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/processed/HOMOLOGENE

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

cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/scripts

echo running  Mouse_pheno_to_human_PC_gene_auto.py
python Mouse_pheno_to_human_PC_gene_auto.py

# check that the mouse_to_human files exist

cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/processed/MOUSE_TO_HUMAN_GENES

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
cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/scripts

# construct the evidence files:
echo running human_gene2go_extract_v14_auto.py
python human_gene2go_extract_v14_auto.py

# check that the evidence files exist
cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/processed/GO_EVIDENCE

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
cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/scripts
echo running GO_obo_to_tree_v26_auto.py
python GO_obo_to_tree_v26_auto.py

# check that the trees files exist
cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/processed/GO_TREES

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
cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/processed/GO_ATTRIBUTES

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
cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/scripts
echo running  GO_trees_to_paths_JH_auto.py
python GO_trees_to_paths_JH_auto.py

#check that the paths files exist
cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/processed/GO_PATHS

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

cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/processed/GO_ATTRIBUTES_UPDATED

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
cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/scripts
echo running expand_GO_v12_auto.py
python expand_GO_v12_auto.py

# check that the final output files 'expand.txt' exist
cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/processed/GO_EXPAND

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
cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/scripts
echo running GO_gene_checker_v2_auto.py
python GO_gene_checker_v2_auto.py

# check that the final output files 'expand.txt' exist
cd /Users/Janetlaptop/Documents/HUMAN_BRAIN_PROJECT/ANNOTATION_AUTO/processed/GO_GENE_CHECK

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
echo " Processing complete at $(date)"
