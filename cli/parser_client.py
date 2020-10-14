import argparse
import json
import requests

from pprint import pprint
from typing import NamedTuple

BASE_URL = "http://localhost:4000/api/"

class Request(NamedTuple):
    endpoint: str
    query: str

def get_args():
    parser = argparse.ArgumentParser(description="Github Parser API cli client")
    parser.add_argument("endpoint", help="API endpoint. Choices: getRepos, getRepoBy, updateRepos", choices=["getRepos", "getRepoBy", "updateRepos"])
    parser.add_argument("-q", "--query", help="Query param for getBy")
    return parser.parse_args()

def create_request(args):
    if args.endpoint is "getRepoBy" and args.query is None:
        raise Exception("Error. Query param is undefined")
    return Request(args.endpoint, args.query)

def get_request(endpoint, params):
    result = requests.get(BASE_URL + endpoint, params=params)
    pprint(json.loads(result.text))

def post_request(endpoint):
    requests.post(BASE_URL + endpoint)
    print("Repos update started")

if __name__ == "__main__":
    args = get_args()
    request = create_request(args)
    if request.endpoint == "updateRepos":
        post_request(request.endpoint)
    else:
        get_request(request.endpoint, {"query": request.query})
