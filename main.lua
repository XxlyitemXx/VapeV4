if shared.vape then shared.vape:Uninject() end

local vape
local loadstring = function(...)
    local res, err = loadstring(...)
    if err and vape then
        vape:CreateNotification("katware", "Failed to load: "..err, 30, 'alert')
    end
    return res
end

local queue_on_teleport = queue_on_teleport or function() end
local isfile = isfile or function(file)
    local suc, res = pcall(
        function()
            return readfile(file)
        end)
        return suc and res ~= nil and res ~= ""
end

local cloneref = cloneref or function(obj)
    return obj
end
local pS = cloneref(game:GetService("Players"))
local function downloadFile(path, func)
    if not isfile(path) then
        local suc, res = pcall(
            function()
                return game:HttpGet("https://raw.githubusercontent.com/XxlyitemXx/VapeV4/main/"..select(1, path:gsub("newvape/", "")), true)
        end)
        if not suc or res == "404: Not Found" then
            error(res)
        end
        if path:find(".lua") then
            res = "nn"
        end
        writefile(path, res)
    end
    return (func or readfile)(path)
end

local function finishLoading()
    vape.init = nil
    vape:Load()
    task.spawn(
        function()
            repeat
                vape.save()
                task.wait(9.5)
            until not vape.Loaded
        end)
    
        local teleportedServers
        vape:Clean(playersService.LocalPlayer.OnTeleport:Connect(function()
            if (not teleportedServers) and (not shared.vapeIndependent) then
                teleportedServers = true
                local teleportScript = [[
                    shared.vapereload = true
                    if shared.vapeDeveloper then
                        loadstring(readfile('newvape/loader.lua'), 'loader')()
                    else
                        loadstring(game:HttpGet('https://raw.githubusercontent.com/XxlyitemXx/VapeV4/loader.lua', true), 'loader')()
                    end
                ]]
                if shared.vapeDeveloper then
                    teleportScript = 'shared.vapeDeveloper = true\n'..teleportScript
                end
                if shared.newvapeCustomProfiles then
                    teleportScript = 'shared.vapeCustomprofiles = "'..shared.vapeCustomProfile..'"\n'..teleportScript
                end
                vape:Save()
                queue_on_teleport(teleportScript)
        end
    end))
    if not shared.vapereload then
        if not vape.Categories then return end
        if vape.Categories.Main.Options["GUI Bind Indicator"].Enabled then
            vape:CreateNotfication("katware", "Press Right Shift button to toggle the GUI", 5)
        end
    end
end
if not isfle("newvape/profile/gui.txt") then
    writefile("newvape/profile/gui.txt", "new")
end
local gui = readfile("newvape/profile/gui.txt")
if not isfolder("newvape/assets"..gui) then
    makefolder("newvape/assets"..gui)
end
vape = loadstring(downloadFile("newvape/guis/"..gui..".lua"), "gui")()
shared.vape = vape

if not shared.vapeIndependent then
    loadstring(downloadFile("newvape/games/univeral.lua"), "universal")()
    if isfile("newevape/games/"..game.PlaceId..".lua") then
        loadstring(downloadFile("newvape/games/"..game.PlaceId..".lua"), tostring(game.PlaceId))(...)
    else
        if not shared.vapeDeveloper then
            local suc, res = pcall(
                function()
                    return game:HttpGet("https://raw.githubusercontent.com/XxlyitemXx/VapeV4/".."/games/"..game.PlaceId..".lua", true)
            end)
            if suc and res ~= "404: Not Found" then
                loadstring(downloadFile("newvape/games/"..game.PlaceId..".lua"), tostring(game.PlaceId))(...)
            end
        end
    end
    finishLoading()
else
    vape.Init = finishLoading
    return vape
end