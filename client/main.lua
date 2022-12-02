Citizen.CreateThread(function()
    local prompt, zoneId = nil, nil
    local loaded = false

    local targetScript = Config.TargetScript
    if Config.CustomTargetName ~= nil then
        targetScript = Config.CustomTargetName
    end

    RegisterNUICallback("loaded", function()
        loaded = true
    end)

    if #Config.Rewards ~= 25 and #Config.Rewards ~= 24 then
        while true do
            print("Weird amount of rewards, you should have either 24 or 25 rewards")
            Citizen.Wait(2500)
        end
    end

    while loaded == false do
        SendNUIMessage({
            action = "firstSetup",
            background = Config.BackgroundImage
        })

        Citizen.Wait(250)
    end

    RegisterNUICallback("close", function()
        SetNuiFocus(false, false)
        opened = false
    end)

    RegisterNUICallback("claim", function(result)
        TriggerServerEvent("zerio-advent:server:claimReward", result.day)
    end)

    if Config.OpenType == "command" and type(Config.Command) == "string" then
        RegisterCommand(Config.Command, function()
            Functions.Open()
        end)
    elseif Config.OpenType == "keybind" and type(Config.Keybind) == "string" and type(Config.KeybindHelp) == "string" then
        RegisterCommand("+advent", function()
            Functions.Open()
        end)
        TriggerEvent("chat:removeSuggestion", "/+advent")
        RegisterKeyMapping('+advent', Config.KeybindHelp, 'keyboard', Config.Keybind)
    elseif Config.OpenType == "proximity" and (type(Config.Coords) == "vector4" or type(Config.Coords) == "vector3") and type(Config.ProximityKey) == "string" and type(Config.ProximityTime) == "number" and type(Config.ProximityObjectText) == "string" and type(Config.ProximityActionText) == "string" and type(Config.ProximityDrawDist) == "number" and type(Config.ProximityUsageDist) == "number" then
        if GetResourceState("zerio-proximityprompt") == "missing" then
            while true do
                print("zerio-proximityprompt is missing, you can't use Config.OpenType \"proximity\"")
                Citizen.Wait(2500)
            end
        end

        while GetResourceState("zerio-proximityprompt") ~= "started" do
            print("Waiting for zerio-proximityprompt to load")
            Citizen.Wait(1000 * 2.5)
        end

        prompt = exports["zerio-proximityprompt"]:AddNewPrompt({
            name = "advent_calender", 
            objecttext = Config.ProximityObjectText, 
            actiontext = Config.ProximityActionText,
            holdtime = Config.ProximityTime,
            key = Config.ProximityKey,
            position = vector3(Config.Coords.x, Config.Coords.y, Config.Coords.z),
            usage = function()
                Functions.Open()
            end,
            drawdist = Config.ProximityDrawDist,
            usagedist = Config.ProximityUsageDist
        })
    elseif Config.OpenType == "floating" and (type(Config.Coords) == "vector4" or type(Config.Coords) == "vector3") then
        Citizen.CreateThread(function()
            while true do
                local markerCoords = Config.Coords
                local plrCoords = GetEntityCoords(PlayerPedId())

                if type(Config.Coords) ~= "vector3" then
                    markerCoords = vector3(Config.Coords.x, Config.Coords.y, Config.Coords.z)
                end


                if #(plrCoords - markerCoords) <= Config.FloatingMaxDist and opened == false then
                    Functions.DrawFloatingHelpText(markerCoords)

                    if IsControlJustReleased(0, 38) then
                        Functions.Open()
                    end
                    Citizen.Wait(0)
                else
                    Citizen.Wait(100)
                end
            end
        end)
    elseif Config.OpenType == "target" and (type(Config.Coords) == "vector4" or type(Config.Coords) == "vector3") and type(Config.TargetScript) == "string" and type(Config.TargetSize) == "table" and (#Config.TargetSize == 3 or #Config.TargetSize == 2) and type(Config.TargetRotation) == "number" and type(Config.TargetDebug) == "boolean" and type(Config.TargetMaxDist) == "number" then
        if Config.TargetScript == "qb-target" or Config.TargetScript == "ox_target" or Config.TargetScript == "qtarget" then
            if GetResourceState(targetScript) == "missing" then
                while true do
                    print(targetScript .. " is missing, you can't use Config.OpenType \"target\"")
                    Citizen.Wait(2500)
                end
            end

            while GetResourceState(targetScript) ~= "started" do
                print("Waiting for " .. targetScript .. " to load")
                Citizen.Wait(1000 * 2.5)
            end
            
            if Config.TargetScript == "qb-target" then
                exports[targetScript]:AddBoxZone("advent_calender", vector3(Config.Coords.x, Config.Coords.y, Config.Coords.z), Config.TargetSize[1], Config.TargetSize[2], {
                    name = "advent_calender",
                    heading = Config.TargetRotation,
                    debugPoly = Config.TargetDebug,
                    minZ = Config.Coords.z - Config.TargetSize[1],
                    maxZ = Config.Coords.z + Config.TargetSize[1]
                }, {
                    options = {
                        {
                            icon = Config.TargetIcon,
                            label = Config.TargetLabel,
                            action = function()
                                Functions.Open()
                            end
                        }
                    },
                    distance = Config.TargetMaxDist
                })
            elseif Config.TargetScript == "ox_target" then
                zoneId = exports[targetScript]:addBoxZone({
                    coords = vector3(Config.Coords.x, Config.Coords.y, Config.Coords.z),
                    size = vector3(Config.TargetSize[1], Config.TargetSize[2], Config.TargetSize[3]),
                    rotation = Config.TargetRotation,
                    debug = Config.TargetDebug,
                    options = {
                        {
                            name = "advent_calender",
                            icon = Config.TargetIcon,
                            label = Config.TargetLabel,
                            action = function()
                                Functions.Open()
                            end,
                            canInteract = function(entity, distance, coords, name)
                                if distance <= Config.TargetMaxDist then
                                    return true
                                else
                                    return false
                                end
                            end,
                        }
                    }
                })
            elseif Config.TargetScript == "qtarget" then
                exports[targetScript]:AddBoxZone("advent_calender", vector3(Config.Coords.x, Config.Coords.y, Config.Coords.z), Config.TargetSize[1], Config.TargetSize[2], {
                    name = "advent_calender",
                    heading = Config.TargetRotation,
                    debugPoly = Config.TargetDebug,
                    minZ = Config.Coords.z - Config.TargetSize[1],
                    maxZ = Config.Coords.z + Config.TargetSize[1]
                  }, {
                    options = {
                      {
                        icon = Config.TargetIcon,
                        label = Config.TargetLabel,
                        action = function()
                            Functions.Open()
                        end
                      },
                    },
                    distance = Config.TargetMaxDist
                })
            end
        else
            while true do
                print(Config.TargetScript .. " is not a supported target script for Config.TargetScript")
                Citizen.Wait(2500)
            end
        end
    elseif Config.OpenType == "custom" then
        exports("Open", Functions.Open)
    else
        while true do
            print("Seems like your config is set up wrong.")
            Citizen.Wait(2500)
        end
    end

    if Config.Blip.Enabled and (type(Config.Coords) == "vector3" or type(Config.Coords) == "vector4")and (Config.OpenType == "proximity" or Config.OpenType == "target" or Config.OpenType == "floating") then
        local blip = AddBlipForCoord(Config.Coords.x, Config.Coords.y, Config.Coords.z)
        SetBlipSprite(blip, Config.Blip.Sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.Blip.Size)
        SetBlipColour(blip, Config.Blip.Color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Blip.Text)
        EndTextCommandSetBlipName(blip)
    end

    RegisterNetEvent("onResourceStop")
    AddEventHandler("onResourceStop", function(resName)
        if GetCurrentResourceName() == resName then
            if prompt ~= nil then
                prompt:Remove()
                prompt = nil
            end

            if Config.TargetScript == "ox_target" and zoneId ~= nil then
                exports[targetScript]:removeZone(zoneId)
                zoneId = nil
            end

            if Config.TargetScript == "qb-target" then
                exports[targetScript]:RemoveZone("advent_calender")
            end
        end
    end)
end)
