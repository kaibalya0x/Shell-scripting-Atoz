# Project 2 — Archive older files safely

This project teaches file discovery and cautious archiving. It lists candidate files first, uses a dedicated destination directory, and requires an explicit --apply flag before creating the archive. It does not delete originals.

## Try it in a lab

    mkdir -p /tmp/bash-archive-lab/source /tmp/bash-archive-lab/archive
    printf 'old sample\n' > /tmp/bash-archive-lab/source/old.txt
    touch -d '30 days ago' /tmp/bash-archive-lab/source/old.txt

Run a dry run:

    bash projects/archive-old-files/archive-old-files.sh \
      --source /tmp/bash-archive-lab/source \
      --destination /tmp/bash-archive-lab/archive --days 7

Review the candidate list. To create an archive after confirming the paths, add --apply:

    bash projects/archive-old-files/archive-old-files.sh \
      --source /tmp/bash-archive-lab/source \
      --destination /tmp/bash-archive-lab/archive --days 7 --apply

The project intentionally leaves originals in place. Treat archiving and deletion as separate decisions. For important data, test a restore before considering the task complete.

## Exercise

Add an option to filter by extension. Ensure it handles filenames with spaces. Test with no matches and with a source directory that does not exist.
