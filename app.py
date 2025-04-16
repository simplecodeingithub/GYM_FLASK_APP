from flask import Flask
from flask_app import app

# app = Flask(__name__)
# # register_routes(app)

if __name__ == '__main__':
    app.run(debug=True)