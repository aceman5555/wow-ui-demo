-- SW_Stats_Profiles.lua
-- A way do save /load settings from you different toons

SW_P_Saved = {};

function SW_P_SlashHandler(msg)
	if msg == nil then return; end
	
	local _,_, c, v = string.find(msg, "([^ ]+) (.+)");
	if c == nil then
		c = string.gsub(msg, " ", "");
	end
	
	if c == SW_P_L.Cmd.List then
		SW_P_ShowList();
	elseif c == SW_P_L.Cmd.Save then
		SW_P_DoSave(v);
	elseif c == SW_P_L.Cmd.Load then
		SW_P_DoLoad(v);
	elseif c == SW_P_L.Cmd.Delete then
		if v == nil or string.gsub(v, " ", "") == "" then return; end
		if SW_P_Saved[v] then
			SW_P_Saved[v] = nil;
			SW_P_print(string.format(SW_P_L.DeletedProfile, v));
		else
			SW_P_print(string.format(SW_P_L.NoSuchProfile, v));
		end
	elseif c == "" or c == "?" then
		SW_P_PrintHelp();
	else
		SW_P_print(SW_CONSOLE_NOCMD..c);
		SW_P_PrintHelp();
	end
	
end
function SW_P_PrintHelp()
	for k, v in pairs (SW_P_L.Cmd) do
		SW_P_print(string.format(SW_P_L.CommandListItem, v, SW_P_L.CmpExplain[k]));
	end
end
function SW_P_DoSave(v)
	local saveAs;
	if v == nil or string.gsub(v, " ", "") == "" then
		saveAs = string.format(SW_P_L.SaveName, GetRealmName(), GetUnitName("player"));
	else
		saveAs = v;
	end
	SW_P_Saved[saveAs] = SW_P_TDC(SW_Settings);
	SW_P_Saved[saveAs].SWPScaleCheck = UIParent:GetEffectiveScale();
	SW_P_print(string.format(SW_P_L.SavedAs, saveAs));
end
function SW_P_DoLoad(v)
	local loadName;
	if v == nil or string.gsub(v, " ", "") == "" then
		loadName = string.format(SW_P_L.SaveName, GetRealmName(), GetUnitName("player"));
	else
		loadName = v;
	end
	if not SW_P_Saved[loadName] then
		SW_P_print(string.format(SW_P_L.NoSuchProfile, loadName));
		return;
	end
	SW_P_ApplySettings(SW_P_Saved[loadName]);
	SW_P_print(string.format(SW_P_L.LoadedProfile, loadName));
end
function SW_P_ApplySettings(table)
	if table ==nil then return; end
	if type(table) ~= "table" then return; end
	
	local tmpSettings = SW_P_TDC(table);
	if tmpSettings.SWPScaleCheck then
		--[[ with the new anchoring in wow this is no longer needed
		if tmpSettings.SWPScaleCheck + 0.1 < UIParent:GetEffectiveScale()  then
			--dont load position settings 
			-- windows might be outside of viewable area. 
			tmpSettings.WindowPos = nil;
		end
		--]]
		tmpSettings.SWPScaleCheck = nil;
	end
	tmpSettings.LAST_V_RUN = SW_Settings.LAST_V_RUN;
	tmpSettings.lastWOWBuild = SW_Settings.lastWOWBuild;
	tmpSettings.IsRunning = SW_Settings.IsRunning;
	tmpSettings.LAST_LOCALE = SW_Settings.LAST_LOCALE;
	-- 2.0.5 added this in case we add even more buttons
	-- this will be a problem with old versions though
	if tmpSettings.QuickOptCount > SW_OPT_COUNT then
		tmpSettings.QuickOptCount = SW_OPT_COUNT;
	end
	SW_Settings = tmpSettings;
	
	SW_BarFrame1:Hide();
	--ReloadUI();

	SW_StartupCheck_Vars();
	SW_StartupCheck_Visuals();
	SW_BarLayoutRegisterd();
	
	SW_BarFrame1:Show();
	--2.0.5 layout of option buttons
	SW_OptUpdateLayout(SW_BarFrame1_Selector_Opt1);
	SW_RedoOptLayout = true;
end
function SW_P_ShowList()
	local i=0;
	for k, v in pairs (SW_P_Saved) do
		i = i + 1;
		SW_P_print(k);
	end
	
	if i == 0 then
		SW_P_print(SW_P_L.NoProfiles);
	else
		SW_P_print(string.format(SW_P_L.NumProfiles, i));
	end
end
-- recursive table deep copy func, will not do a deep copy of functions (don't need that here)
function SW_P_TDC (table)
	if table ==nil then return; end
	if type(table) ~= "table" then return; end
	
	local ret = {};
	for k, v in pairs (table) do
		if type(v) == "table" then
			ret[k] = SW_P_TDC(v);
		elseif not (k == "LAST_V_RUN" or k == "lastWOWBuild" or k == "IsRunning" or k == "LAST_LOCALE" ) then -- exclude these
			ret[k] = v;
		end
	end
	return ret;
end
-- setup for the little event processing we do here
function SW_P_OnEvent()
	if event == "ADDON_LOADED" and arg1 == "SW_Stats_Profiles" then
		SW_P_print("SW_Stats_Profiles..loaded");
		SW_P_PrintHelp();
	end
end
local SW_P_EventSink = CreateFrame("Frame");
SW_P_EventSink:SetScript("OnEvent", SW_P_OnEvent);
SW_P_EventSink:RegisterEvent("ADDON_LOADED");

-- setup the slash handlers
SlashCmdList["SW_STATS_PROFILES"] = SW_P_SlashHandler;
SLASH_SW_STATS_PROFILES1 = "/swprofiles";
SLASH_SW_STATS_PROFILES2 = "/swp";

function SW_P_print(str)
	local con;
	
	if SW_FrameConsole_Text1_MsgFrame:IsVisible() then
		con = SW_FrameConsole_Text1_MsgFrame;
	else
		con = DEFAULT_CHAT_FRAME;
	end
	con:AddMessage(str);
end
