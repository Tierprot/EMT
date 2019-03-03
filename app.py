import json

from flask import Flask, jsonify, request
from pymongo import MongoClient

app = Flask(__name__)


db = MongoClient('localhost', 27017).genes_database


with open('relations_3000.json') as f:
    data = json.loads(f.read())

with open('gene_pairs_checked.json') as f:
    genes_data = json.loads(f.read())

print(genes_data)

genes = db.genes
for elem in data:
    genes.insert(elem)


@app.route('/gene', methods=['GET'])
def get_gene():
    gene = request.args.get('gene', type=str)
    return jsonify({gene: genes.find_one({"gen": gene})['id']})


@app.route('/abstract', methods=['GET'])
def get_abstract():
    gene = request.args.get('gene', type=str)
    return jsonify({gene: genes.find_one({"gen": gene})['abstract']})


@app.route('/matches', methods=['GET'])
def get_match():
    gene = request.args.get('gene', type=str)
    return jsonify({gene: genes.find_one({"gen": gene})['match']})


@app.route('/pairs', methods=['GET'])
def get_pairs():
    id = request.args.get('id', type=str)
    return jsonify({id: genes_data[id]})


if __name__ == '__main__':
    app.run(debug=True)
