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

/tmp/tgtd_configurator.sh:
  file.managed:
    - source: salt://iscsi/tgtd_configurator.sh.tpl
    - user: root
    - group: root
    - mode: 700
    - template: jinja
    - require:
      - service: tgtd    

configure_tgtd:
  cmd.run:
    - require:
      - file: /tmp/tgtd_configurator.sh
    - name: /tmp/tgtd_configurator.sh && tgt-admin --dump > /etc/tgt/targets.conf && rm /tmp/tgtd_configurator.sh
