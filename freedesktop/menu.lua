
--[[
                                                        
     Awesome-Freedesktop                                
     Freedesktop.org compliant desktop entries and menu 
                                                        
     Menu section                                       
                                                        
     Licensed under GNU General Public License v2       
      * (c) 2016, Luke Bonham                           
      * (c) 2014, Harvey Mittens                        
                                                        
--]]

local menu_gen   = require("menubar.menu_gen")
local menu_utils = require("menubar.utils")
local pairs      = pairs
local ipairs     = ipairs
local table      = table
local string     = string
local next       = next

-- Add support for nix/nixos systems too
table.insert(menu_gen.all_menu_dirs, "~/.nix-profile/share/applications")

-- Expecting a wm_name of awesome omits too many applications and tools
menu_utils.wm_name = ""

-- Menu
-- freedesktop.menu
local menu = {}

-- Use MenuBar parsing utils to build a menu for Awesome
-- @return awful.menu compliant menu items tree
function menu.build()
	local result = {}
	local menulist = menu_gen.generate()

	for k,v in pairs(menu_gen.all_categories) do
		table.insert(result, {k, {}, v["icon"] } )
	end

	for k, v in ipairs(menulist) do
		for _, cat in ipairs(result) do
			if cat[1] == v["category"] then
				table.insert( cat[2] , { v["name"], v["cmdline"], v["icon"] } )
				break
			end
		end
	end

	-- Cleanup things a bit
	for k,v in ipairs(result) do
		-- Remove unused categories
		if not next(v[2]) then
			table.remove(result, k)
		else
			--Sort entries alphabetically (by name)
			table.sort(v[2], function (a,b) return string.byte(a[1]) < string.byte(b[1]) end)
			-- Replace category name with nice name
			v[1] = menu_gen.all_categories[v[1]].name
		end
	end

	-- Sort categories alphabetically also
	table.sort(result, function(a,b) return string.byte(a[1]) < string.byte(b[1]) end)

	return result
end

return menu
