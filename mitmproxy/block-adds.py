""" Just blocks all resources containing an add-like regex """
import re
from mitmproxy import http

class BlockResource:
    def __init__(self):
        self.num = 0

        self.re = re.compile("\.advertising\.$")

    def response(self, flow):
        m = re.search(self.re, flow.request.url)
        if m:
            print(f"found match for {flow.request.url}")
            #flow.response = http.HTTPResponse.make(404)

addons = [
    BlockResource()
]