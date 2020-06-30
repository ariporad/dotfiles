import sys
import json
import subprocess
from urllib.parse import urlencode
from urllib.request import urlopen, Request
from .auth import get_token, set_token, Token
from .config import CLIENT_ID, CLIENT_SECRET, OAUTH_TOKEN_URL


def _post(url, data, headers={}, json_data=True):
    """
    Send a POST request to url with data and headers. If json_data is True, data will be encoded as JSON, otherwise as urlencoded.
    Response body is always parsed as JSON.
    """

    encoded_data = urlencode(data) if not json_data else json.dumps(data)
    headers["Content-Type"] = (
        "application/x-www-form-urlencoded" if not json_data else "application/json"
    )
    req = Request(url, encoded_data.encode("ascii"), headers)

    with urlopen(req) as r:
        return json.loads(r.read())


def aquire_token(username, password):
    try:
        r = _post(
            OAUTH_TOKEN_URL,
            data={
                "grant_type": "password",
                "client_id": CLIENT_ID,
                "client_secret": CLIENT_SECRET,
                "username": username,
                "password": password,
            },
            json_data=False,
        )

        access_token = r["access_token"]
        instance_url = r["instance_url"]

        set_token(Token(instance_url, access_token))

        return True
    except:
        set_token(None)
        return False


def search(query):
    r = _post(
        get_token().instance_url + "/services/data/v36.0/parameterizedSearch",
        data={
            "q": query,
            "fields": ["id"],
            "in": "NAME",
            "overallLimit": 100,
            "defaultLimit": 100,
            "sobjects": [
                {"fields": ["id", "name", "website", "phone"], "name": "Account"}
            ],
        },
        headers={
            "Authorization": "Bearer " + get_token().token,
            "Content-Type": "application/json",
        },
        json_data=True,
    )
    return r
