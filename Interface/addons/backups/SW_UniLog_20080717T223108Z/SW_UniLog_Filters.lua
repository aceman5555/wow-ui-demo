--[[
	The rightclick filters
	These just put the expressions into the textboxes
	but an easy way to use the addon w/o knowing what a regex is or what the special commands are
	(not implemented yet and a placeholder)
	The following section explains the avilable commands.
	
	Special commands:
	/c=Xyz or /c=XYZ class filters first uses localized names all caps uses the englisch names same in each language
	/eg :EverGroup
	/cg :CurrentGroup
	/pet :CurrentPets in group
	/eg /cg /pet all support the optional class filter e.g. /cg=MAGE will only show mages
	
	| :special used to "or" filters together important: for each or the string is checked - the more ors you use the slower it gets
	
	source -> action -> target -> info  filters behave as if "anded" together
	
	/sot Special command for source
	with /sot found in the source filter the target filter is ignored and the source filter is used for both
	ored together  resulting in: 
	action and (sorce or target) and info
	e.g. /sot/c=MAGE would show any action coming from or directed towards a mage or /sotArtack shows anything coming from or going to Artack
	
	Any regular expression is supported
	eg on the What filter:
	"%*(.-)<<" produces all crits that where partially resisted/blocked - and yes mobs can do that :)
	
	/c=War would match any warrior or warlock on an english client /c=WAR does the same for all languages
	
	any supported entity can be ored eg.
	^J|/pet|/eg on a source filter would match all units starting with a "J" or all current pets or all you have been grouped with
	
	.* as a filter eg is pointless it matches everything
	.*|/pet would always eval to true
	
	ALWAYS first see if using the action filter can narrow down your "search" its the cheapest and fastest of them all
	
--]]

SW_UL_FilterCollection = {
	Units ={
	
	},
	Infos = {
	
	},
	Actions = {
		Damage = {
			id = 1,
			str = "|cffff0000>>|r",
		},
		GRDamage = {
			id = 2,
			str = "|cffff0000!!|r",
		},
		Heal = {
			id = 3,
			str = "|cff40ff40>>|r",
		},
		DOT= {
			id = 4,
			str = "|cffff0000+>|r",
		},
		HOT = {
			id = 5,
			str = "|cff40ff40+>|r",
		},
		PosEffectGot = {
			id = 6,
			str = "|cff00ff00++|r",
		},
		NegEffectGot = {
			id = 7,
			str = "|cffff0000++|r",
		},
		UnknownEffectGot = {
			id = 8,
			str = "++",
		},
		PosEffectLost = {
			id = 9,
			str = "|cff00ff00--|r",
		},
		NegEffectLost = {
			id = 10,
			str = "|cffff0000--|r",
		},
		UnknownEffectLost = {
			id = 11,
			str = "--",
		},
		Death = {
			id = 12,
			str = "|cff999999xx|r",
		},
		Slay = {
			id = 13,
			str = "|cff999999XX|r",
		},
		NullDmg = {
			id = 14,
			str = "|cffdddddd=0|r",
		},
		Cast = {
			id = 15,
			str = "|cff8080ff^^|r",
		},
		Leech = {
			id = 16,
			str = "|cff8080ff>>|r",
		},
		Gain = {
			id = 17,
			str = "|cffffff00>>|r",
		},
		ExtraAttacks = {
			id = 18,
			str = "|cffffff00++|r",
		},
		NoSpecial = {
			id = 19,
			str = "|cffffff00??|r",
		},
		Interrupt = {
			id = 20,
			str = "|cffFF59F5<>|r",
		},
	},
};
 function SW_UL_Init()
 
 end
 
 function SW_UL_TargetFilterDD_Initialize()
	--[[
 	local tmpButton = {};
	for i, t in ipairs(SW_UL_ActionList.rev) do
		tmpButton.text = t.str;
		--tmpButton.func = SW_UL_ActionFilterDDSelect;
		tmpButton.arg1 = i; -- infoNumber
		tmpButton.keepShownOnClick = true;
		tmpButton.checked = SW_UL_Settings.SelectedActions[i];
		UIDropDownMenu_AddButton(tmpButton);
	end
	--]]
 end

