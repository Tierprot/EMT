import json

from flask import Flask, jsonify, request, render_template
from pymongo import MongoClient
from table_creation import make_table

app = Flask(__name__)

partners = {
    "gene1": {
        "Partner": "Partner1",
        "Action": "action on partner1",
        "PMID": "PMID1",
        "Interaction is described in": "someDB",
        "Pathway": "pathway1",
        "Type of cancer": "some cancer1"
    },
    "gene2": {
        "Partner": "Partner2",
        "Action": "action on partner2",
        "PMID": "PMID2",
        "Interaction is described in": "someDB",
        "Pathway": "pathway2",
        "Type of cancer": "some cancer2"
    },
    "gene3": {
        "Partner": "Partner3",
        "Action": "action on partner3",
        "PMID": "PMID3",
        "Interaction is described in": "someDB",
        "Pathway": "pathway3",
        "Type of cancer": "some cancer3"
    }
}

db = MongoClient('loca31578811210419'
                 'alhost', 27017).genes_base

with open('relations_3000.json') as f:
    data = json.loads(f.read())

with open('cancers.json') as f:
    cancers = json.loads(f.read())

with open('super.json') as f:
    genes_mapping = json.loads(f.read())

with open('gene_pairs_checked.json') as f:
    genes_data = json.loads(f.read())

print(genes_mapping['BP-14'])

genes_info = db.genes_info
for elem in data:
    genes_info.insert(elem)

a = [elem.get('gen', '') for elem in data]
a = [elem for sublist in a for elem in sublist]
b = tuple(cancers.keys())
print(type(b))
print(list(set(a) & set(b)))


@app.route("/", methods=['GET'])
def index():
    return render_template('main.html')


@app.route('/genes', methods=['GET'])
def get_genes():
    gene = request.args.get('gene', type=str)
    info = genes_info.find_one({"gen": gene})
    return jsonify(html=make_table({'gene1': {'Partner': genes_mapping[gene][0],
                                              'PMID': info['id'],
                                              'Abstract': info['abstract'],
                                              'Action': info['match'][0][0],
                                              'Type of cancer': cancers[gene]['diabetes mellitus'],
                                              'Pathway': '',
                                              'Interaction is described in': ''}}))


@app.route('/gene', methods=['GET'])
def get_gene():
    gene = request.args.get('gene', type=str)
    return jsonify({gene: genes_info.find_one({"gen": gene})['id']})


@app.route('/abstract', methods=['GET'])
def get_abstract():
    gene = request.args.get('gene', type=str)
    return jsonify({gene: genes_info.find_one({"gen": gene})['abstract']})


@app.route('/matches', methods=['GET'])
def get_match():
    gene = request.args.get('gene', type=str)
    return jsonify({gene: genes_info.find_one({"gen": gene})['match']})


@app.route('/pairs', methods=['GET'])
def get_pairs():
    id = request.args.get('id', type=str)
    return jsonify({id: genes_data[id]})


@app.route("/search_info", methods=['POST'])
def search_info():
    print('im inside')
    gene_id = request.get_json()['gene_id']
    info = genes_info.find_one({"gen": gene_id})
    partners = {'gene1': {'Partner': genes_mapping[gene_id][0],
                          'PMID': info['id'],
                          'Abstract': info['abstract'],
                          'Action': info['match'][0][0],
                          'Type of cancer': cancers[gene_id]['diabetes mellitus'],
                          'Pathway': '',
                          'Interaction is described in': ''}}
    return jsonify(html=make_table(partners))


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5555, debug=True)
