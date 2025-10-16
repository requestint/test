local sysconfig = {
	--- [ SYSTEM CONFIGURATION ] ---
	Prefix = ":", -- the prefix for the bot
	Admins = { "1234567890", "0987654321" }, -- the admins of the bot
	request_refreshrate_check = 3, -- How long it takes for roblox to repeat the cycle to check the endpoint to check for any http / discord bot command requests

	--- SECURITY CONFIGURATION
	-- COMMING SOON!

	--- FEATURE & ACCESS CONFIGURATION
	IncludeVisualDebugger = false, -- weather or not to include the visual debugger for the respective client
	BenchMarkingEnabled = true, -- weather or not to enable the benchmarking feature that enables basic logging of what's being done on the server and etc
	EnablePlayerModerationTools = true, -- This will decide if this script has enabled the feature for access to Commands stored under Classes

	--- ENDPOINT & OTHER CONFIGURATION
	Discord_Endpoint_Response = "https://middleware.up.railway.app/get-commands", -- // the end point act's as a listener for the bot to get commands being requested
	Webhook_EndPoint_Responder = "https://discord.com/api/webhooks/1425266957430820915/GnhoGxqTfnBFo8dX3OYRj8RuUXndx0rPnrvxzad7b4LYFnbaUExSmMHwkp0__D17ggjZ", -- When lunching a command any return value or evaluation will be posted through this responder inorder to avoid confliction with attempting to reroute through the "Discord_Endpoint_Response". If it we're done through that way it could lead to invaild or failed requests which would mean it would've discarded the packets being sent
}

return sysconfig
