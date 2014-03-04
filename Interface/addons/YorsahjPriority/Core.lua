local yorsahjID = "D810" --in hex since that's how game gives it

local summonIDs = {
	[105420] = { --Purple, Green, Blue; Black
		lfr = "234",
		normal = "234",
		heroic = "1234",
	},
	[105435] = { --Green, Red, Black; Blue
		lfr = "135",
		normal = "135",
		heroic = "1235",
	},
	[105436] = { --Green, Yellow, Red; Black
		lfr = "356",
		normal = "356",
		heroic = "1356",
	},
	[105437] = { --Blue, Purple, Yellow; Green
		lfr = "246",
		normal = "246",
		heroic = "2346",
	},
	[105439] = { --Blue, Black, Yellow; Purple
		lfr = "126",
		normal = "126",
		heroic = "1246",
	},
	[105440] = { --Purple, Red, Black; Yellow
		lfr = "145",
		normal = "145",
		heroic = "1456",
	},
}

local timeAtLastWarning = 0

local function ReplaceIcons(message)
	local term
	for tag in string.gmatch(message, "%b{}") do
		term = strlower(string.gsub(tag, "[{}]", ""));
		if ( ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]] ) then
			message = string.gsub(message, tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t");
		end
	end
	return message
end

local addonName, addon = ...
LibStub("AceAddon-3.0"):NewAddon(addon, addonName, "AceEvent-3.0")

function addon:OnInitialize()
	self:SetupDB()
	self:SetupOptions()
	self:SetEnabledState(self.db.global.enabled)
end

function addon:OnEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
end

function addon:UNIT_SPELLCAST_SUCCEEDED(event, unitID, spell, rank, lineID, spellID)
	if not summonIDs[spellID] then return end
	local mode
	if IsInLFGDungeon() then
		mode = "lfr"
	else
		local difficulty = GetInstanceDifficulty()
		if difficulty == 1 or difficulty == 2 then
			mode = "normal"
		else
			mode = "heroic"
		end
	end
	if not self.db.global.modesEnabled[mode] then return end --abort if this difficulty mode is disabled
	self.killGlobule = self.db.global.priorities[mode][summonIDs[spellID][mode]]
	self:OutputWarning()
end
	
function addon:OutputWarning()
	local currentTime = GetTime()
	if currentTime - timeAtLastWarning < 1 then return end
	timeAtLastWarning = currentTime
	local announceSettings = self.db.global.announces
	if announceSettings.yell then
		SendChatMessage(self.killGlobule, "YELL")
	end
	if announceSettings.raid then
		SendChatMessage(self.killGlobule, "RAID")
	end
	if announceSettings.raidWarning then
		if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
			SendChatMessage(self.killGlobule, "RAID_WARNING")
		end
	end
	if announceSettings.privateRaidWarning then
		RaidNotice_AddMessage(RaidWarningFrame, ReplaceIcons(self.killGlobule), ChatTypeInfo["RAID_WARNING"])
		PlaySoundFile("Sound\\Interface\\RaidWarning.wav")
	end
	if announceSettings.privateChatMessage then
		print(ReplaceIcons(self.killGlobule))
	end
end