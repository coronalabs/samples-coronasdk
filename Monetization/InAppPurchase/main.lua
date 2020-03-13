-- 
-- Abstract: In-App Purchase Sample Project
-- 
-- This project demonstrates Corona In-App Purchase support.
-- The code attempts to connect to a store such as iTunes or Google's Android Marketplace
-- to retrieve valid product information and handle transactions.
--
-- IMPORTANT:  Parts of this code can be exercised in Corona Simulator for 
-- testing, but Corona Simulator cannot do in-app purchases.
--
-- To test with the iTunes store, you must:
--   1. Set up your own In App Purchase products in iTunes Connect.
--   2. Modify the code below to suit your products.
--   3. Set up a test user account and provisioning for your iOS test device.
--   4. Build and deploy on device.
--
-- To test with the Google Play store, you must:
--   1. Set up your app on Google Play Developer Console, providing all details/assets 
--		needed for publishing.
--   2. Set up your own In App Purchase products in Google Play Developer Console.
--   3. Modify the code below to suit your products.
-- 	 4. Add your license key from Google Play Developer Console to config.lua.
--   5. Upload a release version of your app to Google Play Developer Console in any of 
--		these distribution channels (Beta, Alpha).
--   6. Publish your app to the Google Play store. It'll take anywhere between 2 and 
--		24 hours to finish.
--   7. Set up a test user account and add it to a Google Plus community for testing as 
--		well as the license testing list in Google Play Developer Console.
--   8. Log into your testing device with your test account, and only your test account.
--   9. Build and deploy on device.
--
-- Version: 1.5
--
-- Updated: May 13, 2015
-- 
-- Update History:
--  1.0    Initial version supporting iTunes in-app purchasing only.
--  1.1    Adding Google's Android Marketplace support.
--  1.2    Updating Google's Android Marketplace support to use Google IAP v3 plugin if possible.
--	1.3    Adding several testing features specific to the Google IAP v3 plugin.
--  1.4	   Removed Google IAP v2 since it's no longer supported by Google.
--  1.5    Refactored storeUI operations into storeUI.lua, interaction with product data into productData.lua
--         and made our dummy products in the simulator follow a similar code path to actual products.
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2015 Corona Labs Inc. All Rights Reserved.
--
--	Supports Graphics 2.0
---------------------------------------------------------------------------------------

-- Declare globals that persist through each module
-- You must call this first in order to use the "store" API.
local store = require ( "store" ) -- Available in Corona build #261 or later
local googleIAPv3 = false

-- Grab info about the platform
local platform = system.getInfo( "platformName" )

-- Determine if this app is running within the Corona Simulator.
if platform == "Mac OS X" or platform == "Win" then
	platform = system.getInfo("environment") -- For ease in checking platforms later
end

-- IAP in Google Play requires Corona build #1128 or later, so verify we have it
assert( tonumber( string.sub( system.getInfo( "build" ), 6 ) ) >= 1128 )

if ( platform == "Android" ) then
    store = require( "plugin.google.iap.v3" )
    googleIAPv3 = true
elseif store.availableStores.apple then
	-- iOS is supported
elseif ( platform == "simulator" ) then
    native.showAlert( "Notice", "In-app purchases are not supported in the Corona Simulator.", { "OK" } )
else
	native.showAlert( "Notice", "In-app purchases are not supported on this system/device.", { "OK" } )
end

-- Interact with IAP product data
local productData = require( "productData" )
productData.setProductList( platform )

-- This is needed for the storeUI controls.
local storeUI = require( "storeUI" )
storeUI.setPlatform( platform )
storeUI.setStore( store )

-- Hide the status bar.
display.setStatusBar( display.HiddenStatusBar )

-- Unbuffer console output for debugging 
io.output( ):setvbuf( 'no' )  -- Remove me for production code

local titlecard
local bg

-------------------------------------------------------------------------------
-- Function used to display a splashscreen.
-------------------------------------------------------------------------------
local function showTitle( )
	titlecard = display.newImage( "titlecard.png", display.contentCenterX, display.contentCenterY, true )
end

-------------------------------------------------------------------------------
-- Handler to receive product information 
-- This callback is set up by store.loadProducts()
-------------------------------------------------------------------------------
local function onLoadProducts( event )
	-- Debug info for testing
	print( "In onLoadProducts()" )

	productData.setData( event )
 
	storeUI.refreshProductFields( productData )
end

-------------------------------------------------------------------------------
-- Displays in-app purchase options.
-- Loads product information from store if possible. 
-------------------------------------------------------------------------------
local function loadStoreProducts( )
	-- Usually you would only list products for purchase if the device supports in-app purchases.
	-- But for the sake of testing the user interface, you might want to list products if running on the simulator too.
	if platform == "simulator" or store.isActive then
		if store.canLoadProducts then
			-- Property "canLoadProducts" indicates that localized product information such as name and price
			-- can be retrieved from the store (such as iTunes). Fetch all product info here asynchronously.
			print ( "Loading products" )
			store.loadProducts( productData.getList( ), onLoadProducts )
			print ( "After store.loadProducts, waiting for callback" )
		else
			-- Unable to retrieve products from the store because:
			-- 1) The store does not support apps fetching products, such as Google's Android Marketplace.
			-- 2) No store was loaded, in which case we could load dummy items or display no items to purchase
			-- So, we'll call onLoadProducts with the dummy product data
			print ( "Loading dummy products" )
			local dummyData = 
			{
				name = tostring( productData.getDummyProductList( ) ),
				products = productData.getDummyProductData( ),
				invalidProducts = {},
			}
			onLoadProducts( dummyData )
		end
	end
end

-------------------------------------------------------------------------------
-- Creates buttons for store interation outside of purchasing products.
-- This includes loading products, restoring purchases, etc.
-------------------------------------------------------------------------------
local function setupStoreFunctionButtons( )
	local buttonSpacing = 5

	-- Create and position LoadProducts and Restore button.
	-- We have the store library call second in this conditional to avoid 
	-- trying to call the store library while in the simulator.
	if platform == "simulator" or store.isActive then
		
		------------------------------------------
		-- Load Products button
		------------------------------------------
		local loadProducts = function ( product )
			-- Request the store to load all available products.
			if platform == "simulator" or store.isActive then
				print ( "Loading Products " )
				loadStoreProducts( )
			else
				storeUI.showStoreNotAvailableWarning( )
			end
		end

		local describeProducts = function ( )
			-- Display info in description area
			if platform == "Android" then
				storeUI.printToConsole( "Load products from the Google Play store." )
			elseif store.availableStores.apple then
				storeUI.printToConsole( "Load products from iOS App Store." )
			elseif platform == "simulator" then
				storeUI.printToConsole( "Load dummy products for the Corona Simulator." )
			end
		end

		local loadProductsButton = storeUI.newFunctionButton( "Load Products", describeProducts, loadProducts )
		loadProductsButton.x = buttonSpacing
		loadProductsButton.y = display.contentHeight - loadProductsButton.height / 2 - buttonSpacing

		------------------------------------------
		-- Restore button
		------------------------------------------
		local restore = function ( product )
			-- Request the store to restore all previously purchased products.
			if store.isActive then
				print ( "Restoring " )
				store.restore( )
			else
				storeUI.showStoreNotAvailableWarning( )
			end
		end

		local describeRestore = function ( )
			-- Display info in description area
			storeUI.printToConsole( "Test restore feature" )
		end

		local restoreButton = storeUI.newFunctionButton( "Test Restore", describeRestore, restore )
		restoreButton.x = buttonSpacing
		restoreButton.y = display.contentHeight - ( 1.5 * restoreButton.height ) - ( 2 * buttonSpacing )
	end

	-- Create and position Google-specific buttons
	-- We have the store library call second in this conditional to avoid 
	-- trying to call the store library while in the simulator.
	if platform == "Android" and store.isActive then

		------------------------------------------
		-- Google Wallet for initiating refunds
		------------------------------------------
		local openGoogleWallet = function ( )
			-- Open the browser and go to Google Wallet
			system.openURL( "https://wallet.google.com/merchant" )
		end

		local describeWallet = function ( )
			-- Display info in description area
			storeUI.printToConsole( "Go to Google Wallet" )
		end

		local walletButton = storeUI.newFunctionButton( "Google Wallet", describeWallet, openGoogleWallet )
		walletButton.x = ( 2 * buttonSpacing ) + walletButton.width
		walletButton.y = display.contentHeight - walletButton.height / 2 - buttonSpacing

		------------------------------------------
		-- Consume button for making purchases available again
		-- For Google IAP V3, both managed and unmanaged products are consumable.
		------------------------------------------
		local consume = function ( )
			if store.isActive then
				-- Consume all our products
				print ( "Consuming " )
				store.consumePurchase( productData.getList( ) )
			else
				storeUI.showStoreNotAvailableWarning( )
			end
		end

		local describeConsume = function ( )
			-- Display info in description area
			storeUI.printToConsole( "Test consuming all your purchases" )
		end

		local consumeButton = storeUI.newFunctionButton( "Test Consume", describeConsume, consume )
		consumeButton.x = ( 2 * buttonSpacing ) + consumeButton.width
		consumeButton.y = display.contentHeight - ( 1.5 * consumeButton.height ) - ( 2 * buttonSpacing )
	end
end

-------------------------------------------------------------------------------
-- Opens our store after it's been initialized
-------------------------------------------------------------------------------
local function openStore( event )

	titlecard:removeSelf( )
	-- Show store UI
	bg = display.newImage( "storebg.png", display.contentCenterX, display.contentCenterY, true )
	storeUI.initializeStoreMenu( )
	setupStoreFunctionButtons( )

end

-------------------------------------------------------------------------------
-- Handler for all store transactions
-- This callback is set up by store.init()
-------------------------------------------------------------------------------
local function transactionCallback( event )

	-- Log transaction info.
	print( "transactionCallback: Received event " .. tostring( event.name ) )
	print( "state: " .. tostring( event.transaction.state ) )
	print( "errorType: " .. tostring( event.transaction.errorType ) )
	print( "errorString: " .. tostring( event.transaction.errorString ) )

	if event.transaction.state == "purchased" then
		storeUI.printToConsole( "Transaction successful!" )
		print( "receipt: " .. tostring( event.transaction.receipt ) )
		print( "signature: " .. tostring( event.transaction.signature ) )

	elseif  event.transaction.state == "restored" then
		-- Reminder: your app must store this information somewhere
		-- Here we just display some of it
		storeUI.printToConsole( "Restoring transaction:" ..
								"\n   Original ID: " .. tostring( event.transaction.originalTransactionIdentifier ) ..
								"\n   Original date: " .. tostring( event.transaction.originalDate ) )
		print( "productIdentifier: " .. tostring( event.transaction.productIdentifier ) )
		print( "receipt: " .. tostring( event.transaction.receipt ) )
		print( "transactionIdentifier: " .. tostring( event.transaction.transactionIdentifier ) )
		print( "date: " .. tostring( event.transaction.date ) )
		print( "originalReceipt: " .. tostring( event.transaction.originalReceipt ) )

	elseif event.transaction.state == "consumed"  then
		-- Consume notifications is only supported by the Google Android Marketplace.
		-- Apple's app store does not support this.
		-- This is your opportunity to note that this object is available for purchase again.
		storeUI.printToConsole( "Consuming transaction:" ..
								"\n   Original ID: " .. tostring( event.transaction.originalTransactionIdentifier ) ..
								"\n   Original date: " .. tostring( event.transaction.originalDate ) )
		print( "productIdentifier: " .. tostring( event.transaction.productIdentifier ) )
		print( "receipt: " .. tostring( event.transaction.receipt ) )
		print( "transactionIdentifier: " .. tostring( event.transaction.transactionIdentifier ) )
		print( "date: " .. tostring( event.transaction.date ) )
		print( "originalReceipt: " .. tostring( event.transaction.originalReceipt ) )

	elseif  event.transaction.state == "refunded" then
		-- Refunds notifications is only supported by the Google Android Marketplace.
		-- Apple's app store does not support this.
		-- This is your opportunity to remove the refunded feature/product if you want.
		storeUI.printToConsole( "A previously purchased product was refunded by the store:" ..
								"\n	   For product ID = " .. tostring( event.transaction.productIdentifier ) )

	elseif event.transaction.state == "cancelled" then
		storeUI.printToConsole( "Transaction cancelled by user." )

	elseif event.transaction.state == "failed" then        
		storeUI.printToConsole( "Transaction failed, type: " .. 
			tostring( event.transaction.errorType ) .. " " .. tostring( event.transaction.errorString ) )
		
	else
		storeUI.printToConsole( "Unknown event" )
	end

	if store.availableStores.apple then
		-- Tell the store we are done with the transaction.
		-- If you are providing downloadable content, do not call this until
		-- the download has completed.
		store.finishTransaction( event.transaction )
	end

	-- Tell the user to select another option now that this transaction has finished
	timer.performWithDelay( 2000, storeUI.printOptionPrompt )
end

-------------------------------------------------------------------------------
-- Main
-------------------------------------------------------------------------------

-- Show title card
showTitle( )

-- Connect to store at startup, if available.
if googleIAPv3 then
  	store.init( "google", transactionCallback )
  	print( "Using Google's Android In-App Billing system." )
elseif store.availableStores.apple then
	store.init( "apple", transactionCallback )
	print( "Using Apple's In-App Purchase system." )
elseif platform == "simulator" then
    native.showAlert( "Notice", "In-app purchases are not supported in the Corona Simulator. Using dummy products.", { "OK" } )
else
	native.showAlert( "Notice", "In-app purchases are not supported on this system/device.", { "OK" } )
end

-- Hide title card, run store
timer.performWithDelay ( 1000, openStore )

collectgarbage( )

