from flask import Flask, render_template, request, redirect, url_for, jsonify
from table_creation import make_table


app = Flask(__name__)

partners = {
                "gene1":{
                    "Partner": "Partner1",
                    "Action": "action on partner1",
                    "PMID": "PMID1",
                    "Interaction is described in": "someDB",
                    "Pathway": "pathway1",
                    "Type of cancer":"some cancer1"
                },
                "gene2":{
                    "Partner": "Partner2",
                    "Action": "action on partner2",
                    "PMID": "PMID2",
                    "Interaction is described in": "someDB",
                    "Pathway": "pathway2",
                    "Type of cancer":"some cancer2"
                },
                "gene3":{
                    "Partner": "Partner3",
                    "Action": "action on partner3",
                    "PMID": "PMID3",
                    "Interaction is described in": "someDB",
                    "Pathway": "pathway3",
                    "Type of cancer":"some cancer3"
                }
            }


@app.route("/")
def hello():
    return render_template('main.html', test_data = make_table(partners))

