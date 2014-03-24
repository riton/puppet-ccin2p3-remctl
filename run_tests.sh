#!/bin/bash

set -x

[[ ! -d "./tests" ]] && { echo "No tests to run"; exit 0; }

old_modpath=$(puppet config print modulepath)
modpath="${old_modpath}:$(pwd)/.."
for t in $(find ./tests -type f -name '*.pp')
do
    puppet apply --modulepath=${modpath} --verbose --noop ${t}
    [[ $? -ne 0 ]] && { echo "FAIL: '${t}'" >&2; exit 1; }
done
