tgt:
  pkg:
    - installed

/etc/init.d/tgtd:
  file.managed:
    - source: salt://iscsi/tgtd.init
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - require:
      - pkg: tgt
      - file: /etc/default/tgtd

update-rc.d tgtd defaults:
  cmd.run:
    - require:
      - file: /etc/init.d/tgtd

/etc/default/tgtd:
  file.managed:
    - source: salt://iscsi/tgtd.default
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: tgt

tgtd:
  service.running:
    - require:
      - file: /etc/init.d/tgtd
      - pkg: tgt

configure_tgtd:
  cmd.run:
    - require:
      - service: tgtd
    - name: tgt-admin --delete ALL &&
{%- for device, parameters in pillar.get('iscsi', {})['devices'].items() -%}
    {%- set tid = loop.index -%}
      tgtadm --lld iscsi --op new --mode target --tid {{ tid }} -T {{ pillar.get('iscsi', {})['target_prefix'] }}:{{ device }} && 
    {%- for user, password in (parameters['incoming'] or {}).items() -%}
      tgtadm --lld iscsi --mode account --op new --user {{ user }} --password {{ password }} && 
      tgtadm --lld iscsi --mode account --op bind --tid {{ tid }} --user {{ user }} && 
    {%- endfor -%}
    {%- for user, password in (parameters['outgoing'] or {}).items() -%}
      tgtadm --lld iscsi --mode account --op new --user {{ user }} --password {{ password }} && 
      tgtadm --lld iscsi --mode account --op bind --tid {{ tid }} --user {{ user }} --outgoing && 
    {%- endfor -%}
    {%- for path, options in parameters['paths'].items() -%}
      touch -a {{ path }} && tgtadm --lld iscsi --mode logicalunit --op new --tid {{ tid }} --lun {{ loop.index }} -b {{ path }} &&
    {%- endfor -%}
      tgtadm --lld iscsi --op bind --mode target --tid {{ tid }} -I ALL &&
{%- endfor -%}
      tgt-admin --dump > /etc/tgt/targets.conf
