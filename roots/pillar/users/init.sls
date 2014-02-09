users:
  delete_users:
    - test
  add_users:
    someuser:
      home: /home/someuser
      password: test
      publickey: salt://../pillar/users/somekey.pub
      shell: /bin/sh
      samba: True
      samba_guest_readonly: False
      web: True  
      ftp: True
      sudo: True
      torrents: False
      mediashare: False
      avscan: True
      backups: True
      rsync:
        enabled: False
        auth:
    public:
      home: /home/public
      password:
      publickey:
      shell: /bin/false
      samba: True
      samba_guest_readonly: True
      web: True
      ftp: True
      sudo: False
      torrents: True
      mediashare: True
      avscan: True
      backups: True
      rsync: 
        enabled: True
        auth:
          public: publictest
