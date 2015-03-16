
--[[
                                                  
     Licensed under GNU General Public License v2 
      * (c) 2014, lythesia <iranaikimi@gmail.com>  
                                                  
--]]

local helpers      = require("lain.helpers")
local async        = require("lain.asyncshell")

local escape_f     = require("awful.util").escape
local naughty      = require("naughty")
local wibox        = require("wibox")

local io           = { popen    = io.popen }
local os           = { clock    = os.clock,
                       execute  = os.execute,
                       getenv   = os.getenv }
local string       = { char     = string.char,
                       format   = string.format,
                       gmatch   = string.gmatch }
local tonumber     = tonumber

local setmetatable = setmetatable

-- Mpris info
local mpris = {}

local notification = nil
mpris_notification_preset = { title   = "Now playing", timeout = 6 }

local function hex2char(x)
    return string.char(tonumber(x, 16))
end

local function url2path(url)
    local esp,_ = url:gsub("%%(%x%x)", hex2char)
    local path,_ = esp:gsub("^file://", "", 1)
    return path
end

function mpris:hide()
    if notification ~= nil then
      naughty.destroy(notification)
      notification = nil
    end
end

function mpris:show(t_out)
    if helpers.get_map("current mpris track") ~= nil then
      mpris:hide()
      notification = naughty.notify({
        preset = mpris_notification_preset,
        icon   = "/tmp/mpriscover.png",
        timeout = t_out,
        replaces_id = mpris.id,
        screen = client.focus and client.focus.screen or 1
      })
      mpris.id = notification.id
    end
end

local function worker(args)
    local args        = args or {}
    local timeout     = args.timeout or 2
    local player      = args.player or "audacious"
    local cover_size  = args.cover_size or 100
    local default_art = args.default_art or ""
    local settings    = args.settings or function() end

    --local mprisinfo  = helpers.scripts_dir .. "mpris.py"
    --local mpriscover = helpers.scripts_dir .. "mpriscover"
    local mprisinfo  = "/home/six/.config/awesome/lain/scripts/mpris.py"
    local mpriscover  = "/home/six/.config/awesome/lain/scripts/mpriscover"

    mpris.widget = wibox.widget.textbox('')

    helpers.set_map("current mpris track", nil)

    function mpris.ctrl(action)
        local dbus_cmd = "gdbus call --session --dest org.mpris.MediaPlayer2.%s --object-path /org/mpris/MediaPlayer2 --method org.mpris.MediaPlayer2.Player.%s"
        if      action == "toggle" 
        then 
            os.execute(string.format(dbus_cmd, player, "PlayPause"))
        elseif  action == "stop"   
        then 
            os.execute(string.format(dbus_cmd, player, "Stop"))
        elseif  action == "next"   
        then 
            os.execute(string.format(dbus_cmd, player, "Next"))
            os.execute(string.format(dbus_cmd, player, "Play"))
        elseif  action == "prev"   
        then 
            os.execute(string.format(dbus_cmd, player, "Previous"))
            os.execute(string.format(dbus_cmd, player, "Play"))
        end
    end

    function mpris.update()
        async.request(string.format("%s %s", mprisinfo, player), function(f)
            mpris_now = {
                player = player,
                state  = "N/A",
                artist = "N/A",
                title  = "N/A",
                album  = "N/A",
                cover  = "N/A"
            }

            for line in f:lines() do
                for k,v in string.gmatch(line, "([%w]+):[%s](.*)$") do
                    if      k == "state"  then mpris_now.state  = v
                    elseif  k == "artist" then mpris_now.artist = escape_f(v)
                    elseif  k == "title"  then mpris_now.title  = escape_f(v)
                    elseif  k == "album"  then mpris_now.album  = escape_f(v)
                    elseif  k == "cover"  then mpris_now.cover  = url2path(v)
                    end
                end
            end

            mpris_notification_preset.text = string.format("%s (%s)\n%s\n", mpris_now.artist, mpris_now.album, mpris_now.title)
            widget = mpris.widget
            settings()

            if mpris_now.state == "Playing"
            then
                if mpris_now.title ~= helpers.get_map("current mpris track")
                then
                    helpers.set_map("current mpris track", mpris_now.title)

                    os.execute(string.format("%s %q %d %q", mpriscover, mpris_now.cover, cover_size, default_art))

                    mpris.id = naughty.notify({
                      preset = mpris_notification_preset,
                      icon   = "/tmp/mpriscover.png",
                      replaces_id = mpris.id,
                      screen = client.focus and client.focus.screen or 1
                    }).id
                end
            elseif mpris_now.state == "Paused" then mpris_now.artist = player
            else
                helpers.set_map("current mpris track", nil)
            end
        end)
    end

    helpers.newtimer("mpris", timeout, mpris.update)

    mpris.widget:connect_signal('mouse::enter', function () mpris:show(0) end)
    mpris.widget:connect_signal('mouse::leave', function () mpris:hide() end)

    return setmetatable(mpris, { __index = mpris.widget })
end

return setmetatable(mpris, { __call = function(_, ...) return worker(...) end })
