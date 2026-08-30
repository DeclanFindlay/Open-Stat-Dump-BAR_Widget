local gpuType
local RectRound
local lastReload = 0
local reloadPerSec = 1 -- how often the function widget:Update(dt) runs 
local stats = nil
local cpuRows = {}
local gpuRows = {}

local panel = {
    width = 165, -- panel width
    height = 90, -- panel height
    
    -- base positions from the top right corner of your screen
    -- top right = 0, 0
    marginX = 50, 
    marginY = 50, 

    xOffset = -260, -- adjust this to move the panel on the x axis 
    yOffset = 10, -- adjust this to move the panel on the y axis

    round = 6 -- how "round" the corners are 
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

local function createPanelData(panel, cpuRows, gpuRows)
    gl.Color(1,1,1,1)

    -- panel data will follow the top left of the panel
    local x = panel.x1 + 15
    local y = panel.y2 - 22
    local fontSize = 15
    local lineHeight = 16

    for _, row in ipairs(cpuRows) do
        gl.Text(row, x, y, fontSize, "o")
        y = y - lineHeight
    end

    -- create a space between cpu and gpu stats
    y = y - 10

    for _, row in ipairs(gpuRows) do
        gl.Text(row, x, y, fontSize, "o")
        y = y - lineHeight
    end

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

local function GetGpuType(stats)

    if not stats then
        return "N/A"
    end

    for _, hardware in ipairs(stats) do
    
        if hardware.hardwareType == "GpuNvidia" or 
            hardware.hardwareType == "GpuIntel" or 
            hardware.hardwareType == "GpuAmd" then

            return hardware.hardwareType
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

    -- read file once during initialization to get gpu type 
    local ok, loadedStats = readDatafile()
    if ok then
        stats = loadedStats
    else
        cpuRows = "Failed to load data.lua"
        gpuRows = "Failed to load data.lua"
        return
    end

    gpuType = GetGpuType(stats)

    Spring.Echo("[system stats display] Loaded")

end

function widget:Update(dt)

    lastReload = lastReload + dt

    if lastReload < reloadPerSec then
        return
    end
    -- clear the cpu and gpu arrays to stop them appending the data
    cpuRows = {}
    gpuRows = {}

    lastReload = 0

    local ok, loadedStats = readDatafile()

    if ok then
        stats = loadedStats
    else
        cpuRows = "Failed to load data.lua"
        gpuRows = "Failed to load data.lua"
        return
    end

    table.insert(cpuRows, "CPU Temp: " .. GetStats(stats, "Cpu", "Temperature", "CPU Package"))
        
    table.insert(cpuRows, "CPU Usage: " .. GetStats(stats, "Cpu", "Load", "CPU Total"))

    table.insert(gpuRows, "GPU Temp: " .. GetStats(stats, gpuType, "Temperature", "GPU Core")) 

    table.insert(gpuRows, "GPU Usage: " .. GetStats(stats, gpuType, "Load", "GPU Core"))
    -- you may need to change the arguments in the GetStats functions to whatever your gpu/cpu ouput is 
    -- currently set for GpuNvidia  
    -- check the open-stat-dump output file (data.lua)
end

function widget:DrawScreen()

    -- get user screen width and height using a spring engine function
    local screenWidth, screenHeight = Spring.GetViewGeometry()

    -- calculate the panel location 
    panel.x1 = screenWidth - panel.width - panel.marginX + panel.xOffset
    panel.y1 = screenHeight - panel.height - panel.marginY + panel.yOffset
    panel.x2 = screenWidth - panel.marginX + panel.xOffset
    panel.y2 = screenHeight - panel.marginY + panel.yOffset
    
    -- draw the panel and its data
    createPanel(panel)
    createPanelData(panel, cpuRows, gpuRows)

end