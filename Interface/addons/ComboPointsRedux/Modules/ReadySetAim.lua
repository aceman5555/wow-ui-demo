--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
ReadySetAim.lua - A module for tracking Ready Set Aim stacks
$Date: 2012-08-30 22:16:36 +0000 (Thu, 30 Aug 2012) $
$Revision: 267 $
Project Version: 2.2.19
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2012 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

if select(2, UnitClass("player")) ~= "HUNTER" then return end

local UnitBuff = UnitBuff

local cpr = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local modName = "Ready Set Aim"
local mod = cpr:NewModule(modName)
local buff = GetSpellInfo(82925)
local Fire = GetSpellInfo(82926)

function mod:OnInitialize()
	self.abbrev = "RSA"
	self.MAX_POINTS = 3
	self.displayName = buff
	self.events = { "UNIT_AURA" }
end

local oldCount = 0
function mod:UNIT_AURA(_, unit)
	if unit ~= "player" then return end
	
	--count will only go to 2
	local _, _, _, count = UnitBuff("player", buff)
	--at 3 the hunter gets the buff Fire! (82926)
	--if we find the Fire! buff manually push the count to 3
	local name = UnitBuff("player", Fire)
	if name then count = 3 end
	
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
