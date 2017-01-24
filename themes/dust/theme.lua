--[[=============================================================================
#     FileName: theme.lua
#         Desc:  
#       Author: Lee Meng
#        Email: leaveboy@gmail.com
#     HomePage: http://leaveboy.is-programmer.com/
#      Version: 0.0.1
#   LastChange: 2013-01-08 22:29:06
#      History:
=============================================================================]]

local awful = require("awful")

-- {{{ Main
theme = {}
theme.wallpaper = awful.util.getdir("config") .. "/themes/dust/background.png"
--theme.font      = "DejaVu Sans Mono 10"
theme.font      = "Terminess Powerline 10"
-- }}}
theme.colors = {}
theme.colors.base3   = "#002b36ff"
theme.colors.base2   = "#073642ff"
theme.colors.base1   = "#586e75ff"
theme.colors.base0   = "#657b83ff"
theme.colors.base00  = "#839496ff"
theme.colors.base01  = "#93a1a1ff"
theme.colors.base02  = "#eee8d5ff"
theme.colors.base03  = "#fdf6e3ff"
theme.colors.yellow  = "#b58900ff"
theme.colors.orange  = "#cb4b16ff"
theme.colors.red     = "#dc322fff"
theme.colors.magenta = "#d33682ff"
theme.colors.violet  = "#6c71c4ff"
theme.colors.blue    = "#268bd2ff"
theme.colors.cyan    = "#2aa198ff"
theme.colors.green   = "#859900ff"
-- }}}

-- {{{ Styles

-- {{{ Colors
theme.fg_normal  = theme.colors.base02
theme.fg_focus   = theme.colors.base03
theme.fg_urgent  = theme.colors.base3

theme.bg_normal  = theme.colors.base3
theme.bg_focus   = theme.colors.base1
theme.bg_urgent  = theme.colors.red
theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
theme.border_width  = "0"
theme.border_normal = theme.bg_normal
theme.border_focus  = theme.bg_focus
theme.border_marked = theme.bg_urgent
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_normal
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = theme.colors.green
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
theme.menu_height = 15
theme.menu_width = 100

-- {{{ Taglist
theme.taglist_squares_sel = awful.util.getdir("config") .. "/themes/dust/taglist/squaref.png"
theme.taglist_squares_unsel = awful.util.getdir("config") .. "/themes/dust/taglist/square.png"
-- }}}

-- {{{ Misc
theme.awesome_icon = awful.util.getdir("config") .. "/themes/dust/awesome-dust22.png"
theme.menu_submenu_icon = awful.util.getdir("config") .. "/themes/dust/submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile = awful.util.getdir("config") .. "/themes/dust/layouts/tile.png"
theme.layout_tileleft = awful.util.getdir("config") .. "/themes/dust/layouts/tileleft.png"
theme.layout_tilebottom = awful.util.getdir("config") .. "/themes/dust/layouts/tilebottom.png"
theme.layout_tiletop = awful.util.getdir("config") .. "/themes/dust/layouts/tiletop.png"
theme.layout_fairv = awful.util.getdir("config") .. "/themes/dust/layouts/fairv.png"
theme.layout_fairh = awful.util.getdir("config") .. "/themes/dust/layouts/fairh.png"
theme.layout_spiral = awful.util.getdir("config") .. "/themes/dust/layouts/spiral.png"
theme.layout_dwindle = awful.util.getdir("config") .. "/themes/dust/layouts/dwindle.png"
theme.layout_max = awful.util.getdir("config") .. "/themes/dust/layouts/max.png"
theme.layout_fullscreen = awful.util.getdir("config") .. "/themes/dust/layouts/fullscreen.png"
theme.layout_magnifier = awful.util.getdir("config") .. "/themes/dust/layouts/magnifier.png"
theme.layout_floating = awful.util.getdir("config") .. "/themes/dust/layouts/floating.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_normal = "/usr/share/awesome/themes/dust/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = "/usr/share/awesome/themes/dust/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = "/usr/share/awesome/themes/dust/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = "/usr/share/awesome/themes/dust/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "/usr/share/awesome/themes/dust/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = "/usr/share/awesome/themes/dust/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "/usr/share/awesome/themes/dust/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = "/usr/share/awesome/themes/dust/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "/usr/share/awesome/themes/dust/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = "/usr/share/awesome/themes/dust/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "/usr/share/awesome/themes/dust/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = "/usr/share/awesome/themes/dust/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "/usr/share/awesome/themes/dust/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = "/usr/share/awesome/themes/dust/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/dust/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = "/usr/share/awesome/themes/dust/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "/usr/share/awesome/themes/dust/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = "/usr/share/awesome/themes/dust/titlebar/maximized_focus_active.png"
-- }}}

--[[ Layout
theme.layout_tile = awful.util.getdir("config") .. "/themes/dust/layouts/tilew.png"
theme.layout_tileleft = awful.util.getdir("config") .. "/themes/dust/layouts/tileleftw.png"
theme.layout_tilebottom = awful.util.getdir("config") .. "/themes/dust/layouts/tilebottomw.png"
theme.layout_tiletop = awful.util.getdir("config") .. "/themes/dust/layouts/tiletopw.png"
theme.layout_fairv = awful.util.getdir("config") .. "/themes/dust/layouts/fairvw.png"
theme.layout_fairh = awful.util.getdir("config") .. "/themes/dust/layouts/fairhw.png"
theme.layout_spiral = awful.util.getdir("config") .. "/themes/dust/layouts/spiralw.png"
theme.layout_dwindle = awful.util.getdir("config") .. "/themes/dust/layouts/dwindlew.png"
theme.layout_max = awful.util.getdir("config") .. "/themes/dust/layouts/maxw.png"
theme.layout_fullscreen = awful.util.getdir("config") .. "/themes/dust/layouts/fullscreenw.png"
theme.layout_magnifier = awful.util.getdir("config") .. "/themes/dust/layouts/magnifierw.png"
theme.layout_floating = awful.util.getdir("config") .. "/themes/dust/layouts/floatingw.png"
--]] 

-- {{{ Widgets
theme.widget_ac = awful.util.getdir("config")           .. "/themes/dust/widgets/ac.png"
theme.widget_acblink = awful.util.getdir("config")      .. "/themes/dust/widgets/acblink.png"
theme.widget_blank = awful.util.getdir("config")        .. "/themes/dust/widgets/blank.png"
theme.widget_batempty = awful.util.getdir("config")     .. "/themes/dust/widgets/batempty.png"
theme.widget_batfull = awful.util.getdir("config")      .. "/themes/dust/widgets/batfull.png"
theme.widget_batlow = awful.util.getdir("config")       .. "/themes/dust/widgets/batlow.png"
theme.widget_batmed = awful.util.getdir("config")       .. "/themes/dust/widgets/batmed.png"
theme.widget_pac = awful.util.getdir("config")          .. "/themes/dust/widgets/pac.png"
theme.widget_pacnew = awful.util.getdir("config")       .. "/themes/dust/widgets/pacnew.png"
theme.widget_mpd = awful.util.getdir("config")          .. "/themes/dust/widgets/mpd.png"
theme.widget_mpdplay = awful.util.getdir("config")      .. "/themes/dust/widgets/mpdplay.png"
theme.widget_mute = awful.util.getdir("config")         .. "/themes/dust/widgets/mute.png"
theme.widget_net = awful.util.getdir("config")          .. "/themes/dust/widgets/net.png"
theme.widget_vol = awful.util.getdir("config")          .. "/themes/dust/widgets/vol.png"

theme.widget_cpu = awful.util.getdir("config")          .. "/themes/dust/tp/cpu.png"
theme.widget_disk = awful.util.getdir("config")         .. "/themes/dust/tp/fs_01.png"
theme.widget_fs = awful.util.getdir("config")           .. "/themes/dust/tp/fs_02.png"
theme.widget_ram = awful.util.getdir("config")          .. "/themes/dust/tp/ram.png"
theme.widget_swap = awful.util.getdir("config")         .. "/themes/dust/tp/swap.png"
-- }}}

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
