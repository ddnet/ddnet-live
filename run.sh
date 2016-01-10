#!/bin/sh
renice -n -10 $$
xinit ./ddnet.sh >> ddnet.log &
sleep 3
./stream.sh &
./control >> control.log &
