duplicity:
  pkg.installed

{{ pillar.get('backups', {})['destination_folder'] }}:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

{{ pillar.get('backups', {})['destination_folder'] }}/tmp:
  file.directory:
    - user: root
    - group: root
    - mode: 750
    - makedirs: True
    - require:
      - file: {{ pillar.get('backups', {})['destination_folder'] }}

{% for user, parameters in pillar.get('users', {})['add_users'].items() %}
{% if parameters['backups'] %}
{{ pillar.get('backups', {})['destination_folder'] }}/{{ user }}:
  file.directory:
    - user: {{ user }}
    - group: {{ user }}
    - mode: 750
    - makedirs: True
    - require:
      - file: {{ pillar.get('backups', {})['destination_folder'] }}

{{ parameters['home'] }}/backuplist.txt:
  cmd.run:
    - name: 'echo -e "{{ parameters['home'] }}/backuplist.txt\n- {{ parameters['home'] }}/**\n" > backuplist.txt && chown {{user}}:{{user}} backuplist.txt'
    - unless: "test -f backuplist.txt"
    - cwd: {{ parameters['home'] }}
    - require:
      - user: {{ user }}
{% endif %}
{% endfor %}

/root/backup.sh:
  file:
    - managed
    - source: salt://backups/backup.sh
    - template: jinja
    - user: root
    - group: root
    - mode: 700
    - require:
      - pkg: duplicity
  cron:
    - present
    - minute: 0
    - hour: 5
    - require:
      - file: /root/backup.sh
