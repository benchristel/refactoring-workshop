import subprocess
import json
import ocrc

def cabbages(username=None, password=None):
    return Client(ocrc_path="~/.ocrc", username=username, password=password).cabbages()

class Client():
    def __init__(self, ocrc_path='', username=None, password=None):
        self.username = username
        self.password = password
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
        return ["oc", "cabbages"] + self.creds().oc_args()

    def creds(self):
        if self.username == None or self.password == None:
            try:
                with open(self.ocrc_path, 'r') as f:
                    return CredentialsFromFile(f.read())
            except IOError:
                return NullCredentials()
        else:
            return CredentialsFromArgs(self.username, self.password)

class NullCredentials:
    def oc_args(self):
        return []

class CredentialsFromArgs:
    def __init__(self, username, password):
        self.username = username
        self.password = password

    def oc_args(self):
        return ['--username', self.username, '--password', self.password]

class CredentialsFromFile:
    def __init__(self, script):
        username, password = ocrc.get_credentials_exported_by(script)
        self.delegate = CredentialsFromArgs(username, password)

    def oc_args(self):
        return self.delegate.oc_args()

def parse_json(str):
    return json.loads(str)

def stdout_of(cmd):
    return subprocess.check_output(cmd)
