#!/usr/bin/env bash
DIR_OF_THIS_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$DIR_OF_THIS_SCRIPT/test.sh" -n 4
