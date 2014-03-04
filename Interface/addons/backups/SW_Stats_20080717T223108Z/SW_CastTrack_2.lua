
-- holds info until know if a spell succeded
SW_PendingCast = {
	spellName = nil,
	spellCost = 0,
};

--local SW_ManaRegEx = string.gsub(MANA_COST, "%%d","(%%d+)");
--ENERGY_COST RAGE_COST FOCUS_COST
--2.1.3 other power types
local SW_PowerCost = {
	[0] = string.gsub(MANA_COST, "%%d","(%%d+)"),
	[1] = string.gsub(RAGE_COST, "%%d","(%%d+)"),
	[2] = string.gsub(FOCUS_COST, "%%d","(%%d+)"),
	[3] = string.gsub(ENERGY_COST, "%%d","(%%d+)"),
}
function SW_GetManaCost(str)
	if str == nil then return nil; end
	-- always get the power type (druids shape shift)
	local rx = SW_PowerCost[UnitPowerType("player")];
	if not rx then return end
	local _,_, spellCost = string.find(str, rx);
	if spellCost == nil then return nil; end
	return tonumber(spellCost);
end

function SW_AcceptPendingCast()
	if not SW_PendingCast.spellName then
		return;
	end
	--[[
	SW_printStr("--AddMC--");
	SW_printStr(SW_PendingCast.spellName);
	SW_printStr(SW_PendingCast.spellCost);
	--]]
	SW_DataCollection:addCT(SW_PendingCast.spellName, SW_PendingCast.spellCost);
	
	-- setting the spell name = nil on periodic spells like arcane missles is important
	-- they add multiple succedeed msgs
	SW_PendingCast.spellName = nil;
end

