#!/usr/bin/env python

# Written by Janet Harwood August 17th.
# made generic , to process any gene set file
# To convert gene sets to tab delimited format annotation name: gene list.

import sys
import os
from collections import defaultdict
import time
import re

# read in the gene set file
# make a dictionary: annotation name + list of genes.
# count the number of genes in each set.

# output gene sets with 10-200 genes.

# create file paths

root_dir = root_dir = '/home/sbijch/ANNOTATION_AUTO_ROCKS/processed/MAGMA/'

in_dir_path = root_dir + 'DATA_IN'

out_dir_path = root_dir + 'GENE_SETS_MAGMA'

outfile_type1 = 'MAGMA_ALL.txt'
outfile_type2 = 'MAGMA_10-200.txt'

# out_fname1 = root_dir + 'GO_MAGMA/GO_MAGMA_ALL.txt'
# out_fname2 = root_dir + 'GO_MAGMA/GO_MAGMA_10-200.txt'

########################################

# open output file
# outfile1 = open(out_fname1, 'w')
# outfile2 = open(out_fname2, 'w')

##########################################
# Main process

# generate the output file name from the input file name

for infilename in os.listdir(in_dir_path):
    if infilename.endswith(".txt"):

        print 'processing infile =', infilename
        #log_file.write('processing infile=' + infilename + '\n')

        in_fname = os.path.join(in_dir_path, infilename)

        file_id = re.split('_|\.', infilename)[0]
        print 'file_id =:',file_id

        #  make outfile names from the infile name.

        outfilename1 = "_".join([file_id, outfile_type1])
        outfilename2 = "_".join([file_id, outfile_type2])
        print 'outfile1 =', outfilename1
        print 'outfile2 =', outfilename2

        out_fname1 = os.path.join(out_dir_path, outfilename1)
        out_fname2 = os.path.join(out_dir_path, outfilename2)

        # open outfiles
        outfile1 = open(out_fname1, 'w')
        outfile2 = open(out_fname2, 'w')


##########################################

        for line in open(in_fname,'r'):
            count1 = 0
            count2 = 0
            # make each line into a list
            records = line.strip().split('\t')
            if len(records) < 4:
                sys.exit('some records have missing data')
            else:
                count1 += 1
                gene_output = records[2].replace('|','\t')
                #print gene_output
                outfile1.write(records[0] + '\t' + gene_output + '\n' )

            gene_IDs = records[2].split('|')
            if (10 <= len(gene_IDs) <= 200):
                count2 += 1
                gene_output2 = records[2].replace('|','\t')
                outfile2.write(records[0] + '\t' + gene_output2 + '\n')

    print 'total number of gene sets in', os.path.basename(in_fname),'=', count1
    print 'number of gene sets with 10-200 genes in', os.path.basename(in_fname),'=', count2

print 'end of processing'
