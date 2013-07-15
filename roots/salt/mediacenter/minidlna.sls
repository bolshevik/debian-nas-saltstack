minidlna:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: /etc/minidlna.conf
    - require:
      - pkg: minidlna

{% for user, parameters in pillar.get('users', {})['add_users'].items() %}
{% if parameters['mediashare'] -%}
add_minidlna_to_{{user}}_group:
  cmd.run:
    - name: usermod -a -G {{user}} minidlna
    - require:
      - user: {{user}}
      - pkg: minidlna
{% else %}
remove_minidlna_from_{{user}}_group:
  cmd.run:
    - name: gpasswd -d minidlna {{user}}
    - require:
      - user: {{user}}
      - pkg: minidlna
{%- endif %}
{% endfor %}

/etc/minidlna.conf:
  file.managed:
    - source: salt://mediacenter/minidlna.conf
    - template: jinja
    - require:
      - pkg: minidlna

/var/cache/minidlna/:
  file.directory:
    - mode: 700
    - user: minidlna
    - group: minidlna
    - makedirs: True
    - require:
      - pkg: minidlna 
