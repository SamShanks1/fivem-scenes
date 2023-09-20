lib.versionCheck('SamShanks1/fivem-scenes')

local scenes = {}

local group = ('group.%s'):format(Config.AceGroup)
local restrictedGroup = Config.AdminOnly and group

lib.addCommand('scene', {
    help = 'Create/Delete a scene',
    restricted = restrictedGroup
}, function(source, args, raw)
    TriggerClientEvent('fivem-scenes:client:startScenes', source)
end)

--Credit https://github.com/ItsANoBrainer/qb-scenes/blob/master/server/server.lua

local function updateAllScenes()
    scenes = {}
    MySQL.Async.fetchAll('SELECT * FROM scenes', {}, function(result)
        if result[1] then
            for _, v in pairs(result) do
                local sceneData = json.decode(v.data)
                sceneData.id = v.id
                sceneData.coords = vector3(sceneData.coords.x, sceneData.coords.y, sceneData.coords.z)
                scenes[#scenes+1] = sceneData
            end
        end
        TriggerClientEvent('fivem-scenes:client:updateAllScenes', -1, scenes)
    end)
end

local function deleteExpiredScenes()
    if Config.NeverExpire then
        MySQL.Async.execute('DELETE FROM scenes WHERE deleteAt < NOW() AND `neverExpire` = 0', {}, function(result)
            if result > 0 then
                print('Deleted '..result..' expired scenes from the database.')
                updateAllScenes()
            end
        end)
    else
        MySQL.Async.execute('DELETE FROM scenes WHERE deleteAt < NOW()', {}, function(result)
            if result > 0 then
                print('Deleted '..result..' expired scenes from the database.')
                updateAllScenes()
            end
        end)
    end
end

local function countScenes(identifier)
    local count = 0
    for i = 1, #scenes do
        if scenes[i].creator == identifier then
            count = count+1
        end
    end
    return count
end

local function getIdentifier(source)
    for _, v in pairs(GetPlayerIdentifiers(source)) do
        if v:sub(1, #"license:") == "license:" then
            return v
        end
    end
end

RegisterNetEvent('fivem-scenes:server:createScene', function(sceneData)
    local src = source
    local identifier = getIdentifier(src)
    local count = countScenes(identifier)
    if count > Config.MaxScenes then
        return TriggerClientEvent('ox_lib:notify', src, {type = "error", description = "You have exceed the max scene count"})
    end
    sceneData.creator = identifier
    MySQL.Async.insert('INSERT INTO scenes (creator, data, createdAt, deleteAt, neverExpire) VALUES (?, ?, NOW(), DATE_ADD(NOW(), INTERVAL ? HOUR), ?)', {
        identifier, json.encode(sceneData), sceneData.duration, sceneData.neverExpire
    }, function(id)
        sceneData.id = id
        if Config.Log then
            lib.logger(src, 'CreateScene', json.encode(sceneData))
        end
        scenes[#scenes+1] = sceneData
        TriggerClientEvent('fivem-scenes:client:addScene', -1, sceneData)
    end) 
end)

RegisterNetEvent('fivem-scenes:server:deleteScene', function(sceneId)
    local src = source
    local identifier = getIdentifier(src)
    local canDelete = false
    local scenePos

    for i = 1, #scenes do 
        if scenes[i].creator == identifier then
            canDelete = true
            scenePos = i
        end
    end

    if IsPlayerAceAllowed(src, Config.AceGroup) then
        canDelete = true
    end

    if not canDelete then
        return TriggerClientEvent('ox_lib:notify', src, {type = "error", description = "You did not create this scene"})
    end

    MySQL.Async.execute('DELETE FROM scenes WHERE id = ?', {sceneId}, function()
        if Config.Log then
            lib.logger(src, 'DeleteScene', scenes[scenePos])
        end
        table.remove(scenes, scenePos)
        TriggerClientEvent('fivem-scenes:client:removeScene', -1, sceneId)
        TriggerClientEvent('ox_lib:notify', src, {type = "success", description = "Scene Deleted"})
    end)

end)

lib.callback.register('fivem-scenes:server:getScenes', function()
    return scenes
end)


lib.callback.register('fivem-scenes:server:isAdmin', function(source)
    return IsPlayerAceAllowed(source, Config.AceGroup)
end)

CreateThread(function()
    updateAllScenes()
end)

lib.cron.new('* */' .. Config.AuditInterval .. ' * * *', function()
    deleteExpiredScenes()
end)
