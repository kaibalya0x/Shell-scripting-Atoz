# Project 5 — Backup with checksums

This project creates a compressed tar archive of a directory and writes a SHA-256 checksum file beside it. A checksum can help detect accidental changes to the archive; it does not prove that the backup is restorable, encrypted, or stored safely.

## Run in a lab

    mkdir -p /tmp/bash-backup-lab/source /tmp/bash-backup-lab/backups
    printf 'sample data\n' > /tmp/bash-backup-lab/source/example.txt

    bash projects/backup-with-checksums/backup-with-checksums.sh \
      --source /tmp/bash-backup-lab/source \
      --destination /tmp/bash-backup-lab/backups

Verify the checksum using the command displayed in the checksum file. Then list the archive contents with tar -tzf ARCHIVE_NAME. For a real backup process, practise extracting to a separate restore directory.

## Important limits

The script is a starting point, not an enterprise backup system. It does not encrypt data, manage retention, guarantee application-consistent snapshots, or protect against a compromised host. Keep backups separate from the source system and test restores regularly.
