#!/bin/sh

# $1 - path to backup, $2 - destination path, $3 - password
backup() {
  if [ -f "$1/backuplist.txt" ]; then
    echo "\n$(date)" >> "$1/backups.txt"
    export PASSPHRASE=$3
    duplicity remove-older-than 15D --force --tempdir "{{ pillar.get('backups', {})['destination_folder'] }}/tmp" file://$2 >> "$1/backups.txt"
    duplicity incr --full-if-older-than 7D --tempdir "{{ pillar.get('backups', {})['destination_folder'] }}/tmp" --exclude-other-filesystems --include-globbing-filelist $1/backuplist.txt $1 file://$2 >> "$1/backups.txt"
  fi
}

{% for user, parameters in pillar.get('users', {})['add_users'].items() -%}
{% if parameters['backups'] -%}
  backup {{parameters['home']}} {{ pillar.get('backups', {})['destination_folder'] }}/{{ user }} "{{parameters['password'] or 'password' }}"
{% endif -%}
{% endfor -%}

