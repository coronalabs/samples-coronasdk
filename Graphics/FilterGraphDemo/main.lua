--
-- Abstract: Filter Graph sample app
--
-- Date: August 1, 2013
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Demonstrates: graphics, shaders, filters
--
-- File dependencies: none
--
-- Target devices: Simulator and devices
--
-- Limitations:
--
-- Update History:
--
-- Comments: 
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2013 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

local image_name = "image.png"

local effect = require( "kernel_filter_example_blur_gaussian_gl" )

graphics.defineEffect( effect )

local image1 = display.newImage( image_name )

image1.x = display.contentCenterX
image1.y = display.contentCenterY

image1.fill.effect = "filter.custom.exampleBlurGaussian"
image1.fill.effect.horizontal.blurSize = 8
image1.fill.effect.vertical.blurSize = 8
