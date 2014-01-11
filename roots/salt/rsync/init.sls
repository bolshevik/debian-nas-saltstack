rsync:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: /etc/rsyncd.conf
    - require:
      - file: /etc/default/rsync

/etc/rsync:
  file.directory:
    - user: root
    - group: root
    - mode: 700
    - makedirs: True
    - require:
      - pkg: rsync

/etc/rsyncd.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - source: salt://rsync/rsyncd.conf.tpl
    - template: jinja
    - require:
      - pkg: rsync

/etc/default/rsync:
  file.append:
    - text: RSYNC_ENABLE=true

{% for user, parameters in pillar.get('users', {})['add_users'].items() %}
{% if parameters['rsync'] and parameters['rsync']['enabled'] %}
/etc/rsync/{{ user }}.secrets:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - contents: >
        {% if parameters['rsync']['auth'] %}
        {%- for login, pass in parameters['rsync']['auth'].items() %}
        {{ login }}:{{ pass }}
        {% endfor -%}
        {%- endif %}
    - require:
      - file: /etc/rsync
{% else %}
/etc/rsync/{{ user }}.secrets:
  file.absent
{% endif %}
{% endfor %}
