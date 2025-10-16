return function(UserDataStores, ResolvedTag, TargetUser, command)
	--print(UserDataStores, ResolvedTag, TargetUser, command)

	--- Now we're gonna kick the user and then return a response that is vaild
	-- for the response webhook, so that we could alert that somebody has been kicked
	TargetUser:Kick("You have been kicked from the game by an admin.")

	--- Now we'll return the response
	return {
		content = "User has been kicked.",
		embeds = {
			{
				title = "User Kicked",
				description = "User has been kicked by an admin.",
			},
		},
	}
end
