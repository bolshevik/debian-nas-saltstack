# General

This is a set of [saltstack](http://saltstack.com/) recipes to set up and configure the following services on your debian insallation:

* usbautomount
* acpid (custom script for cubieboard based installation)
* logrotate
* users
* nginx shares
* samba shares
* transmission
* proftpd
* mediacenter (minidlna)
* ajaxplorer
* clamav
* pxe boot server
* backups via duplicity
* iscsi target via tgtd

Additionally one may use [salty-vagrant](https://github.com/saltstack/salty-vagrant) to deploy and test the configuration in virtual machine.

# Requirements
* Debian 7.0 Wheezy
* Saltstack 0.15

# Install packages
## ARM
Install these packages:

- python
- python-pip
- python-zmq
- python-crypto
- python-m2crypto

Install salt:

    $pip install salt

Copy minion config to _/etc/salt/minion_.

## i386
For wheezy, the following line is needed in either _/etc/apt/sources.list_ or a file in _/etc/apt/sources.list.d_:

    deb http://debian.saltstack.com/debian wheezy-saltstack main


Then run

    $apt-get update
    $apt-get install salt-minion
    
# Customize Salt states
Edit pillar data to fit your needs.

# Configure Salt

- Put minion configuration under _/etc/salt/minion_
- Copy _roots/_ folder context under _/srv/_

# Run
salt-call state.highstate

# Known issues

- Old version of forked-daapd is installed.
- Ajaxplorer sets default password admin:admin and all the users and repositories are managed via
it. It's impossible to automatically configure it.
- ietd iscsi target requires customly compiled kernel and kernel headers.

# Links
* [Minimal Debian server by romanrm](http://romanrm.ru/en/a10/debian)
* [SaltStack standalone minion](http://salt.readthedocs.org/en/latest/topics/tutorials/standalone_minion.html)
* [MultiarchHOWTO](http://wiki.debian.org/Multiarch/HOWTO)
* [Creating a Debian Wheezy Base Box for Vagrant](https://mikegriffin.ie/blog/20130418-creating-a-debian-wheezy-base-box-for-vagrant/)

