local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/BlackLabel98/bss/main/k.lua'))()
--//Farming
local FarmingWindow = library:CreateWindow("Farming")
local function GetNearest(plr)
	local Closest = nil
	local PlayerPosition = plr
	for i,v in pairs(workspace:WaitForChild("Enemy"):GetDescendants()) do
		if v and v.ClassName== "Part" then
			if Closest == nil then
				Closest = v
			else
				if (PlayerPosition - v.Position).magnitude < (Closest.Position - PlayerPosition).magnitude then
					Closest = v
				end
			end
		end
	end
	return Closest
end
local function Teleport(enemy)
	local plr = game.Players.LocalPlayer
	local pChr = plr.Character or plr.CharacterAdded:Wait()
	local pHroot = pChr:WaitForChild("HumanoidRootPart")
	local pHumanoid = pChr:WaitForChild("Humanoid")
	pChr:SetPrimaryPartCFrame(enemy)
end
FarmingWindow:Toggle("Start Farming", {flag = 'StartFarming'}, function(new)
	task.spawn(function()
		while FarmingWindow.flags.StartFarming do
			pcall(function()
				game:GetService("ReplicatedStorage"):WaitForChild("System"):WaitForChild("SystemClick"):WaitForChild("Click"):FireServer()
			end)
			task.wait(0.1)
		end
	end)
	task.spawn(function()
		while FarmingWindow.flags.StartFarming do
			pcall(function()
				local enemy = GetNearest(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
				if enemy then
					local tempID = enemy.Name
					local tempName = enemy.Parent.Name
					local tempFullName = tempName.."_boss"
					if enemy.CFrame then
						Teleport(enemy.CFrame)
					end
					repeat task.wait() until not enemy.HP or enemy.HP == nil or not FarmingWindow.flags.StartFarming
					local args = {
						[1] = "\230\148\190\231\148\159\232\191\153\229\143\170\229\174\160\231\137\169",
						[2] = {
							["onlyTag"] = tostring(tempFullName),
							["onlyID"] = tonumber(tempID)
						}
					}
					game:GetService("ReplicatedStorage"):WaitForChild("Msg"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
				end
			end)
			task.wait(1)
		end
	end)
end)
