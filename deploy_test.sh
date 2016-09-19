#!/bin/bash

# IDEA: maybe it is possible to run the test only for the directory that changed?

# Exit on error. Append || true if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail
# Turn on traces, useful while debugging but commented out by default
# set -o xtrace

# Set magic variables for current file, directory, os, etc.
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
#__base="$(basename ${__file} .sh)"
#__ex_dir="${__dir}/exercises"

for dir in exercises/*  ; do

  ex_name="${dir/exercises\//}" # keep only dir name, not path
  echo "### Checking all tests pass for exercise '${ex_name}'."

  cd "${dir}" || echo "Could not 'cd ${dir}'!"

  # some exercices have directories and exercices name that differ: '-' vs '_'
  if [[ ! -e "${ex_name}_test.sh" ]]; then
    ex_name2="${ex_name/-/_}"
    if [[ ! -e "${ex_name2}_test.sh" ]]; then
      echo "Files ${dir}/${ex_name}_test.sh or ${dir}/${ex_name2}_test.sh do not exit. Aborting."
      exit 1
    fi
    ex_name="${ex_name2}"
  fi

  # create the exercice file that the test file expects
  cp example.sh "${ex_name}.sh"

  # check if the tests pass for this exercise
  bats "${ex_name}_test.sh"

  cd ../../

  echo
done

if [[ $? ]]; then # always 0 with set -e
  echo "All tests have passed."
fi
