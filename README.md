# qb-tailorjob
A Tailor Job For Your Server!

I used qb-weedpicking as the Base

qb-weedpicking Author - 
https://github.com/MrEvilGamer

Me
https://github.com/Predator7158

Join My Server
https://discord.gg/nbMazBXaVa

#More Scripts Coming Soon#

!IMPORTANT!
Step 1
Make sure you add the images that i gave to the inventory and open the shared.lua and add the text given to
qb-core/shared.lua

["shirt"] 					 = {["name"] = "shirt", 					["label"] = "Shirt", 					["weight"] = 4000, 		["type"] = "item", 		["image"] = "shirt.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,  ["combinable"] = nil,   ["description"] = "Nice shirt you got there"},

["fabricroll"] 					 = {["name"] = "fabricroll", 					["label"] = "Fabricroll", 				["weight"] = 2000, 		["type"] = "item", 		["image"] = "fabric.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,  ["combinable"] = nil,   ["description"] = "An item that need to make shirts"},

["cotton"] 					 = {["name"] = "cotton", 					["label"] = "Cotton", 				        ["weight"] = 1000, 		["type"] = "item", 		["image"] = "cotton.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,  ["combinable"] = nil,   ["description"] = "An item that need to make fabricrolls"},

Step 2
Make sure to add these in qb-core/client/functions.lua
(And this after Drawtext3d) 

```lua
QBCore.Functions.Draw2DText = function(x, y, text, scale)
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end
```



(This at the Bottom)

```lua
QBCore.Functions.SpawnObject = function(model, coords, cb)
    local model = (type(model) == 'number' and model or GetHashKey(model))

    Citizen.CreateThread(function()
        RequestModel(model)
        local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)
        SetModelAsNoLongerNeeded(model)

        if cb then
            cb(obj)
        end
    end)
end
```
```lua
QBCore.Functions.SpawnLocalObject = function(model, coords, cb)
    local model = (type(model) == 'number' and model or GetHashKey(model))

    Citizen.CreateThread(function()
        RequestModel(model)
        local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)
        SetModelAsNoLongerNeeded(model)

        if cb then
            cb(obj)
        end
    end)
end
```
```lua
QBCore.Functions.DeleteObject = function(object)
    SetEntityAsMissionEntity(object, false, true)
    DeleteObject(object)
end
```
