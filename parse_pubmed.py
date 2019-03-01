import requests
import xml.etree.ElementTree as xml

from bs4 import BeautifulSoup as bs

absent = 0


def get_ids_and_total():
    r = requests.get('https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?'
                     'db=pubmed&term=epithelial-mesenchymal+transition&RetMax=25000').text
    print('Id list loaded...')
    soup = bs(r, 'html.parser')
    total = int(soup.count.contents[0])
    ids = []
    for id in soup.idlist.find_all('id'):
        ids.append(id.contents[0])
    return total, ids


def load_abstracts(id_list):
    global absent
    r = requests.get('https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=' +
                     ','.join(id_list) + '&retmode=xml').text
    soup = bs(r, 'html.parser')
    tags = []
    for article in soup.find_all('pubmedarticle'):
        try:
            pubmedarticle = xml.Element("pubmedarticle")
            id = xml.SubElement(pubmedarticle, "id")
            id.text = article.pmid.contents[0]
            title = xml.SubElement(pubmedarticle, "title")
            title.text = article.articletitle.text
            abstr = xml.SubElement(pubmedarticle, "abstract")
            abstr.text = '\n'.join([el.text.strip() for el in article.abstract.find_all('abstracttext')])
            tags.append((bs(xml.tostring(pubmedarticle, encoding='utf8', method='html').
                            decode(), 'html.parser')).prettify() + '\n')
        except AttributeError:
            absent += 1
            continue
    return ''.join(tags)


def main():
    abs_per_file = 200
    total, ids = get_ids_and_total()
    with open('abstracts.xml', "w", encoding='utf8') as ouf:
        ouf.write("<?xml version='1.0' encoding='utf8'?>\n<root>\n")
        for i in range(total // abs_per_file + 1):
            print('Ids {0}-{1} are being processed...'.format(abs_per_file * i, abs_per_file * i + abs_per_file))
            if total < abs_per_file * i + abs_per_file:
                ouf.write(load_abstracts(ids[abs_per_file * i:]))
            else:
                ouf.write(load_abstracts(ids[abs_per_file * i:abs_per_file * i + abs_per_file]))
        ouf.write('</root>')
    print('{0}/{1} of article have no abstract.'.format(absent, total))


if __name__ == '__main__':
    main()
