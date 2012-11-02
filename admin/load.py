#!/usr/bin/python

import os
import requests # See http://docs.python-requests.org/
import json
import sys

def store(user, pwd, dburl, data):
    URL = "http://httpbin.org/put"
    URL = "http://localhost:8011/v1/documents?uri=" + dburl
    print "Storing " + URL
    headers = {
        'Content-type': 'application/json' # hardcoded to json
    }
    r = requests.put(URL, auth=(user, pwd), data=json.dumps(data), headers=headers)
    if r.status_code >= 400 :
        print "Status " + str(r.status_code)
        print "Response:" + r.text
        exit(-1)

def walk(dir):
    for root, dirs, files in  os.walk(dir):
        for f in files:
            yield os.path.join(root, f)


# Walk a data directory and grab all the files, which we know to be json
for file in walk("data") :
    f = open(file).read()
    url = file.replace("data", "")
    if len(sys.argv) < 2:
        print "Usage: " + sys.argv[0] + " admin-password"
        exit(-1)
    store('admin', sys.argv[1], url, f)
    
    
