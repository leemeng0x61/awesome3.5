-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local freedesktop = require("freedesktop")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local lain= require("lain")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local scratch = require("scratch")
beautiful.init(awful.util.getdir("config") .. "/themes/dust/theme.lua")
local wi      = require("wi")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, an error happened!",
        text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init(awful.util.get_themes_dir() .. "dust/theme.lua")
--local wibox = require("wibox")
-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
--local layouts =
awful.layout.layouts = {
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
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}


-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}


-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end }
}
mymainmenu = freedesktop.menu.build({
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", terminal },
        -- other triads can be put here
    }
})
--[[
mymainmenu = awful.menu({ 
    items = { 
        { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "open terminal", terminal }
    }
})
--]]
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
menu = mymainmenu })
-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- Menubar configuration
-- Set the terminal for applications that require it
menubar.utils.terminal = terminal 
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
-- Calendar
mytextclock = awful.widget.textclock("<span font='Tamsyn 2'></span>%H:%M")
lain.widgets.calendar.attach(mytextclock)

-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
awful.button({ }, 1, function(t) t:view_only() end),
awful.button({ modkey }, 1, function(t)
    if client.focus then
        client.focus:move_to_tag(t)
    end
end),
awful.button({ }, 3, awful.tag.viewtoggle),
awful.button({ modkey }, 3, function(t)
    if client.focus then
        client.focus:toggle_tag(t)
    end
end),
awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = awful.util.table.join(
awful.button({ }, 1, function (c)
    if c == client.focus then
        c.minimized = true
    else
        -- Without this, the following
        -- :isvisible() makes no sense
        c.minimized = false
        if not c:isvisible() and c.first_tag then
            c.first_tag:view_only()
        end
        -- This will also un-minimize
        -- the client, if needed
        client.focus = c
        c:raise()
    end
end),
awful.button({ }, 3, client_menu_toggle_fn()),
awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "term", "web", "develop", "mail", "im", 6, 7, "rss", "media"  }, s, awful.layout.layouts[1])
    awful.tag.setproperty(s.tags[5], "mwfact",   0.13)
    awful.tag.setproperty(s.tags[6], "hide",   true)
    awful.tag.setproperty(s.tags[7], "hide",   true)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", height = 16, screen = s })
    s.mywibox1 = awful.wibar({ position = "bottom",height = 16, screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        -- Left widgets
        {
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        -- Middle widget
        s.mytasklist,
        {
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            weather,
            pipe,
            uptimewidget,
            pipe,
            pacicon,
            pacwidget,
            pipe,
            baticon,
            batpct,
            pipe,
            volicon,
            volpct,
            volspace,
            pipe,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
    s.mywibox1:setup {
        layout = wibox.layout.align.horizontal,
        -- Left widgets
        {
            layout = wibox.layout.fixed.horizontal,
            memicon,
            memused,
            pipe,
            dioicon,
            diowidget,
            pipe,
            neticon,
            netwidget,
            pipe,
            mpdicon,
            mpdwidget,
        },
        -- Middle widget
        space,
        -- Right widgets
        {
            layout = wibox.layout.fixed.horizontal,
            cpuicon,
            tzswidget,
            cpugraph0,
            cpugraph1,
            cpugraph2,
            cpugraph3,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
awful.button({ }, 3, function () mymainmenu:toggle() end),
awful.button({ }, 4, awful.tag.viewnext),
awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
{description="show help", group="awesome"}),
awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
{description = "view previous", group = "tag"}),
awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
{description = "view next", group = "tag"}),
awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
{description = "go back", group = "tag"}),

awful.key({ modkey,           }, "j",
function ()
    awful.client.focus.byidx( 1)
end,
{description = "focus next by index", group = "client"}
),
awful.key({ modkey,           }, "k",
function ()
    awful.client.focus.byidx(-1)
end,
{description = "focus previous by index", group = "client"}
),
awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
{description = "show main menu", group = "awesome"}),
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
    frame = naughty.notify({ text = markup(theme.colors.yellow,markup.font("Tamsyn 12",fc)), timeout = 10})
end),
-- Show/Hide Wibox
awful.key({ modkey }, "b", function ()
    myscreen = awful.screen.focused()
    myscreen.mywibox.visible = not myscreen.mywibox.visible
    myscreen.mywibox1.visible = not myscreen.mywibox1.visible
end,
{description = "toggle statusbar"}
),
awful.key({ modkey,           }, "Tab",function ()
    awful.client.focus.history.previous()
    if client.focus then
        client.focus:raise()
    end
end),
-- Scratch
awful.key({ modkey }, "`", function()
    scratch.drop("urxvt -name scratch", "bottom", "center", 1.0, 0.40, false)
end),

-- Layout manipulation
awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
{description = "swap with next client by index", group = "client"}),
awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
{description = "swap with previous client by index", group = "client"}),
awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
{description = "focus the next screen", group = "screen"}),
awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
{description = "focus the previous screen", group = "screen"}),
awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
{description = "jump to urgent client", group = "client"}),
awful.key({ modkey,           }, "Tab",
function ()
    awful.client.focus.history.previous()
    if client.focus then
        client.focus:raise()
    end
end,
{description = "go back", group = "client"}),

-- Standard program
awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
{description = "open a terminal", group = "launcher"}),
awful.key({ modkey, "Control" }, "r", awesome.restart,
{description = "reload awesome", group = "awesome"}),
awful.key({ modkey, "Shift"   }, "q", awesome.quit,
{description = "quit awesome", group = "awesome"}),

awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
{description = "increase master width factor", group = "layout"}),
awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
{description = "decrease master width factor", group = "layout"}),
awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
{description = "increase the number of master clients", group = "layout"}),
awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
{description = "decrease the number of master clients", group = "layout"}),
awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
{description = "increase the number of columns", group = "layout"}),
awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
{description = "decrease the number of columns", group = "layout"}),
awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
{description = "select next", group = "layout"}),
awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
{description = "select previous", group = "layout"}),

awful.key({ modkey, "Control" }, "n",
function ()
    local c = awful.client.restore()
    -- Focus restored client
    if c then
        client.focus = c
        c:raise()
    end
end,
{description = "restore minimized", group = "client"}),

-- Prompt
awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
{description = "run prompt", group = "launcher"}),

awful.key({ modkey }, "x",
function ()
    awful.prompt.run {
        prompt       = "Run Lua code: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval"
    }
end,
{description = "lua execute prompt", group = "awesome"}),
-- Menubar
awful.key({ modkey }, "p", function() menubar.show() end,
{description = "show the menubar", group = "launcher"})
)

clientkeys = awful.util.table.join(
awful.key({ modkey,           }, "f",
function (c)
    c.fullscreen = not c.fullscreen
    c:raise()
end,
{description = "toggle fullscreen", group = "client"}),
awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
{description = "close", group = "client"}),
awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
{description = "toggle floating", group = "client"}),
awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
{description = "move to master", group = "client"}),
awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
{description = "move to screen", group = "client"}),
awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
{description = "toggle keep on top", group = "client"}),
awful.key({ modkey,           }, "n",
function (c)
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    c.minimized = true
end ,
{description = "minimize", group = "client"}),
awful.key({ modkey,           }, "m",
function (c)
    c.maximized = not c.maximized
    c:raise()
end ,
{description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
    function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
            tag:view_only()
        end
    end,
    {description = "view tag #"..i, group = "tag"}),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
    function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
            awful.tag.viewtoggle(tag)
        end
    end,
    {description = "toggle tag #" .. i, group = "tag"}),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
    function ()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:move_to_tag(tag)
            end
        end
    end,
    {description = "move focused client to tag #"..i, group = "tag"}),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
    function ()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:toggle_tag(tag)
            end
        end
    end,
    {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = awful.util.table.join(
awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
awful.button({ modkey }, 1, awful.mouse.client.move),
awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
-- All clients will match this rule.
awful.rules.rules = {
    { 
        rule = { },
        properties = { 
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },
    -- Floating clients.
    { 
        rule_any = {
            instance = {
                -- Firefox addon DownThemAll.
                "DTA",
                -- Includes session name in class.
                "copyq",
            },
            class = {
                "Arandr",
                "Gpick",
                "Kruler",
                "MessageWin",
                "Sxiv",
                "Wpa_gui",
                "pinentry",
                "veromix",
                "xtightvncviewer"},

                name = {
                    -- xev.
                    "Event Tester",
                },
                role = {
                    -- Thunderbird's calendar.
                    "AlarmWindow",
                    -- e.g. Google Chrome's (detached) Developer Tools.
                    "pop-up",
                }
            }, properties = { floating = true }},

            -- Add titlebars to normal clients and dialogs
            { rule_any = {type = { "normal", "dialog" }
        }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    { rule = { class = "urxvt" },
    properties = { screen = 1, tag = "term" } },
    { rule = { class = "Firefox" },
    properties = { screen = 1, tag = "web" } },
    { rule = { class = "Gvim" },
    properties = { screen = 1, tag = "develop" } },
    { rule = { class = "Thunderbird" },
    properties = { screen = 1, tag = "mail" } },
    { rule = { class = "electronic-wechat" },
    properties = { screen = 1, tag = "im" } },
    { rule = { class = "Thunar" },
    properties = { screen = 1, tag = "6" } },
    { rule = { class = "Gimp-2.8" },
    properties = { screen = 1, tag = "rss" } },
    { rule = { class = "SMPlayer" },
    properties = { screen = 1, tag = "media" } },

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
        not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
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

    awful.titlebar(c) : setup {
        { -- Left
        awful.titlebar.widget.iconwidget(c),
        buttons = buttons,
        layout  = wibox.layout.fixed.horizontal
    },
    { -- Middle
    { -- Title
    align  = "center",
    widget = awful.titlebar.widget.titlewidget(c)
},
buttons = buttons,
layout  = wibox.layout.flex.horizontal
        },
        { -- Right
        awful.titlebar.widget.floatingbutton (c),
        awful.titlebar.widget.maximizedbutton(c),
        awful.titlebar.widget.stickybutton   (c),
        awful.titlebar.widget.ontopbutton    (c),
        awful.titlebar.widget.closebutton    (c),
        layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
}
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

--client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
--client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
    c.opacity = 1 
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    c.opacity = 0.618
end)
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
-- }}
