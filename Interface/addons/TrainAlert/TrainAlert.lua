TrainAlert = LibStub("AceAddon-3.0"):NewAddon("TrainAlert", "AceTimer-3.0")

function TrainAlertFrame_OnLoad()

	if TAConfig == "" or TAConfig == nil then
		TAConfig = {
			["ChatMsg"] = 'OFF',
			["Sound"] = 'OFF',
			["Debug"] = 'OFF',
			["KillSound"] = 'OFF',
			["Timer"] = 10,
			["TurnOn"] = 'OFF'
		}
	end

	TrainAlertFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r v" .. GetAddOnMetadata("TrainAlert", "Version") .. " loaded. Use |cFF00FFFF/ta|r for a list of options.")
	-- already hidden by default, but just in case...
	TrainAlertFrame:Hide();

SlashCmdList["TACONFIG"] = taconfig;
	SLASH_TACONFIG1 = "/ta"
	SLASH_TACONFIG2 = "/trainalert"

SlashCmdList["KILLTIME"] = killtime;
	SLASH_KILLTIME1 = "/tak"

end

function TrainAlertFrame_OnEvent(self, event, ...)

	local timestamp, ttype, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellid, spellname, spellschool, b_or_d = select(1, ...);

	local lang = GetDefaultLanguage("player")
	local myName = UnitName("player")
	
	-- Begin Debug
	if destName == myName and TAConfig.Debug == 'ON' then
		DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r |cFF00FF00[Debug]|r " .. sourceName .. " cast " .. spellname .. " (ID Number: " .. spellid .. " - " .. ttype .. ") on " .. destName .. ".")
	end

	if destName == nil and TAConfig.Debug == 'ON' then
		DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r |cFF00FF00[Debug]|r |cFFFF0000[Error]|r Something went wrong. Chances are someone cast a spell which didn't record a target name.")
	end
	-- End Debug

	if (ttype == "SPELL_CAST_START") and (spellid == 61781) then
		local localizedClass, englishClass = UnitClass("player")

		if englishClass ~= "ROGUE" then return else
			DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r " .. sourceName .. " is preparing a Turkey Shooter!")
		end
	end

	if (ttype == "SPELL_CAST_FAILED") and (spellid == 61781) then
		local localizedClass, englishClass = UnitClass("player")

		if englishClass ~= "ROGUE" then return else
			DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r " .. sourceName .. " stopped preparing a Turkey Shooter.")
		end
	end

	if (ttype == "SPELL_AURA_APPLIED") and (spellid == 61781) then
		local localizedClass, englishClass = UnitClass("player")

		if englishClass ~= "ROGUE" then return else
			DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r " .. sourceName .. " used a Turkey Shooter!")
		end
	end

	if (ttype == "SPELL_AURA_APPLIED") and (spellid == 51508) or (spellid == 51510) and destName == myName then
		DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r " .. sourceName .. " just threw a Party G.R.E.N.A.D.E. at you.")
	end

	if (ttype == "SPELL_CAST_SUCCESS") and (spellid == 18400) then

		if sourceName ~= myName then
			DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r " .. sourceName .. " has started playing their Piccolo of the Flaming Fire.")
		end

	end

	if (ttype == "SPELL_CAST_SUCCESS") and (spellid == 61819) then

		if destName == myName then
			DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r You were just " .. GetSpellLink(61819) .. " by " .. sourceName .. ".")
		end

	end

	if (ttype == "SPELL_CAST_SUCCESS") and (spellid == 44212) then
		
		if destName == myName then
			DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r " .. sourceName .. " used a Weighted Jack O' Lantern on you.")
		end

	end

	if (ttype == "SPELL_CAST_START") and (spellid == 61031) then

		if sourceName ~= myName then
			DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r " .. sourceName .. " is preparing a Toy Train Set!")
		end

	end

	if (ttype == "SPELL_CAST_FAILED") and (spellid == 61031) then

		if sourceName ~= myName then
			DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r " .. sourceName .. " stopped preparing a Toy Train Set.")
		end

	end
	
	if (ttype == "SPELL_CREATE") and (spellid == 61031) then

		if sourceName ~= myName then
			DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r " .. sourceName .. " put down a Toy Train Set!")

			if TAConfig.KillSound == 'ON' then
				if GetCVar("Sound_EnableSFX") ~= "0" then
					SetCVar("Sound_EnableSFX", "0") 
					DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r Sound effects have been disabled for |cFF00FFFF" .. TAConfig.Timer .. "|r seconds.")
					TrainAlert:ScheduleTimer("SoundOff", TAConfig.Timer)
				end
			end
			
			if TAConfig.Sound == 'ON' and TAConfig.KillSound == 'OFF' then
				PlaySoundFile("Sound\\Spells\\PVPFlagTaken.ogg")
			end

			if TAConfig.ChatMsg == 'ON' then

				if UnitIsAFK("player") == 1 then
					return
				elseif UnitIsAFK("player") == nil then
				SendChatMessage("[TrainAlert] " .. sourceName .. " has put down a Toy Train Set!","SAY",lang)
				end

			end
		end
	end	
end

function taconfig(msg, editbox)

	if msg == "sound" then
		if TAConfig.Sound == 'OFF' then
			TAConfig.Sound = 'ON'
	DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r The warning sound has been |cFF00FF00enabled|r.")
		elseif TAConfig.Sound == 'ON' then
			TAConfig.Sound = 'OFF'
	DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r The warning sound has been |cFFFF0000disabled|r.")
		end
	elseif msg == "chat" then
		if TAConfig.ChatMsg == 'OFF' then
			TAConfig.ChatMsg = 'ON'
	DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r The chat message has been |cFF00FF00enabled|r.")
		elseif TAConfig.ChatMsg == 'ON' then
			TAConfig.ChatMsg = 'OFF'
	DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r The chat message has been |cFFFF0000disabled|r.")
		end
	elseif msg == "debug" then
		if TAConfig.Debug == 'OFF' then
			TAConfig.Debug = 'ON'
	DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r Debug Mode has been |cFF00FF00enabled|r. If you find a spell that TrainAlert doesn't warn you about, please submit this information to me via a Curse PM. Thanks!")
		elseif TAConfig.Debug == 'ON' then
			TAConfig.Debug = 'OFF'
			DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r Debug Mode has been |cFFFF0000disabled|r.")
		end
	elseif msg == "kill" then
		if TAConfig.KillSound == 'OFF' then
			TAConfig.KillSound = 'ON'
	DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r In-game sound effects |cFF00FF00will|r be disabled for " .. TAConfig.Timer .. " seconds when a Toy Train Set is placed.")
		elseif TAConfig.KillSound == 'ON' then
			TAConfig.KillSound = 'OFF'
			DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r In-game sound effects |cFFFF0000will not|r be disabled when a Toy Train Set is placed.")
		end
	elseif msg == "help" then
		local GUI = LibStub("AceGUI-3.0")
		local container = GUI:Create("Frame")
		container:SetTitle("TrainAlert Help")
		container:SetStatusText("Version " ..GetAddOnMetadata("TrainAlert", "Version"))
		local txt,sf
		local example_txt = ("|cFF990099TrainAlert - Command List|r\n\n|cFF00FFFF/ta sound|r OR |cFF00FFFF/trainalert sound|r - Turns the sound alert for Toy Train Sets on or off.\n|cFF00FFFF/ta chat|r OR |cFF00FFFF/trainalert chat|r - Turns the chat alert for Toy Train Sets on or off.\n|cFF00FFFF/ta debug|r OR |cFF00FFFF/trainalert debug|r - Enter Debug Mode to find new spells and items for me to add.\n|cFF00FFFF/ta kill|r OR |cFF00FFFF/trainalert kill|r - Toggles disabling of sound effects when a Toy Train Set is placed.\n|cFF00FFFF/tak <number>|r - Tells TrainAlert how long to wait before re-enabling sound effects.\n\n|cFF990099TrainAlert - Current Settings|r\n\n|cFF00FFFFChat Message:|r " .. TAConfig.ChatMsg .. "\n|cFF00FFFFAlert Sound:|r " .. TAConfig.Sound .. "\n|cFF00FFFFDebug Mode:|r " .. TAConfig.Debug .. "\n|cFF00FFFFDisable Sound Effects:|r " .. TAConfig.KillSound .. "\n|cFF00FFFFSFX Timer:|r " .. TAConfig.Timer .. " seconds"):rep(1)

		container:SetLayout("Fill")

		txt = GUI:Create("Label")
		txt:SetFullWidth(true)
		txt:SetText(example_txt)

		sf = GUI:Create("ScrollFrame")
		sf:SetLayout("Flow")
		sf:AddChild(txt)

		container:AddChild(sf)

	else
DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r |cFFFF0000[Error]|r Please use one of the following arguments:")DEFAULT_CHAT_FRAME:AddMessage("sound, chat, debug, kill, help")
	end

end

function killtime(msg, editbox)
	local count = tonumber(msg)
	TAConfig.Timer = count
	DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r Sound effects will be disabled for |cFF00FFFF" .. count .. "|r seconds after a Toy Train Set is placed.")
end

function TrainAlert:SoundOff()
	if TAConfig.KillSound == 'ON' then
		SetCVar("Sound_EnableSFX", "1") 
		DEFAULT_CHAT_FRAME:AddMessage("|cFF990099[TrainAlert]|r Sound effects have been re-enabled.")
	else
		return
	end
end