acpid:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: /etc/acpi/powerbtn.sh
      - file: /etc/acpi/events/powerbtn

/etc/acpi:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - require:
      - pkg: acpid

/etc/acpi/events:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - require:
      - pkg: acpid

/etc/acpi/powerbtn.sh:
  file.managed:
    - user: root
    - group: root
    - mode: 744
    - source: salt://acpid/acpi/powerbtn.sh
    - template: jinja
    - require:
      - pkg: samba
      - file: /etc/acpi

/etc/acpi/events/powerbtn:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://acpid/acpi/events/powerbtn
    - template: jinja
    - require:
      - pkg: samba
      - file: /etc/acpi/events

