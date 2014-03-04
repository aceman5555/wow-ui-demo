-------------------------------------------------------------------------------
-- Tidy Plates: CLASSICPLATES
-------------------------------------------------------------------------------

local Theme = {}	
local CopyTable = TidyPlatesUtility.copyTable

local path = "Interface\\Addons\\TidyPlates_ClassicPlates\\Media\\"
local font = 						path.."Alice.ttf"
local blizzfont =					NAMEPLATE_FONT
--local blizzfont =					"FONTS\\ARIALN.TTF"
--local font =						"FONTS\\FRIZQT__.TTF"
--local font =						NAMEPLATE_FONT

-- Non-Latin Font Bypass
local NonLatinLocales = { ["koKR"] = true, ["zhCN"] = true, ["zhTW"] = true, }
if NonLatinLocales[GetLocale()] == true then font = STANDARD_TEXT_FONT end

local castbarVertical = -15

local StyleDefault = {}

				
StyleDefault.frame = {
	width = 106,
	height = 12,
}
				 
StyleDefault.healthborder = {
	texture = 					path.."NormalPlate",
	glowtexture = 					path.."Highlight",
	width = 128,
	height = 32,
	x = 0,
	y = 0,
	anchor = "CENTER",
}

StyleDefault.target = {
	texture		 =				path.."Highlight",
	width = 128,
	height = 32,
	x = 0,
	y = 0,
	anchor = "CENTER",
	show = true,
}

StyleDefault.highlight = {
	texture		 =				path.."Highlight",
	--width = 128,
	--height = 32,
}
			 
StyleDefault.threatborder = {
	texture =					path.."ThreatBar",
	width = 128,
	height = 32,
	x = 0,
	y = 0,
	anchor = "CENTER",
}

StyleDefault.castborder = {
	texture =					path.."CastBarBorder",
	width = 128,
	height = 32,
	x = 0,
	y = 0,
	anchor = "CENTER",
}
				
StyleDefault.castbar = {
	texture =					path.."StatusBar",
	width = 94,
	height = 7,
	x = 12,
	y = -8,
	anchor = "CENTER",
	orientation = "HORIZONTAL",
}

StyleDefault.castnostop = {
	texture = 					path.."CastBarNoStop",
	width = 128,
	height = 32,
	x = 0,
	y = 0,
	anchor = "CENTER",
}
									 
StyleDefault.name = {
	typeface =					font,
	size = 12,
	width = 130,
	height = 18,
	x = 26,
	y = 18,
	align = "LEFT",
	anchor = "LEFT",
	vertical = "BOTTOM",
	shadow = true,
}
				 
StyleDefault.level = {
	typeface =					font,
	size = 9,
	width = 30,
	height = 14,
	x = 8,
	y = -2,
	align = "LEFT",
	anchor = "LEFT",
	vertical = "BOTTOM",
	shadow = true,
}
				 
StyleDefault.healthbar = {
	texture = 					path.."StatusBar",
	width =106,
	height = 9,
	x = 9,
	y = 4,
	anchor = "CENTER",
	orientation = "HORIZONTAL",
}

StyleDefault.customtext = {
	typeface =					font,
	size = 10,
	width = 93,
	height = 10,
	x = 0,
	y = 16,
	align = "RIGHT",
	anchor = "CENTER",
	vertical = "BOTTOM",
	shadow = true,
	flags = "NONE",
	show = true,
}

StyleDefault.spelltext = {
	typeface =					font,
	size = 12,
	height = 12,
	width = 180,
	x = 0,
	y = -11 + castbarVertical,
	align = "CENTER",
	anchor = "TOP",
	vertical = "BOTTOM",
	shadow = true,
	flags = "NONE",
	show = true,
}

StyleDefault.eliteicon = {
	texture = 					path.."ElitePlate",
	width = 128,
	height = 32,
	x = 0,
	y = 0,
	anchor = "CENTER",
	show = true,
}

StyleDefault.spellicon = {
	width = 20,
	height = 20,
	x = 67,
	y = -20,
	anchor = "CENTER",
}
				
StyleDefault.raidicon = {
	width = 14,
	height = 14,
	x = 0,
	y = 12,
	anchor = "TOP",
}

StyleDefault.skullicon = {
	width = 8,
	height = 8,
	x = 2,
	y = 15,
	anchor = "LEFT",
}
				
StyleDefault.threatcolor = {
	LOW = { r = .5, g = 1, b = .2, a = 1, },
	MEDIUM = { r = .6, g = 1, b = 0, a = 1, },
	HIGH = { r = 1, g = .2, b = 0, a = 1, },
}
			

-- No-Bar Style
local StyleTextOnly = CopyTable(StyleDefault)
StyleTextOnly.threatborder.texture = EmptyTexture
StyleTextOnly.healthborder.texture = EmptyTexture
StyleTextOnly.healthbar.texture = EmptyTexture
StyleTextOnly.healthbar.backdrop = EmptyTexture
StyleTextOnly.eliteicon.texture = EmptyTexture
StyleTextOnly.customtext.align = "CENTER"
StyleTextOnly.customtext.size = 10
StyleTextOnly.customtext.y = 16
StyleTextOnly.level.show = false
StyleTextOnly.skullicon.show = false
StyleTextOnly.eliteicon.show = false
--StyleTextOnly.raidicon.x = 
--StyleTextOnly.raidicon.y = 
StyleTextOnly.highlight.texture = path.."TextPlate_Highlight"
StyleTextOnly.target.texture = path.."TextPlate_Target"
--StyleTextOnly.target.y = 21
--StyleTextOnly.target.height = 46
--StyleTextOnly.target.texture = EmptyTexture

local WidgetConfig = {}
WidgetConfig.ClassIcon = { anchor = "TOP" , x = 28,y = 24 }		-- Above Name
--WidgetConfig.ClassIcon = { anchor = "TOP" , x = -35 ,y = 14 }		-- Aside Name
--WidgetConfig.ClassIcon = { anchor = "TOP" , x = -26 ,y = 10 }		-- Upper Left on Bar
--WidgetConfig.ClassIcon = { anchor = "TOP" , x = 46 ,y = -8 }		-- Right, Opposite Spell Icon (not done)
WidgetConfig.TotemIcon = { anchor = "TOP" , x = 0 ,y = 26 }
--WidgetConfig.ThreatLineWidget = { anchor =  "TOP", x = 0 ,y = -7 }
WidgetConfig.ThreatLineWidget = { anchor =  "TOP", x = 0 ,y = 26 }	-- y = 20
--WidgetConfig.ThreatLineWidget = { anchor =  "TOP", x = 0 ,y = -2 }	-- y = 20
--WidgetConfig.ThreatWheelWidget = { anchor =  "CENTER", x = 60 ,y = 15 } 
WidgetConfig.ThreatWheelWidget = { anchor =  "CENTER", x = 33 ,y = 27 } -- "CENTER", plate, 30, 18
WidgetConfig.ComboWidget = { anchor = "TOP" , x = 0 ,y = 0 }
WidgetConfig.RangeWidget = { anchor = "CENTER" , x = 0 ,y = 12 }
WidgetConfig.DebuffWidget = { anchor = "TOP" , x = 22 ,y = 42 }

local DamageThemeName = "Classic/|cFFFF4400Damage"
local TankThemeName = "Classic/|cFF3782D1Tank"

SLASH_CLASSICTANK1 = '/classictank'
SlashCmdList['CLASSICTANK'] = ShowTidyPlatesHubTankPanel

SLASH_CLASSICDAMAGE = '/classicdamage'
SlashCmdList['CLASSICDAMAGE'] = ShowTidyPlatesHubDamagePanel


---------------------------------------------
-- Tidy Plates Hub Integration
---------------------------------------------
Theme["Default"] = StyleDefault
Theme["NameOnly"] = StyleTextOnly			

TidyPlatesThemeList[DamageThemeName] = Theme
local LocalVars = TidyPlatesHubDamageVariables

local ApplyThemeCustomization = TidyPlatesHubFunctions.ApplyThemeCustomization

local function ApplyDamageCustomization()
	ApplyThemeCustomization(Theme)
end

local function OnInitialize(plate)
	TidyPlatesHubFunctions.OnInitializeWidgets(plate, WidgetConfig)
end

local function OnActivateTheme(themeTable)
		if Theme == themeTable then
			LocalVars = TidyPlatesHubFunctions:UseDamageVariables()
			ApplyDamageCustomization()
		end
end

Theme.SetNameColor = TidyPlatesHubFunctions.SetNameColor
Theme.SetScale = TidyPlatesHubFunctions.SetScale
Theme.SetAlpha = TidyPlatesHubFunctions.SetAlpha
Theme.SetHealthbarColor = TidyPlatesHubFunctions.SetHealthbarColor
Theme.SetThreatColor = TidyPlatesHubFunctions.SetThreatColor
Theme.SetCastbarColor = TidyPlatesHubFunctions.SetCastbarColor
Theme.SetCustomText = TidyPlatesHubFunctions.SetCustomText
Theme.OnUpdate = TidyPlatesHubFunctions.OnUpdate
Theme.OnContextUpdate = TidyPlatesHubFunctions.OnContextUpdate
Theme.ShowConfigPanel = ShowTidyPlatesHubDamagePanel
Theme.SetStyle = TidyPlatesHubFunctions.SetStyleBinary
Theme.SetCustomText = TidyPlatesHubFunctions.SetCustomTextBinary
Theme.OnInitialize = OnInitialize		-- Need to provide widget positions
Theme.OnActivateTheme = OnActivateTheme -- called by Tidy Plates Core, Theme Loader
Theme.OnApplyThemeCustomization = ApplyDamageCustomization -- Called By Hub Panel
-- Theme.SetCustomArt = ArenaIconCustom

do
	local TankTheme = CopyTable(Theme)
	TidyPlatesThemeList[TankThemeName] = TankTheme

	local function ApplyTankCustomization()
		ApplyThemeCustomization(TankTheme)
	end

	local function OnActivateTheme(themeTable)
		if TankTheme == themeTable then
			LocalVars = TidyPlatesHubFunctions:UseTankVariables()
			ApplyTankCustomization()
		end
	end

	TankTheme.OnActivateTheme = OnActivateTheme -- called by Tidy Plates Core, Theme Loader
	TankTheme.OnApplyThemeCustomization = ApplyTankCustomization -- Called By Hub Panel
	TankTheme.ShowConfigPanel = ShowTidyPlatesHubTankPanel
end