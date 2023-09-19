Config = {}

Config.MaxDistance = 25 --max distance that can be placed & viewed, passed to UI for view distance
Config.Log = false --logs the scene creation and deletion with ox_lib logging
Config.MaxScenes = 999 --max scenes that can be placed
Config.Radial = false --add scene management to ox_lib radial menu | AdminOnly must be false
Config.AdminOnly = false --only admins can create scenes
Config.AdminDeleteAll = true --admins can delete other peoples scenes
Config.AceGroup = 'admin' --if AdminOnly or AdminDeleteAll is set to true the ace group the command will be locked too
Config.EnableKeybind = false --allow scenes menu to be opened via keybind
Config.KeybindKey = "K" --if EnableKeybind is set to true the key to use, if you change this it will only change for new players
Config.MaxDuration = 50 --max duration the scene can be set in hours
Config.NeverExpire = false --set this to true for an option that scenes never expire in the UI and they will not be deleted from db
Config.NeverExpireAdmin = true --if set to true then you have to be an admin to see the NeverExpire option if true
Config.CheckForCollisions = false --enable this to check for collisions