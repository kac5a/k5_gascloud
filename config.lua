Config = {}
Locale = {}

Config.RemoveMaskKey = 244 --"M" by default

-------------------------------------------------
-------- Safe Zone and circle properties --------
-------------------------------------------------
Config.SafeZone = {
  center = vector3(-88.055053710938, -1270.5104980469, 0),
  size = 2000.0,
  blipColor = 7,
  markerColor={ r = 200, g = 164, b = 237, a = 100}
}

-------------------------------------------------
------------------- Mask types ------------------
-------------------------------------------------
Config.Masks = {
  ['bandana'] = { -- Item name. These have to match the items in your database/shared.lua/items.lua
    capacity = 100, -- Mask capacity in seconds (depends on 'Config.Gas.tick'. The lower the tick, the faster the capacity decreases)
    componentId_male = 51, -- Male mask component
    componentId_female = 55 -- Female mask component
  },
  ['gasmask'] = {
    capacity = 300,
    componentId_male = 38,
    componentId_female = 40
  },
}

-------------------------------------------------
---------------- Gas properties -----------------
-------------------------------------------------
Config.Gas = {
  tick = 1000, -- How often should the gas damage the player in ms (Default: 1s)
  damage = 1, -- Gas damage per tick
  effect = "michealspliff"-- The visual effect in the gas area
}

-------------------------------------------------
----------------- Localozation ------------------
-------------------------------------------------
Locale = {
  safeZoneBlipName = "Safe Zone",
  removeMaskNotification = "You removed your protection",
  alreadyWearMask = "You already wear protection",
  removeHelperText = "Press [M] to remove your protection"
}