import requests
import json

from bs4 import BeautifulSoup as bs
from nltk.tokenize import sent_tokenize


def get_id_list():
    with open('abstracts.xml', 'r', encoding='utf8') as inf:
        soup = bs(inf.read(), 'html.parser')
    return [id.text.strip() for id in soup.find_all('id')]


def get_pairs(sents, genes, gene_ids):
    pairs = {}
    p = 1
    for s in sents:
        for i in range(len(genes)):
            for j in range(i, len(genes)):
                if genes[i] == genes[j]:
                    continue
                if genes[i] in s and genes[j] in s:
                    pairs['pair_{}'.format(p)] = {'gene_1_name': genes[i], 'gene_2_name': genes[j],
                                                                 'gene_1_id': gene_ids[genes[i]],
                                                                 'gene_2_id': gene_ids[genes[j]]}
                    p += 1
    return pairs


def get_genes_and_diseases(id_list):
    r = requests.get('https://www.ncbi.nlm.nih.gov/research/pubtator-api/publications/export/biocxml?pmids=' +
                     ','.join(id_list) + '&concepts=gene').text
    soup = bs(r, 'html.parser')
    tags = []
    for doc in soup.find_all('document'):

        id = doc.id.text
        genes = set()
        gene_ids = {}
        diseases = {}
        abstr = doc.find_all('passage')[1]
        for ann in abstr.find_all('annotation'):
            for info in ann.find_all('infon'):
                if info['key'] == 'type' and info.text == 'Gene':
                    genes.add(ann.find('text').text)
                    gene_ids[ann.find('text').text] = ann.find('infon').text
                elif info['key'] == 'type' and info.text == 'Disease':
                    if len(ann.find('infon').text.split(':')) > 1:
                        diseases[ann.find('text').text] = ann.find('infon').text.split(':')[1]
                    elif ann.find('infon').text:
                        diseases[ann.find('text').text] = ''
        try:
            pairs = get_pairs(sent_tokenize(abstr.find('text').text), list(genes), gene_ids)
            if pairs:
                tags.append(json.dumps({id: {'genes': pairs, 'diseases': diseases}}, indent=4)[1:-2])
        except AttributeError:
            print(abstr)

    return ','.join(tags)


def main():
    total = 23172
    abs_per_file = 100
    id_list = get_id_list()

    filename = 'gene_pairs.json'
    with open(filename, 'w', encoding='utf8') as ouf:
        ouf.write('{')
        for i in range(total // abs_per_file + 1):
            print('Ids {0}-{1} are being processed...'.format(abs_per_file * i, abs_per_file * i + abs_per_file))
            if total < abs_per_file * i + abs_per_file:
                ouf.write(get_genes_and_diseases(id_list[abs_per_file * i:]) + '\n')
            else:
                ouf.write(get_genes_and_diseases(id_list[abs_per_file * i:abs_per_file * i + abs_per_file]) + ',\n')
        ouf.write('}')


if __name__ == '__main__':
    main()
