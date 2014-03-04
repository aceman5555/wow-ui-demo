--[[
	WARNING! If you edit this file you need a good editor, not notepad.
	This file HAS to be saved in UTF-8 format (without signature) else we would have to escape
	all special chars
	e.g. http://www.jedit.org/ will work, when opening the file rightclick and select encoding UTF-8
	
]]--

SW_UL_L = {};
SW_UL_L.When = "When";
SW_UL_L.Source = "Source";
SW_UL_L.Action = "??";
SW_UL_L.Target = "Target";
SW_UL_L.What = "Info";
SW_UL_L.NarrowData = "If checked only data relevant to your group/raid will be added.(Already added items are unaffected)";
SW_UL_L.CommandListItem = "|cff20ff20%s:|r %s";

SW_UL_L.Cmd = {};
SW_UL_L.Cmd.FontSize = "fs";
SW_UL_L.CmpExplain = {};
SW_UL_L.CmpExplain.FontSize = "Sets the font size e.g. /swl fs 8";

SW_UL_FilterCollection.Actions.Damage.Explain = "Damage";
SW_UL_FilterCollection.Actions.GRDamage.Explain = "Inner group/raid damage";
SW_UL_FilterCollection.Actions.Heal.Explain = "Healing";
SW_UL_FilterCollection.Actions.DOT.Explain = "Damage over time";
SW_UL_FilterCollection.Actions.HOT.Explain = "Healing over time";
SW_UL_FilterCollection.Actions.PosEffectGot.Explain = "Target got a buff";
SW_UL_FilterCollection.Actions.NegEffectGot.Explain = "Target got a debuff";
SW_UL_FilterCollection.Actions.UnknownEffectGot.Explain = "Target got an effect";
SW_UL_FilterCollection.Actions.PosEffectLost.Explain = "Target lost a buff";
SW_UL_FilterCollection.Actions.NegEffectLost.Explain = "Target lost a debuff";
SW_UL_FilterCollection.Actions.UnknownEffectLost.Explain = "Target lost an effect";
SW_UL_FilterCollection.Actions.Death.Explain = "Target died";
SW_UL_FilterCollection.Actions.Slay.Explain = "Source killed target";
SW_UL_FilterCollection.Actions.NullDmg.Explain = "Parries/Blocks/Full resists etc.";
SW_UL_FilterCollection.Actions.Cast.Explain = "Casting and perform messages";
SW_UL_FilterCollection.Actions.Leech.Explain = "Leeching and spell steal messages";
SW_UL_FilterCollection.Actions.Gain.Explain = "Gain messages (Happiness/Mana/Rage etc.)";
SW_UL_FilterCollection.Actions.ExtraAttacks.Explain = "Extra attack messages";
SW_UL_FilterCollection.Actions.NoSpecial.Explain = "Messages parsed but not categorized";
SW_UL_FilterCollection.Actions.Interrupt.Explain = "Interrupt messages";

if LOCALE_deDE then
	SW_UL_L.When = "Wann";
	SW_UL_L.Source = "Quelle";
	SW_UL_L.Action = "??";
	SW_UL_L.Target = "Ziel";
	SW_UL_L.What = "Info";
	SW_UL_FilterCollection.Actions.Damage.Explain = "Schaden";
	SW_UL_FilterCollection.Actions.GRDamage.Explain = "Schaden innerhalb der Gruppe.";
	SW_UL_FilterCollection.Actions.Heal.Explain = "Heilung";
	SW_UL_FilterCollection.Actions.DOT.Explain = "Schaden über Zeit";
	SW_UL_FilterCollection.Actions.HOT.Explain = "Heilung über Zeit";
	SW_UL_FilterCollection.Actions.PosEffectGot.Explain = "Ziel bekam einen Buff";
	SW_UL_FilterCollection.Actions.NegEffectGot.Explain = "Ziel bekam einen Debuff";
	SW_UL_FilterCollection.Actions.UnknownEffectGot.Explain = "Ziel bekam einen Effekt";
	SW_UL_FilterCollection.Actions.PosEffectLost.Explain = "Ziel verlor einen Buff";
	SW_UL_FilterCollection.Actions.NegEffectLost.Explain = "Ziel verlor einen Debuff";
	SW_UL_FilterCollection.Actions.UnknownEffectLost.Explain = "Ziel verlor einen Effekt";
	SW_UL_FilterCollection.Actions.Death.Explain = "Ziel ist gestorben";
	SW_UL_FilterCollection.Actions.Slay.Explain = "Quelle tötete Ziel";
	SW_UL_FilterCollection.Actions.NullDmg.Explain = "Parrieren/Blocken etc.";
	SW_UL_FilterCollection.Actions.Cast.Explain = "Spruch und Handlungsnachrichten";
	
	SW_UL_L.CmpExplain.FontSize = "Setz die Fontgrösse. z.B. /sws fs 8";
	
elseif LOCALE_frFR then
	
elseif LOCALE_zhCN then

elseif LOCALE_zhTW then
--elseif ... then
end