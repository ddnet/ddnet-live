#!/bin/sh

pulseaudio --start
xrandr --fb 1280x720 # Adjust framebuffer
cp settings_ddnet.cfg ~/.teeworlds/ # Restore backup
cd ddnet && ./DDNet
