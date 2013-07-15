users:
  delete_users:
    - test 
  add_users:
    bolshevik:
      home: /home/bolshevik
      password: test
      publickey: salt://../pillar/users/somekey.pub
      shell: /bin/sh
      samba: True
      web: True  
      ftp: True
      sudo: True
      torrents: False
      mediashare: False
      avscan: True
      backups: True
    public:
      home: /home/public
      password:
      publickey:
      shell: /bin/false
      samba: True
      web: True
      ftp: True
      sudo: False
      torrents: True
      mediashare: True
      avscan: True
      backups: True
