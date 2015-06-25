-- config.lua

application =
{
	content =
	{
		width = 320,
		height = 480,
		scale = "letterbox",

		imageSuffix =
		{
			["-x15"] = 1.5,		-- A good scale for Droid, Nexus One, etc.
			["-x2"] = 2,		-- A good scale for iPhone 4 and iPad
		},
	},
}
