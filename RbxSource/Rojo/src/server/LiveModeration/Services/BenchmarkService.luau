------------------------
------ [ Services ] ------
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local messagingservice = game:GetService("MessagingService")
local DatastoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

-------------------------
------ [ Modules ] ------


------------------------
------ [ Varibles ] ------


------------------------
------ [ Tables ] ------
local BenchmarkingService = {}

BenchmarkingService.__index = BenchmarkingService

---------------------------
------ [ Functions ] ------
function BenchmarkingService.init() 
	debug.profilebegin('Initilizing Benchmarking Util')
	--- @Varibles
	local self = setmetatable({}, BenchmarkingService)
	
	--[[
		now we'll add a timestamp varible stored inside	
		reason we do this is so when we call 
		BenchmarkingService:Terminate(), we'll be able to calculate
		the approximent time it took to run
	]]
	
	self.StartTime = os.time()
	
	--- we also need a varible to define our decicated terminal
	-- so where know where to log too
	self.Terminals = {
		Source = game:GetService("TestService"), -- In this case our default terminal would be log service since it allows us to add methods and log 
		
		--- Later on adding visual debug access and etc!
	}
	
	debug.profileend()
	--- now we'll return the object
	return self
end

function BenchmarkingService:Terminate()
	debug.profilebegin('Terminating Benchmarking Util')
	--- Now that we're ending the benchmarking session we'll now
	-- calculate the time it took to run by taking the StartTime and subtracting it from the current time
	
	self.result = os.time() - self.StartTime
	
	--- now we'll get our decicated terminal and log to it saying the benchmarking has ended
	--self.Terminals.Source:Message("Benchmarking has ended, the time it took to run was: " .. self.result .. " seconds")
	
	debug.profileend()
	--- now we'll return the result
	return self.result
end


return BenchmarkingService
