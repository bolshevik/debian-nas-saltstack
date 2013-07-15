samba-common-bin:
  pkg.installed

samba:
  pkg:
    - installed
    - require:
      - pkg: samba-common-bin
  service:
    - running
    - watch:
      - file: /etc/samba/smb.conf
