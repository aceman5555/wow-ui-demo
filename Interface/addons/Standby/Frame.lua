-- Author      : Git
-- Create Date : 6/15/2009 11:31:22 AM

local Stb_Version = "2.0.1";
local Stb_State = 0;
local Stb_Prefix = "EpgpStb"
local Stb_ChannelName = "ascension";
local Stb_CheckCount = 0;
local Stb_LastSpawnTime = 0;
local Stb_SpawnCount = 0;
local Stb_SpawnRealCount = 0;
local Stb_MaxCount = 15;
local Stb_YoggArray = {20, 20, 20, 15, 15, 15, 15, 15, 15, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10}

function Stb_OnLoad()
	frmQuestion:Hide();
	Stb_Print("Version " .. Stb_Version .. " now loaded");
	
	SLASH_STANDBY1 = "/standby";
	SlashCmdList["STANDBY"] = Stb_Command;
	
	this:RegisterEvent("CHAT_MSG_ADDON");
	this:RegisterEvent("CHAT_MSG_CHANNEL");
	this:RegisterEvent("CHAT_MSG_WHISPER");
	this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	this:RegisterEvent("CHAT_MSG_MONSTER_YELL");
	this:RegisterEvent("CHAT_MSG_MONSTER_WHISPER");
end

function Stb_Command(cmd)
	if (cmd == "admin start") then
		SendAddonMessage(Stb_Prefix, "START", "GUILD");
	elseif (cmd == "admin resume") then
		SendAddonMessage(Stb_Prefix, "RESUME", "GUILD");
	elseif (cmd == "admin check") then
		Stb_CheckCount = 1;
		Stb_Print("=== Checking Versions ===");
		Stb_CheckCount = 1;
		Stb_Print("1) " .. UnitName("player") .. " v" .. Stb_Version);
		SendAddonMessage(Stb_Prefix, "CHECK:" .. Stb_Version, "GUILD");
	elseif (cmd == "on") then
		Stb_YesClick();
	elseif (cmd == "off") then
		Stb_NoClick();
	else
		Stb_Print("=== HELP/Options ===");
		Stb_Print("/standby on");
		Stb_Print("/standby off");
	end
end

function Stb_OnEvent()
  if event == "CHAT_MSG_ADDON" then
    Stb_OnMsgAddon(arg1, arg2, arg4);
  
  elseif event == "CHAT_MSG_CHANNEL" then
    Stb_OnMsgChannel(arg9, arg8, arg1);
  
  elseif event == "CHAT_MSG_WHISPER" then
    Stb_OnMsgWhisper(arg1, arg2);
  
  elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
	Stb_OnCombatLog(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
  
  elseif event == "CHAT_MSG_MONSTER_YELL" then
	Stb_OnBossEmote(arg1, arg2);
	
	
	elseif event == "CHAT_MSG_MONSTER_WHISPER" then
	
		Stb_Print("boss whisper" .. " - " .. arg1 .. " - " .. arg2);
  end
  
end


function Stb_OnMsgAddon(prefix, message, sender)
  
  --Stb_Print(prefix .. " - " .. message);
  
  if (prefix ~= Stb_Prefix) or sender == UnitName("player") then
    return;
  end
  
  local notInRaid = (UnitInRaid("player") == nil);
  
  if message == "START" then
  
    if Stb_State == 0 and notInRaid then
      frmQuestion:Show();
    end
    
  elseif message == "RESUME" then
    
    if Stb_State > 0 and notInRaid then
      Stb_YesClick();
    end
  
  elseif (string.find(message, "CHECK:") ~= nil) then
	
	SendAddonMessage(Stb_Prefix, "CHECK_ADMIN " .. UnitName("player") .. " v" .. Stb_Version, "WHISPER", sender);
	if (string.gsub(message, "CHECK:", "") ~= Stb_Version) then
		SendChatMessage("<---- needs to download the latest version of EPGP Standby", "GUILD", nil);
	end

  elseif (string.find(message, "CHECK_ADMIN ") ~= nil) then
	Stb_CheckCount = Stb_CheckCount + 1;
	Stb_Print(Stb_CheckCount .. ") " .. string.gsub(message, "CHECK_ADMIN ", ""));
  
  end
end


function Stb_OnMsgChannel(name, number, message)
  name = string.lower(name);
  
  if (name ~= Stb_ChannelName) then
    return;
  end
  local pos = string.find(message, "epgp standby");
  
  if (pos == nil) then
    return;
  end
  
  if (Stb_State == 0 and UnitInRaid("player") == nil) then
    frmQuestion:Show();
  end
end

function Stb_OnMsgWhisper(message, name)
  --Stb_Pring((message == UnitName("player") .. " is now removed from the award list"));
  if (message == UnitName("player") .. " is now removed from the award list"
        and UnitIsAFK("player") == nil
        and Stb_State == 1) then
    SendChatMessage("epgp standby", "WHISPER", nil, name);
  end
  
end

function Stb_OnCombatLog(timestamp, event, sourceGuid, sourceName, sourceFlags, destGuid, destName, destFlags)
	if (sourceName == nil) then
		sourceName = "nil";
	end
	if (destName == nil) then
		destName = "nil";
	end
	--Stb_Print(timestamp .. " - " .. event .. " - " .. sourceGuid .. " - " .. sourceName .. " - " .. sourceFlags .. " - " .. destGuid .. " - " .. destName .. " - " .. destFlags);
	if (sourceName ~= "Ominous Cloud") then
		return;
	end;
	--Stb_Print(timestamp .. " - " .. event .. " - " .. sourceGuid .. " - " .. sourceName .. " - " .. sourceFlags .. " - " .. destGuid .. " - " .. destName .. " - " .. destFlags);
	
	if (Stb_SpawnCount == Stb_MaxCount) then
		return;
	end
	
	if (Stb_SpawnCount == 0) then
		Stb_LastSpawnTime = timestamp;
		Stb_SpawnCount = 1;
		Stb_SpawnRealCount = 1;
		SendChatMessage("Guardian #1", "RAID_WARNING");
		return;
	end
	
	
	
	local time = Stb_LastSpawnTime + Stb_YoggArray[Stb_SpawnCount] - 1;
	
	Stb_Print(time .. " = " .. (timestamp - Stb_LastSpawnTime));
	
	if (time < timestamp and time + 2.5 > timestamp) then
		Stb_LastSpawnTime = timestamp;
		Stb_SpawnCount = Stb_SpawnCount + 1;
		Stb_SpawnRealCount = Stb_SpawnRealCount + 1;
		local message = "Guardian #" .. Stb_SpawnCount;
		
		if (Stb_SpawnRealCount > Stb_SpawnCount) then
			message = message .. " (+" .. (Stb_SpawnRealCount - Stb_SpawnCount) .. " player spawned)";
		end
		Stb_Print(Stb_SpawnCount .. " - " .. Stb_SpawnRealCount .. " - " .. Stb_LastSpawnTime .. " - " .. Stb_YoggArray[Stb_SpawnCount]);
		SendChatMessage(message, "RAID_WARNING");
		return;
		
	else
		Stb_SpawnRealCount = Stb_SpawnRealCount + 1;
		SendChatMessage("PLAYER SPAWNED!!! (+" .. (Stb_SpawnRealCount - Stb_SpawnCount) .. ")", "RAID_WARNING");
		Stb_Print(Stb_SpawnCount .. " - " .. Stb_SpawnRealCount .. " - " .. Stb_LastSpawnTime .. " - " .. Stb_YoggArray[Stb_SpawnCount]);
	end
	
	
	
	
	
end

function Stb_OnBossEmote(message, boss)
	if (boss ~= "Sara") then
		return;
	end
	
	if (message == "The time to strike at the head of the beast will soon be upon us! Focus your anger and hatred on his minions!") then		
		Stb_LastSpawnTime = 0;
		Stb_SpawnCount = 0;
		Stb_SpawnRealCount = 0;
	
	
	elseif (message == "I am the lucid dream.") then
		Stb_YoggStop();	
	end
	
	
	--Stb_Print(time() .. " - " .. boss .. " - " .. message);
end

function Stb_YoggStop()
	Stb_SpawnCount = -1;
end

function Stb_YesClick()
	Stb_State = 1;
	SendChatMessage("epgp standby", "WHISPER", nil, "Git");
	SendChatMessage("epgp standby", "WHISPER", nil, "Ultán");
	SendChatMessage("epgp standby", "WHISPER", nil, "Shív");
	--SendChatMessage("epgp standby", "WHISPER", nil, "Evn");
	frmQuestion:Hide();
	Stb_Print("On standby!!!");
end

function Stb_NoClick()
	Stb_State = -1;
	frmQuestion:Hide();
	Stb_Print("Not on standby...");
end

function Stb_Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cffD16E22[EPGP Standby]:  |cffffffff" .. msg);
end