#!/usr/bin/env python3
#
# A simple python3 utility for fetching current mpris player info.
# 
# Dependencies: python(3)-dbus
#
# Usage: mpris.py <player>
# ! make sure your player has mpris2 supported

import sys
import dbus

bus_base    = 'org.mpris.MediaPlayer2'
interface   = '/org/mpris/MediaPlayer2'
info_method = 'org.freedesktop.DBus.Properties'
player_path = 'org.mpris.MediaPlayer2.Player'

if __name__ == '__main__':
    try:
        session = dbus.SessionBus()
        obj     = session.get_object(bus_base + '.' + sys.argv[1], interface)
        prop    = dbus.Interface(obj, info_method)
        status  = prop.Get(player_path, 'PlaybackStatus')
        print("state: %s" % status)
        if status != 'Stopped':
            meta  = prop.Get(player_path, 'Metadata')
            print("artist: %s" % meta['xesam:artist'][0])
            print("title: %s" % meta['xesam:title'])
            print("album: %s" % meta['xesam:album'])
            if meta['mpris:artUrl'] is not None:
                print("cover: %s" % (meta['mpris:artUrl']))
    except Exception as err:
        print(err)
        exit(1)
    finally:
        session.close()
