local QBCore = exports['qb-core']:GetCoreObject()

local itemcraft = 'markedbills'

RegisterServerEvent('qb-tailorjob:pickedUpcotton') --hero
AddEventHandler('qb-tailorjob:pickedUpcotton', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	    if 	TriggerClientEvent("QBCore:Notify", src, "Picked up some Cotton!!", "Success", 1000) then
		  Player.Functions.AddItem('cotton', 2) ---- change this shit 
		  TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['cotton'], "add")
	    end
end)

RegisterServerEvent('qb-tailorjob:processweed')
AddEventHandler('qb-tailorjob:processweed', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
      local fabricroll = Player.Functions.GetItemByName("fabricroll")

    if fabricroll ~= nil then
        if Player.Functions.RemoveItem('fabricroll', 2) then
            Player.Functions.AddItem('shirt', 1)-----change this
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['fabricroll'], "remove")
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['shirt'], "add")
            TriggerClientEvent('QBCore:Notify', src, '	Shirt sewed sucessfully', "success")  
        else
            TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
    end
end)

RegisterServerEvent('qb-tailorjob:processweed2')
AddEventHandler('qb-tailorjob:processweed2', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cotton = Player.Functions.GetItemByName("cotton")

        if Player.Functions.RemoveItem('cotton', 2) then
            Player.Functions.AddItem('fabricroll', 1)-----change this
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['cotton'], "remove")
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['fabricroll'], "add")
            TriggerClientEvent('QBCore:Notify', src, 'Fabricroll Made sucessfully', "success")  
        else
            TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
        end
end)

--selldrug ok

RegisterServerEvent('qb-tailorjob:selld')
AddEventHandler('qb-tailorjob:selld', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local Item = Player.Functions.GetItemByName('shirt')
   
	if Item ~= nil and Item.amount >= 1 then
		local chance2 = math.random(1, 12)
		if chance2 == 1 or chance2 == 2 or chance2 == 9 or chance2 == 4 or chance2 == 10 or chance2 == 6 or chance2 == 7 or chance2 == 8 then
			Player.Functions.RemoveItem('shirt', 1)----change this
			TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['shirt'], "remove")
			Player.Functions.AddMoney("cash", Config.Pricesell, "sold-pawn-items")
			TriggerClientEvent('QBCore:Notify', src, 'you sold to the textileowner', "success")  
		else
			Player.Functions.RemoveItem('shirt', 1)----change this
			TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['shirt'], "remove")
			Player.Functions.AddMoney("cash", Config.Pricesell-100, "sold-pawn-items")
			TriggerClientEvent('QBCore:Notify', src, 'you sold to the pusher', "success")
		end
else
	TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
	
end
end)

function CancelProcessing(playerId)
	if playersProcessingcotton[playerId] then
		ClearTimeout(playersProcessingcotton[playerId])
		playersProcessingcotton[playerId] = nil
	end
end

RegisterServerEvent('qb-tailorjob:cancelProcessing')
AddEventHandler('qb-tailorjob:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('QBCore_:playerDropped', function(playerId, reason)
	CancelProcessing(playerId)
end)

RegisterServerEvent('qb-tailorjob:onPlayerDeath')
AddEventHandler('qb-tailorjob:onPlayerDeath', function(data)
	local src = source
	CancelProcessing(src)
end)

QBCore.Functions.CreateCallback('poppy:process', function(source, cb)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	 
	if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then
		for k, v in pairs(Player.PlayerData.items) do
		    if Player.Playerdata.items[k] ~= nil then
				if Player.Playerdata.items[k].name == "cotton" then
					cb(true)
			    else
					TriggerClientEvent("QBCore:Notify", src, "You do not have any cotton", "error", 10000)
					cb(false)
				end
	        end
		end	
	end
end)
