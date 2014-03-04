-- -------------------------------------------------------------------------- --
-- GridStatusMTs DEFAULT (english) Localization                               --
-- Please make sure to save this file as UTF-8. ¶                             --
-- -------------------------------------------------------------------------- --

GridStatusMTs_Locales =

{
	["MTs"] = true, -- GridStatusMTs menu name
	["MT"] = true, -- for text indicator (Blizzard: MT | oRA2, oRA3 or CT_RA: MT1, MT2 ... MT10)
	-- options:
	["Opacity"] = true,
	["Sets the opacity for the MainTank icons."] = true,
	["Blizzard MainTank icon"] = true,
	["Use the default Blizzard MainTank icon (shield)."] = true,
	["... for sorted MainTank list too"] = true,
	["Use the default Blizzard MainTank icon (shield) for a sorted MainTank list (oRA2, oRA3 or CT_RA) too."] = true,
}

function GridStatusMTs_Locales:CreateLocaleTable(t)
	for k,v in pairs(t) do
		self[k] = (v == true and k) or v
	end
end

GridStatusMTs_Locales:CreateLocaleTable(GridStatusMTs_Locales)