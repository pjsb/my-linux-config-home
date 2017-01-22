#!/bin/bash
sshfs -o allow_other \
      -o kernel_cache \
      -o auto_cache \
      -o reconnect \
      -o compression=yes \
      -o cache_timeout=600 \
      -o ServerAliveInterval=15 \
      peters@pazuzu.attensity.zz:/cygdrive/f/Workspace.new \
      /mnt/work
