--[[
Use:
	AddonNS.init = function(db)
		AddonNS.db = db;
	end
	LibStub("MyLibrary_DB").asyncLoad("MyArenaLogDB", AddonNS.init);
]]

local MAJOR, MINOR = "MyLibrary_DB", 1
local MyLibrary_DB, oldminor = LibStub:NewLibrary(MAJOR, MINOR);
if not MyLibrary_DB then return end 

MyLibrary_DB.asyncLoad = function (savedVariableName, func)
	local function OnEvent()
		_G[savedVariableName] = _G[savedVariableName] or {};
		func(_G[savedVariableName]);
	end
	LibStub("MyLibrary_Events"):OnDbLoaded(OnEvent)
end