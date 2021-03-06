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

call("xfce4-terminal -x get_iplayer --force --output ~/Recordings --file-prefix '<title> - <firstbcast>' --pid " + pid, shell=True)
