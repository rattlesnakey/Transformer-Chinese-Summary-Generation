# -*- encoding:utf-8 -*-
import sys
import logging
import argparse
import json
from tqdm import tqdm
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s | %(message)s'
)

class Process(object):
    def __init__(self, args):
        super().__init__()
        self.args = args 
    
    def __call__(self, ):
        # 同时打开两个文件，open之间用逗号隔开
        assert self.args.task != None
        if self.args.task == 'sentencepiece':
            with open(self.args.input, 'r', encoding='utf8') as f, open(self.args.output, 'w+') as o:
                logging.info(f'processing {self.args.input} ..')
                for line in tqdm(f):
                    line = json.loads(line.strip())
                    document, summary = line['document'], line['summary']
                    o.write(document + '\n'); o.write(summary + '\n')
        elif self.args.task == 'fairseq':
            with open(self.args.input, 'r', encoding='utf8') as f, open(self.args.output + '.src', 'w+') as src, \
                open(self.args.output + '.tgt', 'w+') as tgt:
                logging.info(f'processing {self.args.input} ..')
                for line in tqdm(f):
                    line = json.loads(line.strip())
                    document, summary = line['document'], line['summary']
                    src.write(document + '\n'); tgt.write(summary + '\n')





def set_args():
    argparser = argparse.ArgumentParser()
    argparser.add_argument('--input', type=str, help='the input file path')
    argparser.add_argument('--output', type=str, help='the output file path')
    argparser.add_argument('--task',type=str, help='for fairseq or for sentencepiece')
    return argparser.parse_args()

if __name__ == '__main__':
    args = set_args()
    p = Process(args)
    sys.exit(p())
    

