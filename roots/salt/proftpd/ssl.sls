include:
  - openssl

/etc/proftpd/certs:
  file.directory:
    - makedirs: True
    - user: root
    - group: root
    - mode: 700
    - require:
      - pkg: proftpd-basic
      - pkg: openssl

/etc/proftpd/certs/proftpd.key:
  cmd.run:
    - name: 'echo -e "US\n.\n.\n.\n.\n.\n.\n.\n" | openssl req -nodes -newkey rsa:2048 -x509 -keyout proftpd.key -out proftpd.crt && chmod 0600 proftpd*'
    - unless: "test -f proftpd.key"
    - cwd: /etc/proftpd/certs
    - require:
      - pkg: proftpd-basic
      - pkg: openssl
      - file: /etc/proftpd/certs

/etc/proftpd/tls.conf:
  file.managed:
    - source: salt://proftpd/tls.conf
    - template: jinja
    - require:
      - pkg: proftpd-basic
      - cmd: /etc/proftpd/certs/proftpd.key
    - watch:
      - cmd: /etc/proftpd/certs/proftpd.key
