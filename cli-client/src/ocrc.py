import subprocess
import os
import binascii

def get_credentials_exported_by(script):
    # choose a delimiter that's vanishingly unlikely to
    # appear in a username or password.
    delimiter = binascii.b2a_hex(os.urandom(16))
    echoer = (script + "\n echo "
        + delimiter
        + '"$OC2RTA_USERNAME"'
        + delimiter
        + '"$OC2RTA_PASSWORD"'
        + delimiter)
    return (subprocess.check_output(echoer, shell=True)
        .split(delimiter)[1:3])
