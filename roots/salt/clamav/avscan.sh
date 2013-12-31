#!/bin/sh
freshclam

scan() {
  PARAMETERS="-r --cross-fs=no -i --scan-mail=no --scan-archive=no --scan-archive=no --max-scansize=10m --max-files=100"
  TIME_INTERVAL="-1500"
  if [ ! -f "$1/avscan.txt" ]; then
    touch "$1/avscan.txt"
    chown $2:$2 "$1/avscan.txt"
    chmod g+w "$1/avscan.txt"
  fi
  echo "\n\n$(date)" >> "$1/avscan.txt"
  if [ ! -f "$1/.fullavscan" ]; then
    touch "$1/.fullavscan"
    chown $2:$2 "$1/.fullavscan"
    chmod g+w "$1/.fullavscan"
    nice -n 5 clamscan -l "$1/avscan.txt" ${PARAMETERS} "$1" >> /var/log/clamav/avscan.log
  else
    find $1 -xdev -mmin ${TIME_INTERVAL} -print0 | xargs -0 -r clamscan -l "$1/avscan.txt" ${PARAMETERS} >> /var/log/clamav/avscan.log
  fi
}
{% for user, parameters in pillar.get('users', {})['add_users'].items() -%}
{% if parameters['avscan'] -%}
scan {{ parameters['home'] }} {{ user }}
{% endif -%}
{% endfor -%}
