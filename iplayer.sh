#!/usr/bin/env python

from subprocess import Popen, PIPE, call

zenity = Popen(['zenity',
 '--entry',
 '--text',
 'URL (e.g. http://www.bbc.co.uk/iplayer/episode/b000k0n/The_Archers/):',
 '--entry-text',
 '',
 '--title=Simon\'s iplayer downloader',
 '--window-icon=/usr/share/icons/hicolor/scalable/apps/gnome-sound-properties.svg',
 '--width=400'], stdout=PIPE)

url = zenity.communicate()[0].split("/")

if 'episode' in url:
    pid = url[url.index('episode') + 1]
elif 'programmes' in url:
    pid = url[url.index('programmes') + 1]


#call("gnome-terminal --hide-menubar -x get_iplayer --modes=flashaachigh,flashaac,flashaacstd,flashaacstd1,flashaudio,flashhigh,flashstd,flashnormal --force --output ~/Music --pid " + pid + " --command 'ffmpeg -ab 192k -i <filename> `echo <filename> | sed s/aac/mp3/` && rm <filename>'", shell=True)
call("gnome-terminal --hide-menubar -x get_iplayer --modes=flashaachigh,flashaac,flashaacstd,flashaacstd1,flashaudio,flashhigh,flashstd,flashnormal,flashaaclow --force --output ~/Music --pid " + pid, shell=True)
#Removed conversion to mp3
