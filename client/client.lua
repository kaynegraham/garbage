local Config = lib.require('shared.config')
local vehicleSpawned, binSpawned, holdingBin = false, false, false 
local truck, bin, ped, blip, binPoint, outfitSet
local pay = 0

-- Prop Functions -- 
local propOptions = {
    label = "Pickup Trashcan",
    icon = "fas fa-trash",
    distance = 3.0, 
    onSelect = function(data) 
        local player = PlayerPedId()
        if IsPedInAnyVehicle(player, true) then 
            return lib.notify({
                title = "You are in a vehicle!",
                type = "error" 
            })
        end 

        local playercoords = GetEntityCoords(player)
        local bincoords = GetEntityCoords(data.entity) 
        local distance = #(playercoords - bincoords)

        lib.requestAnimDict(Config.GrabAnimDict)

        if distance < 2.5 then 
            if lib.progressCircle({
                label = "Picking up bin..",
                duration = 2500,
                position = 'bottom',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                },
            }) then 
            TaskPlayAnim(player,Config.GrabAnimDict,Config.GrabAnimClip, 8.0, 0.0, -1,49, 0, 0, 0, 0)
            AttachEntityToEntity(data.entity, player, GetPedBoneIndex(player, 28422), 0.00, -0.420, -1.290, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
            holdingBin = true 
            if binPoint then 
                binPoint:remove()
                binPoint = nil 
            end 
        else 
            lib.notify({
                title = "You cancelled picking up the bin!",
                type = "error"
            })
        end 
        else
            lib.notify({
                title = "You are too far away!",
                type = "error"
            })
        end
    end,
}

local function spawnBin()
    if binSpawned then return end 
    binSpawned = true 
    if binPoint then 
        binPoint:remove()
    end
    local propLocation = Config.PropLocations[math.random(#Config.PropLocations)]
    local propModel = Config.PropModels[math.random(#Config.PropModels)] 
    lib.requestModel(propModel) 
    bin = CreateObject(propModel, propLocation.x , propLocation.y, propLocation.z, true, true, false) 
    SetEntityHeading(bin, propLocation.w) 
    PlaceObjectOnGroundProperly(bin)
    SetModelAsNoLongerNeeded(propModel) 
    SetNewWaypoint(propLocation.x, propLocation.y)
    lib.notify({
        title = "Another Job Assigned",
        type = 'success'
    })

    if not binPoint then 
    binPoint = lib.points.new({
        coords = propLocation,
        distance = 50
    })
else 
    binPoint.coords = propLocation 
end

    function binPoint:nearby()
        if binSpawned then 
        DrawMarker(0, self.coords.x, self.coords.y, self.coords.z + 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 50, true, true, 2, false, nil, nil, false)
    end
end
    exports['ox_target']:addLocalEntity(bin, propOptions)
end

local function cleanBin()
    if not holdingBin or not DoesEntityExist(truck) then
        return lib.notify({ title = "You don't have a bin.", type = "error" })
    end 

    local player = PlayerPedId()
    local distance = #(GetEntityCoords(player) - GetOffsetFromEntityInWorldCoords(truck, 0.0, -2.5, 0.0))

    if distance > 4.0 then 
        return lib.notify({ title = "You are too far away!", type = "error" })
    end 

    if lib.progressCircle({
        duration = 1800,
        label = "Cleaning Bin..",
        position = "bottom",
        useWhileDead = false,
        canCancel = true, 
        disable = { car = true },
        anim = { dict = Config.DropAnimDict, clip = Config.DropAnimClip },
    }) then 
        DeleteEntity(bin)
        holdingBin = false 
        binSpawned = false 
        pay = pay + Config.Reward
        lib.notify({ title = "Bin Cleaned!", type = "success" })
        spawnBin()
    else 
        lib.notify({ title = "You cancelled cleaning the bin!", type = "error" })
    end
end

-- Outfit Functions -- 
local outfit = {}

local function saveOutfit()
    local playerPed = PlayerPedId()
    outfit = {
        gloves = GetPedDrawableVariation(playerPed, 3), -- Gloves
        pants = GetPedDrawableVariation(playerPed, 4), -- Pants 
        torso = GetPedDrawableVariation(playerPed, 11), -- Shirt 
        shoes = GetPedDrawableVariation(playerPed, 6), -- Shoes 
        hat = GetPedPropIndex(playerPed, 0), -- Hat
        shirt = GetPedDrawableVariation(playerPed, 8) -- Undershirt 
    }
end

local function setOutfit()
    local playerPed = PlayerPedId()
    SetPedComponentVariation(playerPed, 11, Config.Uniform.Shirt, 0, 0) -- Shirt
    SetPedComponentVariation(playerPed, 4, Config.Uniform.Pants, 0, 0) -- Pants 
    SetPedComponentVariation(playerPed, 6, Config.Uniform.Shoes, 0, 0) -- Shoes 
    SetPedComponentVariation(playerPed, 3, Config.Uniform.Gloves, 0, 0) -- Gloves
    SetPedComponentVariation(playerPed, 8, Config.Uniform.Undershirt, 0, 0) -- Undershirt
    SetPedPropIndex(playerPed, 0, Config.Uniform.Hat, 0, 0, true) -- Hat
    outfitSet = true 
end

local function restoreOutfit()
    local playerPed = PlayerPedId()
    SetPedComponentVariation(playerPed, 11, outfit.torso, 0, 0) -- Shirt
    SetPedComponentVariation(playerPed, 4, outfit.pants, 0, 0) -- Pants 
    SetPedComponentVariation(playerPed, 6, outfit.shoes, 0, 0) -- Shoes 
    SetPedComponentVariation(playerPed, 3, outfit.gloves, 0, 0) -- Gloves
    SetPedComponentVariation(playerPed, 8, outfit.shirt, 0, 0) -- Undershirt
    SetPedPropIndex(playerPed, 0, outfit.hat, 0, 0, true) -- Hat
    outfitSet = false 
end

-- Vehicle Functions -- 
local function checkSpawnArea(coords) 
    local nearbyVeh = GetClosestVehicle(coords.x, coords.y, coords.z, 10.0, 0, 70)

    if nearbyVeh and DoesEntityExist(nearbyVeh) then 
        return true 
    end 
    return false 
end

local function spawnTruck()
    if vehicleSpawned then return end  
    lib.requestModel(Config.truckModel)
    local spawnCoords = Config.vehicleCoords
    local spawnareaBusy = checkSpawnArea(spawnCoords)
    if Config.Bond > 0 then 
        local hasBond = lib.callback.await('trash:takemoney', false, Config.Bond, "Garbage Truck Bond")
        if not hasBond then 
            return lib.notify({
                title = "Not enough money!",
                type = "error"
            })
        end
    end 

    if spawnareaBusy then 
        return lib.notify({
            title = "The Spawn Area is busy",
            type = "error"
        })
    end 

    DoScreenFadeOut(1000)
    Wait(1500)
    truck = CreateVehicle(Config.truckModel, spawnCoords.x, spawnCoords.y, spawnCoords.z, Config.vehicleHeading, true, true)
    vehicleSpawned = true 
    SetPedIntoVehicle(PlayerPedId(), truck, -1)
    SetModelAsNoLongerNeeded(truckhash) 
    SetEntityAsMissionEntity(truck, true, true)
    SetVehicleNumberPlateText(truck, "TRASH" .. math.random(1,1000))
    SetVehicleHasBeenOwnedByPlayer(truck, true)
    local netId = NetworkGetNetworkIdFromEntity(truck)
    if Config.UseOxFuel then Entity(truck).state.fuel = 100.0 end 
    if Config.UseKeys then 
        SetNetworkIdCanMigrate(netId, true)
        SetNetworkIdExistsOnAllMachines(netId, true) 
        Wait(100)
        TriggerServerEvent('trash:givekeys', netId)
    end 
    exports['ox_target']:addLocalEntity(truck, {
        label = "Clean Bin",
        icon = "fas fa-soap",
        distance = 2.5, 
        bones = 'boot',
        onSelect = function()
            cleanBin()
        end
    })

    spawnBin()
    DoScreenFadeIn(1000)
end 

-- Blips -- 
local function AddBlips()
    local coords = Config.pedCoords
    blip = AddBlipForCoord(coords.x, coords.y, coords.z) 
    SetBlipRotation(blip, 0)
    SetBlipSprite(blip, 318)
    SetBlipColour(blip, 2)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Garbage Job") 
    EndTextCommandSetBlipName(blip)
    SetBlipDisplay(blip, 4)
end

-- Ped Spawning -- 
local pedOptions = {
    label = "Spawn Garbage Truck",
    icon = "fas fa-truck",
    distance = 3.0, 
    onSelect = function()
        if IsPedInAnyVehicle(PlayerPedId()) or vehicleSpawned then 
            return lib.notify({
                title = "You cannot spawn this vehicle!",
                type = "error"
            })
        end 
        spawnTruck()
    end,
}

local pedOptions2 = {
    {
        label = "Spawn Garbage Truck",
        icon = "fas fa-truck",
        distance = 3.0, 
        onSelect = function()
            if IsPedInAnyVehicle(PlayerPedId()) or vehicleSpawned then 
                return lib.notify({
                    title = "You cannot spawn this vehicle!",
                    type = "error"
                })
            end 

            if Config.requireOutfit then 
                if not outfitSet then 
                    return lib.notify({
                        title = "Put on your uniform!",
                        type = "error"
                    })
                end 
            end 

            spawnTruck()
        end,
    },
    {
        label = "Change Outfits",
        icon = "fas fa-shirt",
        distance = 3.0,
        onSelect = function()
            if outfitSet then 
                restoreOutfit()
                return
            end 

            saveOutfit()
            setOutfit()
        end,
    }
}

local function spawnPeds() 
    if DoesEntityExist(ped) then return end 
        local pedName = Config.pedName
        local pedCoords = Config.pedCoords 
        local pedHeading = Config.pedHeading
        RequestModel(GetHashKey(pedName))
        while not HasModelLoaded(GetHashKey(pedName)) do
            Wait(25)
        end
        lib.requestAnimDict(Config.pedanimDict)
        ped = CreatePed(4, pedName, pedCoords.x, pedCoords.y, pedCoords.z -1.0, pedHeading, false, false)
        SetEntityHeading(ped, pedHeading)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        StopPedSpeaking(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskPlayAnim(ped,Config.pedanimDict,Config.pedanimClip, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
        if Config.changeOutfit then 
            exports['ox_target']:addLocalEntity(ped, pedOptions2)
        else 
        exports['ox_target']:addLocalEntity(ped, pedOptions)
        end
        RemoveAnimDict(Config.pedanimDict)
end 

-- Return Points --
local function ReturnTruck()
    if not vehicleSpawned then return end 
    DeleteVehicle(truck)
    exports['ox_target']:removeLocalEntity(truck)
    vehicleSpawned = false 
    truck = nil 

    if Config.changeOutfit then 
        restoreOutfit()
    end 

    local payout = Config.Bond + pay 
    TriggerServerEvent('trash:addmoney', payout, "Garbage Truck Bond + Wages")
    lib.notify({
        title = "Truck Returned",
        type = 'success'
    })
end

local function DrawText3D(x, y, z, text, scale, r, g, b, a)

    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
 
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(r, g, b, a)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

for _, v in ipairs(Config.ReturnLocations) do 
    local returnPoint = lib.points.new({
        coords = v,
        distance = 50,
    })

    function returnPoint:nearby()
        if vehicleSpawned and GetVehiclePedIsIn(PlayerPedId()) == truck then 
        DrawMarker(39, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 3.0, 3.0, 3.0, 0, 255, 0, 50, false, true, 2, false, nil, nil, false)

        if self.currentDistance < 3.0 and IsControlJustReleased(0, 38) then
            ReturnTruck()
        end
    end
end
end


-- Misc (Cleanup) and Event Handlers -- 
local function cleanUp()
    DeletePed(ped) 
    DeleteEntity(bin) 
    DeleteEntity(truck)
    RemoveBlip(blip)
    ClearPedTasksImmediately(PlayerPedId())
    ClearGpsPlayerWaypoint()
    DeleteWaypoint()
    vehicleSpawned, propSpawned = false, false
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    spawnPeds()
    AddBlips()
  end)
  
  AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    cleanUp()
  end)