-------------------------------------------------------------------------------
--  Product IDs should match the In App Purchase products set up in iTunes Connect.
--  We cannot get them from the iTunes store so here they are hard coded;
--  your app could obtain them dynamically from your server.
-------------------------------------------------------------------------------

-- Create table for productData library
local productData = {}

-- To be assigned a product list from one of the arrays below after we've connected to a store.
-- Will be nil if no store is supported on this system/device.
local currentProductList = nil

-- Tables with data on valid and invalid products
-- Assigned by productData.setData()
productData.validProducts = {}
productData.invalidProducts = {}


-- Product IDs for the "apple" app store.
local appleProductList =
{
	-- These Product IDs must already be set up in your store
	-- We'll use this list to retrieve prices etc. for each item
	-- Note, this simple test only has room for about 6 items, please adjust accordingly
	-- The iTunes store will not validate bad Product IDs.
	"com.anscamobile.NewExampleInAppPurchase.ConsumableTier1",
	"com.anscamobile.NewExampleInAppPurchase.NonConsumableTier1",
	"com.anscamobile.NewExampleInAppPurchase.SubscriptionTier1",
}

-- Non-subscription product IDs for the "google" Android Marketplace.
local googleProductList =
{
	-- Real Product IDs for the "google" Android Marketplace.
	-- A managed product that can only be purchased once per user account. Google Play manages the transaction info.
	"iaptesting.managed",

	-- A product that isn't managed by Google Play. The app must store transaction info itself.
	-- In Google IAP V3, unmanaged products are treated like managed products and need to be explicitly consumed.
	"iaptesting.unmanaged",

	-- A bad product ID. For testing what actually happens in this case.
	"iaptesting.badid",
}

-- Dummy product list to display in the simulator.
local dummyProductList =
{
	"dummy.refill",
	"dummy.glass",
	"dummy.dose",
}

function productData.getDummyProductList( )
	return dummyProductList
end

-- Dummy product data for use in the simulator
local dummyProductData = 
{ 
	{
		title = "Lemonade refill",
		description = "A wonderful dummy product for testing.",
		productIdentifier = dummyProductList[1],
	},

	{
		title = "Drinking glass",
		description = "Makes lemonade easier to drink.",
		productIdentifier = dummyProductList[2],
	},

	{
		title = "Daily dose",
		description = "Made fresh daily!",
		productIdentifier = dummyProductList[3],
	},
}

-------------------------------------------------------------------------------
-- Returns the product data for the dummy product list.
-------------------------------------------------------------------------------
function productData.getDummyProductData( )
	return dummyProductData
end

-------------------------------------------------------------------------------
-- Returns the product list for the platform we're running on.
-------------------------------------------------------------------------------
function productData.getList( )
	return currentProductList
end

-------------------------------------------------------------------------------
-- Sets the product data that we wish to use for this platform.
-------------------------------------------------------------------------------
function productData.setData( data )
  	if ( data.isError ) then
    	print( "Error in loading products " 
      	.. data.errorType .. ": " .. data.errorString )
    	return
  	end
	print( "data, data.name", data, data.name )
	print( data.products )
	print( "#data.products", #data.products )
	io.flush( )  -- remove for production

	-- save for later use
	productData.validProducts = data.products
	productData.invalidProducts = data.invalidProducts
end

-------------------------------------------------------------------------------
-- Sets the product list that we wish to use for this platform.
-------------------------------------------------------------------------------
function productData.setProductList( platform )
	-- Set up the product list for this platform
	if ( platform == "Android" ) then
	    currentProductList = googleProductList
	elseif ( platform == "iPhone OS" ) then
		currentProductList = appleProductList
	elseif ( platform == "simulator" ) then
		currentProductList = dummyProductList
	else
		-- Platform doesn't support IAP
		native.showAlert( "Notice", "In-app purchases are not supported on this system/device.", { "OK" } )
	end
end

-- Return product data library for external use
return productData
