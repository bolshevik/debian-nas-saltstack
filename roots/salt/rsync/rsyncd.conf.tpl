syslog facility = local5
{%- for user, parameters in pillar.get('users', {})['add_users'].items() %}
{%- if parameters['rsync'] and parameters['rsync']['enabled'] %}
[{{ user }}]
  path = {{ parameters['home'] }}
  comment = {{ user }} home folder
  secrets file = /etc/rsync/{{ user }}.secrets
  auth users = {{ parameters['rsync']['auth'].keys() | join(', ') }}
  uid = {{ user }}
  gid = {{ user }}
  use chroot = yes
  exclude = .*
  hosts allow = 192.168.0.0/16 fe80::/64 10.0.0.0/8 172.16.0.0/12
  hosts deny = *
{%- endif %}
{%- endfor %}
