--[[
                                             
     Powerarrow Darker Awesome WM config 2.0 
     github.com/copycat-killer               
                                             
--]]

-- {{{ Required libraries
local gears     = require("gears")
local awful     = require("awful")
awful.rules     = require("awful.rules")
require("awful.autofocus")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local drop      = require("scratchdrop")
local lain      = require("lain")
local yidoc     = require("yidoc")
-- }}}

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Autostart applications
function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
     findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

--run_once("urxvtd")
--run_once("unclutter")
run_once("xcompmgr")
run_once("fcitx -r &> /dev/null")
run_once("start-pulseaudio-x11")
run_once("xscreensaver -nosplash &")
-- }}}

-- {{{ Variable definitions
-- localization
os.setlocale(os.getenv("LANG"))

-- beautiful init
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/powerarrow-darker/theme.lua")

-- common
modkey     = "Mod4"
altkey     = "Mod1"
terminal   = "gnome-terminal" or "xfce4-terminal" or "xterm"
editor     = os.getenv("EDITOR") or "vim" or "nano"
editor_cmd = terminal .. " -e '" .. editor

-- user defined
browser    = "google-chrome-stable"
nemo       = "nemo --no-desktop"
--browser2   = "iron"
gui_editor = "gvim"
--graphics   = "gimp"
--mail       = terminal .. " -e mutt "
--iptraf     = terminal .. " -g 180x54-20+34 -e sudo iptraf-ng -i all "
--musicplr   = "urxvt -g 130x34-320+16 -e ncmpcpp "
musicplr  = terminal .. " --geometry=130x34+380+16 -t 'ncmpcpp' -e 'ncmpcpp'"

local layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
}
-- }}}

-- {{{ Tags
tags = {
   names = { "Code", "Web", "Trans", "Music", },
   layout = { layouts[2], layouts[1], layouts[2], layouts[1], }
}

for s = 1, screen.count() do
   tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.centered(beautiful.wallpaper, s)
    end
end
-- }}}

-- {{{ Menu
--require("freedesktop/freedesktop")
myawesomemenu = {
  { "manual", terminal .. " -e 'man awesome'" },
  { "edit config", editor_cmd .. " " .. awesome.conffile .. "'"},
  { "restart", awesome.restart },
  { "quit", awesome.quit },
  { "shutdown", "systemctl poweroff" },
  { "reboot", "systemctl reboot" },
}

mymainmenu = awful.menu({ items = {
  { "awesome",  myawesomemenu, beautiful.awesome_icon },
  { "terminal", terminal },
  { "browser",  browser},
  { "file",     nemo}, 
}})
mylauncher = awful.widget.launcher({ menu = mymainmenu })
-- }}}

-- {{{ Wibox
markup = lain.util.markup

-- Textclock
clockicon = wibox.widget.imagebox(beautiful.widget_clock)
mytextclock = awful.widget.textclock(" %a %d %b  %H:%M")

-- calendar
lain.widgets.calendar:attach(mytextclock, { font_size = 10 })

-- Mail IMAP check
mailicon = wibox.widget.imagebox(beautiful.widget_mail)
-- since I do not use mutt..
--mailicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn(mail) end)))
mailicon:buttons(awful.util.table.join(awful.button({ }, 1, function() awful.util.spawn(browser .. " https://mail.google.com") end)))
--mailwidget = wibox.widget.background(lain.widgets.imap({
--    timeout  = 180,
--    server   = "imap.gmail.com",
--    mail     = "iranaikimi@gmail.com",
--    password = "python2 -c \"import keyring; print keyring.get_password('system', 'gmail')\"",
--    settings = function()
--        if mailcount > 0 then
--            widget:set_text(" " .. mailcount .. " ")
--            mailicon:set_image(beautiful.widget_mail_on)
--        else
--            widget:set_text("")
--            mailicon:set_image(beautiful.widget_mail)
--        end
--    end
--}), "#313131")

-- Mpris
mprisicon = wibox.widget.imagebox(beautiful.widget_music)
--mprisicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(musicplr) end)))
mpriswidget = lain.widgets.contrib.mpris({
    player = "audacious",
    cover_size = 120,
    settings = function()
        if mpris_now.state == "Playing" then
            artist = " " .. mpris_now.artist .. " "
            title  = mpris_now.title  .. " "
            mprisicon:set_image(beautiful.widget_music_on)
        elseif mpris_now.state == "Paused" then
            artist = " " .. mpris_now.player .. " "
            title  = "paused "
        else
            artist = ""
            title  = ""
            mprisicon:set_image(beautiful.widget_music)
        end

        widget:set_markup(markup("#EA6F81", artist) .. title)
    end
})
mpriswidgetbg = wibox.widget.background(mpriswidget, "#313131")

-- MEM
memicon = wibox.widget.imagebox(beautiful.widget_mem)
memwidget = lain.widgets.mem({
    settings = function()
        widget:set_text(" " .. mem_now.used .. "MB ")
    end
})

-- CPU
cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
cpuwidget = wibox.widget.background(lain.widgets.cpu({
    settings = function()
        widget:set_text(" " .. cpu_now.usage .. "% ")
    end
}), "#313131")

-- Coretemp
tempicon = wibox.widget.imagebox(beautiful.widget_temp)
tempwidget = lain.widgets.temp({
    settings = function()
        widget:set_text(" " .. coretemp_now .. "°C ")
    end
})

-- / fs
fsicon = wibox.widget.imagebox(beautiful.widget_hdd)
fswidget = lain.widgets.fs({
    settings  = function()
        widget:set_text(" " .. fs_now.used .. "% ")
    end
})
fswidgetbg = wibox.widget.background(fswidget, "#313131")

-- Battery
baticon = wibox.widget.imagebox(beautiful.widget_battery)
batterywidget = wibox.widget.textbox()    
batterywidget:set_text("Battery")    
batterywidgettimer = timer({ timeout = 5 })    
batterywidgettimer:connect_signal("timeout",    
function()    
    fh = assert(io.popen("acpi | cut -d, -f 2 - | cut -d% -f 1", "r"))    
    remain = fh:read("*l")
    fh:close()    
    fh = assert(io.popen("acpi | cut -d, -f 1 - | cut -d' ' -f 3", "r"))    
    state = fh:read("*l")
    fh:close()    

    if tonumber(remain) <15 then 
        color = "#EA6F81"
        baticon:set_image(beautiful.widget_battery_empty)
        --hint
        warnNotice = naughty.notify({
            preset = { title = "Attention!! Battery Low !", timeout = 5 }
        })
    else 
        color = "#FFFFFF"
    end
    if state == "Charging" then
        color = "#53FF53"
        baticon:set_image(beautiful.widget_ac)
        --hint
        naughty.destroy(warnNotice)
    end
    batterywidget:set_markup(markup(color , remain .. "%") )
end    
)    
batterywidget:connect_signal('mouse::enter',
function()
    fh = assert(io.popen("acpi", "r"))    
    status = fh:read("*l")
    fh:close()    
    notification = naughty.notify({
        preset = { title = status, timeout = 2 },
        timeout = 0
    })
end
)
batterywidget:connect_signal('mouse::leave',
function()
    naughty.destroy(notification)
end
)
batterywidgettimer:start()

-- ALSA volume
volicon = wibox.widget.imagebox(beautiful.widget_vol)
volumewidget = lain.widgets.alsa({
    settings = function()
        if volume_now.status == "off" then
            volicon:set_image(beautiful.widget_vol_mute)
        elseif tonumber(volume_now.level) == 0 then
            volicon:set_image(beautiful.widget_vol_no)
        elseif tonumber(volume_now.level) <= 50 then
            volicon:set_image(beautiful.widget_vol_low)
        else
            volicon:set_image(beautiful.widget_vol)
        end

        widget:set_text(" " .. volume_now.level .. "% ")
    end
})

-- Net
--[[neticon = wibox.widget.imagebox(beautiful.widget_net)
neticon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(iptraf) end)))
netwidget = wibox.widget.background(lain.widgets.net({
    settings = function()
        widget:set_markup(markup("#7AC82E", " " .. net_now.received)
                          .. " " ..
                          markup("#46A8C3", " " .. net_now.sent .. " "))
    end
}), "#313131")
]]

-- Separators
spr = wibox.widget.textbox(' ')
arrl = wibox.widget.imagebox()
arrl:set_image(beautiful.arrl)
arrl_dl = wibox.widget.imagebox()
arrl_dl:set_image(beautiful.arrl_dl)
arrl_ld = wibox.widget.imagebox()
arrl_ld:set_image(beautiful.arrl_ld)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do

    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()

    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                            awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                            awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                            awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                            awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 18 })

    -- Widgets that are aligned to the upper left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(spr)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])
    left_layout:add(spr)

    -- Widgets that are aligned to the upper right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(spr)
    right_layout:add(arrl)
    right_layout:add(arrl_ld)
    right_layout:add(mprisicon)
    right_layout:add(mpriswidgetbg)
    right_layout:add(arrl_dl)
    right_layout:add(volicon)
    right_layout:add(volumewidget)
    right_layout:add(arrl_ld)
    --right_layout:add(mailicon)
    --right_layout:add(mailwidget)
    right_layout:add(arrl_dl)
    right_layout:add(memicon)
    right_layout:add(memwidget)
    right_layout:add(arrl_ld)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(arrl_dl)
    right_layout:add(baticon)
    right_layout:add(batterywidget)
    --right_layout:add(tempicon)
    --right_layout:add(tempwidget)
    right_layout:add(arrl_ld)
    right_layout:add(fsicon)
    right_layout:add(fswidgetbg)
    --right_layout:add(arrl_ld)
    --right_layout:add(arrl_ld)
    --right_layout:add(neticon)
    --right_layout:add(netwidget)
    right_layout:add(arrl_dl)
    right_layout:add(mytextclock)
    right_layout:add(spr)
    right_layout:add(arrl_ld)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)
    mywibox[s]:set_widget(layout)

end
-- }}}

-- {{{ Mouse Bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- Cheat sheet
    awful.key({ modkey }, "F1",
        function()
            yidoc.display(
              os.getenv("HOME") .. "/.config/awesome/awesome.cheat",
              {}
            )
            --local f = io.open(os.getenv("HOME") .. "/.config/awesome/cheatsheet.html")
            --ws = f:read("*all")
            --f:close()
            --naughty.notify({ text = ws, timeout = 10, hover_timeout = 0.1, font = 'Dejavu Sans Mono 10', opacity = 0.9})
        end),

    -- Take a screenshot
    -- https://github.com/copycat-killer/dots/blob/master/bin/screenshot
    awful.key({ altkey }, "p", function() os.execute("screenshot") end),

    -- lock (using xscreensaver)
    awful.key({ "Control", altkey }, "l", function () awful.util.spawn("xscreensaver-command -lock") end),

    -- Tag browsing
    awful.key({ modkey }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey }, "Escape", awful.tag.history.restore),

    -- Non-empty tag browsing
    --awful.key({ altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end),
    --awful.key({ altkey }, "Right", function () lain.util.tag_view_nonempty(1) end),

    -- Default client focus
    awful.key({ altkey }, "Tab",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ altkey, "Shift" }, "Tab",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),

    -- Show Menu
    awful.key({ modkey }, "w",
        function ()
            mymainmenu:show({ keygrabber = true })
        end),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
        mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
    end),

    -- Layout manipulation
    awful.key({ modkey, "Control" }, "Down",  function () awful.client.moveresize(0,   0,  0,  10) end),
    awful.key({ modkey, "Control" }, "Up",    function () awful.client.moveresize(0,   0,  0, -10) end),
    awful.key({ modkey, "Control" }, "Left",  function () awful.client.moveresize(0,   0,-10,   0) end),
    awful.key({ modkey, "Control" }, "Right", function () awful.client.moveresize(0,   0, 10,   0) end),
    awful.key({ modkey, "Shift"   }, "Down",  function () awful.client.moveresize(  0,  10,   0,   0) end),
    awful.key({ modkey, "Shift"   }, "Up",    function () awful.client.moveresize(  0, -10,   0,   0) end),
    awful.key({ modkey, "Shift"   }, "Left",  function () awful.client.moveresize(-10,   0,   0,   0) end),
    awful.key({ modkey, "Shift"   }, "Right", function () awful.client.moveresize( 10,   0,   0,   0) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),
    awful.key({ altkey, "Shift"   }, "l",      function () awful.tag.incmwfact( 0.05)     end),
    awful.key({ altkey, "Shift"   }, "h",      function () awful.tag.incmwfact(-0.05)     end),
    awful.key({ modkey, "Shift"   }, "l",      function () awful.tag.incnmaster(-1)       end),
    awful.key({ modkey, "Shift"   }, "h",      function () awful.tag.incnmaster( 1)       end),
    awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol( 1)          end),
    awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol(-1)          end),
    awful.key({ modkey,           }, "space",  function () awful.layout.inc(layouts,  1)  end),
    awful.key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(layouts, -1)  end),
    awful.key({ modkey, "Control" }, "n",      awful.client.restore),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r",      awesome.restart),
    awful.key({ modkey, "Shift"   }, "q",      awesome.quit),

    -- Dropdown terminal
    awful.key({        	          }, "F1",     function () drop(terminal, "bottom", "center", 0.6, 0.5) end),

    -- Widgets popups
    awful.key({ altkey,           }, "c",      function () lain.widgets.calendar:show(7) end),
    awful.key({ altkey,           }, "h",      function () fswidget.show(7) end),

    -- ALSA volume control
    awful.key({ altkey }, "Up",
        function ()
            awful.util.spawn("amixer -q set Master 2%+")
            volumewidget.update()
        end),
    awful.key({ altkey }, "Down",
        function ()
            awful.util.spawn("amixer -q set Master 2%-")
            volumewidget.update()
        end),
    awful.key({ altkey }, "m",
        function ()
            awful.util.spawn("amixer -q set Master playback toggle")
            volumewidget.update()
        end),
    awful.key({ altkey, "Control" }, "m",
        function ()
            awful.util.spawn("amixer -q set Master playback 100%")
            volumewidget.update()
        end),

    -- Mpris control
    awful.key({ altkey, "Control" }, "Up",
        function ()
            mpriswidget.ctrl("toggle")
            mpriswidget.update()
        end),
--    awful.key({ altkey, "Control" }, "Down",
--        function ()
--            mpriswidget.ctrl("stop")
--            mpriswidget.update()
--        end),
    awful.key({ altkey, "Control" }, "Left",
        function ()
            mpriswidget.ctrl("prev")
            mpriswidget.update()
        end),
    awful.key({ altkey, "Control" }, "Right",
        function ()
            mpriswidget.ctrl("next")
            mpriswidget.update()
        end),

    -- Copy to clipboard
    awful.key({ modkey }, "c", function () os.execute("xsel -p -o | xsel -i -b") end),

    -- User programs
    --awful.key({ modkey }, "q", function () awful.util.spawn(browser) end),
    --awful.key({ modkey }, "i", function () awful.util.spawn(browser2) end),
    --awful.key({ modkey }, "s", function () awful.util.spawn(gui_editor) end),
    --awful.key({ modkey }, "g", function () awful.util.spawn(graphics) end),

    -- Prompt
    awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end),
    awful.key({ altkey }, "F2", function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    awful.key({ modkey }, "n",
              function ()
                  awful.prompt.run({ prompt = "Create New Tag: " },
                  mypromptbox[mouse.screen].widget,
                  awful.tag.add, nil)
              end),
    awful.key({ modkey, "Shift" }, "n",
              function ()
                  awful.tag.delete()
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "d",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
end
-- Bind PrintScreen key to `scrot -s`
-- date +%y%m%d_%H%M%S
-- Dependency: scrot
globalkeys = awful.util.table.join(globalkeys,
    awful.key( {}, "Print",
        function()
            awful.util.spawn_with_shell("scrot ~/pics/screenshots/`date +%y%m%d_%H%M%S`.png",false)
        end
    )
)

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons,
	                   size_hints_honor = false } },

    { rule = { name = "ncmpcpp" },
          properties = { tag = tags[1][3]} },

    { rule = { class = "URxvt" },
          properties = { opacity = 0.95 } },

    { rule = { class = "Gnome-terminal" },
          properties = { opacity = 0.95 } },

    { rule = { class = "Firefox" }, 
          properties = { floating = true } },

    { rule = { class = "Google-chrome-stable" },
          properties = { floating = true } },

    { rule = { class = "Audacious"}, 
          properties = { floating = true } },

    { rule = { class = "MPlayer" },
          properties = { floating = true } },
}
-- }}}

-- {{{ Signals
-- signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- enable sloppy focus
--    c:connect_signal("mouse::enter", function(c)
--        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--            and awful.client.focus.filter(c) then
--            client.focus = c
--        end
--    end)

    if not startup and not c.size_hints.user_position
       and not c.size_hints.program_position then
        awful.placement.no_overlap(c)
        awful.placement.no_offscreen(c)
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- the title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c,{size=16}):set_widget(layout)
    end
end)

-- No border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized_horizontal == true and c.maximized_vertical == true then
            c.border_color = beautiful.border_normal
        else
            c.border_color = beautiful.border_focus
        end
    end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
        local clients = awful.client.visible(s)
        local layout  = awful.layout.getname(awful.layout.get(s))

        if #clients > 0 then -- Fine grained borders and floaters control
            for _, c in pairs(clients) do -- Floaters always have borders
                if awful.client.floating.get(c) or layout == "floating" then
                    c.border_width = beautiful.border_width

                -- No borders with only one visible client
                elseif #clients == 1 or layout == "max" then
                    clients[1].border_width = 0
                else
                    c.border_width = beautiful.border_width
                end
            end
        end
      end)
end
-- }}}
