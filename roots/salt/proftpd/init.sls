proftpd-basic:
  pkg.installed:
    - pkgs:
      - proftpd-basic
      - proftpd-doc

proftpd:
  service:
    - running
    - require:
      - pkg: proftpd-basic
    - watch:
      - file: /etc/proftpd/tls.conf
      - file: /etc/proftpd/proftpd.conf

include:
  - proftpd.ssl

/etc/proftpd/proftpd.conf:
  file.managed:
    - source: salt://proftpd/proftpd.conf
    - template: jinja
    - require:
      - pkg: proftpd-basic
