module(...)


-- This file is for use with Corona Game Edition
--
-- The function getSpriteSheetData() returns a table suitable for importing using sprite.newSpriteSheetFromData()
--
-- Usage example:
--			local zwoptexData = require "ThisFile.lua"
-- 			local data = zwoptexData.getSpriteSheetData()
--			local spriteSheet = sprite.newSpriteSheetFromData( "blackBall.png", data )
--
-- For more details, see https://www.coronalabs.com/links/content/game-edition-sprite-sheets

function getSpriteSheetData()

	local sheet = {
		frames = {
		
			{
				name = "1.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 2, y = 192, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
			{
				name = "2.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 39, y = 2, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
			
			{
				name = "3.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 76, y = 78, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "4.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 39, y = 78, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "5.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 39, y = 154, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "6.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 187, y = 2, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "7.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 76, y = 116, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "8.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 76, y = 2, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "9.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 39, y = 192, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
			{
				name = "10.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 2, y = 78, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "11.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 2, y = 40, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "12.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 39, y = 40, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "13.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 76, y = 154, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "14.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 150, y = 40, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "15.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 76, y = 40, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "16.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 2, y = 2, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "17.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 2, y = 154, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "18.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 113, y = 40, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "19.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 39, y = 116, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		

			{
				name = "20.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 2, y = 116, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "21.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 150, y = 2, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "22.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 113, y = 2, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		
			{
				name = "23.png",
				spriteColorRect = { x = 0, y = 0, width = 35, height = 36 }, 
				textureRect = { x = 187, y = 40, width = 35, height = 36 }, 
				spriteSourceSize = { width = 35, height = 36 }, 
				spriteTrimmed = true,
				textureRotated = false
			},
		

		
		}
	}

	return sheet
end