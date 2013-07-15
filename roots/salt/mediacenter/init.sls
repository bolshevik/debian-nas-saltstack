include:
#  - mediacenter.forked-daapd
  - mediacenter.minidlna

{% for user, parameters in pillar.get('users', {})['add_users'].items() -%}
{% if parameters['mediashare'] -%}
create_media_directories_{{user}}:
  file.directory:
    - names:
      - {{parameters['home']}}/Other/
      - {{parameters['home']}}/Downloads/
      - {{parameters['home']}}/Documents/
      - {{parameters['home']}}/Music/
      - {{parameters['home']}}/Pictures/
      - {{parameters['home']}}/Videos/
    - user: {{user}}
    - group: {{user}}
    - mode: 777
    - makedirs: True
    - require:
      - user: {{user}}
{% endif %}
{% endfor %}
