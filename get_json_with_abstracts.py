import json

from bs4 import BeautifulSoup as bs


def main():
    filename = 'abstracts.xml'
    with open(filename, 'r', encoding='utf8') as inf:
        soup = bs(inf.read(), 'html.parser')
    tags = []
    with open('abstracts.json', 'w', encoding='utf8') as ouf:
        ouf.write('{')
        for article in soup.find_all('pubmedarticle'):
            tags.append(json.dumps({article.id.text.strip(): {'title': article.title.text.strip(),
                                                            'abstract': article.abstract.text.strip()}}, indent=4)[1:-2])
        ouf.write(','.join(tags))
        ouf.write('\n}')


if __name__ == '__main__':
    main()
