#!/bin/bash

# Pass user:password on command line
CREDS=${1:-admin:xxxx}

API="http://mlw12.marklogic.com/rest-api/v1"

curl --anyauth --user "$CREDS" -H "Content-type: application/json" -X PUT "$API/config/properties/error-format?format=json" -d @-<< HERE
    { "error-format": "json" }
HERE

curl --anyauth --user "$CREDS" -H "Content-type: application/json" -X PUT "$API/config/query/mlw12?format=json" -d @-<< HERE
    {
        options: {
            constraint: [
                {
                    name: "type",
                    value: {
                        "json-key": "type"
                    }
                },
                {
                    name: "speaker",
                    range: {
                        "json-key": "speakerName",
                        "type": "xs:string",
                        "facet-option": "ascending"
                    }
                },
                {
                    name: "track",
                    range: {
                        "json-key": "track",
                        "type": "xs:string",
                        "facet-option": "ascending"
                    }
                }
            ],
            "transform-results": {
                "apply": "raw"
            }
        }
    }
HERE
