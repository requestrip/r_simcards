function debug(...)
	print(...)
end

exports('sim_card', function(event, item, inventory, slot, data)
	local _source = inventory.id
	local characterdata = exports["npwd"]:getPlayerData({ source = _source })
	if event == 'usingItem' then 
		local useditem = exports.ox_inventory:GetSlot(_source, slot)
		if useditem.metadata.number ~= nil then 
			MySQL.Async.fetchAll('SELECT * FROM `r_npwd_sim` WHERE ssn = ?', { useditem.metadata.ssn }, function(result)
				if result[1] then
					if characterdata ~= nil and characterdata.firstName and characterdata.lastName and characterdata.phoneNumber ~= nil then
						exports.npwd:unloadPlayer(_source)
						exports.npwd:newPlayer({ source = _source, firstname = characterdata.firstName, lastname = characterdata.lastName, identifier = characterdata.identifier, phoneNumber = useditem.metadata.number })
					else 
						exports.npwd:newPlayer({ source = _source, firstname = characterdata.firstName, lastname = characterdata.lastName, identifier = characterdata.identifier, phoneNumber = useditem.metadata.number })
					end
					debug(('used sim_card in slot %s with number: %s'):format(slot, useditem.metadata.number))
					MySQL.Async.execute('UPDATE '..Config.Database.playerTable..' SET '..Config.Database.phoneNumberColumn..' = ? WHERE '..Config.Database.identifierColumn..' = ?',{ useditem.metadata.number, characterdata.identifier})
					TriggerClientEvent('r_npwd_sim:activateSim', _source, useditem.metadata.number)
				else 
					TriggerClientEvent('ox_lib:notify', _source, { type = 'error', title = 'Sim Card', description = 'The SSN cannot be identified.'})
				end
			end)
		else 
			local metadata = {
				number = (math.random(111, 999)..'-'..math.random(1111, 9999)),
				ssn = math.random(11111111, 99999999)
			}
			exports['ox_inventory']:SetMetadata(_source, slot, metadata)
			MySQL.Async.execute('INSERT INTO r_npwd_sim (identifier, number, ssn) VALUES (@identifier, @number, @ssn)',
			{
				['@identifier'] = characterdata.identifier,
				['@number'] 	= metadata.number,
				['@ssn'] 		= metadata.ssn
			})
			debug(('modified sim_card in slot %s with new metadata'):format(slot))
			if characterdata ~= nil and characterdata.firstName and characterdata.lastName and characterdata.phoneNumber ~= nil then
				exports.npwd:unloadPlayer(_source)
				exports.npwd:newPlayer({ source = _source, firstname = characterdata.firstName, lastname = characterdata.lastName, identifier = characterdata.identifier, phoneNumber = metadata.number })
			else 
				exports.npwd:newPlayer({ source = _source, firstname = characterdata.firstName, lastname = characterdata.lastName, identifier = characterdata.identifier, phoneNumber = metadata.number })
				debug(('used sim_card in slot %s with number: %s'):format(slot, metadata.number))
			end
			MySQL.Async.execute('UPDATE '..Config.Database.playerTable..' SET '..Config.Database.phoneNumberColumn..' = ? WHERE '..Config.Database.identifierColumn..' = ?',{ metadata.number, characterdata.identifier })
			TriggerClientEvent('r_npwd_sim:activateSim', _source, metadata.number)
		end
	end 
end)


lib.callback.register('r_npwd_sim:getSims', function(source)
    local _source = source
	local characterdata = exports["npwd"]:getPlayerData({ source = _source })
	local data = {}
	local prom = promise.new()
    MySQL.Async.fetchAll('SELECT * FROM r_npwd_sim WHERE identifier = ?', {characterdata.identifier}, function(result)
		data = result
		prom:resolve()
	end)
	Citizen.Await(prom)
	return data
end)

RegisterNetEvent('r_npwd_sim:getSimCopy', function(number)
	local metadata = {
		number = number,
		ssn = math.random(11111111, 99999999)
	}
	exports.ox_inventory:AddItem(source, 'sim_card', 1, metadata, nil, function(success, reason)
	    if success then
			TriggerClientEvent('ox_lib:notify', source, { type = 'success', title = 'Sim Card', description = 'A duplicate sim card has been created.'})
			MySQL.Async.execute('UPDATE r_npwd_sim SET ssn = ? WHERE number = ?', { metadata.ssn, number })
		else
			TriggerClientEvent('ox_lib:notify', source, { type = 'error', title = 'Sim Card', description = 'Unable to create duplicate sim card.'})
		end
	end)
end)
