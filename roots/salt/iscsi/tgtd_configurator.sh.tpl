#/bin/sh

tgt-admin --delete ALL
{% for device, parameters in pillar.get('iscsi', {})['devices'].items() %}
  {%- set tid = loop.index -%}
    tgtadm --lld iscsi --op new --mode target --tid {{ tid }} -T {{ pillar.get('iscsi', {})['target_prefix'] }}:{{ device }}
  {% for user, password in (parameters['incoming'] or {}).items() -%}
    tgtadm --lld iscsi --mode account --op new --user {{ user }} --password {{ password }}
    tgtadm --lld iscsi --mode account --op bind --tid {{ tid }} --user {{ user }}
  {% endfor -%}
  {% for user, password in (parameters['outgoing'] or {}).items() -%}
    tgtadm --lld iscsi --mode account --op new --user {{ user }} --password {{ password }}
    tgtadm --lld iscsi --mode account --op bind --tid {{ tid }} --user {{ user }} --outgoing
  {% endfor -%}
  {% for path, options in parameters['paths'].items() -%}
    touch -a {{ path }} && tgtadm --lld iscsi --mode logicalunit --op new --tid {{ tid }} --lun {{ loop.index }} -b {{ path }}
  {% endfor -%}
  tgtadm --lld iscsi --op bind --mode target --tid {{ tid }} -I ALL
{% endfor %}
