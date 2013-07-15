avahi-utils:
  pkg:
    - installed
    - require:
      - pkg: forked-daapd

forked-daapd:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: /etc/forked-daapd.conf
    - require:
      - pkg: forked-daapd

{% for user, parameters in pillar.get('users', {})['add_users'].items() -%}
{% if parameters['mediashare'] -%}
add_daapd_to_{{user}}_group:
  cmd.run:
    - name: usermod -a -G {{user}} daapd
    - require:
      - user: {{user}}
      - pkg: forked-daapd
{% else %}
remove_daapd_from_{{user}}_group:
  cmd.run:
    - name: gpasswd -d daapd {{user}}
    - require:
      - user: {{user}}
      - pkg: forked-daapd
{%- endif %}
{%- endfor %}

/etc/forked-daapd.conf:
  file.managed:
    - source: salt://mediacenter/forked-daapd.conf
    - template: jinja
    - require:
      - pkg: forked-daapd

/var/cache/forked-daapd/:
  file.directory:
    - mode: 700
    - user: forked-daapd
    - group: forked-daapd
    - makedirs: True
    - require:
      - pkg: forked-daapd
