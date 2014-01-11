{% macro share_up(user, parameters) -%}
{% if parameters['password'] -%}
secure_webhome_{{user}}:
  cmd.run:
    - name: htpasswd -bc {{parameters['home']}}/.htpasswd {{user}} "{{parameters['password']}}"
    - require:
      - user: {{user}}
      - pkg: nginx

{{parameters['home']}}/.htpasswd:
  file.managed:
    - user: {{user}}
    - group: {{user}}
    - file_mode: 644
    - create: False
    - require:
      - cmd: secure_webhome_{{user}}
    - require_in:
      - file: /etc/nginx/sites-available/default
{%- endif %}

/etc/nginx/sites-available/locations/{{user}}:
  file.managed:
    - require_in:
      - file: /etc/nginx/sites-available/default
    - source: salt://nginx/userlocation
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - context:
      username: {{user}}
    - require:
      - pkg: nginx
      - file: /etc/nginx/sites-available/locations/
    - watch_in:
      - service: nginx

nginx_share_up_{{user}}:
  cmd.run:
    - name: usermod -a -G {{user}} www-data
    - require:
      - user: {{user}}
      - pkg: nginx
    - watch_in:
      - service: nginx
{%- endmacro %}

{% macro share_down(user) -%}
nginx_share_down_{{user}}:
  file:
    - absent
    - names:
      - /home/{{user}}/.htpasswd
    - require:
      - service: nginx
      - user: {{user}}

remove_www_data_from_{{user}}_group:
  cmd.run:
    - name: gpasswd -d www-data {{user}} || true
    - require:
      - user: {{user}}
      - pkg: nginx
    - watch_in:
      - service: nginx

/etc/nginx/sites-available/locations/{{user}}:
  file:
    - absent
    - watch_in:
      - service: nginx
{%- endmacro %}
