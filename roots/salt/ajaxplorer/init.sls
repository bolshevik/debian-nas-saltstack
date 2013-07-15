include:
  - nginx
  - php-fpm

install_required_packages:
  pkg.installed:
    - pkgs:
      - php5-gd
      - php5-mcrypt
      - php5-cli
      - unzip
      - wget

/var/www/ajaxplorer/:
  file.directory:
    - makedirs: True
    - user: www-data
    - group: www-data
    - mode: 700
    - require:
      - file: /var/www/

install_ajaxplorer:
  cmd.run:
    - name: 'wget {{ pillar.get('ajaxplorer', {})['download_url'] }} -O ajaxplorer.zip && unzip ajaxplorer.zip && rm ajaxplorer.zip && mv ./ajaxplorer*/* ./ajaxplorer*/.[^.]* . && chown -R www-data:www-data . && chmod -R ugo-w .  && chmod -R ugo+w data/'
    - unless: "test -f index.php"
    - cwd: /var/www/ajaxplorer
    - require:
      - pkg: nginx
      - pkg: install_required_packages
      - file: /var/www/ajaxplorer/

/etc/nginx/sites-available/locations/ajaxplorer:
  file.managed:
    - source: salt://ajaxplorer/location
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: nginx
      - file: /etc/nginx/sites-available/locations/
      - cmd: install_ajaxplorer
    - watch_in:
      - service: nginx

/var/www/ajaxplorer/conf/bootstrap_conf.php:
  file.managed:
    - source: salt://ajaxplorer/bootstrap_conf.php
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 644
    - require:
      - cmd: install_ajaxplorer

