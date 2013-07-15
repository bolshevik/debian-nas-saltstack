include:
  - openssl

nginx:
  pkg:
    - installed
    - require:
      - pkg: openssl
  service:
    - running
    - require:
      - cmd: /etc/nginx/keys/server.key

/etc/nginx/keys:
  file.directory:
    - makedirs: True
    - user: root
    - group: root
    - mode: 700
    - require:
      - pkg: nginx

/var/www/:
  file.directory:
    - makedirs: True
    - user: www-data
    - group: www-data
    - mode: 770
    - require:
      - pkg: nginx

/etc/nginx/keys/server.key:
  cmd.run:
    - name: 'echo -e "US\n.\n.\n.\n.\n.\n.\n.\n" | openssl req -nodes -newkey rsa:2048 -x509 -keyout server.key -out server.crt'
    - unless: "test -f server.key"
    - cwd: /etc/nginx/keys
    - require:
      - pkg: nginx
      - pkg: openssl
      - file: /etc/nginx/keys

/etc/nginx/sites-available/locations/:
  file.directory:
    - makedirs: True
    - user: root
    - group: root
    - mode: 700

