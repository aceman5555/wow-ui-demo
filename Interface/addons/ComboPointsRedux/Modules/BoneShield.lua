--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
BoneShield.lua - A module for tracking Bone Shield stacks
$Date: 2013-11-27 14:36:16 +0000 (Wed, 27 Nov 2013) $
$Revision: 332 $
Project Version: 2.2.19
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2012 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

if select(2, UnitClass("player")) ~= "DEATHKNIGHT" then return end

local UnitBuff = UnitBuff

local cpr = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local modName = "Bone Shield"
local mod = cpr:NewModule(modName)
local buff = GetSpellInfo(49222)

function mod:OnInitialize()
	self.abbrev = "BS"
	self.MAX_POINTS = 6
	self.displayName = buff
	self.events = { "UNIT_AURA" }
end

local oldCount = 0
function mod:UNIT_AURA(_, unit)
	if unit ~= "player" then return end
	
	local _, _, _, count = UnitBuff("player", buff)
	local graphicsCount = count
	
	if count then
		if self.graphics then
			--manually force it to 6 for graphics only
			if count > 6 then graphicsCount = 6 end
			
			local r, g, b = cpr:GetColorByPoints(modName, graphicsCount)
			for i = graphicsCount, 1, -1 do
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
