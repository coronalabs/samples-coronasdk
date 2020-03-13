-- 
-- Abstract: Status Bar sample app
-- 
-- Version: 1.2
-- 
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.


-- Demonstrates different status bar and androidSystemUiVisibility settings
-- https://docs.coronalabs.com/api/library/display/setStatusBar.html
-- https://docs.coronalabs.com/api/library/native/setProperty.html#android-system-ui-visibility
------------------------------------------------------------



local environment = system.getInfo("environment") 
local platform = system.getInfo("platform")

local background = display.newRect(display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
background:setFillColor( 0.5 )


-- This is only supported on iOS (simulated or device) or Android (device only)
if platform == "ios" or (platform == "android" and environment ~= "simulator") then

	local widget = require "widget"


	-- Create text object to display current status bar mode
	local statusBarState = display.newText( "None set, default", display.contentCenterX, 50, nil, 20 )

	-- This table connects string id to actual status bar mode
	local statusBarModes = {
		["display.HiddenStatusBar"] = display.HiddenStatusBar,
		["display.DefaultStatusBar"] = display.DefaultStatusBar,
		["display.DarkStatusBar"] = display.DarkStatusBar,
		["display.TranslucentStatusBar"] = display.TranslucentStatusBar,
		["display.LightTransparentStatusBar"] = display.LightTransparentStatusBar,
		["display.DarkTransparentStatusBar"] = display.DarkTransparentStatusBar,
	}

	-- When button is pressed, set status bar mode text and mode
	local function changeStatusBar( event )
		local id = event.target.id
		statusBarState.text = id
		display.setStatusBar( statusBarModes[id] )
	end


	-- Create buttons which would switch to status bar mode stored in id
	widget.newButton({
		label = "Hidden",
		id = "display.HiddenStatusBar",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 115,
		width = 278,
		height = 32,
		fontSize = 15,
		fillColor = { default={ 0.08,0.28,0.48,1 }, over={ 0.08,0.28,0.48,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = changeStatusBar,
	})

	widget.newButton({
		label = "Default",
		id = "display.DefaultStatusBar",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 155,
		width = 278,
		height = 32,
		fontSize = 15,
		fillColor = { default={ 0.1,0.3,0.5,1 }, over={ 0.1,0.3,0.5,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = changeStatusBar,
	})

	widget.newButton({
		label = "Light Transparent",
		id = "display.LightTransparentStatusBar",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 195,
		width = 278,
		height = 32,
		fontSize = 15,
		fillColor = { default={ 0.12,0.32,0.52,1 }, over={ 0.12,0.32,0.52,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = changeStatusBar
	})	

	widget.newButton({
		label = "Dark Transparent",
		id = "display.DarkTransparentStatusBar",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 235,
		width = 278,
		height = 32,
		fontSize = 15,
		fillColor = { default={ 0.14,0.34,0.54,1 }, over={ 0.14,0.34,0.54,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = changeStatusBar
	})

	widget.newButton({
		label = "Dark (legacy)",
		id = "display.DarkStatusBar",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 275,
		width = 278,
		height = 32,
		fontSize = 15,
		fillColor = { default={ 0.16,0.36,0.56,1 }, over={ 0.16,0.36,0.56,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = changeStatusBar
	})

	widget.newButton({
		label = "Translucent (legacy)",
		id = "display.TranslucentStatusBar",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 315,
		width = 278,
		height = 32,
		fontSize = 15,
		fillColor = { default={ 0.18,0.38,0.58,1 }, over={ 0.18,0.38,0.58,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = changeStatusBar
	})

	-- Android have 'androidSystemUiVisibility' options, which would change how status bar looks like
	-- This can be set with native.setProperty() function
	if platform == 'android' then

		local systemUIVisibility = nil

		-- When 'androidSystemUiVisibility' buttons are pressed, select ui mode and create/change display text
		local function changeAndroidSystemUI( event )
			local id = event.target.id

			if not systemUIVisibility then
				systemUIVisibility = display.newText( id, display.contentCenterX, 75, appFont, 16 )
				systemUIVisibility:setFillColor( 0.7 )
			else
				systemUIVisibility.text = id
			end

			native.setProperty( "androidSystemUiVisibility", id )
		end


		-- Title text for androidSystemUiVisibility
		display.newText({
			text = 'androidSystemUiVisibility:',
			x = display.contentCenterX,
			y = 360,
			width = 278,
			height = 32,
			fontSize = 18,
		})

		-- Buttons to change Android System UI. Mode is stored in button's id
		widget.newButton({
			label = "default",
			id = "default",
			shape = "rectangle",
			x = 89,
			y = 395,
			width = 136,
			height = 32,
			fontSize = 15,
			fillColor = { default={ 0.22,0.42,0.62,1 }, over={ 0.22,0.42,0.62,1 } },
			labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
			onRelease = changeAndroidSystemUI
		})

		widget.newButton({
			label = "lowProfile",
			id = "lowProfile",
			shape = "rectangle",
			x = 231,
			y = 395,
			width = 136,
			height = 32,
			fontSize = 15,
			fillColor = { default={ 0.22,0.42,0.62,1 }, over={ 0.22,0.42,0.62,1 } },
			labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
			onRelease = changeAndroidSystemUI
		})

		widget.newButton({
			label = "immersiveSticky",
			id = "immersiveSticky",
			shape = "rectangle",
			x = 89,
			y = 435,
			width = 136,
			height = 32,
			fontSize = 15,
			fillColor = { default={ 0.22,0.42,0.62,1 }, over={ 0.22,0.42,0.62,1 } },
			labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
			onRelease = changeAndroidSystemUI
		})

		widget.newButton({
			label = "immersive",
			id = "immersive",
			shape = "rectangle",
			x = 231,
			y = 435,
			width = 136,
			height = 32,
			fontSize = 15,
			fillColor = { default={ 0.22,0.42,0.62,1 }, over={ 0.22,0.42,0.62,1 } },
			labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
			onRelease = changeAndroidSystemUI
		})
	end
else
	local msg = display.newText( {
		text = "Statusbar mode not supported on this platform.\n\nTry simulating iOS Device or building for a mobile platform.",
		x = display.contentCenterX,
		y = display.contentCenterY,
		width = display.viewableContentWidth*0.95,
		font = native.systemFontBold,
		fontSize = 20,
		align = "center",
	} )
	msg:setFillColor( 1, 0, 0 )
	
end

