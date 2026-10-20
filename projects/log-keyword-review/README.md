# Project 4 — Log keyword review

A small helper counts lines matching common keywords in a text log (not every repeated occurrence within a line). Start with the sample fixture at tests/fixtures/sample.log. Do not commit real system logs; they may contain sensitive data.

## Run it

    bash projects/log-keyword-review/log-keyword-review.sh tests/fixtures/sample.log

Provide another file path to review a log you are authorized to read. The script only reads the file and prints counts.

## Exercise

Add an option to choose the keyword, and distinguish “no matches” from “file could not be read”. Keep input as data; do not build a command string and pass it to eval.
