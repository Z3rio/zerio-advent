Functions.RegisterServerCallback("zerio-advent:server:getData", function(source, cb)
	local Player = Functions.GetPlayer(source)
	if Player then
		local sqlStr = ""

		if FrameworkName == "esx" then
			sqlStr = string.format([[SELECT `adventcalendar` FROM `users` WHERE `identifier` = "%s"]], Player.identifier)
		elseif FrameworkName == "qbcore" then
			sqlStr = string.format([[SELECT `adventcalendar` FROM `players` WHERE `citizenid` = "%s"]], Player.PlayerData.citizenid)
		end

		Functions.SelectSQL(sqlStr, function(result)
			local claimed = {}

			if result and result[1] then
				claimed = json.decode(result[1].adventcalendar)
			end

			cb({
				day = tonumber(os.date("%d")),
				claimed = claimed
			})
		end)
	end
end)

RegisterNetEvent("zerio-advent:server:claimReward")
AddEventHandler("zerio-advent:server:claimReward", function(day)
	local src = source
	local Player = Functions.GetPlayer(src)

	if Player and Config.Rewards[day] and day <= tonumber(os.date("%d")) and Config.Month == tonumber(os.date("%m")) then
		local data = Config.Rewards[day]
		local sqlStr = ""

		if FrameworkName == "esx" then
			sqlStr = string.format([[SELECT `adventcalendar` FROM `users` WHERE `identifier` = "%s"]], Player.identifier)
		elseif FrameworkName == "qbcore" then
			sqlStr = string.format([[SELECT `adventcalendar` FROM `players` WHERE `citizenid` = "%s"]], Player.PlayerData.citizenid)
		end

		if sqlStr ~= "" then
			Functions.SelectSQL(sqlStr, function(result)
				if result and result[1] then
					result = json.decode(result[1].adventcalendar)
					local found = false

					for i,v in pairs(result) do
						if v == tonumber(day) then
							found = true
						end
					end

					if found == false then
						table.insert(result, tonumber(day))

						sqlStr = ""
						if FrameworkName == "esx" then
							sqlStr = string.format([[UPDATE `users` SET `adventcalendar` = "%s" WHERE `identifier` = "%s"]], json.encode(result), Player.identifier)
						elseif FrameworkName == "qbcore" then
							sqlStr = string.format([[UPDATE `players` SET `adventcalendar` = "%s" WHERE `citizenid` = "%s"]], json.encode(result), Player.PlayerData.citizenid)
						end

						if data.type == "vehicle" then
							Functions.GiveCar(Player, data.model)
						elseif data.type == "money" then
							Functions.GiveMoney(Player, data.account, data.amount)
						elseif data.type == "item" then
							Functions.GiveItem(Player, data.item, data.amount)
						elseif data.type == "custom" then
							data.handler(Player, src)
						end

						
						if sqlStr ~= "" then
							Functions.ExecuteSQL(sqlStr, function() end)
						end
					end
				end
			end)
		end
	end
end)
