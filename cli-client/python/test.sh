#!/usr/bin/env bash
DIR_OF_THIS_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pushd "$DIR_OF_THIS_SCRIPT" >/dev/null
  bin/pytest
popd >/dev/null
