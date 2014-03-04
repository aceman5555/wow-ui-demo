-------------------------------------------------------------------------------
--[[
Usage:

Author:	This mod was written by Whitetooth of Cenarius Server 2005/10/06

Plan:

Todo:

Bugs:
--]]
-------------------------------------------------------------------------------
-- CONSTANTS --
-- GLOBALS --
WT_DamageToRageTest = {};
WT_DamageToRageTest.CurrentRage = 0;
WT_DamageToRageTest.TotalGainedRage = 0;
WT_DamageToRageTest.DamageDone = 0;
WT_DamageToRageTest.DamageTaken = 0;
WT_DamageToRageTest.DamageDoneTotal = 0;
WT_DamageToRageTest.DamageTakenTotal = 0;
WT_DamageToRageTest.DamageTakenTable = {};
WT_DamageToRageTest.UnbridledWrath = false;

-- DEBUG --
function WT_DamageToRageTestFrame_OnLoad()
	-- Esc closes the window
	tinsert(UISpecialFrames, "WT_DamageToRageTestFrame");
	UIPanelWindows["WT_DamageToRageTestFrame"] = nil;
	-- Slash commands
	SlashCmdList["WT_DamageToRageTest"] = WT_DamageToRageTest_SlashHandler;
	SLASH_WT_DamageToRageTest1 = "/drt";
	-- Register events
	this:RegisterEvent("UNIT_RAGE");
	this:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS"); -- mob tests - damage taken
	this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS"); -- duel tests - damage taken
	this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES"); -- duel tests - damage taken
	this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS");
	this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE"); -- duel tests - damage taken
	
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF"); -- you gain 1 rage
	
	-- Saved variables
	--RegisterForSave("WT_DamageToRageTest_Table");
end

function WT_DamageToRageTestFrame_OnEvent(event)
	if event == "UNIT_RAGE" and arg1 == "player" then
		local difference = UnitMana("player") - WT_DamageToRageTest.CurrentRage;
		if difference ~= 0 then
			if difference > 0 then
				WT_DamageToRageTest.TotalGainedRage = WT_DamageToRageTest.TotalGainedRage + difference;
			end
			local output = "Diff: |cffff0000"..string.format("%2d", difference);
			if WT_DamageToRageTest.DamageDone ~= 0 then 
				output = output.."|cffffffff, D Done: |cffff0000"..string.format("%4d", WT_DamageToRageTest.DamageDone).."|cffffffff/"..WT_DamageToRageTest.DamageDoneTotal;
			else
				--output = output.."|cffffffff, D Done: "..string.format("%4d", WT_DamageToRageTest.DamageDone).."/"..WT_DamageToRageTest.DamageDoneTotal;
			end
			if WT_DamageToRageTest.DamageTaken ~= 0 then 
				output = output.."|cffffffff, Taken: |cffff0000"..string.format("%4d", WT_DamageToRageTest.DamageTaken);
				output = output.."|cffffffff - T:"..WT_DamageToRageTest.DamageTakenTotal;
				output = output.." - R: "..WT_DamageToRageTest.TotalGainedRage;
				output = output.." - T/R: "..string.format("%.2f", (WT_DamageToRageTest.DamageTakenTotal/WT_DamageToRageTest.TotalGainedRage));
				--output = output.." - Est.T: "..string.format("%.2f", ((WT_DamageToRageTest.TotalGainedRage) * (UnitLevel("target") - 8) * 1.8));
				--output = output.." - Est.R: "..string.format("%.2f", (WT_DamageToRageTest.DamageTakenTotal / ((UnitLevel("target") - 8) * 1.8)));
				output = output.." - ";
				for damage, times in WT_DamageToRageTest.DamageTakenTable do
					output = output.."["..damage.."]="..times..", ";
				end
			else
				output = output.."|cffffffff, D Taken: "..string.format("%4d", WT_DamageToRageTest.DamageTaken).."/"..WT_DamageToRageTest.DamageTakenTotal;
			end
			--[[
			if WT_DamageToRageTest.UnbridledWrath then 
				output = output.."|cffffffff, Unbridled Wrath";
			end
			--]]
			DEFAULT_CHAT_FRAME:AddMessage(output);
			WT_DamageToRageTest.CurrentRage = UnitMana("player");
			WT_DamageToRageTest.DamageDone = 0;
			WT_DamageToRageTest.DamageTaken = 0;
			WT_DamageToRageTest.UnbridledWrath = false;
			WT_DamageToRageTest.DamageTakenTable = {};
		end
	elseif event == "CHAT_MSG_COMBAT_SELF_HITS" then
		local _, _, damage = string.find(arg1, "^You %a+ .- for (%d+)%.");
		if damage then
			WT_DamageToRageTest.DamageDone = WT_DamageToRageTest.DamageDone + damage;
			WT_DamageToRageTest.DamageDoneTotal = WT_DamageToRageTest.DamageDoneTotal + damage;
		else
			DEFAULT_CHAT_FRAME:AddMessage(event..": "..arg1);
		end
	elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" or event == "CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS" then
		local _, _, damage = string.find(arg1, "^.- %a+ you for (%d+)%.");
		if damage then
			WT_DamageToRageTest.DamageTaken = WT_DamageToRageTest.DamageTaken + damage;
			WT_DamageToRageTest.DamageTakenTotal = WT_DamageToRageTest.DamageTakenTotal + damage;
			if not WT_DamageToRageTest.DamageTakenTable[damage] then
				WT_DamageToRageTest.DamageTakenTable[damage] = 0;
			end
			WT_DamageToRageTest.DamageTakenTable[damage] = WT_DamageToRageTest.DamageTakenTable[damage] + 1;
		else
			DEFAULT_CHAT_FRAME:AddMessage(event..": "..arg1);
		end
	elseif event == "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE" or event == "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE" then
		local _, _, damage = string.find(arg1, "^.-'s .- %a+ you for (%d+)");
		if damage then
			WT_DamageToRageTest.DamageTaken = WT_DamageToRageTest.DamageTaken + damage;
			WT_DamageToRageTest.DamageTakenTotal = WT_DamageToRageTest.DamageTakenTotal + damage;
			if not WT_DamageToRageTest.DamageTakenTable[damage] then
				WT_DamageToRageTest.DamageTakenTable[damage] = 0;
			end
			WT_DamageToRageTest.DamageTakenTable[damage] = WT_DamageToRageTest.DamageTakenTable[damage] + 1;
		else
			DEFAULT_CHAT_FRAME:AddMessage(event..": "..arg1);
		end
	elseif event == "CHAT_MSG_SPELL_SELF_BUFF" and arg1 == "You gain 1 Rage from Unbridled Wrath." then
		WT_DamageToRageTest.UnbridledWrath = true;
		WT_DamageToRageTest.CurrentRage = WT_DamageToRageTest.CurrentRage + 1;
	elseif event == "CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES" then
		if string.find(arg1, "^%a+ misses you%.") or string.find(arg1, "^%a+ attacks%. You dodge%.") then
			if not WT_DamageToRageTest.DamageTakenTable[0] then
				WT_DamageToRageTest.DamageTakenTable[0] = 0;
			end
			WT_DamageToRageTest.DamageTakenTable[0] = WT_DamageToRageTest.DamageTakenTable[0] + 1;
		else
			DEFAULT_CHAT_FRAME:AddMessage(event..": "..arg1);
		end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" then
	else
		DEFAULT_CHAT_FRAME:AddMessage(event..": "..arg1);
	end
end

function WT_DamageToRageTest_SlashHandler(msg)
	local index, value;
	if (not msg or msg == "") then
		if(WT_DamageToRageTestFrame:IsVisible()) then
			WT_DamageToRageTestFrame:Hide();
		else
			WT_DamageToRageTestFrame:Show();
		end
	else
		local command = strlower(msg);
		if (command == "clear") then
			WT_DamageToRageTest.DamageDoneTotal = 0;
			WT_DamageToRageTest.DamageTakenTotal = 0;
			WT_DamageToRageTest.TotalGainedRage = 0;
			DEFAULT_CHAT_FRAME:AddMessage("cleared");
		end
	end
end