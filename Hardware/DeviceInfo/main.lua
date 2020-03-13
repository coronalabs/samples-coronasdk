
-- Abstract: DeviceInfo
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Device Info", showBuildNum=true } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Set app font
local appFont = sampleUI.appFont

local y = sampleUI.titleBarBottom + 10
local yOffset = 25  -- Vertical offset between fields
local labelX = 140  -- Right edge point for all labels
local valueX = 155  -- Left edge point for all values
display.setDefault( "anchorX", 1.0 )
display.setDefault( "fillColor", 1, 0.7, 0.35 )

-- Output labels
local itemLabel = display.newText( mainGroup, "name", labelX, y+yOffset*1, appFont, 16 )
itemLabel = display.newText( mainGroup, "manufacturer", labelX, y+yOffset*2, appFont, 16 )
itemLabel = display.newText( mainGroup, "model", labelX, y+yOffset*3, appFont, 16 )
itemLabel = display.newText( mainGroup, "environment", labelX, y+yOffset*4, appFont, 16 )
itemLabel = display.newText( mainGroup, "platform", labelX, y+yOffset*5, appFont, 16 )
itemLabel = display.newText( mainGroup, "platform version", labelX, y+yOffset*6, appFont, 16 )
itemLabel = display.newText( mainGroup, "version (Corona)", labelX, y+yOffset*7, appFont, 16 )
itemLabel = display.newText( mainGroup, "build (Corona)", labelX, y+yOffset*8, appFont, 16 )
itemLabel = display.newText( mainGroup, "language", labelX, y+yOffset*9, appFont, 16 )
itemLabel = display.newText( mainGroup, "country", labelX, y+yOffset*10, appFont, 16 )
itemLabel = display.newText( mainGroup, "locale", labelX, y+yOffset*11, appFont, 16 )
itemLabel = display.newText( mainGroup, "language code", labelX, y+yOffset*12, appFont, 16 )
itemLabel = display.newText( mainGroup, "target store", labelX, y+yOffset*13, appFont, 16 )
itemLabel = display.newText( mainGroup, "device ID", display.contentCenterX, y+yOffset*15-10, appFont, 16 )
itemLabel:setFillColor( 1, 0.4, 0.25 )
itemLabel.anchorX = 0.5

display.setDefault( "fillColor", 1, 1, 1 )
display.setDefault( "anchorX", 0.0 )

-- Output values (call "system.getInfo()" to set the field values)
local itemText = display.newText( mainGroup, system.getInfo( "name" ), valueX, y+yOffset*1, appFont, 16 )
itemText = display.newText( mainGroup, system.getInfo( "manufacturer" ), valueX, y+yOffset*2, appFont, 16 )
itemText = display.newText( mainGroup, system.getInfo( "model" ), valueX, y+yOffset*3, appFont, 16 )
itemText = display.newText( mainGroup, system.getInfo( "environment" ), valueX, y+yOffset*4, appFont, 16 )
itemText = display.newText( mainGroup, system.getInfo( "platform" ), valueX, y+yOffset*5, appFont, 16 )
itemText = display.newText( mainGroup, system.getInfo( "platformVersion" ), valueX, y+yOffset*6, appFont, 16 )
itemText = display.newText( mainGroup, system.getInfo( "version" ), valueX, y+yOffset*7, appFont, 16 )
itemText = display.newText( mainGroup, system.getInfo( "build" ), valueX, y+yOffset*8, appFont, 16 )
itemText = display.newText( mainGroup, system.getPreference( "ui", "language" ), valueX, y+yOffset*9, appFont, 16 )
itemText = display.newText( mainGroup, system.getPreference( "locale", "country" ), valueX, y+yOffset*10, appFont, 16 )
itemText = display.newText( mainGroup, system.getPreference( "locale", "identifier" ), valueX, y+yOffset*11, appFont, 16 )
itemText = display.newText( mainGroup, system.getPreference( "locale", "language" ), valueX, y+yOffset*12, appFont, 16 )
itemText = display.newText( mainGroup, system.getInfo( "targetAppStore" ), valueX, y+yOffset*13, appFont, 16 )
itemText = display.newText( mainGroup, system.getInfo( "deviceID" ), display.contentCenterX, y+yOffset*15+12, appFont, 14 )
itemText.anchorX = 0.5

display.setDefault( "anchorX", 0.5 )

--[[
print( " \nSYSTEM INFORMATION" )
local platform = system.getInfo("platform")
if platform == "android" then
	print("androidApiLevel: " .. tostring(system.getInfo("androidApiLevel")))
	print("androidAppVersionCode: " .. tostring(system.getInfo("androidAppVersionCode")))
	print("androidAppPackageName: " .. tostring(system.getInfo("androidAppPackageName")))
	print("androidGrantedAppPermissions: " .. tostring(system.getInfo("androidGrantedAppPermissions")))
	print("androidDeniedAppPermissions: " .. tostring(system.getInfo("androidDeniedAppPermissions")))
	print("androidDisplayApproximateDpi: " .. tostring(system.getInfo("androidDisplayApproximateDpi")))
	print("androidDisplayDensityName: " .. tostring(system.getInfo("androidDisplayDensityName")))
	print("androidDisplayWidthInInches: " .. tostring(system.getInfo("androidDisplayWidthInInches")))
	print("androidDisplayHeightInInches: " .. tostring(system.getInfo("androidDisplayHeightInInches")))
	print("androidDisplayXDpi: " .. tostring(system.getInfo("androidDisplayXDpi")))
	print("androidDisplayYDpi: " .. tostring(system.getInfo("androidDisplayYDpi")))
elseif platform == "ios" then
	print("iosIdentifierForVendor: " .. tostring(system.getInfo("iosIdentifierForVendor")))
end
print("appName: " .. tostring(system.getInfo("appName")))
print("appVersionString: " .. tostring(system.getInfo("appVersionString")))
print("architectureInfo: " .. tostring(system.getInfo("architectureInfo")))
print("build: " .. tostring(system.getInfo("build")))
print("deviceID: " .. tostring(system.getInfo("deviceID")))
print("environment: " .. tostring(system.getInfo("environment")))
print("GL_VENDOR: " .. tostring(system.getInfo("GL_VENDOR")))
print("GL_RENDERER: " .. tostring(system.getInfo("GL_RENDERER")))
print("GL_VERSION: " .. tostring(system.getInfo("GL_VERSION")))
print("GL_SHADING_LANGUAGE_VERSION: " .. tostring(system.getInfo("GL_SHADING_LANGUAGE_VERSION")))
print("GL_EXTENSIONS: " .. tostring(system.getInfo("GL_EXTENSIONS")))
print("gpuSupportsHighPrecisionFragmentShaders: " .. tostring(system.getInfo("gpuSupportsHighPrecisionFragmentShaders")))
print("isoCountryCode: " .. tostring(system.getInfo("isoCountryCode")))
print("isoLanguageCode: " .. tostring(system.getInfo("isoLanguageCode")))
print("manufacturer: " .. tostring(system.getInfo("manufacturer")))
print("model: " .. tostring(system.getInfo("model")))
print("name: " .. tostring(system.getInfo("name")))
print("platform: " .. tostring(system.getInfo("platform")))
print("platformVersion: " .. tostring(system.getInfo("platformVersion")))
print("maxTextureSize: " .. tostring(system.getInfo("maxTextureSize")))
print("targetAppStore: " .. tostring(system.getInfo("targetAppStore")))
print("textureMemoryUsed: " .. tostring(system.getInfo("textureMemoryUsed")))
print("version: " .. tostring(system.getInfo("version")))
--]]
