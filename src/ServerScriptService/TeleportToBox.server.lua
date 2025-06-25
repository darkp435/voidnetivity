-- boilerplate
local teleportEvent: RemoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("TeleportEvent")
local serverStorage: ServerStorage = game:GetService("ServerStorage")
local serverScriptService: ServerScriptService = game:GetService("ServerScriptService")
local hostSystem: table = require(serverScriptService.HostSystem)

local box = workspace.Union:Clone()

local function bruteForceMinigame(): nil
	-- placeholder function to get it working, will add minigame later
	-- true means that the user has successfully completed it and vice versa
	task.wait(5)
end

-- TODO: add more minigames later

local function activateMinigame(fileName: string)
	if fileName == "brute.exe" then
		bruteForceMinigame()
	elseif fileName == "script.exe" then
		-- TODO: implement this in future
	end
end

local function teleportPlayerToHost(player: Player, hostname: string)
	player.Character.HumanoidRootPart.CFrame = hostSystem[hostname]:getCFrame()
end

local function createHost(player: Player, hostname: string)
	local hostMap = serverStorage:FindFirstChild(hostSystem[hostname]:getMap())
	hostMap.Position = hostSystem[hostname]:getVector3()
	teleportPlayerToHost(player, hostname)
end

teleportEvent.OnServerEvent:Connect(function(player: Player, fileName: string, targetHostname: string)
	local coords = CFrame.new(math.random(1, 10000), 1000, math.random(1, 10000))
	local file = player.Backpack:FindFirstChild(fileName)
	
	if player and file and file:IsA("Tool") then
		box.CFrame = coords
		box.Parent = workspace
		local humanoid = player.Character:WaitForChild("Humanoid")
		local hrp = player.Character:WaitForChild("HumanoidRootPart")
		if humanoid and hrp then
			hrp.CFrame = coords
			local success = activateMinigame(fileName)
			
			if success then
				if not workspace:FindFirstChild(targetHostname) then
					createHost(player, targetHostname)
				else
					teleportPlayerToHost(player, targetHostname)
				end
			end
		else
			print("error")
		end
	end
end)
