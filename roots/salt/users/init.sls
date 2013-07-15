{# Adds new users. #}
{% for user, parameters in pillar.get('users', {})['add_users'].items() -%}
{{user}}:
  user:
    - present
    - gid_from_name: True
    - home: {{parameters['home']}}
    - shell: {{parameters['shell']}}
    - require:
      - group: {{user}}
      - pkg: general
    - groups:
      - {{user}}
  group:
    - present
    - require:
      - pkg: general
  {% if parameters['publickey'] %}
  ssh_auth:
    - present
    - user: {{user}}
    - source: {{parameters['publickey']}}
    - require:
      - user: {{user}}
  {% endif %}

{% if parameters['password'] -%}
set_{{user}}_passwd:
  cmd.run:
   - name: echo -e "{{parameters['password']}}\n{{parameters['password']}}\n" | passwd {{user}}
   - require:
     - user: {{user}}
     - pkg: general
{%- endif %}

{{ parameters['home'] }}:
  file.directory:
    - user: {{user}}
    - group: {{user}}
    {% if parameters['password'] or parameters['publickey'] %}
    - mode: 750
    {% else %}
    - mode: 770
    {% endif %}
    - makedirs: True
    - require:
      - user: {{user}}

{% if parameters['sudo'] and parameters['shell'] %}
include:
  - sudo

extend:
  sudo:
    file:
     - managed
     - name: /etc/sudoers.d/{{user}}
     - source: salt://users/sudoer
     - template: jinja
     - user: root
     - group: root
     - mode: 440
     - require:
       - pkg: sudo
       - user: {{user}}
     - context:
       username: {{user}}
       parameters: {{parameters['sudo']}}
{% else %}
/etc/sudoers.d/{{user}}:
  file:
    - absent
    - require:
      - user: {{user}}
{% endif %}
{%- endfor %}

{# Deletes deleted users. #}
{% if pillar.get('users', {})['delete_users'] -%}
{% for user in pillar.get('users', {})['delete_users'] -%}
/etc/sudoers.d/{{user}}:
  file:
    - absent
    - require:
      - user: {{user}}
{{user}}:
  user:
    - absent
    - purge: True
    - force: True
  group:
    - absent
    - require:
      - user: {{user}}
{%- endfor %}
{%- endif %}
