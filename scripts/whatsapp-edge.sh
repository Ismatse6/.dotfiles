#!/usr/bin/env bash
# Si ya hay una ventana con instance=web.whatsapp.com, la enfocamos…
if i3-msg -t get_tree | \
   grep -q '"instance":"web.whatsapp.com"'; then
    i3-msg '[instance="web\\.whatsapp\\.com"] focus'
# …si no, la lanzamos como PWA aislada
else
    microsoft-edge --new-window \
      --app=https://web.whatsapp.com \
      --class="Microsoft-edge" &
fi

