#!/bin/bash

name=$(zenity  --list --editable --window-icon="/usr/share/icons/hicolor/scalable/apps/gnome-sound-properties.svg" --title="Simon's MP3 recorder script" --width=400 --height=400 --text "Filename main part (press cancel for none):" --column "Stored names" \
"clive james" \
"isihac" \
"nq" \
"Museum of Everything" \
"Now show" \
"round the horne" \
)

date=$(date +%d.%m.%y)

suffix=$(zenity --entry --text "Filename suffix (press cancel for none):" --entry-text "$date" --title="Simon's MP3 recorder script" --window-icon="/usr/share/icons/hicolor/scalable/apps/gnome-sound-properties.svg" --width=400)

name=$name" "$suffix

if [ "$name" = " " ] ; then
    exit 1;
fi

time=$(zenity --entry --text "Length in minutes:" --entry-text "30" --title="Simon's MP3 recorder script")

if [ -z "$time" ] ; then
    exit 1;
fi

time=$[$time * 60]

pause=$(echo 'scale = 2; '$time' / 100' | bc)

(for a in `seq 0 99` ; do
	echo $a;
	sleep $pause;
done | zenity --progress --text="Recording $name.mp3" --title="Simon's MP3 recorder script" --width=600 --window-icon="/usr/share/icons/hicolor/scalable/apps/gnome-sound-properties.svg" --auto-close --auto-kill) &

#brec -w -b 16 -s 44100 -t $[time]
(arecord --nonblock -t wav -f cd -d $[time] | lame --preset standard - "/home/geoff/Music/$name.mp3" ) &

# Makes everything stop when press cancel
RUNNING=0
while [ $RUNNING == 0 ]
do
 if [ -z "$(pidof zenity)" ] ; then
    pkill brec
    pkill lame
    RUNNING=1
fi
done
