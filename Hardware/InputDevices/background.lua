-- Before creating our background, store and change our texture wrapping option
display.setDefault( "textureWrapX", "repeat" )
display.setDefault( "textureWrapY", "repeat" )

-- Create a background image
local background = display.newRect( display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentWidth )
background.fill = { type="image", filename="tile.png" }
background.fill.scaleX = 512/display.actualContentWidth/2
background.fill.scaleY = 512/display.actualContentWidth/2

-- Restore defaults
local textureWrapDefault = "clampToEdge"
display.setDefault( "textureWrapX", textureWrapDefault )
display.setDefault( "textureWrapY", textureWrapDefault )

return background
