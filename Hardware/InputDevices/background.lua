
-------------------------------------------------------------------------------------------------------
-- Artwork used within this project is licensed under Public Domain Dedication
-- See the following site for further information: https://creativecommons.org/publicdomain/zero/1.0/
-------------------------------------------------------------------------------------------------------

-- Before creating our background, store and change our texture wrapping option
display.setDefault( "textureWrapX", "repeat" )
display.setDefault( "textureWrapY", "repeat" )

-- Create a background image
local background = display.newRect( display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
background.fill = { type="image", filename="grass.png" }
background.fill.scaleX = 0.5
background.fill.scaleY = 0.5

-- Restore defaults
local textureWrapDefault = "clampToEdge"
display.setDefault( "textureWrapX", textureWrapDefault )
display.setDefault( "textureWrapY", textureWrapDefault )

return background
