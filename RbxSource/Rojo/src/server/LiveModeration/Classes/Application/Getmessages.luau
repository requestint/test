local DatastoreService = game:GetService("DataStoreService")
local ChatUserdataStore = DatastoreService:GetDataStore("RespectiveInGameChatLogs")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

return function(Dict, method : "Datastore" | "table", Userid, Botrequest)
	--- Assertions / vaildaters
	assert(Dict, "No datastores or storage provided")
	assert(Userid, "No Userid provided")

	--- Variables
	local Messagepayload = {}
	local chatdata
	
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
	if Botrequest[4] and Botrequest[4].name:lower() == "keyword" then
		print('KEYWORD : ', Botrequest[4].value)
		
		--- We'll attempt to decode the string incase it has been stringed / json encoded
		local success, decoded = pcall(function()
			if typeof(chatdata):lower() == 'string' then 
				HttpService:JSONDecode(chatdata)
			end
			
			return chatdata
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
		
		
		--- Now that we've decoded the nesscary data we'll search for the keyword
		-- if the keyword is found we'll add it to the payload
		for index, data in chatdata do
			if string.find(data.message, "%f[%w_]" .. Botrequest[4].value .. "%f[^%w_]") ~= nil then
				table.insert(Messagepayload, data.message)
			else
				continue
			end
		end
		
		--- now that we've the payload essentially we can now transfer it 
		-- to the Chatdata table since we're not using it for any references currently
		chatdata = #Messagepayload > 0 and Messagepayload or nil -- Meaning that if the payload is empty it'll return nil
	end
	
	
	--- if that data is nil or the user has no chat data we'll return an empty table
	if not chatdata then
		return {
			content = "Could Not locate any messages that have a specific keyword or any messages stored from user."
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
