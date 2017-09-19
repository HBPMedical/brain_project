#!/usr/bin/env python# Written by Janet Harwood May 2017. This script works# This version derived from obo_to_tree_v21.py# Edited July 19th 2017.
# Checked online using pep8

import sysimport osimport refrom collections import defaultdictimport timeimport itertoolsfrom xml.etree.ElementTree import ElementTree, Element, tostringfrom xml.dom.minidom import parseString# get the curent working directorycwd = os.getcwd()# get the root directoryroot_dir = os.path.split(cwd)[0]# input fileinfile = root_dir + '/downloads/go-basic.obo'# output fileslog_fname = root_dir + '/logs/GO_obo_to_tree.log'tree_fname1 = root_dir + '/processed/GO_TREES/BP_tree.txt'tree_fname2 = root_dir + '/processed/GO_TREES/MF_tree.txt'tree_fname3 = root_dir+ '/processed/GO_TREES/CC_tree.txt'attr_fname1 = root_dir + '/processed/GO_ATTRIBUTES/BP_attr.txt'attr_fname2 = root_dir + '/processed/GO_ATTRIBUTES/MF_attr.txt'attr_fname3 = root_dir + '/processed/GO_ATTRIBUTES/CC_attr.txt'# set countersobs_count = 0record_count = 0no_parent_count = 0# make listsmain_ID = []records = []tag_list1 = ['id', 'namespace', 'is_a', 'alt_id']tag_list2 = ['name:']tag_list3 = ['def']tag_list4 = ['relationship']attr_fields = ['id', 'name:', 'def', 'alt_id']# make a list of parent => child relationship terms# a 'is_a' or 'part_of' b : a = child, b=parent# has_part: NOTE has_part is NOT safe to use for grouping annotations.p_tags = ['is_a', 'part_of']# define delimitersdelimiter1 = '\s+'# gets rid of leading whitespacedelimiter2 = ':\s'delimiter3 = ':'# make setsnamespace_set = set()relationship_type = set()# define ontologiesbp_ontology = 'biological_process'mf_ontology = 'molecular_function'cc_ontology = 'cellular_component'# make dictionariesattr_dict = {}# make empty parent_child dictionaries for each ontology.bp_parent_dict = defaultdict(set)mf_parent_dict = defaultdict(set)cc_parent_dict = defaultdict(set)# make element dictionaries for each ontologybp_elem_dict = {}mf_elem_dict = {}cc_elem_dict = {}# define element typeelem_type = 'Term'############################################################################# functionsdef term_parser(tag_list, delimiter):    for tag in tag_list:        term_set = set()        for j in range(0, len(record)):            # print record[j]            if re.match(tag, record[j]) is not None:                # print record[j]                term = re.split(delimiter, record[j])[1]                # print term                term_set.add(term)        master_dict[tag] = term_set##############################################################################def relationship_parser(tag_list):    for tag in tag_list:        rel_term_list = []        rel_ID_list = []        for j in range(0, len(record)):            # print record[j]            if re.match(tag, record[j]) is not None:                rel_term = re.split('\s+', record[j])[1]                rel_term_list.append(rel_term)                rel_ID = re.split('\s+', record[j])[2]                rel_ID_list.append(rel_ID)        if len(rel_term_list) > 0:            id_term_list = zip(rel_term_list, rel_ID_list)            # print id_term_list            for k, v in id_term_list:                relationship_dict.setdefault(k, set()).add(v)                # add the relationship dictionary to the master dictionary                master_dict.update(relationship_dict)############################################################################def definiton_parser(tag_list):    for tag in tag_list:        for j in range(0, len(record)):            if re.match(tag, record[j]) is not None:                # take one & strip off surrounding brackets, whitespace & definition source (enclosed in [] at end of line)                def_string = record[j].split('\"')[1]                if len(def_string) == 0:                    print 'missing definition string!'    master_dict[tag] = def_string############################################################################## check which ontologies have relationship terms in themdef check_relationships(dict, child_tags):    for k, v in dict.items():        for tag in c_tags:            a = dict.get(tag)            if a is not None:                b = dict.get('namespace')                namespace_set.update(b)############################################################################# check a dictionary entry by its id.def record_checker(dict, test_id):    dict_id = ''.join(dict.get('id'))    if dict_id == test_id:        print dict############################################################################# print a dictionary out to the screendef print_dictionary(d):    for k, v in d.items():        print k, "=>", v############################################################################def dictionary_checker(rel_dict):    global log_file    if len(rel_dict) == 0:        print 'no items in dictionary'    else:        log_file.write('number of items in dictionary = : ' + str(len(rel_dict)) + '\n')        print 'number of items in dictionary = : ', str(len(rel_dict))############################################################################# make an attribute file for each ontology containing the following fields# id	name	def	 alt_iddef print_atrributes(main_dict, ontology, attr_fname):    attr_out = open(attr_fname, 'w')    str_header = str('#' + ('\t'.join(attr_fields))+'\n')    # print str_header    attr_out.write(str_header)    for k, v in main_dict.items():        next_line = []        for tag in attr_fields:            ont = ''.join(v.get('namespace'))            if ontology == ont:                if len(v.get(tag)) > 0:                    x = ''.join(v.get(tag))                    next_line.append(x)                else:                    x = 'None'                    next_line.append(x)        if next_line:            # print next_line            str_output = str(('\t'.join(next_line))+'\n')            attr_out.write(str_output)    attr_out.close()############################################################################def get_root(main_dict, ontology):    for k, v in main_dict.items():        ont = ''.join(v.get('namespace'))        p = ''.join(v.get('is_a'))        if len(p) == 0 and ontology == ont:            root = ''.join(v.get('id'))            return root############################################################################# extract the parent or child relationships for each ontology, check that all parent ids are in the same ontology,# then make a dictionary of the terms.def make_relationship_dict(ontology, ontology_relationship_dict, parent_tags):    for k, v in attr_dict.items():        if ontology in v.get('namespace'):            parents = set()            for tag in parent_tags:                a = v.get(tag)                if a is not None:                    parents.update(a)            checked_parents = set()            for parent in parents:                ont = ''.join(attr_dict[parent].get('namespace'))                if ont == ontology:                    checked_parents.add(parent)                else:                    print 'term not in this ontology  ', parent                    pass            # make dictionary            ontology_relationship_dict[k] = checked_parents############################################################################
def make_element_dict(elem_type, attr_dict, ontology, elem_dict):
    for k, v in attr_dict.items():
        if ontology in v.get('namespace'):
            # construct element
            el = Element(elem_type)
            # print v.get('namespace')
            el_id = ''.join(v.get('id'))
            # print el_id
            # set this as id in Element object and attribute dictionary for term
            el.set('id', el_id)
            # print out  the element type and its attibutes
            # print '', el.tag,el.attrib
            # store Element object for term in elem_dict
            # bp_elem_dict[el_id] = el
            elem_dict[el_id] = el

########################################################################### print the elem_dict to check it.def elem_dict_checker(elem_dict):    for el_id, el in elem_dict.items():        print '', el_id, el.tag, el.attrib# print an element to check it by a particular iddef elem_id_checker(elem_dict, G0_id):    for el_id, el in elem_dict.items():        print el.get(G0_id)############################################################################ print out the elements of an Element dictionary (it is in xml!)def prettify(elem_dict):    for el_id, el in elem_dict.items():        # print el.keys()        # print el.items()        x = tostring(el)        print x        reparsed = parseString(x)        print '\n'.join([line for line in reparsed.toprettyxml(indent=' '*2).split('\n') if line.strip()])        print '\n'############################################################################ set parent-child links in elements for each ontologydef parent_child_links(elem_dict, parent_dict):    for next_id, next_child in elem_dict.items():        # print 'element_id =',next_id        for parent_id in parent_dict[next_id]:            # print parent_id            elem_dict[parent_id].append(next_child)###########################################################################def save_tree(elem_dict, root, tree_fname):    tree = ElementTree(elem_dict[root])    tree.write(tree_fname)###########################################################################def print_element_by_id(elem_dict, G0_id):    for el_id, el in elem_dict.items():        if el_id == G0_id:            x = tostring(el)            reparsed = parseString(x)            print '\n'.join([line for line in reparsed.toprettyxml(indent=' '*2).split('\n') if line.strip()])############################################################################ Main process############################################################################### open log for writinglog_file = open(log_fname, 'w')print 'process began at :', time.strftime("%Y-%m-%d %H:%M")log_file.write('process began at:   ' + time.strftime("%Y-%m-%d %H:%M") + '\n')with open(infile) as obo:    for result in re.findall('\[Term](.*?)\[Typedef]', obo.read(), re.S):        # convert all the data to a list        records = result.strip().split('\n')        # split the list        Term_LoL = [list(y) for x, y in itertools.groupby(records, lambda z: z == '[Term]') if not x]        # print Term_LoL[0]        for i in range(0, len(Term_LoL)):            record = Term_LoL[i]            # remove obsolete records            if any('is_obsolete' in s for s in record):                obs_count += 1                pass            else:                record_count += 1                # print '\n'                # print record                master_dict = {}                relationship_dict = {}                # process terms with whitespace delimiter                term_parser(tag_list1, delimiter1)                # print(master_dict)                # process 'name' term with ':'delimiter                term_parser(tag_list2, delimiter2)                # print(master_dict)                # process the 'definition'string                definiton_parser(tag_list3)                # print(master_dict)                # process the relationships                relationship_parser(tag_list4)                # check the master_dict for no parent ids, to get root terms.                # no_parents(master_dict)                # check_relationships(master_dict, c_tags)                term_id = ''.join(master_dict.get('id'))                # print term_id                # make the attribute dictionary                attr_dict[term_id] = master_dict############################################################################ check all the term ids only occur once and that they are unique.print '\n'print 'number of records in GO ontology =  ', len(Term_LoL)log_file.write('number of records in GO ontology =  ' + str(len(Term_LoL)) + '\n')print '\n'print 'number of non-obsolete records in GO ontology =  ', record_countlog_file.write('number of non-obsolete records in GO ontology =  ' + str(record_count) + '\n')print '\n'print 'number of obsolete records in GO ontology =  ', obs_countlog_file.write('number of obsolete records in GO ontology =  ' + str(obs_count) + '\n')print '\n'########################################################################## print the attribute dictionary# print_dictionary(attr_dict)print 'making bp_parent_dict and checking parent terms'make_relationship_dict(bp_ontology, bp_parent_dict, p_tags)# print_dictionary(bp_parent_dict)print '\n'print 'making mp_parent_dict and checking parent terms'make_relationship_dict(mf_ontology, mf_parent_dict, p_tags)# print_dictionary(mp_parent_dict)print '\n'print 'making cc_parent_dict and checking parent terms'make_relationship_dict(cc_ontology, cc_parent_dict, p_tags)# print_dictionary(cc_parent_dict)############################################################################## check  the parent dictionariesprint '\n'print 'checking bp_parent_dict'log_file.write('checking bp_parent_dict' + '\n')dictionary_checker(bp_parent_dict)print '\n'print 'checking mf_parent_dict'log_file.write('checking mf_parent_dict '+' \n')dictionary_checker(mf_parent_dict)print '\n'print 'checking cc_parent_dict'log_file.write('checking cc_parent_dict '+' \n')dictionary_checker(cc_parent_dict)print '\n'# for each ontology: construct Element object for term and make an element dictionary (and add parent terms?)make_element_dict(elem_type, attr_dict, bp_ontology, bp_elem_dict)make_element_dict(elem_type, attr_dict, mf_ontology, mf_elem_dict)make_element_dict(elem_type, attr_dict, cc_ontology, cc_elem_dict)# print element dict to check it# elem_dict_checker(bp_elem_dict)# elem_dict_checker(mf_elem_dict)# elem_dict_checker(cc_elem_dict)########################################################################### set parent-child links in elements for each parent dictionaryprint '\n'print 'setting parent-child links in elements for bp_parent_dict'parent_child_links(bp_elem_dict, bp_parent_dict)print 'setting parent-child links in elements for mf_parent_dict'parent_child_links(mf_elem_dict, mf_parent_dict)print 'setting parent-child links in elements for cc_parent_dict'parent_child_links(cc_elem_dict, cc_parent_dict)############################################################################ Make the trees for each ontology.# get the root terms for each ontologyprint '\n'bp_root = get_root(attr_dict, bp_ontology)print 'root term for biological process ontology = ', bp_rootlog_file.write('root term for biological process ontology =  ' + bp_root + '\n')mf_root = get_root(attr_dict, mf_ontology)print 'root term for molecular function ontology = ', mf_rootlog_file.write('root term for molecular function ontology = ' + mf_root + '\n')cc_root = get_root(attr_dict, cc_ontology)print 'root term for cellular component ontology = ', cc_rootlog_file.write('root term for cellular component ontology = ' + cc_root + '\n')save_tree(bp_elem_dict, bp_root, tree_fname1)print '\n'print 'biological_process tree saved to file'log_file.write('biological_process tree saved to file ' + '\n')save_tree(mf_elem_dict, mf_root, tree_fname2)print 'molecular_function tree saved to file'log_file.write('molecular_function tree saved to file ' + '\n')save_tree(cc_elem_dict, cc_root, tree_fname3)print 'cellular_component tree saved to file'log_file.write('cellular_component tree saved to file ' + '\n')# ############################################################################ print the attributes to file for each ontology.print_atrributes(attr_dict, bp_ontology, attr_fname1)print_atrributes(attr_dict, mf_ontology, attr_fname2)print_atrributes(attr_dict, cc_ontology, attr_fname3)print '\n'print 'atrributes file saved for each ontology'log_file.write('atrributes file saved for each ontology' + '\n')print '\n'print 'end of processing at :', time.strftime("%Y-%m-%d %H:%M")
print '\n'log_file.write('end of processing at:   ' + time.strftime("%Y-%m-%d %H:%M") + '\n')