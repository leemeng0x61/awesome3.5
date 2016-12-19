--[[=============================================================================
#     FileName: rc.lua
#         Desc:  
#       Author: Lee Meng
#        Email: leaveboy@gmail.com
#     HomePage: http://leaveboy.is-programmer.com/
#      Version: 0.0.1
#   LastChange: 2013-01-08 22:27:14
#      History:
=============================================================================]]

local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local lain= require("lain")
--local menu = require("menu")
local scratch = require("scratch")
beautiful.init(awful.util.getdir("config") .. "/themes/dust/theme.lua")
local wi      = require("wi")

-- {{{ Error handling
-- Startup
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
      title = "Oops, there were errors during startup!",
      text = awesome.startup_errors })
end

-- Runtime
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
      if in_error then return end
      in_error = true

      naughty.notify({ preset = naughty.config.presets.critical,
          title = "Oops, an error happened!",
          text = err })
      in_error = false
    end)
end
-- }}}

-- {{{ Variables
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"
altkey = "Mod1"
-- }}}

-- {{{ Layouts
local layouts =
{
  awful.layout.suit.floating,
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.spiral,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier
}
-- }}}


-- {{{ Wallpaper
if beautiful.wallpaper then
  for s = 1, screen.count() do
    gears.wallpaper.maximized(beautiful.wallpaper, s, true)
  end
end
-- }}}

-- {{{ Tags
tags = {
  names  = { "term", "web", "develop", "mail", "im", 6, 7, "rss", "media" },
  layout = { layouts[3], layouts[1], layouts[1], layouts[5], layouts[1],
             layouts[7], layouts[7], layouts[6], layouts[7]
}}
for s = 1, screen.count() do
    tags[s] = awful.tag(tags.names, s, tags.layout)
    awful.tag.setproperty(tags[s][5], "mwfact", 0.13)
    awful.tag.setproperty(tags[s][6], "hide",   true)
    awful.tag.setproperty(tags[s][7], "hide",   true)
end
-- }}}


-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
	 { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu.new({ items = require("freedesktop").menu.build(),
                              theme = { height = 16, width = 130 }})
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

---- {{{ Clock
--mytextclock = awful.widget.textclock("%a %b %d %R")
---- }}}
-- Textclock
mytextclock = awful.widget.textclock("<span font='Tamsyn 2'> </span>%H:%M ")

-- Calendar
lain.widgets.calendar.attach(mytextclock)

-- {{{ Wiboxes
mywibox = {}
mygraphbox = {}
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
  awful.button({ }, 1, function(c)
      if c == client.focus then
        c.minimized = true
      else
        c.minimized = false
        if not c:isvisible() then
          awful.tag.viewonly(c:tags()[1])
        end
        client.focus = c
        c:raise()
      end
    end),
  awful.button({ }, 3, function()
      if instance then
        instance:hide()
        instance = nil
      else
        instance = awful.menu.clients({ width=250 })
      end
    end),
  awful.button({ }, 4, function()
      awful.client.focus.byidx(1)
      if client.focus then client.focus:raise() end
    end),
  awful.button({ }, 5, function()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
    end))

for s = 1, screen.count() do
  mypromptbox[s] = awful.widget.prompt()

  -- Layoutbox
  mylayoutbox[s] = awful.widget.layoutbox(s)
  mylayoutbox[s]:buttons(awful.util.table.join(
      awful.button({ }, 1, function() awful.layout.inc(layouts, 1) end),
      awful.button({ }, 3, function() awful.layout.inc(layouts, -1) end),
      awful.button({ }, 4, function() awful.layout.inc(layouts, 1) end),
      awful.button({ }, 5, function() awful.layout.inc(layouts, -1) end)))

  -- Taglist
  mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

  -- Tasklist
  mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

  -- Wibox
  mywibox[s] = awful.wibox({ position = "top", height = 16, screen = s })

  local left_wibox = wibox.layout.fixed.horizontal()
  left_wibox:add(mylauncher)
  left_wibox:add(mytaglist[s])
  left_wibox:add(mypromptbox[s])

  local right_wibox = wibox.layout.fixed.horizontal()
  right_wibox:add(weather)
  right_wibox:add(pipe)
  right_wibox:add(uptimewidget)
  right_wibox:add(pipe)
  right_wibox:add(pacicon)
  right_wibox:add(pacwidget)
  right_wibox:add(pipe)
  right_wibox:add(baticon)
  right_wibox:add(batpct)
  right_wibox:add(pipe)
  right_wibox:add(volicon)
  right_wibox:add(volpct)
  right_wibox:add(volspace)
  right_wibox:add(pipe)
  if s == 1 then right_wibox:add(wibox.widget.systray()) end
  right_wibox:add(mytextclock)
  --right_wibox:add(clock_widget)
  right_wibox:add(mylayoutbox[s])

  local wibox_layout = wibox.layout.align.horizontal()
  wibox_layout:set_left(left_wibox)
  wibox_layout:set_middle(mytasklist[s])
  wibox_layout:set_right(right_wibox)

  mywibox[s]:set_widget(wibox_layout)

  -- Graphbox
  mygraphbox[s] = awful.wibox({ position = "bottom", height = height, screen = s })

  local left_graphbox = wibox.layout.fixed.horizontal()
  left_graphbox:add(memused)
  --left_graphbox:add(membar)
  left_graphbox:add(pipe)
  --left_graphbox:add(rootfsused)
  left_graphbox:add(diowidget)
  left_graphbox:add(pipe)
  left_graphbox:add(wifiwidget)
  --left_graphbox:add(upgraph)
  left_graphbox:add(pipe)
	--left_graphbox:add(mpdicon)
    left_graphbox:add(mpdwidget)
  --left_graphbox:add(downgraph)

  local right_graphbox = wibox.layout.fixed.horizontal()
  right_graphbox:add(tzswidget)
  right_graphbox:add(cpugraph0)
  right_graphbox:add(cpugraph1)
  right_graphbox:add(cpugraph2)
  right_graphbox:add(cpugraph3)

  local graphbox_layout = wibox.layout.align.horizontal()
  graphbox_layout:set_left(left_graphbox)
  graphbox_layout:set_right(right_graphbox)

  mygraphbox[s]:set_widget(graphbox_layout)
end
-- }}}

-- {{{ Mouse Bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- {{{ Key bindings
globalkeys = awful.util.table.join(
  awful.key({ modkey, }, "Left", awful.tag.viewprev ),
  awful.key({ modkey, }, "Right", awful.tag.viewnext ),
  awful.key({ modkey, }, "Escape", awful.tag.history.restore),

	awful.key({ altkey, }, "r",
	function()
		awful.client.focus.byidx( 1)
		if client.focus then client.focus:raise() end
	end),
	awful.key({ modkey, "Shift" }, "Tab",
	function()
		awful.client.focus.byidx(-1)
		if client.focus then client.focus:raise() end
	end),

	--X230 keborad ctrl
    awful.key({ }, "XF86AudioLowerVolume",function()awful.util.spawn("amixer sset Master,0 5%-")end),
    awful.key({ }, "XF86AudioRaiseVolume",function()awful.util.spawn("amixer sset Master,0 5%+")end),
    awful.key({ }, "XF86AudioMute",       function()awful.util.spawn("amixer sset Master toggle")end),
	awful.key({ }, "XF86AudioPlay",       function()awful.util.spawn("mpc toggle")end),
	awful.key({ }, "XF86AudioNext",       function()awful.util.spawn("mpc next")end),
	awful.key({ }, "XF86AudioPrev",       function()awful.util.spawn("mpc prev")end),
	awful.key({ }, "XF86Display",         function()awful.util.spawn("xrandr --output VGA1 --auto --left-of LVDS1")end),
	--awful.key({ }, "XF86ScreenSaver",     function()awful.util.spawn("xscreensaver-command --lock")end),
	awful.key({ }, "XF86ScreenSaver",     function()awful.util.spawn("slimlock")end),
	awful.key({ }, "XF86Sleep",     function()awful.util.spawn("slock")end),
	awful.key({ modkey, }, "l",     function()awful.util.spawn("slock")end),

	-- 截图 {{{3
	awful.key({ }, "Print", function ()
		-- 截图：全屏
		awful.util.spawn("zsh -c 'cd /tmp&&scrot fullsc.png'")
		os.execute("sleep .5")
		naughty.notify({title="截图", text="全屏截图已保存。"})
	end),
	-- 截图：当前窗口
	awful.key({ "Shift", }, "Print", function ()
		awful.util.spawn("zsh -c 'cd /tmp&&scrot -u'")
		os.execute("sleep .5")
		naughty.notify({title="截图", text="当前窗口截图已保存。"})
	end),

	-- {{{3 sdcv
	awful.key({ modkey }, "d", function ()
		local f = io.popen("xsel -p")
		local new_word = f:read("*a")
		f:close()

		if frame ~= nil then
			naughty.destroy(frame)
			frame = nil
			if old_word == new_word then
				return
			end
		end
		old_word = new_word

		local fc = ""
		--local f = io.popen("sdcv -n --utf8-output -u 'stardict1.3英汉辞典' "..new_word)
        local f = io.popen("sdcv -n --utf8-output -u '朗道英汉字典5.0' "..new_word)
        --local f = io.popen("ydcv  "..new_word)
		for line in f:lines() do
			fc = fc .. line .. '\n'
		end
		f:close()
		frame = naughty.notify({ text = span_fg_em(fc), timeout = 5})
	end),
    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
        mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
        mygraphbox[mouse.screen].visible = not mygraphbox[mouse.screen].visible
	end),
	awful.key({ modkey,           }, "Tab",function ()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end),

	-- Layout manipulation
	awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx( 1) end),
	awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end),
	awful.key({ modkey, }, "Tab", function() awful.screen.focus_relative( 1) end),
	awful.key({ modkey, "Shift" }, "Tab", function() awful.screen.focus_relative(-1) end),
	awful.key({ modkey, }, "u", awful.client.urgent.jumpto),
	awful.key({ modkey, }, "p",function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end),

  -- Standard program
  awful.key({ modkey, }, "Return", function() awful.util.spawn(terminal) end),
  awful.key({ modkey, "Control" }, "r", awesome.restart),
  awful.key({ modkey, "Shift" }, "q", awesome.quit),

  awful.key({ modkey, }, "l", function() awful.tag.incmwfact( 0.05) end),
  awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end),
  awful.key({ modkey, }, "k", function() awful.client.incwfact( 0.03) end),
  awful.key({ modkey, }, "j", function() awful.client.incwfact(-0.03) end),
  awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster( 1) end),
  awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1) end),
  awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol( 1) end),
  awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1) end),
  awful.key({ modkey, }, "space", function() awful.layout.inc(layouts, 1) end),
  awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(layouts, -1) end),

  awful.key({ modkey, "Control" }, "n", awful.client.restore),

  -- Scratch
  awful.key({ modkey }, "`", function()
      scratch.drop("urxvt -name scratch", "bottom", "center", 1.0, 0.40, false)
    end),

  -- Thunderbird
  awful.key({ modkey }, ";", function()
      scratch.drop("thunderbird", "center", "center", 0.95, 0.9, false)
    end),

  -- Prompt
  --awful.key({ altkey }, "F2", function() mypromptbox[mouse.screen]:run() end),
  awful.key({ modkey }, "r", function() mypromptbox[mouse.screen]:run() end),

  awful.key({ modkey }, "x",
    function()
      awful.prompt.run({ prompt = "Run Lua code: " },
        mypromptbox[mouse.screen].widget,
        awful.util.eval, nil,
        awful.util.getdir("cache") .. "/history_eval")
    end),

  -- Menubar
  awful.key({ altkey }, "F2", function()  menubar.show() end),
  --awful.key({ modkey }, "r", function() menubar.show() end),

  -- {{{ Tag 0
  awful.key({ modkey }, 0,
    function()
      local screen = mouse.screen
      if tags[screen][10].selected then
        awful.tag.history.restore(screen)
      elseif tags[screen][10] then
        awful.tag.viewonly(tags[screen][10])
      end
    end),
  awful.key({ modkey, "Control" }, 0,
    function()
      local screen = mouse.screen
      if tags[screen][10] then
        tags[screen][10].selected = not tags[screen][10].selected
      end
    end),
  awful.key({ modkey, "Shift" }, 0,
    function()
      if client.focus and tags[client.focus.screen][10] then
        awful.client.movetotag(tags[client.focus.screen][10])
      end
    end),
  awful.key({ modkey, "Control", "Shift" }, 0,
    function()
      if client.focus and tags[client.focus.screen][10] then
        awful.client.toggletag(tags[client.focus.screen][10])
      end
    end)
  -- }}}
)

clientkeys = awful.util.table.join(
  awful.key({ modkey, }, "f", function(c) c.fullscreen = not c.fullscreen end),
  awful.key({ modkey, "Shift" }, "c", function(c) c:kill() end),
  awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle ),
  awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end),
  awful.key({ modkey, }, "o", awful.client.movetoscreen ),
  awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end),
  awful.key({ modkey, }, "n",
    function(c)
      c.minimized = true
    end),

  -- Maximize
  awful.key({ modkey, }, "m",
    function(c)
      c.maximized_horizontal = not c.maximized_horizontal
      c.maximized_vertical = not c.maximized_vertical
    end),

  -- Scratchify
  awful.key({ modkey }, "s", function () scratch.pad.toggle() end),
  awful.key({ modkey }, "v",
    function(c)
      scratch.pad.seT(c, 0.50, 0.50, true)
    end)
)

keynumber = 0
for s = 1, screen.count() do
  keynumber = math.min(9, math.max(#tags[s], keynumber))
end

for i = 1, keynumber do
  globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey }, "#" .. i + 9,
      function()
        local screen = mouse.screen
        if tags[screen][i].selected then
          awful.tag.history.restore(screen)
        elseif tags[screen][i] then
          awful.tag.viewonly(tags[screen][i])
        end
      end),
    awful.key({ modkey, "Control" }, "#" .. i + 9,
      function()
        local screen = mouse.screen
        if tags[screen][i] then
          awful.tag.viewtoggle(tags[screen][i])
        end
      end),
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
      function()
        if client.focus and tags[client.focus.screen][i] then
          awful.client.movetotag(tags[client.focus.screen][i])
        end
      end),
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
      function()
        if client.focus and tags[client.focus.screen][i] then
          awful.client.toggletag(tags[client.focus.screen][i])
        end
      end))
end

clientbuttons = awful.util.table.join(
  awful.button({ }, 1, function(c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
  { rule = { },
    properties = { border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      keys = clientkeys,
      buttons = clientbuttons } },
  { rule = { class = "Screenkey" },
    properties    = {
      opacity   = 0.50,
      floating  = true,
      ontop     = true,
      focus     = false, },
      callback = function( c )
          c:geometry( { x = 0, width = 3200, y = 700, height = 120 } )
      end },

  { rule = { class = "urxvt" },
    properties = { tag = tags[1][1] } },
  { rule = { class = "Firefox" },
    properties = { tag = tags[1][2] } },
  { rule = { class = "Gvim" },
    properties = { tag = tags[1][3] } },
  { rule = { class = "Thunderbird" },
    properties = { tag = tags[1][4] } },
  { rule = { class = "electronic-wechat" },
    properties = { tag = tags[1][5] } },
  { rule = { class = "Thunar" },
    properties = { tag = tags[1][7] } },
  { rule = { class = "Gimp-2.8" },
    properties = { tag = tags[1][8] } },
  { rule = { class = "SMPlayer" },
    properties = { tag = tags[1][9] } }
}
-- }}}

-- {{{ Signals
client.connect_signal("manage", function(c, startup)
    c.size_hints_honor = false

    -- Sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
          client.focus = c
        end
      end)

    if not startup then
      -- Set the windows at the slave
      awful.client.setslave(c)

      -- Put windows in a smart way, only if they does not set an initial position
      if not c.size_hints.user_position and not c.size_hints.program_position then
        awful.placement.no_overlap(c)
        awful.placement.no_offscreen(c)
      end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
      local left_layout = wibox.layout.fixed.horizontal()
      left_layout:add(awful.titlebar.widget.iconwidget(c))

      local right_layout = wibox.layout.fixed.horizontal()
      right_layout:add(awful.titlebar.widget.floatingbutton(c))
      right_layout:add(awful.titlebar.widget.maximizedbutton(c))
      right_layout:add(awful.titlebar.widget.stickybutton(c))
      right_layout:add(awful.titlebar.widget.ontopbutton(c))
      right_layout:add(awful.titlebar.widget.closebutton(c))

      local title = awful.titlebar.widget.titlewidget(c)
      title:buttons(awful.util.table.join(
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
      ))

      local layout = wibox.layout.align.horizontal()
      layout:set_left(left_layout)
      layout:set_right(right_layout)
      layout:set_middle(title)

      awful.titlebar(c):set_widget(layout)
    end
  end)

--client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus c.opacity = 1 end)
--client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal c.opacity = 0.7 end)
client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
-- {{{ auto cmd
do
  local cmds = 
  { 
    "xcompmgr -Ss -n -Cc -fF -I-10 -O-10 -D1 -t-3 -l-4 -r4 &",
    --and so on...
  }

  for _,i in pairs(cmds) do
    awful.util.spawn(i)
  end
end
-- }}}
