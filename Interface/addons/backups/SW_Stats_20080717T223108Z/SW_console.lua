
function SW_SlashCommand(msg)
	if msg == nil then return; end
	
	local _,_, c, v = string.find(msg, "([^ ]+) (.+)");
	if c == nil then
		c = string.gsub(msg, " ", "");
	end
	if c == "" then
		SW_PrintHelp();
		return;
	end
	
	local cmd = nil;
	for k,v in pairs(SW_SlashCommands) do
		if v["c"] == c then
			cmd = v;
			break;
		end
	end
	if cmd == nil then
		SW_printStr(SW_CONSOLE_NOCMD .. c);
		SW_printStr(SW_CONSOLE_HELP ..SW_RootSlashes[1].." "..SW_SlashCommands["help"]["c"]);
		return;
	end
	--[[
	local unitName = UnitName("target");
	if not unitName then unitName = ERR_MEETING_STONE_INVALID_TARGET; end
	if v and unitName and string.find(v,"%%t") then
		v = string.gsub(v, "%%t", unitName);
	end
	--]]
	if cmd["aC"] > 0 then
		if v == nil or string.gsub(v, " ", "") == "" then
			SW_printStr(cmd["u"]);
			return;
		end
		cmd["f"](v);
	elseif cmd["aC"] < 0 then -- 2.0.beta.2 optional arguments
		if not v or string.gsub(v, " ", "") == "" then
			cmd["f"]();
		else
			cmd["f"](v);
		end
	else
		cmd["f"]();
	end
end
function SW_ResetAllWindows()
	SW_BarFrame1:ClearAllPoints();
	SW_BarFrame1:SetPoint("TOPLEFT","UIParent", "CENTER", -50, 50); 
	SW_BarFrame1:SetWidth(200);
	SW_BarFrame1:SetHeight(300);
	SW_BarFrame1:Show();
	SW_BarsLayout("SW_BarFrame1");
	
	SW_TextWindow:ClearAllPoints();
	SW_TextWindow:SetPoint("TOPLEFT", "UIParent", "CENTER");
	
	SW_GeneralSettings:ClearAllPoints();
	SW_GeneralSettings:SetPoint("TOPLEFT","UIParent", "CENTER", 20, -20);
	SW_GeneralSettings:Show();
	
	SW_BarReportFrame:ClearAllPoints();
	SW_BarReportFrame:SetPoint("TOPLEFT","UIParent", "CENTER", 40, -40);
	SW_BarReportFrame:Show();
	
	SW_BarSyncFrame:ClearAllPoints();
	SW_BarSyncFrame:SetPoint("TOPLEFT","UIParent", "CENTER", 60, -60);
	SW_BarSyncFrame:Show();
	
	SW_BarSettingsFrameV2:ClearAllPoints();
	SW_BarSettingsFrameV2:SetPoint("TOPLEFT","UIParent", "CENTER");
	
	SW_FrameConsole:ClearAllPoints();
	SW_FrameConsole:SetPoint("TOPLEFT","UIParent", "CENTER");
	
	SW_TimeLine:ClearAllPoints();
	SW_TimeLine:SetPoint("TOPLEFT","UIParent", "CENTER");
	
	SW_TargetSelector:ClearAllPoints();
	SW_TargetSelector:SetPoint("TOPLEFT","UIParent", "CENTER");
	
	if SW_UniLogFrame then
		SW_UniLogFrame:ClearAllPoints();
		SW_UniLogFrame:SetPoint("TOPLEFT","UIParent", "CENTER");
		SW_UniLogFrame:SetWidth(350);
		SW_UniLogFrame:SetHeight(100);
		SW_UniLogFrame:CallOnResize();
	end
end
function SW_ToggleConsole()
	local frame = getglobal("SW_FrameConsole")
	if(  frame:IsVisible() ) then
		frame:Hide();
	else
		frame:Show();
	end
end
function SW_ToggleBarFrame()
	local frame = getglobal("SW_BarFrame1")
	if(  frame:IsVisible() ) then
		SW_Settings["SHOWMAIN"] = nil;
		frame:Hide();
	else
		SW_Settings["SHOWMAIN"] = true;
		frame:Show();
	end
end
function SW_ToggleLocks()
	if SW_Settings["BFLocked"] then
		SW_LockFrames();
	else
		SW_LockFrames(true);
	end
end
function SW_ToggleMMIcon()
	if SW_Settings.HideMiniMap then
		SW_Settings.HideMiniMap = false;
		SW_IconFrame:Show();
	else
		SW_Settings.HideMiniMap = true;
		SW_IconFrame:Hide();
	end
end
function SW_ToggleResizer()
	if SW_Settings.SW_HideResizer then
		SW_Settings.SW_HideResizer = nil;
		SW_BarFrame1_Resizer:Show();
	else
		SW_Settings.SW_HideResizer = true;
		SW_BarFrame1_Resizer:Hide();
	end
end
function SW_ToggleNarrowData()
	SW_Settings.NarrowData = SW_Settings.NarrowData + 1;
	if SW_Settings.NarrowData > 3 then
		SW_Settings.NarrowData = 1;
	end
	if SW_Settings.NarrowData == 1 then
		DEFAULT_CHAT_FRAME:AddMessage(SW_ND_AUTO);
		if IsInInstance() then
			SW_ND_CHECK = false;
		else
			SW_ND_CHECK = true;
		end
	elseif SW_Settings.NarrowData == 2 then
		DEFAULT_CHAT_FRAME:AddMessage(SW_ND_ON);
		SW_ND_CHECK = true;
	else
		DEFAULT_CHAT_FRAME:AddMessage(SW_ND_OFF);
		SW_ND_CHECK = false;
	end
end
function SW_ToggleGeneralSettings()
	local frame = getglobal("SW_GeneralSettings")
	if(  frame:IsVisible() ) then
		frame:Hide();
	else
		frame:Show();
	end
end
function SW_LoadProfiles()
	if not IsAddOnLoaded("SW_Stats_Profiles") then
		LoadAddOn("SW_Stats_Profiles");
	end
end
function SW_DumpVar(cmdString)
	local varName = string.gsub(cmdString, " ", "")
	local g = getfenv();
	
	if g[varName] == nil then
		SW_printStr(varName..SW_CONSOLE_NIL_TRAILER);
		return;
	else
		if type(g[varName]) == "table" then
			SW_DumpTable(g[varName]);
		else
			SW_printStr(g[varName]);
		end
	end
	
end
function SW_ResetInfo(newName)
	SW_CombatTime = 0;
	SW_DPS_Dmg =0;
	
	SW_DataCollection:createNewSegment(newName);
end
function SW_ShowNukeDialog()
	StaticPopup_Show("SW_TL_Nuke");
end
function SW_NukeDataCollection()
	SW_StrTable = SW_C_StringTable:new(); 
	SW_DataCollection = SW_C_DataCollection:new();
	SW_DataCollection.meta:updateGroupRaid();
	SW_DataCollection:raiseMarkerChanged();
	SW_DataCollection:checkGroup();
	collectgarbage();
end
function SW_PostCheck(target)
	
	if SW_RPOST then
		return true;
	end
	if UnitInRaid("player") then
		if IsRaidLeader() or IsRaidOfficer() then
			return true;
		else
			if target == "RAID" then
				return false;
			else
				return true;
			end
		end
	--[[ hmm i think this is to restrictive
	elseif UnitInParty("player") then
		if IsPartyLeader() then
			return true;
		else
			if target == "PARTY" then
				return false;
			else
				return true;
			end
		end
	--]]
	else
		return true;
	end
end
function SW_GetResetName(newName)
	if not newName then
		return SW_DS_RESET;
	end
	local doNum = false;
	local didNameReplace = false;
	if string.find(newName,"#") then
		doNum = true;
	end
	local unitName = UnitName("target");
	if not unitName then unitName = ERR_MEETING_STONE_INVALID_TARGET; end
	--unitName = "High King Maulgar";
	
	if unitName and string.find(newName,"%%t") then
		newName = string.gsub(newName, "%%t", unitName);
		didNameReplace = true;
	end
	if not doNum then
		return newName;
	end
	if not didNameReplace then
		unitName = string.gsub(newName, "#", "");
		unitName = (string.gsub(unitName, "^%s*(.-)%s*$", "%1"));
	end
	
	local num;
	local newNum = 0;
	for k,v in pairs(SW_DataCollection.data) do
		_, _, num = string.find(v.Name,"(%d+)");
		if num and string.find(v.Name,unitName) then
			if tonumber(num) > newNum then 
				newNum = tonumber(num);
			end
		end
	end
	newName = string.gsub(newName, "#", newNum + 1);
	return newName;
end
function SW_InitResetVote(newName)
	if SW_SYNC_DO and SW_SYNC_TO_USE then
		newName = SW_GetResetName(newName);
		SW_ResetVote:send(newName);
	end
end
function SW_ResetCheck(newName)
	newName = SW_GetResetName(newName);
	
	if SW_SYNC_DO and SW_SYNC_TO_USE then
		--here we are in a active syncchan 
		if UnitInRaid("player") then
			if IsRaidLeader() or IsRaidOfficer() then
				StaticPopupDialogs.SW_ResetSync.SW_SegmentName = newName;
				StaticPopup_Show("SW_ResetSync");
			else
				StaticPopup_Show("SW_ResetFailInfo");
			end
		else
			if IsPartyLeader() then
				StaticPopupDialogs.SW_ResetSync.SW_SegmentName = newName;
				StaticPopup_Show("SW_ResetSync");
			else
				StaticPopup_Show("SW_ResetFailInfo");
			end
		end
	else
		StaticPopupDialogs.SW_Reset.SW_SegmentName = newName;
		StaticPopup_Show("SW_Reset");
		return;
	end
end
function SW_DoVersionCheck()
	if SW_SYNC_TO_USE then
		SendAddonMessage(SW_CHAN_VC, "VC", SW_SYNC_TO_USE);
	end
end
function SW_PrintHelp()
	local con = getglobal("SW_FrameConsole");
	
	if con ~= nil and con:IsVisible() then
		con = getglobal("SW_FrameConsole_Text1_MsgFrame");
	else
		con = DEFAULT_CHAT_FRAME;
	end
	if con ~= nil then
		for k,v in pairs(SW_SlashCommands) do	
			if v["c"] ~= nil then
				if v["si"] ==nil then
					con:AddMessage("|cc0c0ff00"..v["c"]..":");
				else
					con:AddMessage("|cc0c0ff00"..v["c"]..":"..NORMAL_FONT_COLOR_CODE.."  "..v["si"]);
				end
				if v["u"] ~= nil then
					con:AddMessage(NORMAL_FONT_COLOR_CODE.."     "..v["u"]);
				end
			end
		end
	end
end

function SW_SetOptLayoutMode(var)

	if var == "RIGHT" then
		SW_Settings.OptLayoutMode = "RIGHT";
	else
		SW_Settings.OptLayoutMode = "BOTTOM";
	end
	-- hmm look into this we need 2 refreshes but works for now
	-- must be something that the correct values are set with the next OnUpdate()
	SW_OptUpdateLayout(SW_BarFrame1_Selector_Opt1);
	SW_RedoOptLayout = true;
end