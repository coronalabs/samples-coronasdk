-- gameUI library
module(..., package.seeall)

-- A general function for dragging physics bodies

-- Simple example:
-- 		local dragBody = gameUI.dragBody
-- 		object:addEventListener( "touch", dragBody )
local total_number_of_joints_created = 0

function dragBody( event, params )
	local body = event.target
	local phase = event.phase
	local stage = display.getCurrentStage()

	if "began" == phase then

		if total_number_of_joints_created > 0 then
			-- Nothing to do.
			--
			-- This event happens for ALL bodies, therefore, we have to limit
			-- the total number of joints we create to avoid strange behaviors.
			return
		end

		stage:setFocus( body, event.id )
		body.isFocus = true

		-- Create a temporary touch joint and store it in the object for later reference
		if params and params.center then
			-- drag the body from its center point
			body.tempJoint = physics.newJoint( "touch", body, body.x, body.y )
		else
			-- drag the body from the point where it was touched
			body.tempJoint = physics.newJoint( "touch", body, event.x, event.y )
		end

		total_number_of_joints_created = total_number_of_joints_created + 1

--		body.tempJoint.maxForce = 0.25*body.tempJoint.maxForce

		-- Apply optional joint parameters
		if params then
			local maxForce, frequency, dampingRatio

			if params.maxForce then
				-- Internal default is (1000 * mass), so set this fairly high if setting manually
				body.tempJoint.maxForce = params.maxForce
			end

			if params.frequency then
				-- This is the response speed of the elastic joint: higher numbers = less lag/bounce
				body.tempJoint.frequency = params.frequency
			end

			if params.dampingRatio then
				-- Possible values: 0 (no damping) to 1.0 (critical damping)
				body.tempJoint.dampingRatio = params.dampingRatio
			end
		end

	elseif body.isFocus then
		if "moved" == phase then

			-- Update the joint to track the touch
			body.tempJoint:setTarget( event.x, event.y )

		elseif "ended" == phase or "cancelled" == phase then
			stage:setFocus( body, nil )
			body.isFocus = false

			-- Remove the joint when the touch ends
			body.tempJoint:removeSelf()

			total_number_of_joints_created = total_number_of_joints_created - 1
		end
	end

	-- Stop further propagation of touch event
	return true
end


-- A function for cross-platform event sounds

function newEventSoundXP( params )
	local isAndroid = "Android" == system.getInfo("platformName")

	if isAndroid and params.android then
		soundID = media.newEventSound( params.android ) -- return sound file for Android
	elseif params.ios then
		soundID = media.newEventSound( params.ios ) -- return sound file for iOS/MacOS
	end

	return soundID
end


-- A function for cross-platform fonts

function newFontXP( params )
	local isAndroid = "Android" == system.getInfo("platformName")

	if isAndroid and params.android then
		font = params.android -- return font for Android
	elseif params.ios then
		font = params.ios -- return font for iOS/MacOS
	else
		font = native.systemFont -- default font (Helvetica on iOS, Android Sans on Android)
	end

	return font
end
