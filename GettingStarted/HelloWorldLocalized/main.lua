
-- Abstract: Hello World (Localized)
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Hello World (Localized)", showBuildNum=true } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

local translations = {
	["en"] = "Hello, world!",
	["fr"] = "Bonjour, le monde!",
	["pt"] = "Olá mundo!",
	["zh-Hant"] = "世界你好！",
	["zh-Hans"] = "世界你好！",
	["zh"] = "世界你好！",
	["de"] = "Hallo, Welt!",
	["it"] = "Salve, mondo!",
	["ja"] = "世界よ、こんにちは！",
	["es"] = "¡Hola mundo!",
	["ru"] = "Привет, мир!",
	["uk"] = "Привіт, світе!",
}

local language = system.getPreference( "locale", "language" )
-- Other localization-related system properties
-- system.getPreference( "locale", "country" )
-- system.getPreference( "locale", "identifier" )

-- Get message based on language
local message = translations[language]

-- If language isn't found in above table, default to English
if not message then
	message = translations["en"]
end

local world = display.newImageRect( mainGroup, "world.png", 250, 250 )
world.x = display.contentCenterX
world.y = display.contentCenterY - 30

-- Show text using default font of device
local msgText = display.newText( mainGroup, message, world.x, world.y+160, native.systemFont, 32 )
msgText:setFillColor( 0.2, 0.6, 0.8 )
