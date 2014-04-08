#!/bin/bash

name=$(zenity  --list --editable --window-icon="/usr/share/icons/hicolor/scalable/apps/gnome-sound-properties.svg" --title="Geoff's recorder" --width=400 --height=400 --text "Filename main part (press cancel for none):" --column "Stored names" \
"QUQ " \
"Reith Lectures 2011 Securing Freedom Aung San Suu Kyi " \
"David Attenborough Life Stories " \
"nq " \
"Now Show Extra " \
"Now show " \
"Titus Groan " \
"more or less summer 2011 " \
"isihac s55 " \
"Infinite Monkey Cage s4 " \
"isirta " \
"News Quiz Extra " \
"Questions Questions " \
"The Write Stuff  " \
"Genius " \
"Pratchett Nation  " \
"Stand-Up " \
)
date=$(date +%Y.%m.%d)

suffix=$(zenity --entry --text "Filename suffix (press cancel for none):" --entry-text "$date" --title="Geoff's recorder" --window-icon="/usr/share/icons/hicolor/scalable/apps/gnome-sound-properties.svg" --width=400)

if [ -z "$name" ] ; then
    name=$suffix
else
    name=$name" "$suffix
fi

if [ "$name" = " " ] ; then
    exit 1;
fi

if [ -e "/home/geoff/Music/$name.mp3" ]; then
   zenity --error --text="File already exists.";
   exit 1;
fi

time=$(zenity --entry --text "Length in minutes:" --entry-text "30" --title="Geoff's recorder")

if [ -z "$time" ] ; then
    exit 1;
fi

rectime=$[$time * 60]

rectimewithroom=$[$rectime + 1]

pause=$(echo 'scale = 2; '$rectimewithroom' / 100' | bc)

(for a in `seq 0 99` ; do
	echo $a;
	sleep $pause;
done | zenity --progress --text="Recording $name.mp3.  Recording time: $time minutes." --title="Geoff's recorder" --width=600 --window-icon="/usr/share/icons/hicolor/scalable/apps/gnome-sound-properties.svg" --auto-close) &

#brec -w -b 16 -s 44100 -t $[rectime]
# -f cd
(arecord --nonblock -t wav -f cd -d $[rectime] | lame -r --preset medium - "/home/geoff/Music/$name.mp3" ) &


#check whether it's working
sleep 2;
if [[ ! -s "/home/geoff/Music/$name.mp3" ]]; then
   zenity --error --text="Sorry, recording failed.";
   pkill arecord
   pkill lame
   exit 1
fi

echo $name

# Makes everything stop when press cancel
RUNNING=0
while [ $RUNNING == 0 ]
do
 if [ -z "$(pidof zenity)" ] ; then
    pkill arecord
    pkill lame
    RUNNING=1
fi
done
