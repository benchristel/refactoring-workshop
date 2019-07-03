import subprocess
import json

def cabbages():
    return Client().cabbages()

class Client():
    def cabbages(self):
        """
        I have it on good authority that this returns
        something shaped like:

        {
          "cabbages": [
            {"id": "1", "weight": 20},
            {"id": "2", "weight": 32},
            {"id": "3", "weight": 13}
          ]
        }

        But really, it just returns whatever JSON the API
        returns, parsed into a Python dict.
        """
        return parse_json(stdout_of(cabbages_command()))

def parse_json(str):
    return json.loads(str)

def stdout_of(cmd):
    return subprocess.check_output(cmd)

def cabbages_command():
    return ["oc", "cabbages"]
