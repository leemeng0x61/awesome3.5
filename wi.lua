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
cpu_low     = theme.colors.green
cpu_mid     = theme.colors.magenta 
cpu_high    = theme.colors.red

fg_widget     = theme.colors.base1
bg_widget     = theme.colors.base3
fg_em         = theme.colors.base1
bg_em         = theme.colors.orange

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
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
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
vicious.cache(vicious.widgets.mem)

-- Ram used
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_ram)
memused = wibox.widget.textbox()
vicious.register(memused, vicious.widgets.mem,markup(bg_em,"$2MB $1%") .. markup(fg_em,"♻") .. markup(bg_em,"$5% $6M"), 5)


cputest = wibox.widget {
    {
        max_value     = 1,
        value         = 0.33,
        widget        = wibox.widget.progressbar,
    },
    forced_height = 100,
    forced_width  = 20,
    direction     = 'east',
    layout        = wibox.container.rotate,
}


-- {{{ FILESYSTEM
-- Cache
vicious.cache(vicious.widgets.fs)

-- Root used
--rootfsused = wibox.widget.textbox()
--vicious.register(rootfsused, vicious.widgets.fs,markup(fg_em,"FS:") .. markup(bg_em,"${/ used_gb}GB ${/ used_p}%"), 97)
---- }}}

-- {{{ DISK DIO
-- Cache
vicious.cache(vicious.widgets.dio)

-- Read and Write
dioicon = wibox.widget.imagebox()
dioicon:set_image(beautiful.widget_disk)
diowidget = wibox.widget.textbox()
vicious.register(diowidget, vicious.widgets.dio,markup("green","${sda write_kb}K") .. markup("orange","${sda read_kb}K"),1)
-- }}}

-- {{{ UPTIME
vicious.cache(vicious.widgets.uptime)

uptimewidget = wibox.widget.textbox()
vicious.register(uptimewidget, vicious.widgets.uptime, "♨$1-$2:$3", 60)

uptimewidget:buttons(awful.util.table.join(awful.button({ }, 1, 
function()
	local f = io.popen("uptime")
	p = f:read("*a")
	naughty.notify { text = markup(fg_em,p), timeout = 5, hover_timeout = 0.5 }
end)))
-- }}}

-- {{{ MPD
mpdicon = wibox.widget.imagebox()
mpdicon:set_image(beautiful.widget_mpd)

mpdwidget = wibox.widget.textbox()
vicious.register(mpdwidget, vicious.widgets.mpd,
function(widget, args)
	if args["{state}"] == "Stop" then
		mpdicon:set_image(beautiful.widget_mpd)
		return markup(bg_em,"")
	elseif args["{state}"] == "Pause" then
		mpdicon:set_image(beautiful.widget_mpd)
		return markup(bg_em,"") .. args["{Artist}"]..'∙'.. args["{Title}"]
	else
		mpdicon:set_image(beautiful.widget_mpdplay)
		return markup(bg_em,"") .. args["{Artist}"]..'∙'.. args["{Title}"]
	end
end, 3)

mpdwidget:buttons(awful.util.table.join(awful.button({ }, 1, 
function()
	local f = io.popen("mpc")
	p = f:read("*a")
	naughty.notify { text = markup(fg_em,p), timeout = 5, hover_timeout = 0.5 }
end)))
mpdicon:buttons(mpdwidget:buttons())
-- }}}

-- {{{ NETWORK
vicious.cache(vicious.widgets.net)

neticon = wibox.widget.imagebox()
neticon:set_image(beautiful.widget_net)
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net, markup("green","${wlp3s0 down_kb}K")..markup("orange","${wlp3s0 up_kb}K"), 1)
-- {{{ CLOCK
mytextclock = awful.widget.textclock("%a %R",1)
-- {{{ WEATHER
weather = wibox.widget.textbox()
vicious.register(weather, vicious.widgets.weather,"${weather} ${tempc}°C",1800, "ZUUU")
weather:buttons(awful.util.table.join(awful.button({ }, 1, function()
	vicious.force({ weather, })
end)))
-- }}}

-- {{{ PACMAN
pacicon = wibox.widget.imagebox()
pacicon:set_image(beautiful.widget_pac)

pacwidget = wibox.widget.textbox()
vicious.register(pacwidget, vicious.widgets.pkg, function(widget, args)
  if args[1] > 0 then
    pacicon:set_image(beautiful.widget_pacnew)
  else
    pacicon:set_image(beautiful.widget_pac)
  end

  return args[1]
end, 1801, "Arch S") -- Arch S for ignorepkg

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
vicious.cache(vicious.widgets.volume)

volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)

volpct = wibox.widget.textbox()
vicious.register(volpct, vicious.widgets.volume, "$1%", nil, "Master")

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
local bat_state  = ""
local bat_charge = 0
local bat_time   = 0
local blink      = true

baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_batfull)

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
