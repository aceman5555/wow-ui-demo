--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
Arcane.lua - A module for tracking Arcane Charge debuff stacks
$Date: 2013-05-05 19:58:33 +0000 (Sun, 05 May 2013) $
$Revision: 317 $
Project Version: 2.2.19
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2012 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

if select(2, UnitClass("player")) ~= "MAGE" then return end

local UnitDebuff = UnitDebuff

local cpr = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local modName = "Arcane Blast"
local mod = cpr:NewModule(modName)
local buff = GetSpellInfo(36032)

function mod:OnInitialize()
	self.abbrev = "AC"
	self.MAX_POINTS = 4
	self.displayName = buff
	self.events = { "UNIT_AURA" }
end

local oldCount = 0
function mod:UNIT_AURA(_, unit)
	if unit ~= "player" then return end
	
	local _, _, _, count = UnitDebuff("player", buff)
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
