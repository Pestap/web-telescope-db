import json

def get_json_objects(file='combined.json'):
    with open(file, encoding='utf-8') as file:
        y = json.loads(file.read())