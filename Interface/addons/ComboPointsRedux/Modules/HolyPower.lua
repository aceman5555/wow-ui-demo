--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
HolyPower.lua - A module for tracking Holy Power
$Date: 2012-08-30 22:16:36 +0000 (Thu, 30 Aug 2012) $
$Revision: 267 $
Project Version: 2.2.19
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2012 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

if select(2, UnitClass("player")) ~= "PALADIN" then return end

local UnitPower = UnitPower
local SPELL_POWER_HOLY_POWER = SPELL_POWER_HOLY_POWER

local cpr = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local modName = "Holy Power"
local mod = cpr:NewModule(modName)

function mod:OnInitialize()
	self.MAX_POINTS = 5
	self.displayName = HOLY_POWER
	self.abbrev = "HP"
	self.events = { ["UNIT_POWER"] = "Update", ["UNIT_DISPLAYPOWER"] = "Update" }
end

local oldCount = 0
function mod:Update()
	local count = UnitPower("player", SPELL_POWER_HOLY_POWER)
	
	if count > 0 then
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
