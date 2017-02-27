-- Abstract: Ragdoll sample project
-- A port of the ragdoll from http://www.box2dflash.org/
--
-- Version: 1.0
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- History
--  1.0		6/7/12		Initial version
--
--	Supports Graphics 2.0
---------------------------------------------------------------------------------------

local ragdoll = {}

local gameUI = require("gameUI")

ragdoll.createWalls = function()
	--> Create Walls

	local walls = display.newGroup()

	display.setDefault( "anchorX", 0.0 )	-- default to TopLeft anchor point for new objects
	display.setDefault( "anchorY", 0.0 )

	local leftWall  = display.newRect (-100, 0, 101, display.contentHeight)
	local rightWall = display.newRect (display.contentWidth, 0, 100, display.contentHeight)
	local ceiling   = display.newRect (0, -100, display.contentWidth, 101)
	local floor     = display.newRect (0, display.contentHeight, display.contentWidth, 100)

	local b = 0.3 -- 0.0
	local f = 0.1 -- 10

	physics.addBody (leftWall, "static", {bounce = b, friction = f})
	physics.addBody (rightWall, "static", {bounce = b, friction = f})
	physics.addBody (ceiling, "static", {bounce = b, friction = f})
	physics.addBody (floor, "static", {bounce = b, friction = f})

	walls:insert(leftWall)
	walls:insert(rightWall)
	walls:insert(ceiling)
	walls:insert(floor)

	display.setDefault( "anchorX", 0.5 )	-- restore anchor points for new objects to center anchor point
	display.setDefault( "anchorY", 0.5 )

	return walls
end

local function setFill(ob, param)
	ob:setFillColor(param[1], param[2], param[3], param[4] or 255)
end

-- Aligns an object to TopLeft position (using existing x,y values of the object)
local function TopLeft( object )
	object.x = object.x + object.width *.5
	object.y = object.y + object.height *.5
end

function ragdoll.newRagDoll(originX, originY, colorTable)

	--> Create Ragdoll Group

	-- display.setDefault( "anchorX", 0.0 )	-- default to TopLeft anchor point for new objects
	-- display.setDefault( "anchorY", 0.0 )

	local spacing = 1

	local ragdoll = display.newGroup ()

	local startX = originX+100
	local startY = originY+50

	--[[
	var bd:b2BodyDef;
	var circ:b2CircleDef = new b2CircleDef();
	var box:b2PolygonDef = new b2PolygonDef();
	var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
	--]]

	-- Head
	local head = display.newCircle( startX, startY, 12.5 )
	setFill(head, colorTable)
	ragdoll:insert (head)

	--[[
	circ.density = 1.0;
	circ.friction = 0.4;
	circ.restitution = 0.3;
	bd = new b2BodyDef();
	bd.position.Set(startX, startY);
	var head:b2Body = m_world.CreateBody(bd);
	head.CreateShape(circ);
	head.SetMassFromShapes();
	//if (i == 0){
		head.ApplyImpulse(new b2Vec2(Math.random() * 100 - 50, Math.random() * 100 - 50), head.GetWorldCenter());
	//}
	--]]

	local w,h = 2*15,2*10

	-- Torso1
	local torsoA = display.newRect( -w*0.5, -h*0.5, w, h )
	TopLeft( torsoA )
	torsoA:translate( startX, (startY + 28) )
	setFill(torsoA, colorTable)
	ragdoll:insert (torsoA)
	--[[
	box.SetAsBox(15, 10);
	box.density = 1.0;
	box.friction = 0.4;
	box.restitution = 0.1;
	bd = new b2BodyDef();
	bd.position.Set(startX, (startY + 28));
	var torso1:b2Body = m_world.CreateBody(bd);
	torso1.CreateShape(box);
	torso1.SetMassFromShapes();
	--]]

	-- Torso2
	local torsoB = display.newRect( -w*0.5, -h*0.5, w, h )
	TopLeft( torsoB )
	torsoB:translate( startX, (startY + 43) )
	setFill(torsoB, colorTable)
	ragdoll:insert (torsoB)
	--[[
	bd = new b2BodyDef();
	bd.position.Set(startX, (startY + 43));
	var torso2:b2Body = m_world.CreateBody(bd);
	torso2.CreateShape(box);
	torso2.SetMassFromShapes();
	--]]

	-- Torso3
	local torsoC = display.newRect( -w*0.5, -h*0.5, w, h )
	TopLeft( torsoC )
	torsoC:translate( startX, (startY + 58) )
	setFill(torsoC, colorTable)
	ragdoll:insert (torsoC)
	--[[
	bd = new b2BodyDef();
	bd.position.Set(startX, (startY + 58));
	var torso3:b2Body = m_world.CreateBody(bd);
	torso3.CreateShape(box);
	torso3.SetMassFromShapes();
	--]]

	-- UpperArm
	local w,h = 2*18,2*6.5

	-- L
	local upperArmL = display.newRect( -w*0.5, -h*0.5, w, h )
	TopLeft( upperArmL )
	upperArmL:translate( (startX - 30), (startY + 20) )
	setFill(upperArmL, colorTable)
	ragdoll:insert (upperArmL)

	-- R
	local upperArmR = display.newRect( -w*0.5, -h*0.5, w, h )
	TopLeft( upperArmR )
	upperArmR:translate( (startX + 30), (startY + 20) )
	setFill(upperArmR, colorTable)
	ragdoll:insert (upperArmR)
	--[[
	box.SetAsBox(18, 6.5);
	box.density = 1.0;
	box.friction = 0.4;
	box.restitution = 0.1;
	bd = new b2BodyDef();
	// L
	bd.position.Set((startX - 30), (startY + 20));
	var upperArmL:b2Body = m_world.CreateBody(bd);
	upperArmL.CreateShape(box);
	upperArmL.SetMassFromShapes();
	// R
	bd.position.Set((startX + 30), (startY + 20));
	var upperArmR:b2Body = m_world.CreateBody(bd);
	upperArmR.CreateShape(box);
	upperArmR.SetMassFromShapes();
	--]]

	-- LowerArm
	local w,h = 2*17,2*6

	-- L
	local lowerArmL = display.newRect( -w*0.5, -h*0.5, w, h )
	TopLeft( lowerArmL )
	lowerArmL:translate( (startX - 57), (startY + 20) )
	setFill(lowerArmL, colorTable)
	ragdoll:insert (lowerArmL)

	-- R
	local lowerArmR = display.newRect( -w*0.5, -h*0.5, w, h )
	TopLeft( lowerArmR )
	lowerArmR:translate( (startX + 57), (startY + 20) )
	setFill(lowerArmR, colorTable)
	ragdoll:insert (lowerArmR)
	--[[
	box.SetAsBox(17, 6);
	box.density = 1.0;
	box.friction = 0.4;
	box.restitution = 0.1;
	bd = new b2BodyDef();
	// L
	bd.position.Set((startX - 57), (startY + 20));
	var lowerArmL:b2Body = m_world.CreateBody(bd);
	lowerArmL.CreateShape(box);
	lowerArmL.SetMassFromShapes();
	// R
	bd.position.Set((startX + 57), (startY + 20));
	var lowerArmR:b2Body = m_world.CreateBody(bd);
	lowerArmR.CreateShape(box);
	lowerArmR.SetMassFromShapes();
	--]]

	-- UpperLeg
	local w,h = 2*7.5,2*22

	-- L
	local upperLegL = display.newRect( -w*0.5, -h*0.5, w, h )
	TopLeft( upperLegL )
	upperLegL:translate( (startX - 8), (startY + 85) )
	setFill(upperLegL, colorTable)
	ragdoll:insert (upperLegL)

	-- R
	local upperLegR = display.newRect( -w*0.5, -h*0.5, w, h )
	TopLeft( upperLegR )
	upperLegR:translate( (startX + 8), (startY + 85) )
	setFill(upperLegR, colorTable)
	ragdoll:insert (upperLegR)
	--[[
	box.SetAsBox(7.5, 22);
	box.density = 1.0;
	box.friction = 0.4;
	box.restitution = 0.1;
	bd = new b2BodyDef();
	// L
	bd.position.Set((startX - 8), (startY + 85));
	var upperLegL:b2Body = m_world.CreateBody(bd);
	upperLegL.CreateShape(box);
	upperLegL.SetMassFromShapes();
	// R
	bd.position.Set((startX + 8), (startY + 85));
	var upperLegR:b2Body = m_world.CreateBody(bd);
	upperLegR.CreateShape(box);
	upperLegR.SetMassFromShapes();
	--]]

	-- LowerLeg
	local w,h = 2*6,2*20

	-- L
	local lowerLegL = display.newRect( -w*0.5, -h*0.5, w, h )
	TopLeft( lowerLegL )
	lowerLegL:translate( (startX - 8), (startY + 120) )
	setFill(lowerLegL, colorTable)
	ragdoll:insert (lowerLegL)

	-- R
	local lowerLegR = display.newRect( -w*0.5, -h*0.5, w, h )
	TopLeft( lowerLegR )
	lowerLegR:translate( (startX + 8), (startY + 120) )
	setFill(lowerLegR, colorTable)
	ragdoll:insert (lowerLegR)
	--[[
	box.SetAsBox(6, 20);
	box.density = 1.0;
	box.friction = 0.4;
	box.restitution = 0.1;
	bd = new b2BodyDef();
	// L
	bd.position.Set((startX - 8), (startY + 120));
	var lowerLegL:b2Body = m_world.CreateBody(bd);
	lowerLegL.CreateShape(box);
	lowerLegL.SetMassFromShapes();
	// R
	bd.position.Set((startX + 8), (startY + 120));
	var lowerLegR:b2Body = m_world.CreateBody(bd);
	lowerLegR.CreateShape(box);
	lowerLegR.SetMassFromShapes();
	--]]
--
local d=1
local e=0.1
local f=0.4

	physics.addBody (head, {bounce = 0.3, density=1.0, friction=0.4, radius = 12.5})
	physics.addBody (torsoA, {bounce = e, density=d, friction = f})
	physics.addBody (torsoB, {bounce = e, density=d, friction = f})
	physics.addBody (torsoC, {bounce = e, density=d, friction = f})
	physics.addBody (upperArmL, {bounce = e, density=d, friction = f})
	physics.addBody (upperArmR, {bounce = e, density=d, friction = f})
	physics.addBody (lowerArmL, {bounce = e, density=d, friction = f})
	physics.addBody (lowerArmR, {bounce = e, density=d, friction = f})
	physics.addBody (upperLegL, {bounce = e, density=d, friction = f})
	physics.addBody (upperLegR, {bounce = e, density=d, friction = f})
	physics.addBody (lowerLegL, {bounce = e, density=d, friction = f})
	physics.addBody (lowerLegR, {bounce = e, density=d, friction = f})
--]]
	local function addFrictionJoint(a, b, posX, posY, lowerAngle, upperAngle, mT)
		local j = physics.newJoint ( "pivot", a, b, posX, posY, rFrom, rTo)
		j.isLimitEnabled = true
		j:setRotationLimits (lowerAngle, upperAngle)
		return j
	end

	-- JOINTS
	--jd.enableLimit = true;

	-- Head to shoulders
	addFrictionJoint( torsoA, head, startX, (startY + 15), -40, 40 )
	--[[
	jd.lowerAngle = -40 / (180/Math.PI);
	jd.upperAngle = 40 / (180/Math.PI);
	jd.Initialize(torso1, head, new b2Vec2(startX, (startY + 15)));
	m_world.CreateJoint(jd);
	--]]

	-- Upper arm to shoulders
	-- L
	addFrictionJoint( torsoA, upperArmL, (startX - 18), (startY + 20), -85, 130 )

	-- R
	addFrictionJoint( torsoA, upperArmR, (startX + 18), (startY + 20), -130, 85 )
	--[[
	jd.lowerAngle = -85 / (180/Math.PI);
	jd.upperAngle = 130 / (180/Math.PI);
	jd.Initialize(torso1, upperArmL, new b2Vec2((startX - 18), (startY + 20)));
	m_world.CreateJoint(jd);
	// R
	jd.lowerAngle = -130 / (180/Math.PI);
	jd.upperAngle = 85 / (180/Math.PI);
	jd.Initialize(torso1, upperArmR, new b2Vec2((startX + 18), (startY + 20)));
	m_world.CreateJoint(jd);
	--]]

	-- Lower arm to upper arm
	-- L
	addFrictionJoint( upperArmL, lowerArmL, (startX - 45), (startY + 20), -130, 10 )

	-- R
	addFrictionJoint( upperArmR, lowerArmR, (startX + 45), (startY + 20), -10, 130 )
	--[[
	// L
	jd.lowerAngle = -130 / (180/Math.PI);
	jd.upperAngle = 10 / (180/Math.PI);
	jd.Initialize(upperArmL, lowerArmL, new b2Vec2((startX - 45), (startY + 20)));
	m_world.CreateJoint(jd);
	// R
	jd.lowerAngle = -10 / (180/Math.PI);
	jd.upperAngle = 130 / (180/Math.PI);
	jd.Initialize(upperArmR, lowerArmR, new b2Vec2((startX + 45), (startY + 20)));
	m_world.CreateJoint(jd);
	--]]

	-- Shoulders/stomach
	local j = addFrictionJoint( torsoA, torsoB, (startX), (startY + 35), -15, 15 )
--	Runtime:addEventListener( "enterFrame", function()
--		print( j.jointAngle, j.isLimitEnabled, j.isMotorEnabled, j.motorSpeed, j.motorTorque )
--	end )

	--[[
	jd.lowerAngle = -15 / (180/Math.PI);
	jd.upperAngle = 15 / (180/Math.PI);
	jd.Initialize(torso1, torso2, new b2Vec2(startX, (startY + 35)));
	m_world.CreateJoint(jd);
	--]]

	-- Stomach/hips
	addFrictionJoint( torsoB, torsoC, (startX), (startY + 50), -15, 15 )
	--[[
	jd.Initialize(torso2, torso3, new b2Vec2(startX, (startY + 50)));
	m_world.CreateJoint(jd);
	--]]

	-- Torso to upper leg
	-- L
	addFrictionJoint( torsoC, upperLegL, (startX - 8), (startY + 72), -25, 45 )

	-- R
	addFrictionJoint( torsoC, upperLegR, (startX + 8), (startY + 72), -45, 25 )
	--[[
	// L
	jd.lowerAngle = -25 / (180/Math.PI);
	jd.upperAngle = 45 / (180/Math.PI);
	jd.Initialize(torso3, upperLegL, new b2Vec2((startX - 8), (startY + 72)));
	m_world.CreateJoint(jd);
	// R
	jd.lowerAngle = -45 / (180/Math.PI);
	jd.upperAngle = 25 / (180/Math.PI);
	jd.Initialize(torso3, upperLegR, new b2Vec2((startX + 8), (startY + 72)));
	m_world.CreateJoint(jd);
	--]]

	-- Upper leg to lower leg
	-- L
	addFrictionJoint( upperLegL, lowerLegL, (startX - 8), (startY + 105), -25, 115 )

	-- R
	addFrictionJoint( upperLegR, lowerLegR, (startX + 8), (startY + 105), -115, 25 )
	--[[
	// L
	jd.lowerAngle = -25 / (180/Math.PI);
	jd.upperAngle = 115 / (180/Math.PI);
	jd.Initialize(upperLegL, lowerLegL, new b2Vec2((startX - 8), (startY + 105)));
	m_world.CreateJoint(jd);
	// R
	jd.lowerAngle = -115 / (180/Math.PI);
	jd.upperAngle = 25 / (180/Math.PI);
	jd.Initialize(upperLegR, lowerLegR, new b2Vec2((startX + 8), (startY + 105)));
	m_world.CreateJoint(jd);
	--]]

	--[[
	// Add stairs on the left
	for (var j:int = 1; j <= 10; j++){
		box.SetAsBox((10*j), 10);
		box.density = 0.0;
		box.friction = 0.4;
		box.restitution = 0.3;
		bd = new b2BodyDef();
		bd.position.Set((10*j), (150 + 20*j));
		head = m_world.CreateBody(bd);
		head.CreateShape(box);
		head.SetMassFromShapes();
	}

	// Add stairs on the right
	for (var k:int = 1; k <= 10; k++){
		box.SetAsBox((10*k), 10);
		box.density = 0.0;
		box.friction = 0.4;
		box.restitution = 0.3;
		bd = new b2BodyDef();
		bd.position.Set((640-10*k), (150 + 20*k));
		head = m_world.CreateBody(bd);
		head.CreateShape(box);
		head.SetMassFromShapes();
	}

	box.SetAsBox(30, 40);
	box.density = 0.0;
	box.friction = 0.4;
	box.restitution = 0.3;
	bd = new b2BodyDef();
	bd.position.Set(320, 320);
	head = m_world.CreateBody(bd);
	head.CreateShape(box);
	head.SetMassFromShapes();
	--]]

	function ragdoll:touch( event )
		gameUI.dragBody( event )
	end

	head:addEventListener ( "touch", ragdoll )
	upperLegL:addEventListener ( "touch", ragdoll )
	upperLegR:addEventListener ( "touch", ragdoll )
	lowerLegL:addEventListener ( "touch", ragdoll )
	lowerLegR:addEventListener ( "touch", ragdoll )
	upperArmL:addEventListener ( "touch", ragdoll )
	upperArmR:addEventListener ( "touch", ragdoll )
	lowerArmL:addEventListener ( "touch", ragdoll )
	lowerArmR:addEventListener ( "touch", ragdoll )

	display.setDefault( "anchorX", 0.5 )	-- restore anchor points for new objects to center anchor point
	display.setDefault( "anchorY", 0.5 )

	return ragdoll
end

return ragdoll