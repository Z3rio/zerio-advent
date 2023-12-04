Framework = nil
FrameworkName = nil

DBHandler = nil

if GetResourceState("es_extended") == "started" then
    FrameworkName = "esx"

    if exports["es_extended"].getSharedObject ~= nil then
        Framework = exports["es_extended"]:getSharedObject()
    else
        TriggerEvent("esx:getSharedObject", function(Obj)
            Framework = Obj
        end)
    end 
elseif GetResourceState("qb-core") == "started" then
    FrameworkName = "qbcore"
    Framework = exports["qb-core"]:GetCoreObject()
end

if GetResourceState("oxmysql") == "started" then
    DBHandler = "oxmysql"
elseif GetResourceState("ghmattimysql") == "started" and GetResourceState("oxmysql") == "missing" then
    DBHandler = "ghmattimysql"
elseif GetResourceState("mysql-async") == "started" then
    DBHandler = "mysql-async" 

    if MySQL == nil then
        while true do
            print("You are trying to use mysql-async with zerio-advent, but you havent imported mysql-async in the fxmanifest")
            Citizen.Wait(250)
        end
    end
end

Functions = {
    -- CALLBACKS
    RegisterServerCallback = function(name, handler)
        if FrameworkName == "esx" then
            Framework.RegisterServerCallback(name, handler)
        elseif FrameworkName == "qbcore" then
            Framework.Functions.CreateCallback(name, handler)
        end
    end,

    -- MISC
    DoesPlateExist = function(plate)
        local retVal = promise.new()

        if FrameworkName == "esx" then
            Functions.SelectSQL(string.format("select count(1) from owned_vehicles where `plate` = \"%s\"", plate), function(resp)
                retVal:resolve(resp ~= nil and resp[1] ~= nil and resp[1]["count(1)"] > 0)
            end)
        elseif FrameworkName == "qbcore" then
            Functions.SelectSQL(string.format("select count(1) from player_vehicles where `plate` = \"%s\"", plate), function(resp)
                retVal:resolve(resp ~= nil and resp[1] ~= nil and resp[1]["count(1)"] > 0)
            end)
        else
            retVal:resolve(false)
        end

        Citizen.Await(retVal)

        return retVal.value
    end,

    GeneratePlate = function()
        local count = 0
        local retVal = ""
        while true do
            retVal = ""
            count = count + 1;

            if count >= 100 then
                return nil
            end

            for i = 1, Config.PlateFirstString do
                retVal = retVal .. string.upper(string.char(math.random(97,122)))
            end
            if Config.PlateUseSpace then
                retVal = retVal .. " "
            end
            for i = 1, Config.PlateLastString do
                retVal = retVal .. tostring(math.random(1,9))
            end

            if Functions.DoesPlateExist(retVal) == false then
                break;
            end
        end

        return retVal
    end,
    
    -- PLAYER
    GetPlayer = function(source)
        if FrameworkName == "esx" then
            return Framework.GetPlayerFromId(source)
        elseif FrameworkName == "qbcore" then
            return Framework.Functions.GetPlayer(source)
        end
    end,

    GiveCar = function(plr, model)
        local plate = Functions.GeneratePlate()

        if plate == nil then
            warn("Could not generate plate in time, tried  100 times, yet failed")
        end

        local hash = GetHashKey(model)

        if FrameworkName == "esx" then
            Functions.ExecuteSQL(string.format([[
                INSERT INTO `owned_vehicles` (`owner`, `plate`, `vehicle`, `stored`)
                VALUES ("%s", "%s", '%s', 1)
            ]], 
            plr.identifier, plate, '{"modTrimB":-1,"tyreBurst":{"1":false,"0":false,"5":false,"4":false},"windowTint":-1,"modBackWheels":-1,"modArchCover":-1,"modOrnaments":-1,"doorsBroken":{"4":false,"3":false,"2":false,"1":false,"0":false},"modDashboard":-1,"modDoorR":-1,"wheelColor":158,"color2":3,"modSuspension":-1,"pearlescentColor":70,"modRoof":-1,"xenonColor":255,"modSteeringWheel":-1,"bodyHealth":1000.0,"modAirFilter":-1,"modArmor":-1,"modAPlate":-1,"model":' .. hash .. ',"modRightFender":-1,"modBrakes":-1,"modEngine":-1,"modStruts":-1,"modEngineBlock":-1,"modSpoilers":-1,"neonEnabled":[false,false,false,false],"modFender":-1,"modHood":-1,"modFrontBumper":-1,"modDoorSpeaker":-1,"modPlateHolder":-1,"modSmokeEnabled":false,"modSeats":-1,"modSpeakers":-1,"modLightbar":-1,"plateIndex":0,"modTransmission":-1,"wheels":0,"modXenon":false,"color1":3,"modShifterLeavers":-1,"modAerials":-1,"modDial":-1,"dirtLevel":9.0,"tankHealth":1000.0,"modFrontWheels":-1,"modRearBumper":-1,"windowsBroken":{"5":false,"4":false,"3":false,"2":false,"1":false,"0":false,"7":false,"6":false},"extras":[],"plate":"' .. plate .. '","neonColor":[255,0,255],"engineHealth":1000.0,"tyreSmokeColor":[255,255,255],"modLivery":-1,"modSideSkirt":-1,"modTrunk":-1,"modGrille":-1,"modHydrolic":-1,"modVanityPlate":-1,"modHorns":-1,"modTrimA":-1,"modTurbo":false,"modTank":-1,"fuelLevel":100.0,"modExhaust":-1,"modFrame":-1}'), function() end)
        elseif FrameworkName == "qbcore" then
            Functions.ExecuteSQL(string.format([[
                INSERT INTO `player_vehicles` (`license`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) 
                VALUES ("%s", "%s", "%s", "%s", '%s', "%s", 1)
            ]], 
            plr.PlayerData.license, plr.PlayerData.citizenid, model, hash, '{"modTransmission":-1,"modSteeringWheel":-1,"neonEnabled":[false,false,false,false],"xenonColor":255,"tankHealth":1000.0,"color1":3,"modRoof":-1,"modCustomTiresR":false,"interiorColor":0,"plateIndex":3,"modHydrolic":-1,"modBrakes":-1,"wheels":5,"modFrontWheels":-1,"modPlateHolder":-1,"modSpeakers":-1,"modAerials":-1,"modSeats":-1,"doorStatus":{"1":false,"2":false,"3":false,"4":false,"5":false,"0":false},"pearlescentColor":0,"oilLevel":4.76596940834568,"modStruts":-1,"extras":{"4":true,"5":true,"1":true,"2":true,"3":true},"dashboardColor":0,"modSmokeEnabled":false,"wheelWidth":0.0,"modKit17":-1,"model":' .. hash .. ',"modArmor":-1,"modEngineBlock":-1,"modTank":-1,"modBackWheels":-1,"plate":"' .. plate .. '","dirtLevel":0.0,"modFender":-1,"windowTint":-1,"modXenon":false,"modDashboard":-1,"modShifterLeavers":-1,"modAPlate":-1,"modTrimB":-1,"modArchCover":-1,"modKit21":-1,"modKit49":-1,"modAirFilter":-1,"modTrunk":-1,"modTrimA":-1,"modLivery":-1,"modHood":-1,"modKit47":-1,"engineHealth":1000.0,"bodyHealth":1000.0,"modTurbo":false,"modRightFender":-1,"modDial":-1,"modKit19":-1,"liveryRoof":-1,"modOrnaments":-1,"fuelLevel":100.0,"modGrille":-1,"modVanityPlate":-1,"modSuspension":-1,"modExhaust":-1,"wheelSize":0.0,"modEngine":-1,"wheelColor":156,"tyreSmokeColor":[255,255,255],"headlightColor":255,"modFrontBumper":-1,"tireHealth":{"1":1000.0,"2":1000.0,"3":1000.0,"0":1000.0},"modCustomTiresF":false,"modWindows":-1,"tireBurstCompletely":{"1":false,"2":false,"3":false,"4":false,"5":false,"0":false},"modFrame":-1,"modRearBumper":-1,"neonColor":[255,0,255],"modDoorSpeaker":-1,"windowStatus":{"1":true,"2":true,"3":true,"4":false,"5":false,"6":false,"7":true,"0":true},"modSideSkirt":-1,"modHorns":-1,"tireBurstState":{"1":false,"2":false,"3":false,"4":false,"5":false,"0":false},"color2":3,"modSpoilers":-1}', plate), function() end)
        end
    end,

    GiveItem = function(plr, name, amount)
        if FrameworkName == "esx" then
            plr.addInventoryItem(name, amount)
        elseif FrameworkName == "qbcore" then
            if plr.Functions.AddItem == nil then
                exports["qb-inventory"]:AddItem(plr.source, name, amount)
            else
                plr.Functions.AddItem(name, amount)
            end
        end
    end,

    GiveMoney = function(plr, acc, amount)
        if FrameworkName == "esx" then
            plr.addAccountMoney(acc, amount, "advent-reward")
        elseif FrameworkName == "qbcore" then
            plr.Functions.AddMoney(acc, amount, "advent-reward")
        end
    end,

    -- SQL
    ExecuteSQL = function(str, cb)
        if DBHandler == "oxmysql" then
            exports.oxmysql:update(str, {}, function(retVal)
                cb(retVal)
            end)
        elseif DBHandler == "mysql-async" then
            MySQL.Async.execute(string, {}, function(retVal)
                cb(retVal)
            end)
        elseif DBHandler == "ghmattimysql" then
            exports["ghmattimysql"]:query(str, {}, function(retVal)
                cb(retVal)
            end)
        end
    end,

    SelectSQL = function(str, cb)
        if DBHandler == "oxmysql" then
            exports.oxmysql:query(str, {}, function(retVal)
                cb(retVal)
            end)
        elseif DBHandler == "mysql-async" then
            MySQL.Async.fetchAll(str, {}, function(retVal)
                cb(retVal)
            end)
        elseif DBHandler == "ghmattimysql" then
            exports.ghmattimysql:scalar(str, {}, function(retVal)
                cb(retVal)
            end)
        end
    end,
}
