local Utopia = LibStub("AceAddon-3.0"):GetAddon("Utopia", true)
if (not Utopia) then
	return
end
Utopia:UpdateVersion("$Revision: 213 $")
local function d(...)
	ChatFrame1:AddMessage("|cFFFF8080DEBUG:|r "..format(...), 0.8, 0.8, 0.8)
end

local module = Utopia:NewModule("Details", "AceHook-3.0", "AceEvent-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("Utopia")
local LGT = LibStub("LibGroupTalents-1.0")
local gui = LibStub("AceGUI-3.0")
local BC, loadBCDone
local new, del, copy, deepDel = Utopia.new, Utopia.del, Utopia.copy, Utopia.deepDel
local Gradient, UnitFullName, ClassColour, SmoothColour = Utopia.Gradient, Utopia.UnitFullName, Utopia.ClassColour, Utopia.SmoothColour
local rotate, propercase = Utopia.rotate, Utopia.propercase
local band = bit.band
local BabbleTalents

module.options = {
	type = "group",
	name = L["Details"],
	desc = L["Show enchanced details of available auras, who can cast them and at what levels"],
	get = function(info) return db[info[#info]] end,
	set = function(info, value) db[info[#info]] = value end,
	guiInline = true,
	order = 100,
	args = {
	},
}

-- GetTreeDefinition
local GetTreeDefinition
do
	local treeDef = {}
	function GetTreeDefinition()
		local tree = treeDef[module.detailsMode]
		if (tree) then
			return tree
		end
		tree = new()

		local function sortMe(a,b) return a.text < b.text end

		for category,info in pairs(Utopia[module.detailsMode]) do
			tinsert(tree, {
				text = category,
				value = category,
				children = {}
			})
		end
		sort(tree, sortMe)

		for i,treeInfo in pairs(tree) do
			local category = treeInfo.text
			local info = Utopia[module.detailsMode][category]
			for spellName,data in pairs(info.spells) do
				tinsert(treeInfo.children, {
					text = data.name,
					value = data.name,
				})
			end
			sort(treeInfo.children, sortMe)
		end

		treeDef[module.detailsMode] = tree

		if (treeDef.buffs and treeDef.debuffs) then
			function GetTreeDefinition()
				return treeDef[module.detailsMode]
			end
		end
		return treeDef[module.detailsMode]
	end
end

-- ShowSpellDetails
function module:ShowSpellDetails(widget, category, spell)
	widget:ReleaseChildren()
	local data = Utopia[self.detailsMode][category]
	assert(data, format("Utopia.%s['%s'] ~= nil", self.detailsMode, category or "nil"))
	local spellInfo = spell and data.spells[spell]

	local sf = gui:Create("ScrollFrame")
	sf.width = "fill"
	sf:SetLayout("flow")

	self.detailsFrame:SetStatusText(L["DESC."..self.detailsMode.."."..category])

	local desc = gui:Create("Label")
	desc:SetText(L["DESC."..self.detailsMode.."."..category])
	desc.width = "fill"
	sf:AddChild(desc)

	if (not spellInfo) then
		return
	end

	local anyCanDo
	local players = new()
	for unit in Utopia:IterateRoster() do
		local _, class = UnitClass(unit)
		if (class == spellInfo.class) then
			if (spellInfo.requiredTalent) then
				if (LGT:UnitHasTalent(unit, spellInfo.requiredTalent)) then
					anyCanDo = true
				end
			else
				anyCanDo = true
			end
			tinsert(players, unit)
		end
	end
	local function GetSortString(unit)
		local talent, improved = 0, 0
		local name = UnitFullName(unit)
		if (spellInfo.requiredTalent) then
			if (LGT:GetUnitTalents(name)) then
				talent = (LGT:UnitHasTalent(name, spellInfo.requiredTalent) or 0) + 2
			else
				talent = 0
			end
		end
		if (spellInfo.improved) then
			if (LGT:GetUnitTalents(name)) then
				improved = (LGT:UnitHasTalent(name, spellInfo.improved) or 0) + 2
			else
				improved = 0
			end
		end
		local ret = format("%d%d%s", 9 - talent, 9 - improved, name)
		return ret
	end

	sort(players, function(a, b)
		local sortA = GetSortString(a)
		local sortB = GetSortString(b)
		return sortA < sortB
	end)

	local amount = Utopia:GetAmount(spellInfo)
	local maxAmount = Utopia:GetAmount(spellInfo, nil, true)

	local amountNum = amount and tonumber(strmatch(amount, "(%d+)"))
	local maxAmountNum = maxAmount and tonumber(strmatch(maxAmount, "(%d+)"))
	local amountColour = "|cFF80FF80"
	if (amountNum and maxAmountNum) then
		if (amountNum < maxAmountNum) then
			amountColour = "|cFFE0E060"
		end
	end

--Utopia:Print(format("- amount = %q, anyCanDo = %s", amount or "nil", tostring(anyCanDo)))
	if (amount and amount ~= "" and amount ~= "--") then
		local cat = Utopia[self.detailsMode][category]
		assert(cat)
		if (cat.attribute) then
			amount = amount .. " " .. cat.attribute
		end
		local label = gui:Create("Label")
		label.width = "fill"
		label:SetText(format(L["Maximum potential amount for group is %s%s"], anyCanDo and amountColour or "|cFFFF8080", anyCanDo and amount or L["Not available"]))
		sf:AddChild(label)
	end

	if (maxAmount and maxAmount ~= "" and maxAmount ~= "--") then
		local cat = Utopia[self.detailsMode][category]
		assert(cat)
		if (cat.attribute) then
			maxAmount = maxAmount .. " " .. cat.attribute
		end
		local label = gui:Create("Label")
		label.width = "fill"
		label:SetText(format(L["Maximum possible amount is %s%s"], "|cFF80FF80", maxAmount))
		sf:AddChild(label)
	end

	for i, unit in ipairs(players) do
		local canDo, needsPet, hasPet --, improved
		if (spellInfo.requiredTalent) then
			canDo = LGT:UnitHasTalent(unit, spellInfo.requiredTalent)
		else
			canDo = true
		end
		--if (spellInfo.improved) then
		--	improved = 9 - (LGT:UnitHasTalent(unit, spellInfo.improved) or 0)
		--end
		if (spellInfo.pet) then
			local currentPet = Utopia.pets[UnitFullName(unit)]
			if (currentPet ~= spellInfo.pet) then
				canDo = nil
				needsPet = spellInfo.pet
				hasPet = currentPet
			end
		end

        local group = gui:Create("UtopiaCustomGroup")
        group:SetWidth(150)

		local tooltipID = spellInfo.id
		if (spellInfo.rankIDs) then
			local myRankLevel
			if (UnitIsUnit("player", unit)) then
				myRankLevel = Utopia:MySpellRank(spellInfo)
			end
			if (not myRankLevel) then
				myRankLevel = Utopia:MyLevelRank(spellInfo.rankLevels)
			end
			if (myRankLevel) then
	        	tooltipID = spellInfo.rankIDs[myRankLevel]
	        end
	    end
        group:SetSpellID(tooltipID)
        group:SetPlayer(UnitFullName(unit))

		local name = gui:Create("UtopiaLabel")
		name:SetText(Utopia:ColourPlayer(unit))
		name:SetFont(GameFontNormal)
		name:SetWidth(100)
		group:AddChild(name)

		local label = gui:Create("Label")
		label.width = "fill"

		local amountLabel
		local gotTalents = LGT:GetUnitTalents(unit)
		if (canDo) then
			local level = spellInfo.minLevel or spellInfo.rankLevels and spellInfo.rankLevels[1]
			if (level and UnitLevel(unit) < level) then
				group:SetBorderColor(0.8,0.4,0.4)
				local c = GetQuestDifficultyColor(level)
				c = format("|cFF%02X%02X%02X%d|r", c.r * 255, c.g * 255, c.b * 255, level)
				label:SetText(format(L["Requires level %s"], c))

			elseif (spellInfo.improved) then
				if (not gotTalents) then
					group:SetBorderColor(0.4,0.4,0.4)
					label:SetText(L["Talents unscanned"])
				else
					local imp = LGT:UnitHasTalent(unit, spellInfo.improved) or 0
					if (imp > 0) then
						if (imp < spellInfo.maxTalentPoints) then
							group:SetBorderColor(0.8,0.8,0.4)
							label:SetText(format(L["Can apply. Partially improved (|cFFFF8080%d|r of |cFF80FF80%d|r talent points)"], imp, spellInfo.maxTalentPoints))
						else
							group:SetBorderColor(0.4,0.8,0.4)
							label:SetText(L["Can apply. Improved"])
						end
					else
						group:SetBorderColor(0.8,0.8,0.4)
						label:SetText(L["Can apply. Un-improved"])
					end
				end
			else
				--label:SetText("Can apply")
				group:SetBorderColor(0.4,0.8,0.4)

				if (spellInfo.maxTalentPoints and spellInfo.maxTalentPoints > 1) then
					if (not gotTalents) then
						group:SetBorderColor(0.4,0.4,0.4)
						label:SetText(L["Talents unscanned"])
					else
						if (canDo < spellInfo.maxTalentPoints) then
							group:SetBorderColor(0.8,0.8,0.4)
							label:SetText(format(L["Can apply partially (|cFFFF8080%d|r of |cFF80FF80%d|r talent points)"], canDo, spellInfo.maxTalentPoints))
						end
					end
				end
			end

			amount = Utopia:GetAmount(spellInfo, false, nil, UnitFullName(unit))
			if (amount and amount ~= "" and amount ~= "--") then
				amountLabel = gui:Create("Label")
				amountLabel:SetText(amount)
			end
		else
			if (needsPet) then
				group:SetBorderColor(0.8,0.8,0.4)
				label:SetText(format(L["Requires a |cFFFFFF80%s|r pet, currently has a |cFFFFFF80%s|r"], needsPet, hasPet or NONE))
			elseif (not gotTalents) then
				group:SetBorderColor(0.4,0.4,0.4)
				label:SetText(L["Talents unscanned"])
			else
				group:SetBorderColor(0.8,0.4,0.4)
				label:SetText(self.detailsMode == "buffs" and L["Cannot apply this buff"] or L["Cannot apply this debuff"])
			end
		end

		group:AddChild(label)
		if (amountLabel) then
			group:AddChild(amountLabel)
		end

        sf:AddChild(group)
	end

	widget:AddChild(sf)
end

-- FindSpellForUnit
function module:FindSpellForUnit(unit, category)
	local _, class = UnitClass(unit)
	local name = UnitFullName(unit)

	local cat = Utopia[self.detailsMode][category]
	local canDo, cantDo
	for spellName,spellInfo in pairs(cat.spells) do
		if (class == spellInfo.class) then
			local minLevel = spellInfo.minLevel or (spellInfo.rankLevels and spellInfo.rankLevels[1])
			if (not minLevel or UnitLevel(unit) >= minLevel) then
				if (spellInfo.requiredTalent) then
					if (LGT:UnitHasTalent(unit, spellInfo.requiredTalent)) then
						canDo = spellInfo
					else
						cantDo = spellInfo
					end
				else
					canDo = spellInfo
				end
			end
		end
	end
	return canDo, cantDo
end

do
	local orderedNums
	local function neededSortFunc(a, b)
		local amA = orderedNums[a]
		local amB = orderedNums[b]
		if (amA == amB) then
			return a < b
		end
		return (amA or 0) > (amB or 0)
	end

	-- ShowNeededClassesForDebuff
	function module:ShowNeededClassesForDebuff(widget, category)
		local cat = Utopia[self.detailsMode][category]

		local orderedList = new()
		orderedNums = new()
		for spellName,spellInfo in pairs(cat.spells) do
			local _, amount = Utopia:GetAmount(spellInfo, true, true)
			orderedNums[spellName] = amount
			tinsert(orderedList, spellName)
		end
		sort(orderedList, neededSortFunc)

		for i,spellName in ipairs(orderedList) do
			local spellInfo = cat.spells[spellName]
			local spec = spellInfo.spec
			if (spec) then
				if (not BabbleTalents and GetLocale() ~= "enUS" and GetLocale() ~= "enGB") then
					LoadAddOn("LibBabble-TalentTree-3.0")
					BabbleTalents = LibStub("LibBabble-TalentTree-3.0", true)
					if (BabbleTalents) then
						BabbleTalents = BabbleTalents:GetUnstrictLookupTable()
					end
				end
				if (BabbleTalents) then
					spec = BabbleTalents[spec] or spec
				end
			end
			local class = LOCALIZED_CLASS_NAMES_MALE[spellInfo.class] or spellInfo.class

			local oldMax = Utopia.db.profile.defaultMax
			Utopia.db.profile.defaultMax = nil
			local minamount, minamountNum = Utopia:GetAmount(spellInfo, true, -1)
			Utopia.db.profile.defaultMax = true
			local amount, amountNum = Utopia:GetAmount(spellInfo, true, true)
			Utopia.db.profile.defaultMax = oldMax

	        local group = gui:Create("UtopiaCustomGroup")
	        group.width = "fill"
			local tooltipID = spellInfo.id
			if (spellInfo.rankIDs) then
				local myRankLevel = Utopia:MyLevelRank(spellInfo.rankLevels)
				if (myRankLevel) then
		        	tooltipID = spellInfo.rankIDs[myRankLevel]
		        end
		    end

			local name = gui:Create("UtopiaLabel")
			local fromColour
			if (spellInfo.runescroll) then
				fromColour = "|cFFFFB3B3"
		        group:SetItemID(spellInfo.runescroll)

				local itemName = GetItemInfo(spellInfo.runescroll)
				if (not itemName) then
					if (not Utopia.TempTooltip) then
						Utopia.TempTooltip = CreateFrame("GameTooltip")
					end
					Utopia.TempTooltip:SetHyperlink("item:"..spellInfo.runescroll)
					Utopia.TempTooltip:Hide()
					itemName = "Runescroll/Drums"		-- Not going to localise, as it's only the first time you mouseover
				end

				name:SetText(format("%s%s|r", fromColour, itemName))
			else
				fromColour = ClassColour(spellInfo.class)
		        group:SetSpellID(tooltipID)
				name:SetText(format("%s%s|r", fromColour, spellInfo.name))
			end
			name:SetFont(GameFontNormal)
			name.width = "fill"
			group:AddChild(name)

			local desc
			if (spellInfo.runescroll) then
				local link = select(2, GetItemInfo(spellInfo.runescroll))
				desc = format(L["%s with |cFFFFFF80%s|r"], L["Anyone"], link or "Runescroll/Drums")
			else
				if (spec) then
					desc = format("%s %s|r", spec, class)
				else
					desc = class.."|r"
				end
				if (spellInfo.pet) then
					desc = format(L["%s with |cFFFFFF80%s|r"], desc, spellInfo.pet.." "..PET)
				end
				if (spellInfo.required) then
					desc = format(L["%s with |cFFFFFF80%s|r"], desc, spellInfo.required)
				end
			end

			local from = gui:Create("UtopiaLabel")
			from.width = "fill"
			if (amount == "--") then
				local level = spellInfo.minLevel or spellInfo.rankLevels and spellInfo.rankLevels[1]
				if (level) then
					local c = GetQuestDifficultyColor(level)
					c = format("|cFF%02X%02X%02X%d|r", c.r * 255, c.g * 255, c.b * 255, level)
					from:SetText(format(L["%s%s needs to be level %s for this ability"], fromColour, desc, c))
				end
			else
				if (minamountNum and minamountNum < amountNum) then
					local from2 = gui:Create("UtopiaLabel")
					from2.width = "fill"

					if ((GetLocale() == "enUS" or GetLocale() == "enGB") and strfind("AEIOU", desc:sub(1, 1))) then
						from2:SetText(format(L["%s from an %s%s"], minamount, fromColour, desc))
					else
						from2:SetText(format(L["%s from a %s%s"], minamount, fromColour, desc))
					end

					group:AddChild(from2)
				end

				if (spellInfo.runescroll) then
					from:SetText(format(L["%s from %s"], amount, desc))
				else
					if ((GetLocale() == "enUS" or GetLocale() == "enGB") and strfind("AEIOU", desc:sub(1, 1))) then
						if (spellInfo.improved) then
							from:SetText(format(L["%s from an %s%s with |cFFFFFF80%s|r"], amount, fromColour, desc, spellInfo.improved))
						else
							from:SetText(format(L["%s from an %s%s"], amount, fromColour, desc))
						end
					else
						if (spellInfo.improved) then
							from:SetText(format(L["%s from a %s%s with |cFFFFFF80%s|r"], amount, fromColour, desc, spellInfo.improved))
						else
							from:SetText(format(L["%s from a %s%s"], amount, fromColour, desc))
						end
					end
				end
			end

			group:AddChild(from)
			widget:AddChild(group)
		end

		orderedNums = del(orderedNums)
		del(orderedList)
	end
end

-- ShowCategoryDetails
function module:ShowCategoryDetails(widget, category)
	widget:ReleaseChildren()
	local data = Utopia[self.detailsMode][category]
	assert(data, format("Utopia.%s['%s'] ~= nil", self.detailsMode, category or "nil"))

	local sf = gui:Create("ScrollFrame")
	sf.width = "fill"
	sf:SetLayout("flow")

	self.detailsFrame:SetStatusText(L["DESC."..self.detailsMode.."."..category])

	local desc = gui:Create("Label")
	desc:SetText(L["DESC."..self.detailsMode.."."..category])
	desc.width = "fill"
	sf:AddChild(desc)

	local cat = Utopia[self.detailsMode][category]
	local classes = new()
	for spellName,info in pairs(cat.spells) do
		classes[info.class or "any"] = info
	end

	local amount, maxAmount, maxAmountSpellInfo
	local amountNum, maxAmountNum = 0, 0
	local anyCanDo
	local players = new()
	for unit in Utopia:IterateRoster() do
		local _, class = UnitClass(unit)
		local can, cant = self:FindSpellForUnit(unit, category)
		local spellInfo = can or cant
		if (spellInfo) then
			if (spellInfo.requiredTalent) then
				if (LGT:UnitHasTalent(unit, spellInfo.requiredTalent)) then
					anyCanDo = true
				end
			else
				anyCanDo = true
			end

			local a = Utopia:GetAmount(spellInfo, false, nil, UnitFullName(unit))
			if (a and a ~= "") then
				local man = tonumber(strmatch(a, "(%d+)")) or 0
				if (man > amountNum) then
					amountNum = man
					amount = a
				end
			end

			tinsert(players, unit)
		end
	end

	for class,spellInfo in pairs(classes) do
		local ma = Utopia:GetAmount(spellInfo, nil, true)
		local man = ma and tonumber(strmatch(ma, "(%d+)")) or 0
		if (man > maxAmountNum) then
			maxAmountNum = man
			maxAmount = ma
			maxAmountSpellInfo = spellInfo
		end
	end

	local function GetSortString(unit)
		local talent, improved = 0, 0
		local _, class = UnitClass(unit)
		local name = UnitFullName(unit)
		local spellInfo = classes[class]
		if (spellInfo) then
			if (spellInfo.requiredTalent) then
				if (LGT:GetUnitTalents(name)) then
					talent = (LGT:UnitHasTalent(name, spellInfo.requiredTalent) or 0) + 2
				else
					talent = 0
				end
			end
			if (spellInfo.improved) then
				if (LGT:GetUnitTalents(name)) then
					improved = (LGT:UnitHasTalent(name, spellInfo.improved) or 0) + 2
				else
					improved = 0
				end
			end
		end
		local ret = format("%d%d%s", 9 - talent, 9 - improved, name)
		return ret
	end

	sort(players, function(a, b)
		local sortA = GetSortString(a)
		local sortB = GetSortString(b)
		return sortA < sortB
	end)

	local amountColour = "|cFF80FF80"
	if (amountNum and maxAmountNum) then
		if (amountNum < maxAmountNum) then
			amountColour = "|cFFE0E060"
		end
	end

--Utopia:Print(format("- amount = %q, anyCanDo = %s", amount or "nil", tostring(anyCanDo)))
	if (amount and amount ~= "") then
		local cat = Utopia[self.detailsMode][category]
		assert(cat)
		if (cat.attribute) then
			amount = amount .. " " .. cat.attribute
		end
		local label = gui:Create("Label")
		label.width = "fill"
		label:SetText(format(L["Maximum potential amount for group is %s%s"], anyCanDo and amountColour or "|cFFFF8080", anyCanDo and amount or L["Not available"]))
		sf:AddChild(label)
	end

	if (maxAmount and maxAmount ~= "") then
		local cat = Utopia[self.detailsMode][category]
		assert(cat)
		if (cat.attribute) then
			maxAmount = maxAmount .. " " .. cat.attribute
		end
		local label = gui:Create("Label")
		label.width = "fill"
		
		label:SetText(format(L["Maximum possible amount is %s%s"], "|cFF80FF80", maxAmount))
		sf:AddChild(label)
	end

	local anyCan
	for i, unit in ipairs(players) do
		local _, class = UnitClass(unit)

		local can, cant = self:FindSpellForUnit(unit, category)
		local spellInfo = can or cant

		local canDo, needsPet, hasPet		--, improved
		if (spellInfo.requiredTalent) then
			canDo = LGT:UnitHasTalent(unit, spellInfo.requiredTalent)
		elseif ((UnitLevel(unit) or 999) >= (spellInfo.minLevel or (spellInfo.rankLevels and spellInfo.rankLevels[1]) or 0)) then
			canDo = true
		end
		if (spellInfo.pet) then
			local currentPet = Utopia.pets and Utopia.pets[UnitFullName(unit)]
			if (currentPet ~= spellInfo.pet) then
				canDo = nil
				needsPet = spellInfo.pet
				hasPet = currentPet
			end
		end

        local group = gui:Create("UtopiaCustomGroup")
        group:SetWidth(170)

		local tooltipID = spellInfo.id
		if (spellInfo.rankIDs) then
			local myRankLevel
			if (UnitIsUnit("player", unit)) then
				myRankLevel = Utopia:MySpellRank(spellInfo)
			end
			if (not myRankLevel) then
				myRankLevel = Utopia:MyLevelRank(spellInfo.rankLevels)
			end
			if (myRankLevel) then
	        	tooltipID = spellInfo.rankIDs[myRankLevel]
	        end
	    end
        group:SetSpellID(tooltipID)
        group:SetPlayer(UnitFullName(unit))

		local name = gui:Create("UtopiaLabel")
		name:SetText(Utopia:ColourPlayer(unit))
		name:SetFont(GameFontNormal)
		name.width = "fill"
		group:AddChild(name)

		local spellLabel = gui:Create("UtopiaLabel")
		spellLabel:SetText(spellInfo.name)
		spellLabel:SetFont(GameFontNormal)
		spellLabel.width = "fill"
		group:AddChild(spellLabel)

		local label = gui:Create("Label")
		label.width = "fill"

		local amountLabel
		local gotTalents = LGT:GetUnitTalents(unit)
		if (canDo) then
			if (spellInfo.improved) then
				if (not gotTalents) then
					group:SetBorderColor(0.4,0.4,0.4)
					label:SetText(L["Talents unscanned"])
				else
					anyCan = true
					local imp = LGT:UnitHasTalent(unit, spellInfo.improved) or 0
					if (imp > 0) then
						if (imp < spellInfo.maxTalentPoints) then
							group:SetBorderColor(0.8,0.8,0.4)
							label:SetText(format(L["Can apply. Partially improved (|cFFFF8080%d|r of |cFF80FF80%d|r talent points)"], imp, spellInfo.maxTalentPoints))
						else
							group:SetBorderColor(0.4,0.8,0.4)
							label:SetText(L["Can apply. Improved"])
						end
					else
						group:SetBorderColor(0.8,0.8,0.4)
						label:SetText(L["Can apply. Un-improved"])
					end
				end
			else
				anyCan = true
				group:SetBorderColor(0.4,0.8,0.4)

				if (spellInfo.maxTalentPoints and spellInfo.maxTalentPoints > 1) then
					if (not gotTalents) then
						group:SetBorderColor(0.4,0.4,0.4)
						label:SetText(L["Talents unscanned"])
					else
						if (canDo < spellInfo.maxTalentPoints) then
							group:SetBorderColor(0.8,0.8,0.4)
							label:SetText(format(L["Can apply partially (|cFFFF8080%d|r of |cFF80FF80%d|r talent points)"], canDo, spellInfo.maxTalentPoints))
						end
					end
				end
			end

			amount = Utopia:GetAmount(spellInfo, false, nil, UnitFullName(unit))
			if (amount and amount ~= "") then
				amountLabel = gui:Create("Label")
				amountLabel:SetText(amount)
			end
		else
			local level = spellInfo.minLevel or spellInfo.rankLevels and spellInfo.rankLevels[1]
			if (level and UnitLevel(unit) < level) then
				group:SetBorderColor(0.8,0.4,0.4)
				local c = GetQuestDifficultyColor(level)
				c = format("|cFF%02X%02X%02X%d|r", c.r * 255, c.g * 255, c.b * 255, level)
				label:SetText(format(L["Requires level %s"], c))
			elseif (needsPet) then
				group:SetBorderColor(0.8,0.8,0.4)
				label:SetText(format(L["Requires a |cFFFFFF80%s|r pet, currently has a |cFFFFFF80%s|r"], needsPet, hasPet or NONE))
			elseif (not gotTalents) then
				group:SetBorderColor(0.4,0.4,0.4)
				label:SetText(L["Talents unscanned"])
			else
				group:SetBorderColor(0.8,0.4,0.4)
				label:SetText(L["Cannot apply this debuff"])
			end
		end

		if (canDo) then
			local ex = spellInfo.exclusive or spellInfo.totem
			if (ex) then
				local frame
				if (Utopia.db.profile.dualframe and self.detailsMode == "debuffs") then
					frame = Utopia.frames[2]
				else
					frame = Utopia.frames[1]
 				end

				local spellId = Utopia:HasExclusiveAura(self.detailsMode, frame.unit, ex, UnitGUID(unit))
				if (spellId) then
					if (GetSpellInfo(spellId) ~= spellInfo.name and GetSpellInfo(spellId) ~= spellInfo.alternate) then
						label:SetText(format(L["|cFFFF8080Cannot apply because they have |cFFFFFF80%s|cFFFF8080 active"], GetSpellInfo(spellId)))
						canDo = nil
					end
				end
			end
		end

		group:AddChild(label)
		if (amountLabel) then
			group:AddChild(amountLabel)
		end

        sf:AddChild(group)
	end

	if (#players > 0) then
		local also = gui:Create("Label")
		also:SetText(L["Available from these sources:"])
		also.width = "fill"
		sf:AddChild(also)
	end
	self:ShowNeededClassesForDebuff(sf, category)

	widget:AddChild(sf)

	del(classes)
	del(players)
end

-- OnTreeGroupSelected
local function OnTreeGroupSelected(widget, event, value)
	module.detailsWidget = widget
	module.detailsValue = value
	local category, spell = ("\001"):split(value)
	if (spell) then
		module:ShowSpellDetails(widget, category, spell)
	else
		module:ShowCategoryDetails(widget, category)
	end
end

-- OnTabSelected
local function OnTabSelected(widget, event, mode)
	assert(mode == "buffs" or mode == "debuffs")
	module.detailsMode = mode
	module.detailsTree:SetTree(GetTreeDefinition())
end

-- CreateDetailsFrame
function module:CreateDetailsFrame()
	local f = gui:Create("Frame")
	self.detailsFrame = f
	f:SetTitle(L[self.moduleName])
	f:SetStatusText("")
	f:SetWidth(650)
	f:SetHeight(450)
	f.width = "fill"
	f:SetLayout("flow")

	local tabgroup = gui:Create("TabGroup", 200)
	self.tabgroup = tabgroup
	tabgroup:SetLayout("fill")
	tabgroup.width = "fill"
	tabgroup.height = "fill"
	tabgroup:SetTabs({{text = "Buffs", value = "buffs"}, {text = "Debuffs", value = "debuffs"}})
	tabgroup:SetCallback("OnGroupSelected", OnTabSelected, self)

	local tree = gui:Create("TreeGroup", 200)
	self.detailsTree = tree
	tree:EnableButtonTooltips(false)
	tree:SetLayout("flow")
	--tree.width = "fill"
	--tree.height = "fill"
	tree:SetTree(GetTreeDefinition())
	tree:SetCallback("OnGroupSelected", OnTreeGroupSelected, self)

	f:AddChild(tabgroup)
	tabgroup:AddChild(tree)
	f:DoLayout()
end

-- firstActiveSpellForKey
local function firstActiveSpellForKey(key)
	info = Utopia[module.detailsMode][key]

	for name,spellInfo in pairs(info.spells) do
		local canDo = Utopia.spellPotential and Utopia.spellPotential[name]
		if (not canDo) then
			if (Utopia.petClasses[spellInfo.class]) then
				canDo = Utopia.petPotential and Utopia.petPotential[name]
			end
		end

		if (canDo) then
			return name
		end
	end
end		

-- ToggleDetails
function module:ToggleDetails(mode, key)
	if (self.detailsFrame and self.detailsFrame:IsShown() and self.detailsTree.localstatus and key == self.detailsTree.localstatus.selected and mode == self.detailsMode) then
		self.detailsFrame:Release()
		self.detailsFrame = nil
		return
	end

	self.detailsWidget = nil
	self.detailsMode = mode
	self.detailsValue = nil
	if (not self.detailsFrame) then
		self:CreateDetailsFrame()
	end

	self.detailsFrame:Show()
	self.tabgroup:SelectTab(mode)
	self.detailsTree.localstatus.groups = {}
	self.detailsKey = key
	self.detailsTree:SelectByValue(key)
end

-- RefreshTree
function module:RefreshTree()
	if (self.detailsValue) then
		self.tabgroup:SelectTab(self.detailsMode)
		self.detailsTree.localstatus.groups = {}
		self.detailsTree:SelectByValue(self.detailsValue)
	end
end

do
	-- Copied from InlineGroup, but won't have title and allows for changing border colours
	local AceGUI = gui
	local Type = "UtopiaCustomGroup"
	local Version = 4
	
	local function OnAcquire(self)
		self:SetWidth(300)
		self:SetHeight(100)
		self.border:SetBackdropColor(0.1,0.1,0.1,0.5)
		self.border:SetBackdropBorderColor(0.4,0.4,0.4)
	end
	
	local function OnRelease(self)
		self.frame:ClearAllPoints()
		self.frame:Hide()
		self.frame:EnableMouse(false)
		self.spellId, self.itemId = nil
		self.playerName = nil

		self:HideOptions()
	end

	local PaneBackdrop  = {
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 3, right = 3, top = 5, bottom = 3 }
	}
	
	local function SetTitle(self,title)
		self.titletext:SetText(title)
	end

	local function SetBorderColor(self, r, g, b)
		self.border:SetBackdropBorderColor(r, g, b)
	end

	local function SetColor(self, r, g, b)
		self.border:SetBackdropColor(r, g, b)
	end

	local function LayoutFinished(self, width, height)
		self:SetHeight((height or 0) + 25)
	end
	
	local function OnWidthSet(self, width)
		local content = self.content
		local contentwidth = width - 20
		if contentwidth < 0 then
			contentwidth = 0
		end
		content:SetWidth(contentwidth)
		content.width = contentwidth
	end

	local function OnHeightSet(self, height)
		local content = self.content
		local contentheight = height - 20
		if contentheight < 0 then
			contentheight = 0
		end
		content:SetHeight(contentheight)
		content.height = contentheight
	end

	local function onSetSpellID(self, id)
		self.spellId = id
		self.frame:EnableMouse(true)
	end

	local function onSetItemID(self, id)
		self.itemId = id
		self.frame:EnableMouse(true)
	end

	local function onSetPlayer(self, plr)
		self.playerName = plr
		self.frame:EnableMouse(true)
	end

	local function onEnter(self)
		if (self.obj.spellId or self.obj.itemId) then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			if (self.obj.spellId) then
				GameTooltip:SetHyperlink(format("spell:%d", self.obj.spellId))

				local name, rank = GetSpellInfo(self.obj.spellId)
				if (rank and rank ~= "") then
					GameTooltipTextRight1:SetText(rank)
					GameTooltipTextRight1:SetFontObject(GameTooltipText)
					GameTooltipTextRight1:SetTextColor(0.5, 0.5, 0.5)
					GameTooltipTextRight1:Show()
					GameTooltip:Show()
				end
			elseif (self.obj.itemId) then
				GameTooltip:SetHyperlink(format("item:%d", self.obj.itemId))
			end
		end
	end

	local function onMouseUp(self, button)
		if (button == "RightButton" and self.obj.playerName) then
			self.obj:ShowOptions()
		elseif (button == "LeftButton" and IsModifiedClick("CHATLINK")) then
			self.obj:ChatLink()
		end
	end

	local function onLeave(self)
		if (not self:IsMouseOver()) then
			self.obj:HideOptions()
		end
		GameTooltip:Hide()
	end

	local function onButtonClicked(self)
		if (self.userdata.name) then
			LGT:RefreshTalentsByUnit(self.userdata.name)
			self.userdata.parent:HideOptions()
			module:RefreshTree()
		end
	end

	local function onShowOptions(self)
		if (self.playerName and LGT:GetUnitTalents(self.playerName)) then
			if (not self.button1) then
				local b = gui:Create("Button")
				self.button1 = b
				b.width = "fill"
				b:SetText("Reset Talents")
				b:SetCallback("OnClick", onButtonClicked, self)
				b.userdata.name = self.playerName
				b.userdata.parent = self

				self:AddChild(b)
				self:PerformLayout()
				module.detailsWidget:PerformLayout()
			end
		end
	end

	local function onHideOptions(self)
		if (self.button1) then
			self.button1:Release()
			for i,c in ipairs(self.children) do
				if (c == self.button1) then
					tremove(self.children, i)
					break
				end
			end
			self.button1 = nil
			self:PerformLayout()
			module.detailsWidget:PerformLayout()
		end
	end

	local function onChatLink(self)
		if (self.spellId) then
			local str = format("|cff71d5ff|Hspell:%d|h[%s]|h|r", self.spellId, (GetSpellInfo(self.spellId)))
			local activeWindow = ChatEdit_GetActiveWindow()
			if activeWindow then
				activeWindow:Insert(str)
			end
		end
	end
	
	local function Constructor()
		local frame = CreateFrame("Frame",nil,UIParent)
		local self = {}
		self.type = Type

		self.OnRelease = OnRelease
		self.OnAcquire = OnAcquire
		self.frame = frame
		self.LayoutFinished = LayoutFinished
		self.OnWidthSet = OnWidthSet
		self.OnHeightSet = OnHeightSet
		self.SetBorderColor = SetBorderColor
		self.SetColor = SetColor
		self.SetSpellID = onSetSpellID
		self.SetItemID = onSetItemID
		self.SetPlayer = onSetPlayer
		self.ShowOptions = onShowOptions
		self.HideOptions = onHideOptions
		self.ChatLink = onChatLink

		frame.obj = self
		frame:SetScript("OnEnter", onEnter)
		frame:SetScript("OnLeave", onLeave)
		frame:SetScript("OnMouseUp", onMouseUp)
		frame:EnableMouse(true)

		frame:SetHeight(100)
		frame:SetWidth(100)
		frame:SetFrameStrata("FULLSCREEN_DIALOG")

		local border = CreateFrame("Frame",nil,frame)
		self.border = border
		border:SetPoint("TOPLEFT",frame,"TOPLEFT",3,-3)
		border:SetPoint("BOTTOMRIGHT",frame,"BOTTOMRIGHT",-3,3)

		border:SetBackdrop(PaneBackdrop)

		--Container Support
		local content = CreateFrame("Frame",nil,border)
		self.content = content
		content.obj = self
		content:SetPoint("TOPLEFT",border,"TOPLEFT",10,-10)
		content:SetPoint("BOTTOMRIGHT",border,"BOTTOMRIGHT",-10,10)

		AceGUI:RegisterAsContainer(self)
		return self
	end

	AceGUI:RegisterWidgetType(Type,Constructor,Version)
end

do
	local AceGUI = gui
	local Type = "UtopiaLabel"
	local Version = 8

	local function OnAcquire(self)
		self:SetFont(GameFontHighlightSmall)
		self:SetText("")
		self:SetColor()
	end

	local function OnRelease(self)
		self.frame:ClearAllPoints()
		self.frame:Hide()
	end

	local function SetText(self, text)
		self.label:SetWidth(1000)
		self.label:SetText(text or "")
		self.label:SetWidth(self.label:GetStringWidth() + 10)
		self.frame:SetHeight(self.label:GetStringHeight() + 2)
		self.frame:SetWidth(self.label:GetStringWidth() + 10)
	end

	local function SetFont(self, fontObject)
		self.label:SetWidth(1000)
		self.label:SetFontObject(fontObject)
		self.label:SetWidth(self.label:GetStringWidth() + 10)
		self.frame:SetHeight(self.label:GetStringHeight() + 2)
		self.frame:SetWidth(self.label:GetStringWidth() + 10)
	end

	local function SetColor(self, r, g, b)
		if not (r and g and b) then
			r, g, b = 1, 1, 1
		end
		self.label:SetVertexColor(r, g, b)
	end

	local function Constructor()
		local frame = CreateFrame("Frame",nil,UIParent)
		local self = {}
		self.type = Type

		self.OnRelease = OnRelease
		self.OnAcquire = OnAcquire
		self.SetText = SetText
		self.SetFont = SetFont
		self.SetColor = SetColor
		self.frame = frame
		frame.obj = self

		frame:SetHeight(18)
		frame:SetWidth(200)
		local label = frame:CreateFontString(nil,"BACKGROUND","GameFontHighlightSmall")
		label:SetPoint("TOPLEFT",frame,"TOPLEFT",0,0)
		label:SetWidth(200)
		label:SetJustifyH("LEFT")
		label:SetJustifyV("TOP")
		self.label = label

		AceGUI:RegisterAsWidget(self)
		return self
	end

	AceGUI:RegisterWidgetType(Type,Constructor,Version)
end
