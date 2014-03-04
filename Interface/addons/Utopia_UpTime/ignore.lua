local Utopia = LibStub("AceAddon-3.0"):GetAddon("Utopia", true)
if (not Utopia) then
	return
end
Utopia:UpdateVersion("$Revision: 181 $")
local L = LibStub("AceLocale-3.0"):GetLocale("Utopia")
local d = Utopia.debugprint
local module = Utopia.modules.UpTime
local new, del, copy, deepDel = Utopia.new, Utopia.del, Utopia.copy, Utopia.deepDel

local lzf = LibStub("LibZekFrames-1.0")

StaticPopupDialogs["UTOPIA_PURGE"] = {
	text = L["Really purge all existing fights of all currently ignored mobs? This action is irreversable!"],
	button1 = YES,
	button2 = NO,
	OnAccept = function(self) module.ignoreFrame:OnPurgeConfirmed() end,
	showAlert = 1,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1,
}

function module:ToggleIgnoreFrame(fight)
	if (self.CreateIgnoreFrame) then
		self:CreateIgnoreFrame()
	end
	local f = self.ignoreFrame
	if (f:IsShown() and f.fight == fight) then
		f:Hide()
	else
		f:Hide()
		f.fight = fight
		f:Show()
	end
end

do
	-- frame.OnShow
	local function frameOnShow(self)
		self:PopulateAvailable()
		self:PopulateIgnored()
		self:ValidateButtons()
	end

	-- frame.OnHide
	local function frameOnHide(self)
		self.fight = nil
	end

	local function sortItems(a, b)
		return a[1] < b[1]
	end

	-- PopulateAvailable
	local function framePopulateAvailable(self)
		if (self.fight) then
			local temp = new()
			for mobid, mobname in pairs(self.fight.mobs) do
				if (not module.db.profile.ignoreMobIDs[mobid] and not module.ignoreMobIDs[mobid]) then
					tinsert(temp, new(mobname, mobid))
				end
			end
			sort(temp, sortItems)
			self.lista:SetItems(temp)
			return
		end
		self.lista:SetItems()
	end

	-- PopulateIgnored
	local function framePopulateIgnored(self)
		local items = new()
		for id,name in pairs(module.db.profile.ignoreMobIDs) do
			tinsert(items, new(name, id))
		end
		sort(items, sortItems)
		self.listi:SetItems(items)
	end

	-- frame.ignore.OnClick
	local function buttonIgnore(self)
		local sel = new(self.lista:GetSelected())

		for i,key in ipairs(sel) do
			local mobname = self.fight.mobs[key]
			module.db.profile.ignoreMobIDs[key] = mobname
		end
		del(sel)

		self:PopulateAvailable()
		self:PopulateIgnored()
	end

	-- frame.remove.OnClick
	local function buttonRemove(self)
		local sel = new(self.listi:GetSelected())

		for i,key in ipairs(sel) do
			module.db.profile.ignoreMobIDs[key] = nil
		end
		del(sel)

		self:PopulateAvailable()
		self:PopulateIgnored()
	end

	-- frame.PurgeSection
	local function framePurgeSection(self, fight, mobid, section)
		local total = 0
		if (fight[section]) then
			for mobkey,data in pairs(fight[section]) do
				local id,index = module:MobIDFromKey(mobkey)
				if (id == mobid) then
					fight[section][mobkey] = nil
					total = total + 1
				end
			end
			if (not next(fight[section])) then
				fight[section] = del(fight[section])
			end
		end
		return total
	end

	-- frame.PurgeMobFromFight
	local function framePurgeMobFromFight(self, fight, mobid)
		local total = self:PurgeSection(fight, mobid, "data")
		total = total + self:PurgeSection(fight, mobid, "dps")
		total = total + self:PurgeSection(fight, mobid, "bossdps")
		total = total + self:PurgeSection(fight, mobid, "playerdps")
		total = total + self:PurgeSection(fight, mobid, "dpsp")
		total = total + self:PurgeSection(fight, mobid, "dpsm")
		fight.mobs[mobid] = nil
		return total
	end

	-- frame.Purge
	local function framePurge(self)
		local db = module.db.profile

		local purgeMobs, purgeTotal, purgeFight = 0, 0, 0
		for i,fight in ipairs(db.history) do
			local p
			for mobid,mobname in pairs(fight.mobs) do
				if (module.ignoreMobIDs[mobid] or db.ignoreMobIDs[mobid]) then
					purgeTotal = purgeTotal + self:PurgeMobFromFight(fight, mobid)
					purgeMobs = purgeMobs + 1
					p = true
				end
			end
			if (p) then
				purgeFight = purgeFight + 1
				Utopia.callbacks:Fire("Utopia_FightChanged", fight.combatStart)
			end
		end
		return purgeFight, purgeMobs, purgeTotal
	end

	-- frame.purge.OnClick
	local function buttonPurge(self)
		StaticPopup_Show("UTOPIA_PURGE")
	end

	-- frame.OnPurgeConfirmed
	local function frameOnPurgeConfirmed(self)
		local purgeFight, purgeMobs, purgeTotal = self:Purge()
		module:Print(format(L["Purged from %d |4fight:fights; totalling %d |4mob:mobs;, and a total of %d data |4element:elements;"], purgeFight, purgeMobs, purgeTotal))
		self:PopulateAvailable()
	end

	-- frame.ValidateButtons
	local function frameValidateButtons(self)
		local sel = self.lista:GetSelected()
		if (sel) then
			self.ignore:Enable()
		else
			self.ignore:Disable()
		end

		sel = self.listi:GetSelected()
		if (sel) then
			self.remove:Enable()
		else
			self.remove:Disable()
		end
	end

	-- frame.list*.OnSelectMultiple
	local function framelistOnSelectMultiple(self)
		self:GetParent():ValidateButtons()
	end

	-- CreateIgnoreFrame
	function module:CreateIgnoreFrame()
		local frame = CreateFrame("Frame", "UtopiaUpTimeIgnoreFrame", UIParent)
		frame:Hide()
		frame:SetScale(0.8)
		frame:SetWidth(512)
		frame:SetHeight(400)
		lzf:ApplyBackground(frame, "Interface\\AddOns\\Utopia\\Textures\\UtopiaCornerIcon")
		lzf:MovableFrame(frame)
		frame.OnPositionChanged = function(self) Utopia:SavePosition(self) end
		Utopia:RestorePosition(frame)

		frame:SetScript("OnShow", frameOnShow)
		frame:SetScript("OnHide", frameOnHide)

		frame.title:SetText(L["Ignore Options"])

		frame.lista = lzf:CreateListFrame(frame, true, true)
		frame.lista:SetPoint("TOPLEFT", 24, -82)
		frame.lista:SetPoint("BOTTOMRIGHT", frame, "BOTTOM", 0, 42)
		frame.lista.OnSelectMultiple = framelistOnSelectMultiple
		frame.bar = lzf:CreateVerticalBar(frame.lista, "RIGHT")

		frame.labela = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		frame.labela:SetPoint("BOTTOM", frame.lista, "TOP", 0, 10)
		frame.labela:SetText(L["Selected Fight"])

		frame.ignore = lzf:Button(frame.statusbar, frame, IGNORE, buttonIgnore, "BOTTOMLEFT")
		frame.remove = lzf:Button(frame.statusbar, frame, REMOVE, buttonRemove, "BOTTOMRIGHT")
		frame.purge = lzf:Button(frame.statusbar, frame, L["Purge"], buttonPurge, "BOTTOM")
		frame.ignore.tooltip = L["Ignore the selected mobs"]
		frame.remove.tooltip = L["Remove the selected mobs from the ignored list"]
		frame.purge.tooltip = L["Purge all existing fights of the currently defined ignored mobs"]

		frame.listi = lzf:CreateListFrame(frame, true, true)
		frame.listi:SetPoint("TOPLEFT", frame.lista.verticalBar, "TOPRIGHT", 0, 0)
		frame.listi:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -40, 42)
		frame.listi.OnSelectMultiple = framelistOnSelectMultiple

		frame.labeli = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		frame.labeli:SetPoint("BOTTOM", frame.listi, "TOP", 0, 10)
		frame.labeli:SetText(L["Currently Ignored"])

		frame.PopulateAvailable	= framePopulateAvailable
		frame.PopulateIgnored	= framePopulateIgnored
		frame.Purge				= framePurge
		frame.PurgeMobFromFight	= framePurgeMobFromFight
		frame.PurgeSection		= framePurgeSection
		frame.OnPurgeConfirmed	= frameOnPurgeConfirmed
		frame.ValidateButtons	= frameValidateButtons

		self.ignoreFrame = frame
		self.CreateIgnoreFrame = nil
		return frame
	end
end
