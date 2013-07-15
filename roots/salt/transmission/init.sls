transmission-daemon:
  pkg:
    - installed
  service:
    - running
    - require:
      - file: /var/lib/transmission-daemon/info/settings.json
    - watch:
      - file: /var/lib/transmission-daemon/info/settings.json

stop_transmission:
  service.dead:
    - name: transmission-daemon
    - sig: transmission-daemon

transmission-cli:
  pkg:
    - installed

/var/debian-transmission/downloads:
  file.directory:
    - user: debian-transmission
    - group: debian-transmission
    - mode: 777 
    - makedirs: True
    - require:
      - pkg: transmission-daemon

/var/debian-transmission/incomplete:
  file.directory:
    - user: debian-transmission
    - group: debian-transmission
    - mode: 777 
    - makedirs: True
    - require:
      - pkg: transmission-daemon

{% if pillar.get('transmission', {}) %}
/var/lib/transmission-daemon/info/settings.json:
  file.managed:
    - source: salt://transmission/settings.json
    - template: jinja
    - user: debian-transmission
    - group: debian-transmission
    - mode: 500
    - require:
      - pkg: transmission-daemon
      - file: /var/debian-transmission/downloads
      - file: /var/debian-transmission/incomplete
      - service: stop_transmission
{% endif %}

{% for user, parameters in pillar.get('users', {})['add_users'].items() -%}
{% if parameters['torrents'] %}
transmission_add_to_group_{{user}}:
  cmd.run:
    - name: usermod -a -G {{user}} debian-transmission
    - require:
      - user: {{user}}
      - pkg: transmission-daemon

{{parameters['home']}}/torrents:
  file.directory:
    - user: debian-transmission
    - group: debian-transmission
    - mode: 777
    - makedirs: True
    - require:
      - pkg: transmission-daemon
      - user: {{user}}
{% else %}
transmission_remove_from_group_{{user}}:
  cmd.run:
    - name: gpasswd -d debian-transmission {{user}}
    - require:
      - user: {{user}}
      - pkg: transmission-daemon
{% endif %}
{%- endfor %}
