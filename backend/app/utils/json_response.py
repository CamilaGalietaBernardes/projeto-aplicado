from flask import Response
import json

def json_unicode(data, status=200):
    return Response(
        json.dumps(data, ensure_ascii=False),
        content_type="application/json"
    ), status
