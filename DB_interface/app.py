from flask import Flask, render_template, request, redirect, url_for, jsonify
app = Flask(__name__)

@app.route("/")
def hello():
    return render_template('index.html')