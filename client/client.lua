local QBCore = exports['qb-core']:GetCoreObject()

isLoggedIn = true

local menuOpen = false
local wasOpen = false
local spawnedWeed = 0
local weedPlants = {}

local isPickingUp, isProcessing, isProcessing2 = false, false, false

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
	CheckCoords()
	Wait(1000)
	local coords = GetEntityCoords(PlayerPedId())
	if GetDistanceBetweenCoords(coords, Config.CircleZones.CottonField.coords, true) < 1000 then
		SpawnWeedPlants()
	end
end)

function CheckCoords()
	Citizen.CreateThread(function()
		while true do
			local coords = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(coords, Config.CircleZones.CottonField.coords, true) < 1000 then
				SpawnWeedPlants()
			end
			Wait(1 * 60000)
		end
	end)
end

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		CheckCoords()
	end
end)
Citizen.CreateThread(function()--Cotton
	while true do
		Wait(10)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID
		
		
		for i=1, #weedPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(weedPlants[i]), false) < 1 then
				nearbyObject, nearbyID = weedPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				QBCore.Functions.Draw2DText(0.5, 0.88, 'Press ~g~[E]~w~ to pickup Cotton', 0.4)
			end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				isPickingUp = true
				TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
				QBCore.Functions.Progressbar("search_register", "Picking up Cotton..", 3000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
					disableInventory = false,
				}, {}, {}, {}, function() -- Done
					ClearPedTasks(PlayerPedId())
					QBCore.Functions.DeleteObject(nearbyObject)

					table.remove(weedPlants, nearbyID)
					spawnedWeed = spawnedWeed - 1

					TriggerServerEvent('qb-tailorjob:pickedUpcotton')
				end, function()
					ClearPedTasks(PlayerPedId())
				end)

				isPickingUp = false
			end
		else
			Wait(500)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(weedPlants) do
			QBCore.Functions.DeleteObject(v)
		end
	end
end)
function SpawnWeedPlants()
	while spawnedWeed < 20 do
		Wait(1)
		local weedCoords = GenerateWeedCoords()

		QBCore.Functions.SpawnLocalObject('prop_weed_02', weedCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)
			

			table.insert(weedPlants, obj)
			spawnedWeed = spawnedWeed + 1
		end)
	end
	Wait(45 * 60000)
end

function ValidateWeedCoord(plantCoord)
	if spawnedWeed > 0 then
		local validate = true

		for k, v in pairs(weedPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.CottonField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateWeedCoords()
	while true do
		Wait(1)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-10, 10)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-10, 10)

		weedCoordX = Config.CircleZones.CottonField.coords.x + modX
		weedCoordY = Config.CircleZones.CottonField.coords.y + modY

		local coordZ = GetCoordZWeed(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateWeedCoord(coord) then
			return coord
		end
	end
end

function GetCoordZWeed(x, y)
	local groundCheckHeights = { 31.0, 32.0, 33.0, 34.0, 35.0, 36.0, 37.0, 38.0, 39.0, 40.0, 50.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 31.85
end

Citizen.CreateThread(function()
	while QBCore == nil do
		Wait(200)
	end
	while true do
		Wait(10)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.SewingClothes.coords, true) < 5 then
			DrawMarker(2, Config.CircleZones.SewingClothes.coords.x, Config.CircleZones.SewingClothes.coords.y, Config.CircleZones.SewingClothes.coords.z - 0.2 , 0, 0, 0, 0, 0, 0, 0.3, 0.2, 0.15, 255, 0, 0, 100, 0, 0, 0, true, 0, 0, 0)

			
			if not isProcessing and GetDistanceBetweenCoords(coords, Config.CircleZones.SewingClothes.coords, true) <1 then
				QBCore.Functions.DrawText3D(Config.CircleZones.SewingClothes.coords.x, Config.CircleZones.SewingClothes.coords.y, Config.CircleZones.SewingClothes.coords.z, 'Press ~g~[E]~w~ to Sew')
			end

			if IsControlJustReleased(0, 38) and not isProcessing then
				local hasCotton = false
				local s1 = false
				local hasFabricroll = false
				local s2 = false

				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasCotton = result
					s1 = true
				end, 'cotton')
				
				while(not s1) do
					Wait(100)
				end
				Wait(100)
				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasFabricroll = result
					s2 = true
				end, 'fabricroll')
				
				while(not s2) do
					Wait(100)
				end

				if (hasCotton and hasFabricroll) then
					ProcessCotton()
				elseif (hasCotton) then
					QBCore.Functions.Notify('You dont have enough fabricroll.', 'error')
				elseif (hasFabricroll) then
					QBCore.Functions.Notify('You dont have enough cotton.', 'error')
				else
					QBCore.Functions.Notify('You dont have enough cotton and fabricroll.', 'error')
				end
			end
		else
			Wait(500)
		end
	end
end)

function ProcessCotton()
	isProcessing = true
	local playerPed = PlayerPedId()

	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	SetEntityHeading(PlayerPedId(), 108.06254)

	QBCore.Functions.Progressbar("search_register", "Trying to Sew..", 1000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
		disableInventory = false,
	}, {}, {}, {}, function()
	 TriggerServerEvent('qb-tailorjob:processweed')

		local timeLeft = Config.Delays.SewingClothes / 1000

		while timeLeft > 0 do
			Wait(1000)
			timeLeft = timeLeft - 1

			if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.SewingClothes.coords, false) > 4 then
				TriggerServerEvent('qb-tailorjob:cancelProcessing')
				break
			end
		end
		ClearPedTasks(PlayerPedId())
	end, function()
		ClearPedTasks(PlayerPedId())
	end) -- Cancel
	
	isProcessing = false
end

Citizen.CreateThread(function()
	while QBCore == nil do
		Wait(200)
	end
	while true do
		Wait(10)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.TextileOwner.coords, true) < 5 then
			DrawMarker(2, Config.CircleZones.TextileOwner.coords.x, Config.CircleZones.TextileOwner.coords.y, Config.CircleZones.TextileOwner.coords.z - 0.2 , 0, 0, 0, 0, 0, 0, 0.3, 0.2, 0.15, 255, 0, 0, 100, 0, 0, 0, true, 0, 0, 0)

			
			if not isProcessing2 and GetDistanceBetweenCoords(coords, Config.CircleZones.TextileOwner.coords, true) <1 then
				QBCore.Functions.DrawText3D(Config.CircleZones.TextileOwner.coords.x, Config.CircleZones.TextileOwner.coords.y, Config.CircleZones.TextileOwner.coords.z, 'Press ~g~[E]~w~ to Sell')
			end

			if IsControlJustReleased(0, 38) and not isProcessing2 then
				local hasCotton2 = false
				local hasFabricroll2 = false
				local s3 = false
				
				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasCotton2 = result
					hasFabricroll2 = result
					s3 = true
					
				end, 'shirt')
				
				while(not s3) do
					Wait(100)
				end
				

				if (hasCotton2) then
					SellShirt()
				elseif (hasCotton2) then
					QBCore.Functions.Notify('You dont have enough Fabricroll.', 'error')
				elseif (hasFabricroll2) then
					QBCore.Functions.Notify('You dont have enough Cotton.', 'error')
				else
					QBCore.Functions.Notify('You dont have enough Shirts to sell.', 'error')
				end
			end
		else
			Wait(500)
		end
	end
end)

function SellShirt()
	isProcessing2 = true
	local playerPed = PlayerPedId()

	--
	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	SetEntityHeading(PlayerPedId(), 108.06254)

	QBCore.Functions.Progressbar("search_register", "Selling..", 500, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
		disableInventory = false,
	}, {}, {}, {}, function()
	 TriggerServerEvent('qb-tailorjob:selld')

		local timeLeft = Config.Delays.SewingClothes / 500

		while timeLeft > 0 do
			Wait(500)
			timeLeft = timeLeft - 1

			if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.SewingClothes.coords, false) > 4 then
				break
			end
		end
		ClearPedTasks(PlayerPedId())
	end, function()
		ClearPedTasks(PlayerPedId())
	end) -- Cancel

	isProcessing2 = false
end

--Cotton field blips

CreateThread(function()
    -- local blip = AddBlipForCoord(2064.4783, 4916.6768, 41.1036)
    local blip = AddBlipForCoord(Config.CircleZones.CottonField.coords)
    SetBlipSprite(blip, 73)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 49)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cotton field")
    EndTextCommandSetBlipName(blip)
end)

CreateThread(function()
    local blip = AddBlipForCoord(Config.CircleZones.SewingClothes.coords)
    SetBlipSprite(blip, 73)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 49)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Sewing Clothes")
    EndTextCommandSetBlipName(blip)
end)

CreateThread(function()
    local blip = AddBlipForCoord(Config.CircleZones.TextileOwner.coords)
    SetBlipSprite(blip, 73)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 49)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Textile Owner")
    EndTextCommandSetBlipName(blip)
end)
