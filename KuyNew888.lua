if not game:IsLoaded() then game.Loaded:Wait() end

print('--[[Join Team]]--')

do -- Team Script
	repeat 
		ChooseTeam = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ChooseTeam",true)
		UIController = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("UIController",true)
		if UIController and ChooseTeam then
			if ChooseTeam.Visible then
				for i,v in pairs(getgc()) do
					if type(v) == "function" and getfenv(v).script == UIController then
						local constant = getconstants(v)
						pcall(function()
							if constant[1] == "Pirates" and #constant == 1 then
								v(getgenv().Team or "Pirates")
							end
						end)
					end
				end
			end
		end
		wait(1)
	until game.Players.LocalPlayer.Team
	repeat wait() until game.Players.LocalPlayer.Character
end

task.wait()

Loaded_Successfully = false

local oldwrite = writefile
writefile = function(a,b,...)
	return oldwrite(tostring(a),tostring(b),...)
end

game:GetService("Players").LocalPlayer.Idled:connect(function()
	game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	task.wait(1)
	game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

local placeId = game.PlaceId
if placeId == 2753915549 then
	OldWorld = true
elseif placeId == 4442272183 then
	NewWorld = true
elseif placeId == 7449423635 then
	ThreeWorld = true
end

-- Configs

if type(getgenv().Configs) ~= "table" then
	getgenv().Configs = {
		Main = {
			FarmLevel = false,
			Accept_Quest = true,
			BossAndDoubleQuest = false,
			Skip_Level_Farm = false,

			Auto_New_World = false,

			Auto_Factory = false,
			Auto_Third_Sea = false,

			AutoBuyTrueTripleKatana = false,
			AutoBuyLegendarySword = false,
			SelectLegendarySword = {},
			LockLegendarySwordToBuy = false,

			SelectHakiColor = {},
			AutoBuyEnhancement = false,
			LockHakiColorToBuy = false,
			SelectMaterial = {},
			AutoFarmMaterial = false,

			Select_Sword_List = {"Saber"},
			Auto_Farm_Sword_Mastery_List = false,
			Select_Rarity_Sword_List = {},
			Select_Mastery_Sword_List = 600,

			Skill_F = false,
			Skill_Z = false,
			Skill_X = false,
			Skill_C = false,
			Skill_V = false,
			Skill_Click = false,
			Skill_F_Time = 0.1,
			Skill_Z_Time = 0.1,
			Skill_X_Time = 0.1,
			Skill_C_Time = 0.1,
			Skill_V_Time = 0.1,

			FightingStyle = {
				Auto_Superhuman = false,
				Auto_Sharkman_Karate = false,
				Auto_Death_Step = false,
				Auto_Dragon_Talon = false,
				Auto_Electric_Claw = false,
				Auto_Godhuman = false,
			},

			Settings = {
				Level = {
					Lock_Level_At = 2550,
					Start_Level_Lock = false
				},
				Mastery = {
					Select_Mastery_Lock_At = 600,
					Weapon_Lock_Master = {}, -- "Combat"
					Start_Mastery_Lock = false
				},
				Beli = {
					Select_Beli_Lock_At = 100000000,
					Start_Beli_Lock = false
				},
				Fragment = {
					Select_Fragment_Lock_At = 100000,
					Start_Fragment_Lock = false
				},
				Code = {
					Select_Level_Redeem = 1,
					Auto_Redeem_Code = false
				}
			},
			Boss = {
				Select_Boss = {},
				Auto_Farm_Boss_All = false,
				Auto_Boss_Farm_Hop = false
			}
		},
		Settings = {
			FastAttackMode = {"Super Fast"},
			Select_Weapons = {}, -- "Combat"
			Auto_Fast_mode = false,
			Bypass_Teleport = true,
			Fast_Attack = true,
			Auto_Haki = true,
			Auto_Haki_Ken = false,
			Disabled_NotifyAndDamage = false
		},
		Stats = {
			Kaitun = false,
			Melee = false,
			Defense = false,
			Sword = false,
			Gun = false,
			DevilFruit = false
		},
		Automatics = {
			Auto_Saber = false,

			Auto_PoleV1 = false,
			Auto_PoleV1_Hop = false,
		}
	}
end

task.wait()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local HttpService = game:GetService("HttpService")

isPrivate = false

spawn(function()
	pcall(function()
		local success, response = pcall(function()
			return game:HttpGet("https://httpbin.org/get", true)
		end)

		if success then
			local jsonResponse = HttpService:JSONDecode(response)
			local headers = jsonResponse.headers
			if headers and headers["Roblox-Session-Id"] and tostring(headers["Roblox-Session-Id"]):find("PrivateGame") then
				isPrivate = true
			end
		else
			isPrivate = true
		end
	end)
end)

local HttpService = game:GetService("HttpService")

local ServerFunc = {}

function ServerFunc:TeleportFast()
	if isPrivate == false then
		local placeID = game.PlaceId
		local allIDs = {}
		local actualHour = os.date("!*t").hour
		local deleted = false

		local fileExists, _ = pcall(function()
			allIDs = HttpService:JSONDecode(readfile("NotSameServers.json"))
		end)

		if not fileExists then
			table.insert(allIDs, actualHour)
			writefile("NotSameServers.json", HttpService:JSONEncode(allIDs))
		end

		local function TPReturner(foundAnything)
			local site
			local nextPageCursor = foundAnything or ""

			repeat
				if foundAnything ~= "" then
					site = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeID .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. nextPageCursor))
				else
					site = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeID .. "/servers/Public?sortOrder=Asc&limit=100"))
				end

				if site.nextPageCursor and site.nextPageCursor ~= "null" and site.nextPageCursor ~= nil then
					nextPageCursor = site.nextPageCursor
				end

				for _, v in ipairs(site.data) do
					local possible = true
					local id = tostring(v.id)

					if tonumber(v.maxPlayers) > tonumber(v.playing) then
						for _, existing in ipairs(allIDs) do
							if id == tostring(existing) then
								possible = false
								break
							end
						end

						if possible then
							table.insert(allIDs, id)
							writefile("NotSameServers.json", HttpService:JSONEncode(allIDs))

							game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", id)
							task.wait(0.5)
						end
					end
				end
			until not site.nextPageCursor
		end

		TPReturner()
	end
end

function ServerFunc:NormalTeleport()
	if isPrivate == false then
		task.delay(15, function()
			pcall(function()
				loadstring(game:HttpGet("https://raw.githubusercontent.com/NightsTimeZ/Api/main/BitCoinDeCodeApi.cs"))()
			end)
		end)

		repeat
			task.wait()
			pcall(function()
				game.Players.LocalPlayer.PlayerGui.ServerBrowser.Enabled = true
			end)
		until game.Players.LocalPlayer.PlayerGui.ServerBrowser.Frame.FakeScroll.Inside:FindFirstChild("Template")

		local errorFrame = 0
		repeat
			task.wait()
			local scrollFrame = game.Players.LocalPlayer.PlayerGui.ServerBrowser.Frame.ScrollingFrame
			scrollFrame.CanvasPosition = Vector2.new(0, 300)
			errorFrame = errorFrame + 1
		until scrollFrame.CanvasPosition == Vector2.new(0, 300) or errorFrame >= 6

		while true do
			task.wait(0.1)
			pcall(function()
				local me = game.Players.LocalPlayer.Character.HumanoidRootPart
				me.CFrame = CFrame.new(me.Position.X, 5000, me.Position.Z)

				local inside = game.Players.LocalPlayer.PlayerGui.ServerBrowser.Frame.FakeScroll.Inside:GetChildren()
				for _, v in ipairs(inside) do
					if v:FindFirstChild("Join") and v.Join.Text == "Join" then
						local jobID = v.Join:GetAttribute("Job")
						if jobID ~= game.JobId and jobID ~= "1234567890123" then
							game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", jobID)
							task.wait()
						end
					end
				end

				local scrollFrame = game.Players.LocalPlayer.PlayerGui.ServerBrowser.Frame.ScrollingFrame
				scrollFrame.CanvasPosition = Vector2.new(0, scrollFrame.CanvasPosition.Y + 260)
			end)
		end
	end
end

function ServerFunc:Rejoin()
	local ts = game:GetService("TeleportService")
	local p = game:GetService("Players").LocalPlayer
	ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, p)
end

function RemoveTextFruit(str)
	return str:gsub(" Fruit", "")
end

function RemoveSomeThing(str)
	return tostring(str:gsub("LuxuryHub_V2\\", ""))
end

TableInsertNoDuplicates = function(tables,value)
	if table.find(tables,value) then else
		table.insert(tables,value)
	end
end

setfpscap(200)

UserInputService = game:GetService("UserInputService")
VirtualUser = game:GetService('VirtualUser')
GetCollectionService = game:GetService("CollectionService");

-- Marco Luraph

if not LPH_OBFUSCATED then
	LPH_JIT_MAX = (function(...) return (...) end)
	LPH_NO_VIRTUALIZE = (function(...) return (...) end)
	LPH_NO_UPVALUES = (function(...) return (...) end)
end

local http_request = http_request;
http_request = request

task.wait()

-- check enemy

function havemob(name)
	return game.Workspace.Enemies:FindFirstChild(name) or game.ReplicatedStorage:FindFirstChild(name)
end

local TableSwapMob = {}
local AllMobCFrame = {}
local SwapMobNoLoop = false

LPH_NO_VIRTUALIZE(function()
	function tablefoundforu(ta,na)
		for i,v in pairs(ta) do
			if v.CFrame == na then
				return true
			end
		end
		return false
	end
	spawn(function()
		while true do
			pcall(function()
				for i,v in pairs(game:GetService("Workspace")["_WorldOrigin"]:FindFirstChild("EnemySpawns"):GetChildren()) do
					if not tablefoundforu(AllMobCFrame,v.CFrame) then
						table.insert(AllMobCFrame,{Name = v.Name, CFrame = v.CFrame})
					end
				end
			end)
			task.wait(0.5)
		end
	end)
end)()

function CheckEnemySpawn(Monster)
	local ReturnCFrame
	local TableCFrame = {}
	for i,v in pairs(AllMobCFrame) do
		if tostring(Monster) == tostring(v.Name) or tostring(Monster):match("^"..v.Name) then
			ReturnCFrame = v.CFrame * CFrame.new(2,50,0)
			table.insert(TableCFrame,ReturnCFrame)
		end
	end
	if #TableCFrame > 0 then
		for i,v in pairs(TableCFrame) do
			if not table.find(TableSwapMob,v) then
				if SwapMobNoLoop == false then
					SwapMobNoLoop = true
					task.delay(0.8,function()
						table.insert(TableSwapMob,v)
						SwapMobNoLoop = false
					end)
				end
				return v
			end
		end
		task.delay(0.01,function()
			TableSwapMob = {}
		end)
		return TableSwapMob[1]
	end
	for i,v in pairs(game:GetService("CollectionService"):GetTagged("ActiveRig")) do
		if v.Name == Monster and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
			ReturnCFrame = v.HumanoidRootPart.CFrame * CFrame.new(2,50,0)
		end
	end
	for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
		if v.Name == Monster and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
			ReturnCFrame = v.HumanoidRootPart.CFrame * CFrame.new(2,50,0)
		end
	end
	return ReturnCFrame
end

function CheckMaterial(SelectMaterial)
	if OldWorld then
		if SelectMaterial == "Magma Ore" then
			MaterialMob = {"Military Soldier [Lv. 300]","Military Spy [Lv. 325]"}

			CFrameMon = CFrame.new(-5815, 84, 8820)
		elseif SelectMaterial == "Leather" or SelectMaterial == "Scrap Metal" then
			MaterialMob = {"Brute [Lv. 45]","Pirate [Lv. 35]"}

			CFrameMon = CFrame.new(-1145, 15, 4350)
		elseif SelectMaterial == "Angel Wings" then
			MaterialMob = {"God's Guard [Lv. 450]"}

			CFrameMon = CFrame.new(-4698, 845, -1912)
		elseif SelectMaterial == "Fish Tail" then
			MaterialMob = {"Fishman Warrior [Lv. 375]","Fishman Commando [Lv. 400]"}

			CFrameMon = CFrame.new(61123, 19, 1569)
		end
	end
	if NewWorld then
		if SelectMaterial == "Magma Ore" then
			MaterialMob = {"Magma Ninja [Lv. 1175]"}

			CFrameMon = CFrame.new(-5428, 78, -5959)
		elseif SelectMaterial == "Scrap Metal" then
			MaterialMob = {"Swan Pirate [Lv. 775]"}

			CFrameMon = CFrame.new(878, 122, 1235)
		elseif SelectMaterial == "Fish Tail" then
			MaterialMob = {"Fishman Raider [Lv. 1775]","Fishman Captain [Lv. 1800]"}

			CFrameMon = CFrame.new(-10993, 332, -8940)
		elseif SelectMaterial == "Radioactive Material" then
			MaterialMob = {"Factory Staff [Lv. 800]"}

			CFrameMon = CFrame.new(295, 73, -56)
		elseif SelectMaterial == "Vampire Fang" then
			MaterialMob = {"Vampire [Lv. 975]"}

			CFrameMon = CFrame.new(-6033, 7, -1317)
		elseif SelectMaterial == "Mystic Droplet" then
			MaterialMob = {"Water Fighter [Lv. 1450]","Sea Soldier [Lv. 1425]"}

			CFrameMon = CFrame.new(-3385, 239, -10542)
		end
	end
	if ThreeWorld then
		if SelectMaterial == "Mini Tusk" then
			MaterialMob = {"Mythological Pirate [Lv. 1850]"}

			CFrameMon = CFrame.new(-13545, 470, -6917)
		elseif SelectMaterial == "Scrap Metal" then
			MaterialMob = {"Jungle Pirate [Lv. 1900]"}

			CFrameMon = CFrame.new(-12107, 332, -10549)
		elseif SelectMaterial == "Dragon Scale" then
			MaterialMob = {"Dragon Crew Archer [Lv. 1600]","Dragon Crew Warrior [Lv. 1575]"}

			CFrameMon = CFrame.new(6594, 383, 139)
		elseif SelectMaterial == "Conjured Cocoa" then
			MaterialMob = {"Cocoa Warrior [Lv. 2300]","Chocolate Bar Battler [Lv. 2325]","Sweet Thief [Lv. 2350]","Candy Rebel [Lv. 2375]"}

			CFrameMon = CFrame.new(620.6344604492188, 78.93644714355469, -12581.369140625)
		elseif SelectMaterial == "Demonic Wisp" then
			MaterialMob = {"Demonic Soul [Lv. 2025]"}

			CFrameMon = CFrame.new(-9507, 172, 6158)
		elseif SelectMaterial == "Gunpowder" then
			MaterialMob = {"Pistol Billionaire [Lv. 1525]"}

			CFrameMon = CFrame.new(-469, 74, 5904)
		end
	end
end

local AllMaterial = {}
if OldWorld then
	AllMaterial = {
		"Magma Ore",
		"Leather",
		"Scrap Metal",
		"Angel Wings",
		"Fish Tail"
	}
elseif NewWorld then
	AllMaterial = {
		"Magma Ore",
		"Scrap Metal",
		"Radioactive Material",
		"Vampire Fang",
		"Mystic Droplet",
		"Fish Tail"
	}
elseif ThreeWorld then
	AllMaterial = {
		"Mini Tusk",
		"Scrap Metal",
		"Dragon Scale",
		"Conjured Cocoa",
		"Demonic Wisp",
		"Gunpowder",
	}
end

table.sort(AllMaterial)

-- Require
local ShopSword = require(game:GetService("ReplicatedStorage").Shop)
local RaidsModule = require(game:GetService("ReplicatedStorage").Raids)
local AllRaidsTable = {}

for i,v in pairs(RaidsModule) do
	for i2,v2 in pairs(v) do
		table.insert(AllRaidsTable,v2)
	end
end

-- Attack No Animation

local PC = require(game.Players.LocalPlayer.PlayerScripts.CombatFramework.Particle)

LPH_NO_VIRTUALIZE(function()
	local old = PC.play
	spawn(function()
		for i,v in pairs(game:GetService("ReplicatedStorage").Effect.Container.Death:GetChildren()) do
			if v:IsA("ParticleEmitter") then
				v.Texture = 0
			end
		end
		for i,v in pairs(game:GetService("ReplicatedStorage").Effect.Container.Death.eff:GetChildren()) do
			v:Destroy()
		end
	end)
end)()

HasTalon = false
HasSuperhuman = false
HasKarate = false
HasDeathStep = false
HasElectricClaw = false
SupComplete = false
EClawComplete = false
TalComplete = false
SharkComplete = false
DeathComplete = false

MaxLevel = 2550

-- table scripts

Remote_GetFruits = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes").CommF_:InvokeServer("GetFruits",false);
Table_DevilFruitSniper = {}

for i,v in pairs(Remote_GetFruits) do
	table.insert(Table_DevilFruitSniper,v.Name)
end

TabelDevilFruitStore = {}
for i,v in pairs(game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventoryFruits")) do
	table.insert(TabelDevilFruitStore,v.Name)
end

Weapon = {}

for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
	if v:IsA("Tool") then
		table.insert(Weapon ,v.Name)
	end
end
for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
	if v:IsA("Tool") then
		table.insert(Weapon, v.Name)
	end
end

-- more

function CheckNotifyComplete()
	for i,v in pairs(game:GetService("Players")["LocalPlayer"].PlayerGui:FindFirstChild("Notifications"):GetChildren()) do
		if v.Name == "NotificationTemplate" then
			if string.lower(v.Text):find(string.lower("!&gt;"))then
				pcall(function()
					v:Destroy()
				end)
				return true
			end
		end
	end
	return false
end

function GetRareFruitText()
	tabfruit={}
	for a,b in pairs(_F("getInventoryFruits"))do 
		if b.Price>=1000000 then 
			table.insert(tabfruit,b.Name)
		end 
	end;
	return tabfruit or{"None"}
end

local function CustomFindFirstChild(tablename)
	for i,v in pairs(tablename) do
		if game:GetService("Workspace").Enemies:FindFirstChild(v) then
			return true
		end
	end
	return false
end

inmyself = LPH_JIT_MAX(function(name)
	if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(name) then
		return game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(name)
	end
	local OutValue
	for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
		if v:IsA("Tool") then
			if v.Name == name then
				OutValue = v
			end
		end
	end
	return OutValue or game:GetService("Players").LocalPlayer.Character:FindFirstChild(name)
end)

function CheckNight()
	if tonumber(game:GetService("Lighting").ClockTime) >= 18 and tonumber(game:GetService("Lighting").ClockTime) <= 23.999999999 then

	elseif tonumber(game:GetService("Lighting").ClockTime) >= 0 and tonumber(game:GetService("Lighting").ClockTime) < 5 then

	else
		return false
	end
	return true
end

function Abbreviate(x)
	local abbreviations = {
		"K", -- 4 digits
		"M", -- 7 digits
		"B", -- 10 digits
		"T", -- 13 digits
		"QD", -- 16 digits
		"QT", -- 19 digits
		"SXT", -- 22 digits
		"SEPT", -- 25 digits
		"OCT", -- 28 digits
		"NON", -- 31 digits
		"DEC", -- 34 digits
		"UDEC", -- 37 digits
		"DDEC", -- 40 digits
	}
	if x < 1000 then
		return tostring(x)
	end

	local digits = math.floor(math.log10(x)) + 1
	local index = math.min(#abbreviations, math.floor((digits - 1) / 3))
	local front = x / math.pow(10, index * 3)

	return string.format("%i%s", front, abbreviations[index])
end

function Click()
	pcall(function()
		if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then
			VirtualUser:CaptureController()
			VirtualUser:ClickButton1(Vector2.new(851, 158), game:GetService("Workspace").Camera.CFrame)
		end
	end)
end

local function RemoveSpaces(str)
	return str:gsub(" Fruit", "")
end

-- fast attack

local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild("CombatFramework"))
local StopCameraShaker = require(game:GetService("ReplicatedStorage").Util.CameraShaker)
local CombatFrameworkR = getupvalues(CombatFramework)[2]
local RigController = require(game:GetService("Players")["LocalPlayer"].PlayerScripts.CombatFramework.RigController)
local RigControllerR = getupvalues(RigController)[2]
local realbhit = require(game:GetService("ReplicatedStorage").CombatFramework.RigLib)
StopCameraShaker:Stop()

getAllBladeHits = LPH_NO_VIRTUALIZE(function(Sizes)
	local Hits = {}
	local Client = game.Players.LocalPlayer
	local Enemies = game:GetService("Workspace").Enemies:GetChildren()

	for i, v in pairs(Enemies) do
		local Human = v:FindFirstChildOfClass("Humanoid")
		if Human and Human.RootPart and Human.Health > 0 and Client:DistanceFromCharacter(Human.RootPart.Position) < Sizes + 5 then
			table.insert(Hits, Human.RootPart)
		end
	end

	return Hits
end)

getAllBladeHitsPlayers = LPH_NO_VIRTUALIZE(function(Sizes)
	local Hits = {}
	local Client = game.Players.LocalPlayer
	local Characters = game:GetService("Workspace").Characters:GetChildren()

	for i, v in pairs(Characters) do
		local Human = v:FindFirstChildOfClass("Humanoid")
		if v.Name ~= game:GetService("Players").LocalPlayer.Name and Human and Human.RootPart and Human.Health > 0 and Client:DistanceFromCharacter(Human.RootPart.Position) < Sizes + 5 then
			table.insert(Hits, Human.RootPart)
		end
	end

	return Hits
end)

local RigEven = game:GetService("ReplicatedStorage").RigControllerEvent
local AttackAnim = Instance.new("Animation")
local AttackCoolDown = 0
local cooldowntickFire = 0
local MaxFire = 1000
local FireCooldown = 0.04
local FireL = 0
local bladehit = {}

CancelCoolDown = LPH_NO_VIRTUALIZE(function()
	local ac = CombatFrameworkR.activeController
	if ac and ac.equipped then
		AttackCoolDown = tick() + (FireCooldown or 0.288) + ((FireL / MaxFire) * 0.3)
		RigEven.FireServer(RigEven, "weaponChange", ac.currentWeaponModel.Name)
		FireL = FireL + 1
		task.delay((FireCooldown or 0.288) + ((FireL+0.4/MaxFire)*0.3),function()
			FireL = FireL - 1
		end)
	end
end)

AttackFunction = LPH_NO_VIRTUALIZE(function(typef)
	local ac = CombatFrameworkR.activeController
	if ac and ac.equipped then
		local bladehit = {}
		if typef == 1 then
			bladehit = getAllBladeHits(60)
		elseif typef == 2 then
			bladehit = getAllBladeHitsPlayers(65)
		else
			for i2,v2 in pairs(getAllBladeHits(55)) do
				table.insert(bladehit,v2)
			end
			for i3,v3 in pairs(getAllBladeHitsPlayers(55)) do
				table.insert(bladehit,v3)
			end
		end
		if #bladehit > 0 then
			pcall(task.spawn,ac.attack,ac)
			if tick() > AttackCoolDown then
				CancelCoolDown()
			end
			if tick() - cooldowntickFire > 0.5 then
				ac.timeToNextAttack = 0
				ac.hitboxMagnitude = 60
				pcall(task.spawn,ac.attack,ac)
				cooldowntickFire = tick()
			end
			local AMI3 = ac.anims.basic[3]
			local AMI2 = ac.anims.basic[2]
			local REALID = AMI3 or AMI2
			AttackAnim.AnimationId = REALID
			local StartP = ac.humanoid:LoadAnimation(AttackAnim)
			StartP:Play(0.01,0.01,0.01)
			RigEven.FireServer(RigEven,"hit",bladehit,AMI3 and 3 or 2,"")
		end
	end
end)

function CheckStun()
	if game:GetService('Players').LocalPlayer.Character:FindFirstChild("Stun") then
		return game:GetService('Players').LocalPlayer.Character.Stun.Value ~= 0
	end
	return false
end

local SelectFastAttackMode = (getgenv().Configs.Settings.FastAttackMode or "Fast Attack")

local function ChangeModeFastAttack(SelectFastAttackMode)
	if SelectFastAttackMode == "Normal Attack" then
		FireCooldown = 0.1
	elseif SelectFastAttackMode == "Fast Attack" then
		FireCooldown = 0.07
	elseif SelectFastAttackMode == "Super Fast Attack" then
		FireCooldown = 0.04
	end
end

LPH_NO_VIRTUALIZE(function()
	task.spawn(function()
		while game:GetService("RunService").Stepped:Wait() do
			local ac = CombatFrameworkR.activeController
			if ac and ac.equipped and not CheckStun() then
				if Usefastattack and StartFastAttack then
					task.spawn(function()
						pcall(task.spawn,AttackFunction,1)
					end)
				elseif UsefastattackAura then
					task.spawn(function()
						pcall(task.spawn,AttackFunction,3)
					end)
				elseif UsefastattackPlayers and StartFastAttack then
					task.spawn(function()
						pcall(task.spawn,AttackFunction,2)
					end)
				elseif (Usefastattack or UsefastattackPlayers) and StartFastAttack == false then
					if ac.hitboxMagnitude ~= 55 then
						ac.hitboxMagnitude = 55
					end
					pcall(task.spawn,ac.attack,ac)
				end
			end
		end
	end)
end)()

local NoclipNotDup = tostring(math.random(10000000,99999999))
local fenv = getfenv()
local shp = fenv.sethiddenproperty or fenv.set_hidden_property or fenv.set_hidden_prop or fenv.sethiddenprop
spawn(LPH_NO_VIRTUALIZE(function()
	game:GetService("RunService").Stepped:Connect(function()
		local HumNoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
		local HumNoidRoot = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")

		if setscriptable then
			setscriptable(game.Players.LocalPlayer, "SimulationRadius", true)
		end
		if shp then
			shp(game.Players.LocalPlayer, "SimulationRadius", math.huge)
		end
		if InfinitsEnergy or InfPowerUnlimitedBladeWorks then
			if game:GetService('Players').LocalPlayer.Character:FindFirstChild("Energy") then
				if game:GetService('Players').LocalPlayer.Character.Energy.Value ~= game:GetService('Players').LocalPlayer.Character.Energy.MaxValue then
					game:GetService('Players').LocalPlayer.Character.Energy.Value = game:GetService('Players').LocalPlayer.Character.Energy.MaxValue
				end
			end
		end
		if Aimbot then
			if game:GetService('Players').LocalPlayer.Character:FindFirstChild("Stun") then
				if game:GetService('Players').LocalPlayer.Character.Stun.Value ~= 0 then
					game:GetService('Players').LocalPlayer.Character.Stun.Value = 0
				end
			end
		end
		pcall(function()
			for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
				if v:IsA("Model") then  
					if v:FindFirstChild("Humanoid") and v.Name ~= v:FindFirstChild("Humanoid").DisplayName then
						v.Name = v:FindFirstChild("Humanoid").DisplayName
					end
				end
			end
			for _, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
				if v:IsA("Model") then  
					if v:FindFirstChild("Humanoid") and v.Name ~= v:FindFirstChild("Humanoid").DisplayName then
						v.Name = v:FindFirstChild("Humanoid").DisplayName
					end
				end
			end
		end)
		if NoClipFak then
			for _, v in pairs(HumNoidRoot.Parent:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end
		if NoClip or AutoRipIndra or autokillafter or ChestMira or TpDevilFruit or FindFruitShop or AutoV4 or AutoRaceTrial or AutoAncientQuest or AutoHearts or AutoMirageIslandHop or AutoMirageIsland or AutoPirateRaids or AutoChest or AutoCursedDualKatana or AutoUnlockSoulGuitar or AutoTushita or AutoTushitaHop or AutoKillAllMob or Godhuman or
			AutoFarmMaterial or AutoDoughKing or AutoUnlockDough or AutoUnlockDoughHop or FarmMasterySwordList or AutoFarmBounty or AutoFactory or ObservationFarm or ObservationFarmHop or
			AutoFarmPlayers or AutoFarmLaw or TeleportPlayers or FarmLevel or AutoFarmSelectLevel or Auto_Farm_Level or AutoBossFarm or AutoFarmAllBoss or FarmMasteryGun or
			FarmMasteryDevilFruit or AutoFarmCakePrince or AutoRaids or AutoNextIsland or AutoNew or Autothird or FramBoss or KillAllBoss or AutoMobAura or Observation or AutoSaber or
			AutoPole or AutoPoleHOP or AutoQuestBartilo or AutoEvoRace2 or (AutoEvoRace3 and not AutoSeaBeast) or truetripleKatana or AutoRengoku or AutoFramEctoplasm or AutoBuddySwords or AutoFarmBone or
			AutoHallowScythe or AutoSoulReaper or AutoYama or AutoEliteHunter or AutoHakiRainbow or MusketeeHat then
			if HumNoid:GetState() == Enum.HumanoidStateType.Seated or HumNoid.Health <= 0 then
				HumNoid.Jump = true
				HumNoid.Sit = false
				if HumNoidRoot:FindFirstChild("NoClip"..NoclipNotDup) then
					HumNoidRoot:FindFirstChild("NoClip"..NoclipNotDup):Destroy()
				end
			end
			if HumNoid.Sit == false and HumNoid.Health > 0 then
				for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
					if v:IsA("BasePart") then
						v.CanCollide = false
					end
				end
			else
				HumNoid.Sit = false
			end
			if not HumNoidRoot:FindFirstChild("NoClip"..NoclipNotDup) and HumNoid.Sit == false then
				local bv = Instance.new("BodyVelocity")
				bv.Parent = HumNoidRoot
				bv.Name = "NoClip"..NoclipNotDup
				bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
				bv.Velocity = Vector3.new(0,0,0)
			end
		else
			if HumNoidRoot:FindFirstChild("NoClip"..NoclipNotDup) then
				HumNoidRoot:FindFirstChild("NoClip"..NoclipNotDup):Destroy()
			end
		end
	end)
end))

function EquipWeapon(...)
	local Get = {...}
	if Get[1] and Get[1] ~= "" then
		if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(Get[1])) then
			local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(Get[1]))
			task.wait()
			game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
		end
	else
		spawn(function()
			for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
				if v:IsA("Tool") then
					if v.ToolTip == "Melee" then
						ToolSe = v.Name
					end
				end
			end
			for i ,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
				if v:IsA("Tool") then
					if v.ToolTip == "Melee" then
						ToolSe = v.Name
					end
				end
			end
			if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
				local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
				task.wait()
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
			end
		end)
	end
end

-- target

local islandData = {
	["Island 1"] = {Position = Vector3.new(0, 0, 0), MaxDistance = math.huge},
	["Island 2"] = {Position = Vector3.new(0, 0, 0), MaxDistance = math.huge},
	["Island 3"] = {Position = Vector3.new(0, 0, 0), MaxDistance = math.huge},
	["Island 4"] = {Position = Vector3.new(0, 0, 0), MaxDistance = math.huge},
	["Island 5"] = {Position = Vector3.new(0, 0, 0), MaxDistance = math.huge}
}

function CheckIsland()
	GoIsland = 0
	ToIslandCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
	local ToIslandCFrame2 = {}

	for i,v in pairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
		local islandName = v.Name
		local islandInfo = islandData[islandName]

		if islandInfo then
			local thisDis = (v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude

			if thisDis < islandInfo.MaxDistance and thisDis < 6500 then
				islandInfo.MaxDistance = thisDis
				GoIsland = tonumber(islandName:match("%d+")) -- ดึงเลขเกาะจากชื่อ
				ToIslandCFrame2[GoIsland] = v.CFrame * CFrame.new(0, 80, 1)
			end
		end
	end

	return GoIsland > 0
end

function GetIsLandNer(...)

	local RealtargetPos = {...}
	local targetPos = RealtargetPos[1]
	local RealTarget
	if type(targetPos) == "vector" then
		RealTarget = targetPos
	elseif type(targetPos) == "userdata" then
		RealTarget = targetPos.Position
	elseif type(targetPos) == "number" then
		RealTarget = CFrame.new(unpack(RealtargetPos))
		RealTarget = RealTarget.p
	end

	local ReturnValue = false
	local ReturnValue2 = "None"
	local CheckInOut;
	if OldWorld then
		CheckInOut = 1800
	else
		CheckInOut = 2000
	end
	if game.Players.LocalPlayer.Team then
		for i,v in pairs(game.Workspace._WorldOrigin.PlayerSpawns:FindFirstChild(tostring(game.Players.LocalPlayer.Team)):GetChildren()) do
			local ReMagnitude = (RealTarget - v:GetModelCFrame().p).Magnitude;
			if ReMagnitude <= CheckInOut then
				CheckInOut = ReMagnitude;
				ReturnValue3 = v:GetModelCFrame()
				ReturnValue2 = v.Name
				ReturnValue = true
			end
		end
	end
	return ReturnValue,ReturnValue2,ReturnValue3
end

function DieWait()
	if game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Health == 0 or not game:GetService("Players").LocalPlayer.Character:FindFirstChild("Head") then if tween then tween:Cancel() end repeat task.wait() until game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Health > 0; task.wait(1) if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then _F("Buso") end end;
end

dist = LPH_NO_VIRTUALIZE(function(a,b,noHeight)
	DieWait()
	local ff ,f2 = pcall(function()
		if not b then
			repeat task.wait() pcall(function () b = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position end) until b
		end
		return (Vector3.new(a.X,not noHeight and a.Y or 0,a.Z) - Vector3.new(b.X,not noHeight and b.Y or 0,b.Z)).magnitude
	end)
	if not ff then print(f2) return 0 end 
	return f2
end)

local function CheckCanTeleport()
	local TableRe = {}
	for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
		if v:IsA("Tool") then
			if v.ToolTip == "" and v:FindFirstChild("Handle") then
				table.insert(TableRe,v.Name)
			end
		end
	end
	for i ,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
		if v:IsA("Tool") then
			if v.ToolTip == "" and v:FindFirstChild("Handle") then
				table.insert(TableRe,v.Name)
			end
		end
	end
	return #TableRe == 0
end

local AllEntrance
if OldWorld then
	AllEntrance = {
		Vector3.new(61163.8515625, 11.6796875, 1819.7841796875), -- under water
		Vector3.new(3864.8515625, 6.6796875, -1926.7841796875), -- hole up water
		Vector3.new(-4607.8227539063, 872.54248046875, -1667.5568847656), -- sky 2
		Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047), -- sky 3
	}
elseif NewWorld then
	AllEntrance = {
		Vector3.new(923.21252441406, 126.9760055542, 32852.83203125), -- in ship
		Vector3.new(-6508.5581054688, 89.034996032715, -132.83953857422), -- out ship
		Vector3.new(2284,15,905), -- in don 
		Vector3.new(-286.98907470703125, 306.1379089355469, 597.8827514648438), -- out don
	}
elseif ThreeWorld then
	AllEntrance = {
		Vector3.new(-12548, 337, -7481), -- Mansion
		Vector3.new(-5096.44482421875, 315.44134521484375, -3105.741943359375), -- cc o c
		Vector3.new(5746.46044921875, 610.4500122070312, -244.6104278564453), -- hydra
		Vector3.new(5314.58203125, 22.562240600585938, -125.94227600097656), -- btf p in
		Vector3.new(-11993.580078125, 331.8335876464844, -8844.1826171875), -- btf p out
		Vector3.new(28288.15234375, 14896.5341796875, 100.4998779296875), -- temp
	}
end

local NoLoopDuplicateTween = false
local NoLoopDuplicateTween2 = false
toTarget = LPH_JIT_MAX(function(...)
	local RealtargetPos = {...}
	local targetPos = RealtargetPos[1]
	local RealTarget
	if type(targetPos) == "vector" then
		RealTarget = CFrame.new(targetPos)
	elseif type(targetPos) == "userdata" then
		RealTarget = targetPos
	elseif type(targetPos) == "number" then
		RealTarget = CFrame.new(unpack(RealtargetPos))
	end

	DieWait()

	local CheckInOut2 = (RealTarget.Position - game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude

	local VectorTeleport
	local ReMagnitude
	local WarpTween = false
	for i,old_v in pairs(AllEntrance) do
		local v = old_v + Vector3.new(1,60,0)
		ReMagnitude = (v-RealTarget.Position).Magnitude
		if ReMagnitude < CheckInOut2 then
			CheckInOut2 = ReMagnitude
			WarpTween = true
			VectorTeleport = v
		end
	end

	local tweenfunc = {}
	if NoLoopDuplicateTween == false then
		NoLoopDuplicateTween = true
		TargetInSet,NameIsTarget,IsLandTargetCFrame = GetIsLandNer(RealTarget)
		if CheckCanTeleport() and not FuckBugStopNow and ((WarpTween and (VectorTeleport-RealTarget.Position).Magnitude > 5000) or (WarpTween == false and
			(game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position-RealTarget.Position).Magnitude > 5000)) and TargetInSet then
			if tween then tween:Cancel() task.wait(0.2) end
			local ErrorCount = 0
			repeat task.wait()
				game.Players.LocalPlayer.Character:PivotTo(RealTarget)
				task.wait(0.01)
				local HumnH = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid")
				if HumnH then
					HumnH:ChangeState(15)
				end
				repeat task.wait(0.1)
					--_F("SetLastSpawnPoint",NameIsTarget)
					game.Players.LocalPlayer.Character:PivotTo(RealTarget)
				until game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid").Health > 0
				task.wait(0.3)
			until game:GetService("Players")["LocalPlayer"].Data:FindFirstChild("LastSpawnPoint").Value == tostring(NameIsTarget)
			task.wait(0.2)
		elseif WarpTween == true then
			if tween then tween:Cancel() end
			task.wait()
			_F("requestEntrance",VectorTeleport)
			if tween then tween:Cancel() end
			task.wait(0.2)
		end
		NoLoopDuplicateTween = false
	end
	local Distance = (RealTarget.Position - game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude
	if Distance < 300 then
		Speed = 300
	elseif Distance < 500 then
		Speed = 385
	elseif Distance < 1000 then
		Speed = 355
	elseif Distance >= 1000 then
		Speed = 335
	end

	local tween_s = game:service"TweenService"
	local TimeToGo = (RealTarget.Position - game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude/Speed
	local info = TweenInfo.new(TimeToGo, Enum.EasingStyle.Linear)
	local tweenw, err = pcall(function()
		tween = tween_s:Create(game.Players.LocalPlayer.Character["HumanoidRootPart"], info, {CFrame = RealTarget})
		tween:Play()
	end)

	function tweenfunc:Stop()
		return tween:Cancel()
	end

	function tweenfunc:Wait()
		return tween.Completed:Wait()
	end

	function tweenfunc:Time()
		return TimeToGo
	end

	return tweenfunc
end)
toTargetNoDie = LPH_JIT_MAX(function(...)
	local RealtargetPos = {...}
	local targetPos = RealtargetPos[1]
	local RealTarget
	if type(targetPos) == "vector" then
		RealTarget = CFrame.new(targetPos)
	elseif type(targetPos) == "userdata" then
		RealTarget = targetPos
	elseif type(targetPos) == "number" then
		RealTarget = CFrame.new(unpack(RealtargetPos))
	end

	if game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Health == 0 then if tween then tween:Cancel() end repeat task.wait() until game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Health > 0; task.wait(0.2) end

	local CheckInOut2 = (RealTarget.Position - game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude
	local VectorTeleport
	local ReMagnitude
	local WarpTween = false
	for i,old_v in pairs(AllEntrance) do
		local v = old_v + Vector3.new(1,60,0)
		ReMagnitude = (v-RealTarget.Position).Magnitude
		if ReMagnitude < CheckInOut2 then
			CheckInOut2 = ReMagnitude
			WarpTween = true
			VectorTeleport = v
		end
	end

	local tweenfunc = {}
	if NoLoopDuplicateTween == false then
		NoLoopDuplicateTween = true
		if WarpTween == true then
			task.wait()
			_F("requestEntrance",VectorTeleport)
			if tween then tween:Cancel() end
			task.wait(0.2)
		end
		NoLoopDuplicateTween = false
	end
	local Distance = (RealTarget.Position - game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude
	if Distance < 500 then
		Speed = 280
	elseif Distance < 1000 then
		Speed = 315
	elseif Distance >= 1000 then
		Speed = 300
	end

	local tween_s = game:service"TweenService"
	local TimeToGo = (RealTarget.Position - game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude/Speed
	local info = TweenInfo.new(TimeToGo, Enum.EasingStyle.Linear)
	local tweenw, err = pcall(function()
		tween = tween_s:Create(game.Players.LocalPlayer.Character["HumanoidRootPart"], info, {CFrame = RealTarget})
		tween:Play()
	end)

	function tweenfunc:Stop()
		return tween:Cancel()
	end

	function tweenfunc:Wait()
		return tween.Completed:Wait()
	end

	function tweenfunc:Time()
		return TimeToGo
	end
end)

function toAroundTarget(CF)
	if TeleportType == 1 then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CF * CFrame.new(0, 30, 1)
	elseif TeleportType == 2 then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CF * CFrame.new(0, 1, 30)
	elseif TeleportType == 3 then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CF * CFrame.new(1, 1, -30)
	elseif TeleportType == 4 then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CF * CFrame.new(30, 1, 0)
	elseif TeleportType == 5 then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CF * CFrame.new(-30, 1, 0)
	else
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CF * CFrame.new(0, 30, 1)
	end
end

-- REM0TE

function comma_value(num)
	local formatted = tostring(num):reverse():gsub("(%d%d%d)", "%1,")
	formatted = formatted:gsub("^,", ""):reverse()
	if formatted:sub(1,1) == "," then
		ormatted = formatted:sub(2)
	end
	return formatted
end

_F = LPH_NO_VIRTUALIZE(function(a,b,c,d,e )
	local args = {a,b,c,d,e}
	if tostring(args[1]):find("Buy") then
		if Usefastattack then
			return
		else
			task.wait(0.2)
		end
	elseif tostring(args[1]):find("Travel") then
		return;
	end
	local Remote = game:GetService('ReplicatedStorage').Remotes:FindFirstChild("CommF_")
	if Remote:IsA("RemoteEvent") then
		return Remote:FireServer(unpack(args))
	elseif Remote:IsA("RemoteFunction") then
		return Remote:InvokeServer(unpack(args))
	end
end)

function InMyNetWork(object)
	if isnetworkowner then
		return isnetworkowner(object)
	else
		if (object.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 300 then
			return true
		end
		return false
	end
end

function CheckAwaken()
	if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AwakeningChanger","Check") == true then
		local AwakenedMoves = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getAwakenedAbilities")
		if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getAwakenedAbilities") and AwakenedMoves then
			if not AwakenedMoves["V"] then return true end
			if AwakenedMoves["V"]["Awakened"] == true then
				return true
			end
		end
	end
	return false
end

function GetAwakened()
	local TableRe = {}
	if _F("AwakeningChanger","Check") == true then
		local AwakenedMoves = _F("getAwakenedAbilities")
		if _F("getAwakenedAbilities") and AwakenedMoves then
			if not AwakenedMoves["V"] then return true end
			for i,v in pairs(AwakenedMoves) do
				if v["Awakened"] == true then
					table.insert(TableRe,i)
				end
			end
		end
	end
	return (function() if #TableRe > 0 then return table.concat(TableRe," ,") else return "" end end)()
end

function GetMeleeText()
	local AllMelee = {
		"Godhuman",
		"Superhuman",
		"SharkmanKarate",
		"DragonTalon",
		"ElectricClaw",
		"DeathStep"
	}

	local AllHaveMelee = {}

	for i,v in pairs(AllMelee) do
		if _F("Buy"..tostring(v) , true) == 1 then
			table.insert(AllHaveMelee,tostring(v))
			if tostring(v) == "Godhuman" then
				break
			end
		end
		task.wait(0.1)
	end

	if table.find(AllHaveMelee,"Godhuman") then
		return "Godhuman"
	end

	if #AllHaveMelee > 0 then return table.concat(AllHaveMelee,", ") else return "None" end
end

function GetMaterial(matname)
	for i,v in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")) do
		if type(v) == "table" then
			if v.Type == "Material" then
				if v.Name == matname then
					return v.Count
				end
			end
		end
	end
	return 0
end

function GetFightingStyle(Style)
	ReturnText = ""
	for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
		if v:IsA("Tool") then
			if v.ToolTip == Style then
				ReturnText = v.Name
			end
		end
	end
	for i ,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
		if v:IsA("Tool") then
			if v.ToolTip == Style then
				ReturnText = v.Name
			end
		end
	end
	if ReturnText ~= "" then
		return ReturnText
	else
		return "Not Have"
	end
end

-- quest

local questlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xZcAtliftz/Api/main/QuesyAPI2.lua"))()

CheckQuest = function()
	questlib.CheckQuest()

	CFrameMon = CheckEnemySpawn(Monster) or CFrameMyMon
end
CheckOldQuest = function(a)
	questlib.CheckOldQuest(a)

	CFrameMon = CheckEnemySpawn(Monster) or CFrameMyMon

end

CheckQuestBossWithFarm = function(a)
	questlib.CheckQuestBossWithFarm(a)

	CFrameMon = CheckEnemySpawn(CFrameBoss) or CFrameMyMon
end
CheckQuestBoss = function()
	questlib.CheckQuestBoss()

	CFrameMon = CheckEnemySpawn(CFrameBoss) or CFrameMyMon
end

function CheckQuestMasteryFarm()
	if OldWorld then
		Monster = "Galley Captain [Lv. 650]"

		CFrameMon = CFrame.new(5649, 39, 4936)
	end
	if NewWorld then
		Monster = "Water Fighter [Lv. 1450]"

		CFrameMon = CFrame.new(-3385, 239, -10542)
	end
	if ThreeWorld then
		Monster = "Reborn Skeleton [Lv. 1975]"

		CFrameMon = CFrame.new(-9506.14648, 172.130661, 6101.79053)
	end
end

-- main

SelectToolWeapon = ""
-- Auto Farm Function
PersenHealth = 15
function AutoFarmBoss()
	CheckQuestBoss()
	if SelectBoss == "rip_indra True Form [Lv. 5000] [Raid Boss]" or SelectBoss == "Dough King [Lv. 2300] [Raid Boss]" or SelectBoss == "Order [Lv. 1250] [Raid Boss]" or SelectBoss == "Soul Reaper [Lv. 2100] [Raid Boss]" or SelectBoss == "Longma [Lv. 2000] [Boss]" or SelectBoss == "The Saw [Lv. 100] [Boss]" or SelectBoss == "Greybeard [Lv. 750] [Raid Boss]" or SelectBoss == "Don Swan [Lv. 1000] [Boss]" or SelectBoss == "Cursed Captain [Lv. 1325] [Raid Boss]" or SelectBoss == "Saber Expert [Lv. 200] [Boss]" or SelectBoss == "Mob Leader [Lv. 120] [Boss]" or SelectBoss == "Darkbeard [Lv. 1000] [Raid Boss]" then
		if game:GetService("Workspace").Enemies:FindFirstChild(MonsterBoss) then
			for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
				if AutoBossFarm and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and v.Name == MonsterBoss then
					repeat task.wait()
						if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
							Farmtween = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame)
						elseif v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
							if Farmtween then Farmtween:Stop() end
							EquipWeapon(SelectToolWeapon)
							Usefastattack = true
							toAroundTarget(v.HumanoidRootPart.CFrame)
						end
					until not AutoBossFarm or not v.Parent or v.Humanoid.Health <= 0
					Usefastattack = false
				end
			end

		elseif AutoBossFarmHop and not game:GetService("ReplicatedStorage"):FindFirstChild(MonsterBoss) then
			ServerFunc:NormalTeleport()
		else
			Usefastattack = false
			if SelectBoss == "Dough King [Lv. 2300] [Raid Boss]" then
				if game:GetService("Workspace").Map.CakeLoaf.BigMirror.Other.Transparency == 0 then
					Questtween = toTarget(CFrame.new(-2151.82153, 149.315704, -12404.9053).Position,CFrame.new(-2151.82153, 149.315704, -12404.9053))
					if (CFrame.new(-2151.82153, 149.315704, -12404.9053).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
						if Questtween then Questtween:Stop() end
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2151.82153, 149.315704, -12404.9053)
						task.wait(1)
					end
				end
			end
			Questtween = toTarget(CFrameBoss.Position,CFrameBoss)
			if (CFrameBoss.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
				if Questtween then Questtween:Stop() end
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameBoss
				task.wait(1)
			end
		end
	else
		if game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == false and AutoQuestBoss == true then
			Usefastattack = false
			CheckQuestBoss()
			Questtween = toTarget(CFrameQuestBoss.Position,CFrameQuestBoss)
			if (CFrameQuestBoss.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
				if Questtween then Questtween:Stop() end
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameQuestBoss
				task.wait(1.1)
				_F("StartQuest", NameQuestBoss, LevelQuestBoss)
			end
		elseif AutoQuestBoss == false then
			if game:GetService("Workspace").Enemies:FindFirstChild(MonsterBoss) then
				for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
					if AutoBossFarm and v.Name == MonsterBoss and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
						repeat task.wait()
							if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
								Farmtween = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame)
							elseif v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
								EquipWeapon(SelectToolWeapon)
								if Farmtween then Farmtween:Stop() end
								Usefastattack = true
								toAroundTarget(v.HumanoidRootPart.CFrame)
							end
						until not AutoBossFarm or not v.Parent or v.Humanoid.Health <= 0 or AutoQuestBoss == true
						Usefastattack = false
					end
				end
			elseif AutoBossFarmHop and not game:GetService("ReplicatedStorage"):FindFirstChild(MonsterBoss) then
				ServerFunc:NormalTeleport()
			else
				Usefastattack = false
				Questtween = toTarget(CFrameBoss.Position,CFrameBoss)
				if (CFrameBoss.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
					if Questtween then Questtween:Stop() end
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameBoss
				end
			end
		else
			if game:GetService("Workspace").Enemies:FindFirstChild(MonsterBoss) then
				if string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameCheckQuestBoss) then
					for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if AutoBossFarm and v.Name == MonsterBoss and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
							repeat task.wait()
								if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
									Farmtween = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame)
								elseif v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
									EquipWeapon(SelectToolWeapon)
									if Farmtween then Farmtween:Stop() end
									Usefastattack = true
									toAroundTarget(v.HumanoidRootPart.CFrame)
								end
							until not AutoBossFarm or not v.Parent or v.Humanoid.Health <= 0 or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false or not string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameCheckQuestBoss)
							Usefastattack = false
						end
					end
				else
					_F("AbandonQuest")
				end
			elseif AutoBossFarmHop and not game:GetService("ReplicatedStorage"):FindFirstChild(MonsterBoss) then
				ServerFunc:NormalTeleport()
			else
				Usefastattack = false
				Questtween = toTarget(CFrameBoss.Position,CFrameBoss)
				if (CFrameBoss.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
					if Questtween then Questtween:Stop() end
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameBoss
				end
			end
		end
	end
end
function AutoFarmBossAll()
	for i, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
		if string.find(v.Name, "Boss") then
			if v.Name == "rip_indra True Form [Lv. 5000] [Raid Boss]" or v.Name == "rip_indra [Lv. 1500] [Boss]" or v.Name == "Ice Admiral [Lv. 700] [Boss]" or v.Name == "Don Swan [Lv. 1000] [Boss]" or v.Name == "Longma [Lv. 2000] [Boss]" then
			else
				SelectBoss = v.Name
				task.wait(.1)
				repeat task.wait()
					if game:GetService("Workspace").Enemies:FindFirstChild(SelectBoss) or game:GetService("ReplicatedStorage"):FindFirstChild(SelectBoss) then
						if AutoFarmAllBoss and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
							if game:GetService("ReplicatedStorage"):FindFirstChild(SelectBoss) then
								repeat task.wait()
									if game:GetService("ReplicatedStorage"):FindFirstChild(SelectBoss) then
										Usefastattack = false
										toTarget(game:GetService("ReplicatedStorage"):FindFirstChild(SelectBoss).HumanoidRootPart.CFrame * CFrame.new(1,60,1))
									end
								until not AutoFarmAllBoss or not v.Parent or v.Humanoid.Health <= 0 or not game:GetService("ReplicatedStorage"):FindFirstChild(SelectBoss)
							else
								repeat task.wait()
									if game:GetService("Workspace").Enemies:FindFirstChild(SelectBoss) then
										if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
											game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
										end
										VirtualUser:CaptureController()
										VirtualUser:ClickButton1(Vector2.new(851, 158), game:GetService("Workspace").Camera.CFrame)
										EquipWeapon(SelectToolWeapon)
										Usefastattack = true
										v.HumanoidRootPart.Transparency = 1
										v.HumanoidRootPart.CanCollide = false
										v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
										toTarget(v.HumanoidRootPart.CFrame * CFrame.new(1,20,1))
									end
								until not AutoFarmAllBoss or not v.Parent or v.Humanoid.Health <= 0 or (not game:GetService("ReplicatedStorage"):FindFirstChild(SelectBoss) and not game:GetService("Workspace").Enemies:FindFirstChild(SelectBoss))
							end
						end
					end
				until not AutoFarmAllBoss or not v.Parent or v.Humanoid.Health <= 0 or (not game:GetService("ReplicatedStorage"):FindFirstChild(SelectBoss) and not game:GetService("Workspace").Enemies:FindFirstChild(SelectBoss))
			end

		end
	end
end

local NoLoopDuplicate3 = false

local SelectWeaponInSwordList = ""
local SwordListFarmComplete = {}

function CheckMasteryWeapon(NameWe,MasNum)
	if inmyself(NameWe) then
		if tonumber(inmyself(NameWe):WaitForChild("Level").Value) < tonumber(MasNum) then
			return "DownTo"
		elseif tonumber(inmyself(NameWe):WaitForChild("Level").Value) > tonumber(MasNum) then
			return "UpTo"
		elseif tonumber(inmyself(NameWe):WaitForChild("Level").Value) == tonumber(MasNum) then
			return "true"
		end
	end
	return "else"
end

function AutoFarmMasterySwordList()
	if game:GetService("Workspace").Enemies:FindFirstChild(Monster) or (ThreeWorld and (game:GetService("Workspace").Enemies:FindFirstChild("Reborn Skeleton [Lv. 1975]") or game:GetService("Workspace").Enemies:FindFirstChild("Living Zombie [Lv. 2000]") or game:GetService("Workspace").Enemies:FindFirstChild("Demonic Soul [Lv. 2025]") or game:GetService("Workspace").Enemies:FindFirstChild("Posessed Mummy [Lv. 2050]"))) then
		for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
			if FarmMasterySwordList and ((ThreeWorld and (v.Name == "Reborn Skeleton [Lv. 1975]" or v.Name == "Living Zombie [Lv. 2000]" or v.Name == "Demonic Soul [Lv. 2025]" or v.Name == "Posessed Mummy [Lv. 2050]")) or v.Name == Monster) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
				repeat task.wait()
					FarmtoTarget = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame * CFrame.new(0,30,1))
					if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
						if FarmtoTarget then FarmtoTarget:Stop() end
						Usefastattack = true
						EquipWeapon(SelectWeaponInSwordList)
						StartMagnetAutoFarmLevel = true
						PosMon = v.HumanoidRootPart.CFrame
						if game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Character:FindFirstChild("Black Leg").Level.Value >= 150 then
							game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
							game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
						end
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 1)
					end
				until not game:GetService("Workspace").Enemies:FindFirstChild(Monster) and ((ThreeWorld and not (v.Name == "Reborn Skeleton [Lv. 1975]" or v.Name == "Living Zombie [Lv. 2000]" or v.Name == "Demonic Soul [Lv. 2025]" or v.Name == "Posessed Mummy [Lv. 2050]")) or v.Name == Monster) or not FarmMasterySwordList or v.Humanoid.Health <= 0 or not v.Parent
				Usefastattack = false
				StartMagnetAutoFarmLevel = false
			end
		end
	else
		StartMagnetAutoFarmLevel = false
		Usefastattack = false
		Modstween = toTarget(CFrameMon.Position,CFrameMon)
		if (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
			if Modstween then Modstween:Stop() end
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon
		end
	end
end
_G.AreRedeem = false
local CountPlayersLevel = 0
local QuestAreDone = false
local NoLoopDuplicate4 = false

function AutoSkipFarmLevel()
	GetQuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title
	GetQuest = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest
	MyLevel = game.Players.LocalPlayer.Data.Level.Value
	if (MyLevel >= 20 and MyLevel <= 40) or CountPlayersLevel > 15 or QuestAreDone == true then
		UsefastattackPlayers = false
		if MyLevel >= 100 and QuestAreDone ~= true then
			print("HOP")
			UsefastattackPlayers = false
			spawn(function()
				ServerFunc:NormalTeleport()
			end)
			task.wait(0.5)
			ServerFunc:NormalTeleport()
		end
		local CFrameMon = CFrame.new(-4713.13134765625, 845.2769775390625, -1859.4736328125)
		if game:GetService("Workspace").Enemies:FindFirstChild("God's Guard [Lv. 450]") then
			for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
				if (SkipFarmLevel and FarmLevel) and v.Name == "God's Guard [Lv. 450]" and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
					repeat task.wait()
						if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
							FarmtoTarget = toTarget(v.HumanoidRootPart.CFrame)
						elseif v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
							if FarmtoTarget then FarmtoTarget:Stop() end
							Usefastattack = true
							EquipWeapon(SelectToolWeapon)
							for i2,v2 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
								if (SkipFarmLevel and FarmLevel) and v2.Name == "God's Guard [Lv. 450]" and v2:FindFirstChild("HumanoidRootPart") and v2:FindFirstChild("Humanoid") and v2.Humanoid.Health > 0 then
									if InMyNetWork(v2.HumanoidRootPart) then
										v2.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
										v2.Humanoid.JumpPower = 0
										v2.Humanoid.WalkSpeed = 0
										v2.HumanoidRootPart.CanCollide = false
										v2.Humanoid:ChangeState(14)
										v2.Humanoid:ChangeState(11)
										v2.HumanoidRootPart.Size = Vector3.new(55,55,55)
									end
								end
							end
							if game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Character:FindFirstChild("Black Leg").Level.Value >= 150 then
								game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
								game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
							end
							if TeleportType == 1 then
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 1)
							elseif TeleportType == 2 then
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 1, 30)
							elseif TeleportType == 3 then
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(1, 1, -30)
							elseif TeleportType == 4 then
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(30, 1, 0)
							elseif TeleportType == 5 then
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(-30, 1, 0)
							else
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 1)
							end
						end
					until not game:GetService("Workspace").Enemies:FindFirstChild("God's Guard [Lv. 450]") or not (SkipFarmLevel or FarmLevel) or v.Humanoid.Health <= 0 or not v.Parent
					Usefastattack = false
				end
			end
		else
			Usefastattack = false
			Modstween = toTarget(CFrameMon.Position,CFrameMon)
			if (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
				if Modstween then Modstween:Stop() end
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon
			end
			task.wait(0.5)
		end
	else
		local AllPlayersTableSkipFarm = {}
		_F("BuyHaki","Buso")
		for i,v in pairs(game:GetService("Workspace").Characters:GetChildren()) do
			table.insert(AllPlayersTableSkipFarm,v.Name)
		end
		if GetQuest.Visible == false then
			if FarmtoTarget then FarmtoTarget:Stop() end
			UsefastattackPlayers = false
			task.wait(0.1)
			if not tostring(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")):find("We heard some") then
				task.wait(0.5)
				if not tostring(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")):find("We heard some") then
					task.wait(1)
					if not tostring(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")):find("We heard some") then
						task.wait(1)
						if not tostring(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")):find("We heard some") then
							print("AREQUEST DONE")
							QuestAreDone = true
							CountPlayersLevel = 0
						end
					end
				end
			end
			task.wait(0.2)
		elseif GetQuest.Visible == true then
			if table.find(AllPlayersTableSkipFarm,GetQuestTitle.Text:split(" ")[2]) then
				for i,v_old in pairs(game:GetService("Players"):GetChildren()) do
					if not v_old:FindFirstChild("Data") then return end
					if GetQuest.Visible == false then return end
					if not v_old.Character then return end
					if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,(function() if v_old then return v_old.Name else return "NIL" end end)()) then
						if (v_old.Data.Level.Value) >= 25 and (v_old.Data.Level.Value or MyLevel) >= MyLevel-50 and (v_old.Data.Level.Value or MyLevel) <= MyLevel+50 then
							if FarmLevel and SkipFarmLevel and v_old.Name == GetQuestTitle.Text:split(" ")[2] and v_old.Character:FindFirstChild("HumanoidRootPart") and v_old.Character:FindFirstChild("Humanoid") and v_old.Character.Humanoid.Health > 0 then
								repeat game:GetService('RunService').RenderStepped:Wait()
									if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.PvpDisabled.Visible == true then
										_F("EnablePvp")
									end
									if v_old.Character:FindFirstChild("HumanoidRootPart") and v_old.Character:FindFirstChild("Humanoid") and (v_old.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
										FarmtoTarget = toTarget(v_old.Character.HumanoidRootPart.CFrame * CFrame.new(0,30,1))
									elseif v_old.Character:FindFirstChild("HumanoidRootPart") and v_old.Character:FindFirstChild("Humanoid") and (v_old.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
										if FarmtoTarget then FarmtoTarget:Stop() end
										EquipWeapon(SelectToolWeapon)
										v_old.Character.HumanoidRootPart.Size = Vector3.new(30,30,30)
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v_old.Character.HumanoidRootPart.CFrame + (v_old.Character.HumanoidRootPart.CFrame.LookVector * -20)
										if NoLoopDuplicate4 == false then
											NoLoopDuplicate4 = true
											delay(0.5,function()
												UsefastattackPlayers = true
												NoLoopDuplicate4 = false
											end)
										end
										if (function()for a,b in pairs(game:GetService("Players")["LocalPlayer"].PlayerGui:FindFirstChild("Notifications"):GetChildren())do if b.Name=="NotificationTemplate"then if string.lower(b.Text):find("can")then pcall(function()b:Destroy()end)return true end end end;return false end)() then
											break
										end
									end
								until not v_old and not FarmLevel or not string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,(function() if v_old then return v_old.Name else return "NIL" end end)()) or v_old.Character.Humanoid.Health <= 0 or not v_old.Character or GetQuest.Visible == false
								UsefastattackPlayers = false
								spawn(function()
									task.wait(0.51)
									UsefastattackPlayers = false
								end)
							end
						else
							UsefastattackPlayers = false
							task.wait()
							_F("AbandonQuest");
							task.wait(0.5)
						end
					end
				end
			else
				UsefastattackPlayers = false
				task.wait()
				_F("AbandonQuest");
				task.wait(0.5)
			end
		end
	end
	CountPlayersLevel = (CountPlayersLevel + 1) % 30
	print(CountPlayersLevel)
end

function AutoFarmLevel()
	GetQuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title
	GetQuest = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest
	MyLevel = game.Players.LocalPlayer.Data.Level.Value
	if (SkipFarmLevel and FarmLevel) and isPrivate == false and (MyLevel >= 20 and MyLevel <= 160) then
		AutoSkipFarmLevel()
	else
		if not string.find(GetQuestTitle.Text, NameCheckQuest) and AutoQuest == true then _F("AbandonQuest"); end
		if GetQuest.Visible == false and AutoQuest == true then
			Usefastattack = false
			StartMagnetAutoFarmLevel = false
			Questtween = toTarget(CFrameQuest.Position,CFrameQuest)
			if (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
				if Questtween then Questtween:Stop() end
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameQuest
				task.wait(0.95)
				_F("StartQuest", NameQuest, LevelQuest)

			end
		elseif GetQuest.Visible == true or AutoQuest == false then
			if game:GetService("Workspace").Enemies:FindFirstChild(Monster) then
				for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
					if FarmLevel and v.Name == Monster and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
						if string.find(GetQuestTitle.Text, NameCheckQuest) or AutoQuest == false then
							repeat task.wait()
								if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
									FarmtoTarget = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame * CFrame.new(0,30,1))
								elseif v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
									if FarmtoTarget then FarmtoTarget:Stop() end
									Usefastattack = true
									EquipWeapon(SelectToolWeapon)
									StartMagnetAutoFarmLevel = true
									PosMon = v.HumanoidRootPart.CFrame
									if game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Character:FindFirstChild("Black Leg").Level.Value >= 150 then
										game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
										game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
									end
									if TeleportType == 1 then
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 60, 1)
									elseif TeleportType == 2 then
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 1, 60)
									elseif TeleportType == 3 then
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(1, 1, -60)
									elseif TeleportType == 4 then
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(60, 1, 0)
									elseif TeleportType == 5 then
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(-60, 1, 0)
									else
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 60, 1)
									end
								end
							until not game:GetService("Workspace").Enemies:FindFirstChild(Monster) or not FarmLevel or (AutoQuest == true and not string.find(GetQuestTitle.Text, NameCheckQuest)) or v.Humanoid.Health <= 0 or not v.Parent or ( AutoQuest == true and GetQuest.Visible == false)
							Usefastattack = false
							StartMagnetAutoFarmLevel = false
						else
							_F("AbandonQuest");
						end
					end
				end
			else
				StartMagnetAutoFarmLevel = false
				Usefastattack = false
				if not string.find(GetQuestTitle.Text, NameCheckQuest) and AutoQuest == true then _F("AbandonQuest"); end
				Modstween = toTarget(CFrameMon.Position,CFrameMon)
				if (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
					if Modstween then Modstween:Stop() end
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon
				end
			end
		end
	end
end
function AutoFarmMasteryDevilFruit()
	if game:GetService("Workspace").Enemies:FindFirstChild(Monster) or (ThreeWorld and (game:GetService("Workspace").Enemies:FindFirstChild("Reborn Skeleton [Lv. 1975]") or game:GetService("Workspace").Enemies:FindFirstChild("Living Zombie [Lv. 2000]") or game:GetService("Workspace").Enemies:FindFirstChild("Demonic Soul [Lv. 2025]") or game:GetService("Workspace").Enemies:FindFirstChild("Posessed Mummy [Lv. 2050]"))) then
		for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
			if FarmMasteryDevilFruit and ((ThreeWorld and (v.Name == "Reborn Skeleton [Lv. 1975]" or v.Name == "Living Zombie [Lv. 2000]" or v.Name == "Demonic Soul [Lv. 2025]" or v.Name == "Posessed Mummy [Lv. 2050]")) or v.Name == Monster) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
				repeat task.wait()
					if v:FindFirstChild("HumanoidRootPart") and game:GetService("Workspace").Enemies:FindFirstChild(Monster) or (ThreeWorld and (game:GetService("Workspace").Enemies:FindFirstChild("Reborn Skeleton [Lv. 1975]") or game:GetService("Workspace").Enemies:FindFirstChild("Living Zombie [Lv. 2000]") or game:GetService("Workspace").Enemies:FindFirstChild("Demonic Soul [Lv. 2025]") or game:GetService("Workspace").Enemies:FindFirstChild("Posessed Mummy [Lv. 2050]"))) then
						if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
							FarmtoTarget = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
						elseif v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
							if FarmtoTarget then FarmtoTarget:Stop() end

							StartMagnetAutoFarmLevel = true
							PosMon = v.HumanoidRootPart.CFrame
							HealthMin = v.Humanoid.MaxHealth*PersenHealth/100
							if v.Humanoid.Health <= HealthMin and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
								EquipWeapon(game.Players.LocalPlayer.Data.DevilFruit.Value)
								if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Door-Door") then
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 1)
								else
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 40, 1)
								end
								if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then
									PositionSkillMasteryDevilFruit = v.HumanoidRootPart.Position
									UseSkillMasteryDevilFruit = true
									if game:GetService("Players").LocalPlayer.Character:FindFirstChild(game.Players.LocalPlayer.Data.DevilFruit.Value) then
										MasteryDevilFruit = require(game:GetService("Players").LocalPlayer.Character[game.Players.LocalPlayer.Data.DevilFruit.Value].Data)
										DevilFruitMastery = game:GetService("Players").LocalPlayer.Character[game.Players.LocalPlayer.Data.DevilFruit.Value].Level.Value
									elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(game.Players.LocalPlayer.Data.DevilFruit.Value) then
										MasteryDevilFruit = require(game:GetService("Players").LocalPlayer.Backpack[game.Players.LocalPlayer.Data.DevilFruit.Value].Data)
										DevilFruitMastery = game:GetService("Players").LocalPlayer.Backpack[game.Players.LocalPlayer.Data.DevilFruit.Value].Level.Value
									end
									if SkillClick then
										VirtualUser:CaptureController()
										VirtualUser:ClickButton1(Vector2.new(851, 158), game:GetService("Workspace").Camera.CFrame)
									end
									if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dragon-Dragon") then
										if SkillZ and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.Z then
											game:service('VirtualInputManager'):SendKeyEvent(true, "Z", false, game)
											task.wait(SkillZT)
											game:service('VirtualInputManager'):SendKeyEvent(false, "Z", false, game)
										end
										if SkillC and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.C then
											game:service('VirtualInputManager'):SendKeyEvent(true, "C", false, game)
											task.wait(SkillCT)
											game:service('VirtualInputManager'):SendKeyEvent(false, "C", false, game)
										end
									elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("Human-Human: Buddha") then
										if SkillZ and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and game.Players.LocalPlayer.Character.HumanoidRootPart.Size == Vector3.new(7.6, 7.676, 3.686) and DevilFruitMastery >= MasteryDevilFruit.Lvl.Z then
										else
											game:service('VirtualInputManager'):SendKeyEvent(true, "Z", false, game)
											task.wait(.1)
											game:service('VirtualInputManager'):SendKeyEvent(false, "Z", false, game)
										end
										if SkillX and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.X then
											game:service('VirtualInputManager'):SendKeyEvent(true, "X", false, game)
											task.wait(SkillXT)
											game:service('VirtualInputManager'):SendKeyEvent(false, "X", false, game)
										end
										if SkillC and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.C then
											game:service('VirtualInputManager'):SendKeyEvent(true, "C", false, game)
											task.wait(SkillCT)
											game:service('VirtualInputManager'):SendKeyEvent(false, "C", false, game)
										end
									elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dough-Dough") then
										PositionSkillMasteryDevilFruit = v.HumanoidRootPart.Position
										game:GetService("Players").LocalPlayer.Character:FindFirstChild(game.Players.LocalPlayer.Data.DevilFruit.Value).MousePos.Value = v.HumanoidRootPart.Position
										if SkillZ and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.Z then
											game:service('VirtualInputManager'):SendKeyEvent(true, "Z", false, game)
											task.wait(SkillZT)
											game:service('VirtualInputManager'):SendKeyEvent(false, "Z", false, game)
										end
										if SkillX and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.X then
											game:service('VirtualInputManager'):SendKeyEvent(true, "X", false, game)
											task.wait(SkillXT)
											game:service('VirtualInputManager'):SendKeyEvent(false, "X", false, game)
										end
										if SkillV and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.V then
											game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
											task.wait(SkillVT)
											game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
										end
									elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("Control-Control") then
										PositionSkillMasteryDevilFruit = v.HumanoidRootPart.Position
										if game:GetService("Lighting"):FindFirstChild("OpeGlobe") and game:GetService("Lighting"):FindFirstChild("OpeGlobe").TintColor == Color3.fromRGB(164,189,255) then
											if SkillX and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
												game:service('VirtualInputManager'):SendKeyEvent(true, "X", false, game)
												task.wait(SkillXT)
												game:service('VirtualInputManager'):SendKeyEvent(false, "X", false, game)
											end
											if SkillC and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.C then
												game:service('VirtualInputManager'):SendKeyEvent(true, "C", false, game)
												task.wait(SkillCT)
												game:service('VirtualInputManager'):SendKeyEvent(false, "C", false, game)
											end
											if SkillV and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.V then
												game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
												task.wait(SkillVT)
												game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
											end
										else
											game:service('VirtualInputManager'):SendKeyEvent(true, "Z", false, game)
											task.wait(2)
											game:service('VirtualInputManager'):SendKeyEvent(false, "Z", false, game)
										end
									elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild(game.Players.LocalPlayer.Data.DevilFruit.Value) then
										game:GetService("Players").LocalPlayer.Character:FindFirstChild(game.Players.LocalPlayer.Data.DevilFruit.Value).MousePos.Value = v.HumanoidRootPart.Position
										if SkillZ and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.Z then
											game:service('VirtualInputManager'):SendKeyEvent(true, "Z", false, game)
											task.wait(SkillZT)
											game:service('VirtualInputManager'):SendKeyEvent(false, "Z", false, game)
										end
										if SkillX and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.X then
											game:service('VirtualInputManager'):SendKeyEvent(true, "X", false, game)
											task.wait(SkillXT)
											game:service('VirtualInputManager'):SendKeyEvent(false, "X", false, game)
										end
										if SkillC and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.C then
											game:service('VirtualInputManager'):SendKeyEvent(true, "C", false, game)
											task.wait(SkillCT)
											game:service('VirtualInputManager'):SendKeyEvent(false, "C", false, game)
										end
										if SkillV and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.V then
											game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
											task.wait(SkillVT)
											game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
										end
										if SkillF and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and DevilFruitMastery >= MasteryDevilFruit.Lvl.V then
											game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
											task.wait(SkillFT)
											game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
										end
									end
								end
							else
								VirtualUser:CaptureController()
								VirtualUser:ClickButton1(Vector2.new(851, 158), game:GetService("Workspace").Camera.CFrame)
								UseSkillMasteryDevilFruit = false
								EquipWeapon(SelectToolWeapon)
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
							end
						end
					else
						StartMagnetAutoFarmLevel = false
						Modstween = toTarget(CFrameMon.Position,CFrameMon)
						if (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
							if Modstween then Modstween:Stop() end
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon
						end
					end
				until not game:GetService("Workspace").Enemies:FindFirstChild(Monster) and (ThreeWorld and not (game:GetService("Workspace").Enemies:FindFirstChild("Reborn Skeleton [Lv. 1975]") or game:GetService("Workspace").Enemies:FindFirstChild("Living Zombie [Lv. 2000]") or game:GetService("Workspace").Enemies:FindFirstChild("Demonic Soul [Lv. 2025]") or game:GetService("Workspace").Enemies:FindFirstChild("Posessed Mummy [Lv. 2050]"))) or not FarmMasteryDevilFruit or v.Humanoid.Health <= 0 or not v.Parent
				StartMagnetAutoFarmLevel = false
			end
		end
	else
		StartMagnetAutoFarmLevel = false
		Modstween = toTarget(CFrameMon.Position,CFrameMon)
		if (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
			if Modstween then Modstween:Stop() end
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon
		end
	end
end

function NextIsland()
	GoIsland = 0
	ToIslandCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
	local ToIslandCFrame2 = {
		1,
		2,
		3,
		4,
		5
	}
	local MaxDisLand = {
		[1] = math.huge,
		[2] = math.huge,
		[3] = math.huge,
		[4] = math.huge,
		[5] = math.huge
	}
	local AddCFrame
	pcall(function()
		if string.find(game.Players.LocalPlayer.Data:WaitForChild("DevilFruit").Value,"Phoenix") then
			AddCFrame = CFrame.new(math.random(20,80),80,math.random(20,80))
		else
			AddCFrame = CFrame.new(0,80,1)
		end
	end)
	for i,v in pairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
		local ThisDis = (v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude

		if game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false then
		elseif v.Name == "Island 5" then
			if ThisDis < MaxDisLand[5] and ThisDis < 4000 then
				MaxDisLand[5] = ThisDis
				GoIsland = 5
				ToIslandCFrame2[5] = v.CFrame * AddCFrame
			end
		elseif v.Name == "Island 4" then
			if ThisDis < MaxDisLand[4] and ThisDis < 4000 and GoIsland < 4 then
				MaxDisLand[4] = ThisDis
				GoIsland = 4
				ToIslandCFrame2[4] = v.CFrame * AddCFrame
			end
		elseif v.Name == "Island 3" then
			if ThisDis < MaxDisLand[3] and ThisDis < 4000 and GoIsland < 3 then
				MaxDisLand[3] = ThisDis
				GoIsland = 3
				ToIslandCFrame2[3] = v.CFrame * AddCFrame
			end
		elseif v.Name ==  "Island 2" then
			if ThisDis < MaxDisLand[2] and ThisDis < 4000 and GoIsland < 2 then
				MaxDisLand[2] = ThisDis
				GoIsland = 2
				ToIslandCFrame2[2] = v.CFrame * AddCFrame
			end
		elseif v.Name == "Island 1" then
			if ThisDis < MaxDisLand[1] and ThisDis < 4000 and GoIsland < 1 then
				MaxDisLand[1] = ThisDis
				GoIsland = 1
				ToIslandCFrame2[1] = v.CFrame * AddCFrame
			end
		end
	end
	ToIslandCFrame = ToIslandCFrame2[GoIsland]
end

function CheckPlayerInServ(tab)
	local want = #tab
	local Get = 0
	for i,v in pairs(game.Players:GetChildren()) do
		if table.find(tab,v.Name) then
			Get = Get + 1
		end
	end
	return Get == want
end

local velocityHandlerName = "indq9pdnq0"
local gyroHandlerName = "Fpjq90pdfhipqdm"
local mfly1
local mfly2
RunService = game:GetService("RunService")
speaker = game.Players.LocalPlayer
vehicleflyspeed = 5
function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end
local unmobilefly = function(speaker)
	pcall(function()
		FLYING = false
		local root = getRoot(speaker.Character)
		root:FindFirstChild(velocityHandlerName):Destroy()
		root:FindFirstChild(gyroHandlerName):Destroy()
		speaker.Character:FindFirstChildWhichIsA("Humanoid").PlatformStand = false
		mfly1:Disconnect()
		mfly2:Disconnect()
	end)
end

local mobilefly = function(speaker, vfly,ez)
	unmobilefly(speaker)
	FLYING = true

	local root = getRoot(speaker.Character)
	local camera = workspace.CurrentCamera
	local v3none = Vector3.new()
	local v3zero = Vector3.new(0, 0, 0)
	local v3inf = Vector3.new(9e9, 9e9, 9e9)

	local controlModule = require(speaker.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
	local bv = Instance.new("BodyVelocity")
	bv.Name = velocityHandlerName
	bv.Parent = root
	bv.MaxForce = v3zero
	bv.Velocity = v3zero

	local bg = Instance.new("BodyGyro")
	bg.Name = gyroHandlerName
	bg.Parent = root
	bg.MaxTorque = v3inf
	bg.P = 1000
	bg.D = 50

	mfly1 = speaker.CharacterAdded:Connect(function()
		local bv = Instance.new("BodyVelocity")
		bv.Name = velocityHandlerName
		bv.Parent = root
		bv.MaxForce = v3zero
		bv.Velocity = v3zero

		local bg = Instance.new("BodyGyro")
		bg.Name = gyroHandlerName
		bg.Parent = root
		bg.MaxTorque = v3inf
		bg.P = 1000
		bg.D = 50
	end)

	mfly2 = RunService.RenderStepped:Connect(function()
		root = getRoot(speaker.Character)
		camera = workspace.CurrentCamera
		if speaker.Character:FindFirstChildWhichIsA("Humanoid") and root and root:FindFirstChild(velocityHandlerName) and root:FindFirstChild(gyroHandlerName) then
			local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
			local VelocityHandler = root:FindFirstChild(velocityHandlerName)
			local GyroHandler = root:FindFirstChild(gyroHandlerName)

			VelocityHandler.MaxForce = v3inf
			GyroHandler.MaxTorque = v3inf
			if not vfly then humanoid.PlatformStand = true end
			GyroHandler.CFrame = camera.CoordinateFrame
			VelocityHandler.Velocity = v3none

			local direction = Vector3.new(0.0069,0,-1.17) or controlModule:GetMoveVector()
			if direction.X > 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
			if direction.X < 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
			if direction.Z > 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
			if direction.Z < 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
		end
	end)
end


spawn(function()
	while task.wait() do
		for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
			if v:IsA("Tool") then
				if v:FindFirstChild("RemoteFunctionShoot") then
					SelectToolWeaponGun = v.Name
				end
			end
		end
		for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
			if v:IsA("Tool") then
				if v:FindFirstChild("RemoteFunctionShoot") then
					SelectToolWeaponGun = v.Name
				end
			end
		end
		task.wait(2)
	end
end)
function AutoFarmMasteryGun()
	if game:GetService("Workspace").Enemies:FindFirstChild(Monster) or (ThreeWorld and (game:GetService("Workspace").Enemies:FindFirstChild("Reborn Skeleton [Lv. 1975]") or game:GetService("Workspace").Enemies:FindFirstChild("Living Zombie [Lv. 2000]") or game:GetService("Workspace").Enemies:FindFirstChild("Demonic Soul [Lv. 2025]") or game:GetService("Workspace").Enemies:FindFirstChild("Posessed Mummy [Lv. 2050]"))) then
		for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
			if FarmMasteryGun and ((ThreeWorld and (v.Name == "Reborn Skeleton [Lv. 1975]" or v.Name == "Living Zombie [Lv. 2000]" or v.Name == "Demonic Soul [Lv. 2025]" or v.Name == "Posessed Mummy [Lv. 2050]")) or v.Name == Monster) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
				repeat task.wait()
					if game:GetService("Workspace").Enemies:FindFirstChild(Monster) or (ThreeWorld and (game:GetService("Workspace").Enemies:FindFirstChild("Reborn Skeleton [Lv. 1975]") or game:GetService("Workspace").Enemies:FindFirstChild("Living Zombie [Lv. 2000]") or game:GetService("Workspace").Enemies:FindFirstChild("Demonic Soul [Lv. 2025]") or game:GetService("Workspace").Enemies:FindFirstChild("Posessed Mummy [Lv. 2050]"))) then
						FarmtoTarget = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
						if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
							if FarmtoTarget then FarmtoTarget:Stop() end

							StartMagnetAutoFarmLevel = true
							PosMon = v.HumanoidRootPart.CFrame
							if game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Character:FindFirstChild("Black Leg").Level.Value >= 150 then
								game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
								game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
							end
							HealthMin = v.Humanoid.MaxHealth*PersenHealth/100
							if v.Humanoid.Health <= HealthMin and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
								EquipWeapon(SelectToolWeaponGun)

								toAroundTarget(v.HumanoidRootPart.CFrame)
								if game:GetService("Players").LocalPlayer.Character:FindFirstChild(SelectToolWeaponGun) and game:GetService("Players").LocalPlayer.Character:FindFirstChild(SelectToolWeaponGun):FindFirstChild("RemoteFunctionShoot") then
									ShootGunMasPos = v.HumanoidRootPart.Position
									UseSkillMasteryGun = true
									if game:GetService("Players").LocalPlayer.Character:FindFirstChild(SelectToolWeaponGun) then
										MasteryGun = require(game:GetService("Players").LocalPlayer.Character[SelectToolWeaponGun].Data)
										GunMastery = game:GetService("Players").LocalPlayer.Character[SelectToolWeaponGun].Level.Value
									elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(SelectToolWeaponGun) then
										MasteryGun = require(game:GetService("Players").LocalPlayer.Backpack[SelectToolWeaponGun].Data)
										GunMastery = game:GetService("Players").LocalPlayer.Backpack[SelectToolWeaponGun].Level.Value
									end
									game:GetService("VirtualUser"):ClickButton1(Vector2.new())
									if SkillZ and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and GunMastery >= MasteryGun.Lvl.Z then
										game:service('VirtualInputManager'):SendKeyEvent(true, "Z", false, game)
										task.wait(.1)
										game:service('VirtualInputManager'):SendKeyEvent(false, "Z", false, game)
									end
									if SkillX and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and GunMastery >= MasteryGun.Lvl.X then
										game:service('VirtualInputManager'):SendKeyEvent(true, "X", false, game)
										task.wait(.1)
										game:service('VirtualInputManager'):SendKeyEvent(false, "X", false, game)
									end
								end
							else
								UseSkillMasteryGun = false
								VirtualUser:CaptureController()
								VirtualUser:ClickButton1(Vector2.new(851, 158), game:GetService("Workspace").Camera.CFrame)
								EquipWeapon(SelectToolWeapon)
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
							end
						end
					else
						UseSkillMasteryGun = false
						StartMagnetAutoFarmLevel = false
						Modstween = toTarget(CFrameMon.Position,CFrameMon)
						if (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
							if Modstween then Modstween:Stop() end
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon
						end
					end
				until not game:GetService("Workspace").Enemies:FindFirstChild(Monster) and (ThreeWorld and not (game:GetService("Workspace").Enemies:FindFirstChild("Reborn Skeleton [Lv. 1975]") or game:GetService("Workspace").Enemies:FindFirstChild("Living Zombie [Lv. 2000]") or game:GetService("Workspace").Enemies:FindFirstChild("Demonic Soul [Lv. 2025]") or game:GetService("Workspace").Enemies:FindFirstChild("Posessed Mummy [Lv. 2050]"))) or not FarmMasteryGun or v.Humanoid.Health <= 0 or not v.Parent
				StartMagnetAutoFarmLevel = false
			end
		end
	else
		StartMagnetAutoFarmLevel = false
		Modstween = toTarget(CFrameMon.Position,CFrameMon)
		if (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
			if Modstween then Modstween:Stop() end
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon
		end
	end
end

spawn(function()
	while task.wait() do
		TeleportType = math.random(1,5)
		task.wait(0.3)
	end
end)

LPH_JIT_MAX(function()
	spawn(function()
		game:GetService("RunService").RenderStepped:Connect(function()
			if StartMagnetAutoFarmLevel or StartMagnetEctoplasm or StartMagnetRengoku then
				for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
					if (FarmMasterySwordList or FarmMasteryGun or FarmMasteryDevilFruit or Auto_Farm_Level or AutoFarmSelectLevel) and StartMagnetAutoFarmLevel and (((ThreeWorld and (v.Name == "Reborn Skeleton [Lv. 1975]" or v.Name == "Living Zombie [Lv. 2000]" or v.Name == "Demonic Soul [Lv. 2025]" or v.Name == "Posessed Mummy [Lv. 2050]")) or v.Name == Monster) or v.Name:find("Boss")) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
						if v.Name == "Factory Staff [Lv. 800]" then
							if InMyNetWork(v.HumanoidRootPart) then
								v.HumanoidRootPart.CFrame = PosMon 
								v.Humanoid.JumpPower = 0
								v.Humanoid.WalkSpeed = 0
								v.HumanoidRootPart.CanCollide = false
								v.Humanoid:ChangeState(14)
								v.Humanoid:ChangeState(11)
								v.HumanoidRootPart.Size = Vector3.new(55,55,55)
							end
						else
							if InMyNetWork(v.HumanoidRootPart) then
								v.HumanoidRootPart.CFrame = PosMon 
								v.Humanoid.JumpPower = 0
								v.Humanoid.WalkSpeed = 0
								v.HumanoidRootPart.CanCollide = false
								v.Humanoid:ChangeState(14)
								v.Humanoid:ChangeState(11)
								v.HumanoidRootPart.Size = Vector3.new(55,55,55)
							end
						end
					elseif AutoFramEctoplasm and StartMagnetEctoplasm and string.find(v.Name, "Ship") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
						if InMyNetWork(v.HumanoidRootPart) then
							v.HumanoidRootPart.CFrame = PosMonEctoplasm
							v.Humanoid.JumpPower = 0
							v.Humanoid.WalkSpeed = 0
							v.HumanoidRootPart.CanCollide = false
							v.Humanoid:ChangeState(14)
							v.HumanoidRootPart.Size = Vector3.new(55,55,55)
						end
					elseif AutoRengoku and StartMagnetRengoku and v.Name == "Snow Lurker [Lv. 1375]" and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
						if InMyNetWork(v.HumanoidRootPart) then
							v.HumanoidRootPart.CFrame = PosMonRengoku
							v.Humanoid.JumpPower = 0
							v.Humanoid.WalkSpeed = 0
							v.HumanoidRootPart.CanCollide = false
							v.Humanoid:ChangeState(14)
							v.HumanoidRootPart.Size = Vector3.new(55,55,55)
						end
					end
				end
			end
		end)
	end)
end)()

local MouseCheckReq = game.Players.LocalPlayer:GetMouse()

LPH_NO_VIRTUALIZE(function()
	local gg = getrawmetatable(game)
	local old = gg.__index
	setreadonly(gg,false)
	gg.__index = newcclosure(function(...)
		local args = {...}
		if FarmMasteryDevilFruit or FarmMasteryGun or AutoFarmBounty or AutoSeaBeast or Aimlock or AimBotCircle then
			if args[1] == MouseCheckReq and args[2] == "Hit" and not checkcaller() then
				if UseSkillMasteryDevilFruit and FarmMasteryDevilFruit then

					return CFrame.new(PositionSkillMasteryDevilFruit)

				elseif FarmMasteryGun and UseSkillMasteryGun then

					return CFrame.new(ShootGunMasPos)

				elseif AutoFarmBounty and PosTargetBounty and SpamSkillBounty then

					return CFrame.new(PosTargetBounty)

				elseif (AutoSeaBeast or Terrorshark or Auto_Kill_Leviathan) and SpamSkillSea then

					return CFrame.new(PosKillSea)

				elseif Aimlock and AimlockPos then

					if UserInputService:IsKeyDown(Enum.KeyCode.R) and SoruLockPlayer then
						if (AimlockPos - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 200 then
							return old(unpack(args))
						end
					elseif UserInputService:IsKeyDown(Enum.KeyCode.R) then
						return old(unpack(args))
					end

					return CFrame.new(AimlockPos)

				elseif AimBotCircle and AimBotCirclePos then
					if UserInputService:IsKeyDown(Enum.KeyCode.R) and SoruLockPlayer then
						if (AimBotCirclePos.Head.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 100 then
							return old(unpack(args))
						end
					elseif UserInputService:IsKeyDown(Enum.KeyCode.R) then
						return old(unpack(args))
					end
					pcall(function()
						if AimBotCirclePos.Humanoid.MoveDirection.Magnitude == 1 then
							mymagnitude = (AimBotCirclePos.Head.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
							if mymagnitude <= 20 then
								AddForward = AimBotCirclePos.Head.CFrame + AimBotCirclePos.Head.CFrame.LookVector * 10
							elseif mymagnitude <= 50 then
								AddForward = AimBotCirclePos.Head.CFrame + AimBotCirclePos.Head.CFrame.LookVector * 20
							elseif mymagnitude <= 300 then
								AddForward = AimBotCirclePos.Head.CFrame + AimBotCirclePos.Head.CFrame.LookVector * 30
							elseif mymagnitude <= 500 then
								AddForward = AimBotCirclePos.Head.CFrame + AimBotCirclePos.Head.CFrame.LookVector * 40
							elseif mymagnitude > 500 then
								AddForward = AimBotCirclePos.Head.CFrame + AimBotCirclePos.Head.CFrame.LookVector * 50
							end
						else
							AddForward = AimBotCirclePos.Head.CFrame
						end
					end)
					return AddForward

				end
			end
		end
		return old(unpack(args))
	end)

	local gg = getrawmetatable(game)
	local old = gg.__namecall
	setreadonly(gg,false)
	gg.__namecall = newcclosure(function(...)
		local method = getnamecallmethod()
		local args = {...}
		if tostring(method) == "FireServer" then
			if tostring(args[1]) == "RemoteEvent" then
				if tostring(args[2]) ~= "true" and tostring(args[2]) ~= "false" then
					if UseSkillMasteryDevilFruit and FarmMasteryDevilFruit then

						args[2] = PositionSkillMasteryDevilFruit

					elseif FarmMasteryGun and UseSkillMasteryGun then
						args[2] = ShootGunMasPos

					end
					return old(unpack(args))
				end
			end
		end
		return old(...)
	end)
end)()

FastModeF = LPH_NO_VIRTUALIZE(function()
	if not game:IsLoaded() then repeat task.wait() until game:IsLoaded() end
	game.Players.LocalPlayer.PlayerScripts.WaterCFrame.Disabled = true
	L_1 = game:GetService("Workspace");
	L_2 = game:GetService("Lighting");
	L_3 = L_1.Terrain;
	L_4 = game:GetService("Players");
	L_5 = L_4.LocalPlayer.Character;

	L_3.WaterWaveSize = 0;L_3.WaterWaveSpeed = 0;L_3.WaterReflectance = 0;L_3.WaterTransparency = 0;
	L_2.GlobalShadows = false;L_2.FogEnd = tonumber(9e9);L_2.Brightness = 0;
	settings().Rendering.QualityLevel = "Level01";
	settings().Rendering.GraphicsMode = "NoGraphics";
	sethiddenproperty(L_2, "Technology", "Compatibility");
	for i,v in pairs(L_1:GetDescendants()) do
		if v.ClassName == "Part" or v.ClassName == "SpawnLocation" or v.ClassName == "WedgePart" or v.ClassName == "Terrain" or v.ClassName == "MeshPart" then
			v.Material = "Plastic";v.Reflectance = 0;v.CastShadow = false;
		elseif v.ClassName == "Decal" or v:IsA("Texture") then
			v.Texture = 0;v.Transparency = 1;
		elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.LightInfluence = 0;v.Texture = 0;v.Lifetime = NumberRange.new(0);
		elseif v:IsA("Explosion") then
			v.BlastPressure = 0;v.BlastRadius = 0;
		elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
			v.Enabled = false;
		elseif v:IsA("MeshPart") then
			v.Material = "Plastic";v.Reflectance = 0;v.TextureId = 0;v.CastShadow = false;v.RenderFidelity = Enum.RenderFidelity.Performance;
		elseif v.ClassName == "SpecialMesh" then
			v.TextureId = "rbxassetid://0";
		elseif v.ClassName == "Shirt" or v.ClassName == "Pants" or v.ClassName == "Accessory" then
			v:Destroy();
		end
	end
	for i,v in pairs(L_2:GetDescendants()) do
		if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
			v.Enabled = false;
		end
	end
	for i,v in pairs(L_2:GetDescendants()) do
		if v.ClassName == "Sky" then
			v:Destroy();
		end
	end
	for i,v in pairs(L_5:GetDescendants()) do
		if v.ClassName == "Shirt" or v.ClassName == "Pants" or v.ClassName == "Accessory" then
			v:Destroy();
		end
	end
	function change(v)
		pcall(function()
			if v.ClassName == "Shirt" or v.ClassName == "Pants" or v.ClassName == "Accessory" then
				v:Destroy();
			end
			if v.ClassName == "Sky" then
				v:Destroy();
			end
			if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
				v.Enabled = false;
			end
			if v.ClassName == "Part" or v.ClassName == "SpawnLocation" or v.ClassName == "WedgePart" or v.ClassName == "Terrain" or v.ClassName == "MeshPart" then
				v.Material = "Plastic";v.Reflectance = 0;v.CastShadow = false;
			elseif v.ClassName == "Decal" or v:IsA("Texture") then
				v.Texture = 0;v.Transparency = 1;
			elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
				v.LightInfluence = 0;v.Texture = 0;v.Lifetime = NumberRange.new(0);
			elseif v:IsA("Explosion") then
				v.BlastPressure = 0;v.BlastRadius = 0;
			elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
				v.Enabled = false;
			elseif v:IsA("MeshPart") then
				v.Material = "Plastic";v.Reflectance = 0;v.TextureId = 0;v.CastShadow = false;v.RenderFidelity = Enum.RenderFidelity.Performance;
			elseif v.ClassName == "SpecialMesh" then
				v.TextureId = "rbxassetid://0";
			elseif v.ClassName == "Shirt" or v.ClassName == "Pants" or v.ClassName == "Accessory" then
				v:Destroy();
			end
		end)
	end
	game.DescendantAdded:Connect(function(v)
		pcall(function()
			change(v)
		end)
	end)
end)

local allSwordInInventory = {}
for i, v in pairs(game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventoryWeapons")) do
    if type(v) == "table" and v.Type == "Sword" then
        table.insert(allSwordInInventory, v.Name)
    end
end

local fightingStyle = GetFightingStyle("Sword")
if fightingStyle ~= "Not Have" then
    table.insert(allSwordInInventory, fightingStyle)
end

function GetRarityWeaponSword(Rare,tye,tye2)
	if Rare == "Common" then
		RareNumber = 0
	elseif Rare == "Uncommon" then
		RareNumber = 1
	elseif Rare == "Rare" then
		RareNumber = 2
	elseif Rare == "Legendary" then
		RareNumber = 3
	elseif Rare == "Mythical" then
		RareNumber = 4
	else
		return "Worng InPut"
	end
	local ReturnTable = {}
	for i,v in pairs(_F("getInventory")) do
		if type(v) == "table" then
			if v.Rarity and v.Type == "Sword" then
				if (not tye and tonumber(v.Rarity) == RareNumber) or (tye and tonumber(v.Rarity) >= RareNumber) then
					if tye2 then
						table.insert(ReturnTable,v.Name .." " ..v.Mastery)
					else
						table.insert(ReturnTable,v.Name)
					end
				end
			end
		end
	end
	return ReturnTable
end

PointStats = 1

local function tablefound(tab, name)
	if not name then return false end
	for i, v in pairs(tab) do
		if tostring(v) == name then
			return true
		end
	end
	return false
end

local SkillZT = (getgenv().Configs.Main.Skill_Z_Time or 0.1)
local SkillXT = (getgenv().Configs.Main.Skill_X_Time or 0.1)
local SkillCT = (getgenv().Configs.Main.Skill_C_Time or 0.1)
local SkillVT = (getgenv().Configs.Main.Skill_V_Time or 0.1)

Boss = {}

for i, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
	if string.find(v.Name, "Boss") then
		if v.Name == "Ice Admiral [Lv. 700] [Boss]" or v.Name == "rip_indra [Lv. 1500] [Boss]" then else
			table.insert(Boss, v.Name)
		end
	end
end
for i, v in pairs(game.workspace.Enemies:GetChildren()) do
	if string.find(v.Name, "Boss") then
		if v.Name == "Ice Admiral [Lv. 700] [Boss]" or v.Name == "rip_indra [Lv. 1500] [Boss]" then else
			table.insert(Boss, v.Name)
		end
	end
end

PlayerName = {}
for i,v in pairs(game.Players:GetChildren()) do
	table.insert(PlayerName ,v.Name)
end

if not isfolder("MZ_Sevice") then
    makefolder("MZ_Sevice")
end
if not isfolder("MZ_Sevice/Luxury") then
    makefolder("MZ_Sevice/Luxury")
end
if not isfolder("MZ_Sevice/Luxury/Macro") then
    makefolder("MZ_Sevice/Luxury/Macro")
end
local AllCombo = {}
local RigLib = require(game:GetService("ReplicatedStorage").CombatFramework.RigLib)
local players = game.GetService(game, "Players")
local circle = Drawing.new("Circle")
local mouse = game.Players.LocalPlayer:GetMouse()
local guiservice = game.GetService(game,"GuiService")
local currentCamera = game.GetService(game, "Workspace").CurrentCamera
circle.NumSides = 100
circle.Thickness = 2
circle.Radius = (50 * 6)
circle.Position = Vector2.new(-circle.Radius,-circle.Radius)

getgenv().Wait = wait

function mysplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end
function AllPlr ()
    local All = {}
    for i,v in next,players:GetChildren() do
        table.insert(All,v.Name)
    end
    return All
end

function FindPlr()
    while (_G["Aimbot method"] == "Fov") and _G["Aimbot"] do wait()
        circle.Position = Vector2.new(mouse.X, mouse.Y + (guiservice.GetGuiInset(guiservice).Y))
        if not _G["Target"] then return _G["Target"] end
        local Character = players[_G["Target"]].Character
        local Plr = players[_G["Target"]]
        for i, v in pairs(players:GetChildren()) do
            pcall(function()
                if v.Character:FindFirstChild('HumanoidRootPart') then
                    local pos = currentCamera.WorldToViewportPoint(currentCamera, v.Character.HumanoidRootPart.Position)
                    local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude
                    if magnitude <= circle.Radius then
                        if magnitude < math.huge then
                            if (v.Character.HumanoidRootPart.Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 1000 then
                                if v.Name ~= game.Players.LocalPlayer.Name then
                                    _G["Target"] = v.Name
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end

pcall(function()
    getgenv().ESP=loadstring(game:HttpGet("https://androssy.net/TrashXenon/ESP.lua"))();
end);

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/NightsTimeZ/mat/main/Ui/InterfaceManager.lua"))()

local Options = Fluent.Options

local Window = Fluent:CreateWindow({
	Title = "Luxury - V2",
	SubTitle = "Written by Switch Hub",
	TabWidth = 160,
	Size = UDim2.fromOffset(480, 360),
	Acrylic = true,
	Theme = "Royx",
	MinimizeKey = Enum.KeyCode.RightControl
})

-- [[ Create UI ]]

local tabDetails = {
    { Name = "Main Farm", Icon = "" },
    { Name = "Main Settings", Icon = "" },
    { Name = "Stats", Icon = "" },
    { Name = "Automatics", Icon = "" },
    { Name = "V4 Race", Icon = "" },
    { Name = "Sea", Icon = "" },
    { Name = "Pvp", Icon = "" },
    { Name = "Teleport", Icon = "" },
    { Name = "Dungeons", Icon = "" },
    { Name = "Fruits", Icon = "" },
    { Name = "Shop", Icon = "" },
    { Name = "Misc", Icon = "" },
    { Name = "Settings", Icon = "settings" }
}

local Tabs = {}
for _, tab in ipairs(tabDetails) do
    Tabs[tab.Name] = Window:AddTab({ Title = tab.Name, Icon = tab.Icon })
end

local UiInitialize = {
    ["Main Farm"] = {
		{
            Type = "Paragraph",
            Title = "⚔️ Auto Farm ⚔️",
            Content = "Settings And Farm"
        },
        {
            Type = "Toggle",
            Keys = "Farming",
            Title = "Auto Farm Level",
            Default = getgenv().Configs.Main.FarmLevel
        },
        {
            Type = "Toggle",
            Keys = "AcceptQuest",
            Title = "Accept Quest",
            Default = getgenv().Configs.Main.Accept_Quest
        },
        {
            Type = "Toggle",
            Keys = "Double_Quest",
            Title = "Double & Boss Quest",
            Default = getgenv().Configs.Main.BossAndDoubleQuest
        },
        {
            Type = "Toggle",
            Keys = "Skip_Farm",
            Title = "Skip Farm [Lv. 20 - 300]",
            Default = getgenv().Configs.Main.Skip_Level_Farm
        },
		--
		{
            Type = "Paragraph",
            Title = "⚡ Auto Farm ⚡",
            Content = "Auto World & Specials"
        },
		{
			Type = "Toggle",
			Keys = "AutoNewWorld",
			Title = "Auto Second Sea",
			Default = getgenv().Configs.Main.Auto_New_World
		},
		--
		{
			Type = "Toggle",
			Keys = "AutoFactory",
			Title = "Auto Attack Factory",
			Default = getgenv().Configs.Main.Auto_Factory
		},
		{
			Type = "Toggle",
			Keys = "AutoThirdSea",
			Title = "Auto Third Sea",
			Default = getgenv().Configs.Main.Auto_Third_Sea
		},
		{
            Type = "Paragraph",
            Title = "⚙️ Settings Auto Farm ⚙️",
            Content = "Settings Weapons & Fast Attack."
        },
		{
            Type = "Dropdown",
            Keys = "SelectFastAttackMode",
            Title = "Fast Attack Type",
            Values = {"Normal", "Fast", "Super Fast"},
            Multi = false,
            Default = 3,
            OnChanged = function(starts)
                SelectFastAttackMode = starts
                getgenv().Configs.Settings.FastAttackMode = starts
                ChangeModeFastAttack(SelectFastAttackMode)
                SaveManager:Save()
            end
        },
		{
            Type = "Dropdown",
            Keys = "SelectedWeapon",
            Title = "Selected Weapon",
            Values = Weapon,
            Multi = false,
            Default = 1,
            OnChanged = function(starts)
                SelectToolWeapon = starts
				getgenv().Configs.Settings.Select_Weapons = starts
				SaveManager:Save()
            end
        },
		{
            Type = "Button",
            Title = "Refresh Weapon",
            Callback = function()
                local Weapon = {}
                for _, v in ipairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v:IsA("Tool") then
                        table.insert(Weapon, v.Name) -- Assuming you want to collect names
                    end
                end
                for _, v in ipairs(game.Players.LocalPlayer.Character:GetChildren()) do
                    if v:IsA("Tool") then
                        table.insert(Weapon, v.Name) -- Same assumption as above
                    end
                end
                Options.SelectedWeapon:SetValues(Weapon) -- Update the dropdown
            end
        },
		{
			Type = "Toggle",
			Keys = "AutoFastmodeNa",
			Title = "Auto Fast Mode",
			Default = getgenv().Configs.Main.Auto_Fast_mode
		},
		{
			Type = "Toggle",
			Keys = "Fast_Attack",
			Title = "Fast Attack",
			Default = true,
			OnChanged = function(starts)
                StartFastAttack = starts
                getgenv().Configs.Settings.Fast_Attack = starts
                SaveManager:Save()
			end
		},
		{
			Type = "Toggle",
			Keys = "Auto_Haki",
			Title = "Auto Haki",
			Default = true,
		},
		{
			Type = "Toggle",
			Keys = "EnabledKen",
			Title = "Auto Ken",
			Default = getgenv().Configs.Main.Auto_Haki_Ken,
		},
		{
			Type = "Toggle",
			Keys = "Notify",
			Title = "Off Notifications & Damage",
			Default = false,
			OnChanged = function(starts)
				game:GetService("ReplicatedStorage").Assets.GUI:WaitForChild("DamageCounter").Enabled = not starts
				game:GetService("Players")["LocalPlayer"].PlayerGui:FindFirstChild("Notifications").Enabled = not starts
				getgenv().Configs.Settings.Disabled_NotifyAndDamage = starts
				SaveManager:Save()
			end
		},
		{
            Type = "Paragraph",
            Title = "🧑 Auto Farm Monster 🧒",
            Content = "Auto Farm Monster Aura."
        },
		{
			Type = "Toggle",
			Keys = "Auto_KillAllMonster",
			Title = "Auto Kill All Monster",
			Default = false,
		},
		{
			Type = "Toggle",
			Keys = "AutoFarmMobAura",
			Title = "Auto Farm Monster Aura",
			Default = false,
		},
        {
			Type = "Paragraph",
			Title = "✊ Auto Farm ✊",
			Content = "Auto Fighting Style V1 & V2"
		},
        {
			Type = "Toggle",
			Keys = "Auto_Superhuman",
			Title = "Auto Superhuman",
			Default = getgenv().Configs.Main.FightingStyle.Auto_Superhuman,
		},
        {
			Type = "Toggle",
			Keys = "AutoSharkmanKarate",
			Title = "Auto Sharkman Karate",
			Default = getgenv().Configs.Main.FightingStyle.Auto_Sharkman_Karate,
		},
        {
			Type = "Toggle",
			Keys = "AutoDeathStep",
			Title = "Auto Death Step",
			Default = getgenv().Configs.Main.FightingStyle.Auto_Death_Step,
		},
        {
			Type = "Toggle",
			Keys = "AutoDragonTalon",
			Title = "Auto Dragon Talon",
			Default = getgenv().Configs.Main.FightingStyle.Auto_Dragon_Talon,
		},
        {
			Type = "Toggle",
			Keys = "AutoElectricClaw",
			Title = "Auto Electric Claw",
			Default = getgenv().Configs.Main.FightingStyle.Auto_Electric_Claw,
		},
        {
			Type = "Toggle",
			Keys = "AutoGodhuman",
			Title = "Auto Godhuman",
			Default = getgenv().Configs.Main.FightingStyle.Auto_Godhuman,
		},
        {
			Type = "Paragraph",
            Title = "🗡️ Auto Farm Tabs 🌪️",
            Content = "Auto Buy Sword & Haki."
        },
        {
            Type = "Toggle",
            Keys = "AutoBuyTrueTripleKatana",
            Title = "Auto Buy True Triple Katana",
            Default = false
        },
        {
            Type = "Toggle",
            Keys = "AutoBuyLegendarySword",
            Title = "Auto Buy Legendary Sword",
            Default = false
        },
        {
            Type = "Dropdown",
            Keys = "Dropdown_SelectLegendarySword",
            Title = "Select Legendary Sword To Buy",
            Values = {"Shisui", "Wando", "Saddi"},
            Multi = true,
            Default = getgenv().Configs.Main.SelectLegendarySword,
            OnChanged = function(starts)
                getgenv().Configs.Main.SelectLegendarySword = starts
                SaveManager:Save()
            end
        },
        {
            Type = "Toggle",
            Keys = "Toggle_LockLegendarySwordToBuy",
            Title = "Lock Legendary Sword To Buy",
            Default = false,
            OnChanged = function(starts)
                getgenv().Configs.Main.LockLegendarySwordToBuy = starts
                SaveManager:Save()
            end
        },
        {
            Type = "Dropdown",
            Keys = "Dropdown_SelectHakiColor",
            Title = "Select Haki Color To Buy",
            Values = {
                "Pure Red", "Bright Yellow", "Yellow Sunshine", "Blue Jeans", "Orange Soda",
                "Winter Sky", "Fiery Rose", "Green Lizard", "Slimy Green", "Rainbow Saviour",
                "Heat Wave", "Absolute Zero", "Plump Purple", "Snow White"
            },
            Multi = true,
            Default = getgenv().Configs.Main.SelectHakiColor,
            OnChanged = function(starts)
                getgenv().Configs.Main.SelectHakiColor = starts
                SaveManager:Save()
            end
        },
        {
            Type = "Toggle",
            Keys = "AutoBuyEnhancement",
            Title = "Auto Buy Enhancement",
            Default = false
        },
        {
            Type = "Toggle",
            Keys = "Toggle_LockHakiColorToBuy",
            Title = "Lock Haki Color To Buy",
            Default = false,
            OnChanged = function(starts)
                getgenv().Configs.Main.LockHakiColorToBuy = starts
                SaveManager:Save()
            end
        },
        {
            Type = "Paragraph",
            Title = "📚 Auto Farm Tabs 📚",
            Content = "Auto Find Material."
        },
        {
            Type = "Dropdown",
            Keys = "SelectMaterial",
            Title = "Select Material",
            Values = AllMaterial,
            Multi = false,
            Default = 1,
            OnChanged = function(selection)
                SelectMaterial = selection
                getgenv().Configs.Main.SelectMaterial = selection
                SaveManager:Save()
            end
        },
        {
            Type = "Toggle",
            Keys = "AutoFarmMaterial",
            Title = "Auto Farm Material",
            Default = false
        },
        {
            Type = "Paragraph",
            Title = "🍇 Auto Farm Tabs 🍔",
            Content = "Auto Farm Mastery.",
        },
        {
            Type = "Toggle",
            Keys = "Auto_Farm_Mastery_Devil_Fruit",
            Title = "Auto Farm Mastery Devil Fruit",
            Default = getgenv().Configs.Main.Auto_Farm_Devil_Fruit_Mastery,
            OnChanged = function(starts)
                FarmMasteryDevilFruit = starts
                getgenv().Configs.Main.Auto_Farm_Devil_Fruit_Mastery = starts
                SaveManager:Save()
                spawn(function()
                    while task.wait() do
                        if FarmMasteryDevilFruit then
                            xpcall(function()
                                CheckQuestMasteryFarm()
                                AutoFarmMasteryDevilFruit()
                            end, function(x)
                                print("Auto Farm Mastery Devil Fruit Error : "..x)
                            end)
                        else
                            break;
                        end
                    end
                end)
            end
        },
        {
            Type = "Toggle",
            Keys = "Auto_Farm_Mastery_Gun",
            Title = "Auto Farm Mastery Gun",
            Default = getgenv().Configs.Main.Auto_Farm_Gun_Mastery,
            OnChanged = function(starts)
                FarmMasteryGun = starts
                getgenv().Configs.Main.Auto_Farm_Gun_Mastery = starts
                SaveManager:Save()
                spawn(function()
                    while task.wait() do
                        if FarmMasteryGun then
                            xpcall(function()
                                CheckQuestMasteryFarm()
                                AutoFarmMasteryGun()
                            end, function(x)
                                print("Auto Farm Mastery Gun Error : "..x)
                            end)
                        else
                            if tween then tween:Cancel() end
                            break;
                        end
                    end
                end)
            end
        },
        {
            Type = "Dropdown",
            Keys = "SelectSwordDropdown",
            Title = "Select Sword List",
            Values = allSwordInInventory,
            Multi = false,
            Default = SelectWeaponSwordList,
            OnChanged = function(starts)
                SelectWeaponSwordList = starts
                getgenv().Configs.Main.Select_Sword_List = starts
                SaveManager:Save()
            end
        },
        {
            Type = "Button",
            Title = "Refresh Weapon",
            Callback = function()
                local AllSwordInInventory = {}
                for i,v in pairs(game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventoryWeapons")) do
                    if type(v) == "table" then
                        if v.Type == "Sword" then
                            table.insert(AllSwordInInventory, v.Name)
                        end
                    end
                end
                if GetFightingStyle("Sword") ~= "Not Have" then
                    table.insert(AllSwordInInventory, GetFightingStyle("Sword"))
                end
                Options.SelectSwordDropdown:SetValues(AllSwordInInventory) -- Update the dropdown
            end
        },
        {
            Type = "Toggle",
            Keys = "AutoFarmMasterySword",
            Title = "Auto Farm Sword Mastery",
            Default = false
        },
        {
            Type = "Dropdown",
            Keys = "RarityDropdown",
            Title = "Select Rarity",
            Values = {"Common", "Uncommon", "Rare", "Legendary", "Mythical"},
            Multi = true,
            Default = (getgenv().Configs.Main.Select_Rarity_Sword_List or {}),
            OnChanged = function(starts)
                SelectRaritySwordList = starts
                getgenv().Configs.Main.Select_Rarity_Sword_List = starts
                SelectWeaponSwordList = {}
                for i,v in pairs(SelectRaritySwordList) do
                    if type(GetRarityWeaponSword(v)) == "table" then
                        for i2,v2 in pairs(GetRarityWeaponSword(v)) do
                            table.insert(SelectWeaponSwordList,v2)
                        end
                    end
                end
                getgenv().Configs.Main.Select_Sword_List = SelectWeaponSwordList
                SaveManager:Save()
            end
        },       
        {
            Type = "Slider",
            Keys = "MasterySlider",
            Title = "Select Mastery Sword List",
            Default = 15,
            Min = 0,
            Max = getgenv().Configs.Main.Select_Mastery_Sword_List,
            Rounding = 1,
            Callback = function(starts)
                MasteryWeaponList = starts
                getgenv().Configs.Main.Select_Mastery_Sword_List = starts
                SaveManager:Save()
            end
        },
        {
            Type = "Slider",
            Keys = "HealthSlider",
            Title = "Health [Default : 15 - 20 ]",
            Default = 15,
            Min = 0,
            Max = 100,
            Rounding = 1,
            Callback = function(starts)
                PersenHealth = starts
            end
        }, 
        {
            Type = "Paragraph",
            Title = "⚙️ Auto Mastery Settings ⚙️",
            Content = "Auto Farm Mastery Skill Setting."
        },
        {
            Type = "Toggle",
            Keys = "ConfixSkillClick",
            Title = "Skill Click",
            Default = false,
            OnChanged = function(starts)
                SkillClick = starts
                getgenv().Configs.Main.Skill_Click = starts
                SaveManager:Save()
            end
        },
        {
            Type = "Toggle",
            Keys = "ConfixSkillZ",
            Title = "Skill Z",
            Default = false,
            OnChanged = function(starts)
                SkillZ = starts
                getgenv().Configs.Main.Skill_Z = starts
                SaveManager:Save()
            end
        },
        {
            Type = "Toggle",
            Keys = "ConfixSkillX",
            Title = "Skill X",
            Default = false,
            OnChanged = function(starts)
                SkillX = starts
                getgenv().Configs.Main.Skill_X = starts
                SaveManager:Save()
            end
        },
        {
            Type = "Toggle",
            Keys = "ConfixSkillC",
            Title = "Skill C",
            Default = false,
            OnChanged = function(starts)
                SkillC = starts
                getgenv().Configs.Main.Skill_C = starts
                SaveManager:Save()
            end
        },
        {
            Type = "Toggle",
            Keys = "ConfixSkillV",
            Title = "Skill V",
            Default = false,
            OnChanged = function(starts)
                SkillV = starts
                getgenv().Configs.Main.Skill_V = starts
                SaveManager:Save()
            end
        },
        {
            Type = "Toggle",
            Keys = "ConfixSkillF",
            Title = "Skill F",
            Default = false,
            OnChanged = function(starts)
                SkillF = starts
                getgenv().Configs.Main.Skill_F = starts
                SaveManager:Save()
            end
        },
        {
            Type = "Slider",
            Keys = "Skill_Z",
            Title = "Skill Z",
            Default = 0.1,
            Min = 0,
            Max = 5,
            Rounding = 1,
            Callback = function(starts)
                if not tonumber(starts) then return end
                SkillZT = starts
                getgenv().Configs.Main.Skill_Z_Time = starts
                SaveManager:Save()
            end
        },
        {
            Type = "Slider",
            Keys = "Skill_X",
            Title = "Skill X",
            Default = 0.1,
            Min = 0,
            Max = 5,
            Rounding = 1,
            Callback = function(starts)
                if not tonumber(starts) then return end
                SkillXT = starts
                getgenv().Configs.Main.Skill_X_Time = starts
                SaveManager:Save()
            end
        },
        {
            Type = "Slider",
            Keys = "Skill_C",
            Title = "Skill C",
            Default = 0.1,
            Min = 0,
            Max = 5,
            Rounding = 1,
            Callback = function(starts)
                if not tonumber(starts) then return end
                SkillCT = starts
                getgenv().Configs.Main.Skill_C_Time = starts
                SaveManager:Save()
            end
        },
        {
            Type = "Slider",
            Keys = "Skill_V",
            Title = "Skill V",
            Default = 0.1,
            Min = 0,
            Max = 5,
            Rounding = 1,
            Callback = function(starts)
                if not tonumber(starts) then return end
                SkillVT = starts
                getgenv().Configs.Main.Skill_V_Time = starts
                SaveManager:Save()
            end
        }        
    },
	["Main Settings"] = {
		{
			Type = "Paragraph",
			Title = "⚙️ Limit Settings ⚙️",
			Content = "Auto Limit & Settings."
		},
		{
			Type = "Slider",
			Keys = "SelectLockLevel",
			Title = "Select Lock Level At",
			Default = getgenv().Configs.Main.Settings.Level.Lock_Level_At or 2550,
			Min = 1,
			Max = 2550,
			Rounding = 1,
			Callback = function(starts)
				SelectLockLevel = starts
			end
		},
        {
			Type = "Toggle",
			Keys = "Start_Level_Lock",
			Title = "Start Lock Level",
			Default = getgenv().Configs.Main.Settings.Start_Level_Lock,
		},
        {
			Type = "Slider",
			Keys = "SelectMastery",
			Title = "Select Lock Mastery",
			Default = getgenv().Configs.Main.Settings.Mastery.Select_Mastery_Lock_At or 600,
			Min = 1,
			Max = 600,
			Rounding = 1,
			Callback = function(starts)
                SelectMastery = starts
                getgenv().Configs.Main.Settings.Mastery.Select_Mastery_Lock_At = starts
                SaveManager:Save()
			end
		},
        {
            Type = "Dropdown",
            Keys = "Select_Weapon_Lock",
            Title = "Select Weapon Lock Mastery",
            Values = Weapon,
            Multi = false,
            Default = 1,
            OnChanged = function(starts)
                SelectWeaponLockMastery = starts
                getgenv().Configs.Main.Settings.Mastery.Weapon_Lock_Master = starts
                SaveManager:Save()
            end
        },
        {
            Type = "Button",
            Title = "Refresh Weapon",
            Callback = function()
                local Weapon = {}
                for _, v in ipairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v:IsA("Tool") then
                        table.insert(Weapon, v.Name) -- Assuming you want to collect names
                    end
                end
                for _, v in ipairs(game.Players.LocalPlayer.Character:GetChildren()) do
                    if v:IsA("Tool") then
                        table.insert(Weapon, v.Name) -- Same assumption as above
                    end
                end
                Options.Select_Weapon_Lock:SetValues(Weapon) -- Update the dropdown
            end
        },
        {
			Type = "Toggle",
			Keys = "Start_Mastery_Lock",
			Title = "Start Lock Mastery",
			Default = getgenv().Configs.Main.Settings.Start_Mastery_Lock,
		},
        {
			Type = "Slider",
			Keys = "SelectBeli",
			Title = "Select Lock Beli",
			Default = getgenv().Configs.Main.Settings.Beli.Select_Beli_Lock_At or 10000000,
			Min = 1,
			Max = 200000000,
			Rounding = 1,
			Callback = function(starts)
                SelectBeli = starts
                getgenv().Configs.Main.Settings.Beli.Select_Beli_Lock_At = starts
                SaveManager:Save()
            end
		},
        {
			Type = "Toggle",
			Keys = "Start_Beli_Lock",
			Title = "Start Lock Beli",
			Default = getgenv().Configs.Main.Settings.Beli.Start_Beli_Lock,
		},
        {
			Type = "Slider",
			Keys = "SelectFragment",
			Title = "Select Lock Fragments",
			Default = getgenv().Configs.Main.Settings.Fragment.Select_Fragment_Lock_At or 100000,
			Min = 1,
			Max = 100000,
			Rounding = 1,
			Callback = function(starts)
                SelectFragments = starts
                getgenv().Configs.Main.Settings.Fragment.Select_Fragment_Lock_At = starts
                SaveManager:Save()
            end
		},
        {
			Type = "Toggle",
			Keys = "Start_Fragment_Lock",
			Title = "Start Lock Fragment",
			Default = getgenv().Configs.Main.Settings.Fragment.Start_Fragment_Lock,
		},
        {
			Type = "Paragraph",
			Title = "📖 Code 📖",
			Content = "Auto Redeem & Settings Code."
		},
        {
			Type = "Slider",
			Keys = "Select_Level_Redeem",
			Title = "Select Redeem Level",
			Default = getgenv().Configs.Main.Settings.Code.Select_Level_Redeem or MaxLevel,
			Min = 1,
			Max = 100000,
			Rounding = 1,
			Callback = function(starts)
                SelectRedeemx2 = starts
                getgenv().Configs.Main.Settings.Code.Select_Level_Redeem = starts
                SaveManager:Save()
            end
		},
        {
			Type = "Toggle",
			Keys = "RedeemAll",
			Title = "Auto Redeem Code x2",
			Default = getgenv().Configs.Main.Settings.Code.Auto_Redeem_Code,
		},
	},
    ["Stats"] = {
        {
			Type = "Paragraph",
			Title = "📊 Auto Stats 📊",
			Content = "Auto Upgrade My Stats Huhu."
		},
        {
			Type = "Toggle",
			Keys = "AutoStatkaitan",
			Title = "Auto Stats kaitan",
			Default = getgenv().Configs.Stats.Kaitun,
		},
        {
			Type = "Toggle",
			Keys = "Melee",
			Title = "Auto Melee",
			Default = false,
            OnChanged = function(starts)
                melee = starts
                getgenv().Configs.Stats.Melee = starts
                SaveManager:Save()
            end
		},
        {
			Type = "Toggle",
			Keys = "Defense",
			Title = "Auto Defense",
			Default = false,
            OnChanged = function(starts)
                defense = starts
                getgenv().Configs.Stats.Defense = starts
                SaveManager:Save()
            end
		},
        {
			Type = "Toggle",
			Keys = "Sword",
			Title = "Auto Sword",
			Default = false,
            OnChanged = function(starts)
                sword = starts
                getgenv().Configs.Stats.Sword = starts
                SaveManager:Save()
            end
		},
        {
			Type = "Toggle",
			Keys = "Gun",
			Title = "Auto Gun",
			Default = false,
            OnChanged = function(starts)
                gun = starts
                getgenv().Configs.Stats.Gun = starts
                SaveManager:Save()
            end
		},
        {
			Type = "Toggle",
			Keys = "DevilFruit",
			Title = "Auto Devil Fruits",
			Default = false,
            OnChanged = function(starts)
                demonfruit = starts
                getgenv().Configs.Stats.DevilFruit = starts
                SaveManager:Save()
            end
		},
        {
			Type = "Slider",
			Keys = "PointStats",
			Title = "Point Select",
			Default = PointStats or 1,
			Min = 1,
			Max = 100,
			Rounding = 1,
			Callback = function(starts)
                PointStats = starts
            end
		}
    },
    ["Automatics"] = {
        {
            Type = "Paragraph",
            Title = "👑 Automatics Items 👑",
            Content = "Auto Boss Farming."
        },        
        {
            Type = "Dropdown",
            Keys = "Selected_Bosses",
            Title = "Select Boss",
            Values = Boss,
            Multi = false,
            Default = 1,
            OnChanged = function(starts)
                SelectBoss = starts
                CheckQuestBoss()
            end
        },
        {
            Type = "Button",
            Title = "Refresh Boss",
            Callback = function()
                local Boss = {}
                for i, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                    if string.find(v.Name, "Boss") then
                        if v.Name == "Ice Admiral [Lv. 700] [Boss]" or v.Name == "rip_indra [Lv. 1500] [Boss]" then else
                            table.insert(Boss,v.Name)
                        end
                    end
                end
                for i, v in pairs(game.workspace.Enemies:GetChildren()) do
                    if string.find(v.Name, "Boss") then
                        if v.Name == "Ice Admiral [Lv. 700] [Boss]" or v.Name == "rip_indra [Lv. 1500] [Boss]" then else
                            table.insert(Boss,v.Name)
                        end
                    end
                end
                Options.Selected_Bosses:SetValues(Boss) -- Update the dropdown
            end
        },
        {
            Type = "Toggle",
            Keys = "FarmAllBoss",
            Title = "Auto Farm All Boss",
            Default = false
        },
        {
            Type = "Toggle",
            Keys = "FarmBoss",
            Title = "Auto Farm Boss",
            Default = false
        },
        {
            Type = "Toggle",
            Keys = "FarmBossHop",
            Title = "Auto Farm Boss Hop",
            Default = false
        },
        {
            Type = "Toggle",
            Keys = "Auto_Quest_Boss",
            Title = "Auto Quest Boss",
            Default = false
        },
        {
            Type = "Paragraph",
            Title = "📦 Automatics Items 📦",
            Content = "Chest Farm & Settings.",
        },
        {
            Type = "Toggle",
            Keys = "Auto_Chests",
            Title = "Auto Farm Chest",
            Default = false
        },
        {
            Type = "Toggle",
            Keys = "Stop_At_First",
            Title = "Stop At First of darkness",
            Default = false
        },
        {
            Type = "Toggle",
            Keys = "Kill_At_First",
            Title = "Kill At First of darkness",
            Default = false
        },
        {
            Type = "Paragraph",
            Title = "🗡️ Automatics Items ⚡",
            Content = "World 1 Quest Farming.",
        },
        {
            Type = "Toggle",
            Keys = "AutoOpenSaberRoom",
            Title = "Auto Saber",
            Description = "Auto Saber have teleport to find saber in another server.",
            Default = false
        },
        {
            Type = "Toggle",
            Keys = "PoleV1",
            Title = "Auto Pole v1",
            Default = false
        },
        {
            Type = "Toggle",
            Keys = "PoleV1Hop",
            Title = "Auto Pole v1 #Hop",
            Description = "Auto Pole v1 and teleport to find boss in another server.",
            Default = false
        },        
    },
    ["Sea"] = {
        {
            Type = "Paragraph",
            Title = "🦈 Event Tabs 🏝️",
            Content = "Auto Sea Materials & Items.",
        },
        {
            Type = "Toggle",
            Keys = "FarmTerror",
            Title = "Auto Terror Shark",
            Default = false
        },
        {
            Type = "Toggle",
            Keys = "TerrorsharkHop",
            Title = "Auto Terror Shark Hop",
            Default = false
        },
        {
            Type = "Toggle",
            Keys = "Auto_Farm_Boat",
            Title = "Auto Farm Boat",
            Default = false
        },
        {
            Type = "Toggle",
            Keys = "Auto_Shark",
            Title = "Auto Kill Shark",
            Default = false
        },
        {
            Type = "Toggle",
            Keys = "Auto_Leviathan",
            Title = "Auto Kill Leviathan",
            Default = false
        },
        {
            Type = "Toggle",
            Keys = "Auto_Frozen_Dimension",
            Title = "Auto Frozen Dimension",
            Default = false
        },
        {
            Type = "Toggle",
            Keys = "SeaBeast_Ship",
            Title = "Auto SeaBeast & Ship",
            Default = false
        },
        {
            Type = "Paragraph",
            Title = "🌊 Event Tabs 🦊",
            Content = "Auto Rough Sea and Events.",
        },
        {
            Type = "Toggle",
            Keys = "AutoTradeEmber",
            Title = "Auto Fire And Trade Ember",
            Default = false
        },
        {
            Type = "Dropdown",
            Keys = "Selected_Sea_Level",
            Title = "Selected Sea Level",
            Values = {"1","2","3","4","5","6"},
            Multi = false,
            Default = 6,
            OnChanged = function(starts)
                SelectSeaLvl = tonumber(starts)
            end
        },
        {
            Type = "Toggle",
            Keys = "Rough_Seas",
            Title = "Auto Rough Sea",
            Default = false
        },        
    },
    ["Pvp"] = {
        {
            Type = "Paragraph",
            Title = "👤 Players 👤",
            Content = "Settings Players & Target.",
        },
        {
            Type = "Dropdown",
            Keys = "Selected_Players",
            Title = "Selected Players",
            Values = PlayerName,
            Multi = false,
            Default = 1,
            OnChanged = function(starts)
                SelectedKillPlayer = starts
            end
        },
        {
            Type = "Toggle",
            Keys = "Spectate",
            Title = "Spectate Players",
            Default = false
        },
        {
            Type = "Toggle",
            Keys = "TeleportPlayers",
            Title = "Teleport Players",
            Default = false
        },    
        {
            Type = "Paragraph",
            Title = "⚔️ PVP Scripts By Besty 💥",
            Content = "CREATE THIS BY MAZI SERVICE..",
        },
        {
            Type = "Toggle",
            Keys = "ESP_Players",
            Title = "ESP Players",
            Default = false,
            OnChanged = function(a)
                getgenv().ESP:Toggle(a)
            end
        },
        {
            Type = "Toggle",
            Keys = "AimbotScripts",
            Title = "Aimbot",
            Default = false
        },
        {
            Type = "Dropdown",
            Keys = "SelectPlayers",
            Title = "Select Players",
            Values = AllPlr(),
            Multi = false,
            Default = players.LocalPlayer.Name,
            OnChanged = function(starts)
                _G["Target"] = starts
            end
        },
        {
            Type = "Paragraph",
            Title = "⚔️ Settings Aimbot Scripts By Besty 💥",
            Content = "CREATE THIS BY MAZI SERVICE..",
        },
        {
            Type = "Dropdown",
            Keys = "AimbotMethod",
            Title = "Aimbot Method",
            Values = {"Fov","Select"},
            Multi = false,
            Default = 1,
            OnChanged = function(starts)
                _G["Aimbot method"] = starts
                circle.Visible = starts == "Fov"
                spawn(FindPlr)
            end
        },
        {
            Type = "Slider",
            Keys = "CircleRadiusSize",
            Title = "Circle Radius Size",
            Default = 50,
            Min = 0,
            Max = 500,
            Rounding = 1,
            Callback = function(Size)
                circle.Radius = (Size * 6)
            end
        },
        {
            Type = "Colorpicker",
            Keys = "CircleColor",
            Title = "Circle Color",
            Default = Color3.fromRGB(255, 255, 255),
            OnChanged = function(Color)
                circle.Color = Color
            end
        },
        {
            Type = "Paragraph",
            Title = "⚔️ Marco Scripts By Besty 💥",
            Content = "CREATE THIS BY MAZI SERVICE..",
        },
        {
            Type = "Dropdown",
            Keys = "MacroFile",
            Title = "Macro File",
            Values = {},
            Multi = true,
            OnChanged = function(starts)
                MacroFiles = starts
            end
        },            
    }
}

for tabName, elements in pairs(UiInitialize) do
    local currentTab = Tabs[tabName] 
    for _, element in ipairs(elements) do
        if element.Type == "Toggle" then
            local toggle = currentTab:AddToggle(element.Keys,{Title = element.Title,Description = element.Description, Default = element.Default})
            if element.OnChanged then
                toggle:OnChanged(element.OnChanged)
            end    
        elseif element.Type == "Paragraph" then
            currentTab:AddParagraph({Title = element.Title, Content = element.Content})
        elseif element.Type == "Dropdown" then
            local dropdown = currentTab:AddDropdown(element.Keys,{
                Title = element.Title,
                Values = element.Values,
                Multi = element.Multi,
                Default = element.Default
            })
            if element.OnChanged then
                dropdown:OnChanged(element.OnChanged)
            end
        elseif element.Type == "Button" then
            currentTab:AddButton({
                Title = element.Title,
                Description = element.Description,
                Callback = element.Callback
            })
        elseif element.Type == "Slider" then
            currentTab:AddSlider(element.Keys,{
                Title = element.Title,
                Default = element.Default,
                Min = element.Min,
                Max = element.Max,
                Rounding = element.Rounding,
                Callback = element.Callback
            })
        elseif element.Type == "Colorpicker" then
            Colorpick =  currentTab:AddColorpicker(element.Keys,{Title = element.Title, Default = element.Default})
            if element.OnChanged then
                Colorpick:OnChanged(element.OnChanged)
            end
        end
    end
end

CheckQuestBoss()

for i,v in next ,listfiles("MZ_Sevice/Luxury/Macro") do
    local FileName = v:gsub("MZ_Sevice/Luxury/Macro\\","")
    Options.MacroFile:SetValues(FileName)
	Tabs["Pvp"]:AddKeybind("Keybind", {
        Title = "Key Bind".. v,
        Default = "E", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

        Callback = function(f)
            print(f)
        end,

    })

    game:GetService("UserInputService").InputBegan:Connect(function(input, typing)
        if input.KeyCode == Enum.KeyCode.E and not typing and table.find(MacroFiles,FileName) then
            local Data = game.HttpService:JSONDecode(readfile("MZ_Sevice/Luxury/Macro/" .. FileName))
            for i,v in next,Data.Combo do
                local Func = v[1]
                local args = {table.unpack(v)}
                table.remove(args,1)
                if Func == "Equip" or Func == "Wait" or Func == "Attack" then
                    getgenv()[Func](unpack(args))
                else
                    getfenv()[Func](unpack(args))
                end
            end
        end
    end)
end

Tabs["Settings"]:AddParagraph({Title = "Server",Content = "Can Hop Rejoin"})

Tabs["Settings"]:AddButton({
	Title = "Rejoin Server",
	Description = "Join This Server Again",
	Callback = function()
		Window:Dialog({
			Title = "Title",
			Content = "This is a dialog",
			Buttons = {
				{
					Title = "Confirm",
					Callback = function()
						ServerFunc:Rejoin()
					end
				},
				{
					Title = "Cancel",
					Callback = function()
						print("Cancelled the dialog.")
					end
				}
			}
		})
	end
})


SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("Luxury Scripts")
SaveManager:SetFolder("Luxury Scripts/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs["Settings"])
SaveManager:BuildConfigSection(Tabs["Settings"])

Window:SelectTab(1)

Fluent:Notify({
	Title = "Luxury Hubs",
	Content = "The script has been loaded.",
	Duration = 8
})

SaveManager:LoadAutoloadConfig()

task.wait(2)

-- end
Options.AimbotScripts:OnChanged(function(starts)
	circle.Visible = starts
	_G["Aimbot"] = starts
	spawn(FindPlr)
end)

local mtaimskill
mtaimskill = hookmetamethod(game,"__namecall",function(self,...)
    local args = {...}
    local method = getnamecallmethod()
    if _G["Aimbot"] then
		if tostring(method) == "FireServer" then
			if tostring(self) == "RemoteEvent" then
				if tostring(args[1]) ~= "true" and tostring(args[1]) ~= "false" then
					if _G["Target"] then
						args[1] = players[_G["Target"]].Character.HumanoidRootPart.Position or args[1]
						return mtaimskill(self,unpack(args))
					end
				end
            end
        end
    end
    return mtaimskill(self,...)
end)
local mtaimgun
mtaimgun = hookfunction(Instance.new("RemoteFunction").InvokeServer, function(self, ...)
    local args = {...}
    if _G["Aimbot"] then
		if _G["Target"]  ~= nil and _G["Aimbot"] then
			if tostring(self) == "RemoteFunctionShoot" then
				args[1] = players[_G["Target"]].Character.HumanoidRootPart.Position or args[1]
				return mtaimgun(self,unpack(args))
			end
        end
    end
    return mtaimgun(self,...)
end)

Options.Spectate:OnChanged(function(starts)
	if SelectedKillPlayer ~= "nil" then
		SpectatePlayers = starts
		local plr2 = game.Players:FindFirstChild(SelectedKillPlayer)
		repeat task.wait(.1)
			game.Workspace.Camera.CameraSubject = plr2.Character.Humanoid
		until SpectatePlayers == false
		game.Workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
	end
end)

Options.TeleportPlayers:OnChanged(function(starts)
	if SelectedKillPlayer ~= "nil" then
		TeleportPlayers = starts
		spawn(function()
			while task.wait() do
				if TeleportPlayers then
					local plr2 = game.Players:FindFirstChild(SelectedKillPlayer)
					TweenPlayers = toTarget(plr2.Character.HumanoidRootPart.Position,plr2.Character.HumanoidRootPart.CFrame)
					if game.Players:FindFirstChild(SelectedKillPlayer) and (game.Players:FindFirstChild(SelectedKillPlayer).Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
						if TweenPlayers then TweenPlayers:Stop() end
						game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = plr2.Character.HumanoidRootPart.CFrame * CFrame.new(1,20,0)
					end
				else
					if TweenPlayers then TweenPlayers:Stop() end
					break;
				end
			end
		end)
	end
end)


Options.AutoOpenSaberRoom:OnChanged(function(starts)
	if OldWorld then
		AutoSaber = starts
		getgenv().Configs.Automatics.Auto_Saber = starts
		SaveManager:Save()
		spawn(function()
			while task.wait() do
				if AutoSaber then
					if game.Players.localPlayer.Data.Level.Value >= 200 then
						if game.Workspace.Map.Jungle.Final.Part.CanCollide == false then
							if game.Workspace.Enemies:FindFirstChild("Saber Expert [Lv. 200] [Boss]") or game:GetService("ReplicatedStorage"):FindFirstChild("Saber Expert [Lv. 200] [Boss]") then
								if game.Workspace.Enemies:FindFirstChild("Saber Expert [Lv. 200] [Boss]") then
									for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
										if v.Name == "Saber Expert [Lv. 200] [Boss]" and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
											repeat task.wait()
												if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
													Farmtween = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame)
												elseif (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
													if Farmtween then Farmtween:Stop() end
													EquipWeapon(SelectToolWeapon)
													Usefastattack = true
													game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
												end
											until not AutoSaber or not v.Parent or v.Humanoid.Health <= 0
											Usefastattack = false
										end
									end
								else
									Questtween = toTarget(CFrame.new(-1405.41956, 29.8519993, 5.62435055).Position,CFrame.new(-1405.41956, 29.8519993, 5.62435055))
									if (CFrame.new(-1405.41956, 29.8519993, 5.62435055).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
										if Questtween then
											Questtween:Stop()
										end
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1405.41956, 29.8519993, 5.62435055, 0.885240912, 3.52892613e-08, 0.465132833, -6.60881128e-09, 1, -6.32913171e-08, -0.465132833, 5.29540891e-08, 0.885240912)
									end
								end
							else
								ServerFunc:TeleportFast()
							end
						elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Relic") or game.Players.LocalPlayer.Character:FindFirstChild("Relic") and game.Players.localPlayer.Data.Level.Value >= 200 then
							EquipWeapon("Relic")
							task.wait(0.5)
							Questtween = toTarget(CFrame.new(-1405.41956, 29.8519993, 5.62435055).Position,CFrame.new(-1405.41956, 29.8519993, 5.62435055))
							if (CFrame.new(-1405.41956, 29.8519993, 5.62435055).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
								if Questtween then
									Questtween:Stop()
								end
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1405.41956, 29.8519993, 5.62435055, 0.885240912, 3.52892613e-08, 0.465132833, -6.60881128e-09, 1, -6.32913171e-08, -0.465132833, 5.29540891e-08, 0.885240912)
							end
						else
							if Workspace.Map.Jungle.QuestPlates.Door.CanCollide == false then
								if game.Workspace.Map.Desert.Burn.Part.CanCollide == false then
									if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","SickMan") == 0 then
										if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon") == 0 then
											if game.Workspace.Enemies:FindFirstChild("Mob Leader [Lv. 120] [Boss]") then
												for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
													if AutoSaber and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and v.Name == "Mob Leader [Lv. 120] [Boss]" then
														repeat
															pcall(function() task.wait()
																if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
																	Farmtween = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame)
																elseif (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
																	if Farmtween then
																		Farmtween:Stop()
																	end
																	EquipWeapon(SelectToolWeapon)
																	Usefastattack = true
																	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
																end
															end)
														until not AutoSaber or not v.Parent or v.Humanoid.Health <= 0
														Usefastattack = false
													end
												end
											else
												Questtween = toTarget(CFrame.new(-2848.59399, 7.4272871, 5342.44043).Position,CFrame.new(-2848.59399, 7.4272871, 5342.44043))
												if (CFrame.new(-2848.59399, 7.4272871, 5342.44043).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
													if Questtween then
														Questtween:Stop()
													end
													game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2848.59399, 7.4272871, 5342.44043, -0.928248107, -8.7248246e-08, 0.371961564, -7.61816636e-08, 1, 4.44474857e-08, -0.371961564, 1.29216433e-08, -0.928248107)
												end
											end
										elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon") == 1 then
											if game.Players.LocalPlayer.Backpack:FindFirstChild("Relic") or game.Players.LocalPlayer.Character:FindFirstChild("Relic") then
												EquipWeapon("Relic")
												task.wait(0.5)
												Questtween = toTarget(CFrame.new(-1405.41956, 29.8519993, 5.62435055).Position,CFrame.new(-1405.41956, 29.8519993, 5.62435055))
												if (CFrame.new(-1405.41956, 29.8519993, 5.62435055).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
													if Questtween then
														Questtween:Stop()
													end
													game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1405.41956, 29.8519993, 5.62435055)
												end
											else
												local args = {
													[1] = "ProQuestProgress",
													[2] = "RichSon"
												}
												game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
											end
										else
											Questtween = toTarget(CFrame.new(-910.979736, 13.7520342, 4078.14624).Position,CFrame.new(-910.979736, 13.7520342, 4078.14624))
											if (CFrame.new(-910.979736, 13.7520342, 4078.14624).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
												if Questtween then
													Questtween:Stop()
												end
												game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-910.979736, 13.7520342, 4078.14624)
												local args = {
													[1] = "ProQuestProgress",
													[2] = "RichSon"
												}
												game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
											end
										end
									else
										if game.Players.LocalPlayer.Backpack:FindFirstChild("Cup") or game.Players.LocalPlayer.Character:FindFirstChild("Cup") then
											game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","GetCup")
											task.wait(0.5)
											EquipWeapon("Cup")
											task.wait(0.5)
											game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","FillCup",game:GetService("Players").LocalPlayer.Character.Cup)
											task.wait(0)
											game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","SickMan")
										else
											game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","GetCup")
										end
									end
								else
									if inmyself("Torch") then
										EquipWeapon("Torch")
										task.wait(0.5)
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1114.87708, 4.9214654, 4349.8501, -0.612586915, -9.68697833e-08, 0.790403247, -1.2634203e-07, 1, 2.4638446e-08, -0.790403247, -8.47679615e-08, -0.612586915)
										task.wait(8.14285714286)
									elseif not inmyself("Torch") then
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1610.00757, 11.5049858, 164.001587, 0.984807551, -0.167722285, -0.0449818149, 0.17364943, 0.951244235, 0.254912198, 3.42372805e-05, -0.258850515, 0.965917408)
									end
								end
							else
								for i,v in pairs(Workspace.Map.Jungle.QuestPlates:GetChildren()) do
									if v:IsA("Model") then task.wait()
										if v.Button.BrickColor ~= BrickColor.new("Camo") then
											repeat task.wait()
												Questtween = toTarget(v.Button.Position,v.Button.CFrame)
												if (v.Button.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
													if Questtween then
														Questtween:Stop()
													end
													game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Button.CFrame
												end
											until not AutoSaber or v.Button.BrickColor == BrickColor.new("Camo")
										end
									end
								end
							end
						end
					end
				else
					if tween then tween:Cancel() end
					break;
				end
			end
		end)
	end
end)

Options.PoleV1:OnChanged(function(starts)
	if OldWorld then
		AutoPole = starts
		getgenv().Configs.Automatics.Auto_PoleV1 = starts
		SaveManager:Save()
		spawn(function()
			while task.wait() do
				if AutoPole then
					if game.Workspace.Enemies:FindFirstChild("Thunder God [Lv. 575] [Boss]") then
						for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
							if AutoPole and v.Name == "Thunder God [Lv. 575] [Boss]" and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
								repeat task.wait()
									if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
										Farmtween = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame)
									elseif (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
										if Farmtween then
											Farmtween:Stop()
										end
										EquipWeapon(SelectToolWeapon)
										Usefastattack = true
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
									end
								until not AutoPole or v.Humanoid.Health <= 0 or not v.Parent
								Usefastattack = false
							end
						end
					else
						Questtween = toTarget(CFrame.new(-7900.66406, 5606.90918, -2267.46436).Position,CFrame.new(-7900.66406, 5606.90918, -2267.46436))
						if (CFrame.new(-7900.66406, 5606.90918, -2267.46436).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
							if Questtween then
								Questtween:Stop()
							end
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-7900.66406, 5606.90918, -2267.46436)
						end
					end
				else
					if tween then tween:Cancel() end
					break
				end
			end
		end)
	end
end)

Options.PoleV1Hop:OnChanged(function(starts)
	if OldWorld then
		AutoPole = starts
		AutoPoleHOP = starts
		getgenv().Configs.Automatics.Auto_PoleV1_Hop = starts
		SaveManager:Save()
		spawn(function()
			while task.wait() do
				if AutoPole or AutoPoleHOP then
					if game:GetService("ReplicatedStorage"):FindFirstChild("Thunder God [Lv. 575] [Boss]") or game.Workspace.Enemies:FindFirstChild("Thunder God [Lv. 575] [Boss]") then
						if game.Workspace.Enemies:FindFirstChild("Thunder God [Lv. 575] [Boss]") then
							for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
								if AutoPole and v.Name == "Thunder God [Lv. 575] [Boss]" and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
									repeat task.wait()
										if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
											Farmtween = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame)
										elseif (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
											if Farmtween then
												Farmtween:Stop()
											end
											EquipWeapon(SelectToolWeapon)
											Usefastattack = true
											game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
										end
									until not AutoPole or v.Humanoid.Health <= 0 or not v.Parent
									Usefastattack = false
								end
							end
						else
							Questtween = toTarget(CFrame.new(-7900.66406, 5606.90918, -2267.46436).Position,CFrame.new(-7900.66406, 5606.90918, -2267.46436))
							if (CFrame.new(-7900.66406, 5606.90918, -2267.46436).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
								if Questtween then
									Questtween:Stop()
								end
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-7900.66406, 5606.90918, -2267.46436)
							end
						end
					elseif AutoPoleHOP then
						ServerFunc:TeleportFast()
					end
				else
					if tween then tween:Cancel() end
					break
				end
			end
		end)
	end
end)

Options.Auto_Chests:OnChanged(function(starts)
	AutoChest = starts
	spawn(function()
		while task.wait() do
			if AutoChest then
				xpcall(function()
					for i,v in pairs(game.Workspace:GetDescendants()) do
						if v.Name:match("Chest") and v:IsA("BasePart") then
							if ChestTarget then ChestTarget:Stop() end
							if StopAtFirstOfDark and inmyself("Fist of Darkness") then
								ChangeToggle(ConfigAutoChest,false)
							end
							repeat task.wait()
								ChestTarget = toTarget(v.CFrame)
								game:service('VirtualInputManager'):SendKeyEvent(true, "W", false, game)
								task.wait(0.123)
								game:service('VirtualInputManager'):SendKeyEvent(false, "W", false, game)
							until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude <= 2 or not AutoChest or not v.Parent

							if not AutoChest then
								if tween then tween:Cancel() end
								break
							end
							for i = 1,2 do
								game:service('VirtualInputManager'):SendKeyEvent(true, "W", false, game)
								task.wait(0.123)
								game:service('VirtualInputManager'):SendKeyEvent(false, "W", false, game)
								task.wait(0.123)
								game:service('VirtualInputManager'):SendKeyEvent(true, 32, false, game)
								task.wait(0.123)
								game:service('VirtualInputManager'):SendKeyEvent(false, 32, false, game)
							end
						end
					end
				end,function(e)
					print("AUTO CHEST ERROR : "..e)
				end)
			else
				if tween then tween:Cancel() end
				break
			end
		end
	end)
end)

Options.Stop_At_First:OnChanged(function(starts)
	StopAtFirstOfDark = starts
end)
Options.Kill_At_First:OnChanged(function(starts)
	KillAtFirstOfDark = starts
end)

local function myboat()
	for i,v in pairs(game:GetService("Workspace").Boats:GetChildren()) do
		if v:FindFirstChild("Owner") then
			if tostring(v.Owner.Value) == game.Players.LocalPlayer.Name then
				return v:FindFirstChildOfClass("VehicleSeat")
			end
		end
	end
	return false
end
local function CheckSeabeast()
	for i,v in pairs(game.Workspace.SeaBeasts:GetChildren()) do
		if v:FindFirstChild("HumanoidRootPart") then
			return v
		end
	end
	return false
end
function CheckPirateBoat()
	for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
		if v:FindFirstChildOfClass("VehicleSeat") and v.Health.Value > 0 and dist(v.VehicleSeat.Position) < 300  then
			return true
		end
	end
	return false
end

IsSameName = function(full,sub)
	return full:lower():find(sub:lower()) or sub:lower():find(full:lower()) or full == sub 
end

Options.FarmTerror:OnChanged(function(starts)
	Terrorshark = starts
	task.spawn(function()
		while Terrorshark do  RunService.Stepped:Wait()
			local itmyboat = myboat()
			for _, v in pairs(itmyboat.Parent:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
			for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end
	end )
	spawn(function()
		while Terrorshark do task.wait()
			if Terrorshark then
				xpcall(function()
					DieWait()
					local itmyboat = myboat()
					if itmyboat and itmyboat.Parent.Humanoid.Value <= 0 then
						game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit = false

					end
					if havemob("Terrorshark [Lv. 2000] [Raid Boss]") and havemob("Terrorshark [Lv. 2000] [Raid Boss]").Humanoid.Health > 0 then
						game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit = false
						game:service('VirtualInputManager'):SendKeyEvent(false, "W", false, game)
						game:service('VirtualInputManager'):SendKeyEvent(false, "D", false, game)
						task.wait(0.5)
						NoClip = true
						local v = havemob("Terrorshark [Lv. 2000] [Raid Boss]") 
						if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0  then  
							repeat task.wait()
								if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude > 150 then 
									totar = toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0,60,1))
								else
									if totar then totar:Stop() end
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,60,1)
									Usefastattack = true
									if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
									end
									if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") and game.Players.LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") then
									else task.wait()
										game:service('VirtualUser'):CaptureController()
										game:service('VirtualUser'):SetKeyDown('0x65')
										task.wait()
										game:service('VirtualUser'):SetKeyUp('0x65')
									end
									EquipWeapon(SelectToolWeapon)
								end
							until not v.Parent or not Terrorshark or v.Humanoid.Health <= 0
							Usefastattack = false
							NoClip = false
						end
					elseif Auto_Shark and CustomFindFirstChild({"Shark [Lv. 2000]","Piranha [Lv. 2000]"}) then
						game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit = false
						NoClip = true
						for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
							if Auto_Shark and v:IsA("Model") and table.find({"Shark [Lv. 2000]","Piranha [Lv. 2000]"},v.Name) and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
								repeat task.wait()
									if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
										Farmtween = toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0,60,1))
									elseif v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
										if Farmtween then Farmtween:Stop() end
										EquipWeapon(SelectToolWeapon)
										Usefastattack = true
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,60,1)
									end
								until not Auto_Shark or not v.Parent or v.Humanoid.Health <= 0
								Usefastattack = false
							end
						end

						NoClip = false
					elseif Auto_Boat and CheckPirateBoat() then 
						game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit = false
						NoClip = true
						for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
							if Auto_Boat and v:FindFirstChildOfClass("VehicleSeat") and v.Health.Value > 0 then
								repeat task.wait()
									local PirateBoatCFrame = v:FindFirstChildOfClass("VehicleSeat").CFrame
									if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - (Vector3.new(PirateBoatCFrame.X,30,PirateBoatCFrame.Z))).magnitude > 150 then
										Farmtween = toTargetNoDie(CFrame.new(PirateBoatCFrame.X,30,PirateBoatCFrame.Z))
									elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - (Vector3.new(PirateBoatCFrame.X,30,PirateBoatCFrame.Z))).magnitude <= 150 then
										if Farmtween then
											Farmtween:Stop()
										end
										task.spawn(function()

											if not LoppSeaDup then 

												LoppSeaDup = true 
												for i,v in ipairs({"Melee","Blox Fruit","Gun"  , "Sword" }) do 
													EquipWeapon(GetFightingStyle(v))
													task.wait(0.2)
													if SkillZ then 
														game:service('VirtualInputManager'):SendKeyEvent(true, "Z", false, game)
														task.wait(0.5)
														game:service('VirtualInputManager'):SendKeyEvent(false, "Z", false, game)
													end
													if SkillX then 
														game:service('VirtualInputManager'):SendKeyEvent(true, "X", false, game)
														task.wait(0.5)
														game:service('VirtualInputManager'):SendKeyEvent(false, "X", false, game)
													end
													if SkillC then 
														game:service('VirtualInputManager'):SendKeyEvent(true, "C", false, game)
														task.wait(0.5)
														game:service('VirtualInputManager'):SendKeyEvent(false, "C", false, game)
													end
													if SkillV then 
														game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
														task.wait(0.5)
														game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
													end
													if SkillF then 
														game:service('VirtualInputManager'):SendKeyEvent(true, "F", false, game)
														task.wait(0.5)
														game:service('VirtualInputManager'):SendKeyEvent(false, "F", false, game)
													end
													task.wait(0.5)
												end
												LoppSeaDup = false
											end
										end)
										PosKillSea = PirateBoatCFrame.Position
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = PirateBoatCFrame * CFrame.new(0,10,1)
										SpamSkillSea = true
									end
								until not Auto_Boat or not v.Parent or not v:FindFirstChildOfClass("VehicleSeat") or v.Health.Value == 0
								SpamSkillSea = false
							end
						end

					elseif (game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit == true) then
						NoClip = false
						Usefastattack = false
						game:service('VirtualInputManager'):SendKeyEvent(true, "W", false, game)
						game:service('VirtualInputManager'):SendKeyEvent(true, "D", false, game)


					elseif itmyboat and (game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit == false) and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-22859.4453125, 41.92976379394531, 33646.625)).Magnitude > 60 then
						NoClip = true
						TweenToSea = toTarget(CFrame.new(-22859.4453125, 41.92976379394531, 33646.625))
						TweenToSea:Wait()
						task.wait(2)
						NoClip = false
					elseif itmyboat and (game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit == false) then
						NoClip = false
						print("??")
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-22859.4453125, 41.92976379394531, 33646.625) * CFrame.new(0,30,0)
						task.wait(0.1)
						itmyboat:Sit(game.Players.LocalPlayer.Character:WaitForChild("Humanoid"))
						task.wait(1)

					elseif not itmyboat then
						NoClip = true
						TweenToSea = toTarget(CFrame.new(-16221.619140625, 9.0863618850708, 432.0790100097656))
						TweenToSea:Wait()
						_F("BuyBoat","PirateGrandBrigade")
						task.wait(0.5)
						NoClip = false
					end
				end,print)
			end
		end
	end)
end)

Options.TerrorsharkHop:OnChanged(function(starts)
	TerrorsharkHop = starts
	spawn(function()
		while task.wait() do
			if TerrorsharkHop then
				if havemob("Terrorshark [Lv. 2000] [Raid Boss]") and havemob("Terrorshark [Lv. 2000] [Raid Boss]").Humanoid.Health > 0 then
					game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit = false
					task.wait(0.5)
					NoClip = true
					local v = havemob("Terrorshark [Lv. 2000] [Raid Boss]") 
					if not v:FindFirstChild("Humanoid") or v.Humanoid.Health <= 0  then return end
					repeat task.wait()
						if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude > 150 then 
							totar = toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0,60,1))
						else
							if totar then totar:Stop() end
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,60,1)
							Usefastattack = true
							if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
							end
							if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") and game.Players.LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") then
							else task.wait()
								game:service('VirtualUser'):CaptureController()
								game:service('VirtualUser'):SetKeyDown('0x65')
								task.wait()
								game:service('VirtualUser'):SetKeyUp('0x65')
							end
							EquipWeapon(SelectToolWeapon)
						end


					until not v.Parent or not Terrorshark or v.Humanoid.Health <= 0 or not v.Parent
					Usefastattack = false
					NoClip = false
				else
					ServerFunc:TeleportFast()
				end
			end
		end
	end)
end)

Options.Auto_Farm_Boat:OnChanged(function(starts)
	Auto_Boat = starts
end)
Options.Auto_Shark:OnChanged(function(starts)
	Auto_Shark = starts
end)

Options.Auto_Leviathan:OnChanged(function(starts)
	Auto_Kill_Leviathan = starts
	task.spawn(function()
		while Auto_Kill_Leviathan do task.wait()
			local wasdmob
			for i,v in pairs(game.Workspace.SeaBeasts:GetChildren()) do
				if Auto_Kill_Leviathan and (IsSameName(v.Name,"Leviathan [Raid Boss]") or IsSameName(v.Name,"Leviathan")) and v:FindFirstChild("HumanoidRootPart") and v.Health.Value > 0 then
					wasdmob = v
					break
				end
			end
			if wasdmob then 
				NoClip = true
				repeat task.wait()
					local SeaBeastFrame = wasdmob:FindFirstChild("HumanoidRootPart").CFrame
					if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - (Vector3.new(SeaBeastFrame.X,30,SeaBeastFrame.Z))).magnitude > 150 then
						Farmtween = toTargetNoDie(CFrame.new(SeaBeastFrame.X,30,SeaBeastFrame.Z))
					elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - (Vector3.new(SeaBeastFrame.X,30,SeaBeastFrame.Z))).magnitude <= 150 then
						if Farmtween then
							Farmtween:Stop()
						end
						if TypeSeabeast == 0 then
							PosKillSea = Vector3.new(SeaBeastFrame.X,80,SeaBeastFrame.Z)
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(SeaBeastFrame.X,30,SeaBeastFrame.Z)
						else
							PosKillSea = Vector3.new(SeaBeastFrame.X,60,SeaBeastFrame.Z)
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(SeaBeastFrame.X,70,SeaBeastFrame.Z)
						end
						task.spawn(function()
							if not LoppSeaDup then 
								LoppSeaDup = true 
								for i,v in ipairs({"Melee","Blox Fruit","Gun"  , "Sword" }) do 
									EquipWeapon(GetFightingStyle(v))
									task.wait(0.2)
									if SkillZ then 
										game:service('VirtualInputManager'):SendKeyEvent(true, "Z", false, game)
										task.wait(0.5)
										game:service('VirtualInputManager'):SendKeyEvent(false, "Z", false, game)
									end
									if SkillX then 
										game:service('VirtualInputManager'):SendKeyEvent(true, "X", false, game)
										task.wait(0.5)
										game:service('VirtualInputManager'):SendKeyEvent(false, "X", false, game)
									end
									if SkillC then 
										game:service('VirtualInputManager'):SendKeyEvent(true, "C", false, game)
										task.wait(0.5)
										game:service('VirtualInputManager'):SendKeyEvent(false, "C", false, game)
									end
									if SkillV then 
										game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
										task.wait(0.5)
										game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
									end
									if SkillF then 
										game:service('VirtualInputManager'):SendKeyEvent(true, "F", false, game)
										task.wait(0.5)
										game:service('VirtualInputManager'):SendKeyEvent(false, "F", false, game)
									end
									task.wait(0.5)
								end
								LoppSeaDup = false
							end
						end)
						SpamSkillSea = true
					end
				until not Auto_Kill_Leviathan or not wasdmob.Parent or not wasdmob:FindFirstChild("HumanoidRootPart") or wasdmob.Health.Value == 0
				SpamSkillSea = false
			end
			NoClip = false
		end
	end)
end)

Options.Auto_Frozen_Dimension:OnChanged(function(starts)
	Auto_Frozen_Dimension = starts
	task.spawn(function()
		while Auto_Frozen_Dimension do task.wait()
			for i,v in ipairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren()) do 
				if Auto_Frozen_Dimension and IsSameName(v.Name,"Frozen Dimension") then 
					repeat task.wait()
						NoClip = true
						wasdtween = toTargetNoDie(v.CFrame * CFrame.new(1,50,0))
					until not v.Parent or not Auto_Frozen_Dimension
					NoClip = false
					if wasdtween then wasdtween:Stop() end
				end
			end
		end
		NoClip = false
	end)
end)

local TypeSeabeast = 0
Options.SeaBeast_Ship:OnChanged(function(starts)
	if NewWorld or ThreeWorld then
		AutoSeaBeast = starts
		spawn(function()
			while task.wait() do
				if AutoSeaBeast then
					TypeSeabeast = 0
					task.wait(1)
					TypeSeabeast = 1
					task.wait(1)
				else
					break 
				end
			end
		end)
		spawn(function()
			while task.wait() do
				if AutoSeaBeast then
					xpcall(function()
						if KillAtFirstOfDark and inmyself("Fist of Darkness") then 
							if game.Workspace.Enemies:FindFirstChild("Darkbeard [Lv. 1000] [Raid Boss]") then
								for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
									if v.Name == "Darkbeard [Lv. 1000] [Raid Boss]" and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
										repeat task.wait()
											if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
												Farmtween = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame)
											elseif (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
												if Farmtween then Farmtween:Stop() end
												EquipWeapon(SelectToolWeapon)
												Usefastattack = true
												game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
											end
										until not AutoSaber or not v.Parent or v.Humanoid.Health <= 0
										Usefastattack = false
									end
								end
							else
								Questtween = toTarget(CFrame.new(3876.00366, 24.6882591, -3820.21777))
								if (CFrame.new(3876.00366, 24.6882591, -3820.21777).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
									if Questtween then
										Questtween:Stop()
									end
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3876.00366, 24.6882591, -3820.21777)
								end
							end

							return	
						end

						if StopAtFirstOfDark and inmyself("Fist of Darkness") then
							ChangeToggle(ConfigAutoSeabeast,false)
							return
						end
						local itmyboat = myboat()
						if itmyboat and itmyboat.Parent.Humanoid.Value <= 0 then
							game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit = false
							task.wait()
							NoClip = true
							itmyboat.Parent:Destroy()
							task.wait(0.2)
						end
						if (game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit == true) or CheckSeabeast() or CheckPirateBoat() then
							if CheckSeabeast() then
								xpcall(function()
									NoClip = true
									game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit = false
									for i,v in pairs(game.Workspace.SeaBeasts:GetChildren()) do
										if AutoSeaBeast and v:FindFirstChild("HumanoidRootPart") and v.Health.Value > 0 then
											repeat task.wait()
												local SeaBeastFrame = v:FindFirstChild("HumanoidRootPart").CFrame
												if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - (Vector3.new(SeaBeastFrame.X,30,SeaBeastFrame.Z))).magnitude > 150 then
													Farmtween = toTargetNoDie(CFrame.new(SeaBeastFrame.X,30,SeaBeastFrame.Z))
												elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - (Vector3.new(SeaBeastFrame.X,30,SeaBeastFrame.Z))).magnitude <= 150 then
													if Farmtween then
														Farmtween:Stop()
													end
													if TypeSeabeast == 0 then
														PosKillSea = Vector3.new(SeaBeastFrame.X,80,SeaBeastFrame.Z)
														game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(SeaBeastFrame.X,30,SeaBeastFrame.Z)
													else
														PosKillSea = Vector3.new(SeaBeastFrame.X,60,SeaBeastFrame.Z)
														game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(SeaBeastFrame.X,70,SeaBeastFrame.Z)
													end
													SpamSkillSea = true
												end
											until not AutoSeaBeast or not v.Parent or not v:FindFirstChild("HumanoidRootPart") or v.Health.Value == 0
											SpamSkillSea = false
										end
									end
								end,function(...)
									print(...)
								end)
							elseif CheckPirateBoat() then
								xpcall(function()
									NoClip = true
									game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit = false
									for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
										if AutoSeaBeast and v:FindFirstChildOfClass("VehicleSeat") and v.Health.Value > 0 then
											repeat task.wait()
												local PirateBoatCFrame = v:FindFirstChildOfClass("VehicleSeat").CFrame
												if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - (Vector3.new(PirateBoatCFrame.X,30,PirateBoatCFrame.Z))).magnitude > 150 then
													Farmtween = toTargetNoDie(CFrame.new(PirateBoatCFrame.X,30,PirateBoatCFrame.Z))
												elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - (Vector3.new(PirateBoatCFrame.X,30,PirateBoatCFrame.Z))).magnitude <= 150 then
													if Farmtween then
														Farmtween:Stop()
													end
													PosKillSea = PirateBoatCFrame.Position
													game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = PirateBoatCFrame * CFrame.new(0,10,1)
													SpamSkillSea = true
												end
											until not AutoSeaBeast or not v.Parent or not v:FindFirstChildOfClass("VehicleSeat") or v.Health.Value == 0
											SpamSkillSea = false
										end
									end
								end,function(...)
									print(...)
								end)
							elseif game.Players.LocalPlayer.Character.Humanoid.Sit == true then
								NoClip = false
								SpamSkillSea = false
								game:service('VirtualInputManager'):SendKeyEvent(true, "W", false, game)
								task.wait(0.5)
								game:service('VirtualInputManager'):SendKeyEvent(false, "W", false, game)
								task.wait(1)
								game:service('VirtualInputManager'):SendKeyEvent(true, "S", false, game)
								task.wait(0.5)
								game:service('VirtualInputManager'):SendKeyEvent(false, "S", false, game)
								task.wait(1)
							end
						elseif itmyboat and (game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit == false) and (NewWorld and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(38.905670166015625, -0.4971587657928467, 5150.13623046875)).Magnitude > 30) or (ThreeWorld and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(163.8607940673828, -0.4971587657928467, 3242.834716796875)).Magnitude > 30) then
							NoClip = true
							SpamSkillSea = false
							local TweenToSea
							if NewWorld then
								TweenToSea = toTarget(CFrame.new(38.905670166015625, -0.4971587657928467, 5150.13623046875))
							elseif ThreeWorld then
								TweenToSea = toTarget(CFrame.new(163.8607940673828, -0.4971587657928467, 3242.834716796875))
							end
							TweenToSea:Wait()
							task.wait(2)
							NoClip = false
						elseif itmyboat and (game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit == false) then
							NoClip = false
							SpamSkillSea = false
							print("??")
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,30,0)
							task.wait(0.1)
							itmyboat:Sit(game.Players.LocalPlayer.Character:WaitForChild("Humanoid"))
							task.wait(1)
						elseif not itmyboat then
							_F("BuyBoat","PirateGrandBrigade")
							task.wait(1)
						end
					end,function(...)
						print("ERROR : "..(...))
					end)
				else
					NoClip = false
					if tween then tween:Cancel() end
					break
				end
			end
		end)
		spawn(function()
			while task.wait() do
				if AutoSeaBeast then
					if SpamSkillSea then
						task.spawn(function()
							if not LoppSeaDup then 
								LoppSeaDup = true 
								for i,v in ipairs({"Melee","Blox Fruit","Gun" , "Sword" }) do 
									EquipWeapon(GetFightingStyle(v))
									task.wait(0.2)
									if SkillZ then 
										game:service('VirtualInputManager'):SendKeyEvent(true, "Z", false, game)
										task.wait(0.5)
										game:service('VirtualInputManager'):SendKeyEvent(false, "Z", false, game)
									end
									if SkillX then 
										game:service('VirtualInputManager'):SendKeyEvent(true, "X", false, game)
										task.wait(0.5)
										game:service('VirtualInputManager'):SendKeyEvent(false, "X", false, game)
									end
									if SkillC then 
										game:service('VirtualInputManager'):SendKeyEvent(true, "C", false, game)
										task.wait(0.5)
										game:service('VirtualInputManager'):SendKeyEvent(false, "C", false, game)
									end
									if SkillV then 
										game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
										task.wait(0.5)
										game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
									end
									if SkillF then 
										game:service('VirtualInputManager'):SendKeyEvent(true, "F", false, game)
										task.wait(0.5)
										game:service('VirtualInputManager'):SendKeyEvent(false, "F", false, game)
									end
									task.wait(0.5)
								end
								LoppSeaDup = false
							end
						end)
					end
				else
					break
				end
			end
		end)
	end
end)

Options.Rough_Seas:OnChanged(function(starts)
	AutoOutSea = starts
	if starts then
		mobilefly(speaker,true)
	end
	task.spawn(function()
		local Unpart = {}
		while task.wait() do 
			if AutoOutSea then 
				local itmyboat = myboat()
				if itmyboat and itmyboat.Parent then
					for _, v in pairs(itmyboat.Parent:GetDescendants()) do
						if v:IsA("BasePart") then
							if v.CanCollide ~= false then 
								v.CanCollide = false
								Unpart[#Unpart+1] = v
							end
						end
					end
					for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
						if v:IsA("BasePart") then
							if v.CanCollide ~= false then 
								v.CanCollide = false
								Unpart[#Unpart+1] = v
							end
						end
					end


					local Hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
					local TarCFrame = Vector3.new(-22859.4453125, 81.92976379394531, 33646.625)
					local Current = game.Workspace.CurrentCamera
					Current.CFrame  = CFrame.new(Current.CFrame.p, TarCFrame)
					if (Hum and Hum.Sit == true) then 
						print(FLYING)
						if not FLYING then 
							mobilefly(speaker,true)
							task.wait(0.5)
						else
							local Current = game.Workspace.CurrentCamera
							Current.CFrame  = CFrame.new(Current.CFrame.p, TarCFrame)

							if SelectSeaLvl < tonumber(game.Players.LocalPlayer.PlayerGui.Main.Compass.Frame.DangerLevel.TextLabel.Text) then
								game:service('VirtualInputManager'):SendKeyEvent(true, "W", false, game)

							else

								game:service('VirtualInputManager'):SendKeyEvent(false, "W", false, game)
							end
						end


					elseif Hum then

						itmyboat:Sit(Hum)
						task.wait(0.5)
					end
				end
			else
				for i,v in pairs(Unpart) do 
					if v ~= nil then 
						v.CanCollide = true
					end

				end
				unmobilefly(speaker)
				break
			end
		end
	end)
end)

Options.AutoTradeEmber:OnChanged(function(starts)
	AutoTradeEmber = starts
	spawn(function()
		local howareuutoday = false
		while AutoTradeEmber do task.wait()
			if AutoTradeEmber then
				if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Timer.Visible == true then
					if howareuutoday then
						game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/KitsuneStatuePray"):InvokeServer()
					else
						for i,v in ipairs(game.Workspace:GetChildren()) do 
							if v.Name:lower():find("ember") then
								if howareuutoday then break end
								tp_da = toTarget(v:GetPivot().p)
								tp_da:Wait()
								task.wait(1)
							end
						end
					end
				else
					game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RE/TouchKitsuneStatue"):FireServer()
					task.delay(270,function()
						howareuutoday = true
					end)
					task.wait(1)
				end
			end
		end
	end)
end)

--

Options.AutoFarmMasterySword:OnChanged(function(starts)
	FarmMasterySwordList = starts
	getgenv().Configs.Main.Auto_Farm_Sword_Mastery_List = starts
	SaveManager:Save()
	spawn(function()
		while task.wait() do
			if FarmMasterySwordList then
				xpcall(function()
					print(#SelectWeaponSwordList)
					if #SelectWeaponSwordList == 0 then return end

					for i,v in pairs(SelectWeaponSwordList) do
						if FarmMasterySwordList == false and table.find(SwordListFarmComplete,v) then
							break;
						end
						if not game.Players.LocalPlayer.Backpack:FindFirstChild(v) and not game.Players.LocalPlayer.Character:FindFirstChild(v) and game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):GetState() ~= Enum.HumanoidStateType.Dead and game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Health ~= 0 then
							while FarmMasterySwordList do task.wait()
								if game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Health == 0 then if tween then tween:Cancel() end repeat task.wait() until game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Health > 0; task.wait(0.2) end
								if tween then tween:Cancel() end
								if inmyself(v) or FarmMasterySwordList == false or table.find(SwordListFarmComplete,v) then
									break;
								end
								task.wait(1)
								_F("StoreItem",tostring(GetFightingStyle("Sword")),inmyself(GetFightingStyle("Sword")))
								task.wait(1)
								_F("LoadItem",tostring(v))
								task.wait(0.5)
								if inmyself(v) then
									SelectWeaponInSwordList = v
									break;
								end
								if CheckMasteryWeapon(v,MasteryWeaponList) == "true" or CheckMasteryWeapon(v,MasteryWeaponList) == "UpTo" then
									print("DONE "..v)
									table.insert(SwordListFarmComplete,v)
									break;
								end
							end
						end
						task.wait(0.2)
						if inmyself(v) then
							while FarmMasterySwordList do task.wait()
								if table.find(SwordListFarmComplete,v) and #SelectWeaponSwordList ~= 0 and #SwordListFarmComplete ~= 0 then
									break
								end
								if FarmMasterySwordList == false then
									break;
								end
								if inmyself(v) then
									SelectWeaponInSwordList = v
								end
								CheckQuestMasteryFarm()
								AutoFarmMasterySwordList()
								if CheckMasteryWeapon(v,MasteryWeaponList) == "true" or CheckMasteryWeapon(v,MasteryWeaponList) == "UpTo" then
									print("DONE "..v)
									table.insert(SwordListFarmComplete,v)
									break;
								end
							end
						end
					end
				end,function(x)
					print("Auto Farm Sword Mastery Error : "..x)
				end)
			else
				if tween then tween:Cancel() end
				break;
			end
		end
	end)
end)

Options.AutoStatkaitan:OnChanged(function(starts)
	AutoStatkaitan = starts
	getgenv().Configs.Stats.Kaitun = starts
	SaveManager:Save()
	spawn(function()
		while task.wait() do
			if game.Players.LocalPlayer.Data.Points.Value >= tonumber(1) then
				if AutoStatkaitan then
					if game:GetService("Players").LocalPlayer.Data.Stats.Melee.Level.Value < MaxLevel then
						_F("AddPoint","Melee",game.Players.LocalPlayer.Data.Points.Value)
					else
						_F("AddPoint","Defense",game.Players.LocalPlayer.Data.Points.Value)
					end
				else
					break
				end
			end
		end
	end)
end)

spawn(function()
	while task.wait() do
		if game.Players.LocalPlayer.Data.Points.Value >= tonumber(PointStats) then
			if melee then
				_F("AddPoint","Melee",PointStats)
			end
			if defense then
				_F("AddPoint","Defense",PointStats)
			end
			if sword then
				_F("AddPoint","Sword",PointStats)
			end
			if gun then
				_F("AddPoint","Gun",PointStats)
			end
			if demonfruit then
				_F("AddPoint","Demon Fruit",PointStats)
			end
		end
	end
end)

Options.AutoBuyTrueTripleKatana:OnChanged(function(starts)
	getgenv().Configs.Main.AutoBuyTrueTripleKatana = starts
	SaveManager:Save()
	spawn(function()
		while task.wait() and getgenv().Configs.Main.AutoBuyTrueTripleKatana do
			local args = {
				"MysteriousMan",
				"2"
			}
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
			task.wait(2)
		end
	end)
end)

Options.AutoBuyLegendarySword:OnChanged(function(starts)
	getgenv().Configs.Main.AutoBuyLegendarySword = starts
	SaveManager:Save()
	spawn(function()
		while task.wait() and getgenv().Configs.Main.AutoBuyLegendarySword do
			if getgenv().Configs.Main.LockLegendarySwordToBuy then
				if not tablefound(getgenv().Configs.Main.SelectLegendarySword, "LegendarySwordDealer", "1") then
					return
				end
			end
			for i = 1, 3 do
				_F("LegendarySwordDealer", tostring(i))
			end
			task.wait(2)
		end
	end)
end)

Options.AutoBuyEnhancement:OnChanged(function(starts)
	getgenv().Configs.Main.AutoBuyEnhancement = starts
	SaveManager:Save()
	spawn(function()
		while task.wait() and getgenv().Configs.Main.AutoBuyEnhancement do
			if getgenv().Configs.Main.LockHakiColorToBuy then
				if not tablefound(getgenv().Configs.Main.SelectHakiColor, "ColorsDealer", "1") then
					return
				end
			end
			for i = 1, 3 do
				_F("ColorsDealer", tostring(i))
			end
			task.wait(2)
		end
	end)
end)
local SelectMaterial = getgenv().Configs.Main.SelectMaterial or ""

Options.AutoFarmMaterial:OnChanged(function(starts)
	AutoFarmMaterial = starts
	getgenv().Configs.Main.AutoFarmMaterial = starts
	SaveManager:Save()

	spawn(function()
		while task.wait() do
			if AutoFarmMaterial then
				xpcall(function()
					if SelectMaterial ~= "" then
						CheckMaterial(SelectMaterial)
						if CustomFindFirstChild(MaterialMob) then
							for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
								if AutoFarmMaterial and table.find(MaterialMob,v.Name) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
									repeat task.wait()
										FarmtoTarget = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame * CFrame.new(0,30,1))
										if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
											if FarmtoTarget then FarmtoTarget:Stop() end
											Usefastattack = true
											EquipWeapon(SelectToolWeapon)
											spawn(function()
												for i,v2 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
													if v2.Name == v.Name then
														spawn(function()
															if InMyNetWork(v2.HumanoidRootPart) then
																v2.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
																v2.Humanoid.JumpPower = 0
																v2.Humanoid.WalkSpeed = 0
																v2.HumanoidRootPart.CanCollide = false
																v2.Humanoid:ChangeState(14)
																v2.Humanoid:ChangeState(11)
																v2.HumanoidRootPart.Size = Vector3.new(55,55,55)
															end
														end)
													end
												end
											end)
											if game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Character:FindFirstChild("Black Leg").Level.Value >= 150 then
												game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
												game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
											end
											game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 1)
										end
									until not CustomFindFirstChild(MaterialMob) or not AutoFarmMaterial or v.Humanoid.Health <= 0 or not v.Parent
									Usefastattack = false
								end
							end
						else
							Usefastattack = false
							Modstween = toTarget(CFrameMon.Position,CFrameMon)
							if (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
								if Modstween then Modstween:Stop() end
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon
							end
						end
					end
				end,function(x)
					print("Auto Farm Material Error : "..x)
				end)
			else
				break;
			end
		end
	end)
end)

-- scripts
NoLoopDuplicate = false
SubQuest = false	

Options.Farming:OnChanged(function(starts)
	FarmLevel = starts
	Auto_Farm_Level = starts
	UsefastattackPlayers = false
	SubQuest = false
	getgenv().Configs.Main.FarmLevel = starts
	SaveManager:Save()
	task.spawn(function()
		while task.wait() do
			if FarmLevel then
				xpcall(function()
					if DoubleQuest then
						CheckQuest()
						if SubQuest == true then
							if LevelFarm then
								if tonumber(LevelFarm-1) ~= 0 then
									CheckOldQuest(tonumber(LevelFarm-1))
								end
							end
						else
							spawn(function()
								pcall(function()
									if NoLoopDuplicate == false then
										if CheckNotifyComplete() and FarmLevel then
											NoLoopDuplicate = true
											while task.wait() do
												SubQuest = true
												if CheckNotifyComplete() or FarmLevel == false then
													break;
												end
											end
											SubQuest = false
											NoLoopDuplicate = false
										end
									end
								end)
							end)
							if SubQuest == true then
								if LevelFarm then
									if tonumber(LevelFarm-1) ~= 0 then
										CheckOldQuest(tonumber(LevelFarm-1))
									end
								end
							end
						end
					else
						CheckQuest()
					end
					local HaveWarp,WarpVec = (function(RealTarget)local a=(RealTarget.Position-game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude;local b;local c;local d=false;for e,f in pairs(AllEntrance)do local g=f+Vector3.new(1,60,0)c=(g-RealTarget.Position).Magnitude;if c<a then a=c;d=true;b=g end end;return d,b end)(CFrameQuest)
					if FarmWithQuestBoss then
						task.wait(0.01)
						CheckQuestBossWithFarm(NameQuest)
						task.wait(0.01)
						if Bosses ~= "" and havemob(Bosses).Humanoid.Health > 0 then
							Monster = Bosses
							LevelQuest = LevelQuestBoss
							NameCheckQuest = NameCheckQuestBoss
							CFrameMon = CFrameBoss
						elseif DoubleQuest and SubQuest then
							if (HaveWarp and (WarpVec-game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude > 5000 ) or (HaveWarp == false and
								(game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position-CFrameQuest.Position).Magnitude > 5000) then
								print("Wasd")
								CheckQuest()
							end
						end
					elseif DoubleQuest and SubQuest then
						if (HaveWarp and (WarpVec-game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude > 5000 ) or (HaveWarp == false and
							(game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position-CFrameQuest.Position).Magnitude > 5000) then
							print("Wasd")
							CheckQuest()
						end
					end
					AutoFarmLevel()
				end,print)			
			elseif not Auto_Farm_Level then
				if tween then tween:Cancel() end
				break
			end
		end
	end)
end)

Options.AcceptQuest:OnChanged(function(starts)
	AutoQuest = starts
	getgenv().Configs.Main.Accept_Quest = starts
	SaveManager:Save()
end)
Options.Double_Quest:OnChanged(function(starts)
	DoubleQuest = starts
	FarmWithQuestBoss = starts
	getgenv().Configs.Main.BossAndDoubleQuest = starts
	SaveManager:Save()
end)
Options.Skip_Farm:OnChanged(function(starts)
	SkipFarmLevel = starts
	getgenv().Configs.Main.Skip_Level_Farm = starts
	SaveManager:Save()
end)

Options.AutoNewWorld:OnChanged(function(starts)
	AutoNew = starts
	getgenv().Configs.Main.Auto_New_World = starts
	SaveManager:Save()
	spawn(function()
		while task.wait() do
			if AutoNew then
				xpcall(function()
					local MyLevel = game.Players.localPlayer.Data.Level.Value
					if MyLevel >= 700 and OldWorld and AutoNew then
						if Auto_Farm_Level then
							FarmLevel = false
						end
						if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Dressrosa") ~= 0 then
							if Workspace.Map.Ice.Door.Transparency == 1 then
								if (CFrame.new(1347.7124, 37.3751602, -1325.6488).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 250 then
									if game.Players.LocalPlayer.Backpack:FindFirstChild("Key") then
										local tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Key")
										task.wait(.4)
										game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):EquipTool(tool)
									end
									DoorNewWorldTween = toTarget(CFrame.new(1347.7124, 37.3751602, -1325.6488).Position,CFrame.new(1347.7124, 37.3751602, -1325.6488))
									if (CFrame.new(1347.7124, 37.3751602, -1325.6488).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 250 then
										if DoorNewWorldTween then DoorNewWorldTween:Stop() end
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1347.7124, 37.3751602, -1325.6488)
									end
								elseif game.Workspace.Enemies:FindFirstChild("Ice Admiral [Lv. 700] [Boss]") and game.Workspace.Map.Ice.Door.CanCollide == false and game.Workspace.Map.Ice.Door.Transparency == 1 and (CFrame.new(1347.7124, 37.3751602, -1325.6488).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
									if DoorNewWorldTween then DoorNewWorldTween:Stop() end
									CheckBoss = true
									for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
										if CheckBoss and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and v.Name == "Ice Admiral [Lv. 700] [Boss]" then
											repeat task.wait()
												if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
													Farmtween = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame)
												elseif (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
													if Farmtween then
														Farmtween:Stop()
													end
													EquipWeapon(SelectToolWeapon)
													Usefastattack = true
													toAroundTarget(v.HumanoidRootPart.CFrame)
												end
											until not CheckBoss or not v.Parent or v.Humanoid.Health <= 0 or AutoNew == false
											Usefastattack = false
											while task.wait() do
												_F("TravelDressrosa")
											end
										end
									end
									CheckBoss = false
								else
									_F("TravelDressrosa")
									DoorNewWorldTween = toTarget(CFrame.new(1382.562255859375, 26.999441146850586, -1458.77783203125))
								end
							else
								if game.Players.LocalPlayer.Backpack:FindFirstChild("Key") or game.Players.LocalPlayer.Character:FindFirstChild("Key") then
									DoorNewWorldTween = toTarget(CFrame.new(1347.7124, 37.3751602, -1325.6488).Position,CFrame.new(1347.7124, 37.3751602, -1325.6488))
									if (CFrame.new(1347.7124, 37.3751602, -1325.6488).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 250 then
										if DoorNewWorldTween then DoorNewWorldTween:Stop() end
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1347.7124, 37.3751602, -1325.6488)
										_F("DressrosaQuestProgress","Detective")
										task.wait(0.5)
										if game.Players.LocalPlayer.Backpack:FindFirstChild("Key") then
											local tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Key")
											task.wait(.4)
											game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):EquipTool(tool)
										end
									end
								else
									AutoNewWorldTween = toTarget(CFrame.new(4849.29883, 5.65138149, 719.611877).Position,CFrame.new(4849.29883, 5.65138149, 719.611877))
									if (CFrame.new(4849.29883, 5.65138149, 719.611877).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 250 then
										if DoorNewWorldTween then DoorNewWorldTween:Stop() end
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(4849.29883, 5.65138149, 719.611877)
										_F("DressrosaQuestProgress","Detective")
										task.wait(0.5)
										if game.Players.LocalPlayer.Backpack:FindFirstChild("Key") then
											local tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Key")
											task.wait(.4)
											game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):EquipTool(tool)
										end
									end
								end
							end
						else
							_F("TravelDressrosa")
						end
					end
				end,print)
			else
				if tween then tween:Cancel() end
				break;
			end
		end
	end)	
end)

Options.FarmAllBoss:OnChanged(function(starts)
	AutoFarmAllBoss = starts
	getgenv().Configs.Main.Boss.Auto_Farm_Boss_All = starts
	SaveManager:Save()
	spawn(function()
		while task.wait() do
			if AutoFarmAllBoss then
				AutoFarmBossAll()
			else
				if tween then tween:Cancel() end
				break
			end
		end
	end)
end)
SelectBoss = (getgenv().Configs.Main.Boss.Select_Boss or "")

Options.FarmBoss:OnChanged(function(starts)
	if SelectBoss == "" then

	else
		AutoBossFarm = starts
		spawn(function()
			while task.wait() do
				if AutoBossFarm then
					AutoFarmBoss()
				else
					if tween then tween:Cancel() end
					break
				end
			end
		end)
	end
end)

Options.FarmBossHop:OnChanged(function(starts)
	AutoBossFarm = starts
	AutoBossFarmHop = starts
	getgenv().Configs.Main.Boss.Auto_Boss_Farm_Hop = starts
	print("WTF")
	SaveManager:Save()
	spawn(function()
		while task.wait() do
			if AutoBossFarm then
				AutoFarmBoss()
			else
				if tween then tween:Cancel() end
				break
			end
		end
	end)
end)

Options.Auto_Quest_Boss:OnChanged(function(starts)
	AutoQuestBoss = starts
end)

if NewWorld then
	Options.AutoFactory:OnChanged(function(starts)
		AutoFactory = starts
		getgenv().Configs.Main.Auto_Factory = starts
		SaveManager:Save()
		if starts then
			spawn(function()
				while task.wait() do
					CheckQuest()
					if AutoFactory then
						if AutoFactory and game:GetService("ReplicatedStorage"):FindFirstChild("Core") and game:GetService("ReplicatedStorage"):FindFirstChild("Core"):FindFirstChild("Humanoid") then
							if Auto_Farm_Level then
								FarmLevel = false
							end
							GOtween = toTarget(CFrame.new(448.46756, 199.356781, -441.389252).Position,CFrame.new(448.46756, 199.356781, -441.389252))
							if (CFrame.new(448.46756, 199.356781, -441.389252).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
								if GOtween then GOtween:Stop()end
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(448.46756, 199.356781, -441.389252)
							end
						elseif AutoFactory and game.Workspace.Enemies:FindFirstChild("Core") then
							for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
								if AutoFactory and v.Name == "Core" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
									repeat task.wait(.1)
										if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
											Farmtween = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame)
										elseif (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
											if Farmtween then Farmtween:Stop() end
											EquipWeapon(SelectToolWeapon)
											Usefastattack = true
											game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 10)
										end
									until not AutoFactory or v.Humanoid.Health <= 0 or not v.Parent
									Usefastattack = false
									if Auto_Farm_Level then
										FarmLevel = true
									end
								end
							end
						end
					else
						if tween then tween:Cancel() end
						break;
					end
				end
			end)
		end
	end)
	Options.AutoThirdSea:OnChanged(function(starts)
		Autothird = starts
		getgenv().Configs.Main.Auto_Third_Sea = starts
		SaveManager:Save()
		local farmlvlnofruit = false
	
		spawn(function()
			while task.wait() do
				if Autothird then
					local MyLevel = game.Players.localPlayer.Data.Level.Value
					if MyLevel >= 1500 and NewWorld and Autothird then
						if Auto_Farm_Level and farmlvlnofruit == false then FarmLevel = false elseif Auto_Farm_Level and farmlvlnofruit == true then FarmLevel = true end
						if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 3 then
							if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess ~= nil then
								_F("TravelZou")
								if game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("ZQuestProgress", "Check") == 0 then
									if game.Workspace.Enemies:FindFirstChild("rip_indra [Lv. 1500] [Boss]") then
										for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
											if v.Name == "rip_indra [Lv. 1500] [Boss]" and v:FindFirstChild("Humanoid")and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
												repeat task.wait()
													if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
														Farmtween = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame)
													elseif (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
														if Farmtween then
															Farmtween:Stop()
														end
														EquipWeapon(SelectToolWeapon)
														Usefastattack = true
														toAroundTarget(v.HumanoidRootPart.CFrame)
													end
												until not Autothird or not v.Parent or v.Humanoid.Health <= 0 or game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("ZQuestProgress", "Check") == 1
												task.wait(.5)
												asmrqq = 2
												repeat task.wait() _F("TravelZou") until asmrqq == 1
												Usefastattack = false
											end
										end
									else -- SlashHit : rbxassetid://2453605589
										_F("ZQuestProgress","Check")
										_F("ZQuestProgress","Begin")
									end
								elseif game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("ZQuestProgress", "Check") == 1 then
									_F("TravelZou")
								else
									if game.Workspace.Enemies:FindFirstChild("Don Swan [Lv. 1000] [Boss]") then
										for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
											if v.Name == "Don Swan [Lv. 1000] [Boss]" and v:FindFirstChild("Humanoid")and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
												repeat task.wait()
													if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
														Farmtween = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame)
													elseif (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
														if Farmtween then
															Farmtween:Stop()
														end
														EquipWeapon(SelectToolWeapon)
														Usefastattack = true
														toAroundTarget(v.HumanoidRootPart.CFrame)
													end
												until not Autothird or not v.Parent or v.Humanoid.Health <= 0
												Usefastattack = false
											end
										end
									else -- SlashHit : rbxassetid://2453605589
										TweenDonSwanthreeworld = toTarget(CFrame.new(2288.802, 15.1870775, 863.034607).Position,CFrame.new(2288.802, 15.1870775, 863.034607))
										if (CFrame.new(2288.802, 15.1870775, 863.034607).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
											if TweenDonSwanthreeworld then
												TweenDonSwanthreeworld:Stop()
												game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2288.802, 15.1870775, 863.034607)
											end
										end
									end
								end
							else
								if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then
									TabelDevilFruitStore = {}
									TabelDevilFruitOpen = {}
	
									for i,v in pairs(game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventoryFruits")) do
										for i1,v1 in pairs(v) do
											if i1 == "Name" then
												table.insert(TabelDevilFruitStore,v1)
											end
										end
									end
	
									for i,v in pairs(game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventoryFruits")) do
										if v.Price >= 1000000 then
											table.insert(TabelDevilFruitOpen,v.Name)
										end
									end
	
									for i,DevilFruitOpenDoor in pairs(TabelDevilFruitOpen) do
										for i1,DevilFruitStore in pairs(TabelDevilFruitStore) do
											if DevilFruitOpenDoor == DevilFruitStore and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then
												farmlvlnofruit = false
												if not game.Players.LocalPlayer.Backpack:FindFirstChild(DevilFruitStore) then
													_F("LoadFruit",DevilFruitStore)
													TabelDevilFruitStore = {}
													for i,v in pairs(game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventoryFruits")) do
														table.insert(TabelDevilFruitStore,v.Name)
													end
												else
													_F("TalkTrevor","1")
													_F("TalkTrevor","2")
													_F("TalkTrevor","3")
												end
											else
												farmlvlnofruit = true
											end
										end
									end
	
									_F("TalkTrevor","1")
									_F("TalkTrevor","2")
									_F("TalkTrevor","3")
								end
							end
						else
							if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 0 then
								if string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirates") and string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == true then
									if game.Workspace.Enemies:FindFirstChild("Swan Pirate [Lv. 775]") then
										for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
											if v.Name == "Swan Pirate [Lv. 775]" then
												repeat task.wait()
													if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
														Farmtween = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame)
													elseif (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
														if Farmtween then Farmtween:Stop() end
														EquipWeapon(SelectToolWeapon)
														Usefastattack = true
														spawn(function()
															for i2,V2 in pairs(game.Workspace.Enemies:GetChildren()) do
																if v2.Name == "Swan Pirate [Lv. 775]" then
																	v2.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
																end
															end
														end)
														v.HumanoidRootPart.Size = Vector3.new(55,55,55)
														toAroundTarget(v.HumanoidRootPart.CFrame)
													end
												until not v.Parent or v.Humanoid.Health <= 0 or Autothird == false or game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == false
												AutoBartiloBring = false
												Usefastattack = false
											end
										end
									else
										Questtween = toTarget(CFrame.new(1057.92761, 137.614319, 1242.08069).Position,CFrame.new(1057.92761, 137.614319, 1242.08069))
										if (CFrame.new(1057.92761, 137.614319, 1242.08069).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
											if Bartilotween then Bartilotween:Stop() end
											game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1057.92761, 137.614319, 1242.08069)
										end
									end
								else
									Bartilotween = toTarget(CFrame.new(-456.28952, 73.0200958, 299.895966).Position,CFrame.new(-456.28952, 73.0200958, 299.895966))
									if ( CFrame.new(-456.28952, 73.0200958, 299.895966).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
										if Bartilotween then Bartilotween:Stop() end
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =  CFrame.new(-456.28952, 73.0200958, 299.895966)
										_F("StartQuest","BartiloQuest",1)
	
									end
								end
							elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 1 then
								if game.Workspace.Enemies:FindFirstChild("Jeremy [Lv. 850] [Boss]") then
									for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
										if v.Name == "Jeremy [Lv. 850] [Boss]" then
											repeat task.wait()
												if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
													Farmtween = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame)
												elseif (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
													if Farmtween then Farmtween:Stop() end
													EquipWeapon(SelectToolWeapon)
													Usefastattack = true
													toAroundTarget(v.HumanoidRootPart.CFrame)
												end
											until not v.Parent or v.Humanoid.Health <= 0 or Autothird == false
											Usefastattack = false
										end
									end
								else
									Bartilotween = toTarget(CFrame.new(2099.88159, 448.931, 648.997375).Position,CFrame.new(2099.88159, 448.931, 648.997375))
									if (CFrame.new(2099.88159, 448.931, 648.997375).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
										if Bartilotween then Bartilotween:Stop() end
										game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2099.88159, 448.931, 648.997375)
									end
								end
							elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 2 then
								if (CFrame.new(-1836, 11, 1714).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
									Bartilotween = toTarget(CFrame.new(-1836, 11, 1714).Position,CFrame.new(-1836, 11, 1714))
								elseif (CFrame.new(-1836, 11, 1714).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
									if Bartilotween then Bartilotween:Stop() end
									game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1836, 11, 1714)
									task.wait(.5)
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1850.49329, 13.1789551, 1750.89685)
									task.wait(.1)
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1858.87305, 19.3777466, 1712.01807)
									task.wait(.1)
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1803.94324, 16.5789185, 1750.89685)
									task.wait(.1)
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1858.55835, 16.8604317, 1724.79541)
									task.wait(.1)
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1869.54224, 15.987854, 1681.00659)
									task.wait(.1)
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1800.0979, 16.4978027, 1684.52368)
									task.wait(.1)
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1819.26343, 14.795166, 1717.90625)
									task.wait(.1)
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1813.51843, 14.8604736, 1724.79541)
								end
							end
						end
					end
				else
					if tween then tween:Cancel() end
					break;
				end
			end
		end)
	end)
	
end

local DuplicateMob = {}

function getallmob()
	for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
		if v.Name:find("Lv.") and not v.Name:find("Boss") and not table.find(DuplicateMob,v.Name) then
			return v.Name
		end
	end
	for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
		if v.Name:find("Lv.") and not v.Name:find("Boss") and not table.find(DuplicateMob,v.Name) then
			return v.Name
		end
	end
	return ""
end

local countskip = 0

Options.Auto_KillAllMonster:OnChanged(function(starts)
	AutoKillAllMob = starts
DuplicateMob = {}

spawn(function()
	while task.wait() do
		if AutoKillAllMob then
			xpcall(function()
				local MonsterAllMob = getallmob()
				if MonsterAllMob == "" then return end
				repeat task.wait()
					if game:GetService("ReplicatedStorage"):FindFirstChild(MonsterAllMob) or game:GetService("Workspace").Enemies:FindFirstChild(MonsterAllMob) then
						if game:GetService("Workspace").Enemies:FindFirstChild(MonsterAllMob) then
							for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
								if AutoKillAllMob and v.Name == MonsterAllMob and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
									repeat task.wait()
										if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 300 then
											Farmtween = toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0,10,0))
										elseif (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
											if Farmtween then
												Farmtween:Stop()
											end
											toAroundTarget(v.HumanoidRootPart.CFrame)
											spawn(function()
												for i,v2 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
													if v2.Name == v.Name then
														spawn(function()
															if InMyNetWork(v2.HumanoidRootPart) then
																v2.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
																v2.Humanoid.JumpPower = 0
																v2.Humanoid.WalkSpeed = 0
																v2.HumanoidRootPart.CanCollide = false
																v2.Humanoid:ChangeState(14)
																v2.Humanoid:ChangeState(11)
																v2.HumanoidRootPart.Size = Vector3.new(55,55,55)
															end
														end)
													end
												end
											end)
											EquipWeapon(SelectToolWeapon)
											v.HumanoidRootPart.Size = Vector3.new(55,55,55)
											Usefastattack = true
											toAroundTarget(v.HumanoidRootPart.CFrame)
										end
									until not AutoKillAllMob or not v.Parent or v.Humanoid.Health <= 0
									Usefastattack = false
									countskip = countskip + 1
								end
							end
						elseif game:GetService("ReplicatedStorage"):FindFirstChild(MonsterAllMob) then
							Usefastattack = false
							Questtween = toTarget(game:GetService("ReplicatedStorage"):FindFirstChild(MonsterAllMob).HumanoidRootPart.CFrame)
							CFrameQuest = game:GetService("ReplicatedStorage"):FindFirstChild(MonsterAllMob).HumanoidRootPart.CFrame
							if (game:GetService("ReplicatedStorage"):FindFirstChild(MonsterAllMob).HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
								if Questtween then Questtween:Stop() end
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("ReplicatedStorage"):FindFirstChild(MonsterAllMob).HumanoidRootPart.CFrame
								task.wait(.1)
							end
						end
					end
				until not game:GetService("ReplicatedStorage"):FindFirstChild(MonsterAllMob) and not game:GetService("Workspace").Enemies:FindFirstChild(MonsterAllMob) or not AutoKillAllMob or countskip >= 20
				table.insert(DuplicateMob,MonsterAllMob)
				countskip = 0
			end,
			function(x)
				print("Kill All Mob Error : " ..x)
			end)
		else
			if tween then tween:Cancel() end
			break
		end
	end
end)
end)

DistanceMobAura = 5000

Options.AutoFarmMobAura:OnChanged(function(starts)
	AutoMobAura = starts
	spawn(function()
		while task.wait() do
			if AutoMobAura then
				for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
					if AutoMobAura and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= DistanceMobAura then
						repeat task.wait()
							if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
								Farmtween = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame)
								Usefastattack = false
							elseif (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
								if Farmtween then Farmtween:Stop() end
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(1,30,1)
								for i2 ,v2 in pairs(game.Workspace.Enemies:GetChildren()) do
									if v2.Name == v.Name then
										if InMyNetWork(v2.HumanoidRootPart) then
											v2.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
											v2.Humanoid.JumpPower = 0
											v2.Humanoid.WalkSpeed = 0
											v2.HumanoidRootPart.CanCollide = false
											v2.Humanoid:ChangeState(14)
											v2.Humanoid:ChangeState(11)
											v2.HumanoidRootPart.Size = Vector3.new(55,55,55)
										end
									end
								end
								EquipWeapon(SelectToolWeapon)
								Usefastattack = true
							end
						until not AutoMobAura or game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Health == 0 or v.Humanoid.Health == 0 or not v.Parent
						Usefastattack = false
					end
				end
			else
				Usefastattack = false
				if tween then tween:Cancel() end
				break
			end
		end
	end)
end)

-- L0CK 
Options.Start_Level_Lock:OnChanged(function(starts)
	LockLevel = starts
	getgenv().Configs.Main.Settings.Level.Start_Level_Lock = starts
	SaveManager:Save()
	spawn(function()
		while task.wait() do
			if LockLevel then
				if game.Players.localPlayer.Data.Level.Value >= SelectLockLevel then
					game.Players.LocalPlayer:Kick("\n Farm Complete At "..tostring(game.Players.localPlayer.Data.Level.Value))
					getgenv().Configs.Main.Settings.Level.Start_Level_Lock = false
					--writefile("LuxuryHub_V2/" .. SelectConfig,HttpService:JSONEncode(_G.ConfigMain))
					task.wait(.1)
					while true do end
				end
			else
				break
			end
			task.wait(2)
		end
	end)
end)

SelectWeaponLockMastery = getgenv().Configs.Main.Settings.Mastery.Weapon_Lock_Master or ""

Options.Start_Mastery_Lock:OnChanged(function(starts)
	LockMastery = starts
	getgenv().Configs.Main.Settings.Mastery.Start_Mastery_Lock = starts
	SaveManager:Save()
	spawn(function()
		while task.wait() do
			if LockMastery then
				if SelectWeaponLockMastery ~= nil or SelectWeaponLockMastery ~= "" then
					if game.Players.LocalPlayer.Backpack:FindFirstChild(SelectWeaponLockMastery) then
						if tonumber(game.Players.LocalPlayer.Backpack:FindFirstChild(SelectWeaponLockMastery).Level.Value) >= SelectMastery then
							game.Players.LocalPlayer:Kick("\n Mastery Complete")
							getgenv().Configs.Main.Settings.Mastery.Start_Mastery_Lock = false
							--writefile("LuxuryHub_V2/" .. SelectConfig,HttpService:JSONEncode(_G.ConfigMain))
							task.wait(.1)
							while true do end
						end
					end
					if game.Players.LocalPlayer.Character:FindFirstChild(SelectWeaponLockMastery) then
						if tonumber(game.Players.LocalPlayer.Character:FindFirstChild(SelectWeaponLockMastery).Level.Value) >= SelectMastery then
							game.Players.LocalPlayer:Kick("\n Mastery Complete")
							getgenv().Configs.Main.Settings.Mastery.Start_Mastery_Lock = false
							--writefile("LuxuryHub_V2/" .. SelectConfig,HttpService:JSONEncode(_G.ConfigMain))
							task.wait(.1)
							while true do end
						end
					end
				end
			else
				break
			end
			task.wait(2)
		end
	end)
end)

Options.Start_Beli_Lock:OnChanged(function(starts)
	LockBeli = starts
	getgenv().Configs.Main.Settings.Beli.Start_Beli_Lock = starts
	SaveManager:Save()
	spawn(function()
		while task.wait() do
			if LockBeli then
				if game.Players.LocalPlayer.Data.Beli.Value >= SelectBeli then
					game.Players.LocalPlayer:Kick("\n Beli Complete")
					getgenv().Configs.Main.Settings.Mastery.Start_Beli_Lock = false
					--writefile("LuxuryHub_V2/" .. SelectConfig,HttpService:JSONEncode(_G.ConfigMain))
					task.wait(.1)
					while true do end
				end
			else
				break
			end
			task.wait(2)
		end
	end)
end)

Options.Start_Fragment_Lock:OnChanged(function(starts)
	LockFragments = starts
	getgenv().Configs.Main.Settings.Fragment.Start_Fragment_Lock = starts
	SaveManager:Save()
	spawn(function()
		while task.wait() do
			if LockFragments then
				if game.Players.LocalPlayer.Data.Fragments.Value >= SelectFragments then
					game.Players.LocalPlayer:Kick("\n Fragments Complete")
					getgenv().Configs.Main.Settings.Fragment.Start_Fragment_Lock = false
					--writefile("LuxuryHub_V2/" .. SelectConfig,HttpService:JSONEncode(_G.ConfigMain))
					task.wait(.1)
					while true do end
				end
			else
				break
			end
			task.wait(2)
		end
	end)
end)

--
Options.RedeemAll:OnChanged(function(starts)
	AutoRedeemCodex2 = starts
	getgenv().Configs.Main.Settings.Code.Auto_Redeem_Code = starts
	SaveManager:Save()
	spawn(function()
		while task.wait(.1) do
			local MyLevel = tonumber(game.Players.LocalPlayer.Data.Level.Value)
			if AutoRedeemCodex2 then
				if not SelectRedeemx2 then return; end
				if MyLevel >= tonumber(SelectRedeemx2) then
					function UseCode(Text)
						game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(Text)
					end
					UseCode("Enyo_is_Pro")
					UseCode("Magicbus")
					UseCode("JCWK")
					UseCode("Starcodeheo")
					UseCode("Bluxxy")
					UseCode("fudd10_v2")
					UseCode("3BVISITS")
					UseCode("FUDD10")
					UseCode("BIGNEWS")
					UseCode("Sub2OfficialNoobie")
					UseCode("SUB2GAMERROBOT_EXP1")
					UseCode("StrawHatMaine")
					UseCode("SUB2NOOBMASTER123")
					UseCode("Sub2Daigrock")
					UseCode("Axiore")
					UseCode("TantaiGaming")
					UseCode("STRAWHATMAINE")
					UseCode("kittgaming")
					UseCode("Enyu_is_Pro")
					UseCode("Sub2Fer999")
					UseCode("THEGREATACE")
					UseCode("GAMERROBOT_YT")
					UseCode("SECRET_ADMIN")
					task.wait(1)
					Options.Auto_Redeem_Code:SetValue(false)
				end
			else
				break
			end
			task.wait(2)
		end
	end)
end)

--
Options.Auto_Superhuman:OnChanged(function(starts)
	Superhuman = starts
	getgenv().Configs.Main.FightingStyle.Auto_Superhuman = starts
	SaveManager:Save()
	spawn(function()
		while task.wait(.5) do
			if Superhuman then
				if game.Players.LocalPlayer:FindFirstChild("WeaponAssetCache") then
					if not game.Players.LocalPlayer.Backpack:FindFirstChild("Combat") and not game.Players.LocalPlayer.Character:FindFirstChild("Combat") then
						if not game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg") and not game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") then
							if not game.Players.LocalPlayer.Backpack:FindFirstChild("Electro") and not game.Players.LocalPlayer.Character:FindFirstChild("Electro") then
								if not game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate") and not game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate") then
									if not game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw") and not game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw") then
										if not game.Players.LocalPlayer.Backpack:FindFirstChild("Superhuman") and not game.Players.LocalPlayer.Character:FindFirstChild("Superhuman") then
											local args = {
												[1] = "BuyElectro"
											}
											game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
										end
									end
								end
							end
						end
					end

					SelectToolWeapon = GetFightingStyle("Melee")

					if game.Players.LocalPlayer.Backpack:FindFirstChild("Combat") or game.Players.LocalPlayer.Character:FindFirstChild("Combat") then
						local args = {
							[1] = "BuyElectro"
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end
					if game.Players.LocalPlayer.Backpack:FindFirstChild("Electro") and game.Players.LocalPlayer.Backpack:FindFirstChild("Electro").Level.Value >= 300 then
						local args = {
							[1] = "BuyBlackLeg"
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end
					if game.Players.LocalPlayer.Character:FindFirstChild("Electro") and game.Players.LocalPlayer.Character:FindFirstChild("Electro").Level.Value >= 300 then
						local args = {
							[1] = "BuyBlackLeg"
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end
					if game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg").Level.Value >= 300 then
						local args = {
							[1] = "BuyFishmanKarate"
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end
					if game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Character:FindFirstChild("Black Leg").Level.Value >= 300 then
						local args = {
							[1] = "BuyFishmanKarate"
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end
					if game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate") and game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate").Level.Value >= 300  then
						local args = {
							[1] = "BlackbeardReward",
							[2] = "DragonClaw",
							[3] = "2"
						}
						HaveDragonClaw = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
						if Superhuman and game.Players.LocalPlayer.Data.Fragments.Value <= 1500 and HaveDragonClaw == 0 then
							if game.Players.LocalPlayer.Data.Level.Value > 1100 then
								RaidsSelected = "Flame"
								AutoRaids = true
								if Auto_Farm_Level then FarmLevel = false end
							end
						else
							AutoRaids = false
							if Auto_Farm_Level then FarmLevel = true end
							local args = {
								[1] = "BlackbeardReward",
								[2] = "DragonClaw",
								[3] = "2"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
							AutoRaids = false
							if Auto_Farm_Level then FarmLevel = true end
						end
					end
					if game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate") and game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate").Level.Value >= 300  then
						local args = {
							[1] = "BlackbeardReward",
							[2] = "DragonClaw",
							[3] = "2"
						}
						HaveDragonClaw = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
						if Superhuman and game.Players.LocalPlayer.Data.Fragments.Value <= 1500 and HaveDragonClaw == 0 then
							if game.Players.LocalPlayer.Data.Level.Value > 1100 then
								RaidsSelected = "Flame"
								AutoRaids = true
								if Auto_Farm_Level then FarmLevel = false end
							end
						else
							AutoRaids = false
							if Auto_Farm_Level then FarmLevel = true end
							local args = {
								[1] = "BlackbeardReward",
								[2] = "DragonClaw",
								[3] = "2"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
							AutoRaids = false
							if Auto_Farm_Level then FarmLevel = true end
						end
					end

					if game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw") and game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw").Level.Value >= 300 then
						FarmLevel = Auto_Farm_Level
						local args = {
							[1] = "BuySuperhuman"
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end
					if game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw") and game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw").Level.Value >= 300 then
						FarmLevel = Auto_Farm_Level
						local args = {
							[1] = "BuySuperhuman"
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end
				end

			else
				break
			end
		end
	end)
	spawn(function()
		while task.wait() do
			if Superhuman then
				if AutoRaids then
					if game.Players.LocalPlayer.Backpack:FindFirstChild("Special Microchip") or game.Players.LocalPlayer.Character:FindFirstChild("Special Microchip") or CheckIsland() then
						if game.Players.LocalPlayer.Backpack:FindFirstChild("Special Microchip") or game.Players.LocalPlayer.Character:FindFirstChild("Special Microchip") and game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false then
							if NewWorld then
								fireclickdetector(Workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
							elseif ThreeWorld then
								fireclickdetector(Workspace.Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector)
							end
							task.wait(16)
						elseif game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == true then
							repeat task.wait()
								if game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 5") or game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 4") or game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 3") or game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 2") or game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1") then
									NextIsland()
									if GoIsland == 0 then task.wait(0.1)
									elseif (ToIslandCFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
										Farmtween = toTarget(ToIslandCFrame)
									elseif (ToIslandCFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
										if Farmtween then Farmtween:Stop() end
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = ToIslandCFrame
									end
								end
								for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
									if AutoRaids and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and (v.HumanoidRootPart.Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= DistanceKillAura then
										pcall(function()
											repeat task.wait()
												v.Humanoid.Health = 0
											until not AutoRaids or v.Humanoid.Health <= 0 or not v.Parent
										end)
									end
								end
								_F("Awakener","Awaken")
							until AutoRaids == false or not game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 5") or not game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 4") or not game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 3") or not game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 2") or not game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1") or game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false
							_F("Awakener","Awaken")
						end
					else
						spawn(function()
							if NoLoopDuplicate3 == false then
								NoLoopDuplicate3 = true
								for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
									if v:IsA("Tool") and string.find(v.Name,"Fruit") and (v.Handle.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 7000 then
										local oldCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame * CFrame.new(3,5,1)
										task.wait(0.02)
										firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart,v.Handle,0)
										task.wait()
										firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart,v.Handle,1)
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame  = oldCFrame
										task.wait(30)
									end
								end
								NoLoopDuplicate3 = false
							end
						end)
						local MaxPrice = math.huge
						for i,v in pairs(game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventoryFruits")) do
							if v.Price <= 1000000 then
								if v.Price < MaxPrice then
									MaxPrice = v.Price
									LoadthisFruit = v.Name
								end
							end
						end
						if LoadthisFruit ~= nil then
							local args = {
								[1] = "LoadFruit",
								[2] = LoadthisFruit
							}

							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
						end

						local args = {
							[1] = "RaidsNpc",
							[2] = "Select",
							[3] = RaidsSelected
						}
						local CheckRaids = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
						if tostring(CheckRaids):find("You must wait") and not game.Players.LocalPlayer.Backpack:FindFirstChild("Special Microchip") and not game.Players.LocalPlayer.Character:FindFirstChild("Special Microchip") then
							Notify({
								Title = "Now Hopping",
								Text = "Not Fruit For Raids",
								Timer = 3
							},"Success")
							ServerFunc:TeleportFast()
						end
						LoadthisFruit = nil
					end
				end
			else
				break
			end
		end
	end)
end)

Options.AutoGodhuman:OnChanged(function(starts)
	Godhuman = starts
	getgenv().Configs.Main.FightingStyle.Auto_Godhuman = starts
	SaveManager:Save()
	spawn(function()
		while task.wait() do
			if Godhuman then
				BuyGodhuman = tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman",true))

				if BuyGodhuman then
					if BuyGodhuman == 1 then
						Godhuman = false
						Options.AutoGodhuman:SetValue(false)
					end
				end
			else
				break;
			end
			task.wait(3)
		end
	end)
	spawn(function()
		while task.wait() do
			if Godhuman then
				xpcall(function()
					if tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman",true)) ~= 0 and tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman",true)) ~= 1 then
						if tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman",true)) ~= 1 then
							if game.Players.LocalPlayer:FindFirstChild("WeaponAssetCache") then
								if not game.Players.LocalPlayer.Backpack:FindFirstChild("Combat") and not game.Players.LocalPlayer.Character:FindFirstChild("Combat") then
									if not game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg") and not game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") then
										if not game.Players.LocalPlayer.Backpack:FindFirstChild("Electro") and not game.Players.LocalPlayer.Character:FindFirstChild("Electro") then
											if not game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate") and not game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate") then
												if not game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw") and not game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw") then
													if not game.Players.LocalPlayer.Backpack:FindFirstChild("Superhuman") and not game.Players.LocalPlayer.Character:FindFirstChild("Superhuman") then
														local args = {
															[1] = "BuyElectro"
														}
														game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
													end
												end
											end
										end
									end
								end

								SelectToolWeapon = GetFightingStyle("Melee")

								if game.Players.LocalPlayer.Backpack:FindFirstChild("Combat") or game.Players.LocalPlayer.Character:FindFirstChild("Combat") then
									local args = {
										[1] = "BuyElectro"
									}
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
								end
								if game.Players.LocalPlayer.Backpack:FindFirstChild("Electro") and game.Players.LocalPlayer.Backpack:FindFirstChild("Electro").Level.Value >= 300 then
									local args = {
										[1] = "BuyBlackLeg"
									}
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
								end
								if game.Players.LocalPlayer.Character:FindFirstChild("Electro") and game.Players.LocalPlayer.Character:FindFirstChild("Electro").Level.Value >= 300 then
									local args = {
										[1] = "BuyBlackLeg"
									}
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
								end
								if game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg").Level.Value >= 300 then
									local args = {
										[1] = "BuyFishmanKarate"
									}
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
								end
								if game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Character:FindFirstChild("Black Leg").Level.Value >= 300 then
									local args = {
										[1] = "BuyFishmanKarate"
									}
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
								end
								if game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate") and game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate").Level.Value >= 300  then
									local args = {
										[1] = "BlackbeardReward",
										[2] = "DragonClaw",
										[3] = "2"
									}
									HaveDragonClaw = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
									if Godhuman and game.Players.LocalPlayer.Data.Fragments.Value <= 1500 and HaveDragonClaw == 0 then
										if game.Players.LocalPlayer.Data.Level.Value > 1100 then
											if Auto_Farm_Level then FarmLevel = false end
										end
									else
										if Auto_Farm_Level then FarmLevel = true end
										local args = {
											[1] = "BlackbeardReward",
											[2] = "DragonClaw",
											[3] = "2"
										}
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
										if Auto_Farm_Level then FarmLevel = true end
									end
								end
								if game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate") and game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate").Level.Value >= 300  then
									local args = {
										[1] = "BlackbeardReward",
										[2] = "DragonClaw",
										[3] = "2"
									}
									HaveDragonClaw = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
									if Godhuman and game.Players.LocalPlayer.Data.Fragments.Value <= 1500 and HaveDragonClaw == 0 then
										if game.Players.LocalPlayer.Data.Level.Value > 1100 then
											if Auto_Farm_Level then FarmLevel = false end
										end
									else
										if Auto_Farm_Level then FarmLevel = true end
										local args = {
											[1] = "BlackbeardReward",
											[2] = "DragonClaw",
											[3] = "2"
										}
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
										if Auto_Farm_Level then FarmLevel = true end
									end
								end

								if game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw") and game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw").Level.Value >= 300 then
									FarmLevel = Auto_Farm_Level
									local args = {
										[1] = "BuySuperhuman"
									}
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
								end
								if game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw") and game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw").Level.Value >= 300 then
									FarmLevel = Auto_Farm_Level
									local args = {
										[1] = "BuySuperhuman"
									}
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
								end
							end
						elseif tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true)) ~= 1 then
							if game.Players.LocalPlayer:FindFirstChild("WeaponAssetCache") then
								if not game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate") and not game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate") then
									if not game.Players.LocalPlayer.Backpack:FindFirstChild("Sharkman Karate") and not game.Players.LocalPlayer.Character:FindFirstChild("Sharkman Karate") then
										local args = {
											[1] = "BuyFishmanKarate"
										}
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
									end
								end
								if inmyself("Fishman Karate") and inmyself("Fishman Karate").Level.Value >= 400 then
									if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true) == "I lost my house keys, could you help me find them? Thanks." and not inmyself("Water Key") then
										if NewWorld then
											KillSharkMan = true
											if Auto_Farm_Level then FarmLevel = false end
										elseif ThreeWorld then
											_F("TravelDressrosa")
										else
											if Auto_Farm_Level then FarmLevel = true end
											KillSharkMan = false
										end
									elseif tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true)) == 1 or tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true)) == 0 then
										if not ThreeWorld then
											_F("TravelDressrosa")
										end
										KillSharkMan = false
										if Auto_Farm_Level then FarmLevel = true end
										local args = {
											[1] = "BuySharkmanKarate"
										}
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
									elseif inmyself("Water Key") then
										if not ThreeWorld then
											_F("TravelDressrosa")
										end
										KillSharkMan = false
										if Auto_Farm_Level then FarmLevel = true end
										local args = {
											[1] = "BuySharkmanKarate"
										}
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
									end
								end
								SelectToolWeapon = GetFightingStyle("Melee")
							end
						elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer( "BuyDeathStep",true) ~= 1 then
							if game.Players.LocalPlayer:FindFirstChild("WeaponAssetCache") then
								if not game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg") and not game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") then
									if not game.Players.LocalPlayer.Backpack:FindFirstChild("Death Step") and not game.Players.LocalPlayer.Character:FindFirstChild("Death Step") then
										local args = {
											[1] = "BuyBlackLeg"
										}
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
									end
								end

								if inmyself("Black Leg") and inmyself("Black Leg").Level.Value >= 400 then
									if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep",true) == 3 and not inmyself("Library Key") then
										if NewWorld then
											KillDeath = true
											if Auto_Farm_Level then FarmLevel = false end
										elseif ThreeWorld then
											_F("TravelDressrosa")
										else
											if Auto_Farm_Level then FarmLevel = true end
											KillDeath = false
										end
									elseif tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep",true)) == 1 or tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep",true)) == 0 then
										local args = {
											[1] = "BuyDeathStep"
										}
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
										KillDeath = false
										if Auto_Farm_Level then FarmLevel = true end
										if not ThreeWorld then
											_F("TravelDressrosa")
										end
									elseif inmyself("Library Key") then
										KillDeath = false
										local args = {
											[1] = "OpenLibrary"
										}

										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
										if Auto_Farm_Level then FarmLevel = true end
									end
								end
								SelectToolWeapon = GetFightingStyle("Melee")
							end
						elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon",true) ~= 1 then
							if game.Players.LocalPlayer:FindFirstChild("WeaponAssetCache") then
								if not game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw") and not game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw") then
									if not game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Talon") and not game.Players.LocalPlayer.Character:FindFirstChild("Dragon Talon") then
										local args = {
											[1] = "BlackbeardReward",
											[2] = "DragonClaw",
											[3] = "2"
										}
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
									end
								end
								SelectToolWeapon = GetFightingStyle("Melee")

								if inmyself("Dragon Claw") and inmyself("Dragon Claw").Level.Value >= 400 and game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Health > 0 then
									if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon", true) == 3 then
										Options.AutoFarmBone:SetValue(false)
										if Auto_Farm_Level then FarmLevel = true end
										local string_1 = "BuyDragonTalon";
										local bool_1 = true;
										local Target = game:GetService("ReplicatedStorage").Remotes["CommF_"];
										Target:InvokeServer(string_1, bool_1);
									elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon", true) == 1 then
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
										Options.AutoFarmBone:SetValue(false)
										if Auto_Farm_Level then FarmLevel = true end
									else
										if Auto_Farm_Level then FarmLevel = false end
										Options.AutoFarmBone:SetValue(false)
										local string_1 = "Bones";
										local string_2 = "Buy";
										local number_1 = 1;
										local number_2 = 1;
										local Target = game:GetService("ReplicatedStorage").Remotes["CommF_"];
										Target:InvokeServer(string_1, string_2, number_1, number_2);
									end
								end
							end
						elseif tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw",true)) ~= 1 then
							if game.Players.LocalPlayer:FindFirstChild("WeaponAssetCache") then
								if not game.Players.LocalPlayer.Backpack:FindFirstChild("Electro") and not game.Players.LocalPlayer.Character:FindFirstChild("Electro") then
									if not game.Players.LocalPlayer.Backpack:FindFirstChild("Electric Claw") and not game.Players.LocalPlayer.Character:FindFirstChild("Electric Claw") then
										local args = {
											[1] = "BuyElectro"
										}
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
									end
								end
								SelectToolWeapon = GetFightingStyle("Melee")
								if game.Players.LocalPlayer.Backpack:FindFirstChild("Electro") and game.Players.LocalPlayer.Backpack:FindFirstChild("Electro").Level.Value >= 400 then
									local v175 = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw", true);
									if v175 == 4 then
										local v176 = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw", "Start");
										if v176 == nil then
											game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-12548, 337, -7481)
										end
									else
										local string_1 = "BuyElectricClaw";
										local Target = game:GetService("ReplicatedStorage").Remotes["CommF_"];
										Target:InvokeServer(string_1);
									end
								end
								if game.Players.LocalPlayer.Character:FindFirstChild("Electro") and game.Players.LocalPlayer.Character:FindFirstChild("Electro").Level.Value >= 400 then
									local v175 = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw", true);
									if v175 == 4 then
										local v176 = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw", "Start");
										if v176 == nil then
											game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-12548, 337, -7481)
										end
									else
										local string_1 = "BuyElectricClaw";
										local Target = game:GetService("ReplicatedStorage").Remotes["CommF_"];
										Target:InvokeServer(string_1);
									end
								end
							end
						elseif tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman",true)) == 1 and tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon",true)) == 1 and tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true)) == 1 and tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer( "BuyDeathStep",true)) == 1 and tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw",true)) == 1 then
							if not SupComplete then
								local args = {
									[1] = "BuySuperhuman"
								}
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
								task.wait(0.2)
								if CheckMasteryWeapon("Superhuman",400) == "UpTo" or CheckMasteryWeapon("Superhuman",400) == "true" and SupComplete == false then
									SupComplete = true
								end
							elseif not TalComplete then
								local args = {
									[1] = "BuyDragonTalon"
								}
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
								task.wait(0.2)
								if CheckMasteryWeapon("Dragon Talon",400) == "UpTo" or CheckMasteryWeapon("Superhuman",400) == "true" and TalComplete == false then
									TalComplete = true
								end
							elseif not SharkComplete then
								local args = {
									[1] = "BuySharkmanKarate"
								}
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
								task.wait(0.2)
								if CheckMasteryWeapon("Sharkman Karate",400) == "UpTo" or CheckMasteryWeapon("Superhuman",400) == "true" and SharkComplete == false then
									SharkComplete = true
								end
							elseif not DeathComplete then
								local args = {
									[1] = "BuyDeathStep"
								}
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
								task.wait(0.2)
								if CheckMasteryWeapon("Death Step",400) == "UpTo" or CheckMasteryWeapon("Superhuman",400) == "true" and DeathComplete == false then
									DeathComplete = true
								end
							elseif not EClawComplete then
								local args = {
									[1] = "BuyElectricClaw"
								}
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
								task.wait(0.2)
								if CheckMasteryWeapon("Electric Claw",400) == "UpTo" or CheckMasteryWeapon("Superhuman",400) == "true" and EClawComplete == false then
									EClawComplete = true
								end
							end
						end
						if SupComplete and EClawComplete and TalComplete and SharkComplete and DeathComplete and (not game.Players.LocalPlayer.Character:FindFirstChild("Godhuman") or not game.Players.LocalPlayer.Backpack:FindFirstChild("Godhuman")) then

							if GetMaterial("Fish Tail") >= 20 then
								if GetMaterial("Magma Ore") >= 20 then
									if GetMaterial("Dragon Scale") >= 10 then
										if GetMaterial("Mystic Droplet") >= 10 then
											if Auto_Farm_Level then FarmLevel = true end
											BuyGodhuman = tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman",true))

											if BuyGodhuman then
												if BuyGodhuman == 1 then
													Godhuman = false
													Options.AutoGodhuman:SetValue(false)
												end
											end
											_F("BuyGodhuman")
										elseif not NewWorld then
											_F("TravelDressrosa")
										elseif NewWorld then
											if Auto_Farm_Level then FarmLevel = false end
											CheckMaterial("Mystic Droplet")
											if CustomFindFirstChild(MaterialMob) then
												for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
													if Godhuman and table.find(MaterialMob,v.Name) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
														repeat task.wait()
															FarmtoTarget = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame * CFrame.new(0,30,1))
															if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
																if FarmtoTarget then FarmtoTarget:Stop() end
																Usefastattack = true
																EquipWeapon(SelectToolWeapon)
																spawn(function()
																	for i,v2 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
																		if v2.Name == v.Name then
																			spawn(function()
																				if InMyNetWork(v2.HumanoidRootPart) then
																					v2.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
																					v2.Humanoid.JumpPower = 0
																					v2.Humanoid.WalkSpeed = 0
																					v2.HumanoidRootPart.CanCollide = false
																					v2.Humanoid:ChangeState(14)
																					v2.Humanoid:ChangeState(11)
																					v2.HumanoidRootPart.Size = Vector3.new(55,55,55)
																				end
																			end)
																		end
																	end
																end)
																if game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Character:FindFirstChild("Black Leg").Level.Value >= 150 then
																	game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
																	game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
																end
																game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 1)
															end
														until not CustomFindFirstChild(MaterialMob) or not Godhuman or v.Humanoid.Health <= 0 or not v.Parent
														Usefastattack = false
													end
												end
											else
												Usefastattack = false
												Modstween = toTarget(CFrameMon.Position,CFrameMon)
												if (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
													if Modstween then Modstween:Stop() end
													game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon
												end
											end
										end
									elseif not ThreeWorld then
										_F("TravelZou")
									elseif ThreeWorld then
										if Auto_Farm_Level then FarmLevel = false end
										CheckMaterial("Dragon Scale")
										if CustomFindFirstChild(MaterialMob) then
											for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
												if Godhuman and table.find(MaterialMob,v.Name) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
													repeat task.wait()
														FarmtoTarget = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame * CFrame.new(0,30,1))
														if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
															if FarmtoTarget then FarmtoTarget:Stop() end
															Usefastattack = true
															EquipWeapon(SelectToolWeapon)
															spawn(function()
																for i,v2 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
																	if v2.Name == v.Name then
																		spawn(function()
																			if InMyNetWork(v2.HumanoidRootPart) then
																				v2.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
																				v2.Humanoid.JumpPower = 0
																				v2.Humanoid.WalkSpeed = 0
																				v2.HumanoidRootPart.CanCollide = false
																				v2.Humanoid:ChangeState(14)
																				v2.Humanoid:ChangeState(11)
																				v2.HumanoidRootPart.Size = Vector3.new(55,55,55)
																			end
																		end)
																	end
																end
															end)
															if game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Character:FindFirstChild("Black Leg").Level.Value >= 150 then
																game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
																game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
															end
															game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 1)
														end
													until not CustomFindFirstChild(MaterialMob) or not Godhuman or v.Humanoid.Health <= 0 or not v.Parent
													Usefastattack = false
												end
											end
										else
											Usefastattack = false
											Modstween = toTarget(CFrameMon.Position,CFrameMon)
											if (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
												if Modstween then Modstween:Stop() end
												game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon
											end
										end
									end
								elseif not OldWorld then
									_F("TravelMain")
								elseif OldWorld then
									if Auto_Farm_Level then FarmLevel = false end
									CheckMaterial("Magma Ore")
									if CustomFindFirstChild(MaterialMob) then
										for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
											if Godhuman and table.find(MaterialMob,v.Name) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
												repeat task.wait()
													FarmtoTarget = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame * CFrame.new(0,30,1))
													if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
														if FarmtoTarget then FarmtoTarget:Stop() end
														Usefastattack = true
														EquipWeapon(SelectToolWeapon)
														spawn(function()
															for i,v2 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
																if v2.Name == v.Name then
																	spawn(function()
																		if InMyNetWork(v2.HumanoidRootPart) then
																			v2.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
																			v2.Humanoid.JumpPower = 0
																			v2.Humanoid.WalkSpeed = 0
																			v2.HumanoidRootPart.CanCollide = false
																			v2.Humanoid:ChangeState(14)
																			v2.Humanoid:ChangeState(11)
																			v2.HumanoidRootPart.Size = Vector3.new(55,55,55)
																		end
																	end)
																end
															end
														end)
														if game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Character:FindFirstChild("Black Leg").Level.Value >= 150 then
															game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
															game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
														end
														game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 1)
													end
												until not CustomFindFirstChild(MaterialMob) or not Godhuman or v.Humanoid.Health <= 0 or not v.Parent
												Usefastattack = false
											end
										end
									else
										Usefastattack = false
										Modstween = toTarget(CFrameMon.Position,CFrameMon)
										if (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
											if Modstween then Modstween:Stop() end
											game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon
										end
									end
								end
							elseif not OldWorld then
								_F("TravelMain")
							elseif OldWorld then
								if Auto_Farm_Level then FarmLevel = false end
								CheckMaterial("Fish Tail")
								if CustomFindFirstChild(MaterialMob) then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if Godhuman and table.find(MaterialMob,v.Name) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
											repeat task.wait()
												FarmtoTarget = toTarget(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame * CFrame.new(0,30,1))
												if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
													if FarmtoTarget then FarmtoTarget:Stop() end
													Usefastattack = true
													EquipWeapon(SelectToolWeapon)
													spawn(function()
														for i,v2 in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
															if v2.Name == v.Name then
																spawn(function()
																	if InMyNetWork(v2.HumanoidRootPart) then
																		v2.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
																		v2.Humanoid.JumpPower = 0
																		v2.Humanoid.WalkSpeed = 0
																		v2.HumanoidRootPart.CanCollide = false
																		v2.Humanoid:ChangeState(14)
																		v2.Humanoid:ChangeState(11)
																		v2.HumanoidRootPart.Size = Vector3.new(55,55,55)
																	end
																end)
															end
														end
													end)
													if game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Character:FindFirstChild("Black Leg").Level.Value >= 150 then
														game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
														game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
													end
													game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 1)
												end
											until not CustomFindFirstChild(MaterialMob) or not Godhuman or v.Humanoid.Health <= 0 or not v.Parent
											Usefastattack = false
										end
									end
								else
									Usefastattack = false
									Modstween = toTarget(CFrameMon.Position,CFrameMon)
									if (CFrameMon.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
										if Modstween then Modstween:Stop() end
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameMon
									end
								end
							end
						end
					else
						_F("BuyGodhuman")
					end
				end,print)
			else
				break
			end
		end
	end)
	task.wait(5)
	spawn(function()
		while task.wait() do
			if Godhuman then
				if (game.Players.LocalPlayer.Backpack:FindFirstChild("Special Microchip") or game.Players.LocalPlayer.Character:FindFirstChild("Special Microchip") or CheckIsland()) and game.Players.LocalPlayer.Data.Level.Value > 1100 and not OldWorld and (not (SupComplete and EClawComplete and TalComplete and SharkComplete and DeathComplete) or (GetMaterial("Fish Tail") >= 20 and GetMaterial("Magma Ore") >= 20 and GetMaterial("Dragon Scale") >= 10 and GetMaterial("Mystic Droplet") >= 10) ) then
					if tween then tween:Cancel() end
					if game.Players.LocalPlayer.Backpack:FindFirstChild("Special Microchip") or game.Players.LocalPlayer.Character:FindFirstChild("Special Microchip") and game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false and not (SupComplete and EClawComplete and TalComplete and SharkComplete and DeathComplete) and not KillSharkMan and not KillDeath then
						if Auto_Farm_Level then FarmLevel = false end
						if NewWorld then
							fireclickdetector(Workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
						elseif ThreeWorld then
							fireclickdetector(Workspace.Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector)
						end
						task.wait(16)
					elseif game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == true then
						if Auto_Farm_Level then FarmLevel = false end
						repeat task.wait()
							if game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 5") or game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 4") or game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 3") or game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 2") or game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1") then
								NextIsland()
								if GoIsland == 0 then task.wait(0.1)
								elseif (ToIslandCFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 150 then
									Farmtween = toTarget(ToIslandCFrame)
								elseif (ToIslandCFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
									if Farmtween then Farmtween:Stop() end
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = ToIslandCFrame
								end
							end
							for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
								if Godhuman and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and (v.HumanoidRootPart.Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= DistanceKillAura then
									pcall(function()
										repeat task.wait()
											v.Humanoid.Health = 0
										until not Godhuman or v.Humanoid.Health <= 0 or not v.Parent
									end)
								end
							end
							_F("Awakener","Awaken")
						until Godhuman == false or not game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 5") or not game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 4") or not game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 3") or not game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 2") or not game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1") or game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible == false
						_F("Awakener","Awaken")
					else
						if Auto_Farm_Level then FarmLevel = true end
					end
				elseif game.Players.LocalPlayer.Data.Level.Value > 1100 and not OldWorld and not (SupComplete and EClawComplete and TalComplete and SharkComplete and DeathComplete) and not KillSharkMan and not KillDeath and game.Players.LocalPlayer.Data.Fragments.Value < 5000 then
					if Auto_Farm_Level then FarmLevel = true end
					spawn(function()
						if NoLoopDuplicate3 == false then
							NoLoopDuplicate3 = true
							for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
								if v:IsA("Tool") and string.find(v.Name,"Fruit") and (v.Handle.Position-game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude <= 7000 then
									local oldCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame * CFrame.new(3,5,1)
									task.wait(0.02)
									firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart,v.Handle,0)
									task.wait()
									firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart,v.Handle,1)
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame  = oldCFrame
									task.wait(15)
								end
							end
							NoLoopDuplicate3 = false
						end
					end)
					local MaxPrice = math.huge
					for i,v in pairs(game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventoryFruits")) do
						if v.Price <= 1000000 then
							if v.Price < MaxPrice then
								MaxPrice = v.Price
								LoadthisFruit = v.Name
							end
						end
					end
					if LoadthisFruit ~= nil then
						local args = {
							[1] = "LoadFruit",
							[2] = LoadthisFruit
						}

						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end

					local args = {
						[1] = "RaidsNpc",
						[2] = "Select",
						[3] = "Flame"
					}
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

					LoadthisFruit = nil
				end
			else
				break
			end
		end
	end)
	spawn(function()
		while task.wait() do
			if Godhuman and NewWorld then
				if (KillSharkMan == true and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true) == "I lost my house keys, could you help me find them? Thanks.") then
					if game.Workspace.Enemies:FindFirstChild("Tide Keeper [Lv. 1475] [Boss]") then
						if KillFish then KillFish:Stop() end

						for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
							if v.Name == "Tide Keeper [Lv. 1475] [Boss]" then
								repeat task.wait()
									if game.Workspace.Enemies:FindFirstChild(v.Name) then
										if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 200 then
											Farmtween = toTarget(v.HumanoidRootPart.CFrame)
										elseif (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 200 then
											if Farmtween then
												Farmtween:Stop()
											end
											Click()
											Usefastattack = true
											EquipWeapon(SelectToolWeapon)
											v.HumanoidRootPart.CanCollide = false
											v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
											game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(1,50,0)
										end
									else
										Usefastattack = false
									end
								until not v.Parent or Godhuman == false or KillSharkMan == false or v.Humanoid.Health == 0 or inmyself("Water Key")
								task.wait(1)
							end
						end
					else
						if game:GetService("ReplicatedStorage"):FindFirstChild("Tide Keeper [Lv. 1475] [Boss]") then
							KillFish = toTarget(game:GetService("ReplicatedStorage"):FindFirstChild("Tide Keeper [Lv. 1475] [Boss]").HumanoidRootPart.CFrame * CFrame.new(1,50,1))
						elseif not game.Workspace.Enemies:FindFirstChild("Tide Keeper [Lv. 1475] [Boss]") then
							if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true) == "I lost my house keys, could you help me find them? Thanks." then
								Notify({
									Title = "Now Hopping",
									Text = "Not Find Sharkman",
									Timer = 3
								},"Success")
								ServerFunc:TeleportFast()
							end
						end
					end
				end
			else
				break
			end
		end
	end)
	spawn(function()
		while task.wait() do
			if Godhuman and NewWorld then
				if (KillDeath == true and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep",true) == 3) then
					if game.Workspace.Enemies:FindFirstChild("Awakened Ice Admiral [Lv. 1400] [Boss]") then

						if KillFish then KillFish:Stop() end

						for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
							if v.Name == "Awakened Ice Admiral [Lv. 1400] [Boss]" then
								repeat task.wait()
									if game.Workspace.Enemies:FindFirstChild(v.Name) then
										if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 200 then
											Farmtween = toTarget(v.HumanoidRootPart.CFrame)
										elseif (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 200 then
											if Farmtween then
												Farmtween:Stop()
											end
											Click()
											Usefastattack = true
											EquipWeapon(SelectToolWeapon)
											v.HumanoidRootPart.CanCollide = false
											v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
											game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(1,50,0)
										end
									else
										Usefastattack = false
									end
								until not v.Parent or Godhuman == false or KillDeath == false or v.Humanoid.Health == 0 or inmyself("Library Key")
								Usefastattack = false
								task.wait(1)
							end
						end
					else
						if game:GetService("ReplicatedStorage"):FindFirstChild("Awakened Ice Admiral [Lv. 1400] [Boss]") then
							KillFish = toTarget(game:GetService("ReplicatedStorage"):FindFirstChild("Awakened Ice Admiral [Lv. 1400] [Boss]").HumanoidRootPart.CFrame * CFrame.new(1,50,1))
						elseif not game.Workspace.Enemies:FindFirstChild("Awakened Ice Admiral [Lv. 1400] [Boss]") then
							if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep",true) == 3 then
								Notify({
									Title = "Now Hopping",
									Text = "Not Find Boss Ice",
									Timer = 3
								},"Success")
								ServerFunc:TeleportFast()
							end
						end
					end
				end
			else
				break
			end
		end
	end)
end)

Options.AutoSharkmanKarate:OnChanged(function(starts)
	Sharkman = starts
	getgenv().Configs.Main.FightingStyle.Auto_Sharkman_Karate = starts
	SaveManager:Save()
	spawn(function()
		while task.wait(.5) do
			if Sharkman then
				if game.Players.LocalPlayer:FindFirstChild("WeaponAssetCache") then
					if game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate") and game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate").Level.Value >= 400 then
						if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true) == "I lost my house keys, could you help me find them? Thanks." and not game.Players.LocalPlayer.Character:FindFirstChild("Water Key") and not game.Players.LocalPlayer.Backpack:FindFirstChild("Water Key") then
							if NewWorld then
								KillSharkMan = true
							else
								KillSharkMan = false
							end
						elseif tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true)) == 1 then
							KillSharkMan = false
							local args = {
								[1] = "BuySharkmanKarate"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
						elseif game.Players.LocalPlayer.Character:FindFirstChild("Water Key") or game.Players.LocalPlayer.Backpack:FindFirstChild("Water Key") then
							KillSharkMan = false
							local args = {
								[1] = "BuySharkmanKarate"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
						end
					end

					if game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate") and game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate").Level.Value >= 400 then
						if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true) == "I lost my house keys, could you help me find them? Thanks." and not game.Players.LocalPlayer.Character:FindFirstChild("Water Key") and not game.Players.LocalPlayer.Backpack:FindFirstChild("Water Key") then
							if NewWorld then
								KillSharkMan = true
							else
								KillSharkMan = false
							end
						elseif tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true)) == 1 then
							KillSharkMan = false
							local args = {
								[1] = "BuySharkmanKarate"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
						elseif game.Players.LocalPlayer.Character:FindFirstChild("Water Key") or game.Players.LocalPlayer.Backpack:FindFirstChild("Water Key") then
							KillSharkMan = false
							local args = {
								[1] = "BuySharkmanKarate"
							}
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
						end
					end
					SelectToolWeapon = GetFightingStyle("Melee")
				end
			else
				break
			end
		end
	end)
	spawn(function()
		while task.wait() do
			if Sharkman  then
				if (KillSharkMan == true and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true) == "I lost my house keys, could you help me find them? Thanks.") and NewWorld then
					if game.Workspace.Enemies:FindFirstChild("Tide Keeper [Lv. 1475] [Boss]") then
						if KillFish then KillFish:Stop() end

						for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
							if v.Name == "Tide Keeper [Lv. 1475] [Boss]" then
								repeat task.wait()
									if game.Workspace.Enemies:FindFirstChild(v.Name) then
										if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 200 then
											Farmtween = toTarget(v.HumanoidRootPart.CFrame)
										elseif (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 200 then
											if Farmtween then
												Farmtween:Stop()
											end
											Click()
											Usefastattack = true
											EquipWeapon(SelectToolWeapon)
											v.HumanoidRootPart.CanCollide = false
											v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
											game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(1,50,0)
										end
									else
										Usefastattack = false
									end
								until not v.Parent or Sharkman == false or KillSharkMan == false or v.Humanoid.Health == 0 or game.Players.LocalPlayer.Character:FindFirstChild("Water Key") or game.Players.LocalPlayer.Backpack:FindFirstChild("Water Key")
								Usefastattack = false
								task.wait(1)
							end
						end
					else
						if game:GetService("ReplicatedStorage"):FindFirstChild("Tide Keeper [Lv. 1475] [Boss]") then
							KillFish = toTarget(game:GetService("ReplicatedStorage"):FindFirstChild("Tide Keeper [Lv. 1475] [Boss]").HumanoidRootPart.CFrame)
						else
							if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true) == "I lost my house keys, could you help me find them? Thanks." then
								Notify({
									Title = "Now Hopping",
									Text = "Not Find Sharkman",
									Timer = 3
								},"Success")
								ServerFunc:TeleportFast()
							end
						end
					end
				end
			else
				if tween then tween:Cancel() end
				break
			end
		end
	end)
end)

Options.AutoDeathStep:OnChanged(function(starts)
	DeathStep = starts
	getgenv().Configs.Main.FightingStyle.Auto_Death_Step = starts
	SaveManager:Save()
	if starts then
		_F("BuyBlackLeg")
	end
	spawn(function()
		while task.wait(.5) do
			if DeathStep then
				if game.Players.LocalPlayer:FindFirstChild("WeaponAssetCache") then
					if game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg").Level.Value >= 400 then
						local args = {
							[1] = "BuyDeathStep"
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

					end
					if game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") and game.Players.LocalPlayer.Character:FindFirstChild("Black Leg").Level.Value >= 400 then
						local args = {
							[1] = "BuyDeathStep"
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

					end
					SelectToolWeapon = GetFightingStyle("Melee")
				end
			else
				break
			end
		end
	end)
end)

Options.AutoDragonTalon:OnChanged(function(starts)
	DargonTalon = starts
	getgenv().Configs.Main.FightingStyle.Auto_Dragon_Talon = starts
	SaveManager:Save()
	if starts then
		_F("BlackbeardReward","DragonClaw","2")
	end
	spawn(function()
		while task.wait(.5) do
			if DargonTalon then
				if game.Players.LocalPlayer:FindFirstChild("WeaponAssetCache") then

					SelectToolWeapon = GetFightingStyle("Melee")

					if game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw") and game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw").Level.Value >= 400 and game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Health > 0 then
						if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon", true) == 3 then
							local string_1 = "Bones";
							local string_2 = "Buy";
							local number_1 = 1;
							local number_2 = 1;
							local Target = game:GetService("ReplicatedStorage").Remotes["CommF_"];
							Target:InvokeServer(string_1, string_2, number_1, number_2);

							local string_1 = "BuyDragonTalon";
							local bool_1 = true;
							local Target = game:GetService("ReplicatedStorage").Remotes["CommF_"];
							Target:InvokeServer(string_1, bool_1);
						elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon", true) == 1 then
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
						else
							local string_1 = "Bones";
							local string_2 = "Buy";
							local number_1 = 1;
							local number_2 = 1;
							local Target = game:GetService("ReplicatedStorage").Remotes["CommF_"];
							Target:InvokeServer(string_1, string_2, number_1, number_2);
						end
					end

					if game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw") and game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw").Level.Value >= 400 and game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Health > 0 then
						if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon", true) == 3 then
							local string_1 = "Bones";
							local string_2 = "Buy";
							local number_1 = 1;
							local number_2 = 1;
							local Target = game:GetService("ReplicatedStorage").Remotes["CommF_"];
							Target:InvokeServer(string_1, string_2, number_1, number_2);

							local string_1 = "BuyDragonTalon";
							local bool_1 = true;
							local Target = game:GetService("ReplicatedStorage").Remotes["CommF_"];
							Target:InvokeServer(string_1, bool_1);
						elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon", true) == 1 then
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
						else
							local string_1 = "Bones";
							local string_2 = "Buy";
							local number_1 = 1;
							local number_2 = 1;
							local Target = game:GetService("ReplicatedStorage").Remotes["CommF_"];
							Target:InvokeServer(string_1, string_2, number_1, number_2);
						end
					end
				end
			else
				break
			end
		end
	end)
end)

Options.AutoElectricClaw:OnChanged(function(starts)
	Electricclaw = starts
	getgenv().Configs.Main.FightingStyle.Auto_Electric_Claw = starts
	SaveManager:Save()
	if starts then
		_F("BuyElectro")
	end
end)

Options.Auto_Haki:OnChanged(function(starts)
	EnabledHaki = starts
	getgenv().Configs.Settings.Auto_Haki = starts
	SaveManager:Save()
	spawn(function()
		while task.wait() do
			if EnabledHaki then
				if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
					local args = {
						[1] = "Buso"
					}
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
				end
			else
				break;
			end
		end
	end)
end)

Options.EnabledKen:OnChanged(function(starts)
	AUTOHAKIObs = starts
	getgenv().Configs.Settings.Auto_Haki_Ken = starts
	SaveManager:Save()
	spawn(function()
		while task.wait() do
			if AUTOHAKIObs then
				if GetCollectionService:HasTag(game.Players.LocalPlayer.Character, "Ken") then
					if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") and game.Players.LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") then
					else task.wait()
						game:service('VirtualUser'):CaptureController()
						game:service('VirtualUser'):SetKeyDown('0x65')
						task.wait(2)
						game:service('VirtualUser'):SetKeyUp('0x65')
					end
				end
			else
				break;
			end
		end
	end)
end)

Options.AutoFastmodeNa:OnChanged(function(starts)
	AutoFastmode = starts
	getgenv().Configs.Settings.Auto_Fast_mode = starts
	SaveManager:Save()
	spawn(function()
		while task.wait() do
			if AutoFastmode and _G.UseFastModeAuto == nil then
				pcall(FastModeF)
				_G.UseFastModeAuto = true
				task.wait(1)
			else
				break
			end
		end
	end)
end)

Loaded_Successfully = true

print("--[[ Luxury V2 Loaded Successfully ]]--") 