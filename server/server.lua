lib.versionCheck('SamShanks1/fivem-scenes')

local scenes = {}

local function countScenes(identifier)
    local count = 0
    for i = 1, #scenes do
        if scenes[i].owner == identifier then
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
    if Config.log then
        lib.logger(src, 'CreateScene', json.encode(sceneData))
    end
    local count = countScenes(identifier)
    if count > Config.MaxScenes then
        return TriggerClientEvent('ox_lib:notify', src, {type = "error", description = "You have exceed the max scene count"})
    end
    sceneData.owner = identifier
    scenes[#scenes+1] = sceneData
    TriggerClientEvent('fivem-scenes:client:newScene', -1, sceneData)
end)

lib.callback.register('fivem-scenes:server:getScenes', function()
    return scenes
end)