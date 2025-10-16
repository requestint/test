--------------------------
------ [ Services ] ------
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local messagingservice = game:GetService("MessagingService")
local DatastoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

-------------------------
------ [ Modules ] ------
local SysConfig = require(script.Important.config)
local BenchmarkingService = require(script.Services.BenchmarkService)

------------------------
------ [ Varibles ] ------
local ENDPOINT = SysConfig.Discord_Endpoint_Response
local WehbookUrl_Response_Test = SysConfig.Webhook_EndPoint_Responder

-- Anything with no value is a varible placeholder
-- for the other functions to use collaberatitively
local thread
local StartupTime

------------------------
------ [ Tables ] ------
local ChatMessages = {}
local DataStores = {
	ChatDatastore = DatastoreService:GetDataStore("RespectiveInGameChatLogs"),
	BanUserDataStore = DatastoreService:GetDataStore("BanUserDataStore"),
}

---------------------------
------ [ Functions ] ------
function Callback(command, repository: Instance)
	debug.profilebegin("Live-Moderation : Callback() -> (request-Anaylizer)")

	--- @Varibles
	--local RequestedUserId = command.username
	--local Account = Players:WaitForChild(username, 5)
	local UserTargetid = command.username
	local Tag

	warn("Proccessing Command Packet :", command)

	--- removing any old value from start time if it's a number
	if StartupTime and typeof(StartupTime) == "number" then
		StartupTime = nil
	end

	if not tonumber(UserTargetid) then
		warn("Invalid User ID :", UserTargetid, command)
		return
	end

	--- we'll check if benchmarking is enabled
	if SysConfig.Benchmarking then
		StartupTime = BenchmarkingService.init()
	else
		-- We'll ignore it assuming the feature for it has been set to off / disabled
		StartupTime = "Disabled"
	end

	--- we'll check if the user's chat log data has already been loaded
	-- inorder to depict the methods of fetching chatdata from the Datastore or the chatlogs table
	if not ChatMessages[Players:GetPlayerByUserId(tonumber(UserTargetid))] then
		Tag = "Datastore"
	else
		Tag = "table"
	end

	--- now we'll handle the command
	local success, request = pcall(function(...)
		-- @Varibles
		local module = require(repository:WaitForChild(command.type))

		--- Now we'll print the module aquired and return it
		return module(...)
	end, { Datastore = DataStores, table = ChatMessages }, Tag, tonumber(UserTargetid), command)

	-- now we'll check if we got a success
	if not success then
		warn("Failed to execute command:", request)
	else
		HttpService:PostAsync(WehbookUrl_Response_Test, HttpService:JSONEncode(request))
	end

	--- now we'll end the active benchmarking and trigger the output
	if StartupTime ~= "Disabled" then
		StartupTime:Terminate() -- by default will decicate the primary Output
		StartupTime = nil
	end

	--debug.profileend()
end

local function GetLegitimateUser(content: string)
	debug.profilebegin("Live-Moderation : GetLegitimateUser() -> (User-Authenticator)")

	--- We're gonna go through every exisitng user inside of this server
	-- and see if the username matches the one in the request
	for _, user in pairs(Players:GetPlayers()) do
		if user.Name == content then
			return user
		end
	end

	return nil -- < meaning no user was found
end

local function GetBotResponse()
	debug.profilebegin("Live-Moderation : GetBotResponse() -> (request-Listener)")

	--- Getting the response from the endpoint
	-- and then we'll turn it into a luau table shown at line 83
	local success, response = pcall(function()
		return HttpService:GetAsync(ENDPOINT)
	end)

	if success then
		--print('port response : ', response)
		-- @Varibles
		local commands = HttpService:JSONDecode(response)

		--- going through each active submmited command
		-- that was requested from the discord bot
		for _, command in ipairs(commands) do
			--- we'll add a statment that'll ensure the given placeid
			-- is the same as the one the game is currently running on

			print(command)

			if not command.PlaceId then
				continue
			end --- Incase it somehow passed through the middleware without a placeid
			if game.PlaceId ~= tonumber(command.PlaceId) then
				continue
			end -- < this will skip the command being requested since it was not meant for this experince

			Callback(command, script.Classes.Application)
		end
	else
		warn("Failed to fetch commands:", response)
	end
end

--- Running a sepreate thread for the bot
-- so roblox can repeadly search for requests every time this loop
-- has been ran every X seconds where x is the refreshrate

-- This thread will be contiunuously running in the background
thread = coroutine.create(function(Session)
	--- Main Chunk of code
	while true do
		GetBotResponse()

		--- Closing Benchmarking Session before
		-- disabling coroutine
		if StartupTime ~= "Disabled" then
			Session:Terminate()
		end

		-- Starting Yield, (Automatically gets resumed every time the refreshrate pops in the main thread)
		coroutine.yield()
	end
end)

-- Main thread
task.spawn(function()
	while task.wait(SysConfig.request_refreshrate_check) do
		--- @varibles
		local session = BenchmarkingService.init()

		--- Running usable coroutine
		coroutine.resume(thread, session)
	end
end)

--- Creating a connection for when the player join's
-- so we can load existing chat data
Players.PlayerAdded:Connect(function(plr)
	--print(game.PlaceId, 130169044975144)
	--- Checking for any sort of moderation data
	if DataStores.BanUserDataStore:GetAsync("PLAYER_" .. plr.UserId) ~= nil then
		warn(plr.Name .. " Is-Banned for " .. DataStores.BanUserDataStore:GetAsync("PLAYER_" .. plr.UserId))

		plr:Kick("Your Currently Banned From this experince. Please Contact Staff to dispute the ban!")
	end

	--- Presetting user-messages
	if DataStores.ChatDatastore:GetAsync("PLAYER_" .. plr.UserId) ~= nil then
		ChatMessages[plr] = HttpService:JSONDecode(DataStores.ChatDatastore:GetAsync("PLAYER_" .. plr.UserId))
	else
		ChatMessages[plr] = {}
	end

	--- Chatted event
	plr.Chatted:Connect(function(msg)
		--- This section of the event is where we convert user messages
		-- into translatable userdata for chatlogs that can be repulled at any time

		local success, StorableMessage = pcall(function()
			return {
				type = "chat",
				username = plr.Name,
				message = msg,
				time = DateTime.now():ToIsoDate(),
			}
		end)

		if success and StorableMessage then
			print("storable message : ", StorableMessage)

			--- now we'll publish this to the other servers
			messagingservice:PublishAsync("CHAT", StorableMessage)
		else
			warn("Failed to encode message:", StorableMessage)
		end

		--- The Section Below this is for searching for if it's a command
		-- and then run the command, we can check this by searching for the prefix
		-- stored inside of [script.Important.SysConfig.Prefix]

		if string.sub(msg, 1, 1) == SysConfig.Prefix and SysConfig.EnablePlayerModerationTools then
			-- now that we've delcared if it's a command we can now
			-- use the function we did for firing a command from a bot and fire it here
			-- since the logic will be the same for the player

			-- Getting Module Name Directly via subbing the message against the
			-- command modules [script.Classes.Commands]

			for index, module in script.Classes.Commands:GetChildren() do
				if string.sub(msg, 2, string.len(module.Name:gsub(" ", ""))) then
					task.spawn(
						Callback,
						{
							type = module.Name,
							username = GetLegitimateUser(msg:gsub(module.Name, ""):gsub(":", ""):gsub(" ", "")),
						},
						script.Classes.Commands
					)
				end
			end
		end
	end)
end)

--- Creating connections that'll act on every server
messagingservice:SubscribeAsync("CHAT", function(message)
	debug.profilebegin("Live-Moderation : Serverwide-Event MessagingService:SubscribleAsync(), Topic : CHAT")
	print("message received : ", message.Data)

	--- // Varibles
	local Player

	--- we'll search for a particaular player via name
	for _, player in pairs(game.Players:GetPlayers()) do
		if player.Name == message.Data.username then
			Player = player
			break
		end
	end

	--- now we'll save this to a datastore
	table.insert(ChatMessages[Player], message.Data)
end)

messagingservice:SubscribeAsync("FindSpecificAcc", function(message)
	debug.profilebegin(
		"Live-Moderation : Serverwide-Event MessagingService:SubscribleAsync(), Topic : ApplyServerSearch"
	)
	--- // Varibles
	local UserfoundinAnyServer = false

	-- we'll send a webhook response with the info below
	-- if the player has been found that we're looking for

	------------------------------------
	-- * User Has been found		  --
	-- * What Server They we're in	  --
	-- * What their current status is --
	-- * Day and Time				  --
	------------------------------------

	--- Other-wise we'll send a webhook response saying the user has not been found ingame

	for index, player in Players:GetPlayers() do
		if player.UserId == message.Data.UserId then
			player:Kick("You Have Been Banned. Please Consult To a moderator or an admin To See if this was a mistake!")
			UserfoundinAnyServer = true
		end

		continue
	end

	--- Posting to webhook mentioning wether or not if a user has been found
	if UserfoundinAnyServer then
		HttpService:PostAsync(WehbookUrl_Response_Test, HttpService:JSONEncode(message.Data.webhook_response))
	else
		HttpService:PostAsync(
			WehbookUrl_Response_Test,
			HttpService:JSONEncode({
				content = "User has not been found in any server",
			})
		)
	end
end)

--- Updating the exisitng or new userdata for the client
-- so when they rejoin they've new chat records
game.Players.PlayerRemoving:Connect(function(plr)
	--- now we'll save this to a datastore
	DataStores.ChatDatastore:SetAsync("PLAYER_" .. plr.UserId, HttpService:JSONEncode(ChatMessages[plr]))
end)
