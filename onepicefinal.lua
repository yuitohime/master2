-- ==========================================
-- 🌸 YUIHUB - THE ULTIMATE SCRIPT V29 (NO CRASH, NO SINK, FULL STABLE)
-- (TRỊ DỨT ĐIỂM LỖI ĐƠ SCRIPT KHI DÙNG SKILL, KHÓA VỊ TRÍ CHỜ QUÁI CHỐNG RƠI NƯỚC)
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TPS = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")

_G.YuiKillAllLoops = false
if _G.YuiConnections then for _, conn in pairs(_G.YuiConnections) do pcall(function() conn:Disconnect() end) end end
_G.YuiConnections = {}

local SafeParent = pcall(gethui) and gethui() or LocalPlayer:WaitForChild("PlayerGui")
if SafeParent:FindFirstChild("YuiHub_UI") then SafeParent["YuiHub_UI"]:Destroy() end

local ScanLogFrame = nil
local playerPosBox = nil

-- ==========================================
-- 📚 DATABASE FULL TỪ USER
-- ==========================================
local CoordDB = {
    WorldBosses = {
        ["Hawkeye [Lv.999]"] = {Level = 999, Pos = Vector3.new(-1782, 77, 3671), Island = "Dark Castle"},
        ["God of Cold [Lv.50000]"] = {Level = 50000, Pos = Vector3.new(-374, 637, 8865), Island = "Snowy Mountain"},
        ["Chief Warden [Lv.1425]"] = {Level = 1425, Pos = Vector3.new(-16057, 207, 12158), Island = "UnderWater Jail"},
        ["Kudannaki [Lv.1750]"] = {Level = 1750, Pos = Vector3.new(-602, 230, 6674), Island = "Sakura Island"},
        ["Red Prince [Lv.1000]"] = {Level = 1000, Pos = Vector3.new(5318, 100, -8066), Island = "Red Centipede"},
        ["Moria [Lv.1200]"] = {Level = 1200, Pos = Vector3.new(-10421, 62, -2497), Island = "Thriller Bark"},
        ["Shadow Master [Lv.1450]"] = {Level = 1450, Pos = Vector3.new(-10022, 75, -2991), Island = "Thriller Bark"}
    },
    NormalBosses = {
        ["Naval Rating Student [Lv.10]"] = {Level = 10, Pos = Vector3.new(1089, 87, -371), Island = "Starter Island"},
        ["MyO"] = {Level = 0, Pos = Vector3.new(1549, 144, -302), Island = "Starter Island"},
        ["Luminous Admiral"] = {Level = 0, Pos = Vector3.new(-20398, 274, 499), Island = "Marineford"},
        ["Galactic Overseer"] = {Level = 0, Pos = Vector3.new(-20370, 383, 280), Island = "Marineford"},
        ["Infernal Admiral"] = {Level = 0, Pos = Vector3.new(-20328, 274, 500), Island = "Marineford"},
        ["Glacier Admiral"] = {Level = 0, Pos = Vector3.new(-20402, 274, 436), Island = "Marineford"}
    },
    SeaZones = {
        ["Zone 1"] = Vector3.new(-19800, 86, 16940),
        ["Zone 2"] = Vector3.new(-22385, 120, 19843),
        ["Zone 3"] = Vector3.new(-25180, 117, 22588),
        ["Zone 4"] = Vector3.new(-35042, 29, 31786)
    },
    Mobs = {
        ["Elf [Lv.1300]"] = {Level=1300, Pos=Vector3.new(1212, 49, 5998), Island="Rovaniemi Town"},
        ["Seaman [Lv.50]"] = {Level=50, Pos=Vector3.new(1074, 69, -3396), Island="Shell Island"},
        ["Ryuma [Lv.675]"] = {Level=675, Pos=Vector3.new(-10365, 63, -2891), Island="Thriller Bark"},
        ["Bruno [Lv.600]"] = {Level=600, Pos=Vector3.new(-6217, 51, 3846), Island="Enies Lobby"},
        ["Section Chef [Lv.475]"] = {Level=475, Pos=Vector3.new(-3358, 43, -3203), Island="Ocean Feast"},
        ["Vampire [Lv.650]"] = {Level=650, Pos=Vector3.new(-10259, 62, -2168), Island="Thriller Bark"},
        ["Rifleman [Lv.1225]"] = {Level=1225, Pos=Vector3.new(-3352, 52, 7109), Island="Marksmanship Village"},
        ["Desert Bandit [Lv.150]"] = {Level=150, Pos=Vector3.new(-5452, 54, -1272), Island="Desert Island"},
        ["SharkPirate [Lv.250]"] = {Level=250, Pos=Vector3.new(-5461, 46, -5416), Island="SharkPark"},
        ["Axe Captain [Lv.75]"] = {Level=75, Pos=Vector3.new(1007, 88, -3725), Island="Shell Island"},
        ["Lieutenant [Lv.1450]"] = {Level=1450, Pos=Vector3.new(-20096, 103, 1560), Island="Marineford"},
        ["Hydra Leader [Lv.1025]"] = {Level=1025, Pos=Vector3.new(7375, 411, -651), Island="Amazonia"},
        ["Gorilla [Lv.1150]"] = {Level=1150, Pos=Vector3.new(-1266, 61, -5808), Island="Monkey Island"},
        ["Baboon [Lv.1100]"] = {Level=1100, Pos=Vector3.new(-1283, 52, -5472), Island="Monkey Island"},
        ["Rookie [Lv.700]"] = {Level=700, Pos=Vector3.new(4217, 96, 2975), Island="Mangroveland"},
        ["SkyAssaster [Lv.400]"] = {Level=400, Pos=Vector3.new(-7715, 463, 1094), Island="SkyPark"},
        ["Hydra SwordsMan [Lv.900]"] = {Level=900, Pos=Vector3.new(8618, 189, -628), Island="Amazonia"},
        ["Captain [Lv.1600]"] = {Level=1600, Pos=Vector3.new(-20061, 105, 996), Island="Marineford"},
        ["Black Elf [Lv.1325]"] = {Level=1325, Pos=Vector3.new(1026, 68, 6470), Island="Rovaniemi Town"},
        ["Head Jailer [Lv.1375]"] = {Level=1375, Pos=Vector3.new(-15928, 131, 11976), Island="UnderWater Jail"},
        ["Guard [Lv.1]"] = {Level=1, Pos=Vector3.new(1028, 73, 334), Island="Starter Island"},
        ["Lieutenant Commander [Lv.1500]"] = {Level=1500, Pos=Vector3.new(-20505, 105, 1478), Island="Marineford"},
        ["Hydra Bandit [Lv.975]"] = {Level=975, Pos=Vector3.new(9091, 154, 145), Island="Amazonia"},
        ["Gunner [Lv.1200]"] = {Level=1200, Pos=Vector3.new(-3637, 52, 7077), Island="Marksmanship Village"},
        ["Buggy [Lv.80]"] = {Level=80, Pos=Vector3.new(4004, 60, -5254), Island="Orange Village"},
        ["Black Bandit [Lv.130]"] = {Level=130, Pos=Vector3.new(-1166, 78, 3584), Island="Dark Castle"},
        ["Chef de Cuisine [Lv.1350]"] = {Level=1350, Pos=Vector3.new(-16116, 131, 12080), Island="UnderWater Jail"},
        ["Rear Admiral [Lv.725]"] = {Level=725, Pos=Vector3.new(3773, 54, 3315), Island="Mangroveland"},
        ["Marine [Lv.525]"] = {Level=525, Pos=Vector3.new(-5464, 55, 3982), Island="Enies Lobby"},
        ["Desert Royal [Lv.200]"] = {Level=200, Pos=Vector3.new(-4907, 54, -1579), Island="Desert Island"},
        ["Pirate Hydra [Lv.850]"] = {Level=850, Pos=Vector3.new(6941, 55, -857), Island="Amazonia"},
        ["Smoky [Lv.25]"] = {Level=25, Pos=Vector3.new(966, 99, -438), Island="Starter Island"},
        ["Second Chef [Lv.500]"] = {Level=500, Pos=Vector3.new(-3413, 74, -3201), Island="Ocean Feast"},
        ["Robot [Lv.775]"] = {Level=775, Pos=Vector3.new(3565, 132, 3588), Island="Mangroveland"},
        ["Bear [Lv.825]"] = {Level=825, Pos=Vector3.new(4185, 60, 3263), Island="Mangroveland"},
        ["Zombie [Lv.625]"] = {Level=625, Pos=Vector3.new(-9815, 63, -2557), Island="Thriller Bark"},
        ["Vice Warden [Lv.1400]"] = {Level=1400, Pos=Vector3.new(-16182, 131, 12002), Island="UnderWater Jail"},
        ["Hydra Protector [Lv.875]"] = {Level=875, Pos=Vector3.new(8877, 155, -577), Island="Amazonia"},
        ["Demon [Lv.1650]"] = {Level=1650, Pos=Vector3.new(1517, 62, -6019), Island="Haunted Mansion"},
        ["Snow Bandit [Lv.105]"] = {Level=105, Pos=Vector3.new(-3215, 59, 1493), Island="Snow Island"},
        ["Demon [Lv.500]"] = {Level=500, Pos=Vector3.new(1552, 136, -327), Island="Starter Island"},
        ["Mountain Gorilla [Lv.1175]"] = {Level=1175, Pos=Vector3.new(-1662, 93, -5771), Island="Monkey Island"},
        ["Apprentice [Lv.450]"] = {Level=450, Pos=Vector3.new(-3584, 36, -3123), Island="Ocean Feast"},
        ["SkyBandit [Lv.325]"] = {Level=325, Pos=Vector3.new(-7145, 52, 696), Island="SkyPark"},
        ["Buggy Pirate [Lv.75]"] = {Level=75, Pos=Vector3.new(3985, 42, -5140), Island="Orange Village"},
        ["Hancook [Lv.1075]"] = {Level=1075, Pos=Vector3.new(8213, 411, -268), Island="Amazonia"},
        ["Thunder God [Lv.425]"] = {Level=425, Pos=Vector3.new(-7293, 637, 780), Island="SkyPark"},
        ["SkyRoyal [Lv.375]"] = {Level=375, Pos=Vector3.new(-7743, 512, 1775), Island="SkyPark"},
        ["Swordman [Lv.1250]"] = {Level=1250, Pos=Vector3.new(-3320, 55, 7168), Island="Marksmanship Village"},
        ["Yeti [Lv.115]"] = {Level=115, Pos=Vector3.new(-3550, 152, 1571), Island="Snow Island"},
        ["Spandam [Lv.575]"] = {Level=575, Pos=Vector3.new(-6521, 192, 3845), Island="Enies Lobby"},
        ["Kuro [Lv.1275]"] = {Level=1275, Pos=Vector3.new(-3659, 53, 7454), Island="Marksmanship Village"},
        ["ProSharkPirate [Lv.275]"] = {Level=275, Pos=Vector3.new(-5742, 43, -5765), Island="SharkPark"},
        ["Naval Cadet [Lv.30]"] = {Level=30, Pos=Vector3.new(785, 69, -3927), Island="Shell Island"},
        ["CP5 [Lv.550]"] = {Level=550, Pos=Vector3.new(-5810, 55, 3950), Island="Enies Lobby"},
        ["Arlung [Lv.300]"] = {Level=300, Pos=Vector3.new(-5891, 48, -5192), Island="SharkPark"},
        ["ProSkyBandit [Lv.350]"] = {Level=350, Pos=Vector3.new(-7457, 512, 1782), Island="SkyPark"},
        ["Chimpanzee [Lv.1125]"] = {Level=1125, Pos=Vector3.new(-1374, 61, -5742), Island="Monkey Island"},
        ["Alligator [Lv.225]"] = {Level=225, Pos=Vector3.new(-5646, 55, -1772), Island="Desert Island"},
        ["Master Hydra [Lv.1000]"] = {Level=1000, Pos=Vector3.new(7764, 408, 139), Island="Amazonia"},
        ["Hydra Caption [Lv.925]"] = {Level=925, Pos=Vector3.new(8688, 157, -220), Island="Amazonia"}
    },
    NPCs = {
        ["Arctic"] = {Pos=Vector3.new(835, 131, 6652), Island="Rovaniemi Town"}, ["Clara"] = {Pos=Vector3.new(7342, 408, -41), Island="Amazonia"},
        ["Linetta"] = {Pos=Vector3.new(1264, 102, 285), Island="Starter Island"}, ["Betty"] = {Pos=Vector3.new(-3512, 129, 1131), Island="Snow Island"},
        ["Sebastia"] = {Pos=Vector3.new(1330, 106, 6809), Island="Rovaniemi Town"}, ["Quest Giver 25"] = {Pos=Vector3.new(1365, 62, -5879), Island="Haunted Mansion"},
        ["Cecil"] = {Pos=Vector3.new(-16096, 116, 12341), Island="UnderWater Jail"}, ["Yuno"] = {Pos=Vector3.new(853, 68, -3484), Island="Shell Island"},
        ["Percy"] = {Pos=Vector3.new(-16057, 423, 11503), Island="UnderWater Jail"}, ["Melina"] = {Pos=Vector3.new(-3479, 52, 7128), Island="Marksmanship Village"},
        ["Cashier"] = {Pos=Vector3.new(-1279, 52, -797), Island="Shopland"}, ["SetSpawnPoint 15"] = {Pos=Vector3.new(-1416, 37, -5309), Island="Monkey Island"},
        ["Cleak"] = {Pos=Vector3.new(1004, 85, -3568), Island="Shell Island"}, ["Luna"] = {Pos=Vector3.new(7420, 408, -37), Island="Amazonia"},
        ["SetSpawnPoint 5"] = {Pos=Vector3.new(-1473, 77, 3520), Island="Dark Castle"}, ["SetSpawnPoint 9"] = {Pos=Vector3.new(-3435, 108, -3197), Island="Ocean Feast"},
        ["Lily"] = {Pos=Vector3.new(1357, 102, -209), Island="Starter Island"}, ["The person behind the door"] = {Pos=Vector3.new(952, 68, 6469), Island="Rovaniemi Town"},
        ["SetSpawnPoint 8"] = {Pos=Vector3.new(-7354, 323, 1396), Island="SkyPark"}, ["Arthur"] = {Pos=Vector3.new(-15972, 92, 11908), Island="UnderWater Jail"},
        ["SetSpawnPoint 10"] = {Pos=Vector3.new(-5344, 55, 3902), Island="Enies Lobby"}, ["Quest Giver 2"] = {Pos=Vector3.new(826, 80, -3711), Island="Shell Island"},
        ["Stone Statue"] = {Pos=Vector3.new(-1382, 77, 3901), Island="Dark Castle"}, ["Roland"] = {Pos=Vector3.new(-9535, 63, -2596), Island="Thriller Bark"},
        ["Ember"] = {Pos=Vector3.new(1291, 62, -5827), Island="Haunted Mansion"}, ["Richard"] = {Pos=Vector3.new(-15945, 58, 12165), Island="UnderWater Jail"},
        ["BoatSpawner"] = {Pos=Vector3.new(3943, 42, -4756), Island="Orange Village"}, ["Quest Giver 23"] = {Pos=Vector3.new(-15989, 132, 12112), Island="UnderWater Jail"},
        ["Neko"] = {Pos=Vector3.new(-3154, 60, 1432), Island="Snow Island"}, ["Quest Giver 14"] = {Pos=Vector3.new(-5962, 55, 3886), Island="Enies Lobby"},
        ["Stale"] = {Pos=Vector3.new(857, 68, 6521), Island="Rovaniemi Town"}, ["Gilligan"] = {Pos=Vector3.new(4246, 77, -5056), Island="Orange Village"},
        ["SetSpawnPoint 14"] = {Pos=Vector3.new(7317, 408, -483), Island="Amazonia"}, ["Shizui Master"] = {Pos=Vector3.new(-5423, 285, -1581), Island="Desert Island"},
        ["Quest Giver 4"] = {Pos=Vector3.new(-3476, 164, 1329), Island="Snow Island"}, ["James"] = {Pos=Vector3.new(-16168, 92, 11937), Island="UnderWater Jail"},
        ["Michael"] = {Pos=Vector3.new(-16146, 102, 12055), Island="UnderWater Jail"}, ["Quest Giver 17"] = {Pos=Vector3.new(6588, 67, -828), Island="Amazonia"},
        ["Charlotte"] = {Pos=Vector3.new(7292, 138, 482), Island="Amazonia"}, ["Trent"] = {Pos=Vector3.new(-6076, 168, -5948), Island="SharkPark"},
        ["Lantern Seller"] = {Pos=Vector3.new(1078, 87, 27), Island="Starter Island"}, ["William"] = {Pos=Vector3.new(-16057, 356, 11929), Island="UnderWater Jail"},
        ["Dazzl"] = {Pos=Vector3.new(-1370, 79, 3985), Island="Dark Castle"}, ["SetSpawnPoint 16"] = {Pos=Vector3.new(-3749, 52, 6918), Island="Marksmanship Village"},
        ["SetSpawnPoint 4"] = {Pos=Vector3.new(-3260, 59, 1485), Island="Snow Island"}, ["Shay"] = {Pos=Vector3.new(3849, 77, -5223), Island="Orange Village"},
        ["Quest Giver 18"] = {Pos=Vector3.new(8890, 154, -335), Island="Amazonia"}, ["Remaruki"] = {Pos=Vector3.new(-710, 306, 6956), Island="Sakura Island"},
        ["SetSpawnPoint 7"] = {Pos=Vector3.new(-5677, 47, -5103), Island="SharkPark"}, ["Finn"] = {Pos=Vector3.new(4367, 105, -5246), Island="Orange Village"},
        ["Old Man"] = {Pos=Vector3.new(-3700, 51, 6978), Island="Marksmanship Village"}, ["Karate Master"] = {Pos=Vector3.new(-5904, 150, -5271), Island="SharkPark"},
        ["Quest Giver 3"] = {Pos=Vector3.new(3944, 42, -5093), Island="Orange Village"}, ["Philips"] = {Pos=Vector3.new(-6151, 65, 4065), Island="Enies Lobby"},
        ["Quest Giver 19"] = {Pos=Vector3.new(7410, 408, -482), Island="Amazonia"}, ["Babo"] = {Pos=Vector3.new(1419, 93, 6737), Island="Rovaniemi Town"},
        ["SetSpawnPoint 18"] = {Pos=Vector3.new(-19882, 104, 604), Island="Marineford"}, ["Petty Officer First Class"] = {Pos=Vector3.new(1064, 86, -3544), Island="Shell Island"},
        ["Quest Giver 11"] = {Pos=Vector3.new(-7645, 481, 1115), Island="SkyPark"}, ["John"] = {Pos=Vector3.new(-16183, 57, 12070), Island="UnderWater Jail"},
        ["Rosary"] = {Pos=Vector3.new(-9882, 62, -2848), Island="Thriller Bark"}, ["Bright"] = {Pos=Vector3.new(1223, 48, 6062), Island="Rovaniemi Town"},
        ["LogPose Seller"] = {Pos=Vector3.new(-16193, 92, 12140), Island="UnderWater Jail"}, ["Quest Giver 7"] = {Pos=Vector3.new(-5670, 48, -5506), Island="SharkPark"},
        ["Mrak"] = {Pos=Vector3.new(760, 68, -3630), Island="Shell Island"}, ["BlackLeg Teacher"] = {Pos=Vector3.new(-3401, 321, -3090), Island="Ocean Feast"},
        ["FruitShop"] = {Pos=Vector3.new(1480, 128, -6), Island="Starter Island"}, ["Mia"] = {Pos=Vector3.new(6457, 88, 63), Island="Amazonia"},
        ["Carter"] = {Pos=Vector3.new(-7426, 636, 705), Island="SkyPark"}, ["xdggkit"] = {Pos=Vector3.new(838, 63, -250), Island="Starter Island"},
        ["Joseph"] = {Pos=Vector3.new(-16196, 54, 12171), Island="UnderWater Jail"}, ["Shion"] = {Pos=Vector3.new(-5642, 55, -1532), Island="Desert Island"},
        ["Bernard"] = {Pos=Vector3.new(-16174, 54, 12171), Island="UnderWater Jail"}, ["Poppy"] = {Pos=Vector3.new(9471, 36, 1078), Island="Amazonia"},
        ["Diego"] = {Pos=Vector3.new(1442, 51, 6237), Island="Rovaniemi Town"}, ["Belle"] = {Pos=Vector3.new(958, 67, 6456), Island="Rovaniemi Town"},
        ["Travis"] = {Pos=Vector3.new(-5332, 54, -1517), Island="Desert Island"}, ["Thragg"] = {Pos=Vector3.new(-1469, 77, 3976), Island="Dark Castle"},
        ["SetSpawnPoint 2"] = {Pos=Vector3.new(736, 69, -3558), Island="Shell Island"}, ["thai_TH3"] = {Pos=Vector3.new(-6414, 122, 3480), Island="Enies Lobby"},
        ["Quest Giver 15"] = {Pos=Vector3.new(-9567, 63, -2606), Island="Thriller Bark"}, ["Haki Editor"] = {Pos=Vector3.new(1401, 160, -90), Island="Starter Island"},
        ["Shadow 1"] = {Pos=Vector3.new(-10367, 100, -3518), Island="Thriller Bark"}, ["Jimmie"] = {Pos=Vector3.new(797, 51, 6168), Island="Rovaniemi Town"},
        ["Nerine"] = {Pos=Vector3.new(9116, 154, -832), Island="Amazonia"}, ["Waco"] = {Pos=Vector3.new(-6123, 73, 3633), Island="Enies Lobby"},
        ["Rio"] = {Pos=Vector3.new(-1283, 232, 4145), Island="Dark Castle"}, ["Vincent"] = {Pos=Vector3.new(-6370, 107, 4095), Island="Enies Lobby"},
        ["Elias"] = {Pos=Vector3.new(-9529, 62, -2410), Island="Thriller Bark"}, ["Quest Giver 13"] = {Pos=Vector3.new(-5580, 55, 3789), Island="Enies Lobby"},
        ["Nico"] = {Pos=Vector3.new(967, 335, -5701), Island="Haunted Mansion"}, ["Payton"] = {Pos=Vector3.new(-9666, 143, -3481), Island="Thriller Bark"},
        ["FALC0N_ST"] = {Pos=Vector3.new(-4035, 58, 7123), Island="Marksmanship Village"}, ["SetSpawnPoint 17"] = {Pos=Vector3.new(-15934, 54, 11971), Island="UnderWater Jail"},
        ["Edward"] = {Pos=Vector3.new(-15938, 92, 12168), Island="UnderWater Jail"}, ["Mina"] = {Pos=Vector3.new(-3738, 52, 7157), Island="Marksmanship Village"},
        ["KenHaki"] = {Pos=Vector3.new(-7883, 816, 497), Island="SkyPark"}, ["KINGNONKD"] = {Pos=Vector3.new(-6496, 108, 4195), Island="Enies Lobby"},
        ["Cherry"] = {Pos=Vector3.new(-3460, 152, 1728), Island="Snow Island"}, ["Pipe seller"] = {Pos=Vector3.new(990, 106, -3549), Island="Shell Island"},
        ["SetSpawnPoint 11"] = {Pos=Vector3.new(-9445, 63, -2552), Island="Thriller Bark"}, ["SaraburiTokyo"] = {Pos=Vector3.new(1121, 109, 494), Island="Starter Island"},
        ["Vexa"] = {Pos=Vector3.new(7544, 408, -31), Island="Amazonia"}, ["Quest Giver 1"] = {Pos=Vector3.new(1178, 101, -57), Island="Starter Island"},
        ["Blacksmith"] = {Pos=Vector3.new(1314, 100, 235), Island="Starter Island"}, ["Stats Reset"] = {Pos=Vector3.new(797, 64, -123), Island="Starter Island"},
        ["Quest Giver 20"] = {Pos=Vector3.new(-1461, 56, -5587), Island="Monkey Island"}, ["Quest Giver 12"] = {Pos=Vector3.new(-3478, 74, -3203), Island="Ocean Feast"},
        ["Vanessa"] = {Pos=Vector3.new(-5529, 55, -1795), Island="Desert Island"}, ["Kalea"] = {Pos=Vector3.new(7568, 408, -469), Island="Amazonia"},
        ["Sword Seller"] = {Pos=Vector3.new(1076, 87, -42), Island="Starter Island"}, ["Frederick"] = {Pos=Vector3.new(-16216, 92, 12174), Island="UnderWater Jail"},
        ["Quest Giver 21"] = {Pos=Vector3.new(-3648, 52, 7174), Island="Marksmanship Village"}, ["Quest Giver 5"] = {Pos=Vector3.new(-1240, 90, 3442), Island="Dark Castle"},
        ["Robert"] = {Pos=Vector3.new(-15948, 92, 12034), Island="UnderWater Jail"}, ["The person behind the door 2"] = {Pos=Vector3.new(-9972, 143, -2389), Island="Thriller Bark"},
        ["SetSpawnPoint 3"] = {Pos=Vector3.new(3895, 42, -4957), Island="Orange Village"}, ["Alias Changer"] = {Pos=Vector3.new(1224, 104, 221), Island="Starter Island"},
        ["Winter Retainer"] = {Pos=Vector3.new(1364, 125, 27765), Island="Tundra"}, ["RandomFruits"] = {Pos=Vector3.new(1504, 160, -1), Island="Starter Island"},
        ["Awakenings Toggle"] = {Pos=Vector3.new(1400, 160, 74), Island="Starter Island"}, ["SetSpawnPoint 1"] = {Pos=Vector3.new(1417, 128, 21), Island="Starter Island"},
        ["Henry"] = {Pos=Vector3.new(-15945, 92, 11980), Island="UnderWater Jail"}, ["Lieutenant Commander"] = {Pos=Vector3.new(1056, 115, -3552), Island="Shell Island"},
        ["Asgore"] = {Pos=Vector3.new(-6297, 92, 3613), Island="Enies Lobby"}, ["Small Gumiho"] = {Pos=Vector3.new(-3748, 185, 1352), Island="Snow Island"},
        ["DeLand"] = {Pos=Vector3.new(798, 64, 102), Island="Starter Island"}
    }
}

-- MẢNG ARRAY DATA UI CÓ SẴN
local ListWorldBoss = {}
for k, _ in pairs(CoordDB.WorldBosses) do table.insert(ListWorldBoss, k) end
table.sort(ListWorldBoss)

local ListNormalBoss = {}
for k, _ in pairs(CoordDB.NormalBosses) do table.insert(ListNormalBoss, k) end
table.sort(ListNormalBoss)

local ListNPCs = {}
for name, data in pairs(CoordDB.NPCs) do table.insert(ListNPCs, string.format("[%s] %s", data.Island, name)) end
table.sort(ListNPCs)

-- QUÁI CHIA ĐẢO CÓ CẦU VỒNG
local IslandMobs = {}
for name, data in pairs(CoordDB.Mobs) do
    if not IslandMobs[data.Island] then IslandMobs[data.Island] = {} end
    table.insert(IslandMobs[data.Island], {Name = name, Level = data.Level})
end
local sortedIslands = {}
for isl, _ in pairs(IslandMobs) do table.insert(sortedIslands, isl) end
table.sort(sortedIslands)

local function ToRainbow(text)
    local colors = {"#ff5555", "#ffaa00", "#ffff55", "#55ff55", "#55ffff", "#aaaaff", "#ff55ff"}
    local res = ""; local cIdx = 1
    for i = 1, #text do
        local char = text:sub(i,i)
        if char ~= " " then res = res .. string.format('<font color="%s">%s</font>', colors[cIdx], char); cIdx = cIdx + 1; if cIdx > #colors then cIdx = 1 end
        else res = res .. " " end
    end
    return res
end

local ListMobs = {}
for _, isl in ipairs(sortedIslands) do
    table.insert(ListMobs, {Value = "HEADER_" .. isl, Display = string.format("<font color='#55ff55'><b>=== 🏝️ ĐẢO: %s ===</b></font>", string.upper(isl))})
    local mobs = IslandMobs[isl]
    table.sort(mobs, function(a, b) return a.Level > b.Level end)
    for i, m in ipairs(mobs) do
        local rawName = string.format("[%s] %s", isl, m.Name)
        if i == 1 then table.insert(ListMobs, {Value = rawName, Display = string.format("<font size='13'><b>%s</b></font>", ToRainbow("★ " .. rawName .. " (MAX)"))})
        else table.insert(ListMobs, {Value = rawName, Display = "<font color='#cccccc'>" .. rawName .. "</font>"}) end
    end
end

local QuestDB = {
    {Level = 1, QuestName = "Bandit [Lv. 1]", MobName = "Bandit"}, {Level = 10, QuestName = "Naval Student [Lv. 10]", MobName = "Naval Rating Student"}, {Level = 30, QuestName = "Pirate [Lv. 30]", MobName = "Pirate"},
}
local QuestListNames = {}; for i, v in ipairs(QuestDB) do table.insert(QuestListNames, v.QuestName) end

local DefaultConfig = {
    AutoFarmFree = false, FarmAll = false, SelectedMonsters = {}, ExcludedMobs = {"dummy", "test dmg", "testdmg"},
    AutoFarmLevel = false, ManualQuestFarm = false, SelectedManualQuest = nil, CurrentTargetMob = nil,
    AutoEquip = false, AutoClick = false, AutoSkill = false, AutoRepeatQuest = false,
    Skill_Z = false, Skill_X = false, Skill_C = false, Skill_V = false, Skill_F = false,
    AutoHaki = false, AutoKen = false, SelectedWeapon = nil, SelectedFruit = nil,
    AttackPosition = "Trên Đầu", AttackDistance = 15, FlySpeed = 250,
    PrimaryWeapon = nil, HoldTime1 = 3, W1_Z = false, W1_X = false, W1_C = false, W1_V = false, W1_B = false, W1_F = false,
    SecondaryWeapon = nil, HoldTime2 = 0.5, W2_Z = false, W2_X = false, W2_C = false, W2_V = false, W2_B = false, W2_F = false,
    AutoSwapWeapon = false, SkillSpamDelay = 0.1, AutoSea = false, HuntSeaMonster = true, HuntGhost = true, AutoSitBoat = true, 
    SeaZone = Vector3.new(-15610, 39, 37071), SelectedSeaZone = "Zone 1", IsFightingSea = false, ArrivedAtZone = false,
    
    AutoBuyWorldRaid = false, WorldRaidLocation = "Out (Ngoài Map)", AutoBuyRaid = false, AutoStartRaid = false, AutoJoinGame = false, AutoFarmRaid = false, AutoSunBattery = false,
    AutoTeleEntrance = false, AutoTeleReRaid = false, RaidEntranceDelay = 2, RaidReRaidDelay = 2, RaidBuyTeleportDelay = 2, RaidWaitC1 = "10", RaidWaitC2 = "10", RaidWaitC3 = "15",
    
    -- BOSS RAID THÔNG MINH
    AutoFarmBossRaid = false, SelectedRaidBosses = {}, AlwaysSpinPzozo = false, PzozoSpinRadius = 30, PzozoSpinSpeed = 3,
    AutoIdlePatrol = false, IdleWait1 = "10", IdleWait2 = "10",
    
    -- GLOBAL SAFE HP
    GlobalSafeHP = false, GlobalSafeHP_Min = 30, GlobalSafeHP_Timer = false, GlobalSafeHP_Time = 15, GlobalSafeHP_Spin = true, GlobalDodgeRadius = 50,
    
    AutoBypassMenu = true, BypassDuration = 10,
    AutoCoordMob = false, SelectedCoordMobs = {}, AutoWorldBoss = false, SelectedWorldBosses = {}, AutoNormalBoss = false, SelectedNormalBosses = {}, BossCheckDelay = 5,
    AutoSpawnMihawk = false, MihawkAmount = "x1", AutoGiveShadow = false, ShadowItem = "Shadow Spirit", ShadowAmount = "x1",
    
    SelectedIsland = nil, SelectedSpawnPoint = nil, SelectedNPC = nil,
    AutoPatrolIsland = false, SelectedPatrolIslands = {}, PatrolIslandTime = 30, PatrolIslandRadius = 150, PatrolIslandSpeed = 5, PatrolIslandHeight = 0,
    
    EnableSpeed = false, WalkSpeed = 50, EnableJump = false, JumpPower = 100, InfJump = false, DashNoCD = false, FreeFly = false, FreeFlySpeed = 50, AutoJump = false, Noclip = false, WaterWalk = false,
    AutoSaveConfig = false, AutoLoadConfig = false, SelectedConfig = "DefaultConfig", AutoScanMap = false, EnableBlackScreen = false, AntiAFK = false, ScanMode = "Tất Cả",
    ScannedMonstersList = {}, ScannerData = {Mobs = {}, Bosses = {}, NPCs = {}}
}

local _G_V10 = {}
for k, v in pairs(DefaultConfig) do _G_V10[k] = v end
local _G_UI_Updaters = {}

local ConfigFolder = "YuiHub_Configs"
local MasterFile = ConfigFolder .. "/MasterSettings.json"
if isfolder and not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

local function RenderScannerLog()
    if not ScanLogFrame then return end
    for _, v in pairs(ScanLogFrame:GetChildren()) do if v:IsA("Frame") or v:IsA("TextLabel") then v:Destroy() end end
    
    local function AddChunk(title, content)
        if content == "" then return end
        local chunkText = string.format("=== %s ===\n%s", title, content)
        local chunkFrame = Instance.new("Frame", ScanLogFrame); chunkFrame.Size = UDim2.new(1, -10, 0, 100); chunkFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Instance.new("UICorner", chunkFrame).CornerRadius = UDim.new(0, 6)
        local txt = Instance.new("TextBox", chunkFrame); txt.Size = UDim2.new(1, -50, 1, -10); txt.Position = UDim2.new(0, 5, 0, 5); txt.BackgroundTransparency = 1; txt.Text = chunkText; txt.TextColor3 = Color3.fromRGB(220, 220, 220); txt.Font = Enum.Font.Code; txt.TextSize = 10; txt.TextXAlignment = Enum.TextXAlignment.Left; txt.TextYAlignment = Enum.TextYAlignment.Top; txt.ClearTextOnFocus = false; txt.TextEditable = false; txt.TextWrapped = true
        local copyBtn = Instance.new("TextButton", chunkFrame); copyBtn.Size = UDim2.new(0, 40, 0, 40); copyBtn.Position = UDim2.new(1, -45, 0.5, -20); copyBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255); copyBtn.Text = "COPY"; copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255); copyBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)
        copyBtn.MouseButton1Click:Connect(function() if setclipboard then setclipboard(chunkText); copyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100); copyBtn.Text = "OK"; task.wait(1); copyBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255); copyBtn.Text = "COPY" end end)
        txt:GetPropertyChangedSignal("TextBounds"):Connect(function() chunkFrame.Size = UDim2.new(1, -10, 0, math.max(60, txt.TextBounds.Y + 20)) end)
    end
    
    local hasData = false
    local bStr = ""
    if _G_V10.ScannerData.Bosses then for k, v in pairs(_G_V10.ScannerData.Bosses) do bStr = bStr .. string.format("[%s] | %s (HP: %s) | %s\n", v.Island, k, v.Level, v.Pos); hasData = true end end
    AddChunk("👹 DANH SÁCH BOSS", bStr)
    
    local mLines = {}
    if _G_V10.ScannerData.Mobs then for k, v in pairs(_G_V10.ScannerData.Mobs) do table.insert(mLines, string.format("[%s] | %s | %s", v.Island, k, v.Pos)); hasData = true end end
    local chunkSize = 15
    for i = 1, #mLines, chunkSize do
        local chunkStr = ""
        for j = i, math.min(i + chunkSize - 1, #mLines) do chunkStr = chunkStr .. mLines[j] .. "\n" end
        AddChunk("👾 QUÁI (PHẦN " .. math.ceil(i/chunkSize) .. ")", chunkStr)
    end
    
    local nStr = ""
    if _G_V10.ScannerData.NPCs then for k, v in pairs(_G_V10.ScannerData.NPCs) do nStr = nStr .. string.format("[%s] | %s | %s\n", v.Island, k, v.Pos); hasData = true end end
    AddChunk("🛒 DANH SÁCH NPC", nStr)
    
    if not hasData then
        local emptyLbl = Instance.new("TextLabel", ScanLogFrame)
        emptyLbl.Size = UDim2.new(1, -10, 0, 50); emptyLbl.BackgroundTransparency = 1; emptyLbl.Text = "Đang chờ dữ liệu quét... (Hãy bật Máy Quét và đợi)"; emptyLbl.TextColor3 = Color3.fromRGB(150, 150, 150); emptyLbl.Font = Enum.Font.Gotham; emptyLbl.TextSize = 12
    end
end

local function SaveConfig(name)
    if not writefile then return end
    name = name or "DefaultConfig"; _G_V10.SelectedConfig = name
    writefile(ConfigFolder.."/"..name..".json", HttpService:JSONEncode(_G_V10))
    writefile(MasterFile, HttpService:JSONEncode({AutoLoadConfig = _G_V10.AutoLoadConfig, LastConfig = name}))
end

local function LoadConfig(name)
    if not readfile or not isfile(ConfigFolder.."/"..name..".json") then return end
    local s, decoded = pcall(function() return HttpService:JSONDecode(readfile(ConfigFolder.."/"..name..".json")) end)
    if s and type(decoded) == "table" then
        for k, v in pairs(decoded) do _G_V10[k] = v end
        if not _G_V10.ScannerData then _G_V10.ScannerData = {Mobs = {}, Bosses = {}, NPCs = {}} end
        for _, updater in pairs(_G_UI_Updaters) do pcall(updater) end
        RenderScannerLog()
    end
end

if readfile and isfile(MasterFile) then
    local s, masterData = pcall(function() return HttpService:JSONDecode(readfile(MasterFile)) end)
    if s and type(masterData) == "table" and masterData.AutoLoadConfig and masterData.LastConfig then _G_V10.AutoLoadConfig = true; LoadConfig(masterData.LastConfig) end
end
local function AutoSaveTrigger() if _G_V10.AutoSaveConfig then SaveConfig(_G_V10.SelectedConfig) end end
local function GetConfigsList()
    local list = {}
    if listfiles and isfolder(ConfigFolder) then for _, file in pairs(listfiles(ConfigFolder)) do local name = file:match("([^/%\\]+)%.json$") or file; if name ~= "MasterSettings" then table.insert(list, name) end end end 
    return list
end

-- ==========================================
-- GIAO DIỆN CHÍNH
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", SafeParent)
ScreenGui.Name = "YuiHub_UI"; ScreenGui.ResetOnSpawn = false

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50); ToggleBtn.Position = UDim2.new(0, 15, 0.5, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25); ToggleBtn.Text = "🌸"; ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 200); ToggleBtn.Font = Enum.Font.GothamBold; ToggleBtn.TextSize = 25
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0); Instance.new("UIStroke", ToggleBtn).Color = Color3.fromRGB(255, 100, 200)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 50, 0, 50); MainFrame.Position = UDim2.new(0.5, -25, 0.5, -25)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); MainFrame.BackgroundTransparency = 0.1; MainFrame.ClipsDescendants = true; MainFrame.Visible = false 
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 25); Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 100, 200)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 50); TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15); TopBar.BackgroundTransparency = 1; TopBar.Visible = false
local DragPad = Instance.new("TextButton", TopBar)
DragPad.Size = UDim2.new(1, -150, 1, 0); DragPad.BackgroundTransparency = 1; DragPad.Text = ""

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0.4, 0, 1, 0); Title.Position = UDim2.new(0, 20, 0, 0); Title.BackgroundTransparency = 1; Title.RichText = true
Title.Text = "🌸 YuiHub <font size='12' color='#aaaaaa'><i>- Chào mừng đến với hub của tôi</i></font>"
Title.TextColor3 = Color3.fromRGB(255, 100, 200); Title.Font = Enum.Font.GothamBold; Title.TextSize = 18; Title.TextXAlignment = Enum.TextXAlignment.Left

local ServerUptimeLbl = Instance.new("TextLabel", TopBar)
ServerUptimeLbl.Size = UDim2.new(0.3, 0, 1, 0); ServerUptimeLbl.Position = UDim2.new(0.45, 0, 0, 0); ServerUptimeLbl.BackgroundTransparency = 1; ServerUptimeLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
ServerUptimeLbl.Font = Enum.Font.GothamBold; ServerUptimeLbl.TextSize = 14; ServerUptimeLbl.TextXAlignment = Enum.TextXAlignment.Right
table.insert(_G.YuiConnections, RunService.Stepped:Connect(function()
    if _G.YuiKillAllLoops then return end
    local t = workspace.DistributedGameTime
    local h = math.floor(t / 3600); local m = math.floor((t % 3600) / 60); local s = math.floor(t % 60)
    ServerUptimeLbl.Text = string.format("🕒 Server Uptime: %02d:%02d:%02d", h, m, s)
end))

_G.IsPinned = false
local PinBtn = Instance.new("TextButton", TopBar)
PinBtn.Size = UDim2.new(0, 35, 0, 35); PinBtn.Position = UDim2.new(1, -120, 0, 7.5); PinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
PinBtn.Text = "📌"; PinBtn.TextColor3 = Color3.fromRGB(255, 255, 255); PinBtn.Font = Enum.Font.GothamBold; PinBtn.TextSize = 18; Instance.new("UICorner", PinBtn).CornerRadius = UDim.new(1, 0)
PinBtn.MouseButton1Click:Connect(function()
    _G.IsPinned = not _G.IsPinned; MainFrame.Draggable = not _G.IsPinned
    PinBtn.BackgroundColor3 = _G.IsPinned and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 50, 55); PinBtn.Text = _G.IsPinned and "📍" or "📌"
end)

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 35, 0, 35); MinBtn.Position = UDim2.new(1, -75, 0, 7.5); MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55); MinBtn.Text = "-"; MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 24; Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1, 0)

local function KillAllScriptsAndUI()
    _G.YuiKillAllLoops = true
    if _G.YuiConnections then for _, conn in pairs(_G.YuiConnections) do pcall(function() conn:Disconnect() end) end end
    _G.YuiConnections = {}
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        if hrp:FindFirstChild("FarmAntiFall") then hrp.FarmAntiFall:Destroy() end
        if hrp:FindFirstChild("V10_FreeFlyBV") then hrp.V10_FreeFlyBV:Destroy() end
        for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = true end end
    end
    if ScreenGui then ScreenGui:Destroy() end
end

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 35, 0, 35); CloseBtn.Position = UDim2.new(1, -35, 0, 7.5); CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 16; Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
CloseBtn.MouseButton1Click:Connect(KillAllScriptsAndUI)

local TabsFrame = Instance.new("ScrollingFrame", MainFrame)
TabsFrame.Name = "TabsFrame"; TabsFrame.Size = UDim2.new(0.28, 0, 1, -50); TabsFrame.Position = UDim2.new(0, 0, 0, 50); TabsFrame.BackgroundTransparency = 1; TabsFrame.ScrollBarThickness = 2; TabsFrame.CanvasSize = UDim2.new(0, 0, 0, 850); Instance.new("UIListLayout", TabsFrame).Padding = UDim.new(0, 5); Instance.new("UIPadding", TabsFrame).PaddingTop = UDim.new(0, 5); Instance.new("UIPadding", TabsFrame).PaddingLeft = UDim.new(0, 10); TabsFrame.Visible = false

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Name = "ContentFrame"; ContentFrame.Size = UDim2.new(0.72, -10, 1, -60); ContentFrame.Position = UDim2.new(0.28, 0, 0, 50); ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); ContentFrame.BackgroundTransparency = 0.5; Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0, 15); ContentFrame.Visible = false

local dragging, dragInput, dragStart, startPos
DragPad.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not _G.IsPinned then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
DragPad.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging and not _G.IsPinned then
        local delta = input.Position - dragStart
        TweenService:Create(MainFrame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
    end
end)

local function CloseMenuAnimation()
    TabsFrame.Visible = false; ContentFrame.Visible = false
    local tw1 = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 620, 0, 50), Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, 0.5, -25)})
    tw1:Play(); tw1.Completed:Wait(); TopBar.Visible = false
    local tw2 = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0.5, -25, 0.5, -25)})
    tw2:Play(); tw2.Completed:Wait(); MainFrame.Visible = false
end

ToggleBtn.MouseButton1Click:Connect(function()
    if MainFrame.Visible then CloseMenuAnimation()
    else
        MainFrame.Size = UDim2.new(0, 50, 0, 50); MainFrame.Position = UDim2.new(0.5, -25, 0.5, -25); MainFrame.Visible = true
        local tw1 = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 620, 0, 50), Position = UDim2.new(0.5, -310, 0.5, -25)})
        tw1:Play(); tw1.Completed:Wait(); TopBar.Visible = true
        local tw2 = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 620, 0, 420), Position = UDim2.new(0.5, -310, 0.5, -210)})
        tw2:Play(); tw2.Completed:Wait(); TabsFrame.Visible = true; ContentFrame.Visible = true
    end
end)

MinBtn.MouseButton1Click:Connect(function()
    local isMin = MainFrame.Size.Y.Offset == 50
    if not isMin then TabsFrame.Visible = false; ContentFrame.Visible = false end
    local tw = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = isMin and UDim2.new(0, 620, 0, 420) or UDim2.new(0, 620, 0, 50),
        Position = isMin and UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, 0.5, -210) or UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, 0.5, -25)
    })
    tw:Play(); if isMin then tw.Completed:Connect(function() TabsFrame.Visible = true; ContentFrame.Visible = true end) end
end)

-- ==========================================
-- HÀM TẠO UI COMPONENTS
-- ==========================================
local Pages = {}
local function CreateTab(name)
    local Btn = Instance.new("TextButton", TabsFrame)
    Btn.Size = UDim2.new(1, -10, 0, 40); Btn.Position = UDim2.new(0, 5, 0, 0); Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Btn.TextColor3 = Color3.fromRGB(200, 200, 200); Btn.Text = "  " .. name; Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 12; Btn.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
    local Page = Instance.new("ScrollingFrame", ContentFrame)
    Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.ScrollBarThickness = 2; Page.Visible = false
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    local pad = Instance.new("UIPadding", Page); pad.PaddingTop, pad.PaddingLeft, pad.PaddingRight, pad.PaddingBottom = UDim.new(0,10), UDim.new(0,10), UDim.new(0,10), UDim.new(0,10)
    Pages[name] = {Btn = Btn, Page = Page}
    Btn.MouseButton1Click:Connect(function()
        for n, p in pairs(Pages) do
            p.Page.Visible = (n == name)
            p.Btn.BackgroundColor3 = (n == name) and Color3.fromRGB(255, 100, 200) or Color3.fromRGB(30, 30, 35)
            p.Btn.TextColor3 = (n == name) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        end
    end)
    return Page
end

local function CreateSection(parent, title, color)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 0); Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", Frame).Color = color or Color3.fromRGB(100, 100, 100)
    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(1, -10, 0, 25); Lbl.Position = UDim2.new(0, 10, 0, 5); Lbl.BackgroundTransparency = 1; Lbl.Text = "✦ " .. title; Lbl.TextColor3 = color or Color3.fromRGB(255, 255, 255); Lbl.Font = Enum.Font.GothamBold; Lbl.TextSize = 13; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    local Content = Instance.new("Frame", Frame)
    Content.Size = UDim2.new(1, -10, 1, -30); Content.Position = UDim2.new(0, 5, 0, 30); Content.BackgroundTransparency = 1
    local Layout = Instance.new("UIListLayout", Content); Layout.Padding = UDim.new(0, 5)
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Frame.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y + 40)
        if parent:IsA("ScrollingFrame") then local pLayout = parent:FindFirstChildOfClass("UIListLayout"); if pLayout then parent.CanvasSize = UDim2.new(0, 0, 0, pLayout.AbsoluteContentSize.Y + 20) end end
    end)
    return Content
end

local function CreateToggleSwitch(parent, text, varName, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 40); Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40); Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(0.7, 0, 1, 0); Lbl.Position = UDim2.new(0, 10, 0, 0); Lbl.BackgroundTransparency = 1; Lbl.Text = text; Lbl.TextColor3 = Color3.fromRGB(255, 255, 255); Lbl.Font = Enum.Font.Gotham; Lbl.TextSize = 12; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    local SwitchBG = Instance.new("TextButton", Frame)
    SwitchBG.Size = UDim2.new(0, 40, 0, 20); SwitchBG.Position = UDim2.new(1, -50, 0.5, -10); SwitchBG.BackgroundColor3 = Color3.fromRGB(100, 100, 100); SwitchBG.Text = ""; Instance.new("UICorner", SwitchBG).CornerRadius = UDim.new(1, 0)
    local Knob = Instance.new("Frame", SwitchBG)
    Knob.Size = UDim2.new(0, 16, 0, 16); Knob.Position = UDim2.new(0, 2, 0.5, -8); Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local function UpdateVisuals()
        local state = _G_V10[varName]; SwitchBG.BackgroundColor3 = state and Color3.fromRGB(255, 100, 200) or Color3.fromRGB(100, 100, 100)
        Knob:TweenPosition(state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), "Out", "Quad", 0.2, true)
    end
    _G_UI_Updaters[varName] = UpdateVisuals
    SwitchBG.MouseButton1Click:Connect(function()
        _G_V10[varName] = not _G_V10[varName]; UpdateVisuals(); if varName == "AutoLoadConfig" then SaveConfig(_G_V10.SelectedConfig) end
        AutoSaveTrigger(); if callback then callback(_G_V10[varName]) end
    end)
    UpdateVisuals()
end

local function CreateDropdown(parent, title, itemsList, globalVar, multiSelect, showOrder)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 35); Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40); Frame.ClipsDescendants = true; Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    local MainBtn = Instance.new("TextButton", Frame)
    MainBtn.Size = UDim2.new(1, 0, 0, 35); MainBtn.BackgroundTransparency = 1; MainBtn.Text = "  " .. title .. " ▼"; MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255); MainBtn.Font = Enum.Font.Gotham; MainBtn.TextSize = 12; MainBtn.TextXAlignment = Enum.TextXAlignment.Left; MainBtn.RichText = true
    local Drop = Instance.new("ScrollingFrame", Frame)
    Drop.Size = UDim2.new(1, 0, 0, 150); Drop.Position = UDim2.new(0, 0, 0, 35); Drop.BackgroundTransparency = 1; Drop.ScrollBarThickness = 2; Instance.new("UIListLayout", Drop)

    local function UpdateVisuals()
        if multiSelect then
            local val = _G_V10[globalVar] or {}
            MainBtn.Text = "  " .. title .. ": [" .. #val .. " Chọn] ▼"
            for _, btn in pairs(Drop:GetChildren()) do
                if btn:IsA("TextButton") and not string.find(btn.Name, "^HEADER_") then 
                    local idx = table.find(val, btn.Name)
                    if idx then btn.BackgroundColor3 = Color3.fromRGB(255, 100, 200) else btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50) end
                end
            end
        else
            local val = _G_V10[globalVar]
            MainBtn.Text = "  " .. title .. ": " .. (val and tostring(val) or "Chưa chọn") .. " ▼"
            for _, btn in pairs(Drop:GetChildren()) do
                if btn:IsA("TextButton") and not string.find(btn.Name, "^HEADER_") then 
                    if val == btn.Name then btn.BackgroundColor3 = Color3.fromRGB(255, 100, 200) else btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50) end
                end
            end
        end
    end
    _G_UI_Updaters[globalVar] = UpdateVisuals

    MainBtn.MouseButton1Click:Connect(function() Frame.Size = Frame.Size.Y.Offset == 35 and UDim2.new(1, 0, 0, 185) or UDim2.new(1, 0, 0, 35) end)

    local function Refresh(newList)
        if newList then itemsList = newList end
        for _, v in pairs(Drop:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        for _, itemData in ipairs(itemsList) do
            local itemVal = type(itemData) == "table" and itemData.Value or itemData
            local itemDisp = type(itemData) == "table" and itemData.Display or itemData
            
            local Btn = Instance.new("TextButton", Drop)
            Btn.Name = itemVal; Btn.Size = UDim2.new(1, 0, 0, 30); Btn.Text = itemDisp; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = Enum.Font.Gotham; Btn.TextSize = 11; Btn.RichText = true
            
            if itemVal:match("^HEADER_") then
                Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Btn.AutoButtonColor = false; Btn.TextXAlignment = Enum.TextXAlignment.Center
            else
                Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                Btn.MouseButton1Click:Connect(function()
                    if multiSelect then _G_V10[globalVar] = _G_V10[globalVar] or {}; local idx = table.find(_G_V10[globalVar], itemVal); if idx then table.remove(_G_V10[globalVar], idx) else table.insert(_G_V10[globalVar], itemVal) end
                    else _G_V10[globalVar] = itemVal; Frame.Size = UDim2.new(1, 0, 0, 35) end
                    UpdateVisuals(); AutoSaveTrigger()
                end)
            end
        end
        Drop.CanvasSize = UDim2.new(0, 0, 0, #itemsList * 30); UpdateVisuals()
    end
    Refresh(itemsList); UpdateVisuals()
    return Refresh
end

local function CreateButton(parent, text, callback, color)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, 0, 0, 35); Btn.BackgroundColor3 = color or Color3.fromRGB(255, 100, 200)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Text = text; Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 12; Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    Btn.MouseButton1Click:Connect(callback)
end

local function CreateSlider(parent, name, min, max, globalVar)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 45); Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40); Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(1, 0, 0, 20); Lbl.Position = UDim2.new(0, 5, 0, 0); Lbl.BackgroundTransparency = 1; Lbl.Text = name .. ": " .. _G_V10[globalVar]; Lbl.TextColor3 = Color3.fromRGB(255, 255, 255); Lbl.Font = Enum.Font.Gotham; Lbl.TextSize = 12; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    local SliderBG = Instance.new("TextButton", Frame)
    SliderBG.Size = UDim2.new(0.95, 0, 0, 10); SliderBG.Position = UDim2.new(0.025, 0, 0, 25); SliderBG.BackgroundColor3 = Color3.fromRGB(60, 60, 65); SliderBG.Text = ""; Instance.new("UICorner", SliderBG).CornerRadius = UDim.new(1,0)
    local Fill = Instance.new("Frame", SliderBG)
    Fill.Size = UDim2.new(0, 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(255, 100, 200); Instance.new("UICorner", Fill).CornerRadius = UDim.new(1,0)

    local function UpdateVisuals()
        local val = _G_V10[globalVar]; local percent = (val - min) / (max - min); Fill.Size = UDim2.new(percent, 0, 1, 0); Lbl.Text = name .. ": " .. val
    end
    _G_UI_Updaters[globalVar] = UpdateVisuals

    local Dragging = false
    SliderBG.MouseButton1Down:Connect(function() Dragging = true end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then if Dragging then Dragging = false; AutoSaveTrigger() end end end)
    UIS.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
            _G_V10[globalVar] = math.floor((min + (max - min) * pos) * 10) / 10; UpdateVisuals()
        end
    end)
    UpdateVisuals()
end

local function CreateSkillGrid(parent, labelText, varPrefix)
    local Container = Instance.new("Frame", parent)
    Container.Size = UDim2.new(1, 0, 0, 55); Container.BackgroundColor3 = Color3.fromRGB(40, 40, 45); Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)
    local Lbl = Instance.new("TextLabel", Container)
    Lbl.Size = UDim2.new(1, -10, 0, 20); Lbl.Position = UDim2.new(0, 10, 0, 5); Lbl.BackgroundTransparency = 1; Lbl.Text = labelText; Lbl.TextColor3 = Color3.fromRGB(255, 255, 100); Lbl.Font = Enum.Font.GothamBold; Lbl.TextSize = 11; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    local Grid = Instance.new("Frame", Container)
    Grid.Size = UDim2.new(1, -10, 0, 25); Grid.Position = UDim2.new(0, 10, 0, 25); Grid.BackgroundTransparency = 1; local layout = Instance.new("UIListLayout", Grid); layout.FillDirection = Enum.FillDirection.Horizontal; layout.Padding = UDim.new(0, 5)
    local skills = {"Z", "X", "C", "V", "B", "F"}
    for _, key in ipairs(skills) do
        local Btn = Instance.new("TextButton", Grid)
        Btn.Size = UDim2.new(0, 35, 0, 22); Btn.Text = key; Btn.TextColor3 = Color3.fromRGB(255, 255, 255); Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 12; Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
        local function UpdateVisuals() Btn.BackgroundColor3 = _G_V10[varPrefix..key] and Color3.fromRGB(255, 100, 200) or Color3.fromRGB(80, 80, 80) end
        _G_UI_Updaters[varPrefix..key] = UpdateVisuals
        Btn.MouseButton1Click:Connect(function() _G_V10[varPrefix..key] = not _G_V10[varPrefix..key]; UpdateVisuals(); AutoSaveTrigger() end)
        UpdateVisuals()
    end
end

local function CreateTextBox(parent, placeholder, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 35); Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 50); Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    local TextBox = Instance.new("TextBox", Frame)
    TextBox.Size = UDim2.new(1, -10, 1, 0); TextBox.Position = UDim2.new(0, 5, 0, 0); TextBox.BackgroundTransparency = 1; TextBox.Text = ""; TextBox.PlaceholderText = placeholder; TextBox.TextColor3 = Color3.fromRGB(255, 255, 255); TextBox.Font = Enum.Font.Gotham; TextBox.TextSize = 12; TextBox.ClearTextOnFocus = false
    TextBox.FocusLost:Connect(function() callback(TextBox.Text) end)
    return TextBox
end

-- ==========================================
-- XÂY DỰNG TABS ĐẦY ĐỦ 
-- ==========================================
local TabSettings = CreateTab("⚙️ Cài Đặt Chung & Skill")
local TabMainFarm = CreateTab("⚔️ Main Farm (All in 1)")
local TabRaidHub = CreateTab("🏰 Raid Hub (Boss/Sun)")
local TabBoss = CreateTab("👹 Boss & Spawn")
local TabSeaEvent = CreateTab("🌊 Sự Kiện Biển")
local TabIsland = CreateTab("🏝️ Đảo & Bay & NPC")
local TabPlayer = CreateTab("🏃 Nhân Vật")
local TabServer = CreateTab("🌐 Server System")
local TabScanner = CreateTab("📝 Note & Scan Map")
local TabConfig = CreateTab("💾 Config (Save/Load)")

Pages["⚙️ Cài Đặt Chung & Skill"].Btn.BackgroundColor3 = Color3.fromRGB(255, 100, 200)
Pages["⚙️ Cài Đặt Chung & Skill"].Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabSettings.Visible = true

-- --- TAB: SETTINGS ---
local TwoColFrame = Instance.new("Frame", TabSettings)
TwoColFrame.Size = UDim2.new(1, 0, 1, 0); TwoColFrame.BackgroundTransparency = 1
local TwoColLayout = Instance.new("UIListLayout", TwoColFrame); TwoColLayout.FillDirection = Enum.FillDirection.Horizontal; TwoColLayout.Padding = UDim.new(0, 10)
local LeftCol = Instance.new("Frame", TwoColFrame); LeftCol.Size = UDim2.new(0.5, -5, 1, 0); LeftCol.BackgroundTransparency = 1; local LeftLayout = Instance.new("UIListLayout", LeftCol); LeftLayout.Padding = UDim.new(0, 8)
local RightCol = Instance.new("Frame", TwoColFrame); RightCol.Size = UDim2.new(0.5, -5, 1, 0); RightCol.BackgroundTransparency = 1; local RightLayout = Instance.new("UIListLayout", RightCol); RightLayout.Padding = UDim.new(0, 8)

local SecCombo = CreateSection(LeftCol, "KIỂU ĐÁNH & CHUNG", Color3.fromRGB(0, 200, 255))
CreateDropdown(SecCombo, "Kiểu Đánh", {"Trên Đầu", "Đằng Sau", "Dưới Chân", "Xoay Tròn"}, "AttackPosition", false)
CreateSlider(SecCombo, "Khoảng Cách Đánh", 5, 40, "AttackDistance")
CreateSlider(SecCombo, "Tốc Độ Bay Chung", 100, 500, "FlySpeed")
CreateToggleSwitch(SecCombo, "Bật Tự Động Đánh (Click)", "AutoClick")
CreateToggleSwitch(SecCombo, "Bật Lặp Lại Quest", "AutoRepeatQuest")

local SecSafeHP = CreateSection(LeftCol, "NÉ CHIÊU (SAFE MÁU TOÀN CỤC)", Color3.fromRGB(255, 50, 50))
CreateToggleSwitch(SecSafeHP, "Bật Safe Máu", "GlobalSafeHP")
CreateSlider(SecSafeHP, "Né khi HP dưới (%)", 10, 90, "GlobalSafeHP_Min")
CreateToggleSwitch(SecSafeHP, "Né Theo Thời Gian", "GlobalSafeHP_Timer")
CreateSlider(SecSafeHP, "Đánh Xong Lại Né (s)", 5, 60, "GlobalSafeHP_Time")
CreateToggleSwitch(SecSafeHP, "Xoay Tròn Né Chiêu Dưới Đất", "GlobalSafeHP_Spin")
CreateSlider(SecSafeHP, "Bán Kính Xoay", 10, 100, "GlobalDodgeRadius")

local SecHaki = CreateSection(LeftCol, "HAKI & SKILL GLOBAL", Color3.fromRGB(255, 100, 50))
CreateToggleSwitch(SecHaki, "🔥 Bật Tự Động Haki", "AutoHaki")
CreateToggleSwitch(SecHaki, "👁️ Bật Tự Động Ken", "AutoKen")
CreateToggleSwitch(SecHaki, "Kích Hoạt Auto Skill Global", "AutoSkill")
CreateToggleSwitch(SecHaki, "Phím Z", "Skill_Z"); CreateToggleSwitch(SecHaki, "Phím X", "Skill_X"); CreateToggleSwitch(SecHaki, "Phím C", "Skill_C"); CreateToggleSwitch(SecHaki, "Phím V", "Skill_V"); CreateToggleSwitch(SecHaki, "Phím F", "Skill_F")

local SecWepAuto = CreateSection(RightCol, "ĐỔI VŨ KHÍ SIÊU TỐC", Color3.fromRGB(0, 200, 255))
CreateToggleSwitch(SecWepAuto, "Bật Auto Đổi VK (1 <-> 2)", "AutoSwapWeapon")
CreateSlider(SecWepAuto, "Min Delay Xả Skill (Giây)", 0.1, 5, "SkillSpamDelay")
local DropPriWeapon = CreateDropdown(SecWepAuto, "Vũ Khí 1", {}, "PrimaryWeapon", false)
CreateSlider(SecWepAuto, "Time Cầm VK 1 (s)", 0.1, 10, "HoldTime1")
CreateSkillGrid(SecWepAuto, "Skill VK 1:", "W1_")
local DropSecWeapon = CreateDropdown(SecWepAuto, "Vũ Khí 2", {}, "SecondaryWeapon", false)
CreateSlider(SecWepAuto, "Time Cầm VK 2 (s)", 0.1, 10, "HoldTime2")
CreateSkillGrid(SecWepAuto, "Skill VK 2:", "W2_")

local SecWepFix = CreateSection(RightCol, "CẦM 1 VŨ KHÍ CỐ ĐỊNH", Color3.fromRGB(255, 200, 50))
local DropWeapons = CreateDropdown(SecWepFix, "Chọn Vũ Khí", {}, "SelectedWeapon", false)
CreateToggleSwitch(SecWepFix, "Tự Động Cầm 1 VK Này", "AutoEquip")
CreateButton(SecWepFix, "🎒 Quét Túi Cập Nhật Lại", function()
    local weps = {}
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(weps, v.Name) end end
    if LocalPlayer.Character then for _, v in pairs(LocalPlayer.Character:GetChildren()) do if v:IsA("Tool") and not table.find(weps, v.Name) then table.insert(weps, v.Name) end end end
    DropWeapons(weps); DropPriWeapon(weps); DropSecWeapon(weps)
end)

table.insert(_G.YuiConnections, RunService.Stepped:Connect(function()
    pcall(function() local maxH = math.max(LeftLayout.AbsoluteContentSize.Y, RightLayout.AbsoluteContentSize.Y); TabSettings.CanvasSize = UDim2.new(0, 0, 0, maxH + 20) end)
end))

-- --- TAB: MAIN FARM ---
local LblInfo = Instance.new("TextLabel", TabMainFarm)
LblInfo.Size = UDim2.new(1, 0, 0, 20); LblInfo.BackgroundTransparency = 1; LblInfo.TextColor3 = Color3.fromRGB(255, 255, 100); LblInfo.Font = Enum.Font.Gotham; LblInfo.TextSize = 13; LblInfo.TextXAlignment = Enum.TextXAlignment.Left; LblInfo.Text = "Trạng thái Farm: Đang chờ..."

local function StopAllFarm()
    _G_V10.AutoWorldBoss = false; _G_V10.AutoNormalBoss = false; _G_V10.AutoCoordMob = false
    _G_V10.AutoFarmLevel = false; _G_V10.ManualQuestFarm = false; _G_V10.AutoFarmFree = false
    _G_V10.FarmAll = false; _G_V10.AutoFarmRaid = false; _G_V10.AutoPatrolIsland = false
    _G_V10.AutoFarmBossRaid = false; _G_V10.AutoSunBattery = false; _G_V10.AutoIdlePatrol = false
    
    for _, updater in pairs(_G_UI_Updaters) do pcall(updater) end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        pcall(function()
            char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
        end)
        if char.HumanoidRootPart:FindFirstChild("FarmAntiFall") then char.HumanoidRootPart.FarmAntiFall:Destroy() end
        if char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = false end
    end
end
CreateButton(TabMainFarm, "🛑 STOP ALL FARM (TẮT HẾT FARM NGAY LẬP TỨC)", StopAllFarm, Color3.fromRGB(255, 50, 50))

local SecFarmCoord = CreateSection(TabMainFarm, "FARM TỌA ĐỘ (ƯU TIÊN TUYỆT ĐỐI 1, 2, 3)", Color3.fromRGB(255, 100, 200))
local LblCoordInfo = Instance.new("TextLabel", SecFarmCoord)
LblCoordInfo.Size = UDim2.new(1, -10, 0, 20); LblCoordInfo.BackgroundTransparency = 1; LblCoordInfo.TextColor3 = Color3.fromRGB(255, 150, 150); LblCoordInfo.Font = Enum.Font.Gotham; LblCoordInfo.TextSize = 12; LblCoordInfo.TextXAlignment = Enum.TextXAlignment.Left; LblCoordInfo.Text = "Trạng thái AI Tọa Độ: Đang rảnh..."

CreateDropdown(SecFarmCoord, "ƯU TIÊN 1: Boss Thế Giới", ListWorldBoss, "SelectedWorldBosses", true, true)
CreateToggleSwitch(SecFarmCoord, "Bật Auto Săn Boss Thế Giới", "AutoWorldBoss")
CreateDropdown(SecFarmCoord, "ƯU TIÊN 2: Boss Thường", ListNormalBoss, "SelectedNormalBosses", true, true)
CreateToggleSwitch(SecFarmCoord, "Bật Auto Săn Boss Thường", "AutoNormalBoss")
CreateSlider(SecFarmCoord, "Delay Lặp Lại Check Boss (Min 0.5s)", 0.5, 100, "BossCheckDelay")
CreateDropdown(SecFarmCoord, "ƯU TIÊN 3: Quái (Ưu tiên đúng thứ tự click)", ListMobs, "SelectedCoordMobs", true, true)
CreateToggleSwitch(SecFarmCoord, "Bật Auto Săn Quái Tọa Độ", "AutoCoordMob")

local SecFarmLv = CreateSection(TabMainFarm, "FARM LEVEL CHUẨN (ƯU TIÊN 4)", Color3.fromRGB(50, 200, 255))
CreateToggleSwitch(SecFarmLv, "Bật Auto Farm Level (Tự Chuyển Bãi)", "AutoFarmLevel")
CreateDropdown(SecFarmLv, "Chọn Quest Bằng Tay", QuestListNames, "SelectedManualQuest", false)
CreateToggleSwitch(SecFarmLv, "Bật Đánh Quest Đã Chọn", "ManualQuestFarm")

local SecFarmCstm = CreateSection(TabMainFarm, "FARM TÙY CHỌN & CÀN QUÉT MAP", Color3.fromRGB(100, 255, 100))
local DropMonsters = CreateDropdown(SecFarmCstm, "Chọn Quái Cần Đánh", _G_V10.ScannedMonstersList, "SelectedMonsters", true)
CreateButton(SecFarmCstm, "🔍 Quét Map Lấy Danh Sách Tùy Chọn", function()
    local folders = {workspace}
    if workspace:FindFirstChild("Monster") then table.insert(folders, workspace.Monster) end
    if workspace:FindFirstChild("Enemies") then table.insert(folders, workspace.Enemies) end
    if workspace:FindFirstChild("NPC") then table.insert(folders, workspace.NPC) end
    for _, folder in ipairs(folders) do
        for _, v in pairs(folder:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name ~= LocalPlayer.Name then
                local isEx = false
                for _, ex in pairs(_G_V10.ExcludedMobs) do if string.find(string.lower(v.Name), ex) then isEx = true; break end end
                if not isEx and not table.find(_G_V10.ScannedMonstersList, v.Name) then table.insert(_G_V10.ScannedMonstersList, v.Name) end
            end
        end
    end
    table.sort(_G_V10.ScannedMonstersList); DropMonsters(_G_V10.ScannedMonstersList); AutoSaveTrigger()
end)
CreateToggleSwitch(SecFarmCstm, "Bật Free Farm (Danh sách trên)", "AutoFarmFree")
CreateToggleSwitch(SecFarmCstm, "Bật Farm ALL (Càn quét Map)", "FarmAll")

-- --- TAB: RAID HUB ---
local SecRaidBuy = CreateSection(TabRaidHub, "MUA & BẮT ĐẦU RAID", Color3.fromRGB(255, 100, 100))
CreateDropdown(SecRaidBuy, "Vị trí Mua World Raid", {"Out (Ngoài Map)", "In (Trong Map)"}, "WorldRaidLocation", false)
CreateToggleSwitch(SecRaidBuy, "Bật Auto Mua World Raid (Galactic Overseer)", "AutoBuyWorldRaid")
CreateToggleSwitch(SecRaidBuy, "Bật Tự Động Mua Raid / Re-Raid Thường", "AutoBuyRaid")
CreateSlider(SecRaidBuy, "Delay Teleport Mua Raid (Giây)", 1, 10, "RaidBuyTeleportDelay")
CreateToggleSwitch(SecRaidBuy, "Bật Tự Động Bấm Starto (Bắt đầu Raid)", "AutoStartRaid")
CreateToggleSwitch(SecRaidBuy, "Tự Động Bấm Play/Join Game", "AutoJoinGame")

local SecRaidBoss = CreateSection(TabRaidHub, "FARM BOSS RAID (Seluna & pzozolove)", Color3.fromRGB(255, 50, 200))
CreateDropdown(SecRaidBoss, "Chọn Boss Raid Cần Đánh", {"Seluna", "pzozolove112"}, "SelectedRaidBosses", true, true)
CreateToggleSwitch(SecRaidBoss, "Bật Auto Farm Boss Raid", "AutoFarmBossRaid")
CreateToggleSwitch(SecRaidBoss, "Luôn Xoay Tròn Quanh pzozolove112 (Không đánh)", "AlwaysSpinPzozo")
CreateSlider(SecRaidBoss, "Bán Kính Xoay Pzozo", 10, 1000, "PzozoSpinRadius")
CreateSlider(SecRaidBoss, "Tốc Độ Xoay Pzozo", 1, 20, "PzozoSpinSpeed")

local SecIdlePatrol = CreateSection(TabRaidHub, "CHẾ ĐỘ CHỜ KHI KHÔNG CÓ QUÁI (IDLE PATROL)", Color3.fromRGB(150, 200, 255))
CreateToggleSwitch(SecIdlePatrol, "Bật Bay Chờ Khi Không Có Quái", "AutoIdlePatrol")
CreateDropdown(SecIdlePatrol, "Thời gian chờ Pos 1 (Giây)", {"10", "20", "30"}, "IdleWait1", false)
CreateDropdown(SecIdlePatrol, "Thời gian chờ Pos 2 (Giây)", {"10", "15", "20"}, "IdleWait2", false)

local SecRaidNorm = CreateSection(TabRaidHub, "FARM RAID THƯỜNG", Color3.fromRGB(255, 150, 50))
CreateToggleSwitch(SecRaidNorm, "Bật Auto Farm Toàn Bộ Quái Trong Raid", "AutoFarmRaid")

local SecSun = CreateSection(TabRaidHub, "VẬT PHẨM RAID", Color3.fromRGB(255, 200, 50))
CreateToggleSwitch(SecSun, "Bật Auto Lụm Sun Battery", "AutoSunBattery")

local SecRaidTele = CreateSection(TabRaidHub, "CƠ CHẾ PATROL & TELEPORT RAID", Color3.fromRGB(200, 150, 255))
CreateDropdown(SecRaidTele, "Chờ ở Tọa độ 1 (Giây)", {"10", "20", "30"}, "RaidWaitC1", false)
CreateDropdown(SecRaidTele, "Chờ ở Tọa độ 2 (Giây)", {"10", "20", "30"}, "RaidWaitC2", false)
CreateDropdown(SecRaidTele, "Chờ ở Tọa độ 3 (Giây)", {"10", "20", "30"}, "RaidWaitC3", false)
CreateToggleSwitch(SecRaidTele, "Teleport Cửa Ngoài (Khi ở ngoài)", "AutoTeleEntrance")
CreateSlider(SecRaidTele, "Delay Tele Ra Cửa (Giây)", 1, 10, "RaidEntranceDelay")
CreateToggleSwitch(SecRaidTele, "Teleport Re-Raid (Chỉ khi sạch quái)", "AutoTeleReRaid")
CreateSlider(SecRaidTele, "Delay Re-Raid (Giây)", 1, 10, "RaidReRaidDelay")

-- --- TAB: BOSS & SPAWN ---
local SecBossSpawn = CreateSection(TabBoss, "AUTO SPAWN MIHAWK", Color3.fromRGB(150, 100, 255))
CreateToggleSwitch(SecBossSpawn, "Bật Auto Spawn Mihawk", "AutoSpawnMihawk")
CreateDropdown(SecBossSpawn, "Chọn Lượng Spawn Mihawk", {"x100", "x10", "x1"}, "MihawkAmount", false)
local SecBossShadow = CreateSection(TabBoss, "AUTO GIVE SHADOW BOSS", Color3.fromRGB(150, 100, 255))
CreateToggleSwitch(SecBossShadow, "Bật Auto Give Item Cho Shadow", "AutoGiveShadow")
CreateDropdown(SecBossShadow, "Chọn Vật Phẩm Give", {"Shadow Spirit", "Rotten Flesh", "Aqua Soul", "Bone", "Blood Bottle"}, "ShadowItem", false)
CreateDropdown(SecBossShadow, "Chọn Số Lượng Give", {"x1", "x5", "x10"}, "ShadowAmount", false)

-- --- TAB: SỰ KIỆN BIỂN ---
local LblSeaInfo = Instance.new("TextLabel", TabSeaEvent)
LblSeaInfo.Size = UDim2.new(1, 0, 0, 20); LblSeaInfo.BackgroundTransparency = 1; LblSeaInfo.TextColor3 = Color3.fromRGB(0, 255, 200); LblSeaInfo.Font = Enum.Font.Gotham; LblSeaInfo.TextSize = 13; LblSeaInfo.TextXAlignment = Enum.TextXAlignment.Left; LblSeaInfo.Text = "Trạng thái Biển: Đang rảnh..."
CreateToggleSwitch(TabSeaEvent, "Bật Auto Sea Event", "AutoSea")
CreateDropdown(TabSeaEvent, "Chọn Vùng Biển (Sea Zone)", {"Zone 1", "Zone 2", "Zone 3", "Zone 4"}, "SelectedSeaZone", false)
CreateToggleSwitch(TabSeaEvent, "Săn Sea Monster (Bay Vòng Tròn)", "HuntSeaMonster")
CreateToggleSwitch(TabSeaEvent, "Săn Thuyền Ma (The Starving Ghost)", "HuntGhost")
CreateToggleSwitch(TabSeaEvent, "Tự Động Ngồi Lái Thuyền", "AutoSitBoat")

-- --- TAB: ĐẢO & BAY & NPC ---
local SecIslandPatrol = CreateSection(TabIsland, "TUẦN TRA ĐẢO (ISLAND PATROL)", Color3.fromRGB(0, 255, 200))
local DropPatrolIslands = CreateDropdown(SecIslandPatrol, "Chọn Các Đảo Tuần Tra", {}, "SelectedPatrolIslands", true, true)
CreateToggleSwitch(SecIslandPatrol, "Bật Auto Tuần Tra Đảo", "AutoPatrolIsland")
CreateSlider(SecIslandPatrol, "Thời Gian Ở Lại 1 Đảo (s)", 10, 300, "PatrolIslandTime")
CreateSlider(SecIslandPatrol, "Bán Kính Vòng Lượn Quanh Đảo", 50, 500, "PatrolIslandRadius")
CreateSlider(SecIslandPatrol, "Tốc Độ Lượn Vòng", 1, 20, "PatrolIslandSpeed")
CreateSlider(SecIslandPatrol, "Độ Cao Lượn (Y Offset) (0=Đất)", 0, 500, "PatrolIslandHeight")

local SecIslandSelect = CreateSection(TabIsland, "CHỌN & QUÉT ĐẢO (TELEPORT)", Color3.fromRGB(100, 255, 150))
local DropIslands = CreateDropdown(SecIslandSelect, "Chọn Đảo (Island)", {}, "SelectedIsland", false)
CreateButton(SecIslandSelect, "🏝️ Quét Danh Sách Đảo Mới", function()
    local islands = {}
    local islandsFolder = workspace:FindFirstChild("All") and workspace.All:FindFirstChild("Island")
    if islandsFolder then for _, island in ipairs(islandsFolder:GetChildren()) do table.insert(islands, island.Name) end end
    table.sort(islands); DropIslands(islands); DropPatrolIslands(islands)
end)
local DropSpawnPoints = CreateDropdown(SecIslandSelect, "Chọn Điểm Hồi Sinh", {}, "SelectedSpawnPoint", false)
CreateButton(SecIslandSelect, "🔄 Cập nhật Điểm Hồi Sinh", function()
    local sp = {}
    if workspace:FindFirstChild("SetSpawnPoints") then for _, v in pairs(workspace.SetSpawnPoints:GetChildren()) do table.insert(sp, v.Name) end end
    table.sort(sp); DropSpawnPoints(sp)
end)

local SecNPC = CreateSection(TabIsland, "DỊCH CHUYỂN ĐẾN NPC TRONG DATA", Color3.fromRGB(255, 200, 50))
CreateDropdown(SecNPC, "Chọn NPC Cần Tìm", ListNPCs, "SelectedNPC", false)

local function InstantTeleport(targetCFrame)
    local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if HRP then
        pcall(function() HRP.AssemblyLinearVelocity = Vector3.new(0,0,0) end)
        HRP.CFrame = targetCFrame 
    end
end

CreateButton(TabIsland, "🚀 DỊCH CHUYỂN ĐẾN MỤC ĐÃ CHỌN BÊN TRÊN", function()
    if _G_V10.SelectedIsland then
        local isl = workspace:FindFirstChild("All") and workspace.All:FindFirstChild("Island") and workspace.All.Island:FindFirstChild(_G_V10.SelectedIsland)
        if isl then InstantTeleport(isl:GetPivot() + Vector3.new(0, 50, 0)) end
    elseif _G_V10.SelectedSpawnPoint then
        local sp = workspace:FindFirstChild("SetSpawnPoints") and workspace.SetSpawnPoints:FindFirstChild(_G_V10.SelectedSpawnPoint)
        if sp then InstantTeleport(sp.CFrame + Vector3.new(0, 5, 0)) end
    elseif _G_V10.SelectedNPC then
        local realNPCName = _G_V10.SelectedNPC:match("%] (.*)$") or _G_V10.SelectedNPC:match("%] (.*)") or _G_V10.SelectedNPC:gsub("^%[.-%]%s+", "")
        local dbInfo = CoordDB.NPCs[realNPCName]
        if dbInfo then InstantTeleport(CFrame.new(dbInfo.Pos + Vector3.new(0, 5, 0))) end
    end
end)

-- --- TAB: NHÂN VẬT ---
local SecPlayerMod = CreateSection(TabPlayer, "MOD DI CHUYỂN & NHẢY", Color3.fromRGB(255, 150, 50))
CreateToggleSwitch(SecPlayerMod, "Xuyên Tường & Địa Hình (Noclip)", "Noclip")
CreateToggleSwitch(SecPlayerMod, "Đi Bộ Trên Mặt Nước (Water Walk)", "WaterWalk")
CreateToggleSwitch(SecPlayerMod, "Auto Nhảy Liên Tục (Chống Anti-Cheat)", "AutoJump")
CreateToggleSwitch(SecPlayerMod, "Bật Hack Tốc Độ Chạy", "EnableSpeed")
CreateSlider(SecPlayerMod, "Tốc Độ Chạy (WalkSpeed)", 16, 250, "WalkSpeed")
CreateToggleSwitch(SecPlayerMod, "Bật Hack Nhảy Cao", "EnableJump")
CreateSlider(SecPlayerMod, "Lực Nhảy (JumpPower)", 50, 300, "JumpPower")
CreateToggleSwitch(SecPlayerMod, "Nhảy Vô Hạn (Infinity Jump)", "InfJump")
CreateToggleSwitch(SecPlayerMod, "Lướt Không Hồi Chiêu (Dash No CD)", "DashNoCD")
CreateToggleSwitch(SecPlayerMod, "🚀 Bay Tự Do (Dùng Joystick / W,A,S,D)", "FreeFly")
CreateSlider(SecPlayerMod, "Tốc Độ Bay Tự Do", 50, 500, "FreeFlySpeed")

-- --- TAB: SERVER SYSTEM ---
local SecServerProt = CreateSection(TabServer, "BẢO VỆ & KẾT NỐI", Color3.fromRGB(50, 150, 255))
CreateToggleSwitch(SecServerProt, "Bảo Vệ: Chống Văng (Anti-AFK)", "AntiAFK")
CreateButton(SecServerProt, "♻️ Rejoin (Vào Lại Server Cũ)", function() TPS:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
CreateButton(SecServerProt, "🌐 Hop Server (Đổi Server Khác)", function()
    local req = request or http_request or syn.request
    if req then
        local res = req({Url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"})
        local body = HttpService:JSONDecode(res.Body)
        if body and body.data then for _, v in ipairs(body.data) do if v.playing < v.maxPlayers and v.id ~= game.JobId then TPS:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer); break end end end
    end
end)
CreateButton(SecServerProt, "📉 Hop Server Ít Người", function()
    local req = request or http_request or syn.request
    if req then
        local res = req({Url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"})
        local body = HttpService:JSONDecode(res.Body)
        if body and body.data then for _, v in ipairs(body.data) do if v.playing < v.maxPlayers and v.playing > 0 and v.id ~= game.JobId then TPS:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer); break end end end
    end
end)
CreateButton(SecServerProt, "🚀 Boost FPS (Xóa Đồ Họa Mượt Game)", function()
    game.Lighting.GlobalShadows = false; game.Lighting.FogEnd = 9e9
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then v.Material = Enum.Material.Plastic; v.Reflectance = 0 end
        if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
    end
end)
CreateToggleSwitch(SecServerProt, "Màn Hình Đen (Giảm Lag Treo Máy)", "EnableBlackScreen")

-- --- TAB: MÁY QUÉT MAP & LẤY TỌA ĐỘ ---
local SecScanMap = CreateSection(TabScanner, "LẤY TỌA ĐỘ CỦA TÔI", Color3.fromRGB(0, 255, 100))
local PosLogFrame = Instance.new("Frame", SecScanMap)
PosLogFrame.Size = UDim2.new(1, -10, 0, 50); PosLogFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30); Instance.new("UICorner", PosLogFrame).CornerRadius = UDim.new(0, 6)
local posTxt = Instance.new("TextBox", PosLogFrame)
posTxt.Size = UDim2.new(1, -50, 1, -10); posTxt.Position = UDim2.new(0, 5, 0, 5); posTxt.BackgroundTransparency = 1; posTxt.Text = "Chưa lấy tọa độ..."
posTxt.TextColor3 = Color3.fromRGB(220, 220, 220); posTxt.TextEditable = false; posTxt.TextWrapped = true; posTxt.Font = Enum.Font.Code; posTxt.TextSize = 12; posTxt.TextXAlignment = Enum.TextXAlignment.Left; posTxt.TextYAlignment = Enum.TextYAlignment.Top
local copyPosBtn = Instance.new("TextButton", PosLogFrame)
copyPosBtn.Size = UDim2.new(0, 40, 0, 40); copyPosBtn.Position = UDim2.new(1, -45, 0.5, -20); copyPosBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255); copyPosBtn.Text = "COPY"; copyPosBtn.TextColor3 = Color3.fromRGB(255, 255, 255); copyPosBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", copyPosBtn).CornerRadius = UDim.new(0, 6)
copyPosBtn.MouseButton1Click:Connect(function()
    if setclipboard and posTxt.Text ~= "Chưa lấy tọa độ..." then
        setclipboard(posTxt.Text); copyPosBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100); copyPosBtn.Text = "OK"; task.wait(1); copyPosBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255); copyPosBtn.Text = "COPY"
    end
end)

CreateButton(SecScanMap, "🎯 Lấy Tọa Độ Hiện Tại Xuống Note Trên", function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local p = hrp.Position
        posTxt.Text = string.format("Vector3.new(%.0f, %.0f, %.0f)", p.X, p.Y, p.Z)
    end
end)

local SecScanData = CreateSection(TabScanner, "HỆ THỐNG MÁY QUÉT MAP", Color3.fromRGB(200, 100, 255))
CreateDropdown(SecScanData, "Chế Độ Quét", {"Tất Cả", "Chỉ Boss", "Chỉ Quái", "Chỉ NPC"}, "ScanMode", false)
CreateToggleSwitch(SecScanData, "Bật Quét Tự Động", "AutoScanMap")
CreateButton(SecScanData, "🔄 Cập Nhật Danh Sách Vừa Quét Xong Lên Bảng UI", function() RenderScannerLog() end)

ScanLogFrame = Instance.new("ScrollingFrame", SecScanData)
ScanLogFrame.Size = UDim2.new(1, 0, 0, 300); ScanLogFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); ScanLogFrame.ScrollBarThickness = 3
local slLayout = Instance.new("UIListLayout", ScanLogFrame); slLayout.Padding = UDim.new(0, 5)

-- --- TAB: CONFIG ---
local SecCfgLoad = CreateSection(TabConfig, "QUẢN LÝ CẤU HÌNH", Color3.fromRGB(255, 200, 50))
local DropConfigs = CreateDropdown(SecCfgLoad, "Chọn Bản Lưu", GetConfigsList(), "SelectedConfig", false)
local ConfigNameInput = "DefaultConfig"
CreateTextBox(SecCfgLoad, "Nhập tên cấu hình để lưu (VD: BeliFarm)", function(text) ConfigNameInput = text end)
CreateButton(SecCfgLoad, "💾 LƯU BẢN HIỆN TẠI (SAVE)", function() SaveConfig(ConfigNameInput ~= "" and ConfigNameInput or _G_V10.SelectedConfig); DropConfigs(GetConfigsList()); game.StarterGui:SetCore("SendNotification", {Title = "Lưu Thành Công", Text = "Đã lưu cấu hình!", Duration = 3}) end)
CreateButton(SecCfgLoad, "📂 TẢI BẢN ĐÃ CHỌN (LOAD)", function() LoadConfig(_G_V10.SelectedConfig); game.StarterGui:SetCore("SendNotification", {Title = "Tải Thành Công", Text = "Đã tải cấu hình!", Duration = 3}) end)
local SecCfgBypass = CreateSection(TabConfig, "AUTO BYPASS", Color3.fromRGB(0, 200, 255))
CreateToggleSwitch(SecCfgBypass, "Bật Auto Lưu (Lưu mỗi khi thay đổi)", "AutoSaveConfig")
CreateToggleSwitch(SecCfgBypass, "Bật Auto Load (Khi vào lại game)", "AutoLoadConfig")
CreateToggleSwitch(SecCfgBypass, "Bật Auto Bypass Load Data Lúc Mới Mở", "AutoBypassMenu")
CreateSlider(SecCfgBypass, "Thời Gian Chạy Bypass Lúc Đầu (Giây)", 1, 100, "BypassDuration")

CreateButton(SecCfgBypass, "⚠️ RESET TOÀN BỘ MENU VỀ MẶC ĐỊNH", function()
    for k, v in pairs(DefaultConfig) do if k ~= "ScannedMonstersList" and k ~= "ScannerData" then _G_V10[k] = v end end
    for _, updater in pairs(_G_UI_Updaters) do pcall(updater) end
    SaveConfig(_G_V10.SelectedConfig); game.StarterGui:SetCore("SendNotification", {Title = "Reset", Text = "Đã làm mới Menu!", Duration = 3})
end, Color3.fromRGB(200, 50, 50))

RenderScannerLog()

-- ==========================================
-- ENGINE LÕI: NOCLIP & WATER WALK
-- ==========================================
local WaterPart = Instance.new("Part", workspace)
WaterPart.Size = Vector3.new(15, 2, 15); WaterPart.Transparency = 0.5; WaterPart.Material = Enum.Material.ForceField; WaterPart.Color = Color3.fromRGB(0, 150, 255); WaterPart.Anchored = true; WaterPart.CanCollide = false
local currentWaterY = nil

table.insert(_G.YuiConnections, RunService.Stepped:Connect(function()
    if _G.YuiKillAllLoops then WaterPart:Destroy(); return end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if _G_V10.Noclip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") and v.CanCollide == true then v.CanCollide = false end end
        end
        if _G_V10.WaterWalk then
            if not currentWaterY then currentWaterY = char.HumanoidRootPart.Position.Y - 3.5 end
            WaterPart.CanCollide = true; WaterPart.CFrame = CFrame.new(char.HumanoidRootPart.Position.X, currentWaterY, char.HumanoidRootPart.Position.Z)
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum.FloorMaterial == Enum.Material.Air and char.HumanoidRootPart.Velocity.Y < 0 then
                char.HumanoidRootPart.Velocity = Vector3.new(char.HumanoidRootPart.Velocity.X, 0, char.HumanoidRootPart.Velocity.Z)
            end
        else currentWaterY = nil; WaterPart.CanCollide = false; WaterPart.CFrame = CFrame.new(0, -9999, 0) end
    end
end))

-- ==========================================
-- ENGINE: AUTO SKILL GLOBAL (CHẠY ĐỘC LẬP MƯỢT MÀ)
-- ==========================================
local function ForceUseSkill(key)
    VIM:SendKeyEvent(true, Enum.KeyCode[key], false, game)
    task.spawn(function() task.wait(0.05); VIM:SendKeyEvent(false, Enum.KeyCode[key], false, game) end)
    local char = LocalPlayer.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        local remote = tool:FindFirstChild(key)
        if remote then
            pcall(function()
                if remote:IsA("RemoteFunction") then remote:InvokeServer(key)
                elseif remote:IsA("RemoteEvent") then remote:FireServer(key) end
            end)
        end
    end
end

task.spawn(function()
    while task.wait(_G_V10.SkillSpamDelay or 0.1) do
        if _G.YuiKillAllLoops then break end
        if _G_V10.AutoSkill then
            if _G_V10.Skill_Z then ForceUseSkill("Z") end
            if _G_V10.Skill_X then ForceUseSkill("X") end
            if _G_V10.Skill_C then ForceUseSkill("C") end
            if _G_V10.Skill_V then ForceUseSkill("V") end
            if _G_V10.Skill_F then ForceUseSkill("F") end
        end
    end
end)

-- ==========================================
-- ENGINE: AUTO REPEAT QUEST (CHẠY ĐỘC LẬP)
-- ==========================================
task.spawn(function()
    while task.wait(1) do
        if _G.YuiKillAllLoops then break end
        if _G_V10.AutoRepeatQuest or _G_V10.AutoFarmLevel or _G_V10.ManualQuestFarm then
            pcall(function()
                for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                    if v:IsA("RemoteEvent") and v.Name == "Qu" then v:FireServer("Yes") end
                end
            end)
        end
    end
end)

-- ==========================================
-- BẮT CHAT SYSTEM CHECK BOSS SPAWN NHANH
-- ==========================================
local lastWorldBossCheckTime = os.clock()
local lastNormalBossCheckTime = os.clock()

local function MonitorChatForBosses()
    local ChatSys = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Chat")
    if ChatSys then
        table.insert(_G.YuiConnections, ChatSys.DescendantAdded:Connect(function(descendant)
            if _G.YuiKillAllLoops then return end
            if descendant:IsA("TextLabel") and descendant.Text then
                local txt = string.lower(descendant.Text)
                if string.find(txt, "trăng máu") or string.find(txt, "blood moon") or string.find(txt, "shadow") or string.find(txt, "boss") then
                    lastWorldBossCheckTime = 0
                    lastNormalBossCheckTime = 0 
                end
            end
        end))
    end
end
pcall(MonitorChatForBosses)

-- ==========================================
-- ENGINE: AUTO BYPASS MAIN MENU
-- ==========================================
local function TapSafeEdge()
    if _G.YuiKillAllLoops then return end
    local cam = workspace.CurrentCamera
    if cam then
        local safeX = cam.ViewportSize.X * 0.75 
        VIM:SendMouseButtonEvent(safeX, 20, 0, true, game, 0)
        task.wait(0.05); VIM:SendMouseButtonEvent(safeX, 20, 0, false, game, 0)
    end
end

local function SmartFindButton(gui, searchText)
    for _, obj in pairs(gui:GetDescendants()) do
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            if obj:IsA("TextButton") and obj.Text and string.find(string.lower(obj.Text), string.lower(searchText)) then return obj end
            local txtChild = obj:FindFirstChildWhichIsA("TextLabel")
            if txtChild and txtChild.Text and string.find(string.lower(txtChild.Text), string.lower(searchText)) then return obj end
        end
    end
    return nil
end

local function PhysicalClick(guiObj)
    if _G.YuiKillAllLoops then return end
    if not guiObj then return end
    local inset = GuiService:GetGuiInset()
    local center = guiObj.AbsolutePosition + (guiObj.AbsoluteSize / 2)
    VIM:SendMouseButtonEvent(center.X, center.Y + inset.Y, 0, true, game, 0)
    task.wait(0.05); VIM:SendMouseButtonEvent(center.X, center.Y + inset.Y, 0, false, game, 0)
end

task.spawn(function()
    if not _G_V10.AutoBypassMenu then return end
    local endTime = os.clock() + _G_V10.BypassDuration
    while os.clock() < endTime do
        if _G.YuiKillAllLoops then break end
        task.wait(0.5)
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if pg then
            local loadBtn = SmartFindButton(pg, "Load Data") or SmartFindButton(pg, "Load") or SmartFindButton(pg, "Accept")
            local playBtn = SmartFindButton(pg, "Play") or SmartFindButton(pg, "Join") or SmartFindButton(pg, "Start")
            if loadBtn then PhysicalClick(loadBtn) end
            if playBtn then PhysicalClick(playBtn) end
        end
        TapSafeEdge()
    end
end)

-- ==========================================
-- ENGINE: MUA WORLD RAID, MUA RAID THƯỜNG & SPAWN BOSS
-- ==========================================
task.spawn(function()
    while task.wait(0.5) do
        if _G.YuiKillAllLoops then break end
        if _G_V10.AutoBuyWorldRaid then
            local char = LocalPlayer.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
            
            if not talkingGui then
                if _G_V10.WorldRaidLocation == "Out (Ngoài Map)" then
                    local targetPos = Vector3.new(-20370, 383, 280)
                    if (hrp.Position - targetPos).Magnitude > 20 then hrp.CFrame = CFrame.new(targetPos); task.wait(_G_V10.RaidBuyTeleportDelay) end
                end
                
                local npc = Workspace:FindFirstChild("NPC") and Workspace.NPC:FindFirstChild("Galactic Overseer")
                if npc and (hrp.Position - npc:GetPivot().Position).Magnitude < 30 then
                    task.spawn(function() pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end) end)
                end
            else
                local buyBtn = SmartFindButton(talkingGui, "Buy with money") or SmartFindButton(talkingGui, "Buy with Beli") or SmartFindButton(talkingGui, "Buy")
                if buyBtn then task.wait(1.5); PhysicalClick(buyBtn); task.wait(1); TapSafeEdge() else TapSafeEdge() end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do 
        if _G.YuiKillAllLoops then break end
        if not _G_V10.AutoSpawnMihawk then continue end
        local char = LocalPlayer.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        local target = Vector3.new(-1380, 77, 3904)
        if (hrp.Position - target).Magnitude > 50 then hrp.CFrame = CFrame.new(target); task.wait(1.5) end
        local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
        if not talkingGui then
            local npc = Workspace:FindFirstChild("NPC") and Workspace.NPC:FindFirstChild("Stone Statue")
            if npc then task.spawn(function() pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end) end) end
            task.wait(1)
        else
            local amtBtn = SmartFindButton(talkingGui, _G_V10.MihawkAmount)
            if amtBtn then task.wait(1.5); PhysicalClick(amtBtn); task.wait(1); TapSafeEdge() else task.wait(1); TapSafeEdge() end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if _G.YuiKillAllLoops then break end
        if not _G_V10.AutoGiveShadow then continue end
        local char = LocalPlayer.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        local target = Vector3.new(-10371, 100, -3519)
        if (hrp.Position - target).Magnitude > 50 then hrp.CFrame = CFrame.new(target); task.wait(1.5) end
        local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
        if not talkingGui then
            local npc = Workspace:FindFirstChild("NPC") and Workspace.NPC:FindFirstChild("Shadow 1")
            if npc then task.spawn(function() pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end) end) end
            task.wait(1)
        else
            local itemBtn = SmartFindButton(talkingGui, _G_V10.ShadowItem)
            local amtBtn = SmartFindButton(talkingGui, _G_V10.ShadowAmount)
            task.wait(1.5)
            if itemBtn then PhysicalClick(itemBtn); task.wait(1); TapSafeEdge() elseif amtBtn then PhysicalClick(amtBtn); task.wait(1); TapSafeEdge() else task.wait(1); TapSafeEdge() end
        end
    end
end)

local raidPatrolState = "Wait_C1"
local raidPatrolTimer = os.clock()
local C1 = CFrame.new(-77, 119, -258)
local C2 = CFrame.new(-101, 114, 382)
local C3 = CFrame.new(-124, 114, 404)
local lastRaidTeleport = os.clock()

task.spawn(function()
    while task.wait(0.5) do
        if _G.YuiKillAllLoops then break end
        if _G_V10.AutoJoinGame then
            pcall(function() ReplicatedStorage.Assets.Remote.RemoteEvent.Di:FireServer() end)
            pcall(function() ReplicatedStorage.Assets.Remote.RemoteEvent.Home:FireServer("Dark Castle", "Sea", true) end)
        end
        
        local char = LocalPlayer.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hrp or char.Humanoid.Health <= 0 then continue end
        
        local distToRaidMap = (hrp.Position - Vector3.new(-123, 114, 407)).Magnitude
        
        if distToRaidMap < 3000 then 
            if _G_V10.AutoStartRaid then pcall(function() ReplicatedStorage.Assets.Remote.RemoteEvent.Starto:FireServer() end) end
            if _G_V10.AutoBuyRaid then
                local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
                if not talkingGui then
                    if not _G_V10.AutoFarmRaid and not _G_V10.AutoFarmBossRaid then
                        local targetPos = Vector3.new(-123, 114, 407)
                        if (hrp.Position - targetPos).Magnitude > 20 then hrp.CFrame = CFrame.new(targetPos); task.wait(_G_V10.RaidBuyTeleportDelay) end
                    end
                    local npc = Workspace:FindFirstChild("NPC") and Workspace.NPC:FindFirstChild("Dazzl")
                    if npc and (hrp.Position - npc:GetPivot().Position).Magnitude < 30 then
                        task.spawn(function() pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end) end)
                    end
                else
                    local buyBtn = SmartFindButton(talkingGui, "Buy with Beli")
                    if buyBtn then PhysicalClick(buyBtn) end
                end
            end
        else
            if _G_V10.AutoBuyRaid then
                local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
                if not talkingGui then
                    local targetPos = Vector3.new(-1371, 79, 3982)
                    if (hrp.Position - targetPos).Magnitude > 20 then hrp.CFrame = CFrame.new(targetPos); task.wait(_G_V10.RaidBuyTeleportDelay) end
                    local npc = Workspace:FindFirstChild("NPC") and Workspace.NPC:FindFirstChild("Dazzl")
                    if npc and (hrp.Position - npc:GetPivot().Position).Magnitude < 30 then
                        task.spawn(function() pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(npc, npc, npc) end) end)
                    end
                else
                    local buyBtn = SmartFindButton(talkingGui, "Buy with Beli")
                    if buyBtn then PhysicalClick(buyBtn) end
                end
            end
            if _G_V10.AutoTeleEntrance and os.clock() - lastRaidTeleport >= _G_V10.RaidEntranceDelay then
                hrp.CFrame = CFrame.new(-1346, 79, 3989); lastRaidTeleport = os.clock()
            end
        end
    end
end)

-- ==========================================
-- ENGINE: TUẦN TRA ĐẢO
-- ==========================================
local patrolIndex = 1
local patrolArrivalTime = 0
local currentPatrolIsland = nil

task.spawn(function()
    while task.wait() do
        if _G.YuiKillAllLoops then break end
        if not _G_V10.AutoPatrolIsland or #_G_V10.SelectedPatrolIslands == 0 then 
            currentPatrolIsland = nil
            continue 
        end
        
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        if patrolIndex > #_G_V10.SelectedPatrolIslands then patrolIndex = 1 end
        local islandName = _G_V10.SelectedPatrolIslands[patrolIndex]
        
        local islFolder = workspace:FindFirstChild("All") and workspace.All:FindFirstChild("Island")
        local targetIsland = islFolder and islFolder:FindFirstChild(islandName)
        
        if targetIsland then
            local islandPos = targetIsland:GetPivot().Position
            
            if currentPatrolIsland ~= islandName then
                currentPatrolIsland = islandName
                patrolArrivalTime = os.clock()
                hrp.CFrame = CFrame.new(islandPos + Vector3.new(0, tonumber(_G_V10.PatrolIslandHeight) or 0, 0))
                task.wait(1)
            end
            
            if os.clock() - patrolArrivalTime < tonumber(_G_V10.PatrolIslandTime) then
                local angle = tick() * (tonumber(_G_V10.PatrolIslandSpeed) / 5)
                local radius = tonumber(_G_V10.PatrolIslandRadius)
                local yOffset = tonumber(_G_V10.PatrolIslandHeight) or 0
                local offset = Vector3.new(math.cos(angle) * radius, yOffset, math.sin(angle) * radius)
                hrp.CFrame = CFrame.new(islandPos + offset, islandPos)
            else
                patrolIndex = patrolIndex + 1
                currentPatrolIsland = nil
            end
        else
            patrolIndex = patrolIndex + 1
            currentPatrolIsland = nil
            task.wait(1)
        end
    end
end)

-- ==========================================
-- ENGINE: VẬT LÝ AN TOÀN TUYỆT ĐỐI (KHÔNG CRASH)
-- ==========================================
table.insert(_G.YuiConnections, RunService.RenderStepped:Connect(function()
    if _G.YuiKillAllLoops then return end
    pcall(function() -- BỌC PCALL ĐỂ DÙ CÓ LỖI VẬT LÝ GAME CŨNG KHÔNG SẬP SCRIPT
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not hrp or not hum then return end

        local isNormalFarming = _G_V10.AutoFarmLevel or _G_V10.ManualQuestFarm or _G_V10.AutoFarmFree or _G_V10.FarmAll or _G_V10.AutoFarmRaid or _G_V10.AutoCoordMob or _G_V10.AutoWorldBoss or _G_V10.AutoNormalBoss or _G_V10.AutoFarmBossRaid
        
        if isNormalFarming and not _G_V10.FreeFly and not _G_V10.AutoPatrolIsland then
            -- TẠO LỰC ĐỠ
            local af = hrp:FindFirstChild("FarmAntiFall")
            if not af then
                af = Instance.new("BodyVelocity")
                af.Name = "FarmAntiFall"
                af.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                af.Velocity = Vector3.new(0, 0, 0)
                af.Parent = hrp
            end
            af.Velocity = Vector3.new(0, 0, 0)
            
            -- FIX ĐỨNG DẬY, NẰM NGANG
            if _G_V10.AttackPosition == "Trên Đầu" or _G_V10.AttackPosition == "Dưới Chân" or _G_V10.AttackPosition == "Xoay Tròn" or _G.IsLootingSun then
                hum.PlatformStand = true
            else
                hum.PlatformStand = false
            end
            
            -- TẮT VA CHẠM
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        else
            if hrp:FindFirstChild("FarmAntiFall") then hrp.FarmAntiFall:Destroy() end
            if not _G_V10.FreeFly then hum.PlatformStand = false end
        end
    end)
end))

local function GetPlayerLevel()
    local lvl = 1
    pcall(function()
        if LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Level") then lvl = tonumber(LocalPlayer.leaderstats.Level.Value)
        elseif LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level") then lvl = tonumber(LocalPlayer.Data.Level.Value) end
    end)
    return lvl or 1
end

local function GetMobForCurrentLevel()
    local myLevel = GetPlayerLevel(); local targetMob = QuestDB[1].MobName; local targetQuest = QuestDB[1].QuestName
    for i = 1, #QuestDB do if myLevel >= QuestDB[i].Level then targetMob = QuestDB[i].MobName; targetQuest = QuestDB[i].QuestName end end
    return targetMob, targetQuest
end

-- ==========================================
-- MAIN COMBAT ENGINE (TÌM QUÁI V1 NHANH NHẤT)
-- ==========================================
local currentSwapState = 1
local lastSwapTime = os.clock()
local lastSkillSpamTime = os.clock()

_G.CheckWorldBossIdx = 1
_G.WorldBossWaitStarted = nil
_G.CheckNormalBossIdx = 1
_G.NormalBossWaitStarted = nil

local lastGlobalDodge = os.clock()
local isGlobalDodging = false
local dodgeGlobalEndTime = 0

local function isValidMobByDatabase(mob)
    if not mob or not mob:IsA("Model") then return false end
    local hum = mob:FindFirstChild("Humanoid"); local hrp = mob:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp or hum.Health <= 0 then return false end
    if mob.Name == LocalPlayer.Name or Players:GetPlayerFromCharacter(mob) then return false end
    return true
end

local function DirectFind(name)
    local targetName = string.lower(name)
    for _, folderName in ipairs({"Monster", "Enemies", "NPC", "NPCs"}) do
        local folder = workspace:FindFirstChild(folderName)
        if folder then
            for _, v in ipairs(folder:GetDescendants()) do
                if string.lower(v.Name) == targetName and isValidMobByDatabase(v) then return v end
            end
        end
    end
    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("Model") and string.lower(v.Name) == targetName and isValidMobByDatabase(v) then return v end
    end
    return nil
end

task.spawn(function()
    while task.wait() do
        if _G.YuiKillAllLoops then break end
        if _G_V10.AutoPatrolIsland then continue end 
        
        local char = LocalPlayer.Character
        if not char then continue end
        local HRP = char:FindFirstChild("HumanoidRootPart")
        local Hum = char:FindFirstChild("Humanoid")
        
        if not HRP or not Hum or Hum.Health <= 0 then 
            lastWorldBossCheckTime = os.clock(); lastNormalBossCheckTime = os.clock()
            _G.WorldBossWaitStarted = nil; _G.NormalBossWaitStarted = nil
            _G.IsLootingSun = false
            task.wait(1); continue 
        end

        local isNormalFarming = _G_V10.AutoFarmLevel or _G_V10.ManualQuestFarm or _G_V10.AutoFarmFree or _G_V10.FarmAll or _G_V10.AutoFarmRaid or _G_V10.AutoCoordBoss or _G_V10.AutoNormalBoss or _G_V10.AutoFarmBossRaid or _G_V10.AutoCoordMob
        local isFarmingAction = isNormalFarming or (_G_V10.AutoSea and _G_V10.IsFightingSea)
        
        if isFarmingAction and not _G_V10.FreeFly then
            
            -- ================= LỤM SUN BATTERY ĐỘC LẬP =================
            local targetSun = nil
            if _G_V10.AutoSunBattery then
                local effects = workspace:FindFirstChild("Effects")
                if effects then
                    targetSun = effects:FindFirstChild("SunBattery") or effects:FindFirstChild("Sun Battery")
                end
                if not targetSun then targetSun = workspace:FindFirstChild("SunBattery") or workspace:FindFirstChild("Sun Battery") end
            end
            
            if targetSun then
                _G.IsLootingSun = true
                LblCoordInfo.Text = "Raid: Đang lụm Sun Battery!"
                local sunPos = targetSun:IsA("Model") and targetSun:GetPivot().Position or targetSun.Position
                HRP.CFrame = CFrame.new(sunPos)
                
                task.wait(0.2)
                local click = targetSun:FindFirstChild("FruitClick") or targetSun:FindFirstChildWhichIsA("ProximityPrompt", true)
                if click then
                    if click:IsA("ProximityPrompt") then fireproximityprompt(click)
                    elseif click:IsA("ClickDetector") then fireclickdetector(click) end
                end
                continue 
            else
                _G.IsLootingSun = false
            end

            local targetMobInstance = nil
            local highestLevel = -1
            local shortestDist = math.huge
            local targetWaitPos = nil
            
            -- ================= LỌC TÌM MỤC TIÊU =================
            if not (_G_V10.AutoSea and _G_V10.IsFightingSea) then
                
                -- TẦNG 1: WORLD BOSS
                if _G_V10.AutoWorldBoss and #_G_V10.SelectedWorldBosses > 0 then
                    local foundBoss = nil
                    for _, bossName in ipairs(_G_V10.SelectedWorldBosses) do
                        foundBoss = DirectFind(bossName); if foundBoss then break end
                    end
                    
                    if foundBoss then
                        targetMobInstance = foundBoss
                        LblCoordInfo.Text = "World Boss: Đang chém " .. foundBoss.Name
                        lastWorldBossCheckTime = os.clock(); _G.WorldBossWaitStarted = nil
                    else
                        local delay = math.max(0.5, tonumber(_G_V10.BossCheckDelay) or 5)
                        if os.clock() - lastWorldBossCheckTime >= delay then
                            if _G.CheckWorldBossIdx > #_G_V10.SelectedWorldBosses then _G.CheckWorldBossIdx = 1 end
                            local bossToCheck = _G_V10.SelectedWorldBosses[_G.CheckWorldBossIdx]
                            local dbInfo = CoordDB.WorldBosses[bossToCheck]
                            if dbInfo then
                                targetWaitPos = dbInfo.Pos; LblCoordInfo.Text = "World Boss: Bay Check " .. bossToCheck
                                if (HRP.Position - dbInfo.Pos).Magnitude <= 150 then
                                    if not _G.WorldBossWaitStarted then _G.WorldBossWaitStarted = os.clock()
                                    elseif os.clock() - _G.WorldBossWaitStarted >= 1.5 then
                                        _G.CheckWorldBossIdx = _G.CheckWorldBossIdx + 1; lastWorldBossCheckTime = os.clock(); _G.WorldBossWaitStarted = nil
                                    end
                                end
                            end
                        else
                            local timeLeft = math.max(0, math.floor(delay - (os.clock() - lastWorldBossCheckTime)))
                            LblCoordInfo.Text = string.format("World Boss: Đợi %d s để check...", timeLeft)
                        end
                    end
                end

                -- TẦNG 2: NORMAL BOSS 
                if not targetMobInstance and not targetWaitPos and _G_V10.AutoNormalBoss and #_G_V10.SelectedNormalBosses > 0 then
                    local foundBoss = nil
                    for _, bossName in ipairs(_G_V10.SelectedNormalBosses) do
                        foundBoss = DirectFind(bossName); if foundBoss then break end
                    end
                    
                    if foundBoss then
                        targetMobInstance = foundBoss
                        LblCoordInfo.Text = "Normal Boss: Đang chém " .. foundBoss.Name
                        lastNormalBossCheckTime = os.clock(); _G.NormalBossWaitStarted = nil
                    else
                        local delay = math.max(0.5, tonumber(_G_V10.BossCheckDelay) or 5)
                        if os.clock() - lastNormalBossCheckTime >= delay then
                            if _G.CheckNormalBossIdx > #_G_V10.SelectedNormalBosses then _G.CheckNormalBossIdx = 1 end
                            local bossToCheck = _G_V10.SelectedNormalBosses[_G.CheckNormalBossIdx]
                            local dbInfo = CoordDB.NormalBosses[bossToCheck]
                            if dbInfo then
                                targetWaitPos = dbInfo.Pos; LblCoordInfo.Text = "Normal Boss: Bay Check " .. bossToCheck
                                if (HRP.Position - dbInfo.Pos).Magnitude <= 150 then
                                    if not _G.NormalBossWaitStarted then _G.NormalBossWaitStarted = os.clock()
                                    elseif os.clock() - _G.NormalBossWaitStarted >= 1.5 then
                                        _G.CheckNormalBossIdx = _G.CheckNormalBossIdx + 1; lastNormalBossCheckTime = os.clock(); _G.NormalBossWaitStarted = nil
                                    end
                                end
                            end
                        else
                            if not _G_V10.AutoWorldBoss or #_G_V10.SelectedWorldBosses == 0 then
                                local timeLeft = math.max(0, math.floor(delay - (os.clock() - lastNormalBossCheckTime)))
                                LblCoordInfo.Text = string.format("Normal Boss: Đợi %d s để check...", timeLeft)
                            end
                        end
                    end
                end
                
                -- TẦNG 3: QUÁI TỌA ĐỘ 
                if not targetMobInstance and not targetWaitPos and _G_V10.AutoCoordMob and #_G_V10.SelectedCoordMobs > 0 then
                    local bestMob = nil; local firstWaitPos = nil; local bestMobName = ""
                    for _, selMobStr in ipairs(_G_V10.SelectedCoordMobs) do
                        local realName = selMobStr:match("%] (.*)$") or selMobStr:match("%] (.*)") or selMobStr:gsub("^%[.-%]%s+", "")
                        realName = realName:match("^%s*(.-)%s*$")
                        
                        local found = DirectFind(realName)
                        if found then
                            bestMob = found; bestMobName = realName; break
                        else
                            if not firstWaitPos then
                                local dbInfo = CoordDB.Mobs[realName]
                                if dbInfo then firstWaitPos = dbInfo.Pos end
                            end
                        end
                    end
                    
                    if bestMob then targetMobInstance = bestMob; LblCoordInfo.Text = "Tọa độ: Đang dọn " .. bestMobName
                    else if firstWaitPos then targetWaitPos = firstWaitPos; LblCoordInfo.Text = "Tọa độ: Chờ Quái ra..." end end
                end

                -- TẦNG 4: BOSS RAID SELUNA / PZOZOLOVE CÙNG IDLE PATROL
                if not targetMobInstance and not targetWaitPos and _G_V10.AutoFarmBossRaid and #_G_V10.SelectedRaidBosses > 0 then
                    for _, bossName in ipairs(_G_V10.SelectedRaidBosses) do
                        local b = DirectFind(bossName)
                        if b then targetMobInstance = b; break end
                    end
                    
                    if not targetMobInstance and _G_V10.AutoIdlePatrol then
                        local p1 = Vector3.new(129, 4691, -631)
                        local p2 = Vector3.new(155, 4691, -605)
                        if not _G.IdlePatrolState then _G.IdlePatrolState = "Pos1" end
                        if not _G.IdlePatrolTimer then _G.IdlePatrolTimer = os.clock() end
                        
                        targetWaitPos = (_G.IdlePatrolState == "Pos1") and p1 or p2
                        LblCoordInfo.Text = "Raid Boss: Đang tuần tra chờ Boss..."
                        
                        if (HRP.Position - targetWaitPos).Magnitude < 10 then
                            local waitTime = (_G.IdlePatrolState == "Pos1") and tonumber(_G_V10.IdleWait1) or tonumber(_G_V10.IdleWait2)
                            if os.clock() - _G.IdlePatrolTimer >= waitTime then
                                _G.IdlePatrolState = (_G.IdlePatrolState == "Pos1") and "Pos2" or "Pos1"
                                _G.IdlePatrolTimer = os.clock()
                            end
                        end
                    end
                end

                -- TẦNG 5: FARM TÙY CHỌN / CÀN QUÉT MAP / LEVEL / RAID THƯỜNG
                if not targetMobInstance and not targetWaitPos then
                    if _G_V10.AutoFarmLevel then
                        local mob, qName = GetMobForCurrentLevel(); _G_V10.CurrentTargetMob = {mob}; LblInfo.Text = "Farm Level: " .. qName
                    elseif _G_V10.ManualQuestFarm and _G_V10.SelectedManualQuest then
                        for _, v in pairs(QuestDB) do if v.QuestName == _G_V10.SelectedManualQuest then _G_V10.CurrentTargetMob = {v.MobName}; LblInfo.Text = "Farm Thủ Công: " .. v.QuestName end end
                    elseif _G_V10.AutoFarmFree and type(_G_V10.SelectedMonsters) == "table" and #_G_V10.SelectedMonsters > 0 then
                        _G_V10.CurrentTargetMob = _G_V10.SelectedMonsters; LblInfo.Text = "Đang Farm Tùy Chọn"
                    elseif _G_V10.FarmAll then LblInfo.Text = "Đang Càn Quét (Farm All)"
                    end

                    for _, folderName in ipairs({"Monster", "Enemies"}) do
                        local folder = workspace:FindFirstChild(folderName)
                        if folder then
                            for _, v in ipairs(folder:GetDescendants()) do
                                if isValidMobByDatabase(v) then
                                    local isValidTarget = false
                                    local isEx = false
                                    for _, ex in pairs(_G_V10.ExcludedMobs) do if string.find(string.lower(v.Name), ex) then isEx = true break end end
                                    
                                    if not isEx then
                                        if (_G_V10.AutoFarmRaid or _G_V10.AutoFarmRaidHard) then
                                            local distToRaidMap = (HRP.Position - Vector3.new(-123, 114, 407)).Magnitude
                                            if distToRaidMap < 3000 then isValidTarget = true end
                                        elseif _G_V10.FarmAll then isValidTarget = true
                                        elseif _G_V10.AutoFarmFree and type(_G_V10.SelectedMonsters) == "table" and table.find(_G_V10.SelectedMonsters, v.Name) then isValidTarget = true 
                                        elseif _G_V10.AutoFarmLevel and _G_V10.CurrentTargetMob and table.find(_G_V10.CurrentTargetMob, v.Name) then isValidTarget = true
                                        elseif _G_V10.ManualQuestFarm and _G_V10.CurrentTargetMob and table.find(_G_V10.CurrentTargetMob, v.Name) then isValidTarget = true
                                        end
                                    end
                                    
                                    if isValidTarget then
                                        local dist = (HRP.Position - v.HumanoidRootPart.Position).Magnitude
                                        local lvlMatch = string.match(v.Name, "%[%D*(%d+)%]"); local mobLvl = lvlMatch and tonumber(lvlMatch) or 0
                                        if mobLvl > highestLevel then highestLevel = mobLvl; shortestDist = dist; targetMobInstance = v
                                        elseif mobLvl == highestLevel then if dist < shortestDist then shortestDist = dist; targetMobInstance = v end end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            -- ================= GLOBAL SAFE HP LÝ TƯỞNG =================
            local hpPct = (Hum.Health / Hum.MaxHealth) * 100
            if _G_V10.GlobalSafeHP and targetMobInstance then
                local triggerDodge = false
                if hpPct <= tonumber(_G_V10.GlobalSafeHP_Min) then triggerDodge = true end
                if _G_V10.GlobalSafeHP_Timer and tonumber(_G_V10.GlobalSafeHP_Time) > 0 and (os.clock() - lastGlobalDodge) >= tonumber(_G_V10.GlobalSafeHP_Time) then triggerDodge = true end
                
                if triggerDodge and not isGlobalDodging then
                    if _G_V10.GlobalSafeHP_Spin then isGlobalDodging = true; dodgeGlobalEndTime = os.clock() + 5
                    else isGlobalDodging = false; lastGlobalDodge = os.clock() end
                end
                
                if isGlobalDodging then
                    if hpPct > tonumber(_G_V10.GlobalSafeHP_Min) + 15 and os.clock() >= dodgeGlobalEndTime then isGlobalDodging = false; lastGlobalDodge = os.clock() end
                end
            else isGlobalDodging = false end

            -- ================= HÀNH ĐỘNG CỦA NHÂN VẬT =================
            if targetMobInstance or (_G_V10.AutoSea and _G_V10.IsFightingSea) then
                raidPatrolState = "Wait_C1"; raidPatrolTimer = os.clock()
                
                local forcePzozoSpin = false
                if targetMobInstance and string.lower(targetMobInstance.Name) == "pzozolove112" and _G_V10.AlwaysSpinPzozo then forcePzozoSpin = true end

                -- CHỈ XẢ SKILL VŨ KHÍ NẾU KHÔNG PHẢI LÀ PZOZO SPIN VÀ KHÔNG NÉ
                if not isGlobalDodging and not forcePzozoSpin then
                    if _G_V10.AutoSwapWeapon and _G_V10.PrimaryWeapon and _G_V10.SecondaryWeapon then
                        if currentSwapState == 1 then
                            local wp = LocalPlayer.Backpack:FindFirstChild(_G_V10.PrimaryWeapon); if wp then Hum:EquipTool(wp) end
                            if os.clock() - lastSwapTime >= _G_V10.HoldTime1 then currentSwapState = 2; lastSwapTime = os.clock() end
                        elseif currentSwapState == 2 then
                            local wp = LocalPlayer.Backpack:FindFirstChild(_G_V10.SecondaryWeapon); if wp then Hum:EquipTool(wp) end
                            if os.clock() - lastSwapTime >= _G_V10.HoldTime2 then currentSwapState = 1; lastSwapTime = os.clock() end
                        end
                    elseif _G_V10.AutoEquip and _G_V10.SelectedWeapon then
                        local wp = LocalPlayer.Backpack:FindFirstChild(_G_V10.SelectedWeapon); if wp then Hum:EquipTool(wp) end
                    end

                    if _G_V10.AutoClick then
                        local equippedTool = char:FindFirstChildWhichIsA("Tool"); if equippedTool then equippedTool:Activate() end
                    end
                end
                
                if targetMobInstance then
                    if isGlobalDodging then
                        local angle = tick() * 3
                        local radius = tonumber(_G_V10.GlobalDodgeRadius) or 50
                        local mobPos = targetMobInstance.HumanoidRootPart.Position
                        local dodgeOffset = Vector3.new(math.cos(angle) * radius, 20, math.sin(angle) * radius)
                        HRP.CFrame = CFrame.new(mobPos + dodgeOffset, mobPos)
                    elseif forcePzozoSpin then
                        local angle = tick() * tonumber(_G_V10.PzozoSpinSpeed)
                        local radius = tonumber(_G_V10.PzozoSpinRadius)
                        local mobPos = targetMobInstance.HumanoidRootPart.Position
                        local dodgeOffset = Vector3.new(math.cos(angle) * radius, 20, math.sin(angle) * radius)
                        HRP.CFrame = CFrame.new(mobPos + dodgeOffset, mobPos)
                    else
                        local mobPos = targetMobInstance.HumanoidRootPart.Position
                        if _G_V10.AttackPosition == "Trên Đầu" then 
                            HRP.CFrame = CFrame.new(mobPos + Vector3.new(0, _G_V10.AttackDistance, 0)) * CFrame.Angles(math.rad(-90), 0, 0)
                        elseif _G_V10.AttackPosition == "Dưới Chân" then 
                            HRP.CFrame = CFrame.new(mobPos + Vector3.new(0, -_G_V10.AttackDistance, 0)) * CFrame.Angles(math.rad(90), 0, 0)
                        elseif _G_V10.AttackPosition == "Xoay Tròn" then
                            local angle = tick() * 3
                            local radius = _G_V10.AttackDistance
                            local offset = Vector3.new(math.cos(angle) * radius, 20, math.sin(angle) * radius)
                            HRP.CFrame = CFrame.new(mobPos + offset, mobPos)
                        else
                            HRP.CFrame = targetMobInstance.HumanoidRootPart.CFrame * CFrame.new(0, 0, _G_V10.AttackDistance)
                        end
                    end
                end
            else
                -- NÂNG ĐỘ CAO +40 ĐỂ TRÁNH TRÔI XUỐNG ĐẤT NƯỚC KHI KHÔNG CÓ QUÁI
                if targetWaitPos then
                    local safeWaitPos = targetWaitPos + Vector3.new(0, 40, 0) 
                    if (HRP.Position - safeWaitPos).Magnitude > 50 then HRP.CFrame = CFrame.new(safeWaitPos) 
                    else HRP.CFrame = CFrame.new(safeWaitPos) end
                elseif _G_V10.AutoFarmRaid then
                    local distToRaidMap = (HRP.Position - Vector3.new(-123, 114, 407)).Magnitude
                    if distToRaidMap < 3000 then
                        if raidPatrolState == "Wait_C1" then
                            if (HRP.Position - C1.Position).Magnitude > 10 then HRP.CFrame = C1; raidPatrolTimer = os.clock()
                            elseif os.clock() - raidPatrolTimer >= tonumber(_G_V10.RaidWaitC1) then raidPatrolState = "Wait_C2"; raidPatrolTimer = os.clock() end
                        elseif raidPatrolState == "Wait_C2" then
                            if (HRP.Position - C2.Position).Magnitude > 10 then HRP.CFrame = C2; raidPatrolTimer = os.clock()
                            elseif os.clock() - raidPatrolTimer >= tonumber(_G_V10.RaidWaitC2) then raidPatrolState = "Wait_C3"; raidPatrolTimer = os.clock() end
                        elseif raidPatrolState == "Wait_C3" then
                            if (HRP.Position - C3.Position).Magnitude > 10 then HRP.CFrame = C3; raidPatrolTimer = os.clock()
                            elseif os.clock() - raidPatrolTimer >= tonumber(_G_V10.RaidWaitC3) then raidPatrolState = "Wait_C2"; raidPatrolTimer = os.clock() end
                        end
                    end
                end
            end
        end
    end
end)

-- ==========================================
-- ENGINE: SEA EVENT ĐỘC LẬP
-- ==========================================
local function GetTargetSeaEvent()
    local monsterFolder = workspace:FindFirstChild("Monster")
    if not monsterFolder then return nil end
    for _, v in pairs(monsterFolder:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local isSeaMonster = (v.Name == "Sea Monster")
            local isGhost = string.find(v.Name, "The Starving Ghost")
            if (isSeaMonster and _G_V10.HuntSeaMonster) or (isGhost and _G_V10.HuntGhost) then return v end
        end
    end
    return nil
end

local wasAutoSeaOn = false
task.spawn(function()
    while task.wait() do 
        if _G.YuiKillAllLoops then break end
        if not _G_V10.AutoSea then 
            if wasAutoSeaOn then VIM:SendKeyEvent(false, Enum.KeyCode.W, false, game); wasAutoSeaOn = false end
            _G_V10.ArrivedAtZone = false; continue 
        else wasAutoSeaOn = true end
        
        local char = LocalPlayer.Character; local HRP = char and char:FindFirstChild("HumanoidRootPart"); local Hum = char and char:FindFirstChild("Humanoid")
        if not char or not HRP or not Hum or Hum.Health <= 0 then continue end

        local targetMonster = GetTargetSeaEvent()
        local myBoatName = LocalPlayer.Name .. "Boat"; local boatFolder = workspace:FindFirstChild("Boats"); local myBoat = boatFolder and boatFolder:FindFirstChild(myBoatName)

        if targetMonster then
            _G_V10.IsFightingSea = true; VIM:SendKeyEvent(false, Enum.KeyCode.W, false, game); if Hum.Sit then Hum.Sit = false end
            if targetMonster.Name == "Sea Monster" then
                local radius = 25; local angle = tick() * 2
                local rootPos = targetMonster.HumanoidRootPart.Position
                HRP.CFrame = CFrame.new(rootPos + Vector3.new(math.cos(angle) * radius, 20, math.sin(angle) * radius), rootPos)
            else
                HRP.CFrame = targetMonster.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0) * CFrame.Angles(math.rad(-90),0,0)
            end
        else
            if _G_V10.IsFightingSea then _G_V10.IsFightingSea = false; VIM:SendKeyEvent(false, Enum.KeyCode.W, false, game) end
            
            if not myBoat then
                _G_V10.ArrivedAtZone = false
                local shopPos = Vector3.new(-16021, 58, 11133)
                if (HRP.Position - shopPos).Magnitude > 20 then
                    HRP.CFrame = CFrame.new(shopPos)
                    task.wait(1)
                end
                local spawner = workspace:FindFirstChild("NPC") and workspace.NPC:FindFirstChild("BoatSpawner")
                if spawner then
                    if (HRP.Position - spawner:GetPivot().Position).Magnitude < 30 then
                        task.spawn(function() pcall(function() ReplicatedStorage.Assets.Remote.RemoteFunction.Talking:InvokeServer(spawner, spawner, spawner) end) end)
                        task.wait(0.5)
                        local talkingGui = LocalPlayer.PlayerGui:FindFirstChild("Talking")
                        if talkingGui then
                            local btn = SmartFindButton(talkingGui, "Galleon") or SmartFindButton(talkingGui, "Galleon $1K")
                            if btn then PhysicalClick(btn); task.wait(0.5); TapSafeEdge() end
                        end
                    end
                end
            else
                local seat = myBoat:FindFirstChild("VehicleSeat", true)
                if seat then
                    local selZone = _G_V10.SelectedSeaZone or "Zone 1"
                    local targetZone = CoordDB.SeaZones[selZone] or Vector3.new(-19800, 86, 16940)
                    local safeZone = targetZone + Vector3.new(0, 30, 0)

                    if not _G_V10.ArrivedAtZone or (seat.Position - targetZone).Magnitude > 2000 then
                        if Hum.Sit then Hum.Sit = false; task.wait(0.2) end
                        if myBoat:IsA("Model") and myBoat.PrimaryPart then 
                            myBoat:PivotTo(CFrame.new(safeZone)) 
                        else 
                            seat.CFrame = CFrame.new(safeZone) 
                        end
                        task.wait(0.5)
                        
                        if _G_V10.AutoSitBoat then 
                            HRP.CFrame = seat.CFrame + Vector3.new(0, 5, 0)
                            task.wait(0.2)
                            seat:Sit(Hum) 
                        end
                        _G_V10.ArrivedAtZone = true 
                    else
                        if _G_V10.AutoSitBoat and not Hum.Sit then 
                            HRP.CFrame = seat.CFrame + Vector3.new(0, 5, 0)
                            task.wait(0.2)
                            seat:Sit(Hum) 
                        end
                        if Hum.Sit then
                            VIM:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                        end
                    end
                end
            end
        end
    end
end)
