import subprocess
import json
import ocrc

def cabbages():
    return Client(ocrc_path="~/.ocrc").cabbages()

class Client():
    def __init__(self, ocrc_path):
        self.ocrc_path = ocrc_path

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
        return parse_json(stdout_of(self.cabbages_command()))

    def cabbages_command(self):
        return ["oc", "cabbages"] + self.auth_args()

    def auth_args(self):
        try:
            with open(self.ocrc_path, 'r') as f:
                username, password = ocrc.get_credentials_exported_by(f.read())
            return ["--username", username, "--password", password]
        except IOError:
            return []

def parse_json(str):
    return json.loads(str)

def stdout_of(cmd):
    return subprocess.check_output(cmd)
