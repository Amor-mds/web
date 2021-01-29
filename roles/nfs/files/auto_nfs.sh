#!/bin/bash
mkdir /wwwroot
echo "/wwwroot 192.168.6.0/24(rw,sync,no_root_squash)" >> /etc/exports
mount 192.168.6.8:/wwwroot /wwwroot
