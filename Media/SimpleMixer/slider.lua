-- 
-- Abstract: slider component
-- 
-- Version: 0.1
-- To make your own sliders, please use the widget library: https://docs.coronalabs.com/api/library/widget/newSlider.html
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
-- TODO
-- setvalue
-- values = { }
-- documentation
-- margins

module(..., package.seeall)

local function newSliderHandler( self, event )

	local result = true

--	local default = self[1]
--	local over = self[2]
	
	-- General "onEvent" function overrides onPress and onRelease, if present
	local onEvent = self._onEvent
	
	local onPress = self._onPress
	local onRelease = self._onRelease

	local sliderEvent = { value = self.value }
	if (self._id) then
		sliderEvent.id = self._id
	else
		sliderEvent.id = 0
	end

	local phase = event.phase
	if "began" == phase then
		if self.thumbOver then 
			self.thumbDefault.isVisible = false
			self.thumbOver.isVisible = true
		end

		if onEvent then
			sliderEvent.phase = "press"
			result = onEvent( sliderEvent )
		elseif onPress then
			result = onPress( event )
		end

		-- Subsequent touch events will target slider even if they are outside the stageBounds of slider
		display.getCurrentStage():setFocus( self, event.id )
		self.isFocus = true
		
	elseif self.isFocus then
		local bounds = self.stageBounds
		local oldValue = self.value

		-- find new position of thumb
		if self.isVertical then
			local y = event.y - self.y
			
			if y < self.thumbMin then
				y = self.thumbMin
			end
			if y > self.thumbMax then
				y = self.thumbMax
			end
			self.thumbDefault.y = y
			self.thumbOver.y = y
        print ("thumb value: " .. y)
			
			self.value = (((y - self.thumbMin) / (self.thumbMax - self.thumbMin)) * self.range) + self.minValue
		else
			local x = event.x - self.x
			
--			print("x=" .. x .. " min=" .. self.thumbMin .. " max=" .. self.thumbMax .. " " .. self.x)
			if x < self.thumbMin then
				x = self.thumbMin
			end
			if x > self.thumbMax then
				x = self.thumbMax
			end
			self.thumbDefault.x = x
			self.thumbOver.x = x

			self.value = (((x - self.thumbMin) / (self.thumbMax - self.thumbMin)) * self.range) + self.minValue
		end

		sliderEvent.value = self.value

		if "moved" == phase then
        
			if self.value ~= oldValue then
				if onEvent then
					sliderEvent.phase = "moved"
					result = onEvent( sliderEvent )
				end
			end
		elseif "ended" == phase or "cancelled" == phase then 
			if self.thumbOver then 
				self.thumbDefault.isVisible = true
				self.thumbOver.isVisible = false
			end
			
			if "ended" == phase then
				if onEvent then
					sliderEvent.phase = "release"
					result = onEvent( sliderEvent )
				elseif onRelease then
					result = onRelease( event )
				end
			end
			
			-- Allow touch events to be sent normally to the objects they "hit"
			display.getCurrentStage():setFocus( self, nil )
			self.isFocus = false
		end
	end

	return result
end

-- newSlider( params )
-- where params is a table containing:
--		track			- name of track image
--		thumbDefault	- name of default thumb image
--		thumbOver		- name of thumb over image (optional)
--		minValue		- min value (optional, defaults to 0)
--		maxValue		- max value (optional, defaults to 100)
--		value			- initial value (optional, defaults to minValue)
--		isInteger		- true if integer, false if real (continuous value) (defaults to false)
--		isVertical		- true if vertical; otherwise is horizontal (defaults to horizontal)
--		onPress			- function to call when slider is pressed
--		onRelease		- function to call when slider is released
--		onEvent			- function to call when an event occurs
--  
function newSlider( params )
	local slider
	
	slider = display.newGroup()

	if params.track then
		slider.track = display.newImage( params.track )
		slider:insert( slider.track, true )
	end
	
	if params.thumbDefault then
		slider.thumbDefault = display.newImage( params.thumbDefault )
		slider:insert( slider.thumbDefault, true )
	end
	
	if params.thumbOver then
		slider.thumbOver = display.newImage( params.thumbOver )
		slider.thumbOver.isVisible = false
		slider:insert( slider.thumbOver, true )
	end
	
	if ( params.maxValue ~= nil ) then
		slider.maxValue = params.maxValue
	else
		slider.maxValue = 100
	end
	if ( params.minValue ~= nil ) then
		slider.minValue = params.minValue
	else
		slider.minValue = 0
	end

	slider.range = slider.maxValue - slider.minValue
	
	if ( params.value ~= nil ) then
		slider.value = params.value
	else
		slider.value = slider.minValue
	end
	if ( params.isInteger == true ) then
		slider.isInteger = true
	else
		slider.isInteger = false
	end
	if ( params.isVertical == true ) then
		slider.isVertical = true
	else
		slider.isVertical = false
	end
	if ( params.onPress and ( type(params.onPress) == "function" ) ) then
		slider._onPress = params.onPress
	end
	if ( params.onRelease and ( type(params.onRelease) == "function" ) ) then
		slider._onRelease = params.onRelease
	end	
	if (params.onEvent and ( type(params.onEvent) == "function" ) ) then
		slider._onEvent = params.onEvent
	end
		
	-- calculate thumb extents
	local trackBounds = slider.track.stageBounds
	local thumbBounds = slider.thumbDefault.stageBounds
	if slider.isVertical then
		slider.thumbMin = trackBounds.yMin - thumbBounds.yMin
		slider.thumbMax = trackBounds.yMax - thumbBounds.yMax
	else
--		print( slider.thumbDefault.x .. " " .. thumbBounds.xMin .. " " .. trackBounds.xMin .. " " .. trackBounds.xMax .. " " .. thumbBounds.xMax .. " " .. slider.thumbDefault.x )
		slider.thumbMin = trackBounds.xMin - thumbBounds.xMin
		slider.thumbMax = trackBounds.xMax - thumbBounds.xMax
	end

	-- Set slider as a table listener by setting a table method and adding the slider as its own table listener for "touch" events
	slider.touch = newSliderHandler
	slider:addEventListener( "touch", slider )

	if params.x then
		slider.x = params.x
	end
	
	if params.y then
		slider.y = params.y
	end
	
	if params.id then
		slider._id = params.id
	end

	return slider
end
