#! /usr/bin/env python

import sys

commands = ["1: track [Display now playing]","2: play [Toggle pause]","3: next [Skip track]","4: previous [Previous Track]", "5: who are you [Displays user logged in]", "6: Launch [Launch an Application]"]

print "Here are the machine commands:\n"

for index in range(len(commands)):
	print commands[index]
sys.exit

