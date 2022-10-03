Config = {}

--[[
    menu position
    'top-left' or 'top-right' or 'bottom-left' or 'bottom-right'
]]
Config.menuAlign = 'bottom-right'

--[[
    "playerTable"
        The table in which your user information is stored.
        At a minimum, it needs to contain player's identifier and a phone number column.
    "identifierColumn"
        Found within your playerTable
    "phoneNumberColumn"
        The column where phone numbers are stored.
]]

Config.Database = {
    playerTable = 'users',
    identifierColumn = 'identifier',
    phoneNumberColumn = 'phone_number'
}


Config.DrawDistance = 10.0
Config.InteractDistance = 5
Config.DuplicatePosition = vec3(-1082.14, -247.58, 37.76-0.90)

Config.MarkerSize   = {x = 1.5, y = 1.5, z = 1.0001}
Config.MarkerColor  = {r = 106, g = 28, b = 116}
Config.MarkerType   = 23

Config.InteractKey = 38