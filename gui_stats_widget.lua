-- gpu types, pick the right one for your machine

-- GPU TYPES -----
local GpuNvidia = "GpuNvidia"
local GpuIntel = "GpuIntel"
local GpuAmd = "GpuAmd"
-- GPU TYPES -----

local RectRound

local lastReload = 0
local reloadPerSec = 1

local stats = nil
local text = "Loading stats..."

local panel = {
    x1 = 1375,
    y1 = 990,
    x2 = 1550,
    y2 = 1078,
    round = 6
}

local function readDatafile()
    -- using the spring engine file reading system, pcall function
    local ok, loadedStats = pcall(VFS.Include, "LuaUI/Widgets/data.lua")

    return ok, loadedStats
end

local function createPanel(panel)

    -- border
    gl.Color(0.1, 0.1, 0.1, 0.4)
    RectRound(panel.x1 -3, panel.y1 -3, panel.x2 + 3, panel.y2 + 3, panel.round)

    -- main
    gl.Color(0.5, 0.5, 0.5, 0.3)
    RectRound(panel.x1, panel.y1, panel.x2, panel.y2, panel.round)

end

local function createPanelData(panel, text)
    gl.Color(1,1,1,1)
    gl.Text(text, panel.x1 + 15, panel.y2 - 22, 15, "o")

end

local function GetStats(stats, hardwareType, sensorType, sensorName)

    if not stats then
        return "N/A"
    end

    for _, hardware in ipairs(stats) do
    
        if hardware.hardwareType == hardwareType then

            for _, sensor in ipairs(hardware.sensors) do

                if sensor.sensorType == sensorType and sensor.sensorName == sensorName then

                    if sensorType == "Temperature" then
                        return string.format("%.1f °C", sensor.sensorValue)
                    end

                    if sensorType == "Load" then
                        return string.format("%.1f %%", sensor.sensorValue)
                    end
                end
            end
        end
    end
    return "N/A"
end

function widget:GetInfo()
    return{
        name = "system stats display",
        desc = "shows system stats using Open-Stat-Dump output files",
        author = "Declan Findlay",
        enabled = true
    }
end

function widget:Initialize()

    if WG.FlowUI and WG.FlowUI.Draw then
        RectRound = WG.FlowUI.Draw.RectRound
    end

    RectRound = RectRound or function(x1, y1, x2, y2)
        gl.Rect(x1, y1, x2, y2)
    end

    Spring.Echo("[system stats display] Loaded")

end


function widget:Update(dt)

    lastReload = lastReload + dt

    if lastReload < reloadPerSec then
        return
    end

    lastReload = 0

    local ok, loadedStats = readDatafile()

    if ok then
        stats = loadedStats
    else
        text = "Failed to load data.lua"
        return
    end

    text = ""

    text = text ..
        "CPU Temp: " ..
        GetStats(stats, "Cpu", "Temperature", "CPU Package") ..
        "\n"

    text = text ..
        "CPU Usage: " ..
        GetStats(stats, "Cpu", "Load", "CPU Total") ..
        "\n\n"

    text = text ..
        "GPU Temp: " ..
        -- change to your gpu type here 
        GetStats(stats, GpuNvidia, "Temperature", "GPU Core") .. -- <------
        "\n"

    text = text ..
        "GPU Usage: " ..
        -- change to your gpu type here
        GetStats(stats, GpuNvidia, "Load", "GPU Core") .. -- <------
        "\n"
        -- you may need to change the arguments in the GetStats functions to whatever your gpu ouput is 
        -- currently set for GpuNvidia  
        -- check the open-stat-dump output file (data.lua)
end

function widget:DrawScreen()
    
    createPanel(panel)
    createPanelData(panel, text)

end