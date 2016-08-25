#!/bin/bash

# IDEA: maybe it is possible to run the test only for the directory that changed?

set -e # exit if any errors

for dir in exercises/*  ; do

  ex_name="${dir/exercises\//}" # keep only dir name, not path
  echo "### Checking all tests pass for exercise '${ex_name}'."

  cd "${dir}" || echo "Could not 'cd ${dir}'!"

  # some exercices have directories and exercices name that differ: '-' vs '_'
  if [ ! -e "${ex_name}_test.sh" ]; then
    ex_name2="${ex_name/-/_}"
    if [ ! -e "${ex_name2}_test.sh" ]; then
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

if [ $? ]; then
  echo "All tests have passed."
fi
