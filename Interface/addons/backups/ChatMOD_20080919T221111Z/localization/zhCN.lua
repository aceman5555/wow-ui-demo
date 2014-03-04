-- Chinese Simplified by q09q09
-- q09q09' Profile: http://forums.curse-gaming.com/member.php?u=43339
-- Last Update 28.05.2007  Thanks for Info by 'toshism' that URF-8 was broken. 
if ( GetLocale() == "zhCN" ) then
	SCCN_INIT_CHANNEL_LOCAL			= "General";
	SCCN_GUI_HIGHLIGHT1				= "???????? SCCN ????? ???????";
	SCCN_LOCAL_CLASS["WARLOCK"] 	= "??";
	SCCN_LOCAL_CLASS["HUNTER"] 	= "??";
	SCCN_LOCAL_CLASS["PRIEST"] 	= "??";
	SCCN_LOCAL_CLASS["PALADIN"] 	= "???";
	SCCN_LOCAL_CLASS["MAGE"] 	= "??";
	SCCN_LOCAL_CLASS["ROGUE"] 	= "??";
	SCCN_LOCAL_CLASS["DRUID"] 	= "???";
	SCCN_LOCAL_CLASS["SHAMAN"] 	= "????";
	SCCN_LOCAL_CLASS["WARRIOR"] 	= "??";
	SCCN_LOCAL_ZONE["alterac"]	= "??????";
	SCCN_LOCAL_ZONE["warsong"]	= "????";
	SCCN_LOCAL_ZONE["arathi"]	= "?????";
	SCCN_CONFAB			= "|cffff0000????Confab??????,SCCN??????????!";
	SCCN_HELP[1]			= "Sol's Color chat Nicks - ????:";
	SCCN_HELP[2]			= "|cff68ccef".."/chatmod hidechanname".."|cffffffff".." ??????";
	SCCN_HELP[3]			= "|cff68ccef".."/chatmod colornicks".."|cffffffff".." ???????????";
	SCCN_HELP[4]			= "|cff68ccef".."/chatmod purge".."|cffffffff".." ??SCCN???? |cffa0a0a0(?????ui????????????)";
	SCCN_HELP[5]			= "|cff68ccef".."/chatmod killdb".."|cffffffff".." ????SCCN?????? (????)";
	SCCN_HELP[6]			= "|cff68ccef".."/chatmod mousescroll".."|cffffffff".." ???????????? |cffa0a0a0(??<SHIFT>-????=??,??<CTRL>-????=????, <STRG>-Molette = Top, Bottom)";
	SCCN_HELP[7]			= "|cff68ccef".."/chatmod topeditbox".."|cffffffff".." ????????????????";	
	SCCN_HELP[8]			= "|cff68ccef".."/chatmod timestamp".."|cffffffff".." ???????????????|cffa0a0a0 /chatmod timestamp ?|cffffffff ?????????";
	SCCN_HELP[9]			= "|cff68ccef".."/chatmod colormap".."|cffffffff".." ?????????????????";	
	SCCN_HELP[10]			= "|cff68ccef".."/chatmod hyperlink".."|cffffffff".." ???????URL??????!";
	SCCN_HELP[11]			= "|cff68ccef".."/chatmod selfhighlight".."|cffffffff".." ???????????????!";
	SCCN_HELP[12]			= "|cff68ccef".."/chatmod clickinvite".."|cffffffff".." ???????[??]????????????";	
	SCCN_HELP[13] 			= "|cff68ccef".."/chatmod editboxkeys".."|cffffffff".." ????????????<ALT>?????????? & ??????????256?!";
	SCCN_HELP[14] 			= "|cff68ccef".."/chatmod chatstring".."|cffffffff".." ???????";
	SCCN_HELP[15] 			= "|cff68ccef".."/chatmod selfhighlightmsg".."|cffffffff".." ?????????????????????,??? /chatmod selfhighlight";	
	SCCN_HELP[16]			= "|cff68ccef".."/chatmod hidechatbuttons".."|cffffffff".." ???????";	
	SCCN_HELP[17]			= "|cff68ccef".."/chatmod highlight".."|cffffffff".." ????????????.";	
	SCCN_HELP[18]			= "|cff68ccef".."/chatmod AutoBGMap".."|cffffffff".." BGMinimap Autopupup.";	
	SCCN_HELP[19]			= "|cff68ccef".."/chatmod shortchanname ".."|cffffffff".." ???????.";	
	SCCN_HELP[20]			= "|cff68ccef".."/chatmod autogossipskip ".."|cffffffff".." ????????. |cffa0a0a0(?? <CTRL> ?????)";
	SCCN_HELP[21]			= "|cff68ccef".."/chatmod autodismount ".."|cffffffff".." ??????????????";	
	SCCN_HELP[22]					= "|cff68ccef".."/chatmod inchathighlight ".."|cffffffff".."Highlight Known Nicknames";	
	SCCN_HELP[23]					= "|cff68ccef".."/chatmod sticky ".."|cffffffff".."Sticky Chat behavior";	
	SCCN_HELP[24]					= "|cff68ccef".."/chatmod initchan <channelname>".."|cffffffff".."Set the specified <channelname> to default chatfram on startup.";		
	SCCN_HELP[25]					= "|cff68ccef".."/chatmod nofade".."|cffffffff".."Disable fading of Chattext";
	SCCN_HELP[26]					= "|cff68ccef".."/chatmod chaticon".."|cffffffff".."Toggle Chatcroll indicator Icon";
	SCCN_HELP[27]					= "|cff68ccef".."/chatmod showlevel".."|cffffffff".."Toggle Leveldisplay in Name";
	SCCN_HELP[28]					= "|cff68ccef".."/chatmod chatcolorname".."|cffffffff".."Toggle Namecoloring in Chattext";
	SCCN_HELP[99]			= "|cff68ccef".."/chatmod status".."|cffffffff".." ???????";
	SCCN_TS_HELP  			= "|cff68ccef".."/chatmod timestamp |cffFF0000FORMAT|cffffffff\n".."FORMAT:\n$h = ?? (0-24) \n$t = ?? (0-12) \n$m = ?? \n$s = ? \n$p = ??/?? (am / pm)\n".."|cff909090Example: /chatmod timestamp [$t:$m:$s $p]";
	SCCN_CMDSTATUS[1]		= "??????:";
	SCCN_CMDSTATUS[2]		= "???????????:";
	SCCN_CMDSTATUS[3]		= "???????????:";
	SCCN_CMDSTATUS[4]		= "???????:";
	SCCN_CMDSTATUS[5]		= "??????:";
	SCCN_CMDSTATUS[6]		= "????????????????:";
	SCCN_CMDSTATUS[7]		= "URL?????:";
	SCCN_CMDSTATUS[8]		= "?????????:";
	SCCN_CMDSTATUS[9]		= "??????????????:";
	SCCN_CMDSTATUS[10]		= "????????<ALT>:";
	SCCN_CMDSTATUS[11]		= "??????:";
	SCCN_CMDSTATUS[12]		= "?????????????:";
	SCCN_CMDSTATUS[13]		= "??????:";
	SCCN_CMDSTATUS[14] 		= "?????????:";
	SCCN_CMDSTATUS[15] 		= "?????:";
	SCCN_CMDSTATUS[16] 		= "?????:";
	SCCN_CMDSTATUS[17]		= "??????:";
	SCCN_CMDSTATUS[18]		= "????:";	
	SCCN_CMDSTATUS[19]				= "In Chat Highlight:";	
	SCCN_CMDSTATUS[20]				= "Remeber last Chatroom (sticky):";	
	SCCN_CMDSTATUS[21]				= "Don't Fade chattext automaticaly:";
	SCCN_CMDSTATUS[22]				= "Chat Scoll Icon:";
	SCCN_CMDSTATUS[23]				= "Leveldisplay in Name:";
	SCCN_CMDSTATUS[24]      = "Color names in Chattext:";
	-- cursom invite word in the local language
	SCCN_CUSTOM_INV[0]		= "??";
	SCCN_CUSTOM_INV[1] 		= "??";
	-- Whispers customized
	SCCN_CUSTOM_CHT_FROM		= "%s?:";
	SCCN_CUSTOM_CHT_TO		= "?%s:";	
	-- hide this channels aditional, feel free to add your own
	SCCN_STRIPCHAN[1]		= "??";
	SCCN_STRIPCHAN[2]		= "??";
	SCCN_STRIPCHAN[3]		= "??";		
	SCCN_STRIPCHAN[4]		= "????";
	SCCN_STRIPCHAN[5]		= "??";
-- ItemLink Channels
    SCCN_ILINK[1]                   = "General -"
    SCCN_ILINK[2]                   = "Trade -"
    SCCN_ILINK[3]                   = "LookingForGroup -"
    SCCN_ILINK[4]                   = "LocalDefense -"
    SCCN_ILINK[5]                   = "WorldDefense"	
	-- some general channel name translation for the GUI
	SCCN_TRANSLATE[1]				= "??";
	SCCN_TRANSLATE[2]				= "??";
	SCCN_TRANSLATE[3]				= "??";
	SCCN_TRANSLATE[4]				= "??";
	SCCN_TRANSLATE[5]				= "??";	
	SCCN_Highlighter				= "ChatMOD ??";
	SCCN_Config						= "ChatMOD ??";
	SCCN_Changelog					= "ChatMOD ????";	
	SCCN_NewVer                     = "There is a new ChatMOD Version available. Check www.solariz.de for Update!";
end;
