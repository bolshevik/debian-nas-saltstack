#!/bin/bash

case "$2" in
 PBTN)
  modifiedin=`echo $[$(date +%s)-$(stat --printf "%Y" /tmp/pbtn || echo "0")]`

  # If button click is within 10 seconds from the previous one - let's shutdown.
  if [ "$modifiedin" -lt "10" ]; then
    sleep 1
    echo "1" > /sys/devices/virtual/misc/sun4i-gpio/pin/ph10
    echo "0" > /sys/devices/virtual/misc/sun4i-gpio/pin/ph20
    shutdown -h now
    exit
  fi

  echo "0" > /sys/devices/virtual/misc/sun4i-gpio/pin/ph10
  echo "0" > /sys/devices/virtual/misc/sun4i-gpio/pin/ph20
  for mnt in /media/* ; do
    if [ -d "$mnt" ]; then
      if ! umount "$mnt"; then
        echo "1" > /sys/devices/virtual/misc/sun4i-gpio/pin/ph10
      fi
    fi
  done

  sleep 1
  touch /tmp/pbtn
  echo "0" > /sys/devices/virtual/misc/sun4i-gpio/pin/ph10
  echo "1" > /sys/devices/virtual/misc/sun4i-gpio/pin/ph20
 ;;
esac

