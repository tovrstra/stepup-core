#!/usr/bin/env bash
git clean -qdfX .
export COLUMNS=80
unset STEPUP_ROOT
stepup boot --no-progress -n 4 | sed -f ../../clean_stdout.sed > stdout.txt

# INP: plan.py
