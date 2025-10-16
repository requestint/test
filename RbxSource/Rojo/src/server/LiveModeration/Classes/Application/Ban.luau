local DatastoreService = game:GetService("DataStoreService")
local ChatUserdataStore = DatastoreService:GetDataStore("RespectiveInGameChatLogs")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MessagingService = game:GetService("MessagingService")
local BanUserDatStore = DatastoreService:GetDataStore("BanUserDataStore");

return function(UserDataStores, ResolvedTag, Userid, command)
	local success, result = pcall(function()
		
		--- Searching for account
		MessagingService:PublishAsync("FindSpecificAcc", {
			UserId = Userid,
			webhook_response = {
				content = "Successfully Added BanActivity For User!: "..`https://www.roblox.com/users/{Userid}/profile`
			}
		})
		
		--- Applying to datastore
		BanUserDatStore:SetAsync("PLAYER_"..Userid, -1)
		
		return true
	end)
	
	if success and result then
		return result
	else
		return {
			content = "Failed to add BanActivity For User!: "..`https://www.roblox.com/users/{Userid}/profile`
		}
	end
end