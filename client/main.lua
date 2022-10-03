RegisterNetEvent('ox_inventory:setPlayerInventory', function(currentDrops, inventory)
	exports.ox_inventory:displayMetadata({
		number = "Number",
		ssn = "SSN"
	})
	local phoneNumber = exports.npwd:getPhoneNumber() 
	foundSim = false 
	for _, item in pairs(inventory) do
		if item.name == 'sim_card' then 
			if item.metadata.number == phoneNumber then 
				foundSim = true 
				break
			else 
				foundSim = false 
			end
		end 
	end
	if not foundSim then 
		exports.npwd:setPhoneDisabled(true)
	else  
		lib.notify({
			title = 'Sim Card',
			description = ('Sim Card activated. Phone number: %s'):format(phoneNumber),
			type = 'success'
		})
		exports.npwd:setPhoneDisabled(false)
	end 
end)

RegisterNetEvent('r_npwd_sim:activateSim', function(phoneNumber)
	local isDisabled = exports.npwd:isPhoneDisabled()
	if isDisabled then
		exports.npwd:setPhoneDisabled(false)
	end
	lib.notify({
		title = 'Sim Card',
		description = ('Sim Card activated. Phone number: %s'):format(phoneNumber),
		type = 'success'
	})
end)

exports('checkSim', function()
	local phoneNumber = exports.npwd:getPhoneNumber() 
	local isDisabled = exports.npwd:isPhoneDisabled()
	local simcards = exports.ox_inventory:Search('slots', 'sim_card')
	for _, item in pairs(simcards) do 
		if item.metadata.number == phoneNumber then 
			foundSim = true 
			break
		else 
			foundSim = false 
		end
	end 
	if (not foundSim and not isDisabled) then 
		exports.npwd:setPhoneDisabled(true)
		lib.notify({
			title = 'Sim Card',
			description = ('Sim Card deactivated. Phone number: %s'):format(phoneNumber),
			type = 'error'
		})
	elseif isDisabled then 
		lib.notify({
			title = 'Sim Card',
			description = ('Sim Card activated. Phone number: %s'):format(phoneNumber),
			type = 'success'
		})
		exports.npwd:setPhoneDisabled(false)
	end 
end)

function OpenMenu()
	local elements = {}
	local prom = promise.new()
	lib.callback("r_npwd_sim:getSims", false, function(result)
		for k, v in pairs(result) do
			table.insert(elements, {
				label = v.number,
				args = v.number,
			})
		end
		prom:resolve()

	end)
	Citizen.Await(prom)
	lib.registerMenu({
		id = 'SimCard_Copy',
		title = 'Get a Sim Card Copy', 
		position = Config.menuAlign, 
		options = elements
	
	}, function(selected, scrollIndex, args)
		TriggerServerEvent('r_npwd_sim:getSimCopy', args)
	end)
    lib.showMenu('SimCard_Copy')
end

local duplicatepostion = lib.points.new(Config.DuplicatePosition, Config.DrawDistance, {})

function duplicatepostion:nearby()
    DrawMarker(Config.MarkerType, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, nil, nil, false)

    if self.currentDistance < Config.InteractDistance and IsControlJustReleased(0, Config.InteractKey) then
		OpenMenu()
    end
end