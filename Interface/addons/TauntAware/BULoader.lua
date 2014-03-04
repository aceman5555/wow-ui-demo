-- ****************************************************************************
-- * Addon Specific Settings                                                  *
-- * Nothing to change here anymore                                           *
-- ****************************************************************************
local AddonName, _ = ...


-- ****************************************************************************
-- * Library Settings                                                         *
-- ****************************************************************************

local Version = "2013-03-01"


-- ****************************************************************************
-- * Bill's Utils loader                                                      *
-- ****************************************************************************
local HigherVersion = false
local Ver = {string.split("-", Version)}

if type( BillsUtils ) ~= "table" then
	BillsUtils = {}
	BillsUtils.LoadedBy = {}
	BillsUtils.LoadedBy[1] = AddonName
	BillsUtils.Locals = {}
	HigherVersion = true
else
	BillsUtils.LoadedBy[#BillsUtils.LoadedBy +1] = AddonName
	local ThisVersion = tonumber( Ver[1]..Ver[2]..Ver[3] )
	local LoadedVersion = tonumber(BillsUtils.Version[1]..BillsUtils.Version[2]..BillsUtils.Version[3])
	
	if ThisVersion > LoadedVersion then
		HigherVersion = true
	end
end

if HigherVersion then

	local BU = BillsUtils
	BU.Version = { string.split("-", Version) }
	BU.AddonName = AddonName
	
	local on = true
	local off = false
	local X = 16 -- standard Horizontal Spacing
	local Y = 35 -- standard Vertical spacing 26
	local TxtY = 13

-- Wait/Delay function
	local waitTable = {}
	local waitFrame = nil

	BU.Wait = function(delay, func, ...)
		if(type(delay)~="number" or type(func)~="function") then
			return false
		end
	
		if(waitFrame == nil) then
			waitFrame = CreateFrame("Frame","WaitFrame", UIParent)
			waitFrame:SetScript("onUpdate",function (self,elapse)
				local count = #waitTable
				local i = 1;
				while(i<=count) do
					local waitRecord = tremove(waitTable,i)
					local d = tremove(waitRecord,1)
					local f = tremove(waitRecord,1)
					local p = tremove(waitRecord,1)
					if(d>elapse) then
						tinsert(waitTable,i,{d-elapse,f,p})
						i = i + 1
					else
						count = count - 1
						f(unpack(p))
					end
				end
			end)
		end
		tinsert(waitTable,{delay,func,{...}})
		return true
	end

-- Add Meta Tables to Variables
	BU.addOptionMt = function(options, defaults)
		setmetatable(options, {__index = defaults})
		for i, v in pairs(options) do
			if type(v) == "table" and not getmetatable(v) then
				BU.addOptionMt(v, defaults[i])
			end
		end
	end
	
-- Return Colored status
	BU.StatColor = function(stat)
		local vtype = type(stat)
		if vtype == "boolean" then
			if stat then
				return "|cFF00FF00[on]"
			else
				return "|cFFFF0000[off]"
			end
		elseif vtype == "number" then
			if stat == 0 then
				return "|cFFFF0000[0] (DISABLED)"
			elseif stat > 0 then
				return string.format("|cFF00FF00[%i] second(s)", stat)
			end
		end
		return stat 
	end

-- Return the color code for passed class (In Caps)
	BU.CCC = function(class)
		if class == nil or not(RAID_CLASS_COLORS[class]) then
			return ("|cFF%02X%02X%02X"):format( 187, 187, 187)
		end
		return ("|c%s"):format( RAID_CLASS_COLORS[class].colorStr )
	end

-- String Join print
	BU.SJprint = function(...)
		print( string.join(" ", ...))
	end
	
-- Sorts 2 tables where x in both tables are related
	BU.LinkedSort = function( main, linked )
		if #main == 0 or #linked == 0 then
			return false
		end
		if #main ~= #linked then
			return false
		end
	
		local sorted
		repeat
			sorted = true
			for x = #main -1, 1, -1 do
				if main[x] > main[x+1] then
					main[x], main[x+1] = main[x+1], main[x]
					linked[x], linked[x+1] = linked[x+1], linked[x]
					sorted = false
				end
			end
		until sorted	
	end

-- First Letter Capitalizer
	BU.FLCap = function( word )
		if type( word ) ~= "string" then
			return word
		end
		if string.len( word ) == 1 then
			return string.upper(word)
		end
		
		return (string.upper(string.sub(word, 1, 1))..string.sub(word, 2))
	end
	
-- ****************************************************************************
-- * Cmd Line Utils                                                           *
-- ****************************************************************************

-- Checks CmdLine switches against variable and changes var if needed true/false on/off
	BU.OptSaveTF = function( Table, Key, Value)
		local Saved = Table[ Key ]
		local vtype = type(Value)
		if vtype == "string" then
			if Value == "on" or Value == "yes" or Value == "true" then
				Value = true
			elseif Value == "off" or Value == "no" or Value == "false" then
				Value = false
			else
				return
			end
		elseif vtype ~= "boolean" then
			return
		end
		if Saved ~= Value then
			Table[ Key ] = Value
		end
	end

-- Checks CmdLine switches against variable and changes var if needed  and value in range
	BU.OptSaveVal = function( Table, Key, Value, Min, Max)
		local Saved = Table[ Key ]
		local vtype = type(Value)
		
		if vtype == "nil" then
			return
		elseif vtype == "string" then
			Value = tonumber(Value)
		end
	
		if Value ~= Saved then
			if Value >= Min and Value <= Max then
				Table[ Key ] = Value
			end
		end
	end

-- ****************************************************************************
-- * Check Box Utils                                                          *
-- ****************************************************************************

	BU.ChkBox = function( Last, Prefix, Name, Parent, Click, TextTable, TextName )
		local box
		if type(TextName) == "nil" then
			TextName = Name
		end
		
		box = CreateFrame( "CheckButton", Prefix..Name.."Checkbox", Parent, "InterfaceOptionsCheckButtonTemplate" )
		if Last == Parent then
			box:SetPoint("TOPLEFT", Last ,"TOPLEFT", X*1.25 , -Y/2 )
		else
			box:SetPoint("TOPLEFT", Last ,"TOPLEFT", 0, -Y )
		end
		box:SetSize( 26, 26 )
		box:SetScript( "OnClick", Click )
	
		box.Text = Parent:CreateFontString( nil, "ARTWORK", "GameFontHighlightSmall" )
		box.Text:SetPoint( "BOTTOMLEFT", box, "BOTTOMLEFT", X*2 , -TxtY )
		box.Text:SetPoint( "RIGHT", -32, 0 )
		box.Text:SetHeight( 32 )
		box.Text:SetJustifyH( "LEFT" )
		box.Text:SetJustifyV( "TOP" )
		box.Text:SetText( TextTable[ TextName ] )
		return box
	end

	BU.CheckClick = function()
		PlaySound( "GAMEGENERICBUTTONPRESS" )
	end

-- Checks checkboxes against variable and adjusts variable if needed
	BU.ChkBoxSave = function( Panel, Box, Table, Key)
		if Key == nil then
			Key = Box
		end
		if (Panel[ Box ]:GetChecked() == 1) ~= Table[Key] then
			Table[ Key ] = (Panel[ Box ]:GetChecked() == 1)
		end
	end

-- ****************************************************************************
-- * Slider Utils                                                             *
-- ****************************************************************************

	BU.Slider = function( Last , Prefix, Name, Parent, SliderMW , TextTable, min, max, step )
		local slider
		slider = CreateFrame( "Slider", Prefix..Name.."Slider", Parent, "OptionsSliderTemplate" )
		slider:SetMinMaxValues( min, max )
		slider:SetOrientation("HORIZONTAL")
		slider:SetPoint("TOPLEFT", Last ,"TOPLEFT", 0 , -Y * 1.25)
		slider:SetValueStep( step )
		slider:SetWidth( 240 )
		slider:SetHeight( 16 )
		slider:SetScript( "OnValueChanged", function( self )
			self.Val:SetNumber( self:GetValue() )
			PlaySound( "GAMEGENERICBUTTONPRESS" )
		end)
		getglobal(slider:GetName() .. 'Low'):SetText(tostring(min))
		getglobal(slider:GetName() .. 'High'):SetText(tostring(max))
		getglobal(slider:GetName() .. 'Text'):SetText(TextTable[ Name ]); --Sets the "title" text (top-centre of slider).
	
		slider:SetScript("OnMouseWheel", function(self, delta)
			SliderMW(self, delta)
		end)
		return slider
	end

	BU.SliderEditBox = function( Slider , Prefix, Name, Parent )
		local Val
		Val=CreateFrame("EditBox", Prefix..Name.."Value", Parent, "InputBoxTemplate")
		Val:SetFontObject("ChatFontNormal")
		Val:SetTextInsets(0, 0, 3, 3)
		Val:SetPoint("BOTTOMLEFT", Slider , "BOTTOMRIGHT", X , -8)
		Val:SetHeight(19)
		Val:SetWidth(40)
		Val:SetNumeric(true)
		Val:SetAutoFocus(false)
		Val:SetMaxLetters( 4 )
		Val.Owner = Slider
		Val:SetScript("OnEnterPressed" , function(self)
			local min, max = self.Owner:GetMinMaxValues()
			local val = self:GetNumber()
			if val >= min and val <= max then
				if val ~= self.Owner:GetValue() then
					self.Owner:SetValue(val)
				end
			else
				self:SetNumber(self.Owner:GetValue())
			end
			self:ClearFocus()
		end)
		Val:SetScript("OnEscapePressed", function(self)
			self:SetNumber( self.Owner:GetValue() )
			self:ClearFocus()
		end)
		return Val
	end

-- Checks Slider against variable and changes var if needed
	BU.SliderSave = function( Panel, Slider, Table, Key)
		if type(Key) ~= "string" then
			Key = Slider
		end
		if Panel[Slider]:GetValue() ~= Table[Key] then
			Table[Key] = Panel[Slider]:GetValue()
		end
	end

-- Mousewheel control for sliders
	BU.SliderMW = function(self, delta)
		local minimum, maximum = self:GetMinMaxValues()
		local step = self:GetValueStep()
		local value = self:GetValue()
	
		if (delta < 0) then 
			self:SetValue( math.max(value - step, minimum) )
		elseif (delta > 0) then
			self:SetValue( math.min(value + step, maximum) )
		end
	end

-- ****************************************************************************
-- * Edit Box Utils                                                           *
-- ****************************************************************************

	BU.EditBox = function( Last, Prefix, Name, Parent, Table, Key, TextTable, TTKey )
		if TTKey == nil then
			TTKey = Key
		end
	
		local EBox
		EBox = CreateFrame( "EditBox", Prefix..Name.."Editbox", Parent, "InputBoxTemplate" )
		EBox:SetFontObject("ChatFontNormal")
		EBox:SetTextInsets(0, 0, 3, 3)
		EBox:SetPoint("TOPLEFT", Last , "TOPLEFT", 0 ,-Y*2 )
		EBox:SetPoint("RIGHT", -32, 0)
		EBox:SetHeight(19)
		EBox:SetWidth(50)
		EBox:SetAutoFocus(false)
		EBox:SetMaxLetters( 254 )
		EBox:SetScript("OnEnterPressed" , function(self)
			self:ClearFocus()
		end)
		EBox:SetScript("OnEditFocusGained", function(self)
			if self:IsNumeric() then
				self.OldValue = self:GetNumber()
			else
				self.OldValue = self:GetText()
			end
			self:HighlightText()
		end)
		EBox:SetScript("OnEscapePressed", function(self)
			self:SetCursorPosition( 0 )
			if self:IsNumeric() then
				self:SetNumber( self.OldValue )
			else
				self:SetText( self.OldValue )
			end
			self:ClearFocus()
		end)
		EBox:SetScript("OnTabPressed", function(self)
			self:Insert("    ")
		end)
	
		EBox.Text = Parent:CreateFontString( nil, "ARTWORK", "GameFontHighlightSmall" )
		EBox.Text:SetPoint( "BOTTOMLEFT", EBox , "BOTTOMLEFT", 0 , Y/4 )
		EBox.Text:SetPoint( "RIGHT", -32, 0 )
		EBox.Text:SetHeight( 32 )
		EBox.Text:SetJustifyH( "LEFT" )
		EBox.Text:SetJustifyV( "TOP" )
		EBox.Text:SetText( TextTable[ TTKey ] )
		return EBox
	end

-- ****************************************************************************
-- * Faction Detection Functions                                              *
-- ****************************************************************************

-- Faction tooltip settings
	local guidCache = {}
    local utip = CreateFrame("GameTooltip", "uTip", UIParent, "GameTooltipTemplate")
    utip:SetOwner( WorldFrame, "ANCHOR_NONE") 

-- Faction Check (returns true if player and compared GUID are same faction)
	BU.SameFaction = function( GUID )
		if IsPlayerNeutral() then
			return true
		end
		local _, myFaction = UnitFactionGroup('player')
		return myFaction == BU.FactionByGUID(GUID)
	end

-- Returns a faction from a given GUID for a player character
	BU.FactionByGUID = function(GUID)
    	if not( GUID ) then
    		return false
    	end
    	
		uTip:ClearLines()
		utip:SetHyperlink('unit:'..GUID)
		if IsPlayerNeutral() then
			return "Neutral"
		end
		if guidCache[GUID] then
			return guidCache[GUID]
		end
		
		if not( tonumber(GUID:sub(5,5), 16) % 8 == 0 ) then
			return "Not a player character"
		end
		
		local _, _, _, CompRace = GetPlayerInfoByGUID( GUID )
		-- Non Panda Scan
		if CompRace ~= "Pandaren" then
			local Alliance = { ["Worgen"] = true, ["Draenei"] = true, ["Dwarf"] = true, ["Gnome"] = true, ["Human"] = true, ["NightElf"] = true }
			guidCache[GUID] = Alliance[CompRace] and FACTION_ALLIANCE or FACTION_HORDE
			return guidCache[GUID]
		end
		-- Panda Scan
        local tipName, numLines = "uTipTextLeft", _G["uTip"]:NumLines()
        local faction = _G[tipName..tostring(numLines)]:GetText() == PVP and _G[tipName..tostring(numLines-1)]:GetText() or _G[tipName..tostring(numLines)]:GetText()
       	if faction ~= FACTION_ALLIANCE and faction ~= FACTION_HORDE then
       		--panda's level is too high compared to ours so just invert our faction 
       		local _, myFaction = UnitFactionGroup('player')
       		faction = myFaction == FACTION_ALLIANCE and FACTION_HORDE or FACTION_ALLIANCE
       end
       guidCache[GUID] = faction
       return guidCache[GUID]
    end


-- ****************************************************************************
-- * Misc Functions                                                           *
-- ****************************************************************************

-- PvP Zone Check (returns true if in battleground or designated PvP zone (Tol Barad, Wintersgrasp)
	BU.IsPvPZone = function()
		local inInstance, instanceType = IsInInstance()
		if inInstance then 
			if instanceType == "pvp" or instanceType == "arena" then 
				return true
			end
			return false
		end
		
		local zone = GetRealZoneText()
		local WPvP = false
		if zone == "Wintergrasp" then --WorldPVPArea 1 is Wintergrasp
			WPvP = 1
		elseif zone == "Tol Barad" then --WorldPVPArea 2 is Tol Barad
			WPvP = 2
		end
		
		if WPvP then
			local pvpID, localizedName, isActive, canQueue, startTime, canEnter = GetWorldPVPAreaInfo(WPvP)
			if isActive then
				return true
			end
		end
		return false
	end

-- returns a word based on gender of person passed and the male word variant	
	BU.GenderWord = function( unit, maleWord, GUID)
	-- 					maleWord		unknown,	male, 		female
		local words = { ["his"] = {		"their",	"his", 		"her" },
						["him"] = {		"them", 	"him", 		"her" },
						["himself"] = {	"themself",	"himself", 	"herself" },
						["he"] = {		"it", 		"he", 		"she" },
						["man"] = {		"it",		"man", 		"woman" }, 
						["male"] = {	"it", 		"male", 	"female" },
						["his'"] = {	"its",		"his",		"hers" },
		}
		
		if not(words[maleWord]) then
			return maleWord
		end

		-- WoW sexes = 1(unknown) 2(male) 3(female)
		local sex = 1
		if GUID ~= nil then
			_, _, _, _, sex = GetPlayerInfoByGUID(GUID)
		elseif UnitExists( unit ) then
			sex = UnitSex( unit )
		end
		
		return words[maleWord][sex]
	end

-- Frame Event Registration Toggler
	BU.EventToggle = function( Frame, Table, Key, Event, Enable )
		if type(Enable) ~= "boolean" then
			Enable = true
		end
		
		if not(Enable) then
			if Frame:IsEventRegistered(Event) then
				Frame:UnregisterEvent( Event )
			end
			return
		end
		
		if type(Table) == "table" then
			if Frame:IsEventRegistered(Event) ~= Table[Key] then
				if Table[Key] then
					Frame:RegisterEvent( Event )
				else
					Frame:UnregisterEvent( Event )
				end
			end
		else
			if Frame:IsEventRegistered(Event) ~= Key then
				if Key then
					Frame:RegisterEvent( Event )
				else
					Frame:UnregisterEvent( Event )
				end
			end
		end
	end
		
-- Slash Command
	SLASH_BILLSUTILS1 = "/billsutils"
	SlashCmdList["BILLSUTILS"] = function(msg)
		local cmd,arg = string.split(" ", msg)
		
		print("|cFF00FF00 Bill's Utils v"..BillsUtils.Version[1].."-"..BillsUtils.Version[2].."-"..BillsUtils.Version[3].."  was loaded by "..BillsUtils.AddonName.."|r")
		print("|cFF00FF00 Bill's Utils is being used by "..#BillsUtils.LoadedBy.." add ons. ("..#BillsUtils.Locals.." properly registered files and unknown others)")
		print("|cFF00FF00 Bill's Utils is used and registered by: |r")
		for x = 1, #BillsUtils.LoadedBy do
			print("|cFF00FF00   "..BillsUtils.LoadedBy[x].."|r")
		end
	end
	
-- ****************************************************************************
-- * Update locals if Higher version has been loaded                          *
-- ****************************************************************************
	if #BillsUtils.Locals > 0 then
		for x = 1, #BillsUtils.Locals do
			BillsUtils.Locals[x]()
		end
	end
	


-- End of HigherVersion check
end



   