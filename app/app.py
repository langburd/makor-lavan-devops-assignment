#!/usr/bin/env python3

"""Example echo server application prepared for Mend."""

import os

import geocoder
from flask import Flask, abort, jsonify, request

app = Flask(__name__)

# Get data from the environment variables
app_environment = os.environ.get("APP_ENVIRONMENT", "undefined")
app_version = os.environ.get("APP_VERSION", "v1.0.0")
index_html_dir = os.environ.get("INDEX_HTML_DIR", "web")


@app.route("/")
def echo():
    """Main function returning the given echo string and geo location of the user."""
    echo_string = {
        "_app_environment": app_environment,
        "_app_version": app_version,
        "_app_repository": "https://github.com/langburd/makor-lavan-devops-assignment",
    }

    if request.headers.getlist("X-Forwarded-For"):
        client_ip = request.headers.getlist("X-Forwarded-For")[0]
    else:
        client_ip = request.remote_addr

    geo_location_data = geocoder.ip(client_ip)

    response_data = echo_string | geo_location_data.json

    return jsonify(response_data)


@app.route("/index.html")
def serve_index():
    """Function serving the index.html file."""

    try:
        with open(f"{index_html_dir}/index.html", "r", encoding="utf-8") as file:
            content = file.read()
        return content
    except FileNotFoundError:
        abort(404)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
