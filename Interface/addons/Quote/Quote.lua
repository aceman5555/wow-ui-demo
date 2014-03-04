---------------------------------------------------
--                  Quote System                 --
--                         v.1.2.1                --
---------------------------------------------------





function Quote_Out(text)
	DEFAULT_CHAT_FRAME:AddMessage(text)
end
	

function Quote_Send()
	if not (UnitName("target") == nil) then 
		if (UnitIsVisible("target")) then
			if (UnitIsFriend("player", "target")) then	
				local tempnum = math.random(1, #(QUOTE_MESSAGE_Target_Good));
				Quote_Msg(Quote_MsgReplace_Full(QUOTE_MESSAGE_Target_Good[tempnum], UnitName("target")), "WORLD");
			else 
				local tempnum = math.random(1, #(QUOTE_MESSAGE_Target_Evil));
				Quote_Msg(Quote_MsgReplace_Full(QUOTE_MESSAGE_Target_Evil[tempnum], UnitName("target")), "WORLD");
			end
		else
			local tempnum = math.random(1, #(QUOTE_MESSAGE_NoTarget));
			Quote_Msg(Quote_MsgReplace_Short(QUOTE_MESSAGE_NoTarget[tempnum], UnitName("player")), "WORLD");
		end
	else
	
		local tempnum = math.random(1, #(QUOTE_MESSAGE_NoTarget));
		Quote_Msg(Quote_MsgReplace_Short(QUOTE_MESSAGE_NoTarget[tempnum], UnitName("player")), "WORLD");
	end

	
 end
-- Registering Slash Command
	SlashCmdList["QUOTE"] = quote;
	SLASH_QUOTE1 = "/quote";
------------------------------------------------------------------------------------------------------
-- POSTING FUNCTIONS (CONSOLE, CHAT, MESSAGE SYSTEM) 
------------------------------------------------------------------------------------------------------

function Quote_Msg(msg, type)
	if (type == "WORLD") then
		if (GetNumRaidMembers() > 0) then
			SendChatMessage(msg, "RAID");
		elseif (GetNumPartyMembers() > 0) then
			SendChatMessage(msg, "PARTY");
		else
			SendChatMessage(msg, "SAY");
		end
	end
end

------------------------------------------------------------------------------------------------------
-- USER-FRIENDLY VARIABLES WHEN DISPLAYING CHAT
------------------------------------------------------------------------------------------------------

function Quote_MsgReplace_Full(msg, target)
	local GenderTable1 = { "its", "his", "her" };
	local GenderTable2 = { "it", "him", "her" };
	local GenderTable3 = { "it", "he", "she" };
	msg = string.gsub(msg, "<player>", UnitName("player"));   
	msg = string.gsub(msg, "<target>", UnitName("target"));
	msg = string.gsub(msg, "<gender1>", GenderTable1[UnitSex("target")]);
	msg = string.gsub(msg, "<gender2>", GenderTable2[UnitSex("target")]);
	msg = string.gsub(msg, "<gender3>", GenderTable3[UnitSex("target")]);
	return msg;
end

function Quote_MsgReplace_Short(msg, target)
	msg = string.gsub(msg, "<player>", UnitName("player"));   
	return msg;
end

function QuoteShowAll()
	QuoteFrame:Show()
	SendQuote_Button:Show()
	QuotesClose_Button:Show()
end

function QuoteHideAll()
	SendQuote_Button:Hide()
	QuotesClose_Button:Hide()
	QuoteFrame:Hide()
end

function quote(msg)
	if msg == "" then
	Quote_Send()
	elseif msg == "show" then
	QuoteShowAll()
	elseif msg == "help" then
	Quote_Out("help:  Shows this message")
	Quote_Out("show:  Displays the Main Window")
	Quote_Out("close:  Closes the Main Window")
	elseif msg == "close" then
	QuoteHideAll()
	end
end
	