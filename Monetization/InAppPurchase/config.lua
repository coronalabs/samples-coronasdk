application = 
{
	content = 
	{ 
		width = 480,
		height = 720,
		scale = "letterbox",
		fps = 60,
	},

	license =
	{
		google =
		{
			key = "Your key from Google Play Dev Console goes here",
			-- This is optional, it can be "strict" or "serverManaged" (default).
			-- strict WILL NOT cache the server response so if there is no network access it will always return false.
			-- serverManaged WILL cache the server response so if there is no network access it can use the cached response.
			policy = "serverManaged", 
		},
	},
}
