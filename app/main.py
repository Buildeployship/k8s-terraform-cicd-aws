import os
from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def index():
    return jsonify(
        version=os.environ.get("APP_VERSION", "0.1.0"),
        pod_name=os.environ.get("POD_NAME", "unknown"),
        namespace=os.environ.get("POD_NAMESPACE", "unknown"),
        node=os.environ.get("NODE_NAME", "unknown"),
        config_value=os.environ.get("CONFIG_VALUE", "unset"),
    )


@app.get("/healthz")
def healthz():
    return jsonify(status="healthy"), 200
