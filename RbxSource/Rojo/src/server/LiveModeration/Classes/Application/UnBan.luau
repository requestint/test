local DatastoreService = game:GetService("DataStoreService")
local ChatUserdataStore = DatastoreService:GetDataStore("RespectiveInGameChatLogs")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MessagingService = game:GetService("MessagingService")
local BanUserDatStore = DatastoreService:GetDataStore("BanUserDataStore");

return function(UserDataStores, ResolvedTag, Userid, Botrequest)
	local success, result = pcall(function()
		BanUserDatStore:RemoveAsync("PLAYER_"..Userid)
		return {
			content = "Successfully Removed BanActivity For User!: "..`https://www.roblox.com/users/{Userid}/profile`
		}
	end)
	
	if success and result then
		
		--- now we'll return the result and then search for the player if they're in any servers
		-- if they're then we'll kick them then when they try to join the game the important moderation data will be loaded
		-- and they'll be banned until they've consulted with a mod or admin
		MessagingService:PublishAsync("ApplyServerSearch", {UserId = tonumber(Userid), webhook_response = {
			content = 'Searching for user, Status : Undefined'
		}}) -- < fires a signal that occurs server wide on all servers
		
		--- ENDING FUNCTION
		return result
	else
		--return 'Failed to Apply BanActivity For User!'
		return {
			content = "Failed to Remove BanActivity For User!: "..`https://www.roblox.com/users/{Userid}/profile`
		}
	end
end