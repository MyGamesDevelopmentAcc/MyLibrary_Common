--[[
Use:
    LibStub("MyLibrary_Events"):RegisterEvent("PLAYER_LOGIN",someFunction);
or     
    obj= {};
    LibStub("MyLibrary_Events").embed(obj);
    obj:RegisterEvent("PLAYER_LOGIN",someFunction);
    obj:RegisterEvent("PLAYER_LOGIN"); -- will register function that must be defined under this object  `obj:PLAYER_LOGIN(...)`
]]
local MAJOR, MINOR = "MyLibrary_Events", 1
local MyLibrary_Events, oldminor = LibStub:NewLibrary(MAJOR, MINOR);
if not MyLibrary_Events then return end

local events = {};
local function addEvent(eventName, f)
    events[eventName] = events[eventName] or {};
    events[eventName][f] = true;
end

local function removeEvent(eventName, f)
    if not f then
        return;
    else
        events[eventName] = events[eventName] or {};
        events[eventName][f] = nil;
    end
end

local function getEvents(eventName)
    return events[eventName] or {};
end

local function OnEvent(self, event, ...)
    local functions = getEvents(event);
    for i, _ in pairs(functions) do
        i(event, ...);
    end
end

local frame = CreateFrame("Frame")
frame:HookScript("OnEvent", OnEvent);
function MyLibrary_Events:RegisterEvent(eventName, f)
    if (not events[eventName]) then
        frame:RegisterEvent(eventName)
    end
    addEvent(eventName, f)
end

function MyLibrary_Events:UnregisterEvent(eventName, f)
    removeEvent(eventName, f)
    if (events[eventName] and next(events[eventName]) == nil) then
        frame:UnregisterEvent(eventName)
    end
end

-- function namespace:Register(eventName)
--     frame:UnregisterEvent(eventName)
-- end

function MyLibrary_Events:OnDbLoaded(f)
    self:RegisterEvent("PLAYER_LOGIN", f)
end

function MyLibrary_Events:OnInitialize(f)
    self:OnDbLoaded(f);
end

function MyLibrary_Events.embed(nameSpace)
    local nameSpaceFunctions = {};
    function nameSpace:RegisterEvent(eventName, f)
        if (f == nil) then
            f = function(...)
                nameSpace[eventName](nameSpace, ...);
            end
            nameSpaceFunctions[eventName] = f;
        end
        MyLibrary_Events:RegisterEvent(eventName, f)
    end

    function nameSpace:UnregisterEvent(eventName, f)
        if (f == nil) then
            f = nameSpaceFunctions[eventName]
        end
        MyLibrary_Events:UnregisterEvent(eventName, f)
    end

    function nameSpace:OnDbLoaded(f)
        MyLibrary_Events:OnDbLoaded(f)
    end

    function nameSpace:OnInitialize(f)
        MyLibrary_Events:OnInitialize(f)
    end
end
