syslinux-common:
  pkg.installed

dnsmasq:
  pkg:
    - installed
  service:
    - running

{{ pillar.get('pxe', {})['tftp_root'] }}/pxelinux.cfg/:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/etc/dnsmasq.d/pxe.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 600
    - source: salt://pxe/dnsmasq.conf
    - template: jinja
    - require:
      - pkg: dnsmasq
    - watch_in:
      - service: dnsmasq

/etc/dnsmasq.conf:
  file.append:
    - text: conf-dir=/etc/dnsmasq.d
    - watch_in:
      - service: dnsmasq
    - require:
      - pkg: dnsmasq

cp /usr/lib/syslinux/pxelinux.0 ./:
  cmd.run:
    - unless: "test -f pxelinux.0"
    - cwd: {{ pillar.get('pxe', {})['tftp_root'] }}
    - require:
      - pkg: syslinux-common
      - file: {{ pillar.get('pxe', {})['tftp_root'] }}/pxelinux.cfg/
