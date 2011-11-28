#! /usr/bin/env python

import dbus
import dbus.mainloop.glib
import glib
import sys
import time
import os

#Script is called via uid 0 (root) so need to drop privs as its not root running rhythmbox.
os.setgid(1000)
os.setuid(1000)

paused = False
dbus.mainloop.glib.DBusGMainLoop (set_as_default = True)

bus = dbus.SessionBus ()

proxy = bus.get_object ("org.gnome.Rhythmbox", "/org/gnome/Rhythmbox/Player")
player = dbus.Interface (proxy, "org.gnome.Rhythmbox.Player")
proxy = bus.get_object ("org.gnome.Rhythmbox", "/org/gnome/Rhythmbox/Shell")
shell = dbus.Interface (proxy, "org.gnome.Rhythmbox.Shell")
try:
	if player.getPlaying():
		paused = True
		player.playPause(True)
		print "Music paused"
	else:
		paused == False
		player.playPause(False)
		print "Music unpaused..."
		song = shell.getSongProperties (player.getPlayingUri())
		print "Now Playing: {0}".format (song["title"])
		print "By: {0}".format (song["artist"])
except:
	print "Client is not running or is unavailable."
sys.exit

