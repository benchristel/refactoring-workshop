import subprocess
import json
import ocrc

def cabbages(username=None, password=None):
    return Client(ocrc_path="~/.ocrc", username=username, password=password).cabbages()

class NullIO:
    def write(self, s):
        return None

class Client():
    def __init__(self, ocrc_path='', username=None, password=None, log=NullIO()):
        self.username = username
        self.password = password
        self.ocrc_path = ocrc_path
        self.log = log

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
        cmd = self.cabbages_command()
        self.log.write(' '.join(cmd) + '\n')
        return parse_json(stdout_of(cmd))

    def cabbages_command(self):
        return ["oc", "cabbages"] + self.creds().oc_args()

    def creds(self):
        if self.username != None and self.password != None:
            return CredentialsFromArgs(self.username, self.password)
        elif len(self.ocrc_path) > 0:
            return CredentialsFromFile(self.ocrc_path)
        else:
            return NullCredentials()

class Value:
    def __eq__(self, other):
        if isinstance(other, self.__class__):
            return self.__dict__ == other.__dict__
        else:
            return False

    def __ne__(self, other):
        return not self.__eq__(other)

class NullCredentials(Value):
    def oc_args(self):
        return []

class CredentialsFromArgs(Value):
    def __init__(self, username, password):
        self.username = username
        self.password = password

    def oc_args(self):
        return ['--username', self.username, '--password', self.password]

class CredentialsFromFile(Value):
    def __init__(self, path):
        self.path = path
        self._delegate = None

    def oc_args(self):
        return self.delegate().oc_args()

    def delegate(self):
        if self._delegate is None:
            try:
                with open(self.path, 'r') as f:
                    username, password = ocrc.get_credentials_exported_by(f.read())
                self._delegate = CredentialsFromArgs(username, password)
            except IOError:
                self._delegate = NullCredentials()

        return self._delegate

def parse_json(str):
    return json.loads(str)

def stdout_of(cmd):
    return subprocess.check_output(cmd)
