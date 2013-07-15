include:
  - samba

/etc/samba/smb.conf:
  file.managed:
    - source: salt://samba/smb.conf
    - template: jinja
    - require:
      - pkg: samba

/usr/local/samba/private/smbpasswd:
  cmd.run:
    - require:
      - pkg: samba
    - names:
      - smbpasswd -Lan {{ pillar.get('samba', {})['guest_username'] }}
{% for user, parameters in pillar.get('users', {})['add_users'].items() %}
{% if parameters['samba'] %}
   {% if parameters['password'] %}
      - echo -e "{{parameters['password']}}\n{{parameters['password']}}\n" | smbpasswd -La -s {{user}}
   {% else %}
      - smbpasswd -Lan {{user}}
      - usermod -a -G {{user}} {{ pillar.get('samba', {})['guest_username'] }}
   {% endif %}
{% endif %}
{% endfor %}

{% for user, parameters in pillar.get('users', {})['add_users'].items() %}
{% if parameters['samba'] %}
{{parameters['home']}}/.recycle:
  file.directory:
    - user: {{user}}
    - group: {{user}}
    - mode: 777
    - makedirs: True
    - require:
      - pkg: samba
      - user: {{user}}
{% else %}
{{parameters['home']}}/.recycle:
  file.absent
{% endif %}
{% endfor %}
