#!/bin/sh

find /sys/class/net/ -maxdepth 1 -type l | while read line; do
  interface=$(basename "$line")
  for feature in rx tx sg tso ufo gso gro lro ntuple rxhash; do
    ethtool -K "$interface" "$feature" off > /dev/null 2>&1
  done
done
