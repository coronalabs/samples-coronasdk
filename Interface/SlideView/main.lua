-- 
-- Abstract: Slide View sample app
--  
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Demonstrates how to display a set of images in a series that 
-- the user can swipe from left to right, using the methods 
-- provided in slideView.lua.

display.setStatusBar( display.HiddenStatusBar ) 

local slideView = require("slideView")
	
local myImages = {
	"myPhotos1.jpg",
	"myPhotos2.jpg",
	"myPhotos3.jpg",
	"myPhotos4.jpg"
}		

slideView.new( myImages )

--[[

-- Examples of other parameters:

-- Show a background image behind the slides
slideView.new( myImages, "bg.jpg" )

-- Insert space at the top and bottom
slideView.new( myImages, nil, 40, 60 )

--]]

