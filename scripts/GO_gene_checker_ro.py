#!/usr/bin/env python

# Written by Janet Harwood June 27th.
# to get a list of GO ids, genes set and paretns from the GO expand file.
# Looks like this works.. might need a final check!
#Updated for GO_FAST final version and checked June 28th 2017.

import sys
import os
from collections import defaultdict
import time
import re # for searching for regular expressions

# create file paths

root_dir = '/home/sbijch/ANNOTATION_AUTO_ROCKS/'

expand_dir_path = root_dir + 'processed/GO_EXPAND'

path_dir_path = root_dir + 'processed/GO_PATHS'

attr_dir_path = root_dir + 'processed/GO_ATTRIBUTES'

out_dir_path = root_dir + 'processed/GO_GENE_CHECK'

# define infile types
infile_type1 = 'attr.txt'
infile_type2 = 'expand.txt'

# define outfile type
outfile_type = 'id_genes_parents.txt'

# define log file
log_fname = root_dir + 'logs/GO_gene_check.log'

# open log file for writing
log_file = open(log_fname,'w')

#########################################

# functions

# print a dictionary out to the screen
def print_dictionary(d):
    for k, v in d.items():
                print k ,"=>", v

#######################################################################################################
#main process

print 'process began at :', time.strftime("%Y-%m-%d %H:%M")

log_file.write('process began at:   ' + time.strftime("%Y-%m-%d %H:%M") + '\n')

# process paths file and make id_parents dictionary

#open the paths.txt files
for pathfilename in os.listdir(path_dir_path):
    if pathfilename.endswith("paths.txt"):

        # make empty id parent dictionary
        id_parents = defaultdict(set)

        # make empty GO_gene dictionary
        GO_gene = defaultdict(set)

        #GO attributes dictionary
        GO_attr =defaultdict(list)

        # make a  master ID list
        master_ID = set()

        GO_ID_attr_set = set()

        # read in the path files
        file_id = re.split('_|\.',pathfilename)[0]
        #print 'file_id =:',file_id

        # derive directory paths
        path_fname =os.path.join(path_dir_path,pathfilename)
        #print 'path infilename =', path_fname

        #get the corresponding attribute file
        attr_infilename = "_".join([file_id, infile_type1])

        # derive the attr file directory path
        attr_fname =os.path.join(attr_dir_path,attr_infilename)
        #print 'attributes file directory path = ', attr_fname

        #get the corresponding expand file
        expand_infilename = "_".join([file_id, infile_type2])


        # derive the expand file directory path
        expand_fname =os.path.join(expand_dir_path,expand_infilename)
        print 'expand file directory path = ', expand_fname

        # derive the outfile name and path.
        outfilename = "_".join([file_id, outfile_type])
        print 'outfilename = ',outfilename
        outfile_fname = os.path.join(out_dir_path,outfilename )
        print 'outfilepath = ',outfile_fname

        #open the output file
        GO_out = open(outfile_fname,'w')

        print 'processing paths file =',pathfilename
        log_file.write('path infile = ' + pathfilename + '\n')
        print 'attributes infilename = ',attr_infilename
        log_file.write('attributes infile = '+ attr_infilename + '\n')
        print 'expand file name = ', expand_infilename
        log_file.write('expand infile = '+ expand_infilename + '\n')

        ##############################################################################

        #read in the attributes file, extract the GO_ID and name and make the GO_attr  dictionary

        # make an empty set to put all the ids in from the attributes file.. what about alternative ids?
        id_set = set()

        for line in open(attr_fname,'r'):
            #skip the header line
            if not line.startswith('#'):
               #make each line into a list
               attr = line.strip().split('\t')
               GO_ID_attr = attr[0]
               GO_ID_name = attr[1]
               # get a list of GO ids
               id_set.add(GO_ID_attr)
               # make a dictionary from GO ID and name
               GO_attr[GO_ID_attr]=GO_ID_name

        #print_dictionary(GO_attr)

        print "GO_attr dictionary constructed from ", os.path.basename(attr_fname), 'at',time.strftime("%Y-%m-%d %H:%M")

        # #check number of unique IDs in the atrribute file
        print 'number of unique IDs in the atrribute file =  ' , len(id_set)
        log_file.write ('number of unique IDs in the atrribute file =  ' + str(len(id_set))+ '\n')

        ##############################################################################

        # process the paths file : make ID parents dictionary
        id_paths = []
        for line in open(path_fname,'r'):
            #make each line into a list
            data = line.strip().split('\t')
            id_paths.append(data)

        # make the ID parents dictionary
        for node in id_set: id_parents[node] = set([node])

        #print_dictionary(id_parents)

        for path in id_paths: id_parents[path[-1]].update(path)

        #print_dictionary(id_parents)

        #################################################################################################################

        print "id_parents dictionary constructed from ", os.path.basename(path_fname), 'at',time.strftime("%Y-%m-%d %H:%M")
        log_file.write('id_parents dictionary constructed from ' + os.path.basename(path_fname) + '\n\n')
        print 'size of id parents dictionary  =  ', len(id_parents)
        log_file.write ('size of id parents dictionary  =  ' + str(len(id_parents)) + '\n')

        #################################################################################################################
        expand_ID = set()
        expand_genes= set()
        expand_GO_gene = {}
        expand_gene_GO = defaultdict(set)

        # read in the GO_expand.txt file
        for line in open(expand_fname,'r'):
            record = line.strip().split('\t')
            #print record
            expand_ID.add(record[0])
            #print record[0]
            gene_set = set(record[2].split('|'))
            #print gene_set

            # extract a set of all the genes in the file
            expand_genes.update(gene_set)

            #make a GO_gene dictionary
            expand_GO_gene[record[0]]=gene_set

        #print_dictionary(expand_GO_gene)
        print 'size of expand_GO_gene dictionary  =  ', len(expand_GO_gene)
        log_file.write ('size of expand_GO_gene dictionary  =  ' + str(len(expand_GO_gene)) + '\n')


        #make an output file of GO_ID,genes and all the parents?

        for GO_ID,gene_set in expand_GO_gene.items():
            parents = id_parents[GO_ID]
            # print GO_ID
            # print gene_set
            # print parents

            # make an output file: GO_expand_id_genes_parents.txt
            #GO id, genes parents.

            gene_str  = '|'.join(gene_set)
            parent_str = '|'.join(parents)
            #print '', GO_ID,  gene_str, parent_str
            #write to output file.
            GO_out.write(GO_ID + '\t' + gene_str + '\t' + parent_str  + '\n')

#check parents of a couple of terms
# print id_parents['GO:0070256']
# print '\n'
# print id_parents['GO:0070257']


print 'end of processing at : ', time.strftime("%Y-%m-%d %H:%M")

log_file.write('end of processing at :   ' + time.strftime("%Y-%m-%d %H:%M") + '\n')

#  END OF PROCESSING.
log_file.close()

########################################################################################################
