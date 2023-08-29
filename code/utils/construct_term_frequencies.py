#!/usr/bin/env python
# Tsung-Yi Lin <tl483@cornell.edu>
# Ramakrishna Vedantam <vrama91@vt.edu>
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import copy
from collections import defaultdict
import numpy as np
import pdb
import math
import six
from six.moves import cPickle
import os
import pandas as pd
import pickle
import csv

def precook(s, n=4, out=False):
    """
    Takes a string as input and returns an object that can be given to
    either cook_refs or cook_test. This is optional: cook_refs and cook_test
    can take string arguments as well.
    :param s: string : sentence to be converted into ngrams
    :param n: int    : number of ngrams for which representation is calculated
    :return: term frequency vector for occuring ngrams
    """
    # if type(s) != str:
    #     print(s)
    words = str(s).split()
    counts = defaultdict(int)
    for k in range(1,n+1):
        for i in range(len(words)-k+1):
            ngram = tuple(words[i:i+k])
            counts[ngram] += 1
    return counts

def cook_refs(refs, n=4): ## lhuang: oracle will call with "average"
    '''Takes a list of reference sentences for a single segment
    and returns an object that encapsulates everything that BLEU
    needs to know about them.
    :param refs: list of string : reference sentences for some image
    :param n: int : number of ngrams for which (ngram) representation is calculated
    :return: result (list of dict)
    '''
    return [precook(ref, n) for ref in refs]


def compute_doc_freq(cook_refs_dict):
    '''
    Compute term frequency for reference data.
    This will be used to compute idf (inverse document frequency later)
    The term frequency is stored in the object
    :return: None
    '''
    # document_frequency = {}
    document_frequency = defaultdict(float)
    for ngram in list([ngram for ref in cook_refs_dict for (ngram,count) in ref.items()]):
        document_frequency[ngram] += 1
        # maxcounts[ngram] = max(maxcounts.get(ngram,0), count)
    return document_frequency


def compute(sentences):
    # lst = ['This is sentence is sentence', 'This is sentence', 'this and that']
    refs_dict = cook_refs(sentences)
    doc_frequencies = compute_doc_freq(refs_dict)
    return doc_frequencies

def load_data():
    # column_headers = ['uniq-id',	'image_name', 'caption','description']
    # all_data_dataframe = pd.read_csv('/home/development/abisekrk/Research/OFA/dataset/context_caption_data/val.tsv', sep='\t',header = None)
    column_headers = ['uniq-id','image_name', 'caption','description', 'relevant_description']
    all_data_dataframe = pd.read_csv('/research/nytimes_processed_data/cleaned_and_position_filtered/val.tsv',  sep='\t',header = None, names = column_headers, lineterminator='\n',  quoting=csv.QUOTE_NONE)
    caption_df = all_data_dataframe.iloc[:, 2]
    caption_list = caption_df.tolist()
    print(len(caption_list))
    return caption_list

def build_data(ref_len, document_frequency):
    result_hash = {}
    result_hash['ref_len'] = ref_len
    result_hash['document_frequency'] = document_frequency
    return result_hash


caption_list = load_data()
print(caption_list[2])
doc_frequencies = compute(caption_list)
result_data = build_data(len(caption_list), doc_frequencies)
with open('/research/nytimes_processed_data/cleaned_and_position_filtered/cider_cached_tokens/valid-words.p', 'wb') as f:
    pickle.dump(result_data, f)

# with open('/home/development/abisekrk/Research/OFA/dataset/context_caption_data/cider_cached_tokens/train-words.p', 'wb') as f:
#     pickle.dump(result_data, f)