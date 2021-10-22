# -*- encoding:utf-8 -*-
from rouge import Rouge
from tqdm import tqdm 
import argparse
import sys
def process_for_rouge(pred_summary, summary):
    return [' '.join(list(pred_summary)), ' '.join(list(summary))]

def process_text(text):
    return text.replace('_', '').replace(' ','')

if __name__ == '__main__':
    argparser = argparse.ArgumentParser()
    argparser.add_argument('--input', type=str, help='the path of generated-test')
    args = argparser.parse_args()
    fin = open(args.input, 'r').readlines()
    metric = Rouge()
    total_rouge_1, total_rouge_2, total_rouge_l, count = 0, 0, 0, 0
    cur_tgt, cur_pred = None, None
    progress_bar = tqdm(total=len(fin))
    progress_bar.set_description('evaluating ..')
    for line in fin:
        try:
            progress_bar.update(1)
            if len(line.strip().split('\t')) == 2:
                signal, text = line.strip().split('\t') 
            else: signal, prob, text = line.strip().split('\t') 
            if 'T' in signal:
                cur_tgt = process_text(text)
            elif 'D' in signal:
                cur_pred = process_text(''.join(text.split(' ')[1:]))
                result = metric.get_scores(*process_for_rouge(cur_pred, cur_tgt))[0]
                total_rouge_1 += result['rouge-1']['f']
                total_rouge_2 += result['rouge-2']['f']
                total_rouge_l += result['rouge-l']['f']
                count += 1
        except Exception:
            continue
    progress_bar.close()
    print('valid_count:', count)
    print(f'rouge1:{total_rouge_1 / count}, rouge2:{total_rouge_2 / count}, rougeL:{total_rouge_l / count}' ) 



