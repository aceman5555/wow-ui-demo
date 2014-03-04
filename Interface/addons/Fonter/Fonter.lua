local Fonter = LibStub("AceAddon-3.0"):NewAddon("Fonter", "AceConsole-3.0", "AceEvent-3.0")
local LSM    = LibStub:GetLibrary("LibSharedMedia-3.0")

function Fonter:OnInitialize()
	self:InitializeConfiguration()
	self:InitializeConfigurationGUI()
	self:InitializeFonts()
	self:RegisterEvent("VARIABLES_LOADED", "OnVariablesLoaded")
end

function Fonter:OnVariablesLoaded()
	self:Update()
end

function Fonter:InitializeFonts()
	LSM.RegisterCallback(Fonter, "LibSharedMedia_Registered", "LibSharedMediaCallback")
	LSM.RegisterCallback(Fonter, "LibSharedMedia_SetGlobal" , "LibSharedMediaCallback")

		for k, v in pairs(FonterFonts) do
			LSM:Register("font", k, v, 0xff)
		end
end

function Fonter:LibSharedMediaCallback(Name, MediaType, Key)
	if MediaType == "font" then
		self:Update()
	end
end

function Fonter:Update()
	self:SetBaseFonts()
end

function Fonter:SetFont(Object, Font, Size, Style)
	Object:SetFont(Font, Size, Style)
end

function Fonter:SetBaseFonts()
 local FontCenter         = LSM:Fetch("font", self.db.profile.FontCenter)
 local FontChat           = LSM:Fetch("font", self.db.profile.FontChat)
 local FontDamage         = LSM:Fetch("font", self.db.profile.FontDamage)
 local FontHealth         = LSM:Fetch("font", self.db.profile.FontHealth)
 local FontNamePlate      = LSM:Fetch("font", self.db.profile.FontNamePlate)
 local FontQuest          = LSM:Fetch("font", self.db.profile.FontQuest)
 local FontRaid           = LSM:Fetch("font", self.db.profile.FontRaid)
 local FontScrolling      = LSM:Fetch("font", self.db.profile.FontScrolling)
 local FontStacks         = LSM:Fetch("font", self.db.profile.FontStacks)

 local CenterSize         = self.db.profile.CenterSize
 local ChatSize           = self.db.profile.ChatSize
 local HealthSmall        = self.db.profile.HealthSmall
 local HealthMedium       = self.db.profile.HealthMedium
 local HealthLarge        = self.db.profile.HealthLarge
 local NamePlateSmall     = self.db.profile.NamePlateSmall
 local NamePlateMedium    = self.db.profile.NamePlateMedium
 local NamePlateLarge     = self.db.profile.NamePlateLarge
 local QuestSmall         = self.db.profile.QuestSmall
 local QuestMedium        = self.db.profile.QuestMedium
 local QuestLarge         = self.db.profile.QuestLarge
 local StacksSmall        = self.db.profile.StacksSmall
 local StacksMedium       = self.db.profile.StacksMedium
 local StacksLarge        = self.db.profile.StacksLarge

 local CenterOutline      = self.db.profile.CenterOutline
 local ChatOutline        = self.db.profile.ChatOutline
 local ChatOutline2       = self.db.profile.ChatOutline2
 local HealthOutline      = self.db.profile.HealthOutline
 local HealthOutline2     = self.db.profile.HealthOutline2
 local NamePlateOutline   = self.db.profile.NamePlateOutline
 local NamePlateOutline2  = self.db.profile.NamePlateOutline2
 local QuestOutline       = self.db.profile.QuestOutline
 local QuestOutline2      = self.db.profile.QuestOutline2
 local StacksOutline      = self.db.profile.StacksOutline
 local StacksOutline2     = self.db.profile.StacksOutline2

	self:SetFont(SystemFont_OutlineThick_WTF, FontCenter, CenterSize, CenterOutline)	
	self:SetFont(SystemFont_OutlineThick_Huge2, FontCenter, CenterSize, CenterOutline)
	self:SetFont(SystemFont_OutlineThick_Huge4, FontCenter, CenterSize, CenterOutline)
	self:SetFont(NumberFont_Shadow_Med, FontChat, ChatSize, ChatOutline2)
	self:SetFont(SystemFont_Shadow_Outline_Huge2, FontChat, ChatSize, "OUTLINE")
	self:SetFont(SystemFont_Outline_Small, FontHealth, HealthSmall, HealthOutline)
	self:SetFont(NumberFont_Outline_Huge, FontHealth, HealthLarge, HealthOutline)
	self:SetFont(SystemFont_Large, FontHealth, HealthLarge, HealthOutline2)
	self:SetFont(SystemFont_Tiny, FontHealth, HealthSmall, HealthOutline2)
	self:SetFont(SystemFont_InverseShadow_Small, FontHealth, HealthSmall, HealthOutline2)
	self:SetFont(NumberFont_Shadow_Small, FontHealth, HealthSmall, HealthOutline2)
	self:SetFont(SystemFont_Med3, FontHealth, HealthMedium, HealthOutline2)
	self:SetFont(InvoiceFont_Small, FontNamePlate, NamePlateSmall, NamePlateOutline2)
	self:SetFont(InvoiceFont_Med, FontNamePlate, NamePlateMedium, NamePlateOutline2)
	self:SetFont(NumberFont_OutlineThick_Mono_Small, FontNamePlate, NamePlateMedium, NamePlateOutline)
	self:SetFont(FriendsFont_UserText, FontNamePlate, NamePlateSmall, NamePlateOutline2)
	self:SetFont(FriendsFont_Small, FontNamePlate, NamePlateSmall, NamePlateOutline2)
	self:SetFont(FriendsFont_Normal, FontNamePlate, NamePlateMedium, NamePlateOutline2)
	self:SetFont(FriendsFont_Large, FontNamePlate, NamePlateLarge, NamePlateOutline2)
	self:SetFont(SystemFont_Med1, FontQuest, QuestMedium, QuestOutline2)
	self:SetFont(SystemFont_Med2, FontQuest, QuestMedium + 1, QuestOutline2)
	self:SetFont(SystemFont_Shadow_Med3, FontQuest, QuestMedium, QuestOutline2)
	self:SetFont(QuestFont_Large, FontQuest, QuestLarge, QuestOutline2)
	self:SetFont(QuestFont_Shadow_Huge, FontQuest, QuestLarge + 4, QuestOutline2)
	self:SetFont(MailFont_Large, FontQuest, QuestLarge, QuestOutline2)
	self:SetFont(AchievementFont_Small, FontQuest, QuestSmall, QuestOutline2)
	self:SetFont(ReputationDetailFont, FontQuest, QuestSmall, QuestOutline2)
	self:SetFont(SystemFont_Small, FontQuest, QuestSmall, QuestOutline2)	
	self:SetFont(SystemFont_Shadow_Huge1, FontRaid, 40, nil)
	self:SetFont(SystemFont_Shadow_Huge3, FontScrolling, 20, nil)
	self:SetFont(SpellFont_Small, FontStacks, StacksSmall, StacksOutline2)
	self:SetFont(NumberFont_Outline_Med, FontStacks, StacksMedium, StacksOutline)
	self:SetFont(GameTooltipHeader, FontStacks, StacksMedium, StacksOutline2)
	self:SetFont(Tooltip_Small, FontStacks, StacksSmall, StacksOutline2)
	self:SetFont(Tooltip_Med, FontStacks, StacksMedium, StacksOutline2)
	self:SetFont(NumberFont_Outline_Large, FontStacks, StacksLarge, StacksOutline)
	self:SetFont(SystemFont_Shadow_Small, FontStacks, StacksSmall, StacksOutline2)
	self:SetFont(SystemFont_Shadow_Med1, FontStacks, StacksMedium, StacksOutline2)
	self:SetFont(SystemFont_Shadow_Large, FontStacks, StacksLarge, StacksOutline2)

	STANDARD_TEXT_FONT = FontHealth
	UNIT_NAME_FONT     = FontNamePlate
	DAMAGE_TEXT_FONT   = FontDamage
	NAMEPLATE_FONT     = FontNamePlate
	CHAT_FONT_HEIGHTS  = { 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34 }

		for i = 1, 8 do
			local Frame = _G["ChatFrame"..i]
			local Font, Size = Frame:GetFont()
			Frame:SetFont(FontChat, Size, ChatOutline)
	end
end