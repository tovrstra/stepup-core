#!/usr/bin/env -S bash -x
# Exit on first error and clean up.
set -e
trap 'kill $(pgrep -g $$ | grep -v $$) > /dev/null 2> /dev/null || :' EXIT
rm -rvf $(cat .gitignore)

# Run the example
cp plan1.py plan.py
echo hello > inp.txt
stepup boot -n 1 -w & # > current_stdout.txt &

# Get the graph after completion of the pending steps.
stepup wait
stepup graph current_graph1

# Check files that are expected to be present and/or missing.
[[ -f plan.py ]] || exit 1
[[ -f out.txt ]] || exit 1
[[ -f out1.txt ]] || exit 1
[[ ! -f out2.txt ]] || exit 1

# Remove the static file foo.txt, change the plan and rerun
cp plan2.py plan.py
rm inp.txt
stepup watch-delete inp.txt
stepup run
stepup wait
stepup graph current_graph2
stepup join

# Wait for background processes, if any.
wait

# Check files that are expected to be present and/or missing.
[[ -f plan.py ]] || exit 1
[[ ! -f out.txt ]] || exit 1
[[ ! -f out1.txt ]] || exit 1
[[ -f out2.txt ]] || exit 1
