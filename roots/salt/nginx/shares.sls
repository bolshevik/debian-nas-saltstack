{% from "nginx/macros.sls" import share_up %}
{% from "nginx/macros.sls" import share_down %}

include:
  - nginx

apache2-utils:
  pkg:
    - installed
    - require_in:
      - pkg: nginx

{% for user, parameters in pillar.get('users', {})['add_users'].items() %}
{% if parameters['web'] %}
{{ share_up(user, parameters) }}
{% else %}
{{ share_down(user) }}
{% endif %}
{% endfor %}

{% if pillar.get('users', {})['delete_users'] -%}
{% for user in pillar.get('users', {})['delete_users'] %}
{{ share_down(user) }}
{% endfor %}
{%- endif %}

/etc/nginx/sites-available/default:
  file.managed:
    - source: salt://nginx/hosts
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: nginx
      - file: /etc/nginx/sites-available/locations/
    - watch_in:
      - service: nginx

/etc/nginx/sites-enabled/default:
  file.symlink:
    - target: /etc/nginx/sites-available/default
    - watch_in:
      - service: nginx
