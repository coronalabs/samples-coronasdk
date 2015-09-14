module(...)


-- This file is for use with Corona Game Edition
--
-- The function getSpriteSheetData() returns a table suitable for importing using sprite.newSpriteSheetFromData()
--
-- Usage example:
--			local zwoptexData = require "ThisFile.lua"
-- 			local data = zwoptexData.getSpriteSheetData()
--			local spriteSheet = sprite.newSpriteSheetFromData( "Untitled.png", data )
--
-- For more details, see https://www.coronalabs.com/links/content/game-edition-sprite-sheets

function getSpriteSheetData()

	local sheet = {
		frames = {
		
			{
				name = "redBall_0000_36.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 116, y = 40, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0001_35.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 2, y = 78, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0002_34.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 154, y = 40, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0003_33.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 78, y = 116, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0004_32.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 2, y = 40, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0005_31.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 154, y = 154, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0006_30.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 154, y = 192, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0007_29.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 78, y = 40, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0008_28.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 116, y = 154, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0009_27.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 40, y = 2, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0010_26.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 2, y = 2, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0011_25.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 40, y = 154, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0012_24.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 116, y = 116, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0013_23.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 192, y = 116, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0014_22.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 192, y = 154, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0015_21.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 192, y = 2, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0016_20.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 40, y = 116, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0017_19.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 40, y = 78, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0018_18.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 40, y = 192, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0019_17.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 192, y = 192, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0020_16.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 154, y = 2, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0022_14.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 78, y = 2, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0022_15.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 78, y = 154, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0023_13.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 116, y = 192, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0024_12.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 2, y = 192, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0025_11.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 154, y = 116, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0026_10.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 78, y = 192, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0027_9.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 40, y = 40, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0028_8.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 2, y = 154, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0029_7.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 192, y = 40, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0030_6.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 116, y = 2, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0031_5.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 192, y = 78, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0032_4.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 2, y = 116, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0033_3.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 154, y = 78, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0034_2.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 78, y = 78, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "redBall_0035_1.png",
				spriteColorRect = { x = 0, y = 0, width = 36, height = 36 }, 
				textureRect = { x = 116, y = 78, width = 36, height = 36 }, 
				spriteSourceSize = { width = 36, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
		}
	}

	return sheet
end