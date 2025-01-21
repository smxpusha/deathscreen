Config = {}

-- Debug Mode
Config.Debug = false -- Enable or disable debug mode (true/false)

-- Framework Configuration
Config.Framework = "qbcore" -- Choose framework: "esx", "qbcore", or "standalone"

-- General Settings
Config.BleedOutTimer = 780 -- Time until bleed out, in seconds
Config.RespawnShowTimer = 180 -- Time left until the player can respawn, in seconds
Config.BleedOutRemoveMoney = true -- Should money be removed on respawn (true/false)
Config.BleedOutPrice = 500 -- Amount of money to remove on respawn
Config.RespawnCoords = { -- Coordinates where players respawn
    x = 298.7508, 
    y = -1440.6846, 
    z = 29.7929, 
    heading = 44.1302
}

-- Key Bindings
Config.KeyBinds = {
    Respawn = "E",    -- Key to respawn
    Dispatch = "G",   -- Key to send dispatch signal
    Sync = "U"        -- Key to sync
}

-- Distress Signal Configuration
function DistressSignalTrigger()
    print('Add your trigger or export here')
end

function RespawnTrigger()
    if Config.Framework == 'esx' then
        SendNUIMessage({type = "show", status = false})
        SetNuiFocus(false, false)
        TriggerEvent('smx-deathscreen:client:remove_revive')
        if Config.BleedOutRemoveMoney then 
            ESX.TriggerServerCallback("smx-deathscreen:server:removeMoney")
            ESX.ShowNotification((Config.Translation.MoneyRemoved):format(Config.BleedOutPrice))
        end
    elseif Config.Framework == 'qbcore' then
        SendNUIMessage({type = "show", status = false})
        SetNuiFocus(false, false)
        TriggerEvent('smx-deathscreen:client:remove_revive')
        if Config.BleedOutRemoveMoney then 
            QBCore.Functions.TriggerCallback("smx-deathscreen:server:removeMoney")
            QBCore.Functions.Notify((Config.Translation.MoneyRemoved):format(Config.BleedOutPrice), 'primary', 5000)
        end
    end
end

function onPlayerDeath()
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

function checkdeathstatus()
    if Config.Framework == "esx" then
        AddEventHandler('esx:onPlayerDeath', onPlayerDeath)
        AddEventHandler('esx:onPlayerSpawn', HideUI)
    elseif Config.Framework == "qbcore" then
        RegisterNetEvent('QBCore:Player:SetPlayerData', function(data)
            if (data.metadata.isdead or data.metadata.inlaststand) then
                onPlayerDeath()
            else
                HideUI()
            end
        end)
    else 
        print('Fix this if you are using standalone frameworks')
    end
end

exports("OpenDeathUI", function()
    return ShowDeathScreenUI()
end)

exports("CloseDeathUI", function()
    return HideDeathScreenUI()
end)

Config.Translation = {
    Dead = "YOU ARE DEAD",                       -- Message displayed when player dies
    DeadDisc = "YOUR TIME PASS AWAY",            -- Description when dead
    Respawn = "RESPAWN",                         -- Respawn button text
    Dispatch = "DISPATCH",                       -- Dispatch button text
    Sync = "SYNC",                               -- Sync button text
    MoneyRemoved = "You have been charged $%s for accepting to die early" -- Message when money is deducted on respawn
}
