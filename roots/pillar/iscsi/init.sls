iscsi:
  target: tgtd
  target_prefix: iqn.2013-07.nas
  devices:
    test:
# Optional authentication, seem not to work with Windows initiator.
      incoming:
        #test: YourSecurePwd1
      outgoing:
        #test: YourSecurePwd2
      paths:
        /tmp/test.img:
          ietd_type: fileio
#          ietd_iomode: ro
