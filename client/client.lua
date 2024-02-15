local creationLaser = false
local editingScene = false
local scenes = {}
local sceneData = {}
local closestScenes = {}

lib.requestStreamedTextureDict("commonmenu")
lib.requestStreamedTextureDict("scenes")

local function toggleNuiFrame(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  SendReactMessage('setVisible', shouldShow)
end

RegisterNUICallback('hideFrame', function(_, cb)
  toggleNuiFrame(false)
  editingScene = false
  cb({})
end)

RegisterNUICallback('CreateScene', function(data, cb)
  toggleNuiFrame(false)
  editingScene = false
  TriggerServerEvent('fivem-scenes:server:createScene', sceneData)
  cb({})
end)

CreateThread(function()
  local admin = lib.callback.await("fivem-scenes:server:isAdmin")
  local data = {
    maxDistance = Config.MaxDistance,
    maxDuration = Config.MaxDuration,
    isAdmin = admin,
    neverExpire = Config.NeverExpire,
    neverExpireAdmin = Config.NeverExpireAdmin
  }
  SendReactMessage('setConfig', data)
  SendReactMessage('setFonts', Fonts)
end)

RegisterNUICallback('UpdateScene', function(data, cb)
  data.coords = sceneData.coords
  sceneData = data
  cb({})
end)

local function buildScenePoint(scene)
  local point = lib.points.new({
    coords = scene.coords,
    distance = Config.MaxDistance,
    sceneId = scene.id
  })
  function point:nearby()
    DrawScene(scene)
  end
end

local function rebuildScenePoints()
  local points = lib.points.getAllPoints()
  for i = 1, #points do
    points[i]:remove()
  end
  for i = 1, #scenes do
    buildScenePoint(scenes[i])
  end
end

RegisterNetEvent('fivem-scenes:client:startScenes', function()
  ToggleSceneLaser()
end)

RegisterNetEvent('fivem-scenes:client:updateAllScenes', function(data)
  scenes = data
  rebuildScenePoints()
end)

RegisterNetEvent('fivem-scenes:client:addScene', function(data)
  scenes[#scenes+1] = data
  buildScenePoint(data)
end)

RegisterNetEvent('fivem-scenes:client:removeScene', function(sceneId)
  local points = lib.points.getAllPoints()
  for i = 1, #points do
    if points[i].sceneId == sceneId then
      points[i]:remove()
    end
  end
  for i = 1, #scenes do
      if scenes[i].id == sceneId then
        table.remove(scenes, i)
      end
  end
end)

CreateThread(function()
    local data = lib.callback.await("fivem-scenes:server:getScenes")
    scenes = data

    if Config.Radial and not Config.AdminOnly then
      lib.addRadialItem({
        id = 'scenes',
        icon = 'palette',
        label = 'Scene',
        onSelect = function()
          ToggleSceneLaser()
        end
      })
    end

    if Config.EnableKeybind then
      lib.addKeybind({
        name = "Scenes",
        description = "Create/Delete scenes",
        defaultKey = Config.KeybindKey,
        onReleased = function(self)
          ToggleSceneLaser()
        end
      })
    end
    rebuildScenePoints()
end)

function ToggleSceneLaser()
  creationLaser = true
    if creationLaser then
        CreateThread(function()
            while creationLaser do
              local hit, coords = DrawLaser('PRESS ~g~E~w~ TO CREATE SCENE\nPRESS ~g~G~w~ TO DELETE SCENE', {r = 2, g = 241, b = 181, a = 200})
            
              if IsControlJustReleased(0, 38) then
                  sceneData.coords = coords
                  if hit then
                    creationLaser = false
                    EditingScene()
                    toggleNuiFrame(true)
                  else
                      lib.notify({description = "Laser did not hit anything.", type = "error"})
                  end
              elseif IsControlJustReleased(0, 47) then
                  creationLaser = false
                  DeleteScene(coords)
              end
              Wait(0)
            end
        end)
    end
end

function DeleteScene(coords)
  local closestScene = nil
  local shortestDistance = nil
  for i=1,#scenes do
      local currentScene = scenes[i]
      local distance =  #(coords - currentScene.coords)
      if distance < 1 and (shortestDistance == nil or distance < shortestDistance) then
          closestScene = currentScene.id
          shortestDistance = distance
      end
  end

  if closestScene then
     TriggerServerEvent('fivem-scenes:server:deleteScene', closestScene)
  else
    lib.notify({type = "error", description = "No scene was close enough"})
  end
end

function EditingScene()
  editingScene = true
  if editingScene then
      CreateThread(function()
        while editingScene do
          DrawScene(sceneData)
          Wait(0)
        end
    end)
  end
end

function DrawLaser(message, color)
  local hit, coords = RayCastGamePlayCamera(Config.MaxDistance)
  Draw2DText(message, 4, {255, 255, 255}, 0.4, 0.43, 0.888 + 0.025)

  if hit then
      local position = GetEntityCoords(cache.ped)
      DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
      DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.1, 0.1, 0.1, color.r, color.g, color.b, color.a, false, true, 2, nil, nil, false)
  end

  return hit, coords
end

function DrawScene(currentScene)
  local hit = false
  if Config.CheckForCollisions then
    hit = CanPlayerSeeScene(currentScene.coords)
  end
  local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(currentScene.coords.x, currentScene.coords.y, currentScene.coords.z)

  if onScreen and not hit then
      local camCoords = GetFinalRenderedCamCoord()
      local distance = #(currentScene.coords - camCoords)
      local fov = (1 / GetGameplayCamFov()) * 75
      local scale = (1 / distance) * (4) * fov * (currentScene.fontSize or 1)
      local r,g,b=rgbToHex(currentScene.colour or "#ffffff")
      local text = currentScene.text

      SetTextScale(0.0, scale)
      SetTextFont(currentScene.font or 0)
      SetTextColour(r, g, b, 255)
      SetTextProportional(true)
      SetTextWrap(0.0, 1.0)
      SetTextCentre(true)

      if currentScene.shadow then
        SetTextDropshadow(1, 255, 255, 255, 0)
      end

      if currentScene.outline then
        SetTextOutline()
      end

      BeginTextCommandGetWidth("STRING")
      AddTextComponentString(text ~= "" and text or "Example Text")

      local H = GetRenderedCharacterHeight(scale, currentScene.font)+0.0030
      local W = EndTextCommandGetWidth(currentScene.font)+0.005

      BeginTextCommandDisplayText("STRING")
      AddTextComponentString(text ~= "" and text or "Example Text")
      EndTextCommandDisplayText(screenX, screenY)

      if currentScene.background and currentScene.background ~= "none" then
        local br, bg, bb = rgbToHex(currentScene.backgroundColour)

        DrawSprite("scenes", currentScene.background, screenX+currentScene.backgroundX*scale, screenY+currentScene.backgroundY*scale, W+currentScene.backgroundWidth*scale, H+currentScene.backgroundHeight*scale, 0, br,bg,bb, currentScene.backgroundAlpha)
      end
  end
end