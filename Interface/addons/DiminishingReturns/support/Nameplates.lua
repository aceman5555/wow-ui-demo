--[[
Diminishing Returns - Attach diminishing return icons to unit frames.
Copyright 2009-2012 Adirelle (adirelle@gmail.com)
All rights reserved.
--]]

local addon = _G.DiminishingReturns
if not addon then return end

--<GLOBALS
local _G = _G
local hooksecurefunc = _G.hooksecurefunc
--GLOBALS>

local function SetupNameplates(LibNameplate)
	local db = addon.db:RegisterNamespace('Nameplates', {profile={
		enabled = true,
		iconSize = 16,
		direction = 'RIGHT',
		spacing = 2,
		anchorPoint = 'TOP',
		relPoint = 'BOTTOM',
		xOffset = 0,
		yOffset = 0,
	}})

	local function GetDatabase()
		return db.profile, db
	end

	local function GetNameplateGUID(self)
		return LibNameplate:GetGUID(self.anchor) or nil
	end

	local function OnNameplateEnable(self)
		LibNameplate.RegisterCallback(self, "LibNameplate_FoundGUID", "UpdateGUID")
		LibNameplate.RegisterCallback(self, "LibNameplate_RecycleNameplate", "UpdateGUID")
	end

	local function OnNameplateDisable(self)
		LibNameplate.UnregisterAllCallbacks(self)
	end

	addon:RegisterFrameConfig('Nameplates', GetDatabase)

	local seen = {}
	LibNameplate.RegisterCallback(addon, 'LibNameplate_NewNameplate', function(_ , nameplate)
		if seen[nameplate] or seen[nameplate:GetParent()] then return end
		seen[nameplate] = true
		addon:Debug("Detected new nameplate", nameplate:GetName() or "anonymous")
		return addon:SpawnGenericFrame(nameplate, GetDatabase, GetNameplateGUID, OnNameplateEnable, OnNameplateDisable, 'noCooldown', true)
	end)
end

local found = false
local function TestLibNameplate()
	if found then return end
	local lib, minor = LibStub('LibNameplate-1.0', true)
	if lib then
		found = true
		addon:Debug("Found LibNameplate-1.0", minor)
		addon:UnregisterEvent('ADDON_LOADED', TestLibNameplate)
		return SetupNameplates(lib)
	end
end

addon:RegisterEvent('ADDON_LOADED', TestLibNameplate)
hooksecurefunc(addon, "LoadAddonSupport", TestLibNameplate)


