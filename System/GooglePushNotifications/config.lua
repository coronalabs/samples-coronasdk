application =
{
	content =
	{
		width = 320,
		height = 480,
		scale = "letterbox",
	},
	notification =
	{
		google =
		{
			-- This Project Number (also known as a Sender ID) tells Corona to register this application
			-- for push notifications with the Google Cloud Messaging service on startup.
			-- This number can be obtained from the Google API Console at:  https://code.google.com/apis/console
			projectNumber = "Your project number goes here.",
		},
	},
}
