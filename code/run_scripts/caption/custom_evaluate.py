from tkinter.messagebox import NO
from pycocoevalcap.bleu.bleu import Bleu
from pycocoevalcap.rouge.rouge import Rouge
from pycocoevalcap.cider.cider import Cider
from pycocoevalcap.meteor.meteor import Meteor
from pycocoevalcap.spice.spice import Spice
import pandas as pd
import json

# column_headers = ['uniq-id','image_name', 'caption','description']
# all_data_dataframe = pd.read_csv('/research/OFA/dataset/context_caption_data/test.tsv', sep='\t',header = None, names = column_headers,lineterminator='\n')

column_headers = ['uniq-id',	'image_name', 'caption','description', 'ne_entites']
all_data_dataframe = pd.read_csv('/research/OFA/dataset/context_caption_ne/test.tsv', sep='\t',header = None, names = column_headers,lineterminator='\n')




def score(ref, hypo):
    scorers = [
        (Bleu(4), ["Bleu_1", "Bleu_2", "Bleu_3", "Bleu_4"]),
        (Rouge(), "ROUGE_L"),
        (Cider(), "CIDEr")
    ]
    final_scores = {}
    all_scores = {}
    for scorer, method in scorers:
        score, scores = scorer.compute_score(ref, hypo)

        if type(score) == list:
            for m, s in zip(method, score):
                final_scores[m] = s
            for m, s in zip(method, scores):
                all_scores[m] = s
        else:
            final_scores[method] = score
            all_scores[method] = scores

    return final_scores, all_scores


def compute(ref, cand, get_scores=True):
    # make dictionary
    hypo = {}
    for i, caption in enumerate(cand):
        hypo[i] = [caption]
    truth = {}
    for i, caption in enumerate(ref):
        truth[i] = [caption]

    # compute bleu score
    final_scores = score(truth, hypo)

    #     print out scores
    print('Bleu_1:\t ;', final_scores[0]['Bleu_1'])
    print('Bleu_2:\t ;', final_scores[0]['Bleu_2'])
    print('Bleu_3:\t ;', final_scores[0]['Bleu_3'])
    print('Bleu_4:\t ;', final_scores[0]['Bleu_4'])
    print('ROUGE_L: ;', final_scores[0]['ROUGE_L'])
    print('CIDEr:\t ;', final_scores[0]['CIDEr'])

    if get_scores:
        return final_scores

def get_true_caption(ref_id):
    rslt_df = all_data_dataframe.loc[all_data_dataframe['uniq-id'] == (ref_id)]
    # print(ref_id)
    return rslt_df['caption'].values[0]


def populate_data():
    with open("/research/OFA/results/context_caption_ne/without_context/test_predict.json", "r") as outfile:
        predicted_data = json.load(outfile)

    for data in predicted_data:
        pred_caption = data['caption']
        true_caption = get_true_caption(data['image_id'])
        true_captions.append(true_caption)
        pred_captions.append(pred_caption)
    return None

true_captions = []
pred_captions = []
populate_data()

# print(true_captions[0:5])
# print(pred_captions[0:5])
# ref = ['This is sample sentence', 'This is no']
# cand = ['This is a sample sentence', 'This is yes']
res = compute(true_captions, pred_captions, get_scores=True)