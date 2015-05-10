samba-common-bin:
  pkg.installed

samba-vfs-modules:
  pkg.installed

samba:
  pkg:
    - installed
    - require:
      - pkg: samba-common-bin
      - pkg: samba-vfs-modules
  service:
    - name: smbd
    - running
    - watch:
      - file: /etc/samba/smb.conf
