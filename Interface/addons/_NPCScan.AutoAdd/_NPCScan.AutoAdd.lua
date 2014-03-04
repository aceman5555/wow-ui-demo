
--Updated 10/18 for _NPCSCAN v5.4.0.5
local f = CreateFrame("Frame")

f:RegisterEvent("PLAYER_TARGET_CHANGED")
f:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
f:RegisterEvent("PLAYER_LOGIN")


--Sync removedNo longer needed as added custom NPC's are global to all characters now


--Generates a list of MobIDs for Achievement Mobs
local AchievementMobIDs = {}

local function AchievementNPCS()
	for _, achievement in pairs(_NPCScan.ACHIEVEMENTS) do

	--local achievement =  _NPCScan.ACHIEVEMENTS[achievement_id]

		for criteria_id, npc_id in pairs(achievement.Criteria) do
			if npc_id > 1 then
				AchievementMobIDs[npc_id] = true;
			end
		end
	end
end

-- Format time for the timer
local function FormatTime(sec)
	local hour = floor(sec/3600)
	local mins = floor((sec-3600*hour)/60)
	local secs = floor(sec - 3600*hour - 60*mins)
	local h,m = 1,1
	if ( hour < 1 ) then
		hour = ""
		h = nil
	elseif ( hour < 10 ) then
		hour = "0"..hour
	end
	if ( mins < 1 ) then
		mins = ""
		m = nil
	elseif ( mins < 10 ) then
		mins = "0"..mins
	end
	if ( secs < 10 ) then
		secs = "0"..secs
	end
	if ( h ) then
		return hour..":"..mins..":"..secs
	else
		return mins..":"..secs
	end
end

-- Display a timer showing time after detection
local hooked = false
local function Timer()
	CreateFrame("Frame","AutoAddTimer")
	AutoAddTimer:SetWidth(10)
	AutoAddTimer:SetHeight(10)
	AutoAddTimer.time = AutoAddTimer:CreateFontString()
	AutoAddTimer.time:SetFont("Fonts\\FRIZQT__.TTF",12,"OUTLINE")
	AutoAddTimer.time:SetPoint("CENTER")
	AutoAddTimer.start = function()
		if ( _NPCScan.Button ) then
			AutoAddTimer:SetPoint("TOP",_NPCScan.Button,"BOTTOM",0,0)
			AutoAddTimer.ref = GetTime()
			AutoAddTimer.time:SetText("--:--")
			AutoAddTimer.update = 0
			AutoAddTimer:SetScript("OnUpdate",function(self)
				if ( AutoAddTimer.update < GetTime() ) then
					AutoAddTimer.time:SetText(FormatTime(GetTime() - AutoAddTimer.ref))
					AutoAddTimer.update = GetTime() + 0.1
				end
			end)
			if ( not hooked ) then
				_NPCScan.Button:HookScript("OnHide",function()
					AutoAddTimer:Hide()
				end)
				_NPCScan.Button:HookScript("OnShow",function()
					AutoAddTimer.start()
				end)
				hooked = true
			end
			AutoAddTimer:Show()
		end
	end
end

-- Fix the saved variable upon first login
local function OnLogin()
	if type(_NPCScan_AutoAdd) ~= "table" then
		_NPCScan_AutoAdd = {}
		_NPCScan_AutoAdd["NPCs"] = {}
		_NPCScan_AutoAdd["NPCWorldIDs"] = {}
	end
	AchievementNPCS()
	Timer()
end

-- Check what kind or mob the player has targeted / mouseovered
-- and add it if it's a rare
local function NewMob(unit)
	local Classi = UnitClassification(unit)
	local Rare = false
	if strfind(Classi,"rare") then
		Classi = strupper(strsub(Classi,1,1))..strsub(Classi,2)
		if strfind(Classi,"rareelite") then
			Classi = strsub(Classi,1,4).." "..strupper(strsub(Classi,5,5))..strsub(Classi,6)
		end
		Rare = true
	end
	local NPS = _G._NPCScan
	if Rare then 
		local NPC_ID = tonumber((UnitGUID(unit)):sub(-12, -9), 16)
		local NPC_WID = GetCurrentMapContinent()
		if NPC_WID == 5 then
			NPC_WID = "Deepholm"
		end

	--Added check to see if mob is in the defaut list of rare mobs, rare tameable mobs, or an achievement mob
		if not _NPCScanOptions["NPCs"][NPC_ID] and not AchievementMobIDs[NPC_ID] then

			_NPCScanOptions["NPCs"][NPC_ID] = UnitName(unit)
			_NPCScanOptions["NPCWorldIDs"][NPC_ID] = NPC_WID
			_NPCScan_AutoAdd["NPCs"][NPC_ID] = UnitName(unit)
			_NPCScan_AutoAdd["NPCWorldIDs"][NPC_ID] = NPC_WID
			
			--Since the rare is found by mouseover or targeting it will already be cached
			--when it's added to the "look for" list, thus preventing the alarm. Therefore
			--we set of the alarm manually the first time the new rare is added
			
			print("|cff33ee00Found NPC:|r |cffCCCCCC"..UnitName(unit).."|r")
			_NPCScan.Button:SetNPC( NPC_ID, UnitName(unit) )
			AutoAddTimer.start()
		end
	end
end



f:SetScript("OnEvent",function(self,event,...)
	if event == "UPDATE_MOUSEOVER_UNIT" then
		NewMob("Mouseover")
	elseif event == "PLAYER_TARGET_CHANGED" then
		NewMob("Target")
	elseif event == "PLAYER_LOGIN" then
		OnLogin()
	end
end)

