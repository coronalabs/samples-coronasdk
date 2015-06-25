-- 
-- Abstract: animated sprite or "movieclip" library
-- This library assembles animation sequences from individual image files. For more advanced 
-- texture memory handling, see the "sprite sheet" feature in Corona Game Edition.
--
-- Version: 2.1
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

-- movieclip.lua (a convenience library for assembling animated sprites from separate images)

module(..., package.seeall)


function newAnim (imageTable)

	-- Set up graphics
	local g = display.newGroup()
	local animFrames = {}
	local animLabels = {}
	local limitX, limitY, transpose

	local i = 1
	while imageTable[i] do
		animFrames[i] = display.newImage(imageTable[i]);
		g:insert(animFrames[i], true)
		animLabels[i] = i -- default frame label is frame number
		animFrames[i].isVisible = false
		i = i + 1
	end

	-- show first frame by default
	animFrames[1].isVisible = true

	-------------------------
	-- Define private methods
	
	local currentFrame = 1
	local totalFrames = #animFrames
	local startFrame = 1
	local endFrame = #animFrames
	local loop = 0
	local loopCount = 0
	local remove = false
	local dragBounds = nil
	local dragLeft, dragTop, dragWidth, dragHeight
	
	-- flag to distinguish initial default case (where no sequence parameters are submitted)
	local inSequence = false
	
	local function resetDefaults()
		currentFrame = 1
		startFrame = 1
		endFrame = #animFrames
		loop = 0
		loopCount = 0
		remove = false
	end
	
	local function resetReverseDefaults()
		currentFrame = #animFrames
		startFrame = #animFrames
		endFrame = 1
		loop = 0
		loopCount = 0
		remove = false
	end
	
	local function nextFrame( self, event )
		animFrames[currentFrame].isVisible = false
		currentFrame = currentFrame + 1
		if (currentFrame == endFrame + 1) then
			if (loop > 0) then
				loopCount = loopCount + 1

				if (loopCount == loop) then
					-- stop looping
					currentFrame = currentFrame - 1
					animFrames[currentFrame].isVisible = true
					Runtime:removeEventListener( "enterFrame", self )

					if (remove) then
						-- delete self (only gets garbage collected if there are no other references)
						if self.removeSelf then
							self:removeSelf()
						end
					end

				else
					currentFrame = startFrame
					animFrames[currentFrame].isVisible = true
				end

			else
				currentFrame = startFrame
				animFrames[currentFrame].isVisible = true
			end
			
		elseif (currentFrame > #animFrames) then
			currentFrame = 1
			animFrames[currentFrame].isVisible = true
			
		else
			animFrames[currentFrame].isVisible = true
			
		end
	end

	
	local function prevFrame( self, event )
		animFrames[currentFrame].isVisible = false
		currentFrame = currentFrame - 1
		
		if (currentFrame == endFrame - 1) then
			if (loop > 0) then
				loopCount = loopCount + 1

				if (loopCount == loop) then 
					-- stop looping
					currentFrame = currentFrame + 1
					animFrames[currentFrame].isVisible = true
					Runtime:removeEventListener( "enterFrame", self )

					if (remove) then
						-- delete self
						self.parent:remove(self)
					end

				else
					currentFrame = startFrame
					animFrames[currentFrame].isVisible = true
				end

			else
				currentFrame = startFrame
				animFrames[currentFrame].isVisible = true
			end
			
		elseif (currentFrame < 1) then
			currentFrame = #animFrames
			animFrames[currentFrame].isVisible = true
			
		else
			animFrames[currentFrame].isVisible = true
			
		end
	end
	
	
	local function dragMe(self, event)
		local onPress = self._onPress
		local onDrag = self._onDrag
		local onRelease = self._onRelease
	
		if event.phase == "began" then
			display.getCurrentStage():setFocus( self )     

			g._startX = event.x - g.x
			g._startY = event.y - g.y
			
			if onPress then
				result = onPress( event )
			end
			
		elseif event.phase == "moved" then
	
			if transpose == true then
				-- Note: "transpose" is deprecated now that Corona supports native landscape mode
				-- dragBounds is omitted in transposed mode, but feel free to implement it
				if limitX ~= true then
					g.x = g._startX - (event.yStart - event.y)
				end
				if limitY ~= true then
					g.y = g._startY + (event.xStart - event.x)
				end
			else
				if limitX ~= true then
					   g.x = event.x - g._startX
					if (dragBounds) then
						if (g.x < dragLeft) then g.x = dragLeft end
						if (g.x > dragLeft + dragWidth) then g.x = dragLeft + dragWidth end
					end
				end
				if limitY ~= true then
					g.y = event.y - g._startY
					if (dragBounds) then
						if (g.y < dragTop) then g.y = dragTop end
						if (g.y > dragTop + dragHeight) then g.y = dragTop + dragHeight end
					end
				end      
				print("g" , g.x, g.y, event.x, event.y)
			end

			if onDrag then
				result = onDrag( event )
			end
				
		elseif event.phase == "ended" then
			display.getCurrentStage():setFocus( nil )

			if onRelease then
				result = onRelease( event )
			end
			
		end
		
		-- stop touch from falling through to objects underneath
		return true
	end


	------------------------
	-- Define public methods

	function g:enterFrame( event )
		self:repeatFunction( event )
	end

	function g:play( params )
		Runtime:removeEventListener( "enterFrame", self )

		if ( params ) then
			-- if any parameters are submitted, assume this is a new sequence and reset all default values
			animFrames[currentFrame].isVisible = false
			resetDefaults()				
			inSequence = true
			-- apply optional parameters (with some boundary and type checking)
			if ( params.startFrame and type(params.startFrame) == "number" ) then startFrame=params.startFrame end
			if ( startFrame > #animFrames or startFrame < 1 ) then startFrame = 1 end
		
			if ( params.endFrame and type(params.endFrame) == "number" ) then endFrame=params.endFrame end
			if ( endFrame > #animFrames or endFrame < 1 ) then endFrame = #animFrames end
		
			if ( params.loop and type(params.loop) == "number" ) then loop=params.loop end
			if ( loop < 0 ) then loop = 0 end
			
			if ( params.remove and type(params.remove) == "boolean" ) then remove=params.remove end
			loopCount = 0
		else
			if (not inSequence) then
				-- use default values
				startFrame = 1
				endFrame = #animFrames
				loop = 0
				loopCount = 0
				remove = false
			end			
		end
		
		currentFrame = startFrame
		animFrames[startFrame].isVisible = true 
		
		self.repeatFunction = nextFrame
		Runtime:addEventListener( "enterFrame", self )
	end
	
	
	function g:reverse( params )
		Runtime:removeEventListener( "enterFrame", self )
		
		if ( params ) then
			-- if any parameters are submitted, assume this is a new sequence and reset all default values
			animFrames[currentFrame].isVisible = false
			resetReverseDefaults()
			inSequence = true
			-- apply optional parameters (with some boundary and type checking)
			if ( params.startFrame and type(params.startFrame) == "number" ) then startFrame=params.startFrame end
			if ( startFrame > #animFrames or startFrame < 1 ) then startFrame = #animFrames end
		
			if ( params.endFrame and type(params.endFrame) == "number" ) then endFrame=params.endFrame end
			if ( endFrame > #animFrames or endFrame < 1 ) then endFrame = 1 end
		
			if ( params.loop and type(params.loop) == "number" ) then loop=params.loop end
			if ( loop < 0 ) then loop = 0 end
		
			if ( params.remove and type(params.remove) == "boolean" ) then remove=params.remove end
		else
			if (not inSequence) then
				-- use default values
				startFrame = #animFrames
				endFrame = 1
				loop = 0
				loopCount = 0
				remove = false
			end
		end
		
		currentFrame = startFrame
		animFrames[startFrame].isVisible = true 
		
		self.repeatFunction = prevFrame
		Runtime:addEventListener( "enterFrame", self )
	end

	
	function g:nextFrame()
		-- stop current sequence, if any, and reset to defaults
		Runtime:removeEventListener( "enterFrame", self )
		inSequence = false
		
		animFrames[currentFrame].isVisible = false
		currentFrame = currentFrame + 1
		if ( currentFrame > #animFrames ) then
			currentFrame = 1
		end
		animFrames[currentFrame].isVisible = true
	end
	
	
	function g:previousFrame()
		-- stop current sequence, if any, and reset to defaults
		Runtime:removeEventListener( "enterFrame", self )
		inSequence = false
		
		animFrames[currentFrame].isVisible = false
		currentFrame = currentFrame - 1
		if ( currentFrame < 1 ) then
			currentFrame = #animFrames
		end
		animFrames[currentFrame].isVisible = true
	end

	function g:currentFrame()
		return currentFrame
	end
	
	function g:totalFrames()
		return totalFrames
	end
	
	function g:stop()
		Runtime:removeEventListener( "enterFrame", self )
	end

	function g:stopAtFrame(label)
		-- This works for either numerical indices or optional text labels
		if (type(label) == "number") then
			Runtime:removeEventListener( "enterFrame", self )
			animFrames[currentFrame].isVisible = false
			currentFrame = label
			animFrames[currentFrame].isVisible = true
			
		elseif (type(label) == "string") then
			for k, v in next, animLabels do
				if (v == label) then
					Runtime:removeEventListener( "enterFrame", self )
					animFrames[currentFrame].isVisible = false
					currentFrame = k
					animFrames[currentFrame].isVisible = true
				end
			end
		end
	end

	
	function g:playAtFrame(label)
		-- This works for either numerical indices or optional text labels
		if (type(label) == "number") then
			Runtime:removeEventListener( "enterFrame", self )
			animFrames[currentFrame].isVisible = false
			currentFrame = label
			animFrames[currentFrame].isVisible = true
			
		elseif (type(label) == "string") then
			for k, v in next, animLabels do
				if (v == label) then
					Runtime:removeEventListener( "enterFrame", self )
					animFrames[currentFrame].isVisible = false
					currentFrame = k
					animFrames[currentFrame].isVisible = true
				end
			end
		end
		self.repeatFunction = nextFrame
		Runtime:addEventListener( "enterFrame", self )
	end


	function g:setDrag( params )
		if ( params ) then
			if params.drag == true then
				limitX = (params.limitX == true)
				limitY = (params.limitY == true)
				transpose = (params.transpose == true)
				dragBounds = nil
				
				if ( params.onPress and ( type(params.onPress) == "function" ) ) then
					g._onPress = params.onPress
				end
				if ( params.onDrag and ( type(params.onDrag) == "function" ) ) then
					g._onDrag = params.onDrag
				end
				if ( params.onRelease and ( type(params.onRelease) == "function" ) ) then
					g._onRelease = params.onRelease
				end
				if ( params.bounds and ( type(params.bounds) == "table" ) ) then
					dragBounds = params.bounds
					dragLeft = dragBounds[1]
					dragTop = dragBounds[2]
					dragWidth = dragBounds[3]
					dragHeight = dragBounds[4]
				end
				
				g.touch = dragMe
				g:addEventListener( "touch", g )
				
			else
				g:removeEventListener( "touch", g )
				dragBounds = nil
				
			end
		end
	end


	-- Optional function to assign text labels to frames
	function g:setLabels(labelTable)
		for k, v in next, labelTable do
			if (type(k) == "string") then
				animLabels[v] = k
			end
		end		
	end
	
	-- Return instance of anim
	return g

end
