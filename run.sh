#!/bin/sh
renice -n -10 $$
dtach -A ddnet.dtach -e '^q' xinit ./ddnet.sh
sleep 3
./stream.sh &
./control >> control.log &
