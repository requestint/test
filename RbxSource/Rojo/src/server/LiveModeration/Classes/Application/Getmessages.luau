local DatastoreService = game:GetService("DataStoreService")
local ChatUserdataStore = DatastoreService:GetDataStore("RespectiveInGameChatLogs")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

return function(Dict, method : "Datastore" | "table", Userid, Params)
	--- Assertions / vaildaters
	assert(Dict, "No datastores or storage provided")
	assert(Userid, "No Userid provided")

	--- now we'll get the chat data
	local Messagepayload = {}
	local chatdata
	
	
	--print(Dict, method, Userid, Params)
	
	--- we'll double check if there is any existing chat data in 
	-- the main table called ChatMessages, that is being passed in Dict.table
	-- if there is we'll use that instead of the datastore
	if Dict.table[Players:GetPlayerByUserId(Userid)] then
		chatdata = Dict.table[Players:GetPlayerByUserId(Userid)]
	else
		chatdata = ChatUserdataStore:GetAsync("PLAYER_"..Userid)
	end
	
	
	--- Sending console message
	warn('GETTING CHAT-DATA : ', chatdata, method)
	
	--- checking for keywords if a priameter for "Keyword"
	-- inside the dictionary has been passed in
	if Params.Keyword then
		print('KEYWORD : ', Params.Keyword)
		
		--- We'll attempt to decode the string incase it has been stringed / json encoded
		local success, decoded = pcall(function()
			return HttpService:JSONDecode(chatdata)
		end)
		
		--- if it was we'll decode it
		if success then
			chatdata = decoded
		elseif string.match(string.lower(decoded), "not a luau table") then
			chatdata = chatdata
		else
			warn('error', decoded)
			return {
				content = 'failed to complete method'
			}
		end
		
		for index, message in chatdata do
			if string.match(string.lower(message.message), string.lower(Params.Keyword)) then
				
			end
		end
		
		
	end
	
	
	--- if that data is nil or the user has no chat data we'll return an empty table
	if not chatdata then
		return {
			content = "User has no chat data."
		}
	end

	--- now we'll return the chat data
	local request_payload = {
		content = "Chat data for user: "..`https://www.roblox.com/users/{Userid}/profile` ,
		embeds = {
			{
				title = "User Chat Data",
				description = game:GetService("HttpService"):JSONEncode(chatdata)
			}
		}
	}
	
	--- returning data ->
	return request_payload
end
