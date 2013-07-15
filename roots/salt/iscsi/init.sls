include:
{% if pillar.get('iscsi', {})['target'] == 'tgtd' %}
  - iscsi.tgtd
{% endif %}
{% if pillar.get('iscsi', {})['target'] == 'ietd' %}
  - iscsi.ietd
{% endif %}
