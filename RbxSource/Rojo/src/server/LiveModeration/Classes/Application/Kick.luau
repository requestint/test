local DatastoreService = game:GetService("DataStoreService")
local ChatUserdataStore = DatastoreService:GetDataStore("RespectiveInGameChatLogs")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MessagingService = game:GetService("MessagingService")
local BanUserDatStore = DatastoreService:GetDataStore("BanUserDataStore");

return function(UserDataStores, ResolvedTag, Userid, command)
	local success, result = pcall(function()

		--- Searching for account this will auto kick the user aswell
		MessagingService:PublishAsync("FindSpecificAcc", {
			UserId = Userid,
			webhook_response = {
				content = "Successfully Kicked User!: "..`https://www.roblox.com/users/{Userid}/profile`
			}
		})
		
		
		return true
	end)

	if success and result then
		return result
	else
		return {
			content = "Failed to Kick User!: "..`https://www.roblox.com/users/{Userid}/profile`
		}
	end
end