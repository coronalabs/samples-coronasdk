local storeUI = {}

-- This is needed for the storeUI controls.
local widget = require( "widget" )

-- The store our UI is connected to.
local store = nil

-- The platform our UI is configured for.
local platform = nil

storeUI.descriptionArea = nil

-- Buttons for each of the products we've loaded
local productButtons = {}

-------------------------------------------------------------------------------
-- Displays a warning indicating that store access is not available,
-- meaning that Corona does not support in-app purchases on this system/device.
-- To be called when the store.isActive property returns false.
-------------------------------------------------------------------------------
function storeUI.showStoreNotAvailableWarning( )
	if platform == "simulator" then
		native.showAlert( "Notice", "In-app purchases are not supported by the Corona Simulator.", { "OK" } )
	else
		native.showAlert( "Notice", "In-app purchases are not supported on this system/device.", { "OK" } )
	end
end

-------------------------------------------------------------------------------
-- Prints the "Select an option..." prompt in the UI's console
-------------------------------------------------------------------------------
function storeUI.printOptionPrompt ( )
	storeUI.printToConsole( "Select an option..." )
end

-------------------------------------------------------------------------------
-- Sets up the background and description area for the Store UI
-------------------------------------------------------------------------------
function storeUI.initializeStoreMenu ( )
	
	-- Set up native text box for displaying current transaction status.
	storeUI.descriptionArea = native.newTextBox( 0, 0,
				display.contentCenterX - 20, 0.75 * display.contentHeight )
	storeUI.printOptionPrompt( )
	storeUI.descriptionArea:setTextColor( 0, 0.8, 0, 0.8 )
	storeUI.descriptionArea.size = 24
	storeUI.descriptionArea.hasBackground = false
	storeUI.descriptionArea.anchorX = 0
	storeUI.descriptionArea.anchorY = 0

end

-------------------------------------------------------------------------------
-- Process and display product information obtained from store.
-- Constructs a button for each item
-------------------------------------------------------------------------------
function storeUI.addProductFields( productData )
	-- Display product purchasing options
	print ( "Loading product list" )
	if ( not productData.validProducts  ) or ( #productData.validProducts  <= 0 ) then
		-- There are no products to purchase. This indicates that in-app purchasing is not supported.
		local noProductsLabel = display.newText(
					"Sorry!\nIn-App purchases are not supported on this device.",
					display.contentWidth / 2, display.contentHeight / 3,
					display.contentWidth / 2, 0,
					native.systemFont, 16 )
		noProductsLabel:setFillColor( 0, 0, 0 )
		noProductsLabel.anchorX = 0
		noProductsLabel.anchorY = 0
		storeUI.showStoreNotAvailableWarning( )
	else
		-- Products for purchasing have been received. Create options to purchase them below.
		print( "Product list loaded" )
		print( "Country: " .. tostring( system.getPreference( "locale", "country" ) ) )
		print( "Found " .. #productData.validProducts  .. " valid items " )
		
		local buttonSpacing = 5

		-- display the valid products in buttons 
		for i=1, #productData.validProducts  do            
			-- Debug:  print out product info 
			print( "Item " .. tostring( i ) .. ": " .. tostring( productData.validProducts[i].productIdentifier )
							.. " (" .. tostring( productData.validProducts[i].price ) .. ")" )
			print( productData.validProducts[i].title .. ",  ".. productData.validProducts[i].description )

			-- create and position product button
			local myButton = storeUI.newBuyButton( productData.validProducts[i] )
			myButton.x = display.contentWidth - myButton.width - buttonSpacing
			myButton.y = i * buttonSpacing + ( 2 * i - 1 ) * myButton.height / 2
			productButtons[i] = myButton
		end
        
		-- Debug: Display invalid prodcut info loaded from the store.
		--        You would not normally do this in a release build of your app.
		for i=1, #productData.invalidProducts do
			native.showAlert( "Notice", "Item " .. tostring( productData.invalidProducts[i] ) .. " is invalid.", {"OK"} )
			print( "Item " .. tostring( productData.invalidProducts[i] ) .. " is invalid." )
		end
	end
end

-------------------------------------------------------------------------------
-- Clears product infomation currently displayed.
-- Used for chaning the products currently displayed.
-------------------------------------------------------------------------------
function storeUI.clearProductFields( )
	-- Remove all the product buttons
	for i = 1, #productButtons do
		display.remove( productButtons[i] )
	end
end

-------------------------------------------------------------------------------
-- Refreshes the current product field display
-------------------------------------------------------------------------------
function storeUI.refreshProductFields( productData )
	storeUI.clearProductFields( )
	storeUI.addProductFields( productData )
end

-------------------------------------------------------------------------------
-- Utility function to build a buy button.
-------------------------------------------------------------------------------
function storeUI.newBuyButton ( product )
	--	Handler for buy button 
	local buttonDefault = "buttonBuy.png"
	local buttonOver = "buttonBuyDown.png"

	local buyThis = function ( productId )

		function printWaitingForTransaction( )
			storeUI.printToConsole( "Waiting for transaction on " .. tostring( productId ) .. " to complete..." )
		end

		-- Check if it is possible to purchase the item, then attempt to buy it.
		if not isAndroid and not store.isActive then
			storeUI.showStoreNotAvailableWarning( )
			timer.performWithDelay( 2000, storeUI.printOptionPrompt )
		elseif not store.canMakePurchases then
			native.showAlert( "Notice", "Store purchases are not available, please try again later", { "OK" } )
			timer.performWithDelay( 2000, storeUI.printOptionPrompt )
		elseif productId then
			print( "Ka-ching! Purchasing " .. tostring( productId ) )
    		if platform == "Android" then
      			-- Google IAP v3 only allows purchases one at a time, so we don't pass a table here.
      			store.purchase( productId )
    		else
      			-- Corona's default store library requires a table to be passed here, even for only 1 item.
			  	store.purchase( {productId} )
    		end
    		timer.performWithDelay( 2000, printWaitingForTransaction )
		end
		
	end
	function buyThis_closure ( product )            
		-- Closure wrapper for buyThis() to remember which button
		return function ( event )
			buyThis( product.productIdentifier )
			return true
		end        
	end

	local describeThis = function ( description )
		-- Display product description for testing
		storeUI.printToConsole( "About this product:\n" .. description )
	end
	function describeThis_closure ( product )            
		-- Closure wrapper for describeThis() to remember which button
		return function ( event )
			describeThis( product.description )		 
			return true
		end        
	end

	local label = product.title
	-- On Android, the name of the app is included in the title 
	-- of all in-app products. We remove this for the sake of clarity
	if platform == "Android" then
		label = string.gsub( label, "%b()", "" )
	end
	
	local myButton = widget.newButton
	{ 
		defaultFile = buttonDefault, 
		overFile = buttonOver,
		label = "", 
		labelColor = 
		{ 
			default = { 2/255, 0, 127/255 }, 
			over = { 2/255, 0, 127/255 } 
		}, 
		font = "Marker Felt", 
		fontSize = 18, 
		emboss = false,
		--onEvent = handleButtonEvent( product )
		onPress = describeThis_closure( product ),
		onRelease = buyThis_closure( product ),
	}
	myButton.anchorX = 0 	-- left
	myButton:setLabel( label )
	return myButton
end

-------------------------------------------------------------------------------
-- Factory method to build function buttons
-------------------------------------------------------------------------------
function storeUI.newFunctionButton ( label, pressFunc, releaseFunc )
	local buttonDefault = "buttonFunction.png"
	local buttonOver = "buttonFunctionDown.png"

	local doThis = function ( )
		releaseFunc( )
		timer.performWithDelay( 1000, storeUI.printOptionPrompt )
	end

	local myButton = widget.newButton
	{ 
		defaultFile = buttonDefault, 
		overFile = buttonOver,
		label = "", 
		labelColor = 
		{ 
			default = { 2/255, 0, 127/255 }, 
			over = { 2/255, 0, 127/255 } 
		}, 
		font = "Marker Felt", 
		fontSize = 18, 
		emboss = false,
		onPress = pressFunc,
		onRelease = doThis,
	}
	myButton.anchorX = 0 	-- left
	myButton:setLabel( label ) 
	return myButton
end

-------------------------------------------------------------------------------
-- Sets which platform we want our store UI will be used with.
-------------------------------------------------------------------------------
function storeUI.setPlatform( platformToUse )
	platform = platformToUse
end

-------------------------------------------------------------------------------
-- Tell the store UI which store API to use
-------------------------------------------------------------------------------
function storeUI.setStore( storeToUse )
	store = storeToUse
end

-------------------------------------------------------------------------------
-- Print info to the storeUI's debug console
-------------------------------------------------------------------------------
function storeUI.printToConsole( message )
	if storeUI.descriptionArea ~= nil then
		storeUI.descriptionArea.text = message
		print( storeUI.descriptionArea.text )
	else
		print( "Store UI console unavailable. Printing message to stdout." )
		print( message )
	end
end

-- Return storeUI library for external use
return storeUI
