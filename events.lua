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
    table.insert(events[eventName], f);
end

local function removeEvent(eventName, f)
    if not f then
        return;
    else
        events[eventName] = events[eventName] or {};
        for i, n in ipairs(events[eventName]) do
            if (f == n) then
                table.remove(events[eventName], i);
                return
            end
        end
    end
end

local function getFunctions(eventName)
    return events[eventName] or {};
end

local function OnEvent(self, event, ...)
    for _, f in ipairs(getFunctions(event)) do
        f(event, ...);
    end
end

local frame = CreateFrame("Frame")
frame:HookScript("OnEvent", OnEvent);
function MyLibrary_Events:RegisterEvent(eventName, f)
    if (not frame:IsEventRegistered(eventName)) then
        frame:RegisterEvent(eventName)
    end
    addEvent(eventName, f)
end

function MyLibrary_Events:RegisterCustomEvent(eventName, f)
    if (C_EventUtils.IsEventValid(eventName)) then
        error("Event " ..
            eventName .. " is a valid WoW event, do not use this function for valid events.")
    end
    addEvent(eventName, f)
end

function MyLibrary_Events:UnregisterEvent(eventName, f)
    removeEvent(eventName, f)
end

function MyLibrary_Events:TriggerCustomEvent(eventName, ...)
    if (C_EventUtils.IsEventValid(eventName)) then
        error("Event " ..
            eventName .. " is a valid WoW event, do not use this function for valid events.")
    end
    OnEvent(nil, eventName, ...);
end

function MyLibrary_Events:UnregisterCustomEvent(eventName, f)
    if (C_EventUtils.IsEventValid(eventName)) then
        error("Event " ..
            eventName .. " is a valid WoW event, do not use this function for valid events.")
    end
    removeEvent(eventName, f)
end

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

    function nameSpace:RegisterCustomEvent(eventName, f)
        if (f == nil) then
            f = function(...)
                nameSpace[eventName](nameSpace, ...);
            end
            nameSpaceFunctions[eventName] = f;
        end
        MyLibrary_Events:RegisterCustomEvent(eventName, f)
    end

    function nameSpace:UnregisterCustomEvent(eventName, f)
        if (f == nil) then
            f = nameSpaceFunctions[eventName]
        end
        MyLibrary_Events:UnregisterCustomEvent(eventName, f)
    end

    function nameSpace:OnDbLoaded(f)
        MyLibrary_Events:OnDbLoaded(f)
    end

    function nameSpace:TriggerCustomEvent(eventName, ...)
        MyLibrary_Events:TriggerCustomEvent(eventName, ...)
    end

    function nameSpace:OnInitialize(f)
        MyLibrary_Events:OnInitialize(f)
    end
end
