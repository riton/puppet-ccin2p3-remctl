#!/bin/bash

set -x

[[ ! -d "./tests" ]] && { echo "No tests to run"; exit 0; }

old_modpath=$(puppet config print modulepath)
modpath="${old_modpath}:$(pwd)/.."
for t in $(find ./tests -type f -name '*.pp')
do
    echo "[*] -- ${t} --"
    puppet apply --modulepath=${modpath} --verbose --debug --noop ${t}
    [[ $? -ne 0 ]] && { echo "FAIL: '${t}'" >&2; exit 2; }
    echo "[*] -- ${t} passed --"
done

echo "[*] All tests passed"

exit 0
