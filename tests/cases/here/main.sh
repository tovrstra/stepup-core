#!/usr/bin/env -S bash -x
# Exit on first error and cleanup.
set -e
trap 'kill $(pgrep -g $$ | grep -v $$) > /dev/null 2> /dev/null || :' EXIT
xargs rm -rvf < .gitignore

# Run the example
export STEPUP_ROOT="${PWD}/source"
export PUBLIC="../public"
stepup -w 1 plan.py & # > current_stdout.txt &

# Get the graph after completion of the pending steps.
python3 - << EOD
from stepup.core.interact import *
wait()
graph("../current_graph")
join()
EOD

# Check files that are expected to be present and/or missing.
[[ -f source/plan.py ]] || exit -1
[[ -f source/www/plan.py ]] || exit -1
[[ -f source/www/index.md ]] || exit -1
[[ -f public/www/index.md ]] || exit -1

# Wait for background processes, if any.
wait $(jobs -p)
