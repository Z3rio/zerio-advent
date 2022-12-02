opened = false

Framework = nil
FrameworkName = nil

if GetResourceState("es_extended") == "started" then
    FrameworkName = "esx"

    if exports["es_extended"].getSharedObject ~= nil then
        Framework = exports["es_extended"]:getSharedObject()
    else
        while Framework == nil do
            TriggerEvent("esx:getSharedObject", function(Obj)
                Framework = Obj
            end)
            Citizen.Wait(250)
        end
    end 
elseif GetResourceState("qb-core") == "started" then
    FrameworkName = "qbcore"
    Framework = exports["qb-core"]:GetCoreObject()
end

Functions = {
    -- MISC
	DrawFloatingHelpText = function(coords) 
		AddTextEntry('adventCalendar', Config.FloatingText)
		SetFloatingHelpTextWorldPosition(1, Config.Coords)
		SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
		BeginTextCommandDisplayHelp('adventCalendar')
		EndTextCommandDisplayHelp(2, false, false, -1)
    end,

    -- MAIN
	Open = function()
		Functions.TriggerServerCallback("zerio-advent:server:getData", function(data)
            local formattedRewards = {}

            for i,v in pairs(Config.Rewards) do
                local data = v

                if data.type == "custom" then
                    data.handler = nil
                end

                formattedRewards[i] = data
            end

            for i,v in pairs(data.claimed) do
                formattedRewards[v].claimed = true
            end

			SetNuiFocus(true, true)
			SendNUIMessage({
                action = "open",
				day = data.day,
                rewards = formattedRewards
			})
			opened = true
		end)
	end,

    -- CALLBACKS
    TriggerServerCallback = function(name, cb)
        if FrameworkName == "esx" then
            Framework.TriggerServerCallback(name, cb)
        elseif FrameworkName == "qbcore" then
            Framework.Functions.TriggerCallback(name, cb)
        end
    end
}
