#!/usr/bin/env bash
DIR_OF_THIS_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! which virtualenv; then
  pip install virtualenv
fi

pushd "$DIR_OF_THIS_SCRIPT"
  virtualenv .
  source bin/activate
  pip install -r requirements.txt

  # deactivate and reactivate the virtualenv.
  # this ensures that pytest is on the PATH.
  deactivate
  source bin/activate
popd
