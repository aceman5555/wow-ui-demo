--[[
	WARNING! If you edit this file you need a good editor, not notepad.
	This file HAS to be saved in UTF-8 format (without signature) else we would have to escape
	all special chars
	e.g. http://www.jedit.org/ will work, when opening the file rightclick and select encoding UTF-8
	
]]--

SW_P_L = {};
SW_P_L.NoProfiles = "There are no saved profiles.";
SW_P_L.NumProfiles = "There are %d profiles saved.";
SW_P_L.SavedAs = "Profile saved as \"%s\"";
SW_P_L.SaveName = "%s.%s";
SW_P_L.NoSuchProfile = "There is no profile with the name \"%s\"";
SW_P_L.LoadedProfile = "Profile \"%s\" loaded.";
SW_P_L.DeletedProfile = "Profile \"%s\" deleted.";
SW_P_L.CommandListItem = "|cff20ff20%s:|r %s";

SW_P_L.Cmd = {};
SW_P_L.Cmd.List = "list";
SW_P_L.Cmd.Save= "save";
SW_P_L.Cmd.Load = "load";
SW_P_L.Cmd.Delete = "delete";
SW_P_L.CmpExplain = {};
SW_P_L.CmpExplain.List = "Lists the saved profiles (/swp list)";
SW_P_L.CmpExplain.Save= "Saves a profile. (You can supply a name E.g. /swp save Freds super settings)";
SW_P_L.CmpExplain.Load = "Loades a saved profile. (You can supply a name E.g. /swp load Freds super settings)";
SW_P_L.CmpExplain.Delete = "Deletes a saved profile. You MUST supply a name E.g. /swp delete Freds super settings";

if LOCALE_deDE then
	SW_P_L.NoProfiles = "Es gibt keine abgespeicherten Profile.";
	SW_P_L.NumProfiles = "Es gibt %d abgespeicherte Profile.";
	SW_P_L.SavedAs = "Profil gespeichert unter \"%s\"";
	SW_P_L.NoSuchProfile = "Es gibt kein Profil mit dem Namen: \"%s\"";
	SW_P_L.LoadedProfile = "Profil \"%s\" geladen.";
	SW_P_L.DeletedProfile = "Profil \"%s\" wurde gelöscht.";
	SW_P_L.CmpExplain.List = "Listet alle gespeicherten Profile auf. (/swp list)";
	SW_P_L.CmpExplain.Save= "Speichert ein Profil. (Es kann ein Name angegeben werden z.B. /swp save Freds Profil)";
	SW_P_L.CmpExplain.Load = "Lädt ein gespeichertes Profil. (Es kann ein Name angegeben werden z.B. /swp load Freds Profil)";
	SW_P_L.CmpExplain.Delete = "Löscht ein gespeichertes Profil. Es MUβ ein Name angegeben werden z.B. /swp delete Freds Profil";
elseif LOCALE_frFR then
	
elseif LOCALE_zhCN then

elseif LOCALE_zhTW then
--elseif ... then
end