-- Flandre Screensaver by PrikolMen#3372
local surface_DrawTexturedRect = surface.DrawTexturedRect
local cvars_AddChangeCallback = cvars.AddChangeCallback
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local CreateClientConVar = CreateClientConVar
local system_HasFocus = system.HasFocus
local ScreenScale = ScreenScale
local tonumber = tonumber
local hook_Add = hook.Add
local CurTime = CurTime

local cam_Start2D = cam.Start2D
local cam_End2D = cam.End2D

local x, y
local loaded = false
local screenBlockTimeout = 0
local flan = Material("flan/flanderka")

local timeToBlock = CreateClientConVar("flan_timer", "5", true, false, "Minutes need for enable flan screen saver (0 - disable)", 0, 120):GetInt()
cvars_AddChangeCallback("flan_timer", function(name, old, new)
    timeToBlock = tonumber(new)
end, "flan_screen_saver")

local function AddTime()
    if (timeToBlock != 0) then
        screenBlockTimeout = CurTime() + 60*timeToBlock
    end
end

local size = ScreenScale(CreateClientConVar("flan_size", "64", true, false, "Flandere size (16-265)", 16, 265):GetInt())
local function UpdateFlanData()
    x, y = (ScrW() - size)/2, (ScrH() - size)/2
    AddTime()
end

hook_Add("OnScreenSizeChanged", "flan_screen_saver", UpdateFlanData)
cvars_AddChangeCallback("flan_size", function(new, old, new)
    size = ScreenScale(tonumber(new))
    UpdateFlanData()
end, "flan_screen_saver")

hook_Add('RenderScene', 'flan_screen_saver', function()
    if (loaded == false) then return end
    if not system_HasFocus() or ((timeToBlock != 0) and (screenBlockTimeout < CurTime())) then 
        cam_Start2D()
            surface_SetDrawColor(255, 255, 255, 255)
            surface_SetMaterial(flan)
            surface_DrawTexturedRect(x, y, size, size)
        cam_End2D()
        
        return true
    end
end)

hook_Add("StartCommand", "flan_screen_saver", function(ply, cmd)
    if (loaded == false) or (timeToBlock == 0) then return end
        
    local lr, fb, ud = cmd:GetSideMove(), cmd:GetForwardMove(), cmd:GetUpMove()
    if (lr + fb + ud) != 0 then
        return AddTime()
    end

    local mx, my, mw = cmd:GetMouseX(), cmd:GetMouseY(), cmd:GetMouseWheel()
    if (mx + my + mw) != 0 then
        return AddTime()
    end
end)

hook_Add("RenderScene", "FUCK_RUBAT54", function()
    hook.Remove("RenderScene", "FUCK_RUBAT54")
    UpdateFlanData()
    
    loaded = true
end)