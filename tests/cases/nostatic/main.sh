#!/usr/bin/env -S bash -x
# Exit on first error and cleanup.
set -e
trap 'kill $(pgrep -g $$ | grep -v $$) > /dev/null 2> /dev/null || :' EXIT
xargs rm -rvf < .gitignore

# Run the example
stepup -w 1 plan.py & # > current_stdout.txt &

# Get the graph after completion of the pending steps.
python3 - << EOD
from stepup.core.interact import *
wait()
graph("current_graph")
EOD

# Check files that are expected to be present and/or missing.
[[ -f plan.py ]] || exit -1
[[ -f first.txt ]] || exit -1
[[ -f second.txt ]] || exit -1

# Test cleanup that has no effect
cleanup plan.py

# Check files that are expected to be present and/or missing.
[[ -f plan.py ]] || exit -1
[[ -f first.txt ]] || exit -1
[[ -f second.txt ]] || exit -1

# Test cleanup that removes first and second
cleanup ./

# Check files that are expected to be present and/or missing.
[[ -f plan.py ]] || exit -1
[[ ! -f first.txt ]] || exit -1
[[ ! -f second.txt ]] || exit -1

# Exit stepup
python3 - << EOD
from stepup.core.interact import *
join()
EOD

# Wait for background processes, if any.
wait $(jobs -p)
