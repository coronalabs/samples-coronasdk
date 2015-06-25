application = 
{
	content = 
	{ 
		width = 320,
		height = 480,
		scale = "letterbox",
		fps = 60,
	},
	license =
	{
		google =
		{
			key = "Your Key Here",
			-- This is optional, it can be strict or serverManaged(default).
			-- stric WILL NOT cache the server response so if there is no network access then it will always return false.
			-- serverManaged WILL cache the server response so if there is no network access it can use the cached response.
			policy = "serverManaged", 
		},
	},
}