--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
Lacerate.lua - A module for tracking Lacerate stacks
$Date: 2012-10-04 14:06:17 +0000 (Thu, 04 Oct 2012) $
$Revision: 295 $
Project Version: 2.2.19
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2012 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

if select(2, UnitClass("player")) ~= "DRUID" then return end

local UnitAura = UnitAura

local cpr = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local modName = "Lacerate"
local mod = cpr:NewModule(modName)
local buff = GetSpellInfo(33745)

function mod:OnInitialize()
	self.abbrev = "L"
	self.MAX_POINTS = 3
	self.displayName = buff
	self.events = { "UNIT_AURA", "PLAYER_TARGET_CHANGED" }
end

function mod:OnModuleEnable()
	self:RegisterEvent("UPDATE_SHAPESHIFT_FORM", "OnShapeshift")
end

local oldCount = 0
function mod:UNIT_AURA(_, unit)
	if unit ~= "target" then return end
	
	local _, _, _, count = UnitAura("target", buff, nil, "PLAYER|HARMFUL")
	if count then
		if self.graphics then
			local r, g, b = cpr:GetColorByPoints(modName, count)
			for i = count, 1, -1 do
				self.graphics.points[i].icon:SetVertexColor(r, g, b)
				self.graphics.points[i]:Show()
			end
			for j = self.MAX_POINTS, count+1, -1 do
				self.graphics.points[j]:Hide()
			end
		end
		if self.text then self.text:SetNumPoints(count) end
		
		--should prevent spamming issues when UNIT_AURA fires and
		--the aura we care about hasn't changed
		if oldCount ~= count then
			oldCount = count
			cpr:DoFlash(modName, count)
		end
	else
		if self.graphics then
			for i = 1, self.MAX_POINTS do
				self.graphics.points[i]:Hide()
			end
		end
		if self.text then self.text:SetNumPoints("") end
		
		oldCount = 0
	end
end

function mod:PLAYER_TARGET_CHANGED()
	self:UNIT_AURA(nil, "target")
end

function mod:OnShapeshift()
	local form = GetShapeshiftForm(true)
	--[[
	forms:
	0 - caster
	1 - bear
	2 - aquatic
	3 - cat
	4 - travel
	5 - Moonkin form (flight if no moonkin)
	6 - Flight form
	]]
	
	if cpr.db.profile.modules[modName].hideOutBear then
		--if we only show lacerate stacks in bear form...
		if form == 1 then
			if self.text then self.text:Show() end
			if self.graphics then self.graphics:Show() end
		else
			if self.text then self.text:Hide() end
			if self.graphics then self.graphics:Hide() end
		end
	end
end
