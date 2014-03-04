local Utopia = LibStub("AceAddon-3.0"):GetAddon("Utopia", true)
if (not Utopia or Utopia.modules.Custom) then
	return
end
Utopia:UpdateVersion("$Revision: 211 $")

local wowVersion = tonumber((select(2,GetBuildInfo())))

local d = Utopia.debugprint
local module = Utopia:NewModule("Custom", "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceSerializer-3.0", "AceComm-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Utopia")
local LGT = LibStub("LibGroupTalents-1.0")
local db, dbc, udb
local new, del, copy, deepDel = Utopia.new, Utopia.del, Utopia.copy, Utopia.deepDel
local Gradient, UnitFullName, ClassColour, SmoothColour = Utopia.Gradient, Utopia.UnitFullName, Utopia.ClassColour, Utopia.SmoothColour
local rotate, propercase = Utopia.rotate, Utopia.propercase
local band = bit.band

module.options = {
	type = "group",
	name = L["Custom"],
	desc = L["Custom"],
	get = getFunc,
	set = getFunc,
	guiInline = true,
	order = 150,
	handler = module,
	args = {
		notifications = {
			type = "execute",
			name = L["Show Configuration"],
			desc = L["Show Configuration"],
			order = 10,
			func = "ToggleSpellOptions",
		},
	},
}
do
	-- customUnitAura
	local function customUnitAura(info)
		local spellName, _, tex = GetSpellInfo(info.id)
		local unit, func
		if (info.type == "buff") then
			unit, func = "player", UnitBuff
		else
			unit, func = "target", UnitDebuff
		end
		local superIndex

		local name, rank, texture, count, auraType, duration, endTime = func(unit, info.name, nil, "PLAYER")
		if (name == spellName and texture ~= tex) then
			-- Special handling for buffs of same name but mismatching textures (Sacred Shield buff and proc are different)
			name = nil
			for j = 1,100 do
				name, rank, texture, count, auraType, duration, endTime = func(unit, j, "PLAYER")
				if (name == spellName and texture == tex) then
					superIndex = j
					break
				end
			end
		end
		return name, rank, tex, count, auraType, duration, endTime, superIndex
	end

	-- customicon.OnEnter
	local function customiconOnEnter(self)
		Utopia:OnEnter(self:GetParent())
		local spell = module:GetSpells()[self:GetID()]
		if (spell) then
    		local name, rank, texture, count, auraType, duration, endTime, superIndex = customUnitAura(spell)
			GameTooltip:SetOwner(self, "LEFT")
    		if (name) then
				if (spell.type == "buff") then
					GameTooltip:SetUnitBuff("player", superIndex or spell.name)
				elseif (spell.type == "debuff") then
					GameTooltip:SetUnitDebuff("target", superIndex or spell.name)
				end
			else
				--local link = GetSpellLink((GetSpellInfo(spell.id)))		-- Get our highest rank if applicable
				--local rank
				--if (link) then
				--	local id = tonumber(strmatch(link, "Hspell:(%d+)"))
				--	if (id) then
				--		local name, r, tex = GetSpellInfo(id)
				--		rank = r
				--	end
				--end
				--link = link or "spell:"..spell.id
				--GameTooltip:SetHyperlink(link)
				--if (rank and rank ~= "") then
				--	GameTooltipTextRight1:SetText(rank)
				--	GameTooltipTextRight1:SetTextColor(0.5, 0.5, 0.5)
				--	GameTooltipTextRight1:Show()
				--end

				GameTooltip:SetHyperlink("spell:"..spell.id)
				GameTooltip:Show()
    		end
		end
	end

	-- customicon.OnClick
	local function customiconOnClick(self, button)
		if (button == "RightButton") then
			module:ToggleSpellOptions()
		end
	end

	-- customicon.Activate
	local function customiconActivate(self, debuffName, caster, duration, endTime)
		self.toggle = "on"
		local c = udb.colour.active
		self.tex:SetVertexColor(c.r, c.g, c.b, c.a)
		self:ShowCooldown(duration, endTime)
		if (GameTooltip:IsOwned(self)) then
			customiconOnEnter(self)
		end
	end

	-- custom.UpdateBuffs
	local function customUpdateBuffs(self)
		local s = module:GetSpells()

		self.progress = 0
		local iconIndex, keySort = 1, 1
		for i,info in ipairs(s) do
			if (info.type == "spacer") then
				keySort = keySort + 1
			else
				local name, rank, tex, count, auraType, duration, endTime = customUnitAura(info)

				local icon = self.icons[iconIndex]
				if (not icon) then
					icon = self:CreateAuraIcon()
					self.icons[iconIndex] = icon

					icon.OnEnter = customiconOnEnter

					icon:SetScript("OnEnter", customiconOnEnter)
					icon:SetScript("OnClick", customiconOnClick)
					icon.Activate = customiconActivate
					icon.UpdateTooltip = customiconOnEnter
				end
				iconIndex = iconIndex + 1

				icon:Show()
				icon:SetID(i)
				icon.tex:SetTexture(tex)
				icon.keySort = keySort

				if (name) then
					self.progress = self.progress + 1
					icon:Activate(name, "player", duration, endTime)
					if (count and count > 1) then
						if (not module.maxStacks) then
							module.maxStacks = {}
						end
						module.maxStacks[name] = max(module.maxStacks[name] or 0, count)
					end
					if (count and count > 1 and (module.maxStacks and module.maxStacks[name] or 0) > 1) then
						icon:ShowCount(100 * count / module.maxStacks[name])
					end
				else
					icon:Deactivate(true)
					icon:HideCooldown()
				end
			end
		end
		for i = iconIndex,#self.icons do
			self.icons[i]:Hide()
		end

		self.shown				= #s
		self.totalAvailable		= self.shown

		if (self.shown == 0) then
			self:Hide()
		else
			self:Show()

			self:UpdateProgressBar()
			self:DoBackdropColour()
		end
	end

	-- custom.SetTitle
	local function customSetTitle(self)
		if (self:IsShown() and self.backdrop and self.backdrop:IsShown()) then
			self.backdrop.title:SetFormattedText("%s %s", Utopia.label, L["Custom"])
		end
	end

	-- custom.UNIT_AURA
	local function customUNIT_AURA(self, unit)
		if (unit == "player" or unit == "target") then
			self.auraUpdateFrame:Show()		-- Throttle UNIT_AURA's to once per frame
		end
	end

	-- custom.SetMode
	local function customSetMode(self)
		-- Do nothing
	end

	-- CreateCustomFrame
	function module:CreateCustomFrame()
		local frame = Utopia:CreateUtopianFrame()
		Utopia.frames[3] = frame

		frame.UpdateBuffs			= customUpdateBuffs
		frame.SetTitle				= customSetTitle
		frame.SetMode				= customSetMode
		frame.UNIT_AURA				= customUNIT_AURA

		frame.shown					= #self:GetSpells()
		frame.fakeShown				= 0
		frame.extraVSize			= 0
		frame.totalAvailable		= frame.shown
		frame.totalAvailableNonTemporary = 0
		frame.progress				= 0

		frame:UpdateBuffs()
		frame:SetOrientation()
		frame:SetFrameSize()
		frame:Show()
	end

	-- ShowingFrames
	function module:ShowingFrames()
		local f = Utopia.frames[3]
		local spells = self:GetSpells()
		if (not f) then
			if (spells and next(spells)) then
				self:CreateCustomFrame()
			end
		else
			if (spells and next(spells)) then
				f:UpdateBuffs()
			else
				f:Hide()
			end
		end
	end
end

-- ToggleSpellOptions
function module:ToggleSpellOptions()
	LoadAddOn("Utopia_CustomConfig")

	if (not self.optionsFrame) then
		self:MakeSpellOptions()
	end
	if (self.optionsFrame:IsShown()) then
		self.optionsFrame:Hide()
	else
		self.optionsFrame:Show()
	end
end

-- LibGroupTalents_Update
function module:LibGroupTalents_Update(e, guid)
	if (guid == UnitGUID("player")) then
		if (self.needDefaults) then
			-- Talents weren't available at login, now they are and we flagged that we need to get the defaults
			self.needDefaults = nil
			local group = GetActiveTalentGroup() or 1
			dbc.spells[group] = nil
			self:GetSpells()
		end

		local frame = Utopia.frames and Utopia.frames[3]
		if (frame) then
			frame:UpdateBuffs()
			frame:SetOrientation()
			frame:SetFrameSize()
		end
	end
end

-- GetSpells
function module:GetSpells()
	local group = GetActiveTalentGroup() or 1
	local spells = dbc.spells
	if (not spells) then
		spells = new()
		dbc.spells = spells
	end

	local g = dbc.spells[group]
	if (not g) then
		if (not self.DefaultClassSpells) then
			LoadAddOn("Utopia_CustomConfig")
		end
		if (self.DefaultClassSpells) then
			g = self:DefaultClassSpells()
		else
			g = new()
		end
		dbc.spells[group] = g
	end
	return g
end

-- OnProfileChanged
function module:OnProfileChanged(event, database, newProfileKey)
	udb = Utopia.db.profile
	db = database.profile
	dbc = database.char
	self:Activate()
end

-- OnInitialize
function module:OnInitialize()
	local defaults = {
		char = {
			spells = {},
		}
	}

	if (IsAddOnLoaded("Utopia_Custom")) then
		self.db = LibStub("AceDB-3.0"):New("UtopiaCustomDB", defaults, "Default")
	else
		self.db = Utopia.db:RegisterNamespace("Custom", defaults)
	end
	udb = Utopia.db.profile
	db = self.db.profile
	dbc = self.db.char
end

-- OnEnable
function module:OnEnable()
	udb = Utopia.db.profile
	db = self.db.profile
	dbc = self.db.char

	Utopia.RegisterCallback(self, "ShowingFrames")
	LGT.RegisterCallback(self, "LibGroupTalents_Update")

	local spells = dbc.spells
	if (not spells[1] and not spells[2]) then
		-- Old format, delete it (this is for my benefit only)
		dbc.spells = {}
	end

	if (Utopia.frames) then
		if (not Utopia.frames[3]) then
			self:ShowingFrames()
		else
			Utopia.frames[3]:Show()
		end
	end
end

-- OnDisable
function module:OnDisable()
	if (Utopia.frames and Utopia.frames[3]) then
		Utopia.frames[3]:Hide()
	end

	Utopia.UnregisterCallback(self, "ShowingFrames")
	LGT.UnregisterCallback(self, "LibGroupTalents_Update")
end
