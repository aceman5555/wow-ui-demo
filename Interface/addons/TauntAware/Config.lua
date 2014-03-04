local AddonName, TA = ...
local _

-- Config Panel Text Strings
TA.Text={
Title = "Taunt Aware",
TitleSub = "Change how Taunt Aware behaves by setting the options below",
Enable = "Enable the Add On to function",
Solo = "Enable alerts when you are playing solo",
Full = "Enable full warnings (if you are not a tank)",
AlertSound = "Play a sound when you get a taunt alert",
MF = "Use the Message Frame instead of chat for alerts",
MFAutoScale = "Enable message frame to auto scale to an effective scale of 1 (+/-)",
MFScale = "Percentage scale of the message frame [50 - 300]",
FontSize = "Font Size in message frame                 ",
FadeDelay  = "                            How long the messages display in the frame [1-60 secs]",
TauntsOnly = "Select how to react to high threat actions ( on = ignore, off = tattle, monitor = just alert yourself )",
PetTaunts = "Select how to react to pet taunts ( on = full alerts, off = no alerts, mute = alert w/o sound )",
Links = "Show skill links instead of just skill names",
Scan = "Scan the group for threat increasing abilities when members change",
ScanDelay = "                                    Wait how long after members change for the scan [1-60 secs]",
Tattle = "Alert other people when fight is over to taunts used by non tanks",
TatMode = "How to send the alert [GROUP/WHISPER/SUMMARY](Summary just outputs to you)",
}

-- Bill's Utils
local ChkBox = BillsUtils.ChkBox
local ChkBoxSave = BillsUtils.ChkBoxSave
local CheckClick = BillsUtils.CheckClick
local SliderSave = BillsUtils.SliderSave
local SliderMW = BillsUtils.SliderMW
local Slider = BillsUtils.Slider
local SliderEditBox = BillsUtils.SliderEditBox

BillsUtils.Locals[#BillsUtils.Locals +1] = function ()
	ChkBox = BillsUtils.ChkBox
	ChkBoxSave = BillsUtils.ChkBoxSave
	CheckClick = BillsUtils.CheckClick
	SliderSave = BillsUtils.SliderSave
	SliderMW = BillsUtils.SliderMW
	Slider = BillsUtils.Slider
	SliderEditBox = BillsUtils.SliderEditBox
end


local X = 16 -- standard Horizontal Spacing
local Y = 35 -- standard Vertical spacing 26
local TxtY = 13



-- General Settings / functions
local TAS = TauntAware_Settings
local TAD

TA.ConfigFrame = CreateFrame("Frame")
TA.ConfigFrame:RegisterEvent("ADDON_LOADED")

TA.ConfigFrame:SetScript("OnEvent",function(self, event, ...)
	local arg = ...
	if event ~= "ADDON_LOADED" and arg ~= AddonName then return end
	TAS = TA.TAS
	TAD = TA.TAD
end)

TA.Checkclick = function()
	PlaySound( "GAMEGENERICBUTTONPRESS" )
end

local PlayTestSound = function( sound )
	local file
	if sound >= 2 and sound <= 9 then
		file = "Interface\\AddOns\\TauntAware\\Alert"..tostring(sound - 1)..".mp3"
	elseif sound == 10 then
		file = "Interface\\AddOns\\TauntAware_CustomSounds\\custom.mp3"
	elseif sound == 11 then
		file = "Interface\\AddOns\\TauntAware_CustomSounds\\custom.ogg"
	else
		return
	end
	PlaySoundFile( file, "Master" )
end

local DDSettings = {
			AlertSound ={	Modes = {"off", "alert1.mp3", "alert2.mp3", "alert3.mp3", "alert4.mp3", "alert5.mp3", "alert6.mp3", "alert7.mp3", "alert8.mp3", "custom.mp3", "custom.ogg" },
							Checked = false
						},
			TauntsOnly ={	Modes = {"on", "off", "monitor"},
							Checked = false
						},
			PetTaunts  ={	Modes = {"on", "off", "mute"},
							Checked = false
						},
			TatMode    ={	Modes = {"GROUP", "WHISPER", "SUMMARY"},
							Checked = false
						},
					}

-- DropDown Menu Functions
local function OnClick(self, arg1, arg2)
	local name = string.sub( UIDROPDOWNMENU_OPEN_MENU:GetName(), 14)
	print(name)
	UIDropDownMenu_SetSelectedID( UIDROPDOWNMENU_OPEN_MENU, arg1, arg2 )
	DDSettings[name].Checked = arg1
	if name == "AlertSound" then
		PlayTestSound( arg1 )
	end
end

local function initialize(self, level)
	local name = string.sub( UIDROPDOWNMENU_INIT_MENU:GetName(), 14)
	local info
	for count = 1, #DDSettings[name].Modes  do
		if not( DDSettings[name].Checked ) and TAS[name] == DDSettings[name].Modes[count] then
			DDSettings[name].Checked = count
		end
		info = UIDropDownMenu_CreateInfo()
		info.text = DDSettings[name].Modes[count]
		info.arg1 = count
		info.checked = self:GetID() == DDSettings[name].Checked 
		info.func = OnClick
		UIDropDownMenu_AddButton(info, level)
	end
	
	UIDropDownMenu_SetSelectedID( UIDROPDOWNMENU_INIT_MENU , DDSettings[name].Checked  ) 
end

--Panel
TA.panel = CreateFrame( "Frame", "TauntAwareConfig", UIParent )
TA.panel2 = CreateFrame( "Frame", "TauntAwareConfig2", TA.Panel)
local me = TA.panel
local me2 = TA.panel2
me2:SetSize(500, 360)
me2:SetPoint("BOTTOMRIGHT", me, "BOTTOMRIGHT")
me:SetScript("OnLoad", function()
	me.init()
end)


me.name = "Taunt Aware"

-- Panel title
local Title = me:CreateFontString( nil, "ARTWORK", "GameFontNormalLarge" )
Title:SetPoint( "TOPLEFT", 16, -16 )
Title:SetText( TA.Text.Title )
local SubText = me:CreateFontString( nil, "ARTWORK", "GameFontHighlightSmall" )
SubText:SetPoint( "TOPLEFT", Title, "BOTTOMLEFT", 0, -8 )
SubText:SetPoint( "RIGHT", -32, 0 )
SubText:SetHeight( 32 )
SubText:SetJustifyH( "LEFT" )
SubText:SetJustifyV( "TOP" )
SubText:SetText( TA.Text.TitleSub )

-- Scroll Frame
me.ScrollFrame = CreateFrame("ScrollFrame", "TaumtAwareConfigScrollFrame", me, "UIPanelScrollFrameTemplate")
me.ScrollFrame:SetScrollChild(me2)
me.ScrollFrame:SetPoint("TOPRIGHT", me ,"TOPRIGHT", -30,- 64)
me.ScrollFrame:SetPoint("BOTTOMRIGHT", me ,"BOTTOMRIGHT", -30, 10)
me.ScrollFrame:SetPoint("BOTTOMLEFT", me ,"BOTTOMLEFT", 30, 10)

-- Check Boxes & Text
local last = me2
local Command = {"Enable", "Solo", "Full",}
for x = 1, #Command do
	me[ Command[x] ] = ChkBox( last , "TauntAwareCfg", Command[x] , me2, CheckClick, TA.Text )
	last = me[ Command[x] ]
end



-- AlertSound
local AlertSoundText = me2:CreateFontString( nil, "ARTWORK", "GameFontHighlightSmall" )
AlertSoundText:SetPoint( "TOPLEFT", last, "BOTTOMLEFT", 0, -0 )
AlertSoundText:SetPoint( "RIGHT", -32, 0 )
AlertSoundText:SetHeight( 32 )
AlertSoundText:SetJustifyH( "LEFT" )
AlertSoundText:SetJustifyV( "CENTER" )
AlertSoundText:SetText( TA.Text.AlertSound )

last = AlertSoundText

me.AlertSound = CreateFrame("Button", "TauntAwareCfgAlertSound", me2, "UIDropDownMenuTemplate") 
me.AlertSound.displayMode = "MENU"
me.AlertSound:ClearAllPoints()
me.AlertSound:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, 0)
UIDropDownMenu_Initialize( me.AlertSound, initialize)
UIDropDownMenu_SetWidth( me.AlertSound, 100);
UIDropDownMenu_SetButtonWidth( me.AlertSound, 124)
UIDropDownMenu_JustifyText( me.AlertSound, "LEFT")
		
last = me.AlertSound

-- Message Frame Check Box
me.MF = ChkBox( last , "TauntAwareCfg", "MF" , me2, CheckClick, TA.Text )
last = me.MF

-- Message Frame Auto Scale Check Box
me.MFAutoScale = ChkBox( last , "TauntAwareCfg", "MFAutoScale" , me2, CheckClick, TA.Text )
last = me.MFAutoScale

-- Message Frame Scale Slider
me.MFScale = Slider( last , "TauntAwareCfg", "MFScale", me2 , SliderMW , TA.Text, 50, 300, 1 )
last = me.MFScale
me.MFScale.Val = SliderEditBox( last , "TauntAwareCfg", "MFScale", me2 )


local FontSizeDemo
local SliderFontSize = function(self, delta)
	local min,max = self:GetMinMaxValues()
	local step = self:GetValueStep()
	local value = self:GetValue()

	if delta < 0 then 
		value = value - step
	elseif delta > 0 then
		value = (value + step)
	end
	if value < min then
		value = min
	elseif value > max then
		value = max
	end
	self:SetValue( value )
	FontSizeDemo:SetFont( STANDARD_TEXT_FONT, value )
	FontSizeDemo:SetText( "Font Size Demo "..tostring(value) )
end
	
me.FontSize = Slider( last , "TauntAwareCfg", "FontSize", me2 , SliderFontSize , TA.Text, 7, 24, 1 )
me.FontSize:SetScript( "OnValueChanged", function( self )
	local val = self:GetValue()
	self.Val:SetNumber( val )
	FontSizeDemo:SetFont( STANDARD_TEXT_FONT, val )
	FontSizeDemo:SetText( "Font Size Demo "..tostring( val ) )
	PlaySound( "GAMEGENERICBUTTONPRESS" )
end)
	
last = me.FontSize
me.FontSize.Val = SliderEditBox( last , "TauntAwareCfg", "FontSize", me2 )
	
FontSizeDemo = me2:CreateFontString( "TauntAwareFontSizeDemo", "ARTWORK")
FontSizeDemo:SetFont( STANDARD_TEXT_FONT, 10 )
FontSizeDemo:SetPoint( "TOPLEFT", last, "BOTTOMLEFT", 0, -0 )
FontSizeDemo:SetPoint( "RIGHT", -32, 0 )
FontSizeDemo:SetHeight( 32 )
FontSizeDemo:SetJustifyH( "LEFT" )
FontSizeDemo:SetJustifyV( "CENTER" )
FontSizeDemo:SetText( "Font Size Demo" )

last = FontSizeDemo

me.FadeDelay = Slider( last , "TauntAwareCfg", "FadeDelay", me2 , SliderMW , TA.Text, 1, 60, 1 )
last = me.FadeDelay
me.FadeDelay.Val = SliderEditBox( last , "TauntAwareCfg", "FadeDelay", me2 )

--"TauntsOnly"
local TauntsOnlyText = me2:CreateFontString( nil, "ARTWORK", "GameFontHighlightSmall" )
TauntsOnlyText:SetPoint( "TOPLEFT", last, "BOTTOMLEFT", 0, -0 )
TauntsOnlyText:SetPoint( "RIGHT", -32, 0 )
TauntsOnlyText:SetHeight( 32 )
TauntsOnlyText:SetJustifyH( "LEFT" )
TauntsOnlyText:SetJustifyV( "CENTER" )
TauntsOnlyText:SetText( TA.Text.TauntsOnly )

last = TauntsOnlyText

me.TauntsOnly = CreateFrame("Button", "TauntAwareCfgTauntsOnly", me2, "UIDropDownMenuTemplate")
me.TauntsOnly.displayMode = "MENU"
me.TauntsOnly:ClearAllPoints()
me.TauntsOnly:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, 0)
UIDropDownMenu_Initialize( me.TauntsOnly, initialize)
UIDropDownMenu_SetWidth( me.TauntsOnly, 100);
UIDropDownMenu_SetButtonWidth( me.TauntsOnly, 124)
UIDropDownMenu_JustifyText( me.TauntsOnly, "LEFT")
		
last = me.TauntsOnly

-- "PetTaunts" 
local PetTauntsText = me2:CreateFontString( nil, "ARTWORK", "GameFontHighlightSmall" )
PetTauntsText:SetPoint( "TOPLEFT", last, "BOTTOMLEFT", 0, -0 )
PetTauntsText:SetPoint( "RIGHT", -32, 0 )
PetTauntsText:SetHeight( 32 )
PetTauntsText:SetJustifyH( "LEFT" )
PetTauntsText:SetJustifyV( "CENTER" )
PetTauntsText:SetText( TA.Text.PetTaunts )

last = PetTauntsText

me.PetTaunts = CreateFrame("Button", "TauntAwareCfgPetTaunts", me2, "UIDropDownMenuTemplate")
me.PetTaunts.displayMode = "MENU"
me.PetTaunts:ClearAllPoints()
me.PetTaunts:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, 0)
UIDropDownMenu_Initialize( me.PetTaunts, initialize)
UIDropDownMenu_SetWidth( me.PetTaunts, 100);
UIDropDownMenu_SetButtonWidth( me.PetTaunts, 124)
UIDropDownMenu_JustifyText( me.PetTaunts, "LEFT")
		
last = me.PetTaunts

Command = { "Links", "Scan"}
for x = 1, #Command do
	me[ Command[x] ] = ChkBox( last , "TauntAwareCfg", Command[x] , me2, CheckClick, TA.Text )
	last = me[ Command[x] ]
end
	
me.ScanDelay = Slider( last , "TauntAwareCfg", "ScanDelay", me2 , SliderMW , TA.Text, 1, 60, 1 )
last = me.ScanDelay
me.ScanDelay.Val = SliderEditBox( last , "TauntAwareCfg", "ScanDelay", me2 )
	
me.Tattle = ChkBox( last , "TauntAwareCfg", "Tattle" , me2, CheckClick, TA.Text )
last = me.Tattle

-- "TatMode"
local TatModeText = me2:CreateFontString( nil, "ARTWORK", "GameFontHighlightSmall" )
TatModeText:SetPoint( "TOPLEFT", last, "BOTTOMLEFT", 0, -0 )
TatModeText:SetPoint( "RIGHT", -32, 0 )
TatModeText:SetHeight( 32 )
TatModeText:SetJustifyH( "LEFT" )
TatModeText:SetJustifyV( "CENTER" )
TatModeText:SetText( TA.Text.TatMode )

last = TatModeText

me.TatMode = CreateFrame("Button", "TauntAwareCfgTatMode", me2, "UIDropDownMenuTemplate")
me.TatMode.displayMode = "MENU"
me.TatMode:ClearAllPoints()
me.TatMode:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, 0)
UIDropDownMenu_Initialize( me.TatMode, initialize)
UIDropDownMenu_SetWidth( me.TatMode, 100);
UIDropDownMenu_SetButtonWidth( me.TatMode, 124)
UIDropDownMenu_JustifyText( me.TatMode, "LEFT")
		
last = me.TatMode

--	End of frame

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-- X  Init / Reset the config panel to match current settings                                                     X
-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--

me.Init = function(...)
	me.Enable:SetChecked( TAS.Enable )
	me.Solo:SetChecked( TAS.Solo )
	me.Full:SetChecked( TAS.Full )
	DDSettings.AlertSound.Checked = false
	ToggleDropDownMenu( nil, nil, me.AlertSound ) 
	ToggleDropDownMenu( nil, nil, me.AlertSound )
	me.MF:SetChecked( TAS.MF )
	me.MFAutoScale:SetChecked( TAS.MFAutoScale )
	me.MFScale:SetValue( TAS.MFScale)
	me.MFScale.Val:SetCursorPosition( 0 )
	me.MFScale.Val:SetNumber( TAS.MFScale )
	me.FadeDelay:SetValue( TAS.FadeDelay)
	me.FadeDelay.Val:SetCursorPosition( 0 )
	me.FadeDelay.Val:SetNumber( TAS.FadeDelay )
	me.FontSize:SetValue( TAS.FontSize)
	me.FontSize.Val:SetCursorPosition( 0 )
	me.FontSize.Val:SetNumber( TAS.FontSize )
	DDSettings.TauntsOnly.Checked = false
	ToggleDropDownMenu( nil, nil, me.TauntsOnly ) 
	ToggleDropDownMenu( nil, nil, me.TauntsOnly )
	DDSettings.PetTaunts.Checked = false
	ToggleDropDownMenu( nil, nil, me.PetTaunts ) 
	ToggleDropDownMenu( nil, nil, me.PetTaunts )
	me.Links:SetChecked( TAS.Links )
	me.Scan:SetChecked( TAS.Scan )
	me.ScanDelay:SetValue( TAS.ScanDelay)
	me.ScanDelay.Val:SetCursorPosition( 0 )
	me.ScanDelay.Val:SetNumber( TAS.ScanDelay )
	me.Tattle:SetChecked( TAS.Tattle )
	DDSettings.TatMode.Checked = false
	ToggleDropDownMenu( nil, nil, me.TatMode ) 
	ToggleDropDownMenu( nil, nil, me.TatMode )
end

-- Reset config panel and settings to DEFAULT
me.Reset = function(...)
	local Command = {"Enable", "Solo", "Full","AlertSound", "MF", "MFAutoScale", "MFScale", "FontSize",
					 "FadeDelay", "TauntsOnly", "PetTaunts", "AlertTauntsOnly", "TattleTauntsOnly",
					 "Links", "Scan", "ScanDelay", "Tattle", "TatMode"}
	for x = 1, #Command do
		TAS.Command[x] = TAD.Command[x]
	end
	me.Init()
end



me.refresh = function(self)
	me.Init()
end

me.default = function (self)
	me.Reset()
end

me.cancel = function (self)
	me.Init()
end


-- Save settings from config panel
me.okay = function(self)
	local Command = {"Enable", "Solo", "Full", "MF", "MFAutoScale", "Links", "Scan", "Tattle"}
	for x = 1, #Command do
		ChkBoxSave( me, Command[x], TAS)
	end
	SliderSave( me, "MFScale", TAS) 
	SliderSave( me, "FontSize", TAS) 
	SliderSave( me, "FadeDelay", TAS)
	SliderSave( me, "ScanDelay", TAS)
	
	local Command = {"AlertSound", "TauntsOnly", "PetTaunts", "TatMode"}
	for x = 1, #Command do
		if TAS[Command[x]] ~= DDSettings[Command[x]].Modes[DDSettings[Command[x]].Checked] then
			TAS[Command[x]] = DDSettings[Command[x]].Modes[DDSettings[Command[x]].Checked]
		end
	end
	TA.SettingsUpdate()
end

-- Register the config panel
InterfaceOptions_AddCategory( me )
