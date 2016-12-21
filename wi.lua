--[[=============================================================================
#     FileName: wi.lua
#         Desc:  
#       Author: Lee Meng
#        Email: leaveboy@gmail.com
#     HomePage: http://leaveboy.is-programmer.com/
#      Version: 0.0.1
#   LastChange: 2013-01-07 17:21:57
#      History:
=============================================================================]]
local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local vicious   = require("vicious")
local naughty   = require("naughty")
--local cal       = require("utils.cal")
local lain      = require("lain")
markup      = lain.util.markup

height      = 12
graphwidth  = 50
graphheight = height
pctwidth    = 40
cpu_low     = "#00ff00"
cpu_mid     = "#ffff00"
cpu_high    = "#ff0000"

fg_widget     = "#908884"
bg_widget     = "#2a2a2a"
bg_em         = "#ffcc00"
fg_em         = "#E47833"
bg_tooltip    = "#d6d6d6"
fg_tooltip    = "#1a1a1a"
border_tooltip= "#444444"

-- {{{ SPACERS
space = wibox.widget.textbox()
space:set_text(" ")

comma = wibox.widget.textbox()
comma:set_markup(",")

pipe = wibox.widget.textbox()
pipe:set_markup(markup(fg_widget,'┋'))

tab = wibox.widget.textbox()
tab:set_text("         ")

volspace = wibox.widget.textbox()
volspace:set_text("")
-- }}}

-- {{{ PROCESSOR
-- Cache
vicious.cache(vicious.widgets.cpu)
vicious.cache(vicious.widgets.cpuinf)

-- Core temperature 
tzswidget = wibox.widget.textbox()
vicious.register(tzswidget, vicious.widgets.thermal, "$1°C", 19, "thermal_zone0")

-- Core 2 %
--cpupct2 = wibox.widget.textbox()
--cpupct2.fit = function(box,w,h)
  --local w,h = wibox.widget.textbox.fit(box,w,h) return math.max(pctwidth,w),h
--vicious.register(cpupct2, vicious.widgets.cpu, "$4%", 2)
--end

-- Core 0 graph
cpugraph0 = awful.widget.graph()
cpugraph0:set_width(graphwidth):set_height(graphheight)
cpugraph0:set_border_color(nil)
cpugraph0:set_border_color(fg_widget)
cpugraph0:set_background_color(bg_widget)
cpugraph0:set_color({
  type = "linear",
  from = { 0, graphheight },
  to = { 0, 0 },
  stops = {
    { 0, cpu_low },
    { 0.50, cpu_mid },
    { 1, cpu_high }
  }})
vicious.register(cpugraph0, vicious.widgets.cpu, "$1")

-- Core 1 graph
cpugraph1 = awful.widget.graph()
cpugraph1:set_width(graphwidth):set_height(graphheight)
cpugraph1:set_border_color(nil)
cpugraph1:set_border_color(fg_widget)
cpugraph1:set_background_color(bg_widget)
cpugraph1:set_color({
  type = "linear",
  from = { 0, graphheight },
  to = { 0, 0 },
  stops = {
    { 0, cpu_low },
    { 0.50, cpu_mid },
    { 1, cpu_high }
  }})
vicious.register(cpugraph1, vicious.widgets.cpu, "$2")

-- Core 2 graph
cpugraph2 = awful.widget.graph()
cpugraph2:set_width(graphwidth):set_height(graphheight)
cpugraph2:set_border_color(nil)
cpugraph2:set_border_color(fg_widget)
cpugraph2:set_background_color(bg_widget)
cpugraph2:set_color({
  type = "linear",
  from = { 0, graphheight },
  to = { 0, 0 },
  stops = {
    { 0, cpu_low },
    { 0.50, cpu_mid },
    { 1, cpu_high }
  }})
vicious.register(cpugraph2, vicious.widgets.cpu, "$3")

-- Core 3 graph
cpugraph3 = awful.widget.graph()
cpugraph3:set_width(graphwidth):set_height(graphheight)
cpugraph3:set_border_color(nil)
cpugraph3:set_border_color(fg_widget)
cpugraph3:set_background_color(bg_widget)
cpugraph3:set_color({
  type = "linear",
  from = { 0, graphheight },
  to = { 0, 0 },
  stops = {
    { 0, cpu_low },
    { 0.50, cpu_mid },
    { 1, cpu_high }
  }})
vicious.register(cpugraph3, vicious.widgets.cpu, "$4")
-- }}}

-- {{{ MEMORY
-- Cache
vicious.cache(vicious.widgets.mem)

-- Ram used
memused = wibox.widget.textbox()
vicious.register(memused, vicious.widgets.mem,
  markup(fg_em,"▒") .. markup(bg_em,"$2MB $1%") .. markup(fg_em,"♻") .. markup(bg_em,"$5% $6M"), 5)

-- Ram bar
membar = awful.widget.progressbar()
membar:set_vertical(false):set_width(graphwidth):set_height(graphheight)
membar:set_ticks(false):set_ticks_size(2)
membar:set_border_color(nil)
membar:set_background_color(bg_widget)
membar:set_color({
  type = "linear",
  from = { 0, 0 },
  to = { graphwidth, 0 },
  stops = {
    { 0, cpu_low },
    { 0.50, cpu_mid },
    { 1, cpu_high }
  }})
vicious.register(membar, vicious.widgets.mem, "$1", 13)

-- {{{ FILESYSTEM
-- Cache
vicious.cache(vicious.widgets.fs)

-- Root used
rootfsused = wibox.widget.textbox()
vicious.register(rootfsused, vicious.widgets.fs,markup(fg_em,"FS:") .. markup(bg_em,"${/ used_gb}GB ${/ used_p}%"), 97)
-- }}}

-- {{{ DISK DIO
-- Cache
vicious.cache(vicious.widgets.dio)

-- Read and Write
diowidget = wibox.widget.textbox()
vicious.register(diowidget, vicious.widgets.dio, markup(fg_em,"◘") ..
  markup("green","↓${sda write_kb}K") .. markup("orange","↑${sda read_kb}K"),1)
-- }}}

-- {{{ UPTIME
-- Cache
vicious.cache(vicious.widgets.uptime)

-- Read and Write
uptimewidget = wibox.widget.textbox()
vicious.register(uptimewidget, vicious.widgets.uptime, "♨$1-$2:$3", 60)

-- Buttons
uptimewidget:buttons(awful.util.table.join(awful.button({ }, 1, 
function()
	local f = io.popen("uptime")
	p = f:read("*a")
	naughty.notify { text = markup(fg_em,p), timeout = 5, hover_timeout = 0.5 }
end)))
-- }}}

-- {{{ Pianobar
-- Icon
mpdicon = wibox.widget.imagebox()
mpdicon:set_image(beautiful.widget_mpd)

-- Song info
mpdwidget = wibox.widget.textbox()
vicious.register(mpdwidget, vicious.widgets.mpd,
function(widget, args)
	local ret_str = markup(fg_em,"♫")
	if args["{state}"] == "Stop" then
		mpdicon:set_image(beautiful.widget_mpd)
		return ret_str .. markup(bg_em,"■")
	elseif args["{state}"] == "Pause" then
		mpdicon:set_image(beautiful.widget_pause)
		return ret_str .. markup(bg_em,"〓") .. args["{Artist}"]..'∙'.. args["{Title}"]
	else
		mpdicon:set_image(beautiful.widget_play)
		return ret_str .. markup(bg_em,"▶") .. args["{Artist}"]..'∙'.. args["{Title}"]
	end
end, 3)

-- Buttons
mpdwidget:buttons(awful.util.table.join(awful.button({ }, 1, 
function()
	local f = io.popen("mpc")
	p = f:read("*a")
	naughty.notify { text = markup(fg_em,p), timeout = 5, hover_timeout = 0.5 }
end)))
mpdicon:buttons(mpdwidget:buttons())
-- }}}

-- {{{ NETWORK
-- Cache
vicious.cache(vicious.widgets.net)

-- UpSpeed/TX and DownSpeed/RX 
wifiwidget = wibox.widget.textbox()
vicious.register(wifiwidget, vicious.widgets.net, markup(fg_em,"Ψ") ..
  markup("green","↓${wlp3s0 down_kb}K") ..
  markup("orange","↑${wlp3s0 up_kb}K"), 1)

-- Up graph
upgraph = awful.widget.graph()
upgraph:set_width(graphwidth):set_height(graphheight)
upgraph:set_border_color(nil)
upgraph:set_background_color(bg_widget)
upgraph:set_color({
  type = "linear",
  from = { 0, graphheight },
  to = { 0, 0 },
  stops = {
    { 0, cpu_low },
    { 0.50, cpu_mid },
    { 1, cpu_high }
  }})
vicious.register(upgraph, vicious.widgets.net, "${wlp3s0 up_kb}")

-- Down graph
downgraph = awful.widget.graph()
downgraph:set_width(graphwidth):set_height(graphheight)
downgraph:set_border_color(nil)
downgraph:set_background_color(bg_widget)
downgraph:set_color({
  type = "linear",
  from = { 0, graphheight },
  to = { 0, 0 },
  stops = {
    { 0, cpu_low },
    { 0.50, cpu_mid },
    { 1, cpu_high }
  }})
vicious.register(downgraph, vicious.widgets.net, "${wlp3s0 down_kb}")

-- {{{ CLOCK
mytextclock = awful.widget.textclock("%a %R",1)
--cal.register(mytextclock," [%s]")
--[[
   [clock_widget = wibox.widget.textbox()
   [vicious.register(clock_widget, vicious.widgets.date, "%R", 1)
   [
   [-- Buttons
   [clock_widget:buttons(awful.util.table.join(awful.button({ }, 1, 
   [function()
   [    local f = io.popen("cal -m")
   [    p = f:read("*a")
   [    naughty.notify { text = markup(fg_em,p), timeout = 5, hover_timeout = 0.5 }
   [end)))
   ]]
-- }}}

-- {{{ WEATHER
weather = wibox.widget.textbox()
vicious.register(weather, vicious.widgets.weather,"${sky} ${tempc}°C",1800, "ZUUU")
weather:buttons(awful.util.table.join(awful.button({ }, 1, function()
	vicious.force({ weather, })
	--naughty.notify { text = 
	--markup(fg_em,"City :") ..markup(bg_em," ${city}\n")..
	--markup(fg_em,"Sky  :") ..markup(bg_em," ${sky}\n")..
	--markup(fg_em,"Temp :") ..markup(bg_em," ${tempc}\n")..
	--markup(fg_em,"Wind :") ..markup(bg_em," ${wind}\n")..
	--markup(fg_em,"Humid :") ..markup(bg_em," ${humid}\n")..
	--markup(fg_em,"Press:") ..markup(bg_em," ${press}")
	--, timeout = 5, hover_timeout = 0.5 }
end)))
-- }}}

-- {{{ PACMAN
-- Icon
pacicon = wibox.widget.imagebox()
pacicon:set_image(beautiful.widget_pac)

-- Upgrades
pacwidget = wibox.widget.textbox()
vicious.register(pacwidget, vicious.widgets.pkg, function(widget, args)
  if args[1] > 0 then
    pacicon:set_image(beautiful.widget_pacnew)
  else
    pacicon:set_image(beautiful.widget_pac)
  end

  return args[1]
end, 1801, "Arch S") -- Arch S for ignorepkg

-- Buttons
function popup_pac()
  local pac_updates = ""
  local f = io.popen("pacman -Sup --dbpath /tmp/pacsync")
  if f then
    pac_updates = f:read("*a"):match(".*/(.*)-.*\n$")
  end
  f:close()

  if not pac_updates then
    pac_updates = "System is up to date"
  end

	naughty.notify { text = markup(fg_em,pac_updates), timeout = 5, hover_timeout = 0.5 }
end
pacwidget:buttons(awful.util.table.join(awful.button({ }, 1, popup_pac)))
pacicon:buttons(pacwidget:buttons())
-- }}}

-- {{{ VOLUME
-- Cache
vicious.cache(vicious.widgets.volume)

-- Icon
volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)

-- Volume %
volpct = wibox.widget.textbox()
vicious.register(volpct, vicious.widgets.volume, "$1%", nil, "Master")

-- Buttons
volicon:buttons(awful.util.table.join(
  awful.button({ }, 1,
    function() awful.util.spawn_with_shell("amixer sset Master toggle") end),
  awful.button({ }, 4,
    function() awful.util.spawn_with_shell("amixer sset Master,0 5%+") end),
  awful.button({ }, 5,
    function() awful.util.spawn_with_shell("amixer sset Master,0 5%-") end)
))
volpct:buttons(volicon:buttons())
volspace:buttons(volicon:buttons())
-- }}}

-- {{{ BATTERY
-- Battery attributes
local bat_state  = ""
local bat_charge = 0
local bat_time   = 0
local blink      = true

-- Icon
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_batfull)

-- Charge %
batpct = wibox.widget.textbox()
vicious.register(batpct, vicious.widgets.bat, function(widget, args)
  bat_state  = args[1]
  bat_charge = args[2]
  bat_time   = args[3]

  if args[1] == "−" then
    if bat_charge > 90 then
      baticon:set_image(beautiful.widget_batfull)
    elseif bat_charge > 30 then
      baticon:set_image(beautiful.widget_batmed)
    elseif bat_charge > 10 then
      baticon:set_image(beautiful.widget_batlow)
    elseif bat_charge > 3 then
      baticon:set_image(beautiful.widget_batempty)
			naughty.notify { text = markup(fg_em,"Charge :")..("Less 10%\n") .. markup(fg_em,"State  :")..("Hibernate at 3%"),
			timeout = 2, hover_timeout = 0.5 }
		else
			awful.util.spawn_with_shell("pm-hibernate")
    end
  else
    baticon:set_image(beautiful.widget_ac)
    if args[1] == "+" then
      blink = not blink
      if blink then
        baticon:set_image(beautiful.widget_acblink)
      end
    end
  end

  return args[2] .. "%"
end, nil, "BAT0")

-- Buttons
function popup_bat()
  local state = ""
  if bat_state == "↯" then
    state = "Full"
  elseif bat_state == "↯" then
    state = "Charged"
  elseif bat_state == "+" then
    state = "Charging"
  elseif bat_state == "−" then
    state = "Discharging"
  elseif bat_state == "⌁" then
    state = "Not charging"
  else
    state = "Unknown"
  end

  naughty.notify { text = markup(fg_em,"Charge : ") .. bat_charge .. "%\n" .. markup(fg_em,"State  : ") .. state ..
    " (" .. bat_time .. ")", timeout = 5, hover_timeout = 10 }
end
batpct:buttons(awful.util.table.join(awful.button({ }, 1, popup_bat)))
baticon:buttons(batpct:buttons())
-- }}}
---------------------------------------------------------------------------------------------------------
--[[ new add 2016.12.17
-- Weather
weathericon = wibox.widget.imagebox(beautiful.widget_weather)
myweather = lain.widgets.weather({
    city_id = 1815286, -- placeholder
})

-- / fs
fsicon = wibox.widget.imagebox(beautiful.widget_fs)
fswidget = lain.widgets.fs({
    settings  = function()
        widget:set_markup(markup("#80d9d8", fs_now.used .. "% "))
    end
})

-- Mail IMAP check
mailicon = wibox.widget.imagebox()
mailicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn(mail) end)))
mailwidget = lain.widgets.imap({
    timeout  = 180,
    server   = "server",
    mail     = "mail",
    password = "keyring get mail",
    settings = function()
        if mailcount > 0 then
            mailicon:set_image(beautiful.widget_mail)
            widget:set_markup(markup("#cccccc", mailcount .. " "))
        else
            widget:set_text("")
            mailicon:set_image(nil)
        end
    end
})

-- CPU
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
cpuwidget = lain.widgets.cpu({
    settings = function()
        widget:set_markup(markup("#e33a6e", cpu_now.usage .. "% "))
    end
})

-- Coretemp
tempicon = wibox.widget.imagebox(beautiful.widget_temp)
tempwidget = lain.widgets.temp({
    settings = function()
        widget:set_markup(markup("#f1af5f", coretemp_now .. "°C "))
    end
})

-- Battery
baticon1 = wibox.widget.imagebox(beautiful.widget_batt)
batwidget = lain.widgets.bat({
    settings = function()
        perc = bat_now.perc .. "% "
        if bat_now.ac_status == 1 then
            perc = perc .. "Plug "
        end
        widget:set_text(perc)
    end
})

-- ALSA volume
volicon = wibox.widget.imagebox(beautiful.widget_vol)
volumewidget = lain.widgets.alsa({
    settings = function()
        if volume_now.status == "off" then
            volume_now.level = volume_now.level .. "M"
        end

        widget:set_markup(markup("#7493d2", volume_now.level .. "% "))
    end
})

-- Net
netdownicon = wibox.widget.imagebox(beautiful.widget_netdown)
--netdownicon.align = "middle"
netdowninfo = wibox.widget.textbox()
netupicon = wibox.widget.imagebox(beautiful.widget_netup)
--netupicon.align = "middle"
netupinfo = lain.widgets.net({
    settings = function()
        if iface ~= "network off" and
           string.match(myweather._layout.text, "N/A")
        then
            myweather.update()
        end

        widget:set_markup(markup("#e54c62", net_now.sent .. " "))
        netdowninfo:set_markup(markup("#87af5f", net_now.received .. " "))
    end
})

-- MEM
memicon = wibox.widget.imagebox(beautiful.widget_mem)
memwidget = lain.widgets.mem({
    settings = function()
        widget:set_markup(markup("#e0da37", mem_now.used .. "M "))
    end
})

--MPD
mpdicon = wibox.widget.imagebox()
mpdwidget1 = lain.widgets.mpd({
    settings = function()
        mpd_notification_preset = {
            text = string.format("%s [%s] - %s\n%s", mpd_now.artist,
                   mpd_now.album, mpd_now.date, mpd_now.title)
        }
        if mpd_now.state == "play" then
            artist = mpd_now.artist .. " > "
            title  = mpd_now.title .. " "
            mpdicon:set_image(beautiful.widget_note_on)
        elseif mpd_now.state == "pause" then
            artist = "mpd "
            title  = "paused "
        else
            artist = ""
            title  = ""
            mpdicon:set_image(nil)
        end
        widget:set_markup(markup("#e54c62", artist) .. markup("#b2b2b2", title))
    end
})
]]
