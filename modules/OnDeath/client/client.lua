local function onPlayerDeath()
    TriggerEvent('smx-deathscreen:client:setDeathStatus', true)
    SendNUIMessage({type = "show", status = true})
    SetNuiFocus(true, true)

    SendNUIMessage({
        type = 'setUPValues', 
        timer = Config.BleedOutTimer,
        dead = Config.Translation.Dead,
        deaddisc = Config.Translation.DeadDisc,
        respawn = Config.Translation.Respawn,
        dispatch = Config.Translation.Dispatch,
        sync = Config.Translation.Sync,
        respawnkey = Config.KeyBinds.Respawn,
        dispatchkey = Config.KeyBinds.Dispatch,
        synckey = Config.KeyBinds.Sync,
        respawntimer = Config.RespawnShowTimer
    })
end

RegisterNetEvent('smx-deathscreen:client:onPlayerDeath', onPlayerDeath)

function HideDeathScreenUI()
    SendNUIMessage({type = "show", status = false})
    SetNuiFocus(false, false)
end

function ShowDeathScreenUI()
    SendNUIMessage({type = "show", status = true})
    SetNuiFocus(true, true)
    TriggerEvent('smx-deathscreen:client:setDeathStatus', true)

    SendNUIMessage({
        type = 'setUPValues', 
        timer = Config.BleedOutTimer,
        dead = Config.Translation.Dead,
        deaddisc = Config.Translation.DeadDisc,
        respawn = Config.Translation.Respawn,
        dispatch = Config.Translation.Dispatch,
        sync = Config.Translation.Sync,
        respawnkey = Config.KeyBinds.Respawn,
        dispatchkey = Config.KeyBinds.Dispatch,
        synckey = Config.KeyBinds.Sync,
        respawntimer = Config.RespawnShowTimer
    })
end

RegisterNetEvent('smx-deathscreen:client:hide_ui', HideUI)

RegisterNuiCallback("accept_to_die", function(data)
    RespawnTrigger()
end)

RegisterNuiCallback("call_emergency", function(data)
    DistressSignalTrigger()
end)

RegisterNUICallback("sync", function(data, cb)
    local playerPed = PlayerPedId()
    
    local currentCoords = GetEntityCoords(playerPed)

    print(string.format("Current Coordinates: x=%.2f, y=%.2f, z=%.2f", currentCoords.x, currentCoords.y, currentCoords.z))

    if currentCoords and currentCoords.x and currentCoords.y and currentCoords.z then
        
        SetEntityCoords(playerPed, currentCoords.x, currentCoords.y, currentCoords.z, false, false, false, true)

        if currentCoords.heading then
            SetEntityHeading(playerPed, currentCoords.heading)
        end
    end
end)

RegisterNuiCallback("time_expired", function(data)
    SetNuiFocus(false, false)
    TriggerEvent('smx-deathscreen:client:remove_revive')
end)
