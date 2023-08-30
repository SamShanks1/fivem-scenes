Config = {}

Config.MaxDistance = 25 --max distance that can be placed & viewed, passed to UI for view distance
Config.Log = false --logs the scene creation and deletion with ox_lib logging
Config.MaxScenes = 999 --max scenes that can be placed
Config.Radial = false --add scene management to ox_lib radial menu | AdminOnly must be false
Config.AdminOnly = false --only admins can create scenes
Config.AdminDeleteAll = true --admins can delete other peoples scenes
Config.AceGroup = 'group.admin' --if AdminOnly or AdminDeleteAll is set to true the ace group the command will be locked too
