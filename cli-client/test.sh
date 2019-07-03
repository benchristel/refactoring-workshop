#!/usr/bin/env bash
DIR_OF_THIS_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pushd "$DIR_OF_THIS_SCRIPT" >/dev/null
  PATH="$DIR_OF_THIS_SCRIPT/fakes:$PATH" bin/pytest "$@"
popd >/dev/null
