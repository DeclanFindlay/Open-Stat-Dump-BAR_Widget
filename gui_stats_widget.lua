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
    y1 = 1030,
    x2 = 1550,
    y2 = 1078,
    round = 6
}

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

local function GetMainCpuTemp()

    if not stats then
        return "N/A"
    end

    local maxTemp = nil

    for _, hardware in ipairs(stats) do

        if hardware.hardwareType == "Cpu" then

            for _, sensor in ipairs(hardware.sensors) do

                if sensor.sensorType == "Temperature" then

                    if not maxTemp or sensor.sensorValue > maxTemp then
                        maxTemp = sensor.sensorValue
                    end

                end
            end

        end
    end

    if maxTemp then
        return string.format("%.1f °C", maxTemp)
    end

    return "N/A"
end

local function GetMainGpuTemp(gpuType)

    if not stats then
        return "N/A"
    end

    for _, hardware in ipairs(stats) do

        if hardware.hardwareType == gpuType then

            for _, sensor in ipairs(hardware.sensors) do

                if sensor.sensorType == "Temperature" 
                -- may need to change "GPU Core" to whatever your gpu ouput is 
                -- currently set for GpuNvidia 
                -- check the open-stat-dump output file (data.lua)
                and sensor.sensorName == "GPU Core" then

                    return string.format("%.1f °C", sensor.sensorValue)

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

    local ok, loadedStats = pcall(VFS.Include, "LuaUI/Widgets/data.lua")

    if ok then
        stats = loadedStats
    else
        text = "Failed to load stats.lua"
        return
    end

    text = ""

    text = text ..
        "CPU Temp: " ..
        GetMainCpuTemp() ..
        "\n"

    text = text ..
        "GPU Temp: " ..
        -- change to your gpu type here 
        GetMainGpuTemp(GpuNvidia) .. -- <------
        "\n"

end

function widget:DrawScreen()
    
    createPanel(panel)
    createPanelData(panel, text)

end