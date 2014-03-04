local Addon, TA = ...
local _

-- Generic Locals
local on = true
local off = false
local PerSec = 8 -- run the Queue scan X times a second
local AnnounceDupeTime = 1 -- Duplicate announce filter time (if same spell happens within x seconds by same person it won't announce it)
local ToTell = false -- flag if something to tattle happens

-- Addon Settings
TauntAware_Settings = {}
local TAS = nil 
TauntAware_Default_Settings = {
	Enable = on,
	Solo = off,
	Full = off,
	AlertSound = "alert1.mp3",
	MF = on,
	MFAutoScale = on,
	MFScale = 100,
	FontSize = 10,
	FadeDelay = 15,
	TauntsOnly = "on", -- "on", "off", "monitor"
	PetTaunts = "on", -- "on", "off", "mute"
	Links = on,
	Scan = on,
	ScanDelay = 5,
	Tattle = off,
	TatMode = "GROUP", -- either WHISPER, GROUP, SUMMARY (summary just prints to you)
}

TauntAware_PC = {}

-- Bill's Utils
local SJprint = BillsUtils.SJprint
local addOptionMt = BillsUtils.addOptionMt
local StatColor = BillsUtils.StatColor
local OptSaveTF = BillsUtils.OptSaveTF
local OptSaveVal = BillsUtils.OptSaveVal
local CCC = BillsUtils.CCC

BillsUtils.Locals[#BillsUtils.Locals +1] = function ()
	SJprint = BillsUtils.SJprint
	addOptionMt = BillsUtils.addOptionMt
	StatColor = BillsUtils.StatColor
	OptSaveTF = BillsUtils.OptSaveTF
	OptSaveVal = BillsUtils.OptSaveVal
	CCC = BillsUtils.CCC
end

-- Local Misc Functions
-- local PlayerLinkTemplate = "|Hplayer:%s|h[%s]|h|r"
local SpellLinkTemplate = "|cff71d5ff|Hspell:%d|h[%s]|h|r"

-- Message Frame Control
local MFShown = false
local MFShownTime = 0
local MFShowTimeWarn = 30

-- Local text colors
local yel = "|cFFFFFF00"
local wht = "|cFFFFFFFF"
local blu = "|cFF00FFFF"
local red = "|cFFFF0000"
local grn = "|cFF00FF00"
local res = "|r"

local SpellList = {}
-- SpellId 

SpellList = {
	--MONK
	[115546] = true, -- Provoke
	[122057] = true, -- Clash
	[115180] = true, -- Dizzying Haze
	
	--DRUID
	--SPELL_CAST_SUCCESS
	[6795] = true,	-- Growl
	[5209] = true,	-- Challenging Roar

	--HUNTER
	--SPELL_CAST_SUCCESS
	[34477] = true,	-- Misdirection
	[20736] = true,	-- Distracting Shot

	--MAGE

	--PALADIN
	--SPELL_CAST_SUCCESS
	[31789] = true,	-- Righteous Defense
	[62124] = true,	-- Hand of Reckoning
	[25780] = true,	-- Righteous Fury

	--PRIEST
	
	--ROGUE
	--SPELL_CAST_SUCCESS
	[57934] = true,	-- Tricks of the Trade

	--SHAMAN
	--SPELL_CAST_SUCCESS
	[8056] = true,	-- Frost Shock
	--"SPELL_AURA_APPLIED"
	[73684] = true,	-- Unleash Earth

	--WARLOCK
	--"SPELL_CAST_SUCCESS"
	[97827] = true, -- Provocation

	--WARRIOR
	--SPELL_CAST_SUCCESS
	[355] = true,	-- Taunt
	[1161] = true,	-- Fury
	--	[57755] = true,	-- Heroic Throw
	[71] = true,	-- Defensive Stance

	--DEATHKNIGHT
	--SPELL_CAST_SUCCESS
	[48263] = true,	-- Blood Presence
	[49576] = true,	-- Death Grip
	[56222] =  true,	-- Dark Command

	--PETS
	-- Warlock Pets
	[17735] = true,	-- Suffering
	[3716] = true,	-- Torment
	-- Hunter Pets
	[2649] = true,	-- Growl
	[53477] = true,	-- Taunt
	[24394] = true,	-- Intimidation
	[63900] = true,	-- Thunderstomp
}

local ScanSpells = {
	[25780] = true,	-- Pally	Righteous Fury
	[48263] = true,	-- DK		Blood Presence
	[71] = true,	-- War 		Defensive Stance
	[115069] = true, -- Monk	Stance of the Sturdy Ox
	[114168] = true, -- Warlock	Dark Apotheosis
}

TA.MsgOut = function( message )
	if TAS.MF then
		TA.MF:AddMessage( message )
	else	
		print( message )
	end
	return
end
	

local LastPartyMembers ={}
local ScanComplete = false
TA.ScanGroup = function( UserCalled )
	local Count = GetNumGroupMembers()
	local Raid = IsInRaid()
	local Type = ""
	local msg
		
	if Raid then
		Type = "raid"
	elseif Count > 0 then
		Type = "party"
	elseif UserCalled then
		Type = "self"
	else
		return
	end
	
	local changed = false
	
	if Count ~= #LastPartyMembers then
		changed = true
	elseif Count == 0 and UserCalled then
		--
	else
		for x = 1, Count do
			if LastPartyMembers[x] ~= UnitName(Type..tostring(x)) then
				changed = true
			end
		end
	end
		
	if not(changed) and not(UserCalled) then
		return
	end
	
	msg = ("%sTaunt Aware|r %s started on %d group members at %s"):format( yel, UserCalled and "scan" or "auto scan", Count , date("%I:%M:%S %p") )
		
	TA.MsgOut( msg )
	
	table.wipe(LastPartyMembers)
	local msg
	if Count > 0 then
		for x = 1, Count do
			LastPartyMembers[x] = UnitName(Type..tostring(x))
			local role = UnitGroupRolesAssigned(Type..tostring(x))
			if role ~= "TANK" then
				for y = 1, 40 do
					local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura( Type..tostring(x), y)
					if not spellId then
						break
					end
					if ScanSpells[spellId] then
						local _, class = UnitClass(Type..tostring(x))
						local charName = UnitName(Type..tostring(x))
						local charNameLink = ("|Hplayer:%s|h%s|h|r"):format(charName, charName)
						local spellLink = ("|cff71d5ff|Hspell:%s|h[%s]|h|r"):format(spellId, name)
						msg = ("%s<Taunt Aware> %s%s|r has %s on"):format(yel, CCC(class), (TAS.Links and charNameLink or charName), (TAS.Links and spellLink or "|cff71d5ff"..name.."|r"))
						TA.MsgOut( msg )
					end
				end
			end
		end
	end
	if Type == "party" or Type == "self" then
		local role = UnitGroupRolesAssigned("player")
		if role ~= "TANK" then
			for y = 1, 40 do
				local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura( "player" , y)
				if not spellId then
					break
				end
				if ScanSpells[spellId] then
					local _, class = UnitClass("player")
					local charName = UnitName("player")
					local charNameLink = ("|Hplayer:%s|h%s|h|r"):format(charName, charName)
					local spellLink = ("|cff71d5ff|Hspell:%s|h[%s]|h|r"):format(spellId, name)
					msg = ("%s<Taunt Aware> %s%s|r has %s on"):format(yel, CCC(class), (TAS.Links and charNameLink or charName), (TAS.Links and spellLink or "|cff71d5ff"..name.."|r"))
					TA.MsgOut( msg )
				end
			end
		end
	end
	
	-- Millisecond time complete hack (announces on next screen draw)
	ScanComplete = UserCalled and 1 or 2
	return
end

local scanTool = CreateFrame( "GameTooltip", "ScanTooltip", nil, "GameTooltipTemplate" )
scanTool:SetOwner( WorldFrame, "ANCHOR_NONE" )
local scanText = _G["ScanTooltipTextLeft2"] -- This is the line with <[Player]'s Pet>

function getPetOwner(petName)
	scanTool:ClearLines()
	scanTool:SetUnit(petName)
	local ownerText = scanText:GetText()
	if not ownerText then return false end
	local owner, _ = string.split("'",ownerText) -- english
	if UnitExists(owner) then return owner end
	owner = { string.split(" ", ownerText) }
	for x = #owner, 1, -1 do
		if UnitExists(owner[x]) then
			return owner[x]
		end
	end
	
	return false -- This is for error catching 
end

local AlertSoundFile = ""
local Queue = {}
local ScanDelay = false

TA.Frame = CreateFrame("Frame", nil, UIParent)
TA.Frame:RegisterEvent("ADDON_LOADED")
TA.Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
TA.Frame:RegisterEvent("GROUP_ROSTER_UPDATE")
TA.Frame:RegisterEvent("UI_SCALE_CHANGED")
TA.Frame:RegisterEvent("PLAYER_REGEN_ENABLED")

TA.Frame:SetScript("OnEvent",function(self, event, ...)
	if event == "ADDON_LOADED" then
		local arg = ...
		if arg == Addon then
			SJprint(yel, "Taunt Aware v",red, GetAddOnMetadata(Addon, "Version"), yel, "loaded", res)
			addOptionMt( TauntAware_Settings, TauntAware_Default_Settings )
			TAS = TauntAware_Settings
			local realm = GetRealmName()
			local player = UnitName("player")
			if not TauntAware_PC[realm] then
				TauntAware_PC[realm] = {}
			end
			if not TauntAware_PC[realm][player] then
				TauntAware_PC[realm][player] = {}
			end
			PC = TauntAware_PC[realm][player]
			if not(PC.MsgFrameSet) then
				PC.MsgFrameSet = true
				TA.MsgFrameUnlock()
				TA.MF:AddMessage("Move this frame to where you would like then type \"/tamf lock\" to save the position", 1, 1, 1 )
			else
				TA.MsgFrameLock()
			end
			
			-- variable upgrade here
			if type(TAS.TauntsOnly) == "boolean" then
				if TAS.TauntsOnly then
					TA.CmdLine( "tauntsonly on")
				else
					TA.CmdLine( "tauntsonly off")
				end
			end
		
			TA.TAS = TAS
			TA.TAD = TAD
			TA.SettingsUpdate()
		end		
		return self, event, ...
	end
	
	if not(TAS.Enable) then return end
	if event == "UI_SCALE_CHANGED" then
		if TAS.MFAutoScale then
			local UIScale = UIParent:GetScale()
			TAS.MFScale =  math.floor((1/UIScale)*100)
			SJprint(yel, "Taunt Aware:", wht, "message frame scale auto adjusted", res)
			TA.MF:SetScale(TAS.MFScale / 100 )
		end
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		TA.LocalAnnounce( ... )
	elseif event == "PLAYER_REGEN_ENABLED" then
		TA.GroupAnnounce()
	elseif (event == "GROUP_ROSTER_UPDATE") and TAS.Scan and not( ScanDelay ) then
		ScanDelay = TAS.ScanDelay
	end	
	return
end)

local last = {}
local TattleQueue = {}
TA.LocalAnnounce = function(...)
	local PlayerRole = UnitGroupRolesAssigned("player")
	local timestamp, eventType, hidecaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2, spellId, spellName = ...
	local ValidUnit = UnitExists(sourceName)
	local ValidSpellWarn = type(SpellList[spellId]) == "boolean"
	local ValidEvent = eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_AURA_APPLIED"
	if not(ValidUnit) or not(ValidSpellWarn) or not(ValidEvent) then return end
	if last.sourceName == sourceName and last.spellId == spellId and (timestamp - last.timestamp < AnnounceDupeTime ) then return end --Duplicate announce check
	last.sourceName = sourceName
	last.spellId = spellId
	last.timestamp = timestamp
	
	local Pet
	local PC
	do
		local B = tonumber(sourceGUID:sub(5,5), 16);
		local maskedB = B % 8; -- x % 8 has the same effect as x & 0x7 on numbers <= 0xf
		-- local knownTypes = {[0]="player", [3]="NPC", [4]="pet", [5]="vehicle"};
		Pet = maskedB == 4
		PC = maskedB == 0 
	end
	
	local Self = PC and UnitIsUnit(sourceName, "player")
	local SelfPet = Pet and UnitIsUnit(sourceName, "pet")
	local inGroup = IsInGroup()
		
	if Pet and TAS.PetTaunts == "off" then
		return
	elseif inGroup then
		if TAS.Full or PlayerRole == "TANK" then
			--Announce = true
		elseif PlayerRole == "DAMAGER" and (Self or SelfPet) then
			SJprint(red, "Are You supposed to be taunting?")
			--Announce = true
		elseif PlayerRole == "HEALER" then
		--	Announce = true
		elseif PlayerRole == "NONE" then
			--Announce = true
		else
			return
		end
	else
		if not(TAS.Solo) then
			return
		end
	end
	
	local _, sourceClass = UnitClass(sourceName)
	local name = ""
	local PetOwner = false
	local PetOwnerClass = false
	local msg = ""
		
	if Pet then
		if SelfPet then
			PetOwner = UnitName("player")
		else
			PetOwner = getPetOwner(sourceName)
		end
		
		if not( PetOwner) then
			local PersonScanString = IsInRaid() and "raid%d" or "party%d"
			local ScanCount = GetNumGroupMembers()
			local PetScanString
				
			for x = 1, ScanCount do
				PetScanString = format( PersonScanString.."pet", x )
				if UnitIsValid( PetScanString ) and UnitIsUnit( PetScanString , sourceName) then
					PetOwner = UnitName( format( PersonScanString, x) )
					break
				end
			end
		end
		if PetOwner then
			_, PetOwnerClass = UnitClass( PetOwner )
		end
	end
	if TAS.Links then
		spellName = SpellLinkTemplate:format( spellId, spellName )
		if Pet and PetOwner then
			name = ("%s|Hplayer:%s|h[%s]|h %s%s "):format( CCC(PetOwnerClass), PetOwner, PetOwner, CCC(sourceClass), sourceName )
		elseif Pet then
			name = ("PET: %s%s "):format( CCC(sourceClass), sourceName )
		else
			name = ("%s|Hplayer:%s|h[%s]|h"):format(CCC(sourceClass), sourceName, sourceName)
		end
	else
		if Pet and PetOwner then
			name = ("%s%s %s%s"):format( CCC(PetOwnerClass), PetOwner, sourceClass, sourceName )
		elseif Pet then
			name = ("PET: %s%s "):format( CCC(sourceClass), sourceName )
		else
			name = ("%s%s "):format( CCC(sourceClass), sourceName )
		end
	end
	if destName and destName ~= sourceName then
		msg = string.format("|cFFFFFF00<Taunt Aware> %s|cFFFFFFFF casts %s on |cFFFF0000%s|r", name, spellName, destName )
	else
		msg = string.format("|cFFFFFF00<Taunt Aware> %s|cFFFFFFFF casts %s|r", name, spellName )
	end
	-- Message Output
	TA.MsgOut( msg )
	-- Alert Sound
	if TAS.AlertSound ~= "off" and ( not( Pet ) or (Pet and TAS.PetTaunts == "on")) then
		PlaySoundFile( AlertSoundFile, "Master" )
	end
	if TAS.Tattle and SpellList[spellId] then -- have to test spell ID because people now can get warned of high threat actions but not tattle them
		if Pet or UnitGroupRolesAssigned( sourceName ) ~= "TANK" then
			if not(TattleQueue[sourceName]) then
				TattleQueue[sourceName] = {}
			end
			if not(TattleQueue[sourceName][spellId]) then
				TattleQueue[sourceName][spellId] = 0
			end
			TattleQueue[sourceName][spellId] = TattleQueue[sourceName][spellId] + 1
		end
	end	
end

TA.GroupAnnounce = function(...)
	if TAS.Tattle then
		local ChatType = false
		if TAS.TatMode == "GROUP" then
			if GetNumGroupMembers( LE_PARTY_CATEGORY_INSTANCE ) > 0 then
				ChatType = "INSTANCE_CHAT"
			elseif IsInRaid() then
				ChatType = "RAID"
			elseif GetNumGroupMembers() > 0 then
				ChatType = "PARTY"
			end
		elseif TAS.TatMode == "WHISPER" then
			ChatType = "WHISPER"
		end
		
		for Name,Table in pairs(TattleQueue) do 
			for SpellId,Count in pairs(Table) do
				if SpellList[SpellId] then
					local SpellLink = GetSpellLink(SpellId)
					local msg, ChatTarget

					if UnitInParty(Name) or UnitInRaid(Name) or UnitIsUnit("player", Name) then
						ChatTarget = Name
						msg = ("<Taunt Aware> %s casted %s %s times last fight"):format( Name, SpellLink, Count )
					else
						local PetOwner = getPetOwner( Name )
						ChatTarget = PetOwner
						msg = ("<Taunt Aware> %s %s casted %s %s times last fight"):format( PetOwner, Name, SpellLink, Count )	
					end	
					
					if ChatType then
						if ChatType == "PARTY" or ChatType == "RAID" or ChatType == "INSTANCE_CHAT" then
							SendChatMessage( msg ,ChatType )
						elseif ChatType == "WHISPER" then
							if ChatTarget then
								SendChatMessage( msg, ChatType, nil, ChatTarget)
							end
						else
							TA.MsgOut( msg )
						end
					else
						TA.MsgOut( msg )
					end
				end
			end
		end
	end
	table.wipe(TattleQueue)
end


local e = 0
local PlayTestSound = false
TA.Frame:SetScript("OnUpdate", function(self, elapsed)
	if ScanComplete then
		TA.MsgOut ( ("%sTaunt Aware|r %s finished on %d group members in %.3f seconds"):format( yel, ScanComplete == 1 and "scan" or "auto scan", GetNumGroupMembers(), elapsed ) )
		ScanComplete = false
	end
	
	e = e + elapsed
	if e < 1/PerSec then return end
	
	if MFShown then
		MFShownTime = MFShownTime + e
		if MFShownTime > MFShowTimeWarn then
			MFShownTime = 0
			TA.MF:AddMessage("Move this frame to where you would like then type \"/tamf lock\" to save the position. (Left button moves frame, Right button resizes frame)", 1, 1, 1 )
			PlaySound("READYCHECK", "Master")
		end
	end
	
	if ScanDelay then
		ScanDelay = ScanDelay - e
		if ScanDelay < 0 then
			ScanDelay = false
			TA.ScanGroup()
		end
	end
	
	e = 0

	if PlayTestSound then
		PlayTestSound = false
		PlaySoundFile( AlertSoundFile, "Master" )
	end
end)

TA.SettingsUpdate = function()
	if TAS.MFAutoScale then
		local UIScale = UIParent:GetScale()
		TAS.MFScale =  math.floor((1/UIScale)*100)
	end
	TA.MF:SetScale(TAS.MFScale / 100 )
	TA.MF:SetFont( STANDARD_TEXT_FONT, TAS.FontSize, "OUTLINE")
	TA.MF:SetTimeVisible( TAS.FadeDelay )
		
	if string.find( TAS.AlertSound, "%d") then
		AlertSoundFile = "Interface\\AddOns\\TauntAware\\"..TAS.AlertSound
	elseif string.find( TAS.AlertSound, "custom" ) then
		AlertSoundFile = "Interface\\AddOns\\TauntAware_CustomSounds\\"..TAS.AlertSound
	else
		AlertSoundFile = ""
	end
	
	local val
	if TAS.TauntsOnly == "on" then
		val = nil
	elseif TAS.TauntsOnly == "monitor" then
		val = false	
	else
		val = true			
	end
	SpellList[115180] = val -- Monk		Dizzying Haze
	SpellList[34477] = val	-- Hunter	Misdirection
	SpellList[57934] = val	-- Rogue	Tricks of the Trade
	SpellList[8056] = val	-- Shaman	Frost Shock
	
	if TAS.PetTaunts == "on" or TAS.PetTaunts == "mute" then
		val = true
	elseif TAS.PetTaunts == "off" then
		val = nil
	end
	-- Warlock Pets
	SpellList[17735] = val	-- Suffering
	SpellList[3716] = val	-- Torment
	-- Hunter Pets
	SpellList[2649] = val	-- Growl
	SpellList[53477] = val	-- Taunt
	SpellList[24394] = val	-- Intimidation
	SpellList[63900] = val	-- Thunderstomp
end

TA.CmdLine = function( msg )
	local cmd, arg, arg2 = string.split(" ", msg)
	cmd = cmd:lower()
	
	if cmd == "config" or cmd == "cfg" then
		InterfaceOptionsFrame_OpenToCategory( TA.panel )
		return
	end

	if cmd == "scannow" then
		TA.ScanGroup(true)
		return
	end

	if not(TAS.Enable) and cmd ~= "enable" then
		print(" ")
		SJprint( yel, "Taunt Aware", res)
		SJprint( yel, "  This addon is ", red, "DISABLED", res)
		SJprint( yel, "  Type: ", blu, "/ta enable on", res)
		SJprint( yel, "  to enable.", res)
		return
	end

	do --On/Off True/False values
		local Command = { enable = "Enable", solo = "Solo", full = "Full", links = "Links", scan = "Scan", tattle = "Tattle", mfautoscale = "MFAutoScale"}
		if Command[cmd] then
			OptSaveTF( TAS, Command[cmd], arg)
			SJprint(  yel, "Taunt Aware:", Command[cmd],"is", StatColor( TAS[Command[cmd]] ), res)
			TA.SettingsUpdate()
			return
		end
	end
	
	do -- value range commands
		local Command = { mfscale = 1, fontsize = 2, fadedelay = 3, scandelay = 4}
		local VarName = {"MFScale", "FontSize", "FadeDelay", "ScanDelay"}
		local minimum = {       50,          7,           1,           1}
		local maximum = {      300,         24,          60,          60}
		local stat    = {    false,      false,        true,        true}
		
		if Command[cmd] then
			local index = Command[cmd]
			OptSaveVal( TAS, VarName[index], arg, minimum[index], maximum[index] )
			TA.SettingsUpdate()
			if stat[index] then
				SJprint( yel, "Taunt Aware:", VarName[index],"is", StatColor( TAS[VarName[index]] ), res)
			else
				SJprint( yel, "Taunt Aware:", VarName[index],"is", grn, TAS[VarName[index]], res)
			end
			return
		end
	end
	
	if cmd == "tauntsonly" then
		if arg == "on" or arg == "off" or arg == "monitor" then
			TAS.TauntsOnly = arg
			TA.SettingsUpdate()
		end
		SJprint(  yel, "Taunt Aware:", blu, "TauntsOnly|r is", (TAS.TauntsOnly == "off" and red or grn), TAS.TauntsOnly , res)
		SJprint(  yel, "Taunt Aware:|r valid modes are ", blu, "on, off, monitor", res)
		return
	end
	
	if cmd == "pettaunts" then
		if arg == "on" or arg == "off" or arg == "mute" then
			TAS.PetTaunts = arg
			TA.SettingsUpdate()
		end
		SJprint(  yel, "Taunt Aware:", blu, "PetTaunts|r is", TAS.PetTaunts == "off" and red or grn, TAS.PetTaunts , res)
		SJprint(  yel, "Taunt Aware:|r valid modes are ", blu, "on, off, mute", res)
		return
	end
	
	if cmd == "mf" then
		if arg == "unlock" then
			TA.MsgFrameUnlock()
		elseif arg == "lock" then
			TA.MsgFrameLock()
		elseif arg == "scale" then
			TA.CmdLine( "mfscale ".. (arg2 and arg2 or " " ))
		elseif arg == "autoscale" then
			TA.CmdLine( "mfautoscale ".. (arg2 and arg2 or " ") )
		else
			OptSaveTF( TAS, "MF", arg)
			SJprint( yel, "Taunt Aware:", blu, "MF", wht, "is", StatColor( TAS.MF ), res)
		end
		return
	end
	
	if cmd == "tatmode" then
		if arg then
			local Mode = string.upper(arg)
			if Mode == "GROUP" or Mode == "WHISPER" or Mode == "SUMMARY" then
				TAS.TatMode = Mode
			else
				SJprint(  yel, "Taunt Aware:", red, Mode, wht, "is not a valid Tattle Mode")
				SJprint(  yel, "Taunt Aware:", wht, "Valid modes are", blu, "GROUP   WHISPER   SUMMARY")
			end
		end
		SJprint(yel, "Taunt Aware:", blu,"TatMode", wht, "is", grn, TAS.TatMode, res)
		return
	end
	
	if cmd == "alertsound" then
		local AlertSoundModes = {["off"] = true, ["alert1.mp3"] = true, ["alert2.mp3"] = true, ["alert3.mp3"] = true, ["alert4.mp3"] = true, ["alert5.mp3"] = true ,
								["alert6.mp3"] = true, ["alert7.mp3"] = true, ["alert8.mp3"] = true, ["custom.mp3"] = true, ["custom.ogg"] = true }
		if arg then
			if AlertSoundModes[arg] then
				TAS.AlertSound = arg
				TA.SettingsUpdate()
			else
				SJprint( yel, "Taunt Aware:", red, arg, wht, "is not a valid option. Valid options are", blu, "off, alert1.mp3, alert2.mp3, alert3.mp3, alert4.mp3, alert5.mp3, alert6.mp3, alert7.mp3, alert8.mp3, custom.mp3, custom.ogg", res)
			end
		end
		
		if TAS.AlertSound ~= "off" then
			SJprint( yel, "Taunt Aware: AlertSound is", grn, "["..TAS.AlertSound.."]", res)
			PlayTestSound = true
		else
			SJprint( yel, "Taunt Aware: AlertSound is", red, "["..TAS.AlertSound.."]", res)
		end
		return
	end
	
	if cmd == "test" then
		TA.MsgOut( yel.."Taunt Aware:"..wht.." This is a test. It is only a test" )
		if TAS.AlertSound ~= "off" then
			PlaySoundFile( AlertSoundFile, "Master" )
		end
		return
	end
		
	if cmd == "" then
		print(" ")
		SJprint( yel, "________________________________________", res)
		SJprint( yel, "Taunt Aware", res)
		SJprint( blu, "     Enable", wht, "is", StatColor(TAS.Enable), res)
		SJprint( blu, "     Solo", wht, "is", StatColor(TAS.Solo), res)
		SJprint( blu, "     Full", wht, "alerts are", StatColor(TAS.Full), res)
		SJprint( blu, "     AlertSound", wht, "is", grn, TAS.AlertSound, res)
		SJprint( blu, "     MF", wht, "is", StatColor(TAS.MF), res)
		SJprint( blu, "     MFAutoScale", wht, "is", StatColor(TAS.MFAutoScale), res)
		SJprint( blu, "     MFScale", wht, "is", grn, TAS.MFScale, "%", res)
		SJprint( blu, "     FontSize", wht, "is", grn, TAS.FontSize, res)
		SJprint( blu, "     FadeDelay", wht, "is", grn, TAS.FadeDelay, wht, "seconds", res)
		SJprint( blu, "     TauntsOnly", wht, "is set", grn, TAS.TauntsOnly, res)
		SJprint( blu, "     PetTaunts", wht, "is set", StatColor(TAS.PetTaunts), res)
		SJprint( blu, "     Links ", wht, "for abilities are", StatColor(TAS.Links), res)
		SJprint( blu, "     Scan ", wht, "on party change is", StatColor(TAS.Scan), res)
		SJprint( blu, "     ScanDelay ", wht, "is", StatColor(TAS.ScanDelay), res)
		SJprint( blu, "     Tattle ", wht, "on non tank taunts is", StatColor(TAS.Tattle), res)
		SJprint( blu, "     TatMode ", wht, "What channel you want to tattle to (GROUP   WHISPER   SUMMARY) is", grn, (TAS.TatMode), res)
		SJprint( yel, "Available commands are listed in", blu, "BLUE.", res)
		SJprint( yel, "Type", blu, "/ta test", yel, "to test the alert with your current settings", res)
		SJprint( yel, "Type", blu, "/ta scannow", yel, "or", blu, "/tascan", yel, "to run a group scan",  res)
		SJprint( yel, "Type", blu, "/ta help", yel, "or", blu, "/ta cmdlist", yel, "for an explanation of the commands",  res)
		SJprint( yel, "Type", blu, "/ta config", yel, "to open the GUI config screen.", res)
		SJprint( yel, "________________________________________", res)
		return
	end

	if cmd == "help" or cmd == "cmdlist" then
		print(" ")
		SJprint( yel, "________________________________________", res)
		SJprint( yel, "Taunt Aware", res)
		SJprint( blu, "     Enable", wht, "Enable the addon to function [on/off]", res)
		SJprint( blu, "     Solo", wht, "Announce when you are solo [on/off]", res)
		SJprint( blu, "     Full", wht, "Alerts no matter your role [on/off]", res)
		SJprint( blu, "     AlertSound", wht, "Play a sound when you get a taunt alert [off/alert1.mp3 - alert8.mp3/custom.mp3/custom.ogg]",res)
		SJprint( blu, "     MF", wht, "use the new movable message fram to alert to taunts [on/off/lock/unlock]", res)
		SJprint( blu, "     MFAutoScale", wht, "Auto Scale the Message Frame to an effective scale of 1+/- [on/off]", res)
		SJprint( blu, "     MFScale", wht, "Percentage scale to use on message frame [50 - 300]", res)
		SJprint( blu, "     FontSize", wht, "The size of the font in the message frame [7 - 24]", res)
		SJprint( blu, "     FadeDelay", wht, "how long the messages stay in the above frame[1-60 seconds]", res)
		SJprint( blu, "     TauntsOnly", wht, "select what to do about high threat actions on = ignore  off = tattle  monitor = alert just yourself", res)
		SJprint( blu, "     PetTaunts", wht, "select what to do about pet actions on = full alerts  off = ignore  mute = alert without sound", res)
		SJprint( blu, "     Links ", wht, "enable spell/ player links when able [on/off]", res)
		SJprint( blu, "     Scan ", wht, "Scan the non tank group members for threat increasing abilities on a group change [on/off]", res)
		SJprint( blu, "     ScanDelay ", wht, "how long after group changes to run an autoscan [1-60 seconds]", res)
		SJprint( blu, "     Tattle ", wht, "on non tank taunts [on/off]", res)
		SJprint( blu, "     TatMode ", wht, "What channel you want to tattle to (GROUP   WHISPER   SUMMARY)", res)
		SJprint( yel, "Available commands are listed in", blu, "BLUE.", res)
		SJprint( yel, "Type", blu, "/ta test", yel, "to test the alert with your current settings", res)
		SJprint( yel, "Type", blu, "/ta scannow", yel, "or", blu, "/tascan", yel, "to run a group scan",  res)
		SJprint( yel, "Type", blu, "/ta config", yel, "to open the GUI config screen.", res)
		SJprint( yel, "Type", blu, "/tamf unlock", yel, "to move the message frame.", res)
		SJprint( yel, "Type", blu, "/tamf lock", yel, "to lock and hide the message frame.", res)
		SJprint( yel, "________________________________________", res)
		return
	end
	
	print(" ")
	SJprint( yel, "  Taunt Aware", res)
	SJprint( yel, "  Error: ", red, cmd, yel, " is not a valid command", res)
	SJprint( yel, "  Type: ", blu, "/ta", yel, "for the addon status and command list", res)
	SJprint( yel, "  Type: ", blu, "/ta cmdlist", yel, "for command list help", res)
	SJprint( yel, "Type", blu, "/ta config", yel, "to open the GUI config screen.", res)
	return
end

local Backdrop={
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true,
	tileSize = 16,
	edgeSize = 16,
	insets = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0
	}
}

local OnMouseDown = function(self, button)
	if button == "LeftButton" then
		self:StartMoving()
		self.isMoving = true
		self.hasMoved = false
	elseif button == "RightButton" then
		self:StartSizing()
		self.isMoving = true
		self.hasMoved = false
	end
end

local OnMouseUp = function(self)
    if ( self.isMoving ) then
        self:StopMovingOrSizing();
        self.isMoving = false;
        self.hasMoved = true;
    end
end

TA.MF = CreateFrame("MessageFrame", "TAMsgFrame", UIParent)
local MF = TA.MF
MF:SetFrameStrata("DIALOG")
MF:SetToplevel(true)
MF:SetSize(UIParent:GetWidth() / 4, 50)
MF:SetTimeVisible(15)
MF:SetFadeDuration(5)
MF:SetFading(true)
MF:SetClampedToScreen(true)
MF:SetInsertMode("TOP")
MF:SetIndentedWordWrap(true)
MF:SetFontObject(GameFontNormalSmall)
MF:SetJustifyH("LEFT")
MF:SetPoint("CENTER", UIParent, "CENTER" )
MF:Show()
MF:SetMovable(true)
MF:SetResizable(true)
MF:SetMinResize( 30, 30 )
MF:RegisterForDrag("LeftButton","RightButton")
MF:SetScript("OnMouseDown",OnMouseDown)
MF:SetScript("OnMouseUp",OnMouseUp)
MF.Title = MF:CreateFontString( nil , "OVERLAY", "GameFontHighlight")
MF.Title:SetPoint( "TOP", MF, "TOP", 0, 8 )
MF.Title:SetJustifyH( "CENTER" )
MF.Title:SetJustifyV( "MIDDLE" )
MF.Title:SetText("Taunt Aware")
MF:SetScale( 1 )

TA.MsgFrameLock = function()
	MF:EnableMouse(false)
	MF:SetBackdrop( nil )
	MF.Title:Hide()
	MFShown = false
end

TA.MsgFrameUnlock = function()
	MF:EnableMouse(true)
	MF:SetBackdrop( Backdrop )
	MF.Title:Show()
	TA.MF:AddMessage( yel.."Taunt Aware:"..wht.." Left Button moves the frame, Right button resizes the frame. Type \"/tamf lock\" when you are done"..res )
	MFShown = true
	MFShownTime = 0
end


SLASH_TA1 = "/ta"
SlashCmdList["TA"] = function(msg)
	TA.CmdLine(msg)
end

SLASH_TASCAN1 = "/tascan"
SlashCmdList["TASCAN"] = function(msg)
	TA.ScanGroup(true)
end

SLASH_TAMF1 = "/tamf"
SlashCmdList["TAMF"] = function(msg)
	TA.CmdLine("mf "..msg)
	return
end