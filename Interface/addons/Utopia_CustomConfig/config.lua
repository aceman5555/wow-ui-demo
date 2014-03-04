local Utopia = LibStub("AceAddon-3.0"):GetAddon("Utopia", true)
if (not Utopia) then
	return
end
Utopia:UpdateVersion("$Revision: 203 $")

local wowVersion = tonumber((select(2,GetBuildInfo())))

local d = Utopia.debugprint
local module = Utopia.modules.Custom
local L = LibStub("AceLocale-3.0"):GetLocale("Utopia")
local LGT = LibStub("LibGroupTalents-1.0")
local new, del, copy, deepDel = Utopia.new, Utopia.del, Utopia.copy, Utopia.deepDel
local Gradient, UnitFullName, ClassColour, SmoothColour = Utopia.Gradient, Utopia.UnitFullName, Utopia.ClassColour, Utopia.SmoothColour
local rotate, propercase = Utopia.rotate, Utopia.propercase
local band = bit.band

local lzf = LibStub("LibZekFrames-1.0")
lzf:AssignTableResources(new, del, copy, deepDel)
lzf:AssignTextureResources(
	"Interface\\Addons\\Utopia\\Textures\\LibZekFrames-ResizeGrip",
	"Interface\\Addons\\Utopia\\Textures\\LibZekFrames-TopLeft",
	"Interface\\Addons\\Utopia\\Textures\\LibZekFrames-Top",
	"Interface\\Addons\\Utopia\\Textures\\LibZekFrames-TopRight",
	"Interface\\Addons\\Utopia\\Textures\\LibZekFrames-BottomLeft",
	"Interface\\Addons\\Utopia\\Textures\\LibZekFrames-Bottom",
	"Interface\\Addons\\Utopia\\Textures\\LibZekFrames-BottomRight"
)

do	----------- OPTIONS --------------

	-- options.OnShow
	local function optionsOnShow(self)
		self:PopulateCurrentSpells()

		if (InterfaceOptionsFrame and InterfaceOptionsFrame:IsShown()) then
			self:SetFrameStrata(InterfaceOptionsFrame:GetFrameStrata())
			self:SetFrameLevel((InterfaceOptionsFrameTab2 or InterfaceOptionsFrame):GetFrameLevel() + 5)
		else
			self:SetFrameStrata("FULLSCREEN_DIALOG")
		end
	end

	-- options.OnHide
	local function optionsOnHide(self)
		self.current:Clear()
		self.found:Clear()
	end

	-- options.PopulateCurrentSpells
	local function optionsPopulateCurrentSpells(self)
		local spells = module:GetSpells()
		if (spells) then
			local listItems = new()
			local last
			for i,info in ipairs(spells) do
				if (info.type == "spacer") then
					tinsert(listItems, {format("  --- %s ---", L["Spacer"]), i})
				else
					local name, rank, tex = GetSpellInfo(info.id)
					if (name) then
						if (info.type == "buff") then
							tinsert(listItems, new("|cFF80FF80+|r "..name, i))
						else
							tinsert(listItems, new("|cFFFF8080-|r "..name, i))
						end
					end
				end
			end
			self.current:SetItems(listItems)
		else
			self.current:Clear()
		end
		self:ShowOptions()
	end

	-- sortNameName
	local function sortNameName(a, b)
		return a[1] < b[1]
	end

	-- options.PopulateSearchMatches
	local function optionsPopulateSearchMatches(self)
		local ss = self.searchString
		if (ss) then
			self.found:Clear()
			local foundItems = new()
			local foundLookup = new()

			local last = 1
			for i = 1,150000 do
				local name, rank, tex = GetSpellInfo(i)
				if (name) then
					last = i
					if (tex ~= "Interface\\Icons\\Temp") then
						if (strmatch(name, ss)) then
							if (not foundLookup[name]) then
								foundLookup[name] = true
								tinsert(foundItems, new(name, i))
							end
						end
					end
				end
				if (i > last + 1000) then
					break
				end
			end

			del(foundLookup)
			sort(foundItems, sortNameName)
			self.found:SetItems(foundItems)
		end
	end

	-- frame.search.set
	local function searchSet(self, newval)
		self.searchString = newval
		self:PopulateSearchMatches()
	end

	-- foundlist.OnClick
	local function foundlistOnClick(self, startIndex)
		self:GetParent():PopulateIconsForName(startIndex)
	end

	-- options.PopulateIconsForName
	local function optionsPopulateIconsForName(self, startIndex)
		local findName = GetSpellInfo(startIndex)
		assert(findName)

		local foundIcons = new()
		local last = startIndex
		for i = startIndex,150000 do
			local name, rank, tex = GetSpellInfo(i)
			if (name) then
				last = i
				if (name == findName and tex ~= "Interface\\Icons\\Temp") then
					tinsert(foundIcons, i)
				end
			end
			if (i > last + 1000) then
				break
			end
		end
		self.icons:SetFoundIcons(foundIcons)
	end

	-- icons.SetFoundIcons
	local function iconsSetFoundIcons(self, icons)
		del(self.foundIcons)
		self.foundIcons = icons
		self:DrawIcons()
	end

	-- icons.FreeAllIcons
	local function iconsFreeAllIcons(self)
		if (self.iconList) then
			for i,icon in ipairs(self.iconList) do
				self:ReleaseIcon(icon)
			end
			self.iconList = del(self.iconList)
		end
	end

	-- icons.OnSizeChanged
	local function iconsOnSizeChanged(self)
		self:DrawIcons()
	end

	-- icons.DrawIcons
	local function iconsDrawIcons(self)
		self:FreeAllIcons()
		if (not self.foundIcons) then
			return
		end

		self.iconList = new()

		local first, prev
		local h, w = 0, 0
		for i,id in ipairs(self.foundIcons) do
			local name, rank, tex = GetSpellInfo(id)
			assert(name)

			local icon = self:AquireIcon()
			icon.tex:SetTexture(tex)
			icon:SetID(id)

			if (w + icon:GetWidth() + 4 > self:GetWidth()) then
				h = h + icon:GetHeight() + 4
				if (h >= self:GetHeight()) then
					self:ReleaseIcon(icon)
					break
				end

				icon:SetPoint("TOPLEFT", first, "BOTTOMLEFT", 0, -4)
				first = nil
				w = 0

			elseif (prev) then
				icon:SetPoint("TOPLEFT", prev, "TOPRIGHT", 4, 0)
			else
				icon:SetPoint("TOPLEFT")
			end
			w = w + icon:GetWidth() + 4

			tinsert(self.iconList, icon)
			if (not first) then
				first = icon
				if (h == 0) then
					h = icon:GetHeight() + 4
				end
			end
			prev = icon
		end
	end

	-- icon.OnEnter
	local function iconOnEnter(self)
		local id = self:GetID()
		if (id) then
			GameTooltip:SetOwner(self, "ANCHOR_TOP")
			GameTooltip:SetHyperlink("spell:"..id)
		end
	end

	-- icon.OnLeave
	local function iconOnLeave(self)
		GameTooltip:Hide()
	end

	-- icon.OnClick
	local function iconOnClick(self)
		local id = self:GetID()
		local name, rank, tex = GetSpellInfo(id)
		assert(name)

		if (not IsModifierKeyDown()) then
			local spells = module:GetSpells()
			tinsert(spells, {id = id, name = name, texture = tex, type = "buff"})

			self:GetParent():GetParent():RefreshCurrent(id)
		else
			if (IsShiftKeyDown()) then
				local link = format("|cff71d5ff|Hspell:%d|h[%s]|h|r", id, name)
				ChatEdit_InsertLink(link)
			end
		end
	end

	local icons = {}
	local increment = 1
	local function iconsCreateIcon(self)
		local icon = CreateFrame("Button", "UtopiaCustomIcons"..increment, self, "ActionButtonTemplate")
		icon.tex = _G[icon:GetName().."Icon"]
		increment = increment + 1

		icon:SetScript("OnEnter", iconOnEnter)
		icon:SetScript("OnLeave", iconOnLeave)
		icon:SetScript("OnClick", iconOnClick)

		return icon
	end

	local function iconsAquireIcon(self)
		local icon = tremove(icons, 1) or self:CreateIcon()
		icon:Show()
		return icon
	end

	local function iconsReleaseIcon(self, icon)
		icon:ClearAllPoints()
		icon:Hide()
		tinsert(icons, icon)
	end

	-- options.RefreshCurrent
	local function optionsRefreshCurrent(self, id)
		self:PopulateCurrentSpells()
		self.current:Select(id)
		self:ShowOptions()

		module:ShowingFrames()
		local frame = Utopia.frames and Utopia.frames[3]
		if (frame) then
			frame:UpdateBuffs()
			frame:SetOrientation()
			frame:SetFrameSize()
		end
	end

	-- options.DeleteSpell
	local function optionsDeleteSpell(self)
		local index = self.current:GetSelected()

		local spells = module:GetSpells()
		tremove(spells, index)

		self:RefreshCurrent(index)
	end

	-- optionsDefaults
	local function optionsDefaults(self)
		local index = self.current:GetSelected()

		local dbc = module.db.char
		if (dbc.spells) then
			local defaults = module:DefaultClassSpells()
			if (defaults) then
				local group = GetActiveTalentGroup() or 1
				dbc.spells[group] = defaults
			end
		end

		self:RefreshCurrent(index)
	end

	-- options.ToggleAuraType
	local function optionsToggleAuraType(self)
		local index = self.current:GetSelected()

		local spells = module:GetSpells()
		local info = spells[index]
		if (info.type ~= "spacer") then
			info.type = info.type == "buff" and "debuff" or "buff"
		end

		self:RefreshCurrent(index)
	end

	-- options.InsertSpacer
	local function optionsInsertSpacer(self)
		local index = self.current:GetSelected()
		local spells = module:GetSpells()

		if (index) then
			tinsert(spells, index, {type = "spacer"})
		else
			tinsert(spells, {type = "spacer"})
		end

		self:RefreshCurrent(index)
	end

	-- options.MoveEntry
	local function optionsMoveEntry(self, where)
		local index = self.current:GetSelected()

		local spells = module:GetSpells()
		if (where == "down") then
			if (index < #spells) then
				local temp = spells[index]
				spells[index] = spells[index + 1]
				spells[index + 1] = temp

				self:RefreshCurrent(index + 1)
			end
		else
			if (index > 1) then
				local temp = spells[index]
				spells[index] = spells[index - 1]
				spells[index - 1] = temp

				self:RefreshCurrent(index - 1)
			end
		end
	end

	-- optionsButtonMoveDown
	local function optionsButtonMoveDown(self)
		self:MoveEntry("down")
	end

	-- optionsButtonMoveUp
	local function optionsButtonMoveUp(self)
		self:MoveEntry("up")
	end

	-- options.current.OnClick
	local function optionscurrentOnClick(self)
		self:GetParent():ShowOptions()
	end

	-- options.ShowOptions
	local function optionsShowOptions(self)
		local sel = self.current:GetSelected()
		if (sel) then
			local spells = module:GetSpells()
			local isAura = spells[sel] and spells[sel].type ~= "spacer"

			self.delete:Enable()
			self.up:Enable()
			self.down:Enable()

			if (isAura) then
				self.auraType:Enable()
			else
				self.auraType:Disable()
			end
		else
			self.delete:Disable()
			self.up:Disable()
			self.down:Disable()
			self.auraType:Disable()
		end
	end

	-- MakeSpellOptions
	function module:MakeSpellOptions()
		local frame = CreateFrame("Frame", "UtopiaCustomOptions", UIParent)
		frame:Hide()
    	frame:SetWidth(600)
		frame:SetHeight(400)
		lzf:ApplyBackground(frame, "Interface\\AddOns\\Utopia\\Textures\\UtopiaCornerIcon")
		lzf:MovableFrame(frame)
		frame.OnPositionChanged = function(self) Utopia:SavePosition(self) end
		Utopia:RestorePosition(frame)

		frame.title:SetFormattedText(L["%s Custom Configuration"], Utopia.label)

		frame.icons = CreateFrame("Frame", nil, frame)
		frame.icons:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 23, 124)
		frame.icons:SetPoint("BOTTOMRIGHT", -16, 43)
		frame.icons.AquireIcon		= iconsAquireIcon
		frame.icons.ReleaseIcon		= iconsReleaseIcon
		frame.icons.SetFoundIcons	= iconsSetFoundIcons
		frame.icons.DrawIcons		= iconsDrawIcons
		frame.icons.FreeAllIcons	= iconsFreeAllIcons
		frame.icons.CreateIcon		= iconsCreateIcon
		frame.icons:SetScript("OnSizeChanged", iconsOnSizeChanged)

		lzf:CreateHorizontalBar(frame.icons, "TOP")

		frame.current = lzf:CreateListFrame(frame, true)
		frame.current:SetPoint("TOPLEFT", 24, -82)
		frame.current:SetPoint("BOTTOMRIGHT", frame.icons.horizontalBar, "BOTTOMLEFT", 165, 4)
		frame.current.OnClick = optionscurrentOnClick

		frame:SetScript("OnShow", optionsOnShow)
		frame:SetScript("OnHide", optionsOnHide)
		frame.PopulateCurrentSpells		= optionsPopulateCurrentSpells
		frame.PopulateSearchMatches		= optionsPopulateSearchMatches
		frame.PopulateIconsForName		= optionsPopulateIconsForName
		frame.RefreshCurrent			= optionsRefreshCurrent
		frame.MoveEntry					= optionsMoveEntry
		frame.ShowOptions				= optionsShowOptions
		frame.InsertSpacer				= optionsInsertSpacer

		frame.bar = lzf:CreateVerticalBar(frame.current, "RIGHT", true)

		frame.search = lzf:EditBox(frame, frame, true, L["Search"], searchGet, searchSet, "BOTTOMLEFT", frame.current, "TOPRIGHT", 10, 7)

		frame.found = lzf:CreateListFrame(frame, true)
		frame.found:SetPoint("TOPLEFT", frame.current.verticalBar, "TOPRIGHT", 0, 0)
		frame.found:SetPoint("BOTTOMRIGHT", frame.icons.horizontalBar, "BOTTOMRIGHT", -25, 4)
		frame.found.OnClick = foundlistOnClick

		frame.auraType = lzf:Button(frame.statusbar, frame, L["Aura Type"], optionsToggleAuraType, "LEFT")
		frame.up = lzf:Button(frame.statusbar, frame, L["Up"], optionsButtonMoveUp, "LEFT", frame.auraType, "RIGHT", 10)
		frame.up:SetWidth(60)
		frame.down = lzf:Button(frame.statusbar, frame, L["Down"], optionsButtonMoveDown, "LEFT", frame.up, "RIGHT", 10)
		frame.down:SetWidth(60)

		frame.delete = lzf:Button(frame.statusbar, frame, DELETE, optionsDeleteSpell, "RIGHT")
		frame.default = lzf:Button(frame.statusbar, frame, DEFAULTS, optionsDefaults, "RIGHT", frame.delete, "LEFT", -10)

		frame.spacer = lzf:Button(frame, frame, L["Spacer"], optionsInsertSpacer, "BOTTOMRIGHT", frame.found, "TOPRIGHT", 20, 7)

		frame.up.tooltip		= L["Move the selected spell up"]
		frame.down.tooltip		= L["Move the selected spell down"]
		frame.auraType.tooltip	= L["Toggle between buff and debuff for the selected spell"]
		frame.delete.tooltip	= L["Delete the selected spell"]
		frame.default.tooltip	= L["Reload the defaults for this class and spec"]
		frame.spacer.tooltip	= L["Insert a spacer at the current point to seperate the icons"]

		self.optionsFrame = frame
		self.MakeSpellOptions = nil
	end
end

-- AddSlotProcs
function module:AddSlotProcs(list, slot)
	local t = GetInventoryItemID("player", slot)
	if (t) then
		-- Trinkets
		if (t == 50355) then										-- Herkuml War Token
			tinsert(list, {id = 71396, type = "buff"})				-- Rage of the Fallen

		elseif (t == 47464 or t == 47303 or t == 47115 or t == 47131) then	-- Death's Choice/Verdict
			local str, agi = UnitStat("player", 1), UnitStat("player", 2)

			if (t == 47464 or t == 47131) then
				-- Heroic version
				if (str > agi) then
					tinsert(list, {id = 67773, type = "buff"})				-- Paragon (510 STR)
				else
					tinsert(list, {id = 67772, type = "buff"})				-- Paragon (510 AGI)
				end
			else
				-- Normal version
				if (str > agi) then
					tinsert(list, {id = 67708, type = "buff"})				-- Paragon (450 STR)
				else
					tinsert(list, {id = 67703, type = "buff"})				-- Paragon (450 AGI)
				end
			end

		elseif (t == 44253 or t == 42987 or t == 44255 or t == 44254) then	-- Darkmoon Card: Greatness
			local str, agi, int, spr = UnitStat("player", 1), UnitStat("player", 2), UnitStat("player", 4), UnitStat("player", 5)
			if (str > agi and str > int and str > spr) then
				tinsert(list, {id = 60229, type = "buff"})				-- Greatness (STR)
			elseif (agi > str and agi > int and agi > spr) then
				tinsert(list, {id = 60233, type = "buff"})				-- Greatness (AGI)
			elseif (int > str and int > agi and int > spr) then
				tinsert(list, {id = 60234, type = "buff"})				-- Greatness (INT)
			else
				tinsert(list, {id = 60235, type = "buff"})				-- Greatness (SPR)
			end

		elseif (t == 47881 or t == 47725) then						-- Vengeance of the Forsaken/Victor's Call
			tinsert(list, {id = 67737, type = "buff"})				-- Risen Fury
		elseif (t == 48020 or t == 47948) then						-- Vengeance of the Forsaken/Victor's Call (Heroic)
			tinsert(list, {id = 67746, type = "buff"})				-- Risen Fury (Heroic)
		elseif (t == 50198) then									-- Needle-Encrusted Scorpion
			tinsert(list, {id = 71403, type = "buff"})				-- Fatal Flaws
		elseif (t == 40684) then									-- Mirror of Truth
			tinsert(list, {id = 60065, type = "buff"})				-- Reflection of Torment

		-- Rings
		elseif (t == 50401 or t == 50402) then						-- Ashen Band of Xxxxxxxx Vengeance
			tinsert(list, {id = 72412, type = "buff"})				-- Frostforged Champion
		elseif (t == 50403 or t == 50404) then						-- Ashen Band of Xxxxxxxx Courage
			tinsert(list, {id = 72414, type = "buff"})				-- Frostforged Defender
		elseif (t == 50397 or t == 50398) then						-- Ashen Band of Xxxxxxxx Destruction
			tinsert(list, {id = 72416, type = "buff"})				-- Frostforged Sage
		elseif (t == 50399 or t == 50400) then						-- Ashen Band of Xxxxxxxx Wisdom
			tinsert(list, {id = 72418, type = "buff"})				-- Item - Icecrown Reputation Ring Healer Effect

		-- Weapons
		elseif (t == 49982) then									-- Heartpierce
			tinsert(list, {id = 71882, type = "buff"})				-- Invigoration

		-- Relics
		elseif (t == 50459) then									-- Sigil of the Hanged Man
			tinsert(list, {id = 71227, type = "buff"})				-- Indomitable
		elseif (t == 50462) then									-- Sigil of the Bone Gryphon
			tinsert(list, {id = 71229, type = "buff"})				-- Precognition
		elseif (t == 47673) then									-- Sigil of Virulence
			tinsert(list, {id = 67383, type = "buff"})				-- Unholy Force
		end
	end
end

-- IDInList
function module:IDInList(list, id)
	for k,v in pairs(list) do
		if (v.id and v.id == id) then
			return true
		end
	end
end

-- AddSlotEnchant
function module:AddSlotEnchant(list, slot)
	local link = GetInventoryItemLink("player", slot)
	if (link) then
		local id, a, b, c, d, e, f = link:match("\124Hitem:(%d+):(%d+):(%d+):(%d+):(%d+):")
		local encs = {a, b, c, d, e, f}
		for i = 1,6 do
			local enc = tonumber(encs[i])
			if (enc) then
				if (enc == 3604) then								-- Hyperspeed Accelerators
					tinsert(list, {id = 54758, type = "buff"})		-- Hyperspeed Acceleration
				elseif (enc == 3368) then							-- Rune of the Fallen Crusader
					if (not self:IDInList(list, 53365)) then
						tinsert(list, {id = 53365, type = "buff"})		-- Unholy Strength
					end

				elseif (enc == 3789) then							-- Berserking
					if (not self:IDInList(list, 59620)) then
						tinsert(list, {id = 59620, type = "buff"})		-- Berserk
					end

				elseif (enc == 2673) then							-- Mongoose
					if (not self:IDInList(list, 28093)) then
						tinsert(list, {id = 28093, type = "buff"})		-- Lightning Speed
					end
				end
			end
		end
	end
end

-- DefaultClassSpells
function module:DefaultClassSpells()
	local _, class = UnitClass("player")
	local spec, s1, s2, s3 = LGT:GetUnitTalentSpec("player")

	local classSpells = {}
	if (spec) then
		if (class == "ROGUE") then
			classSpells = {
				{id = 5171, type = "buff"},								-- Slice and Dice
				{id = 1943, type = "debuff"},							-- Rupture
			}

			if (LGT:UnitHasTalent("player", (GetSpellInfo(51662)))) then
				tinsert(classSpells, {id = 51662, type = "buff"})		-- Hunger For Blood
			end
			if (s1 > (s2 + s3)) then
				-- Mutilate
				tinsert(classSpells, {id = 32645, type = "buff"})		-- Envenom
			end
			tinsert(classSpells, {id = 57970, type = "debuff"})			-- Deadly Poison IX

		elseif (class == "SHAMAN") then
			classSpells = {}
			if (LGT:UnitHasTalent("player", (GetSpellInfo(17364)))) then
				tinsert(classSpells, {id = 17364, type = "debuff"})		-- Stormstrike
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(16284)))) then
				tinsert(classSpells, {id = 16284, type = "buff"})		-- Flurry
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(29180)))) then
				tinsert(classSpells, {id = 29180, type = "buff"})		-- Elemental Devestation
			end
			if (s1 > (s2 + s3)) then
				tinsert(classSpells, {id = 8050, type = "debuff"})		-- Flame Shock
			end
			if (s2 > (s1 + s3)) then
				tinsert(classSpells, {id = 49281, type = "buff"})		-- Lightning Shield
			else
				tinsert(classSpells, {id = 57960, type = "buff"})		-- Water Shield
			end

		elseif (class == "PALADIN") then
			classSpells = {}
			if (s1 > (s2 + s3)) then
				tinsert(classSpells, {id = 20166, type = "buff"})		-- Seal of Wisdom
			else
				tinsert(classSpells, {id = 53736, type = "buff"})		-- Seal of Corruption
			end

			if (LGT:UnitHasTalent("player", (GetSpellInfo(51455)))) then
				tinsert(classSpells, {id = 51455, type = "buff"})		-- Judgements of the Pure
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(53576)))) then
				tinsert(classSpells, {id = 53576, type = "buff"})		-- Infusion of Light
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(20049)))) then
				tinsert(classSpells, {id = 20053, type = "buff"})		-- Vengeance
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(53380)))) then
				tinsert(classSpells, {id = 53380, type = "buff"})		-- Righteous Vengeance
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(20925)))) then
				tinsert(classSpells, {id = 25780, type = "buff"})		-- Righteous Fury
				tinsert(classSpells, {id = 20925, type = "buff"})		-- Holy Shield
				tinsert(classSpells, {id = 53601, type = "buff"})		-- Sacred Shield (buff)
				tinsert(classSpells, {id = 58597, type = "buff"})		-- Sacred Shield (proc)
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(20127)))) then
				tinsert(classSpells, {id = 20127, type = "buff"})		-- Redoubt
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(20177)))) then
				tinsert(classSpells, {id = 20177, type = "buff"})		-- Reckoning
			end

		elseif (class == "DEATHKNIGHT") then
			classSpells = {
				{id = 59921, type = "debuff"},							-- Frost Fever
				{id = 59879, type = "debuff"},							-- Blood Plague
			}
			if (LGT:UnitHasTalent("player", (GetSpellInfo(49194)))) then
				tinsert(classSpells, {id = 49194, type = "debuff"})		-- Unholy Blight
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(66817)))) then
				tinsert(classSpells, {id = 66803, type = "buff"})		-- Desolation
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(49504)))) then
				tinsert(classSpells, {id = 49504, type = "buff"})		-- Bloody Vengeance
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(51123)))) then
				tinsert(classSpells, {id = 51123, type = "buff"})		-- Killing Machine
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(49222)))) then
				tinsert(classSpells, {id = 49222, type = "buff"})		-- Bone Shield
			end

		elseif (class == "PRIEST") then
			classSpells = {}
			if (LGT:UnitHasTalent("player", (GetSpellInfo(15332)))) then
				tinsert(classSpells, {id = 15332, type = "buff"})		-- Shadow Weaving
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(34914)))) then
				tinsert(classSpells, {id = 34914, type = "debuff"})		-- Vampiric Touch
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(15286)))) then
				tinsert(classSpells, {id = 15286, type = "buff"})		-- Vampiric Embrace
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(34753)))) then
				tinsert(classSpells, {id = 34753, type = "buff"})		-- Holy Concentration
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(63730)))) then
				tinsert(classSpells, {id = 63730, type = "buff"})		-- Serendipity
			end
			tinsert(classSpells, {id = 588, type = "buff"})				-- Inner Fire

		elseif (class == "MAGE") then
			classSpells = {
				{id = 6117, type = "buff"},								-- Mage Armor
			}
			if (LGT:UnitHasTalent("player", (GetSpellInfo(12577)))) then -- Arcane Concentration
				tinsert(classSpells, {id = 12536, type = "buff"})		-- Clearcasting
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(44545)))) then
				tinsert(classSpells, {id = 44545, type = "buff"})		-- Finger's of Frost
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(11426)))) then
				tinsert(classSpells, {id = 11426, type = "buff"})		-- Ice Barrier
			end

		elseif (class == "WARLOCK") then
			classSpells = {
				{id = 172, type = "debuff"},							-- Corruption
				{id = 28176, type = "buff"},							-- Fel Armor
			}

		elseif (class == "DRUID") then
			classSpells = {}
			if (s1 > (s2 + s3)) then
				tinsert(classSpells, {id = 8921, type = "debuff"})		-- Moonfire
			end
			tinsert(classSpells, {id = 467, type = "buff"})				-- Thorns

		elseif (class == "WARRIOR") then
			classSpells = {}
			if (LGT:UnitHasTalent("player", (GetSpellInfo(56614)))) then -- Wrecking Crew
				tinsert(classSpells, {id = 57522, type = "buff"})		-- Enrage
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(12317)))) then -- Enrage
				tinsert(classSpells, {id = 14204, type = "buff"})		-- Enrage
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(12319)))) then
				tinsert(classSpells, {id = 12319, type = "buff"})		-- Flurry
			end
			if (LGT:UnitHasTalent("player", (GetSpellInfo(12867)))) then
				tinsert(classSpells, {id = 12867, type = "debuff"})		-- Deep Wounds
			end

		elseif (class == "HUNTER") then
			classSpells = {
			}
			if (LGT:UnitHasTalent("player", (GetSpellInfo(34500)))) then
				tinsert(classSpells, {id = 34500, type = "buff"})		-- Expose Weakness
			end
		end
		self.needDefaults = nil
	else
		self.needDefaults = true
	end

	local procs = {}
	for i = 1,18 do
		self:AddSlotEnchant(procs, i)
	end

	for i = 1,18 do
		self:AddSlotProcs(procs, i)
	end

	if (next(procs)) then
		tinsert(classSpells, {type = "spacer"})
		for k,v in pairs(procs) do
			tinsert(classSpells, v)
		end
	end

	if (classSpells) then
		for i,info in pairs(classSpells) do
			if (info.id) then
				local spellName, rank, texture = GetSpellInfo(info.id)
				if (not spellName) then
					error(format("Missing spell for ID %d", info.id))
				end
				info.name = spellName
				info.texture = texture
			end
		end
	end

	return classSpells or {}
end
