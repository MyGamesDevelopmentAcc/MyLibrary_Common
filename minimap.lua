--[[
Use:
	LibStub("MyLibrary_Minimap").create(
		addonName,
		"Interface\\Icons\\Spell_holy_borrowedtime",
		function() AddonNS["MinimapOnClick"]() end, -- this allows to init minimap without defining the function yet
		"Addon shows spells casted in order during arena match."
	)
]]
local LibDBIcon = LibStub("LibDBIcon-1.0")
local MAJOR, MINOR = "MyLibrary_Minimap", 1
local MyLibrary_Minimap, oldminor = LibStub:NewLibrary(MAJOR, MINOR);
if not MyLibrary_Minimap then return end
if not LibDBIcon then
	print("Unable to create map button, LibDBIcon not loaded");
	return;
end

function MyLibrary_Minimap.create(addonName, icon, onClickFunction, addonDescription )
	local miniButton =  {
		type = "data source",
		text = addonName.." Addon",
		icon = icon,
		OnClick = function()
			onClickFunction();
		end,
		OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then return end
			tooltip:AddLine(addonName.." "..addonDescription)
		end,
	}
	LibDBIcon:Register(addonName, miniButton, {hide=false})
end