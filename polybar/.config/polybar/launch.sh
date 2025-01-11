#!/bin/sh

# kill all polybar instances
killall -q polybar
rm /tmp/polybarshow

# wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# launch bar
echo "---" | tee -a /tmp/polybar.log
polybar bar 2>&1 | tee -a /tmp/polybar.log &
disown
touch /tmp/polybarshow

echo "Bars launched..."
