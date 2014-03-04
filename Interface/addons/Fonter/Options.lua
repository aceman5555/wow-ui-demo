local Fonter = LibStub("AceAddon-3.0"):GetAddon("Fonter")
local LSM    = LibStub:GetLibrary("LibSharedMedia-3.0")
local L      = LibStub("AceLocale-3.0"):GetLocale("Fonter")

function Fonter:InitializeConfiguration()
	defaults	= {
		profile = {
		  FontCenter          = "",
		  FontChat            = "",
		  FontDamage          = "",
		  FontHealth          = "",
		  FontNamePlate       = "",
	  	  FontQuest           = "",
		  FontRaid            = "",
		  FontScrolling       = "",
		  FontStacks          = "",
		  CenterOutline       = "",
		  ChatOutline         = "",
		  ChatOutline2        = "",
		  HealthOutline       = "",
		  HealthOutline2      = "",
		  NamePlateOutline    = "",
		  NamePlateOutline2   = "",
		  QuestOutline        = "",
		  QuestOutline2       = "",
		  StacksOutline       = "",
		  StacksOutline2      = "",
		  CenterSize          = 0,
		  ChatSize            = 0,
		  HealthSmall         = 0,
		  HealthMedium        = 0,
		  HealthLarge         = 0,
		  NamePlateSmall      = 0,
		  NamePlateMedium     = 0,
		  NamePlateLarge      = 0,
		  QuestSmall          = 0,
		  QuestMedium         = 0,
		  QuestLarge          = 0,
		  StacksSmall         = 0,
		  StacksMedium        = 0,
		  StacksLarge         = 0,
		}
	}

	local Outlines = {
		["NIL"]          = L["None"],
		["OUTLINE"]      = L["Outline"],
		["THICKOUTLINE"] = L["Thick Outline"],
	}

	self.Configuration = { }

	self.Configuration.Main = { name = "Fonter", handler = Fonter, type = "group", get = "GetValue", set = "SetValue",
	args = {
	Font1 = { name = L["Center Screen"], type = "group", inline = true, order = 1.0,
	args = {
FontCenter = {
	dialogControl = 'LSM30_Font',
	values = LSM:HashTable("font"),
	name   = L["Center Screen Font"],
	desc   = L["Center Screen/Map Location Text"],
	type   = "select",
	order  = 1.0
	},
FontRaid = {
	dialogControl = 'LSM30_Font',
	values = LSM:HashTable("font"),
	name   = L["Raid Warnings Font"],
	desc   = L["Raid Warnings/Spell Warning Text"],
	type   = "select",
	order  = 1.1
	},
CenterOutline = {
	values = Outlines,
	name   = L["Outline"],
	desc   = L["Center Screen/Raid Warnings Outline"],
	type   = "select",
	order  = 1.2
	},
CenterSize = {
	name   = L["Center Screen Size"],
	type   = "range",
	step   = 1,
	min    = 0,
	max    = 34,
	order  = 1.3
	}
	}
},
	Font2 = { name = L["Chat"], type = "group", inline = true, order = 1.1,
	args = {
FontChat = {
	dialogControl = 'LSM30_Font',
	values = LSM:HashTable("font"),
	name   = L["Chat Font"],
	desc   = L["Chat Frame/Chat Input Text"],
	type   = "select",
	order  = 1.0
	},
ChatOutline = {
	values = Outlines,
	name   = L["Chat Box Outline"],
	type   = "select",
	order  = 1.1
	},
ChatOutline2 = {
	values = Outlines,
	name   = L["Chat Input Outline"],
	type   = "select",
	order  = 1.2
	},
ChatSize = {
	name   = L["Chat Input Size"],
	type   = "range",
	step   = 1,
	min    = 0,
	max    = 34,
	order  = 1.3
	}
	}
},
	Font3 = { name = L["Damage"], type = "group", inline = true, order = 1.2,
	args = {
FontDamage = {
	dialogControl = 'LSM30_Font',
	values = LSM:HashTable("font"),
	name   = L["Damage Font"],
	desc   = L["Damage/Healing/Experience Text"],
	type   = "select",
	order  = 1.0
	},
FontScrolling = {
	dialogControl = 'LSM30_Font',
	values = LSM:HashTable("font"),
	name   = L["Scrolling Font"],
	desc   = L["Scrolling Combat Text"],
	type   = "select",
	order  = 1.1
	}
	}
},
	Font4 = { name = L["Health Frame"], type = "group", inline = true, order = 1.3,
	args = {
FontHealth = {
	dialogControl = 'LSM30_Font',
	values = LSM:HashTable("font"),
	name   = L["Health Frame Font"],
	desc   = L["Health Frames/Undefined Text"],
	type   = "select",
	order  = 1.0
	},
HealthOutline = {
	values = Outlines,
	name   = L["Outlined Fonts"],
	desc   = L["Text Outlined By Blizzard"],
	type   = "select",
	order  = 1.1
	},
HealthOutline2 = {
	values = Outlines,
	name   = L["Non Outlined Fonts"],
	desc   = L["Text Not Outlined By Blizzard"],
	type   = "select",
	order  = 1.2
	},
HealthSmall = {
	name   = L["Health Frame Size Small"],
	desc   = L["For Fonts Rendered Using This Size"],
	type   = "range",
	step   = 1,
	min    = 0,
	max    = 30,
	order  = 1.3
	},
HealthMedium = {
	name   = L["Health Frame Size Medium"],
	desc   = L["For Fonts Rendered Using This Size"],
	type   = "range",
	step   = 1,
	min    = 0,
	max    = 32,
	order  = 1.4
	},
HealthLarge = {
	name   = L["Health Frame Size Large"],
	desc   = L["For Fonts Rendered Using This Size"],
	type   = "range",
	step   = 1,
	min    = 0,
	max    = 34,
	order  = 1.5
	}
	}
},
	Font5 = { name = L["Nameplates"], type = "group", inline = true, order = 1.4,
	args = {
FontNamePlate = {
	dialogControl = 'LSM30_Font',
	values = LSM:HashTable("font"),
	name   = L["Nameplates Font"],
	desc   = L["Nameplates/Unit Names/Friends Text"],
	type   = "select",
	order  = 1.0
	},	
NamePlateOutline = {
	values = Outlines,
	name   = L["Outlined Fonts"],
	desc   = L["Text Outlined By Blizzard"],
	type   = "select",
	order  = 1.1
	},
NamePlateOutline2 = {
	values = Outlines,
	name   = L["Non Outlined Fonts"],
	desc   = L["Text Not Outlined By Blizzard"],
	type   = "select",
	order  = 1.2
	},							
NamePlateSmall = {
	name   = L["Nameplates Size Small"],
	desc   = L["For Fonts Rendered Using This Size"],
	type   = "range",
	step   = 1,
	min    = 0,
	max    = 30,
	order  = 1.3
	},
NamePlateMedium = {
	name   = L["Nameplates Size Medium"],
	desc   = L["For Fonts Rendered Using This Size"],
	type   = "range",
	step   = 1,
	min    = 0,
	max    = 32,
	order  = 1.4
	},
NamePlateLarge = {
	name   = L["Nameplates Size Large"],
	desc   = L["For Fonts Rendered Using This Size"],
	type   = "range",
	step   = 1,
	min    = 0,
	max    = 34,
	order  = 1.5
	}
	}
},
	Font6 = { name = L["Quest Log"], type = "group", inline = true, order = 1.5,
	args = {
FontQuest = {
	dialogControl = 'LSM30_Font',
	values = LSM:HashTable("font"),
	name   = L["Quest Font"],
	desc   = L["Quest Log/Books/Mail Text"],
	type   = "select",
	order  = 1.0
	},
QuestOutline = {
	values = Outlines,
	name   = L["Outlined Fonts"],
	desc   = L["Text Outlined By Blizzard"],
	type   = "select",
	order  = 1.1
	},
QuestOutline2 = {
	values = Outlines,
	name   = L["Non Outlined Fonts"],
	desc   = L["Text Not Outlined By Blizzard"],
	type   = "select",
	order  = 1.2
	},
QuestSmall = {
	name   = L["Quest Size Small"],
	desc   = L["For Fonts Rendered Using This Size"],
	type   = "range",
	step   = 1,
	min    = 0,
	max    = 30,
	order  = 1.3
	},
QuestMedium = {
	name   = L["Quest Size Medium"],
	desc   = L["For Fonts Rendered Using This Size"],
	type   = "range",
	step   = 1,
	min    = 0,
	max    = 32,
	order  = 1.4
	},
QuestLarge = {
	name   = L["Quest Size Large"],
	desc   = L["For Fonts Rendered Using This Size"],
	type   = "range",
	step   = 1,
	min    = 0,
	max    = 34,
	order  = 1.5
	}
	}
},
	Font7 = { name = L["Stacks"], type = "group", inline = true, order = 1.6,
	args = {
FontStacks = {
	dialogControl = 'LSM30_Font',
	values = LSM:HashTable("font"),
	name   = L["Stacks Font"],
	desc   = L["Stacks/The Bag Frame/Tooltips Text"],
	type   = "select",
	order  = 1.0
	},
StacksOutline = {
	values = Outlines,
	name   = L["Outlined Fonts"],
	desc   = L["Text Outlined By Blizzard"],
	type   = "select",
	order  = 1.1
	},
StacksOutline2 = {
	values = Outlines,
	name   = L["Non Outlined Fonts"],
	desc   = L["Text Not Outlined By Blizzard"],
	type   = "select",
	order  = 1.2
	},
StacksSmall = {
	name   = L["Stacks Size Small"],
	desc   = L["For Fonts Rendered Using This Size"],
	type   = "range",
	step   = 1,
	min    = 0,
	max    = 30,
	order  = 1.3
	},
StacksMedium = {
	name   = L["Stacks Size Medium"],
	desc   = L["For Fonts Rendered Using This Size"],
	type   = "range",
	step   = 1,
	min    = 0,
	max    = 32,
	order  = 1.4
	},
StacksLarge = {
	name   = L["Stacks Size Large"],
	desc   = L["For Fonts Rendered Using This Size"],
	type   = "range",
	step   = 1,
	min    = 0,
	max    = 34,
	order  = 1.5
	}
	}
}
}
}

	self.db = LibStub("AceDB-3.0"):New("FonterDB", defaults, true)
	self.Configuration.Profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.Configuration.Profiles.name = "Profiles"

	LibStub("AceConfig-3.0"):RegisterOptionsTable("Fonter",          self.Configuration.Main)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Fonter.Profiles", self.Configuration.Profiles)

	self.db.RegisterCallback(self, "OnProfileChanged", "Update")
	self.db.RegisterCallback(self, "OnProfileCopied",  "Update")
	self.db.RegisterCallback(self, "OnProfileReset",   "Update")

	self:RegisterChatCommand("Fonter", "ChatCommand")
end

function Fonter:InitializeConfigurationGUI()
	self.ConfigurationFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Fonter", self.Configuration.Main.name)

	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Fonter.Profiles", self.Configuration.Profiles.name, "Fonter")

	self.ConfigurationFrame.okay   = function() 
	self:Update() end
	self.ConfigurationFrame.cancel = function() 
	self:OnCloseConfigurationFrame() end
end

function Fonter:ChatCommand()
	InterfaceOptionsFrame_OpenToCategory(self.ConfigurationFrame)
end

function Fonter:GetValue(Infotable)
	return self.db.profile[Infotable[#Infotable]]
end

function Fonter:SetValue(Infotable, Value)
	self.db.profile[Infotable[#Infotable]] = Value
	self:Update()
end

function Fonter:GetFontValue(Infotable)
	local table = LSM:HashTable("font")

	for k, v in pairs(table) do
		if self.db.profile[Infotable[#Infotable]] == v then
			return k
		end
	end
end

function Fonter:SetFontValue(Infotable, Value)
	local table = LSM:HashTable("font")
	self.db.profile[Infotable[#Infotable]] = table[Value]
	self:Update()
end