include:
  - logrotate

clamav:
  pkg.installed

/root/avscan.sh:
  file:
    - managed
    - source: salt://clamav/avscan.sh
    - template: jinja
    - user: root
    - group: root
    - mode: 700
    - require:
      - pkg: clamav
  cron:
    - present
    - minute: 0
    - hour: 3
    - require:
      - file: /root/avscan.sh

/etc/logrotate.d/avscan:
  file.managed:
    - source: salt://clamav/logrotate
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: clamav
