-- -------------------------------------------------------------------------- --
-- GridStatusMTs deDE Localization                                            --
-- Please make sure to save this file as UTF-8. ¶                             --
-- -------------------------------------------------------------------------- --
if GetLocale() ~= "deDE" then return end
GridStatusMTs_Locales:CreateLocaleTable(

{
	["MTs"] = "MTs", -- GridStatusMTs menu name
	["MT"] = "MT", -- for text indicator (Blizzard: MT | oRA2, oRA3 or CT_RA: MT1, MT2 ... MT10)
	-- options:
	["Opacity"] = "Deckkraft",
	["Sets the opacity for the MainTank icons."] = "Verändert die Deckkraft der MainTank Symbole.",
	["Blizzard MainTank icon"] = "Blizzard MainTank Symbol",
	["Use the default Blizzard MainTank icon (shield)."] = "Das Blizzard MainTank Symbol (Schild) benutzen.",
	["... for sorted MainTank list too"] = "... auch für eine sortierte MainTank Liste",
	["Use the default Blizzard MainTank icon (shield) for a sorted MainTank list (oRA2, oRA3 or CT_RA) too."] = "Das Blizzard MainTank Symbol (Schild) auch für eine sortierte MainTank Liste (oRA2, oRA3 oder CT_RA) benutzen.",
}

)