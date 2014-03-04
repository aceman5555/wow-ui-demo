local Utopia = LibStub("AceAddon-3.0"):GetAddon("Utopia", true)
if (not Utopia) then
	return
end
Utopia:UpdateVersion("$Revision: 166 $")

local new, del, copy, deepDel = Utopia.new, Utopia.del, Utopia.copy, Utopia.deepDel
local Gradient, UnitFullName, ClassColour, SmoothColour = Utopia.Gradient, Utopia.UnitFullName, Utopia.ClassColour, Utopia.SmoothColour
local rotate, propercase = Utopia.rotate, Utopia.propercase
local band = bit.band

-- Class buffs we want to enhance the tooltips for, data can be small for these
-- as they're all % increases based from talents that can be read from tooltips

-- [spellid] = "improved,improvedPercentagePerTalentPoint,maxTalentPoints,[replaceIndex],[maxStacks],[amount]"
local function classSpells(class)
	if (class == "MAGE") then
		return {
			[168] = {									-- Frost Armor
				improved = GetSpellInfo(11189),			-- Frost Warding
				improvedPercentagePerTalentPoint = 25,
				maxTalentPoints = 2,
				regex = "TALENT",
			},
			[7302] = {									-- Ice Armor
				improved = GetSpellInfo(11189),			-- Frost Warding
				improvedPercentagePerTalentPoint = 25,
				maxTalentPoints = 2,
				regex = "TALENT",
			},
			[1008] = {									-- Amplify Magic
				improved = GetSpellInfo(11247),			-- Magic Attunement
				improvedPercentagePerTalentPoint = 25,
				maxTalentPoints = 2,
				regex = "TALENT",
			},
			[604] = {									-- Dampen Magic
				improved = GetSpellInfo(11247),			-- Magic Attunement
				improvedPercentagePerTalentPoint = 25,
				maxTalentPoints = 2,
				regex = "TALENT",
			}
		}
	elseif (class == "DEATHKNIGHT") then
		return {
			[48263] = {									-- Frost Presence
				improved = GetSpellInfo(50384),			-- Improved Frost Presence
				improvedPercentagePerTalentPoint = 1,
				maxTalentPoints = 2,
				regex = "TALENT",
				regexIndex = 2,
			},
			[48266] = {									-- Blood Presence
				improved = GetSpellInfo(50365),			-- Improved Blood Presence
				improvedPercentagePerTalentPoint = 10,
				maxTalentPoints = 2,
				regex = "TALENT",
				regexIndex = 2,
			},
		}
	elseif (class == "PRIEST") then
		return {
			[17] = {									-- Power Word: Shield
				improved = GetSpellInfo(14748),			-- Improved Power Word: Shield
				improvedPercentagePerTalentPoint = 5,
				maxTalentPoints = 3,
				regex = "TALENT",
				regexIndex = 3,
			},
			[25431] = {									-- Inner Fire
				improved = GetSpellInfo(14747),			-- Improved Inner Fire
				improvedPercentagePerTalentPoint = 15,
				maxTalentPoints = 3,
				maxStacks = 20,
				regex = "TALENT",
			}
		}
	elseif (class == "SHAMAN") then
		return {
			[325] = {									-- Lightning Shield
				improved = GetSpellInfo(16261),			-- Improved Shields
				improvedPercentagePerTalentPoint = 5,
				glyphImproved = GetSpellInfo(55553),
				glpyhImprovedPercentage = 20,
				maxTalentPoints = 3,
				regex = "TALENT",
				regexIndex = 1,
				maxStacks = 3,
			},
			[52127] = {									-- Water Shield
				improved = GetSpellInfo(16261),			-- Improved Shields
				improvedPercentagePerTalentPoint = 5,
				maxTalentPoints = 3,
				regex = "TALENT",
				regexIndex = {[1] = true, [3] = true},	-- TODO localize?
				maxStacks = 3,
			},
			[49284] = {									-- Earth Shield
				improved = GetSpellInfo(16261),			-- Improved Shields
				improvedPercentagePerTalentPoint = 5,
				maxTalentPoints = 3,
				regex = "TALENT",
				regexIndex = 2,
				maxStacks = 6,
			},
		}
	elseif (class == "ROGUE") then
		return {
			[1784] = {
				improved = GetSpellInfo(14063),
				improvedAmountPerTalentPoint = -5,
				maxTalentPoints = 3,
				regex = "TALENT",
			},
			[51662] = {
				amount = 15,
				glyphImproved = 63249,
				glpyhImprovedAmount = 3,
				amountType = "%",
				regex = true,
			},
		}
	end
end

-- GetClassSpells
function Utopia:GetClassSpells()
	local _, class = UnitClass("player")
	if (class) then
		local spells = classSpells(class)
		if (spells) then
			self.classSpells = new()
			for id,info in pairs(spells) do
				local name = GetSpellInfo(id)
				if (name) then
					info.id = id
					info.name = name
					self.classSpells[name] = info
					spells[id] = nil
				end
			end
		end
		deepDel(spells)

		classSpells = nil
		Utopia.GetClassSpells = nil
		Utopia = nil
	end
end
