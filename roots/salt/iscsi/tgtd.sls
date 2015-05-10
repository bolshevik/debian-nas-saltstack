tgt:
  pkg:
    - installed
  service.running:
    - require:
      - file: /etc/init.d/tgt
      - pkg: tgt

/etc/init.d/tgt:
  file.managed:
    - source: salt://iscsi/tgt.init
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - require:
      - pkg: tgt
      - file: /etc/default/tgtd

update-rc.d tgt defaults:
  cmd.run:
    - require:
      - file: /etc/init.d/tgt

/etc/default/tgtd:
  file.managed:
    - source: salt://iscsi/tgtd.default
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: tgt

/tmp/tgtd_configurator.sh:
  file.managed:
    - source: salt://iscsi/tgtd_configurator.sh.tpl
    - user: root
    - group: root
    - mode: 700
    - template: jinja
    - require:
      - service: tgt

configure_tgtd:
  cmd.run:
    - require:
      - file: /tmp/tgtd_configurator.sh
    - name: /tmp/tgtd_configurator.sh && tgt-admin --dump > /etc/tgt/conf.d/iscsi.conf && rm /tmp/tgtd_configurator.sh
