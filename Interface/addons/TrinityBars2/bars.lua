local currentVersion = "20400.7"

--[[ Global Variables Declarations ]]--

TrinityBars2 = {}

TrinityBars2.SelfCastOptions = {
	[TRINITYBARS2_STRINGS.SELFCAST_1] = 1,
	[TRINITYBARS2_STRINGS.SELFCAST_2] = 2,
	[TRINITYBARS2_STRINGS.SELFCAST_3] = 3,
	[TRINITYBARS2_STRINGS.SELFCAST_4] = 4,
	[TRINITYBARS2_STRINGS.SELFCAST_5] = 5,
}

TrinityBars2.ButtonStyles = {}

TrinityBars2SavedState = {

	docks = {},
	buttons = {},
	pet = {},
	class = {},
	bag = {},
	menu = {},
	spellBindings = {},
	macroBindings = {},
	classBar = {},
	skinPlugins = {},
	globalColor = { 1,1,1 },
	options = {
		["CheckButtons"] = {
			[101] = 1,
			[102] = 1,
			[104] = 1,
			[202] = 1,
			[301] = 1,
			[302] = 1,
			[303] = 1,
		},
	},
	debug = {},
	firstRun = true,
	convertBindings = true,
	buttonGridShow = false,
	buttonLock = false,
	modifierButtonLock = false,
	bindingTextHidden = false,
	showButtonTooltips = true,
	selfCastOption = 1,
	cooldownAlpha = 1,
	autocastAlpha = 1,
	buttonStyle = 3,
	selfCastOption = 1,
	containerOffsetX = 0,
	containerOffsetY = 70,
	containerScale = 1,
	fadeSpeed = 0.5,
	savedVersion = "unknown",
	registerForClicks = "up",

}

TrinityBars2Templates = {}

TrinityBars2MacroMaster = {}

--[[ Local Variable Declarations ]]--

local dockIndex = {}
local dockNames = {}
local dockingData = {};	dockingData.anchorPlaced = {}; dockingData.placed = {};	dockingData.last = {}; dockingData.buttonList = {}

local buttonIndex = {}
local petButtonIndex = {}
local classButtonIndex = {}
local bagButtonIndex = {}
local menuButtonIndex = {}

local spellIndex = {}
local macroIconIndex = {}

local autohideIndex = {}
local alphaupIndex = {}
local checkButtons = {}

local dedBars = {}; dedBars.docks = {}
local unitBuffs = {}; unitBuffs.player = {}; unitBuffs.target = {}; unitBuffs.focus = {}

local TRINITYBARS2_STRINGS = TRINITYBARS2_STRINGS

local targetNames = { "none", "player", "pet", "target", "targettarget", "focus", "mouseover", "party1", "party2", "party3", "party4" }
local headerNames = { "Normal", "Actionbar", "Stance" }
local mainBarTypes = { "Normal", "Paged", "Stance" }
local frameStratas = { "BACKGROUND", "LOW", "MEDIUM", "HIGH", "DIALOG", "TOOLTIP" }
local barShapes = { [0] = TRINITYBARS2_STRINGS.BARSHAPE_1, [1] = TRINITYBARS2_STRINGS.BARSHAPE_2, [2] = TRINITYBARS2_STRINGS.BARSHAPE_3, [3] = TRINITYBARS2_STRINGS.BARSHAPE_4, [4] = TRINITYBARS2_STRINGS.BARSHAPE_5 }
local charSlots = { [0] = "AmmoSlot", [1] = "HeadSlot", [2] = "NeckSlot", [3] = "ShoulderSlot", [4] = "ShirtSlot", [5] = "ChestSlot", [6] = "WaistSlot", [7] = "LegsSlot", [8] = "FeetSlot", [9] = "WristSlot", [10] = "HandsSlot", [11] = "Finger0Slot", [12] = "Finger1Slot", [13] = "Trinket0Slot", [14] = "Trinket1Slot", [15] = "BackSlot", [16] = "MainHandSlot", [17] = "SecondaryHandSlot", [18] = "RangedSlot", [19] = "TabardSlot" }
local arcPresets = { { TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1_1, 173, 180 }, { TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1_2, 353, 180 }, { TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1_3, 262, 180 }, { TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1_4, 82, 180 }, { TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1_5, 90, 359 } }
local powerColors = { Mana = { r = 0.4, g = 0.4, b = 1.00 }, Rage = { r = 1.00, g = 0.2, b = 0.2 },	Focus = { r = 1.00, g = 0.50, b = 0.25 }, Energy = { r = 1.00, g = 1.00, b = 0.00 } }
local buttonTypes = { TRINITYBARS2_STRINGS.BUTTON_TYPE1, TRINITYBARS2_STRINGS.BUTTON_TYPE2, TRINITYBARS2_STRINGS.BUTTON_TYPE3, TRINITYBARS2_STRINGS.BUTTON_TYPE4, TRINITYBARS2_STRINGS.BUTTON_TYPE5 }
local alphaUp = { TRINITYBARS2_STRINGS.ALPHAUP_NONE, TRINITYBARS2_STRINGS.ALPHAUP_BATTLE, TRINITYBARS2_STRINGS.ALPHAUP_MOUSEOVER, TRINITYBARS2_STRINGS.ALPHAUP_BATTLEMOUSE, TRINITYBARS2_STRINGS.ALPHAUP_RETREAT, TRINITYBARS2_STRINGS.ALPHAUP_RETREATMOUSE }

local useStates, playerEnteredWorld, combatLockdown, debugActive, slotPickup = false, false, false, false, false
local alphaTimer, alphaDir, autocastAlpha, cooldownAlpha, fadeSpeed = 0, 0, 1, 1, 0.5
local keyBindButton, keyBindSpell, keyBindMacro = 0, nil, nil
local macroDrag, macroDragIcon = nil, nil

--[[ Local Copies of Often Used Globals ]]--

local gsub = string.gsub
local find = string.find
local match = string.match
local gmatch = string.gmatch
local format = string.format
local lower = string.lower
local upper = string.upper
local floor = math.floor
local ceil = math.ceil

local GetTime = _G.GetTime
local UnitBuff = _G.UnitBuff
local UnitDebuff = _G.UnitDebuff
local UnitMana = _G.UnitMana
local MouseIsOver = _G.MouseIsOver

local tooltipScan = Trinity2TooltipScan
local tooltipScanTextLeft2 = Trinity2TooltipScanTextLeft2

--[[ Local Utility Functions ]]--

local function clearTable(table)

	if (table) then
		for k in pairs(table) do
			table[k] = nil
		end
	end
end

local function copyTable(table)

	if (table == nil) then
		return
	end

	if (type(table) ~= "table") then
		return
	end

	local data = {}

	for k, v in pairs (table) do

		if (type(v) == "table") then
			data[k] = copyTable(v)
		else
			data[k] = v
		end
	end

	return data
end

local defaultSavedState = copyTable(TrinityBars2SavedState)

local function getChildrenAndRegions(frame)

	if (frame == nil) then
		return
	end

	local data, childData = {}, {}
	local children, regions = { frame:GetChildren() }, { frame:GetRegions() }

	for k,v in pairs(children) do

		tinsert(data, v:GetName())

		childData = getChildrenAndRegions(v)

		for key,value in pairs(childData) do
			tinsert(data, value)
		end
	end

	for k,v in pairs(regions) do
		tinsert(data, v:GetName())
	end

	return data
end

local function print(msg)

	if (TrinDev) then
		DEFAULT_CHAT_FRAME:AddMessage(msg)
	end
end

local function createSkinConfig(dockFrame)

	local count = 1;
	local array = {}

	for k,v in pairs(TrinityBars2.buttonSkins) do
		array[count] = k
		count = count + 1
	end

	table.sort(array)

	return array;
end

local function updateSpellIndex()

	clearTable(spellIndex)

	local i = 1

	repeat
		spellName, spellRank = GetSpellName(i, "spell")

   		if (spellName) then

   			spellName = lower(spellName)
   			spellRank = lower(spellRank)

   			local rank = tonumber(match(spellRank, "%d+")) or 0

			spellIndex[spellName.."("..spellRank..")"] = { i, rank, spellRank }

			if (not spellIndex[spellName]) then
				spellIndex[spellName] = { i, rank, spellRank }
			elseif (rank > spellIndex[spellName][2]) then
				spellIndex[spellName] = { i, rank, spellRank }
			end
   		end

   		i = i + 1

   	until (not spellName)
end

local function getPowertypeAmount(self)

	tooltipScan:SetOwner(self, "ANCHOR_NONE")

	if (self.config.type == "action") then

		tooltipScan:SetAction(self.config.action)

	elseif (self.config.type == "spell") then

		local spell = lower(self.config.spell..self.config.spellranktext or "")

		if (spellIndex[spell]) then
			tooltipScan:SetSpell(spellIndex[spell][1], "spell")
		end
	end

	local amount, powerType, text = nil, nil, tooltipScanTextLeft2:GetText()

	if (text) then
		amount, powerType = match(tooltipScanTextLeft2:GetText(), "(%d+)%s(%a+)")
	end

	if (amount and powerType) then
		return tonumber(amount), powerType
	else
		return
	end
end

local function updateMacroIconIndex()

	clearTable(macroIconIndex)

	for i=1,GetNumMacroIcons() do
		macroIconIndex[i] = GetMacroIconInfo(i)
	end
end

local function setMainMenuBarBackpackButton(count)

	if (count == 1) then
		MainMenuBarBackpackButton:SetScript("OnClick", function() OpenAllBags() end)
	else
		MainMenuBarBackpackButton:SetScript("OnClick", function() if (IsShiftKeyDown()) then OpenAllBags() else ToggleBackpack() end end);
	end
end

local function updateButtonData(dockFrame, button)

	button.dockFrame = dockFrame
	button.alpha = dockFrame.config.alpha

	button.skincolor = dockFrame.config.skincolor
	button.rangecolor = dockFrame.config.rangecolor
	button.manacolor = dockFrame.config.manacolor
	button.buffcolor = dockFrame.config.buffcolor
	button.debuffcolor = dockFrame.config.debuffcolor
	button.hovercolor = dockFrame.config.hovercolor
	button.equipcolor = dockFrame.config.equipcolor

	button.cdcolornorm = dockFrame.config.cdcolornorm
	button.cdcolorlarge = dockFrame.config.cdcolorlarge

	button.bdcolornorm = dockFrame.config.bdcolornorm
	button.bdcolorlarge = dockFrame.config.bdcolorlarge

	button.hasAction = dockFrame.hasAction
	button.noAction = dockFrame.noAction
end

local function setDefaultButtonSkin(button)

	local array

	button.skin = "Square (Blizz Default)"

	button:SetNormalTexture(TrinityBars2.buttonSkins[button.skin]["NormalTexture"])
	button.normaltexture:SetWidth(TrinityBars2.buttonSkins[button.skin]["NormalTextureW"])
	button.normaltexture:SetHeight(TrinityBars2.buttonSkins[button.skin]["NormalTextureH"])

	button.border:SetTexture(TrinityBars2.buttonSkins[button.skin]["Border"])
	button.border:SetWidth(TrinityBars2.buttonSkins[button.skin]["BorderW"])
	button.border:SetHeight(TrinityBars2.buttonSkins[button.skin]["BorderH"])

	button:SetHighlightTexture(TrinityBars2.buttonSkins[button.skin]["HighlightTexture"])
	button.highlighttexture:SetWidth(TrinityBars2.buttonSkins[button.skin]["HighlightTextureW"])
	button.highlighttexture:SetHeight(TrinityBars2.buttonSkins[button.skin]["HighlightTextureH"])

	button.bindframe:SetHighlightTexture(TrinityBars2.buttonSkins[button.skin]["HighlightTexture"])
	if (button.editframe) then
		button.editframe:SetHighlightTexture(TrinityBars2.buttonSkins[button.skin]["HighlightTexture"])
	end

	button:SetCheckedTexture(TrinityBars2.buttonSkins[button.skin]["CheckedTexture"])
	button.checkedtexture:SetWidth(TrinityBars2.buttonSkins[button.skin]["CheckedTextureW"])
	button.checkedtexture:SetHeight(TrinityBars2.buttonSkins[button.skin]["CheckedTextureH"])

	button:SetPushedTexture(TrinityBars2.buttonSkins[button.skin]["PushedTexture"])
	button.pushedtexture:SetWidth(TrinityBars2.buttonSkins[button.skin]["PushedTextureW"])
	button.pushedtexture:SetHeight(TrinityBars2.buttonSkins[button.skin]["PushedTextureH"])
	button.pushedtexture:SetBlendMode(TrinityBars2.buttonSkins[button.skin]["PushedBlendMode"])

	button.sheen:SetTexture(TrinityBars2.buttonSkins[button.skin]["SheenTexture"])
	button.sheen:SetWidth(TrinityBars2.buttonSkins[button.skin]["SheenTextureW"])
	button.sheen:SetHeight(TrinityBars2.buttonSkins[button.skin]["SheenTextureH"])

	button.iconframe:SetWidth(TrinityBars2.buttonSkins[button.skin]["IconFrameW"])
	button.iconframe:SetHeight(TrinityBars2.buttonSkins[button.skin]["IconFrameH"])

	array = TrinityBars2.buttonSkins[button.skin]["IconFrameCooldownTL"]
	button.iconframecooldown:SetPoint("TOPLEFT", array[1], array[2])

	array = TrinityBars2.buttonSkins[button.skin]["IconFrameCooldownBR"]
	button.iconframecooldown:SetPoint("BOTTOMRIGHT", array[1], array[2])

	array = TrinityBars2.buttonSkins[button.skin]["IconFrameIconTexCoord"]
	button.iconframeicon:SetTexCoord(array[1], array[2], array[3], array[4])

	button.hotkey:SetTextHeight(TrinityBars2.buttonSkins[button.skin]["HotKeyHeight"])
	array = TrinityBars2.buttonSkins[button.skin]["HotKeySetPoint"]
	button.hotkey:ClearAllPoints()
	button.hotkey:SetPoint(array[1], array[2], array[3])

	button.count:SetTextHeight(TrinityBars2.buttonSkins[button.skin]["CountTextHeight"])
	array = TrinityBars2.buttonSkins[button.skin]["CountTextSetPoint"]
	button.count:ClearAllPoints()
	button.count:SetPoint(array[1], array[2], array[3])

end

--[[ Frame Creation Functions ]]--

local function createPetButtons()

	local button, buttonName, objects

	for i=1,12 do

		if (i < 11) then
			button = CreateFrame("CheckButton", "TrinityPetButton"..i, UIParent, "TrinityPetButtonTemplate")
			buttonName = button:GetName()
			button:SetID(i)
		else
			button = CreateFrame("CheckButton", "TrinityPetButton"..i, UIParent, "TrinityPossessButtonTemplate")
			buttonName = button:GetName()
			button:SetID(i-10)
		end

		button.id = i

		objects = getChildrenAndRegions(button)

		for k,v in pairs(objects) do
			local name = gsub(v, button:GetName(), "")

			if (lower(name) == "normaltexture2") then
				name = "normaltexture"
			end

			button[lower(name)] = _G[v]
		end

		button.normaltexture:SetPoint("CENTER", 0, 0)
		button.bindframe:SetID(i)
		button.editframe:SetPoint("TOPLEFT")
		button.editframe:SetPoint("BOTTOMRIGHT")

		if (i < 11) then
			button.editframetype:SetText("pet")
		else
			button.editframetype:SetText("poss.")
		end

		button.config = {
			["dock"] = "",
			["dockpos"] = 0,
			["homedock"] = "pet",
			["showstate"] = "",
			["laststate"] = "",
			["HotKey1"] = "",
			["HotKeyText1"] = "",
			["element"] = buttonName,
			["scale"] = 1,
			["XOffset"] = 0,
			["YOffset"] = 0,
			["target"] = "none",
			["spell"] = "",
			["mouseover anchor"] = false,
			["click anchor"] = false,
			["anchordelay"] = "0.1",
			["anchoredheader"] = "",
		}

		if (TrinityBars2SavedState.firstRun) then
			TrinityBars2SavedState.pet[i] = { button.config }
		end

		petButtonIndex[i] = button

		TrinityBars2Options_Storage.data["petButtonIndex"][tonumber(i)] = 0;
	end
end

local function createClassButtons()

	local button, buttonName, objects

	for i=1,10 do

		button = CreateFrame("CheckButton", "TrinityClassButton"..i, UIParent, "TrinityClassButtonTemplate")
		buttonName = button:GetName()
		button:SetID(i)
		button.id = i

		objects = getChildrenAndRegions(button)

		for k,v in pairs(objects) do
			local name = gsub(v, button:GetName(), "")
			button[lower(name)] = _G[v]
		end

		button.bindframe:SetID(i)
		button.editframe:SetPoint("TOPLEFT")
		button.editframe:SetPoint("BOTTOMRIGHT")
		button.editframetype:SetText("class")

		button.config = {
			["dock"] = "",
			["dockpos"] = 0,
			["homedock"] = "class",
			["showstate"] = "",
			["laststate"] = "",
			["HotKey1"] = "",
			["HotKeyText1"] = "",
			["element"] = buttonName,
			["scale"] = 1,
			["XOffset"] = 0,
			["YOffset"] = 0,
			["target"] = "none",
			["spell"] = "",
			["mouseover anchor"] = false,
			["click anchor"] = false,
			["anchordelay"] = "0.1",
			["anchoredheader"] = "",
		}

		if (TrinityBars2SavedState.firstRun) then
			TrinityBars2SavedState.class[i] = { button.config }
		end

		classButtonIndex[i] = button

		TrinityBars2Options_Storage.data["classButtonIndex"][tonumber(i)] = 0;
	end
end

local function createBagButtons()

	local button, buttonName, objects

	local defaultElements = {
		[5] = MainMenuBarBackpackButton,
		[4] = CharacterBag0Slot,
		[3] = CharacterBag1Slot,
		[2] = CharacterBag2Slot,
 		[1] = CharacterBag3Slot,
 	}

	for i=1,#defaultElements do

		button = CreateFrame("CheckButton", "TrinityBagButton"..i, UIParent, "TrinityAnchorButtonTemplate")
		buttonName = button:GetName()
		button:SetID(i)
		button.id = i

		objects = getChildrenAndRegions(button)

		for k,v in pairs(objects) do
			local name = gsub(v, button:GetName(), "")
			button[lower(name)] = _G[v]
		end

		button:SetWidth(defaultElements[i]:GetWidth())
		button:SetHeight(defaultElements[i]:GetHeight())
		button:SetHitRectInsets(button:GetWidth()/2, button:GetWidth()/2, button:GetHeight()/2, button:GetHeight()/2)

		button.editframe:SetPoint("TOPLEFT")
		button.editframe:SetPoint("BOTTOMRIGHT")
		button.editframetype:SetText("bag")

		button.config = {
			["dock"] = "",
			["dockpos"] = 0,
			["homedock"] = "bag",
			["showstate"] = "",
			["laststate"] = "",
			["scale"] = 1,
			["XOffset"] = 0,
			["YOffset"] = 0,
			["element"] = defaultElements[i]:GetName(),
			["mouseover anchor"] = false,
			["click anchor"] = false,
			["anchordelay"] = "0.1",
			["anchoredheader"] = "",
		}

		defaultElements[i]:ClearAllPoints()
		defaultElements[i]:SetParent(button)
		defaultElements[i]:SetPoint("CENTER", button, "CENTER")
		defaultElements[i]:SetScale(0.9)

		if (TrinityBars2SavedState.firstRun) then
			TrinityBars2SavedState.bag[i] = { button.config }
		end

		bagButtonIndex[i] = button

		TrinityBars2Options_Storage.data["bagButtonIndex"][tonumber(i)] = 0;
	end
end

local function createMenuButtons()

	local button, buttonName, objects

	local defaultElements = {
  		[1] = CharacterMicroButton,
  		[2] = SpellbookMicroButton,
  		[3] = TalentMicroButton,
  		[4] = QuestLogMicroButton,
  		[5] = SocialsMicroButton,
  		[6] = LFGMicroButton,
  		[7] = MainMenuMicroButton,
  		[8] = HelpMicroButton,
  		[9] = TrinityBars2LatencyButton,
  		[10] = TrinityBars2KeyRingButton,
	}

	for i=1,#defaultElements do

		button = CreateFrame("CheckButton", "TrinityMenuButton"..i, UIParent, "TrinityAnchorButtonTemplate")
		buttonName = button:GetName()
		button:SetID(i)
		button.id = i

		objects = getChildrenAndRegions(button)

		for k,v in pairs(objects) do
			local name = gsub(v, button:GetName(), "")
			button[lower(name)] = _G[v]
		end

		button:SetWidth(defaultElements[i]:GetWidth()*0.86)
		button:SetHeight(defaultElements[i]:GetHeight()/1.65)
		button:SetHitRectInsets(button:GetWidth()/2, button:GetWidth()/2, button:GetHeight()/2, button:GetHeight()/2)

		button.editframe:SetPoint("TOPLEFT", -3, 0)
		button.editframe:SetPoint("BOTTOMRIGHT", 3, 0)
		button.editframetype:SetText("menu")
		button.editframetype:SetTextHeight(8)

		button.config = {
			["dock"] = "",
			["dockpos"] = 0,
			["homedock"] = "menu",
			["showstate"] = "",
			["laststate"] = "",
			["scale"] = 1,
			["XOffset"] = 0,
			["YOffset"] = 0,
			["element"] = defaultElements[i]:GetName(),
			["mouseover anchor"] = false,
			["click anchor"] = false,
			["anchordelay"] = "0.1",
			["anchoredheader"] = "",
		}

		defaultElements[i]:ClearAllPoints()
		defaultElements[i]:SetParent(button)
		defaultElements[i]:SetPoint("BOTTOM", button, "BOTTOM", 0, -1)
		defaultElements[i]:SetHitRectInsets(3, 3, 23, 3)
		defaultElements[i]:Show()

		if (TrinityBars2SavedState.firstRun) then
			TrinityBars2SavedState.menu[i] = { button.config }
		end

		menuButtonIndex[i] = button

		TrinityBars2Options_Storage.data["menuButtonIndex"][tonumber(i)] = 0;
	end
end

local function createActionbarHeader(dockFrame)

	local header = CreateFrame("Frame", dockFrame.headers.Actionbar.name, UIParent, "SecureStateHeaderTemplate")

	RegisterStateDriver(header, "actionbar", "[actionbar:1] 1; [actionbar:2] 2; [actionbar:3] 3; [actionbar:4] 4; [actionbar:5] 5; [actionbar:6] 6")

	header:SetAttribute("statemap-actionbar", "$input")
	header:SetAttribute("state", header:GetAttribute("state-actionbar"))
	header:SetAttribute("statebindings","0:zero;1:one;2:two;3:three;4:four;5:five;6:six;7:seven;8:eight;9:nine")
	header:SetAttribute("useparent-unit", true)

	dockFrame.actionbarheader = header
	dockFrame.headers.Actionbar.active = true

	return header
end

local function createStanceHeader(dockFrame)

	local header = CreateFrame("Frame", dockFrame.headers.Stance.name, UIParent, "SecureStateHeaderTemplate")

	RegisterStateDriver(header, "stance", "[stance:1] 1; [stance:2] 2; [stance:3] 3; [stance:4] 4; [stance:5] 5; [stance:6] 6; [stance:7] 7; 0")

	header:SetAttribute("statemap-stance", "$input")
	header:SetAttribute("state", header:GetAttribute("state-stance"))
	header:SetAttribute("statebindings","0:zero;1:one;2:two;3:three;4:four;5:five;6:six;7:seven;8:eight;9:nine")
	header:SetAttribute("useparent-unit", true)

	dockFrame.stanceheader = header
	dockFrame.headers.Stance.active = true

	return header
end

local function createNormalHeader(dockFrame)

	local header = CreateFrame("Frame", dockFrame.headers.Normal.name, UIParent, "SecureStateHeaderTemplate")

	RegisterStateDriver(header, "state", "0")

	header:SetAttribute("statemap-state", "$input")
	header:SetAttribute("state", header:GetAttribute("state-state"))
	header:SetAttribute("statebindings","0:zero;1:one;2:two;3:three;4:four;5:five;6:six;7:seven;8:eight;9:nine")

	header:SetAttribute("statemap-anchor-enter", "1:0")
	header:SetAttribute("statemap-anchor-leave", ";")
	header:SetAttribute("statemap-anchor-up", "0-1")
	header:SetAttribute("delaystatemap-anchor-leave", "0:1")
	header:SetAttribute("delayhovermap-anchor-leave", "0:true")

	dockFrame.normalheader = header
	dockFrame.toggleframe = header
	dockFrame.headers.Normal.active = true

	header:SetAllPoints(dockFrame)

	return header
end

local function createAnchorHeader()

	local header = CreateFrame("Frame", "TrinityAnchorHeader", UIParent, "SecureStateHeaderTemplate")

	RegisterStateDriver(header, "state", "0")

	header:SetAttribute("statemap-state", "$input")
	header:SetAttribute("state", header:GetAttribute("state-state"))
end

local function createReactionHeader()

	local header = CreateFrame("Frame", "TrinityReactionHeader", UIParent, "SecureStateHeaderTemplate")

	RegisterStateDriver(header, "harm", "[harm] 1; 0")

	header:SetAttribute("statemap-harm", "$input")
	header:SetAttribute("state", header:GetAttribute("state-harm"))
end

local function createBattleHeader()

	local header = CreateFrame("Frame", "TrinityBattleHeader", UIParent, "SecureStateHeaderTemplate")

	RegisterStateDriver(header, "combat", "[combat] 0; 1")

	header:SetAttribute("statemap-combat", "$input")
	header:SetAttribute("state", header:GetAttribute("state-combat"))
end

local function createRetreatHeader()

	local header = CreateFrame("Frame", "TrinityRetreatHeader", UIParent, "SecureStateHeaderTemplate")

	RegisterStateDriver(header, "combat", "[combat] 1; 0")

	header:SetAttribute("statemap-combat", "$input")
	header:SetAttribute("state", header:GetAttribute("state-combat"))
end

local function createPartyHeader()

	local header = CreateFrame("Frame", "TrinityPartyHeader", UIParent, "SecureStateHeaderTemplate")

	RegisterStateDriver(header, "group", "[group:party] 0; 1")

	header:SetAttribute("statemap-group", "$input")
	header:SetAttribute("state", header:GetAttribute("state-group"))
end

local function createRaidHeader()

	local header = CreateFrame("Frame", "TrinityRaidHeader", UIParent, "SecureStateHeaderTemplate")

	RegisterStateDriver(header, "group", "[group:raid] 0; 1")

	header:SetAttribute("statemap-group", "$input")
	header:SetAttribute("state", header:GetAttribute("state-group"))
end

local function createPvPHeader()

	local header = CreateFrame("Frame", "TrinityPvPHeader", UIParent, "SecureStateHeaderTemplate")

	--faked, hoping it gets put in one day. State switching is handled in TrinityBars2 until that day!
	RegisterStateDriver(header, "pvp", "0")

	header:SetAttribute("state-pvp", "$input")
end

local function createPvEHeader()

	local header = CreateFrame("Frame", "TrinityPvEHeader", UIParent, "SecureStateHeaderTemplate")

	--faked, hoping it gets put in one day. State switching is handled in TrinityBars2 until that day!
	RegisterStateDriver(header, "pve", "0")

	header:SetAttribute("state-pve", "$input")
end

local function createPossessHeader()

	local header = CreateFrame("Frame", "TrinityPossessHeader", UIParent, "SecureStateHeaderTemplate")

	RegisterStateDriver(header, "bonusbar", "[bonusbar:5] 0; 99")

	header:SetAttribute("statemap-bonusbar", "$input")
	header:SetAttribute("state", header:GetAttribute("state-bonusbar"))
end

--[[ Local Dock Functions ]]--

local function updateDockNames(dockFrame)

	local dockID = dockFrame:GetID()
	local index
	local state = ""

	if (dockID == dedBars.bag) then

		if (string.find(dockFrame.config["name"], "^Bar %d+$")) then
			dockNames["Bag Bar"] = dockID
			dockFrame.config["name"] = "Bag Bar"
		else
			dockNames[dockFrame.config["name"]] = dockID
		end

	elseif (dockID == dedBars.menu) then

		if (string.find(dockFrame.config["name"], "^Bar %d+$")) then
			dockNames["Menu Bar"] = dockID
			dockFrame.config["name"] = "Menu Bar"
		else
			dockNames[dockFrame.config["name"]] = dockID
		end

	elseif (dockID == dedBars.pet) then

		if (string.find(dockFrame.config["name"], "^Bar %d+$")) then
			dockNames["Pet Bar"] = dockID
			dockFrame.config["name"] = "Pet Bar"
		else
			dockNames[dockFrame.config["name"]] = dockID
		end

		_G[dockFrame:GetName().."Text"]:SetText(dockFrame.config["name"])

	elseif (dockID == dedBars.class) then

		if (string.find(dockFrame.config["name"], "^Bar %d+$")) then
			dockNames["Class Bar"] = dockID
			dockFrame.config["name"] = "Class Bar"
		else
			dockNames[dockFrame.config["name"]] = dockID
		end

	elseif (dockID) then

		if (string.find(dockFrame.config["name"], "^Bar %d+$")) then
			dockNames[" Bar "..dockID.." "] = dockID
			dockFrame.config["name"] = "Bar "..dockID
		else
			dockNames[" "..dockFrame.config["name"].." "] = dockID
		end

	end

	if (dockFrame.showstateName) then
		_G[dockFrame:GetName().."Text"]:SetText(dockFrame.config["name"].." - "..dockFrame.showstateName)
	else
		_G[dockFrame:GetName().."Text"]:SetText(dockFrame.config["name"])
	end
end

local function saveCurrentState()

	clearTable(dockNames)

	if (TrinityBars2SavedState.docks) then
		clearTable(TrinityBars2SavedState.docks)
	else
		TrinityBars2SavedState.docks = {}
	end

	for k,v in pairs(dockIndex) do
		if (dockIndex[k] ~= nil) then
			TrinityBars2SavedState.docks[k] = { v.headers, v.config };
			updateDockNames(v)
		end
	end

	if (TrinityBars2SavedState.buttons) then
		clearTable(TrinityBars2SavedState.buttons)
	else
		TrinityBars2SavedState.buttons = {}
	end

	for k,v in pairs(buttonIndex) do
		TrinityBars2SavedState.buttons[k] = { v.config }
	end

	if (TrinityBars2SavedState.pet) then
		clearTable(TrinityBars2SavedState.pet)
	else
		TrinityBars2SavedState.pet = {}
	end

	for k,v in pairs(petButtonIndex) do
		TrinityBars2SavedState.pet[k] = { v.config }
	end

	if (TrinityBars2SavedState.class) then
		clearTable(TrinityBars2SavedState.class)
	else
		TrinityBars2SavedState.class = {}
	end

	for k,v in pairs(classButtonIndex) do
		TrinityBars2SavedState.class[k] = { v.config }
	end

	if (TrinityBars2SavedState.bag) then
		clearTable(TrinityBars2SavedState.bag)
	else
		TrinityBars2SavedState.bag = {}
	end

	for k,v in pairs(bagButtonIndex) do
		TrinityBars2SavedState.bag[k] = { v.config }
	end

	if (TrinityBars2SavedState.menu) then
		clearTable(TrinityBars2SavedState.menu)
	else
		TrinityBars2SavedState.menu = {}
	end

	for k,v in pairs(menuButtonIndex) do
		TrinityBars2SavedState.menu[k] = { v.config }
	end

	TrinityBars2SavedState.savedVersion = currentVersion
end

local function setTargetBars(dockFrame)

	local normalHeader = _G[dockFrame.headers.Normal.name]

	if (Trinity2.configMode) then
		normalHeader:SetAttribute("unit", nil)
		UnregisterUnitWatch(normalHeader)
		normalHeader:Show()
	else
		if (dockFrame.config["target"] == "none") then
			normalHeader:SetAttribute("unit", nil)
			UnregisterUnitWatch(normalHeader)
		else
			normalHeader:SetAttribute("unit", dockFrame.config["target"])
			RegisterUnitWatch(normalHeader)
		end
	end
end

local function setShapeOptions(dockFrame)

	if (dockFrame.config["shape"] == 3 or dockFrame.config["shape"] == 4) then
		dockFrame.actionSet[TRINITYBARS2_STRINGS.DOCK_OPT_1] = true
		dockFrame.actionSet["Arc Length"] = true
		dockFrame.actionSet["Arc Preset"] = true
		dockFrame.simpleActionSet["Arc Preset"] = true
	else
		dockFrame.actionSet[TRINITYBARS2_STRINGS.DOCK_OPT_1] = false
		dockFrame.actionSet["Arc Length"] = false
		dockFrame.actionSet["Arc Preset"] = false
		dockFrame.simpleActionSet["Arc Preset"] = false
	end

	Trinity2.SetDockFrameAdjustableOptions(dockFrame)
end

local function refreshHeaders(dockFrame)

	if (InCombatLockdown()) then
		return
	end

	local header, state

	for key,value in pairs(dockFrame.headers) do

		if (dockFrame.headers[key]["active"]) then
			header = _G[dockFrame.headers[key]["name"]]
			SecureStateHeader_Refresh(header)
		end
	end
end

local function buttonVisibility(dockFrame, show)

	if (InCombatLockdown()) then
		return;
	end

	local button, showstate
	local dedBar = false
	local buttonList = {};

	for key,value in pairs(dockFrame.headers) do

		for showstate=dockFrame.headers[key]["start"],dockFrame.headers[key]["end"] do

			if (dockFrame.headers[key]["list"][showstate] and dockFrame.headers[key]["list"][showstate] ~= ",") then

				clearTable(buttonList)

				gsub(dockFrame.headers[key]["list"][showstate], "%d+", function (btn) table.insert(buttonList, btn) end)

				for k,v in pairs(buttonList) do

					button = _G[dockFrame.config.btnType..v]

					if (dockFrame.config.btnType == "TrinityActionButton") then

						if (not button.config["mouseover anchor"] and not button.config["click anchor"]) then

							if (show) then
								button:SetAttribute("showstates", button.config["showstate"])
							elseif (not Trinity2.configMode) then
								if (not playerEnteredWorld) then
									if (button.config.type == "action") then
										if (not HasAction(button.config.action) and not dockFrame.config["showgrid"]) then
											button:SetAttribute("showstates", "NOACTION")
										else
											button:SetAttribute("showstates", button.config["showstate"])
										end
									elseif (button.config.type == "spell") then
										if ((not button.config.spell or button.config.spell == "") and not dockFrame.config["showgrid"]) then
											button:SetAttribute("showstates", "NOACTION")
										else
											button:SetAttribute("showstates", button.config["showstate"])
										end
									elseif (button.config.type == "macro") then
										if ((not button.config.macro or button.config.macro == "") and not dockFrame.config["showgrid"]) then
											button:SetAttribute("showstates", "NOACTION")
										else
											button:SetAttribute("showstates", button.config["showstate"])
										end
									elseif (button.config.type == "item") then
										if ((not button.config.itemlink or button.config.itemlink == "") and not dockFrame.config["showgrid"]) then
											button:SetAttribute("showstates", "NOACTION")
										else
											button:SetAttribute("showstates", button.config["showstate"])
										end
									elseif (button.config.type == "slot") then
										button:SetAttribute("showstates", button.config["showstate"])
									end
								else
									if (button.config.type == "action") then
										if (not HasAction(button.config.action) and not MouseIsOver(button) and not dockFrame.config["showgrid"]) then
											button:SetAttribute("showstates", "NOACTION")
										else
											button:SetAttribute("showstates", button.config["showstate"])
										end
									elseif (button.config.type == "spell") then
										if ((not button.config.spell or button.config.spell == "") and not MouseIsOver(button) and not dockFrame.config["showgrid"]) then
											button:SetAttribute("showstates", "NOACTION")
										else
											button:SetAttribute("showstates", button.config["showstate"])
										end
									elseif (button.config.type == "macro") then
										if ((not button.config.macro or button.config.macro == "") and not MouseIsOver(button) and not dockFrame.config["showgrid"]) then
											button:SetAttribute("showstates", "NOACTION")
										else
											button:SetAttribute("showstates", button.config["showstate"])
										end
									elseif (button.config.type == "item") then
										if ((not button.config.itemlink or button.config.itemlink == "") and not MouseIsOver(button) and not dockFrame.config["showgrid"]) then
											button:SetAttribute("showstates", "NOACTION")
										else
											button:SetAttribute("showstates", button.config["showstate"])
										end
									elseif (button.config.type == "slot") then
										button:SetAttribute("showstates", button.config["showstate"])
									end
								end
							end
						end
					else
						button:SetAttribute("showstates", button.config["showstate"])
					end
				end
			end
		end
	end

	refreshHeaders(dockFrame)
end

local function setPagingTransitions(dockFrame)

	if (dockFrame.headers.Actionbar.active) then

		if (not Trinity2.configMode) then

			local paged = {}
			local page, transTo

			for k,v in pairs(dockFrame.config.pagingTrans) do

				page = match(k, "%d+")
				transTo = match(v, "%d+")

				paged[tonumber(page)] = transTo
			end

			for i=1,6 do
				if (paged[i]) then
					_G[dockFrame.headers.Actionbar.name]:SetAttribute("statemap-actionbar-"..i, paged[i])
				end
			end

		else
			for i=1,6 do
				_G[dockFrame.headers.Actionbar.name]:SetAttribute("statemap-actionbar-"..i, nil)
			end
		end
	end
end

local function setStanceTransitions(dockFrame)

	local form1, form2, macroText, index, button

	if (UnitClass("player") == TRINITYBARS2_STRINGS.HUNTER) then

		for key,value in pairs(dockFrame.buttonList) do

			button = _G["TrinityClassButton"..value]

			for k,v in pairs(dockFrame.config.stanceTrans) do

				if (k == button.config.spell) then

					if (v == "No Page") then

						button:SetAttribute("type", "spell")
						button:SetAttribute("*spell*", button.config.spell)

					else
						index = match(v, "%d+")

						if (index) then

							macroText = "/cast "..button.config.spell.."\n/changeactionbar "..index

							button:SetAttribute("type", "macro")
							button:SetAttribute("*macrotext*", macroText)
						else
							button:SetAttribute("type", "spell")
							button:SetAttribute("*spell*", button.config.spell)
						end
					end
				end
			end
		end
	else
		if (dockFrame.headers.Stance.active) then

			for k,v in pairs(dockFrame.config.stanceTrans) do

				form1 = TrinityBars2SavedState.classBar[k]
				form2 = TrinityBars2SavedState.classBar[v]

				if (form1 and form2) then
					_G[dockFrame.headers.Stance.name]:SetAttribute("statemap-stance-"..form1, form2)
				end
			end
		end
	end
end

local function dockVisibility(dockFrame)

	if (InCombatLockdown()) then
		return;
	end

	if (Trinity2DockFrameOptions:IsVisible() or
	    Trinity2SimpleDockEditor:IsVisible() or
	    TrinityBars2ButtonEditor:IsVisible() or
	    TrinityBars2SimpleButtonEditor:IsVisible() or
	    Trinity2SimpleBindingEditor:IsVisible()) then

		if (not dockFrame.config.stored) then
			if (Trinity2DockFrameOptions:IsVisible() or Trinity2SimpleDockEditor:IsVisible()) then
				dockFrame:Show()
			end
			TrinityBars2SavedState.buttonGridShow = true
			buttonVisibility(dockFrame, true)

		else
			if (not dockFrame.adjusting) then
				dockFrame.vis = 1;
				dockFrame:Hide()
			end

		end
	else
		dockFrame.vis = 1;
		dockFrame:Hide()
		TrinityBars2SavedState.buttonGridShow = false
		buttonVisibility(dockFrame, false)

	end

	setPagingTransitions(dockFrame)

	if (UnitClass("player") == TRINITYBARS2_STRINGS.HUNTER) then

		if (dockFrame:GetID() == dedBars.class) then
			setStanceTransitions(dockFrame)
		end
	else
		setStanceTransitions(dockFrame)
	end
end

local function updateDockFrame(dockFrame, newWidth, newHeight)

	if (dockFrame.elapsed < 0.75) then
		dockFrame.update = true;
		return;
	end

	local count = dockFrame.buttonCount

	if (count < 1) then
		count = 1
	end

	dockFrame:SetUserPlaced(true)
	local x,y = dockFrame:GetCenter()

	if (dockFrame.config["shape"] == 0) then
		dockFrame:SetWidth((newWidth * count) - (dockFrame.config.buttonSpaceH*dockFrame.config.scale))
		dockFrame:SetHeight(newHeight - (dockFrame.config.buttonSpaceV*dockFrame.config.scale))
	elseif (dockFrame.config["shape"] == 1) then
		dockFrame:SetWidth(newWidth - (dockFrame.config.buttonSpaceH*dockFrame.config.scale))
		dockFrame:SetHeight((newHeight * count) - (dockFrame.config.buttonSpaceV*dockFrame.config.scale))
	elseif (dockFrame.config["shape"] == 2) then
		if (count > dockFrame.config["columns"]) then
			dockFrame:SetWidth(newWidth * ceil((ceil(count/dockFrame.config["columns"])*dockFrame.config["columns"])/(ceil(count/dockFrame.config["columns"]))))
			dockFrame:SetHeight((newHeight * ceil(count/dockFrame.config["columns"])) - (dockFrame.config.buttonSpaceV*dockFrame.config.scale))
		else
			dockFrame:SetWidth((newWidth * count) - (dockFrame.config.buttonSpaceH*dockFrame.config.scale))
			dockFrame:SetHeight(newHeight - (dockFrame.config.buttonSpaceV*dockFrame.config.scale))
		end
	elseif (dockFrame.config["shape"] == 3) then
		dockFrame:SetWidth((newWidth*2*(count/math.pi))+(newWidth*1.5))
		dockFrame:SetHeight((newHeight*2*(count/math.pi))+(newHeight*1.5))
	elseif (dockFrame.config["shape"] == 4) then
		dockFrame:SetWidth((newWidth*2*((count)/math.pi))+(newWidth*1.5))
		dockFrame:SetHeight((newHeight*2*((count)/math.pi))+(newHeight*1.5))
	end

	if (playerEnteredWorld and x and y) then
		dockFrame:SetUserPlaced(false)
		dockFrame:ClearAllPoints()
		dockFrame:SetPoint("CENTER","UIParent", "BOTTOMLEFT", x, y)
		dockFrame:SetUserPlaced(true)
	end

	saveCurrentState()
end

local function setCurrHeaderShowstate(dockFrame)

	local parent, btn
	local unitReaction = false

	if (dockFrame.config.target == "none") then
		if (UnitReaction("player", "target")) then
			if (UnitReaction("player", "target") < 5) then
				unitReaction = true
			end
		end
	else
		if (UnitReaction("player", dockFrame.config.target)) then
			if (UnitReaction("player", dockFrame.config.target) < 5) then
				unitReaction = true
			end
		end
	end

	dockFrame.activeHeader = "Normal"
	dockFrame.currHeader = nil
	dockFrame.showstate = 0
	dockFrame.showstateName = ""
	dockFrame.buttonCount = 0

	if (dockFrame.buttonList) then
		clearTable(dockFrame.buttonList)
	else
		dockFrame.buttonList = {}
	end

	if (dockFrame.orderList) then
		clearTable(dockFrame.orderList)
	else
		dockFrame.orderList = {}
	end

	if (useStates) then

		local state = _G[dockFrame.headers.Normal.name]:GetAttribute("state")

		dockFrame.headers.Normal.currState = tonumber(state)
		dockFrame.showstate = tonumber(state)

		if (dockFrame.headers.Actionbar.active) then
			dockFrame.headers.Actionbar.currState  = tonumber(_G[dockFrame.headers.Actionbar.name]:GetAttribute("state"))
		end
		if (dockFrame.headers.Stance.active) then
			dockFrame.headers.Stance.currState = tonumber(_G[dockFrame.headers.Stance.name]:GetAttribute("state"))
		end
	else

		if (dockFrame.config.reaction and unitReaction) then
			dockFrame.headers.Normal.currState = 2
			dockFrame.showstate = 2
		elseif (dockFrame.config.alt and IsAltKeyDown()) then
			dockFrame.headers.Normal.currState = 3
			dockFrame.showstate = 3
		elseif (dockFrame.config.control and IsControlKeyDown()) then
			dockFrame.headers.Normal.currState = 4
			dockFrame.showstate = 4
		elseif (dockFrame.config.shift and IsShiftKeyDown()) then
			dockFrame.headers.Normal.currState = 5
			dockFrame.showstate = 5
		elseif (dockFrame.config.stealth and IsStealthed()) then
			dockFrame.headers.Normal.currState = 6
			dockFrame.showstate = 6
		else
			dockFrame.headers.Normal.currState = 0
			dockFrame.showstate = 0
		end

		--_G[dockFrame.headers.Normal.name]:SetAttribute("state", dockFrame.showstate)

		if (dockFrame.headers.Actionbar.active) then
			dockFrame.headers.Actionbar.currState = GetActionBarPage()
		end
		if (dockFrame.headers.Stance.active) then
			if (UnitClass("player") == TRINITYBARS2_STRINGS.DRUID) then
				if (GetShapeshiftForm() == TrinityBars2SavedState.classBar["Cat Form"]) then
					if (IsStealthed()) then
						dockFrame.headers.Stance.currState = 8;
					else
						dockFrame.headers.Stance.currState = GetShapeshiftForm()
					end
				else
					dockFrame.headers.Stance.currState = GetShapeshiftForm()
				end
			else
				dockFrame.headers.Stance.currState = GetShapeshiftForm()
			end
		end
	end

	if (dockFrame.showstate == 0) then

		for k,v in pairs(dockFrame.headers) do
			if (dockFrame.headers[k]["active"]) then
				dockFrame.orderList[dockFrame.headers[k]["order"]] = k
			end
		end

		for i=1,#dockFrame.orderList do
			if (dockFrame.orderList[i]) then
				parent = gsub(dockFrame.headers[dockFrame.orderList[i]]["parent"], "(Trinity)(%a+)(Header%d*)", "%2")
				if (dockFrame.headers[dockFrame.orderList[i]]["showstate"] == dockFrame.headers[parent]["currState"]) then
					dockFrame.activeHeader = dockFrame.orderList[i]
					dockFrame.currHeader = _G[dockFrame.headers[dockFrame.activeHeader]["name"]]
					dockFrame.showstate = tonumber(dockFrame.headers[dockFrame.orderList[i]]["currState"])
				end
			end
		end
	end

	if (dockFrame.activeHeader == "Normal") then
		if (dockFrame.showstate == 0) then

			if (dockFrame.config["reaction"]) then
				dockFrame.showstateName = "Friendly Target"
			elseif (dockFrame.config["battle"]) then
				dockFrame.showstateName = "Battle Bar"
			elseif (dockFrame.config["retreat"]) then
				dockFrame.showstateName = "Retreat Bar"
			elseif (dockFrame.config["pvp"]) then
				dockFrame.showstateName = "PvP Bar"
			elseif (dockFrame.config["pve"]) then
				dockFrame.showstateName = "PvE Bar"
			elseif (dockFrame.config["party"]) then
				dockFrame.showstateName = "Party Bar"
			elseif (dockFrame.config["raid"]) then
				dockFrame.showstateName = "Raid Bar"
			elseif (dockFrame.config["stealth"]) then
				dockFrame.showstateName = "Stealth Bar"
			elseif (dockFrame.config["possession"]) then
				dockFrame.showstateName = "Possession Bar"
			else
				dockFrame.showstateName = "Normal"
			end

		elseif (dockFrame.showstate == 1) then
			dockFrame.showstateName = "Hidden"
		elseif (dockFrame.showstate == 2) then
			dockFrame.showstateName = "Hostile Target"
		elseif (dockFrame.showstate == 3) then
			dockFrame.showstateName = "Alt Key Down"
		elseif (dockFrame.showstate == 4) then
			dockFrame.showstateName = "Control Key Down"
		elseif (dockFrame.showstate == 5) then
			dockFrame.showstateName = "Shift Key Down"
		elseif (dockFrame.showstate == 6) then
			dockFrame.showstateName = "Stealth"
		elseif (dockFrame.showstate == 7) then
			dockFrame.showstateName = ""
		elseif (dockFrame.showstate == 8) then
			dockFrame.showstateName = ""
		elseif (dockFrame.showstate == 9) then
			dockFrame.showstateName = "Possession"
		end
	elseif (dockFrame.activeHeader == "Actionbar") then
		if (dockFrame.showstate) then
			dockFrame.showstateName = "Page "..dockFrame.showstate
		end
	elseif (dockFrame.activeHeader == "Stance") then
		for k,v in pairs(TrinityBars2SavedState.classBar) do
			if (v == dockFrame.showstate) then
				dockFrame.showstateName = k
			end
		end
	end

	if (find(dockFrame.headers[dockFrame.activeHeader]["list"][dockFrame.showstate], "%d")) then
		gsub(dockFrame.headers[dockFrame.activeHeader]["list"][dockFrame.showstate], "%d+", function (btn) table.insert(dockFrame.buttonList, btn) end)
		dockFrame.buttonCount = #dockFrame.buttonList
	end

	if (value == 1) then
		return dockFrame.activeHeader;
	elseif (value == 2) then
		return dockFrame.activeHeader, dockFrame.showstate;
	elseif (value == 3) then
		return dockFrame.buttonCount;
	else
		return dockFrame.activeHeader, dockFrame.showstate, dockFrame.buttonList, dockFrame.buttonCount
	end
end

local function setupDockFrameUpdate(dockFrame)

	local width = 0
	local height = 0
	local lastWidth, lastHeight, button

	setCurrHeaderShowstate(dockFrame)

	if (dockFrame.buttonCount > 0) then

		for k,v in pairs(dockFrame.buttonList) do

			button = _G[dockFrame.config.btnType..v]

			lastWidth = (button:GetWidth() + dockFrame.config.buttonSpaceH) * dockFrame.config.scale
			lastHeight = (button:GetHeight() + dockFrame.config.buttonSpaceV) * dockFrame.config.scale

			if (lastWidth > width) then width = lastWidth end
			if (lastHeight > height) then height = lastHeight end
		end

	else

		width = 185
		height = 25
	end

	updateDockFrame(dockFrame, width, height)
end

local function updateDockingPrep(dockFrame)

end

local function updateDocking(dockFrame)

	if (not dockFrame) then
		return
	end

	local showstate, x, y, radiusH, radiusV, pos, index, button, width, height, count, header

	setTargetBars(dockFrame)

	setShapeOptions(dockFrame)

	_G[dockFrame.headers.Normal.name]:SetAlpha(dockFrame.config["alpha"])

	dockFrame:SetFrameStrata(dockFrame.config.dockStrata)

	for key,value in pairs(dockFrame.headers) do

		header = _G[dockFrame.headers[key]["name"]]

		if (dockingData.anchorPlaced[key]) then
			clearTable(dockingData.anchorPlaced[key])
		else
			dockingData.anchorPlaced[key] = {}
		end

		if (dockingData.placed[key]) then
			clearTable(dockingData.placed[key])
		else
			dockingData.placed[key] = {}
		end

		if (dockingData.last[key]) then
			clearTable(dockingData.last[key])
		else
			dockingData.last[key] = {}
		end

		for showstate=dockFrame.headers[key]["start"],dockFrame.headers[key]["end"] do

			if (dockFrame.headers[key]["list"][showstate]) then

				clearTable(dockingData.buttonList)
				pos = 1; index = 0

				dockingData.anchorPlaced[key][showstate] = false;

				gsub(dockFrame.headers[key]["list"][showstate], "%d+", function (btn) table.insert(dockingData.buttonList, btn) end)

				for k,v in pairs(dockingData.buttonList) do

					index = index + 1

					button = _G[dockFrame.config.btnType..v]

					if (not button) then
						DEFAULT_CHAT_FRAME:AddMessage("Trinity Bars Critical Error Detected: Invalid button on "..dockFrame:GetName()..". Saved Variables reset required! Sorry!")
					end

					if (dockFrame:GetID() == dedBars.pet and tonumber(v) > 10) then
						TrinityPossessHeader:SetAttribute("addchild", button)
					else
						if (button.config["mouseover anchor"] or button.config["click anchor"]) then
							TrinityAnchorHeader:SetAttribute("addchild", button)
						else
							header:SetAttribute("addchild", button)
						end
					end

					button:SetAttribute("showstates", showstate)
					button.config.showstate = showstate
					button:SetScale(dockFrame.config.scale * button.config.scale)
					button.config.dock = dockFrame:GetID()
					button.config.stored = false

					updateButtonData(dockFrame, button)

					button:ClearAllPoints()

					width = button:GetWidth()
					height = button:GetHeight()

					if (not dockingData.anchorPlaced[key][showstate]) then

						if (dockFrame.config["shape"] == 0) then
							width = width / button.config.scale
							button:SetPoint("CENTER", dockFrame.normalheader:GetName(), "CENTER", -((width+dockFrame.config.buttonSpaceH)*(#dockingData.buttonList-1)/2) + button.config["XOffset"], button.config["YOffset"])
							dockingData.last[key][showstate] = button.id
						elseif (dockFrame.config["shape"] == 1) then
							height = height / button.config.scale
							button:SetPoint("CENTER", dockFrame.normalheader:GetName(), "CENTER", button.config["XOffset"], ((height+dockFrame.config.buttonSpaceV)*(#dockingData.buttonList-1)/2) + button.config["YOffset"]) ;
							dockingData.last[key][showstate] = button.id
						elseif (dockFrame.config["shape"] == 2) then
							dockFrame.adjust = 0
							if (#dockingData.buttonList <= dockFrame.config["columns"]) then
								--button:SetPoint("LEFT", dockFrame.normalheader:GetName(), "CENTER", -(((width*#dockingData.buttonList)+(dockFrame.config.buttonSpaceH*(#dockingData.buttonList-1)))/2)+button.config["XOffset"], button.config["YOffset"])
								button:SetPoint("CENTER", dockFrame.normalheader:GetName(), "CENTER", -((width+dockFrame.config.buttonSpaceH)*(#dockingData.buttonList-1)/2) + button.config["XOffset"], button.config["YOffset"])
							else
								button:SetPoint("TOPLEFT", dockFrame.normalheader:GetName(), "CENTER", -((width+dockFrame.config.buttonSpaceH) * (dockFrame.config["columns"]/2) - dockFrame.adjust)+button.config["XOffset"], ((height+dockFrame.config.buttonSpaceV)*(ceil(#dockingData.buttonList/dockFrame.config["columns"])/2)+button.config["YOffset"]))
							end
							dockingData.placed[key][showstate] = 1;
							dockFrame.multiplier[showstate] = 1;
							dockingData.last[key][showstate] = button.id
						elseif (dockFrame.config["shape"] == 3) then
							dockingData.placed[key][showstate] = dockFrame.config["arcstart"];
							x = ((width+dockFrame.config.buttonSpaceH)*(#dockingData.buttonList/math.pi))*(cos(dockingData.placed[key][showstate])) / button.config.scale;
							y = ((width+dockFrame.config.buttonSpaceV)*(#dockingData.buttonList/math.pi))*(sin(dockingData.placed[key][showstate])) / button.config.scale;
							button:SetPoint("CENTER", dockFrame.normalheader:GetName(), "CENTER", x+button.config["XOffset"], y+button.config["YOffset"])
						elseif (dockFrame.config["shape"] == 4) then
							dockingData.placed[key][showstate] = dockFrame.config["arcstart"];
							button:SetPoint("CENTER", dockFrame.normalheader:GetName(), "CENTER", button.config["XOffset"], button.config["YOffset"])
						end

						dockingData.anchorPlaced[key][showstate] = true

					else

						if (dockFrame.config["shape"] == 0) then
							button:SetPoint("LEFT", _G[dockFrame.config.btnType..dockingData.last[key][showstate]], "RIGHT", dockFrame.config.buttonSpaceH+button.config["XOffset"], 0+button.config["YOffset"])
							dockingData.last[key][showstate] = button.id
						elseif (dockFrame.config["shape"] == 1) then
							button:SetPoint("TOP", _G[dockFrame.config.btnType..dockingData.last[key][showstate]], "BOTTOM", 0+button.config["XOffset"], -(dockFrame.config.buttonSpaceV)+button.config["YOffset"])
							dockingData.last[key][showstate] = button.id
						elseif (dockFrame.config["shape"] == 2) then
							dockFrame.adjust = 0
							if ((dockFrame.config["columns"]*dockFrame.multiplier[showstate]) == dockingData.placed[key][showstate]+dockFrame.adjust) then
								count = #dockingData.buttonList
								if (count > dockFrame.config["columns"]*(dockFrame.multiplier[showstate]+1)) then
									count = dockFrame.config["columns"]*(dockFrame.multiplier[showstate]+1)
								end
								button:SetPoint("TOPLEFT", dockFrame.normalheader:GetName(), "CENTER", -((((width+dockFrame.config.buttonSpaceH)*(count-(dockFrame.config["columns"]*dockFrame.multiplier[showstate]))))/2)+button.config["XOffset"], (height+dockFrame.config.buttonSpaceV)*(ceil(#dockingData.buttonList/dockFrame.config["columns"])/2)-(((height+dockFrame.config.buttonSpaceV)*dockFrame.multiplier[showstate]))+button.config["YOffset"])
								dockingData.placed[key][showstate] = dockingData.placed[key][showstate] + 1;
								dockFrame.multiplier[showstate] = dockFrame.multiplier[showstate] + 1;
							else
								button:SetPoint("LEFT", _G[dockFrame.config.btnType..dockingData.last[key][showstate]], "RIGHT", dockFrame.config.buttonSpaceH+button.config["XOffset"], 0+button.config["YOffset"])
								dockingData.placed[key][showstate] = dockingData.placed[key][showstate] + 1;
							end
							dockingData.last[key][showstate] = button.id
						elseif (dockFrame.config["shape"] == 3) then
							dockingData.placed[key][showstate] = dockingData.placed[key][showstate] - (dockFrame.config["arclength"]/(#dockingData.buttonList))
							x = ((width+dockFrame.config.buttonSpaceH)*(#dockingData.buttonList/math.pi))*(cos(dockingData.placed[key][showstate])) / button.config.scale;
							y = ((width+dockFrame.config.buttonSpaceV)*(#dockingData.buttonList/math.pi))*(sin(dockingData.placed[key][showstate])) / button.config.scale;
							button:SetPoint("CENTER", dockFrame.normalheader:GetName(), "CENTER", x+button.config["XOffset"], y+button.config["YOffset"])
						elseif (dockFrame.config["shape"] == 4) then
							dockingData.placed[key][showstate] = dockingData.placed[key][showstate] - (dockFrame.config["arclength"]/(#dockingData.buttonList-1))
							x = ((width+dockFrame.config.buttonSpaceH)*(#dockingData.buttonList/math.pi))*(cos(dockingData.placed[key][showstate])) / button.config.scale;
							y = ((width+dockFrame.config.buttonSpaceV)*(#dockingData.buttonList/math.pi))*(sin(dockingData.placed[key][showstate])) / button.config.scale;
							button:SetPoint("CENTER", dockFrame.normalheader:GetName(), "CENTER", x+button.config["XOffset"], y+button.config["YOffset"])
						end
					end

					button:SetFrameStrata(dockFrame.config.buttonStrata)

					if (dockFrame.config.btnType == "TrinityActionButton") then

						button:SetFrameLevel(4)
						button.iconframe:SetFrameLevel(2)
						button.iconframecooldown:SetFrameLevel(3)
						button.iconframebuffup:SetFrameLevel(3)
						TrinityBars2Options_Storage.data.buttonIndex[tonumber(v)] = 0
						button.hotkey:SetText(button.config.HotKeyText1)

					elseif (dockFrame.config.btnType == "TrinityPetButton") then

						button:SetFrameLevel(4)
						button.iconframe:SetFrameLevel(2)
						button.iconframecooldown:SetFrameLevel(3)
						TrinityBars2Options_Storage.data.petButtonIndex[tonumber(v)] = 0
						button.hotkey:SetText(button.config.HotKeyText1)

					elseif (dockFrame.config.btnType == "TrinityClassButton") then

						button:SetFrameLevel(4)
						button.iconframe:SetFrameLevel(2)
						button.iconframecooldown:SetFrameLevel(3)
						TrinityBars2Options_Storage.data.classButtonIndex[tonumber(v)] = 0
						button.hotkey:SetText(button.config.HotKeyText1)

					elseif (dockFrame.config.btnType == "TrinityBagButton") then

						button:SetFrameLevel(1)
						TrinityBars2Options_Storage.data.bagButtonIndex[tonumber(v)] = 0

						if (button.config.element and button.config.element ~= "") then
							_G[button.config.element]:SetAttribute("stateheader", header)
							_G[button.config.element]:SetFrameStrata(dockFrame.config.buttonStrata)
							_G[button.config.element]:SetFrameLevel(2)
						end

					elseif (dockFrame.config.btnType == "TrinityMenuButton") then

						button:SetFrameLevel(1)
						TrinityBars2Options_Storage.data.menuButtonIndex[tonumber(v)] = 0

						if (button.config.element and button.config.element ~= "") then
							_G[button.config.element]:SetAttribute("stateheader", header)
							_G[button.config.element]:SetFrameStrata(dockFrame.config.buttonStrata)
							_G[button.config.element]:SetFrameLevel(2)
						end
					end

					button.config.dockpos = pos;
					pos = pos + 1;
				end
			end
		end
	end

	dockVisibility(dockFrame)

	setupDockFrameUpdate(dockFrame)

end

local function updateDockPostions(reset)

	local dockFrame, dockFrameHeight

	local anchor = "BOTTOM";
	local relTo = "UIParent";
	local relPoint = "BOTTOM";
	local x = 0;
	local y = 90;

	clearTable(dockNames)

	if (reset) then

		dockFrameHeight = 40;

		for k,dockFrame in pairs(dockIndex) do

			dockFrame:SetUserPlaced(false)
			dockFrame:ClearAllPoints()

			if (dockFrame:GetID() == 1) then
				dockFrame:SetPoint("CENTER", "UIParent", "BOTTOM", -219.25, 19.5)
			elseif (dockFrame.config.dedType == "menu") then
				dockFrame:SetPoint("CENTER", "UIParent", "BOTTOM", 125.25, 19.5)
			elseif (dockFrame.config.dedType == "bag") then
				dockFrame:SetPoint("CENTER", "UIParent", "BOTTOM", 344.75, 19.5)
			elseif (dockFrame.config.dedType == "class") then
				dockFrame:SetPoint("CENTER", "UIParent", "BOTTOM", -217.95, 71.5)
			elseif (dockFrame.config.dedType == "pet") then
				dockFrame:SetPoint("CENTER", "UIParent", "BOTTOM", 220.25, 71.5)
			else
				dockFrame:SetPoint("CENTER", "UIParent", "BOTTOM", 0, y)
				y = y + dockFrameHeight
			end

			dockFrame.config.centerx, dockFrame.config.centery = dockFrame:GetCenter()
			dockFrame:SetUserPlaced(true)

			updateDockNames(dockFrame)
		end

		if (TrinityBars2SavedState.firstRun) then
			TrinityBars2SavedState.firstRun = false
			saveCurrentState()
			TrinityBars2.SaveTemplate(UnitClass("player").." Default")
		end

	else
		for k,dockFrame in pairs(dockIndex) do

			dockFrame:SetUserPlaced(false)
			dockFrame:ClearAllPoints()
			dockFrame:SetPoint("CENTER", relTo, "BOTTOMLEFT", dockFrame.config.centerx, dockFrame.config.centery)
			dockFrame:SetUserPlaced(true)

			updateDockNames(dockFrame)
		end
	end
end

--[[ Dock Creation Functions ]]--

local function dockFrameDefaults(index, dockFrame)

	dockFrame.orderList = {}
	dockFrame.headers = {
		["Stance"] = {
			["name"] = "TrinityStanceHeader"..index,
			["parent"] = nil,
			["showstate"] = "",
			["active"] = false,
			["order"] = 99,
			["start"] = 0,
			["end"] = 8,
			["list"] = {
				[0] = ",",
				[1] = ",",
				[2] = ",",
				[3] = ",",
				[4] = ",",
				[5] = ",",
				[6] = ",",
				[7] = ",",
				[8] = ",",
			},
			["currState"] = 0,
		},
		["Actionbar"] = {
			["name"] ="TrinityActionbarHeader"..index,
			["parent"] = nil,
			["showstate"] = "",
			["active"] = false,
			["order"] = 99,
			["start"] = 1,
			["end"] = 6,
			["list"] = {
				[1] = ",",
				[2] = ",",
				[3] = ",",
				[4] = ",",
				[5] = ",",
				[6] = ",",
			},
			["currState"] = 0,
		},
		["Normal"] = {
			["name"] ="TrinityNormalHeader"..index,
			["parent"] = "UIParent",
			["showstate"] = 0,
			["active"] = true,
			["order"] = 0,
			["start"] = 0,
			["end"] = 6,
			["list"] = {
				[0] = ",",
				[1] = ",",
				[2] = ",",
				[3] = ",",
				[4] = ",",
				[5] = ",",
				[6] = ",",
			},
			["currState"] = 0,
		},
	}
	dockFrame.config = {
		["name"] = "Bar "..index,
		["btnType"] = "",
		["buttonStrata"] = "LOW",
		["dockStrata"] = "MEDIUM",
		["buttonEdit"] = 1,
		["scale"] = 1,
		["alpha"] = 1,
		["alphaup"] = "none",
		["shape"] = 0,
		["arcstart"] = 90,
		["arclength"] = 359,
		["columns"] = 12,
		["buttonSpaceH"] = 0,
		["buttonSpaceV"] = 0,
		["skin"] = "Square (Blizz Default)",
		["skincolor"] = { 1, 1, 1 },
		["hovercolor"] = { 0.1, 0.1, 1 },
		["equipcolor"] = { 0.1, 1, 0.1 },
		["rangecolor"] = { 0.7, 0.15, 0.15 },
		["manacolor"] = { 0.2, 0.3, 0.7 },
		["buffcolor"] = { 0.0, 0.8, 0.0 },
		["debuffcolor"] = { 0.8, 0.0, 0.0 },
		["cdcolornorm"] = { 1, 0.82, 0 },
		["cdcolorlarge"] = { 1, 0.1, 0.1 },
		["bdcolornorm"] = { 0, 0.82, 0 },
		["bdcolorlarge"] = { 1, 0.1, 0.1 },
		["taper"] = { "none", 1 },
		["target"] = "none",
		["lockcolors"] = false,
		["snapto"] = false,
		["stored"] = false,
		["normal"] = true,
		["paged"] = false,
		["stance"] = false,
		["stealth"] = false,
		["alt"] = false,
		["control"] = false,
		["shift"] = false,
		["reaction"] = false,
		["battle"] = false,
		["retreat"] = false,
		["party"] = false,
		["raid"] = false,
		["pvp"] = false,
		["pve"] = false,
		["autohide"] = false,
		["showgrid"] = false,
		["prowl"] = false,
		["possession"] = false,
		["reset"] = true,
		["delete"] = true,
		["create"] = true,
		["clone"] = true,
		["centerx"] = (UIParent:GetWidth()/2)*UIParent:GetEffectiveScale(),
		["centery"] = (UIParent:GetHeight()/2)*UIParent:GetEffectiveScale(),
		["pagingTrans"] = {
			["Page 1"] = "Page 1",
			["Page 2"] = "Page 2",
			["Page 3"] = "Page 3",
			["Page 4"] = "Page 4",
			["Page 5"] = "Page 5",
			["Page 6"] = "Page 6",
		},
		["stanceTrans"] = {},
		["togglebind"] = "",

	}

	dockFrame.elapsed = 3
	dockFrame.update = false

	dockFrame.multiplier = {}
end

local function createDockFrame(index)

	local dockFrame = CreateFrame("Button", "TrinityDockFrame"..index, UIParent, "Trinity2DockFrameTemplate")
	dockFrame:SetID(index)

	dockFrameDefaults(index, dockFrame)

	if (index ~= 0) then

		dockFrame.tooltip = TRINITYBARS2_STRINGS.TOOLTIP_3

		dockFrame.mousewheelfunc = function(self, dir) TrinityBars2.CycleStates(self, dir) end

		dockFrame.func1 = function(self) updateDockingPrep(self) saveCurrentState() end
		dockFrame.func2 = function(self) updateDocking(self) end

		dockFrame.reset = function(dockFrame) TrinityBars2.ResetDock(dockFrame) end

		if (index == 1) then
			dockFrame.store = function(dockFrame) TrinityBars2.StoreDock(dockFrame) end
		else
			dockFrame.delete = function(dockFrame) TrinityBars2.DeleteDock(dockFrame) end
		end

		dockFrame.create = function(dockFrame) TrinityBars2.CreateDock(true) end
		dockFrame.clone = function(dockFrame) TrinityBars2.CloneDock(dockFrame) end

		dockFrame.owner = "TrinityBars2_"

		dockFrame.simpleActionSet = {
			[TRINITYBARS2_STRINGS.DOCK_OPT_4] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_5] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_7] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_8] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_10] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_11] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_12] = "default",
			[TRINITYBARS2_STRINGS.DOCK_OPT_13] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_14] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_15] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_16] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_19] = true,
		}

		dockFrame.actionSet = {
			[TRINITYBARS2_STRINGS.DOCK_OPT_6] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_7] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_8] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_9] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_10] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_11] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_12] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_13] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_14] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_15] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_16] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_19] = true,
			[TRINITYBARS2_STRINGS.DOCK_OPT_20] = true,
		}

		dockFrame.checkSet = {
			[TRINITYBARS2_STRINGS.CHECK_OPT_1] = true,
			[TRINITYBARS2_STRINGS.CHECK_OPT_2] = true,
			[TRINITYBARS2_STRINGS.CHECK_OPT_3] = true,
			[TRINITYBARS2_STRINGS.CHECK_OPT_4] = true,
			[TRINITYBARS2_STRINGS.CHECK_OPT_5] = true,
			[TRINITYBARS2_STRINGS.CHECK_OPT_6] = true,
			[TRINITYBARS2_STRINGS.CHECK_OPT_7] = true,
			[TRINITYBARS2_STRINGS.CHECK_OPT_8] = true,
			[TRINITYBARS2_STRINGS.CHECK_OPT_9] = true,
			[TRINITYBARS2_STRINGS.CHECK_OPT_10] = true,
			[TRINITYBARS2_STRINGS.CHECK_OPT_11] = true,
			[TRINITYBARS2_STRINGS.CHECK_OPT_12] = true,
			[TRINITYBARS2_STRINGS.CHECK_OPT_13] = true,
			[TRINITYBARS2_STRINGS.CHECK_OPT_14] = true,
			[TRINITYBARS2_STRINGS.CHECK_OPT_15] = true,
			[TRINITYBARS2_STRINGS.CHECK_OPT_16] = true,
			[TRINITYBARS2_STRINGS.CHECK_OPT_17] = true,
			[TRINITYBARS2_STRINGS.CHECK_OPT_18] = true,
		}

		dockFrame.colorSet = {
			[TRINITYBARS2_STRINGS.COLOR_OPT_1] = "buffcolor",
			[TRINITYBARS2_STRINGS.COLOR_OPT_2] = "debuffcolor",
			[TRINITYBARS2_STRINGS.COLOR_OPT_3] = "rangecolor",
			[TRINITYBARS2_STRINGS.COLOR_OPT_4] = "manacolor",
			[TRINITYBARS2_STRINGS.COLOR_OPT_5] = "skincolor",
			[TRINITYBARS2_STRINGS.COLOR_OPT_6] = "hovercolor",
			[TRINITYBARS2_STRINGS.COLOR_OPT_7] = "equipcolor",
			[TRINITYBARS2_STRINGS.COLOR_OPT_8] = "cdcolornorm",
			[TRINITYBARS2_STRINGS.COLOR_OPT_9] = "cdcolorlarge",
			[TRINITYBARS2_STRINGS.COLOR_OPT_10] = "bdcolornorm",
			[TRINITYBARS2_STRINGS.COLOR_OPT_11] = "bdcolorlarge",
		}
	end

 	if (TrinityBars2SavedState.firstRun) then
 		TrinityBars2SavedState["docks"][index] = { dockFrame.headers, dockFrame.config }
	end

	if (index ~= 0) then
		dockIndex[index] = dockFrame
		Trinity2.RegisteredDocks[dockFrame:GetName()] = function(frame) updateDocking(frame) frame.vis = 1 end
	end

	return dockFrame
end

local function petDockOptions(dockFrame)

	dockFrame.actionSet["Bar Target"] = false
	dockFrame.delete = nil
	dockFrame.store = function(dockFrame) TrinityBars2.StoreDock(dockFrame) end
	dockFrame.create = function(dockFrame) TrinityBars2.CreateDock(true) end
	dockFrame.clone = nil
end

local function createPetDock()

	local button
	local dockNum = #dockIndex + 1
	local dockFrame = createDockFrame(dockNum)

	dedBars.pet = dockNum
	dedBars.docks.pet = dockFrame

	dockFrame.config.btnType = "TrinityPetButton"
	dockFrame.config.dedType = "pet"
	dockFrame.config.target = "pet"

	petDockOptions(dockFrame)

	local normalHeader = createNormalHeader(dockFrame)

	for i=1,12 do

		button = _G["TrinityPetButton"..i]

		button.config.dock = dockNum

		if (not dockFrame.headers.Normal.list[0]) then
			dockFrame.headers.Normal.list[0] = ","..button.id..",";
		else
			dockFrame.headers.Normal.list[0] = dockFrame.headers.Normal.list[0]..button.id..",";
		end
	end

	return dockFrame;
end

local function classDockOptions(dockFrame)

	dockFrame.actionSet["Bar Target"] = false
	dockFrame.delete = nil
	dockFrame.store = function(dockFrame) TrinityBars2.StoreDock(dockFrame) end
	dockFrame.create = function(dockFrame) TrinityBars2.CreateDock(true) end
	dockFrame.clone = nil
end

local function createClassDock()

	local button
	local dockNum = #dockIndex + 1
	local dockFrame = createDockFrame(dockNum)

	dedBars.class = dockNum
	dedBars.docks.class = dockFrame

	dockFrame.config.btnType = "TrinityClassButton"
	dockFrame.config.dedType = "class"

	classDockOptions(dockFrame)

	local normalHeader = createNormalHeader(dockFrame)

	for i=1,10 do

		button = _G["TrinityClassButton"..i]

		button.config.dock = dockNum

		if (not dockFrame.headers.Normal.list[0]) then
			dockFrame.headers.Normal.list[0] = ","..button.id..",";
		else
			dockFrame.headers.Normal.list[0] = dockFrame.headers.Normal.list[0]..button.id..",";
		end
	end

	return dockFrame;
end

local function bagDockOptions(dockFrame)

	dockFrame.actionSet["Bar Target"] = false
	dockFrame.delete = nil
	dockFrame.store = function(dockFrame) TrinityBars2.StoreDock(dockFrame) end
	dockFrame.create = function(dockFrame) TrinityBars2.CreateDock(true) end
	dockFrame.clone = nil
end

local function createBagDock()

	local button
	local dockNum = #dockIndex + 1
	local dockFrame = createDockFrame(dockNum)

	dedBars.bag = dockNum
	dedBars.docks.bag = dockFrame

	dockFrame.config.btnType = "TrinityBagButton"
	dockFrame.config.dedType = "bag"

	bagDockOptions(dockFrame)

	local normalHeader = createNormalHeader(dockFrame)

	for i=1,5 do

		button = _G["TrinityBagButton"..i]

		button.config.dock = dockNum

		if (not dockFrame.headers.Normal.list[0]) then
			dockFrame.headers.Normal.list[0] = ","..button.id..",";
		else
			dockFrame.headers.Normal.list[0] = dockFrame.headers.Normal.list[0]..button.id..",";
		end
	end

	return dockFrame;
end

local function menuDockOptions(dockFrame)

	dockFrame.actionSet["Bar Target"] = false
	dockFrame.delete = nil
	dockFrame.store = function(dockFrame) TrinityBars2.StoreDock(dockFrame) end
	dockFrame.create = function(dockFrame) TrinityBars2.CreateDock(true) end
	dockFrame.clone = nil
end

local function createMenuDock()

	local button
	local dockNum = #dockIndex + 1
	local dockFrame = createDockFrame(dockNum)

	dedBars.menu = dockNum
	dedBars.docks.menu = dockFrame

	dockFrame.config.btnType = "TrinityMenuButton"
	dockFrame.config.dedType = "menu"

	menuDockOptions(dockFrame)

	local normalHeader = createNormalHeader(dockFrame)

	for i=1,10 do

		button = _G["TrinityMenuButton"..i]

		button.config.dock = dockNum

		if (not dockFrame.headers.Normal.list[0]) then
			dockFrame.headers.Normal.list[0] = ","..button.id..",";
		else
			dockFrame.headers.Normal.list[0] = dockFrame.headers.Normal.list[0]..button.id..",";
		end
	end

	return dockFrame;
end

local function mainMenuBarDockOptions(dockFrame)

	dockFrame.actionSet["Bar Target"] = false
	dockFrame.delete = nil
	dockFrame.store = function(dockFrame) TrinityBars2.StoreDock(dockFrame) end
	dockFrame.create = function(dockFrame) TrinityBars2.CreateDock(true) end
	dockFrame.clone = nil
end

local function createMainMenuBarDock()

	local button
	local dockNum = #dockIndex + 1
	local dockFrame = createDockFrame(dockNum)

	dedBars.bag = dockNum
	dedBars.docks.bag = dockFrame

	dockFrame.config.btnType = "TrinityMainMenuButton"
	dockFrame.config.dedType = "mainmenu"

	mainMenuBarDockOptions(dockFrame)

	local normalHeader = createNormalHeader(dockFrame)

	button = _G["TrinityMainMenuButton1"]

	button.config.dock = dockNum

	if (not dockFrame.headers.Normal.list[0]) then
		dockFrame.headers.Normal.list[0] = ","..button.id..",";
	else
		dockFrame.headers.Normal.list[0] = dockFrame.headers.Normal.list[0]..button.id..",";
	end

	return dockFrame;
end

--[[Action Button Creation Functions]]--

local function actionButtonDefaults(index, button)

	button.config = {
		["dock"] = 0,
		["dockpos"] = 0,
		["showstate"] = 0,
		["laststate"] = "",
		["HotKey1"] = "",
		["HotKeyText1"] = "",
		["scale"] = 1,
		["XOffset"] = 0,
		["YOffset"] = 0,
		["target"] = "none",
		["stored"] = true,
		["type"] = "spell",
		["action"] = index,
		["spell"] = "",
		["spellrank"] = 0,
		["spellranktext"] = "()",
		["macro"] = "",
		["macroicon"] = 1,
		["macroname"] = "",
		["macronote"] = "",
		["macrousenote"] = false,
		["item"] = "",
		["itemlink"] = "",
		["slot"] = 1,
		["mouseover anchor"] = false,
		["click anchor"] = false,
		["spell counts"] = false,
		["anchordelay"] = "0.1",
		["anchoredheader"] = "",
		["counts"] = false,
		["clicktype"] = "up",
	}


	tooltipScan:SetOwner(button, "ANCHOR_NONE")
	tooltipScan:SetAction(button.config.action)

	local spell, spellrank = tooltipScan:GetSpell()

	if (spell) then
		button.config.spell = spell
	end

	if (spellrank) then
		button.config.spellrank = tonumber(match(spellrank, "%d+")) or 0
		button.config.spellranktext = "("..spellrank..")"
	end
end

local function createActionButton(index)

	local button = CreateFrame("CheckButton", "TrinityActionButton"..index, TrinityBars2Options_Storage, "TrinityActionButtonTemplate")
	local buttonName, objects = button:GetName(), nil
	button:SetID(0)

	actionButtonDefaults(index, button)

	objects = getChildrenAndRegions(button)

	for k,v in pairs(objects) do
		local name = gsub(v, button:GetName(), "")
		button[lower(name)] = _G[v]
	end

	button.bindframe:SetID(index)
	button.id = index

	button:SetAttribute("onmouseupbutton", "up")

	if (TrinityBars2SavedState.firstRun) then
		TrinityBars2SavedState.buttons[index] = { button.config }
	end

	buttonIndex[index] = button

	TrinityBars2Options_Storage.data.buttonIndex[tonumber(index)] = 0;

	TrinityBars2.SetButtonType(button)

	return button
end

--[[ Storage Dock Functions ]]--

local function optionsDockFrameSetup(self)

	self:SetAttribute("state-stored", "STORED")
	self:SetAttribute("statemap-stored", "STORED:STORED")
	self:SetAttribute("statebindings","STORED:stored")
	self.data = {
		["buttonIndex"] = {},
		["petButtonIndex"] = {},
		["classButtonIndex"] = {},
		["bagButtonIndex"] = {},
		["menuButtonIndex"]= {},
	}

	dockFrameDefaults(0, TrinityBars2Options_Storage)
	TrinityBars2Options_Storage.hasAction = "Interface\\Buttons\\UI-Quickslot2"
	TrinityBars2Options_Storage.noAction = "Interface\\Buttons\\UI-Quickslot"

	local dockFrame = createDockFrame(0)
		dockFrame:SetUserPlaced(false)
		dockFrame:ClearAllPoints()
		dockFrame:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
		dockFrame:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
		dockFrame:Hide()
		dockFrame.hasAction = "Interface\\Buttons\\UI-Quickslot2"
		dockFrame.noAction = "Interface\\Buttons\\UI-Quickslot"

	local button = createActionButton(0)
		button:SetScript("OnClick", function() end) -- kill any clicks for the dummy button
		button:SetScript("OnEvent", function() end) -- kill any events for the dummy button
		button:SetScript("OnUpdate", function() end) -- kill any updates for the dummy button
		button:SetPoint("TOPRIGHT", 0, 0)
		button:SetWidth(0)
		button:SetHeight(0)
		button:SetFrameStrata("BACKGROUND")
		button:SetFrameLevel(0)
		button.config.dock = "dummy"
		button:Hide()
end

local function updateStorageDocking()

	local dockFrame = TrinityBars2Options_Storage
	local button, lastButton, count = false, false, 0

	TrinityBars2Options_Storage.data["buttonCount"] = 0

	for k,v in pairs(TrinityBars2Options_Storage.data["buttonIndex"]) do
		if (v == 1) then

			button = _G["TrinityActionButton"..k]
			button:ClearAllPoints()
			button:SetFrameStrata(dockFrame:GetFrameStrata())
			button:SetFrameLevel(4)
			button.iconframe:SetFrameLevel(2)
			button.iconframecooldown:SetFrameLevel(3)
			button.iconframebuffup:SetFrameLevel(3)
			button:SetAttribute("showstates", "STORED")
			button.config.showstate = "STORED"
			button:Show()

			updateButtonData(dockFrame, button)
			setDefaultButtonSkin(button)

			if (not lastButton) then
				button:SetPoint("TOPLEFT", "TrinityBars2Options_StorageActionButtonBorder", "TOPLEFT", 9, -(button:GetHeight()*(count/14))-9)
				lastButton = k
			else
				button:SetPoint("LEFT", _G["TrinityActionButton"..lastButton], "RIGHT")
				lastButton = k
			end

			count = count + 1

			if (mod(count,14) == 0) then
				lastButton = false
			end

			TrinityBars2Options_Storage.data["buttonCount"] = TrinityBars2Options_Storage.data["buttonCount"] + 1
		end
	end

	lastButton = false

	for k,v in pairs(TrinityBars2Options_Storage.data["petButtonIndex"]) do
		if (v == 1) then

			button = _G["TrinityPetButton"..k]
			button:ClearAllPoints()
			button:SetFrameStrata(dockFrame:GetFrameStrata())
			button:SetFrameLevel(dockFrame:GetFrameLevel()+1)
			button:SetAttribute("showstates", "STORED")
			button.config.showstate = "STORED"
			button:Show()

			updateButtonData(dockFrame, button)
			setDefaultButtonSkin(button)

			if (not lastButton) then
				button:SetPoint("TOPLEFT", "TrinityBars2Options_StoragePetButtonBorder", "TOPLEFT", 9, -9)
				lastButton = k
			else
				button:SetPoint("LEFT", _G["TrinityPetButton"..lastButton], "RIGHT")
				lastButton = k
			end
		end
	end

	lastButton = false

	for k,v in pairs(TrinityBars2Options_Storage.data["classButtonIndex"]) do
		if (v == 1) then

			button = _G["TrinityClassButton"..k]
			button:ClearAllPoints()
			button:SetFrameStrata(dockFrame:GetFrameStrata())
			button:SetFrameLevel(dockFrame:GetFrameLevel()+1)
			button:SetAttribute("showstates", "STORED")
			button.config.showstate = "STORED"
			button:Show()

			updateButtonData(dockFrame, button)
			setDefaultButtonSkin(button)

			if (not lastButton) then
				button:SetPoint("TOPLEFT", "TrinityBars2Options_StorageClassButtonBorder", "TOPLEFT", 9, -9)
				lastButton = k
			else
				button:SetPoint("LEFT", _G["TrinityClassButton"..lastButton], "RIGHT")
				lastButton = k
			end
		end
	end

	lastButton = false

	for k,v in pairs(TrinityBars2Options_Storage.data["bagButtonIndex"]) do
		if (v == 1) then

			button = _G["TrinityBagButton"..k]
			button:ClearAllPoints()
			button:SetFrameStrata(dockFrame:GetFrameStrata())
			button:SetFrameLevel(dockFrame:GetFrameLevel()+1)
			button:SetAttribute("showstates", "STORED")
			button.config.showstate = "STORED"
			button:SetScale(0.68)
			button:Show()

			updateButtonData(dockFrame, button)

			if (not lastButton) then
				button:SetPoint("TOPLEFT", "TrinityBars2Options_StorageBagButtonBorder", "TOPLEFT", 9, -9)
				lastButton = k
			else
				button:SetPoint("LEFT", _G["TrinityBagButton"..lastButton], "RIGHT", 0, 0)
				lastButton = k
			end
		end
	end

	lastButton = false

	for k,v in pairs(TrinityBars2Options_Storage.data["menuButtonIndex"]) do
		if (v == 1) then

			button = _G["TrinityMenuButton"..k]
			button:ClearAllPoints()
			button:SetFrameStrata(dockFrame:GetFrameStrata())
			button:SetFrameLevel(dockFrame:GetFrameLevel()+1)
			button:SetAttribute("showstates", "STORED")
			button.config.showstate = "STORED"
			button:Show()

			updateButtonData(dockFrame, button)

			if (not lastButton) then
				button:SetPoint("TOPLEFT", "TrinityBars2Options_StorageMenuButtonBorder", "TOPLEFT", 9, -9)
				lastButton = k
			else
				button:SetPoint("LEFT", _G["TrinityMenuButton"..lastButton], "RIGHT")
				lastButton = k
			end
		end
	end

	saveCurrentState()
end

--[[ Class Bar Functions ]]--

local function updateFormNames(update)

	updateSpellIndex()

	if (TrinityBars2SavedState.classBar) then
		clearTable(TrinityBars2SavedState.classBar)
	else
		TrinityBars2SavedState.classBar = {}
	end

	local transStates = nil;
	local classButton, normalTexture, icon, spellName, index, i, rank, setButton

	for i=1,10 do
		classButton = _G["TrinityClassButton"..i]
		classButton:SetAttribute("type", nil)
		classButton.texture = nil
		classButton.spellIndex = nil
		classButton.spellRank = nil
		classButton.altclass = false
	end

	if (UnitClass("player") == TRINITYBARS2_STRINGS.HUNTER) then

		index = 1
		i = 1

		repeat
			spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL)

   			if (spellName) then

   				if (find(spellName, TRINITYBARS2_STRINGS.ASPECT)) then

   					setButton = false

   					rank = match(spellRank, "%d+")

   					if (not rank) then
   						rank = 0
   					end

   					rank = tonumber(rank)

					if (not TrinityBars2SavedState.classBar[spellName]) then
						TrinityBars2SavedState.classBar[spellName] = { index, rank }
						setButton = true
					elseif (rank > TrinityBars2SavedState.classBar[spellName][2]) then
						index = index - 1
						TrinityBars2SavedState.classBar[spellName] = { index, rank }
						setButton = true
					end

   					if (setButton) then

		 				classButton = _G["TrinityClassButton"..index]
		 				normalTexture = _G[classButton:GetName().."IconFrameIcon"]
		 				icon = GetSpellTexture(i, BOOKTYPE_SPELL)

		 				classButton:SetAttribute("type", "spell")
		 				classButton:SetAttribute("*spell*", spellName)
						normalTexture:SetTexture(icon)

						classButton.texture = icon
						if (classButton.config.spell ~= spellName) then
							classButton.config.trans = ""
						end
						classButton.config.spell = spellName
						classButton.spellIndex = i
						classButton.altclass = 1

						index = index + 1
					end
				end
   			end

   			i = i + 1

   		until (not spellName)

   		TrinityBars2SavedState.classBar["none"] = "No Page"

   	elseif (UnitClass("player") == TRINITYBARS2_STRINGS.PRIEST or UnitClass("player") == TRINITYBARS2_STRINGS.SHAMAN) then

		index = 1
		i = 1

		repeat
			spellName, _ = GetSpellName(i, BOOKTYPE_SPELL)

   			if (spellName) then
   				if (find(spellName, "Shadowform") or find(spellName, "Ghost Wolf")) then

   					if (not TrinityBars2SavedState.classBar[spellName]) then
						TrinityBars2SavedState.classBar[spellName] = index
						index = index + 1
					end

		 			classButton = _G["TrinityClassButton"..TrinityBars2SavedState.classBar[spellName]]
		 			normalTexture = _G[classButton:GetName().."IconFrameIcon"]
		 			icon = GetSpellTexture(i, BOOKTYPE_SPELL)

		 			classButton:SetAttribute("type", "spell")
		 			classButton:SetAttribute("*spell*", spellName)
					normalTexture:SetTexture(icon)

					classButton.texture = icon
					if (classButton.config.spell ~= spellName) then
						classButton.config.trans = ""
					end
					classButton.config.spell = spellName
					classButton.spellIndex = i

					if (UnitClass("player") == TRINITYBARS2_STRINGS.SHAMAN) then
						classButton.altclass = 1
					else
						classButton.altclass = 2
					end
				end
   			end

   			i = i + 1

   		until (not spellName)

	else

		index = 1

 		for i=1,GetNumShapeshiftForms() do

 			classButton = _G["TrinityClassButton"..i]
 			normalTexture = _G[classButton:GetName().."IconFrameIcon"]
 			icon, formName, _ = GetShapeshiftFormInfo(i)

 			classButton:SetAttribute("type", "spell")
 			classButton:SetAttribute("*spell*", formName)
			normalTexture:SetTexture(icon)

 			TrinityBars2SavedState.classBar[formName] = i;

 		end

		repeat
			spellName, _ = GetSpellName(index, BOOKTYPE_SPELL)

			if (TrinityBars2SavedState.classBar[spellName]) then
				classButton = _G["TrinityClassButton"..TrinityBars2SavedState.classBar[spellName]]
				icon = GetSpellTexture(index, BOOKTYPE_SPELL)

				classButton.texture = icon
				if (classButton.config.spell ~= spellName) then
					classButton.config.trans = ""
				end
				classButton.config.spell = spellName
				classButton.spellIndex = index
			end

			index = index + 1

		until (not spellName)
 	end

 	if (UnitClass("player") == TRINITYBARS2_STRINGS.DRUID) then

		if (not TrinityBars2SavedState.classBar["Caster Form"]) then
 			TrinityBars2SavedState.classBar["Caster Form"] = 0;
 		end
 		if (not TrinityBars2SavedState.classBar["Prowl"]) then
 			TrinityBars2SavedState.classBar["Prowl"] = 8;
 		end
 		if (not TrinityBars2SavedState.classBar["Bear Form"]) then
 			TrinityBars2SavedState.classBar["Bear Form"] = "NOTKNOWN";
 		end
 		if (not TrinityBars2SavedState.classBar["Dire Bear Form"]) then
 			TrinityBars2SavedState.classBar["Dire Bear Form"] = "NOTKNOWN";
 		end
 		if (not TrinityBars2SavedState.classBar["Cat Form"]) then
 			TrinityBars2SavedState.classBar["Cat Form"] = "NOTKNOWN";
 		end
 		if (not TrinityBars2SavedState.classBar["Aquatic Form"]) then
 			TrinityBars2SavedState.classBar["Aquatic Form"] = "NOTKNOWN";
 		end
 		if (not TrinityBars2SavedState.classBar["Travel Form"]) then
 			TrinityBars2SavedState.classBar["Travel Form"] = "NOTKNOWN";
 		end
 		if (not TrinityBars2SavedState.classBar["Moonkin Form"]) then
 			TrinityBars2SavedState.classBar["Moonkin Form"] = "NOTKNOWN";
 		end
 		if (not TrinityBars2SavedState.classBar["Tree of Life"]) then
 			TrinityBars2SavedState.classBar["Tree of Life"] = "NOTKNOWN";
 		end
 		if (not TrinityBars2SavedState.classBar["Flight Form"]) then
 			TrinityBars2SavedState.classBar["Flight Form"] = "NOTKNOWN";
 		end
 		if (not TrinityBars2SavedState.classBar["Swift Flight Form"]) then
 			TrinityBars2SavedState.classBar["Swift Flight Form"] = "NOTKNOWN";
 		end

 	end

 	if (UnitClass("player") == TRINITYBARS2_STRINGS.WARRIOR) then

 		if (not TrinityBars2SavedState.classBar["Defensive Stance"]) then
 			TrinityBars2SavedState.classBar["Defensive Stance"] = "NOTKNOWN";
 		end
 		if (not TrinityBars2SavedState.classBar["Berserker Stance"]) then
 			TrinityBars2SavedState.classBar["Berserker Stance"] = "NOTKNOWN";
 		end

 	end

 	if (UnitClass("player") == TRINITYBARS2_STRINGS.PRIEST) then

		if (not TrinityBars2SavedState.classBar["Healer Form"]) then
 			TrinityBars2SavedState.classBar["Healer Form"] = 0;
 		end
 		if (not TrinityBars2SavedState.classBar["Shadowform"]) then
 			TrinityBars2SavedState.classBar["Shadowform"] = "NOTKNOWN";
 		end

 	end

 	if (UnitClass("player") == TRINITYBARS2_STRINGS.ROGUE) then

 		if (not TrinityBars2SavedState.classBar["Attack"]) then
 			TrinityBars2SavedState.classBar["Attack"] = 0
 		end

 		if (not TrinityBars2SavedState.classBar["Stealth"]) then
 			TrinityBars2SavedState.classBar["Stealth"] = "NOTKNOWN";
 		end
 	end

 	for k,dockFrame in pairs(dockIndex) do
 		for key, value in pairs(TrinityBars2SavedState.classBar) do
 			if (not dockFrame.config.stanceTrans[key] and value ~= "NOTKNOWN") then
 				if (UnitClass("player") == TRINITYBARS2_STRINGS.HUNTER) then
 					if (value[1]) then
 						dockFrame.config.stanceTrans[key] = "Page "..value[1]
 					end
 				else
 					dockFrame.config.stanceTrans[key] = key
 				end
 			end
 		end
 	end
end

local function updateClassBar()

	local button

	updateDocking(dedBars.docks.class)

	for i=1,10 do
		TrinityBars2.AddButton(dedBars.docks.class)
	end

	updateFormNames()

 	for i=1,10 do
 		button = _G["TrinityClassButton"..i]
 		if (button.texture == nil) then
 			TrinityBars2.SubtractButton(dedBars.docks.class, nil, button)
 		end
 	end

 	updateDocking(dedBars.docks.class)

 	updateStorageDocking()
end

--[[ Class Defaults Funtion ]]--

local function initializeClassDefaults()

	updateFormNames()

	local pos, showstate, button, dockFrame, normalHeader, actionbarHeader, stanceHeader, stealthHeader, index, numMade
	local barMade, makebtns = false, true

	if (UnitClass("player") == TRINITYBARS2_STRINGS.DRUID) then

		dockFrame = createDockFrame(#dockIndex+1)
		dockFrame.config.btnType = "TrinityActionButton"
		dockFrame.config.showgrid = true

		normalHeader = createNormalHeader(dockFrame)

		pos=0
		stanceHeader = createStanceHeader(dockFrame)
		dockFrame.headers["Stance"]["order"] = 1
		for showstate=dockFrame.headers["Stance"]["start"],dockFrame.headers["Stance"]["end"] do
 			if (showstate == TrinityBars2SavedState.classBar["Bear Form"]) then
				pos=96
				makebtns = true
 			elseif (showstate == TrinityBars2SavedState.classBar["Dire Bear Form"]) then
 				pos=96
 				makebtns = true
 			elseif (showstate == TrinityBars2SavedState.classBar["Moonkin Form"]) then
 				pos=84
 				makebtns = true
 			elseif (showstate == TrinityBars2SavedState.classBar["Tree of Life"]) then
 				pos=84
 				makebtns = true
 			elseif (showstate == TrinityBars2SavedState.classBar["Cat Form"]) then
 				pos=72
 				makebtns = true
			end
			if (makebtns) then
				for index=1,12 do
					button = createActionButton(index+pos)
					button.config.dock = dockFrame:GetID()
					button.config.anchoredheader = dockFrame.headers.Normal.name
					button.dockFrame = dockFrame
					TrinityBars2.SetButtonType(button)
					dockFrame.headers["Stance"]["list"][showstate] = dockFrame.headers["Stance"]["list"][showstate]..button.id..",";
				end
			end
			makebtns = false
		end
		normalHeader:SetAttribute("addchild", stanceHeader)
		stanceHeader:SetAttribute("showstates", "0")
		dockFrame.headers["Stance"]["parent"] = normalHeader:GetName()
		dockFrame.headers["Stance"]["showstate"] = 0;

		barMade = true

	elseif (UnitClass("player") == TRINITYBARS2_STRINGS.WARRIOR) then

		dockFrame = createDockFrame(#dockIndex+1)
		dockFrame.config.btnType = "TrinityActionButton"
		dockFrame.config.showgrid = true

		normalHeader = createNormalHeader(dockFrame)

		pos=0
		stanceHeader = createStanceHeader(dockFrame)
		dockFrame.headers["Stance"]["order"] = 1
		makebtns = false
		for showstate=dockFrame.headers["Stance"]["start"],dockFrame.headers["Stance"]["end"] do
 			if (showstate == TrinityBars2SavedState.classBar["Battle Stance"]) then
				pos=72
				makebtns = true
 			elseif (showstate == TrinityBars2SavedState.classBar["Defensive Stance"]) then
 				pos=84
 				makebtns = true
 			elseif (showstate == TrinityBars2SavedState.classBar["Berserker Stance"]) then
 				pos=96
 				makebtns = true
			end
			if (makebtns) then
				for index=1,12 do
					button = createActionButton(index+pos)
					button.config.dock = dockFrame:GetID()
					button.config.anchoredheader = dockFrame.headers.Normal.name
					button.dockFrame = dockFrame
					TrinityBars2.SetButtonType(button)
					dockFrame.headers["Stance"]["list"][showstate] = dockFrame.headers["Stance"]["list"][showstate]..button.id..",";
				end
			end
			makebtns = false
		end
		normalHeader:SetAttribute("addchild", stanceHeader)
		stanceHeader:SetAttribute("showstates", "0")
		dockFrame.headers["Stance"]["parent"] = normalHeader:GetName()
		dockFrame.headers["Stance"]["showstate"] = 0;

		barMade = true

	elseif (UnitClass("player") == TRINITYBARS2_STRINGS.ROGUE) then

		dockFrame = createDockFrame(#dockIndex+1)
		dockFrame.config.btnType = "TrinityActionButton"
		dockFrame.config.showgrid = true

		normalHeader = createNormalHeader(dockFrame)

		pos=0
		stanceHeader = createStanceHeader(dockFrame)
		dockFrame.headers["Stance"]["order"] = 1
		for showstate=dockFrame.headers["Stance"]["start"],dockFrame.headers["Stance"]["end"] do
 			if (showstate == TrinityBars2SavedState.classBar["Stealth"]) then
				pos=72
				makebtns = true
			end
			if (makebtns) then
				for index=1,12 do
					button = createActionButton(index+pos)
					button.config.dock = dockFrame:GetID()
					button.config.anchoredheader = dockFrame.headers.Normal.name
					button.dockFrame = dockFrame
					TrinityBars2.SetButtonType(button)
					dockFrame.headers["Stance"]["list"][showstate] = dockFrame.headers["Stance"]["list"][showstate]..button.id..",";
				end
			end
			makebtns = false
		end
		normalHeader:SetAttribute("addchild", stanceHeader)
		stanceHeader:SetAttribute("showstates", "0")
		dockFrame.headers["Stance"]["parent"] = normalHeader:GetName()
		dockFrame.headers["Stance"]["showstate"] = 0;

		barMade = true
	end

	if (not barMade) then

		dockFrame = createDockFrame(#dockIndex+1)
		dockFrame.config.btnType = "TrinityActionButton"
		dockFrame.config.showgrid = true
		normalHeader = createNormalHeader(dockFrame)

		index = 1
		numMade = 0

		while (numMade < 12) do

			if (not _G["TrinityActionButton"..index]) then

				button = createActionButton(index)
				button.config.dock = dockFrame:GetID()
				button.config.anchoredheader = dockFrame.headers.Normal.name
				button.dockFrame = dockFrame
				TrinityBars2.SetButtonType(button)
				dockFrame.headers.Normal.list[0] = dockFrame.headers.Normal.list[0]..button.id..",";
				numMade = numMade + 1
			end

			index = index + 1
		end




	end

	createPetDock()
 	createClassDock()
 	createBagDock()
 	createMenuDock()
 	--createMainMenuBarDock()
end

--[[ Button Update Functions ]]--

local function updateButtonColors(self, hasAction)

	local alpha = 0.35

	if (hasAction) then

		alpha = 1

		if (self.hasAction) then
			self.normaltexture:SetTexture(self.hasAction)
		end
	else

		if (self.noAction) then
			self.normaltexture:SetTexture(self.noAction)
		end
	end

	if (self.skincolor) then
		self.normaltexture:SetVertexColor(self.skincolor[1],self.skincolor[2],self.skincolor[3], alpha)
		self.pushedtexture:SetVertexColor(self.skincolor[1],self.skincolor[2],self.skincolor[3], alpha)
	else
		self.normaltexture:SetVertexColor(1,1,1,1)
		self.pushedtexture:SetVertexColor(1,1,1,1)
	end

	if (self.hovercolor) then
		self.highlighttexture:SetVertexColor(self.hovercolor[1],self.hovercolor[2],self.hovercolor[3], alpha)
	else
		self.highlighttexture:SetVertexColor(1,1,1,1)
	end

	if (self.equipcolor) then
		self.border:SetVertexColor(self.equipcolor[1],self.equipcolor[2],self.equipcolor[3], alpha)
	else
		self.border:SetVertexColor(1,1,1,1)
	end
end

local function updateCooldownText(button, start, duration, enable)

	if (not button.cooldowntext) then
		return
	end

	-- cooldown code courtesy of hacocuk from Curse Gaming (modified)

	if ( start > 0 and duration > 4 and enable > 0) then

		local coolDown = ceil(duration-(GetTime()-start))
		local formatted = coolDown

		if (coolDown < 6) then
			button.cooldowntext:Hide()
			button.cooldowntexthuge:Show()
		else
			button.cooldowntext:Show()
			button.cooldowntexthuge:Hide()
		end

		if (coolDown >= 60) then
			formatted = ceil(coolDown/60)
			formatted = formatted.."m";
		end

		if (coolDown >= 3600) then
			formatted = ceil(coolDown/3600)
			formatted = formatted.."h";
		end

		if (coolDown >= 86400) then
			formatted = ceil(coolDown/86400)
			formatted = formatted.."d";
		end

		button.cooldowntexthuge:SetText(formatted)
		button.cooldowntext:SetText(formatted)
	else
		button.cooldowntext:SetText("")
		button.cooldowntexthuge:SetText("")
	end
end

local function updateBuffInfo(unit)

	local spell, rank, _, count, duration, debuffType, timeLeft
	local index = 1

	clearTable(unitBuffs[unit])

	repeat
		spell, rank, _, count, duration, timeLeft = UnitBuff(unit, index)

		if (duration) then
			unitBuffs[unit][spell] = { "buff", rank, count, duration, timeLeft }
		end

		index = index + 1

   	until (not spell)

	index = 1

	repeat

		spell, rank, _, count, debuffType, duration, timeLeft = UnitDebuff(unit, index)

		if (duration) then
			unitBuffs[unit][spell] = { "debuff", rank, count, duration, timeLeft, debuffType }
		end

		index = index + 1

	until (not spell)
end

local function updateBuffup_OnEvent(self, unit, spell)

	if (unitBuffs[unit][spell]) then

		if (unitBuffs[unit][spell][1] == "buff") then

			if (checkButtons[206]) then

				self.border:SetVertexColor(self.buffcolor[1], self.buffcolor[2], self.buffcolor[3], 1.0)
				self.buffup = true
				self.border:Show()
			else
				self.border:SetVertexColor(0.0, 0.0, 0.0, 0.0)
			end

			if (checkButtons[205] and self.cdduration < 4) then

				local duration = unitBuffs[unit][spell][4]
				local timeLeft = unitBuffs[unit][spell][5]

				if (duration and timeLeft > 4) then

					if (self.bdcolornorm) then
						self.cooldowntext:SetTextColor(self.bdcolornorm[1], self.bdcolornorm[2], self.bdcolornorm[3])
						self.cooldowntexthuge:SetTextColor(self.bdcolorlarge[1], self.bdcolorlarge[2], self.bdcolorlarge[3])
					end

					CooldownFrame_SetTimer(self.iconframebuffup, GetTime()-(duration-timeLeft), duration, 1)
				end

				self.buffup = true
				self.border:Show()
			else
				CooldownFrame_SetTimer(self.iconframebuffup, 0, 0, 0)
			end

		elseif (unitBuffs[unit][spell][1] == "debuff" and unit == "target") then

			if (checkButtons[206]) then
				self.border:SetVertexColor(self.debuffcolor[1], self.debuffcolor[2], self.debuffcolor[3], 1.0)
				self.buffup = true
				self.border:Show()
			else
				self.border:SetVertexColor(0.0, 0.0, 0.0, 0.0)
			end

			if (checkButtons[205] and self.cdduration < 4) then

				local duration = unitBuffs[unit][spell][4]
				local timeLeft = unitBuffs[unit][spell][5]

				if (duration and timeLeft > 4) then

					if (self.bdcolornorm) then
						self.cooldowntext:SetTextColor(self.bdcolornorm[1], self.bdcolornorm[2], self.bdcolornorm[3])
						self.cooldowntexthuge:SetTextColor(self.bdcolorlarge[1], self.bdcolorlarge[2], self.bdcolorlarge[3])
					end

					CooldownFrame_SetTimer(self.iconframebuffup, GetTime()-(duration-timeLeft), duration, 1)
				end

				self.buffup = true
				self.border:Show()
			else
				CooldownFrame_SetTimer(self.iconframebuffup, 0, 0, 0)
			end
		end

		self.buffupunit = unit

	elseif (self.buffupunit == unit) then

		self.buffup = false

		CooldownFrame_SetTimer(self.iconframebuffup, 0, 0, 0)

		if (checkButtons[105]) then
			updateCooldownText(self, 0, 0, 0)
		end

		self.border:Hide()
	end
end

local function updateBuffup_OnUpdate(self, unit, spell)

	if (checkButtons[105] and checkButtons[205]) then

		updateBuffInfo(unit)

		if (unitBuffs[unit][spell]) then

			local duration = unitBuffs[unit][spell][4]
			local timeLeft = unitBuffs[unit][spell][5]

			if (duration) then
				updateCooldownText(self,  GetTime()-(duration-timeLeft) or 0, duration or 0, timeLeft or 0)
			else
				updateCooldownText(self, 0, 0, 0)
			end
		end
	else
		updateCooldownText(self, 0, 0, 0)
	end
end

--[[ "action" button functions ]]--

local function actionButton_SetTooltip(self)

	local action = self.config.action

	self.UpdateTooltip = nil

	if (action and action ~= "") then
		GameTooltip:SetAction(action)
		self.UpdateTooltip = actionButton_SetTooltip
	end
end

local function updateActionButton(self, action)

	if (self.editmode) then
		self.iconframeicon:SetVertexColor(0.2, 0.2, 0.2)
	else
		local isUsable, notEnoughMana = IsUsableAction(action)

		if (isUsable) then
			if (IsActionInRange(action, self.target) == 0) then
				if (self.rangecolor) then
					self.iconframeicon:SetVertexColor(self.rangecolor[1], self.rangecolor[2], self.rangecolor[3])
				else
					self.iconframeicon:SetVertexColor(0.15, 0.7, 0.15)
				end
			else
				self.iconframeicon:SetVertexColor(1.0, 1.0, 1.0)
			end
		elseif (notEnoughMana) then
			if (self.manacolor) then
				self.iconframeicon:SetVertexColor(self.manacolor[1], self.manacolor[2], self.manacolor[3])
			else
				self.iconframeicon:SetVertexColor(0.2, 0.3, 0.0)
			end
		else
			self.iconframeicon:SetVertexColor(0.3, 0.3, 0.3)
		end
	end
end

local function updateActionIcon(self, hasAction, action)

	if (hasAction) then
		self.iconframeicon:SetTexture(GetActionTexture(action))
		self.iconframeicon:Show()
	else
		self.iconframeicon:Hide()
	end
end

local function updateActionCount(self, action)

	self.count:SetText("")

	if ( IsConsumableAction(action) ) then

		self.count:SetText(GetActionCount(action))
		self.count:SetTextColor(1,1,1)

	elseif (self.config["spell counts"]) then

		local amount, powertype = getPowertypeAmount(self)

		if (amount) then

			local count = floor(UnitMana("player")/amount)

			if (count > 0 and powerColors[powertype]) then
				self.count:SetText(count)
				self.count:SetTextColor(powerColors[powertype].r, powerColors[powertype].g, powerColors[powertype].b)
			end
		end
	end
end

local function updateActionState(self, action)

	if (IsCurrentAction(action) or IsAutoRepeatAction(action)) then
		self:SetChecked(1)
	else
		self:SetChecked(nil)
	end

	if ( (IsAttackAction(action) and IsCurrentAction(action)) or IsAutoRepeatAction(action) ) then
		self.flash = true
	else
		self.flash = false
	end
end

local function updateAction_OnEvent(self, action)

	tooltipScan:SetOwner(self, "ANCHOR_NONE")
	tooltipScan:SetAction(action)

	local spell, spellrank = tooltipScan:GetSpell()

	tooltipScan:ClearLines()

	if (spell) then
		self.config.spell = spell
	end

	if (spellrank) then
		self.config.spellrank = tonumber(match(spellrank, "%d+")) or 0
		self.config.spellranktext = "("..spellrank..")"
	end

	if (not self.dockFrame) then
		self.dockFrame = _G["TrinityDockFrame"..self.config.dock]
	end

	if (checkButtons[302]) then
		self.name:Show()
		self.name:SetText(GetActionText(action))
	else
		self.name:Hide()
	end

	if ( IsEquippedAction(action) ) then

		self.border:SetVertexColor(0, 1.0, 0, 0.5)
		self.border:Show()

	elseif (not self.buffup) then

		self.border:Hide()
	end

	if ( HasAction(action) ) then

		updateButtonColors(self, true)
		updateActionIcon(self, true, action)

	else
		updateButtonColors(self, false)
		updateActionIcon(self, false, action)
	end

	updateActionCount(self, action)
	updateActionState(self, action)
end

local function updateActionCooldown_OnEvent(self, update, num, action)

	self.cdduration = 0

	if (HasAction(action)) then

		local start, duration, enable = GetActionCooldown(action)

		if (enable) then

			if (self.cdcolornorm and duration > 4) then
				self.cooldowntext:SetTextColor(self.cdcolornorm[1], self.cdcolornorm[2], self.cdcolornorm[3])
				self.cooldowntexthuge:SetTextColor(self.cdcolorlarge[1], self.cdcolorlarge[2], self.cdcolorlarge[3])
			end

			if ( start > 0 and duration > 0 and enable > 0) then
				CooldownFrame_SetTimer(self.iconframecooldown, start, duration, enable)
				self.cooldown = true;
				self.cdduration = duration
			else
				CooldownFrame_SetTimer(self.iconframecooldown, 0, 0, 0)
				self.cooldowntext:SetText("")
				self.cooldowntexthuge:SetText("")
			end
		end

	elseif (update) then

		CooldownFrame_SetTimer(self.iconframecooldown, 0, 0, 0)
		self.cooldowntext:SetText("")
		self.cooldowntexthuge:SetText("")
	end
end

local function updateActionCooldown_OnUpdate(self, action)

	local start, duration, enable = GetActionCooldown(action)

	if (start == 0) then
		self.cooldown = nil
	end

	if (self.alpha and duration) then
		if (self.cooldown and duration > 4) then
			if (self:GetAlpha() ~= cooldownAlpha) then
				self:SetAlpha(cooldownAlpha)
			end
		else
			if (self:GetAlpha() ~= 1) then
				self:SetAlpha(1)
			end
		end
	end

	if (checkButtons[105]) then
		updateCooldownText(self, start or 0, duration or 0, enable or 0)
	end
end

local function actionButton_OnUpdate(self, elapsed)

	self.elapsed = self.elapsed + elapsed

	if (self.flash) then

		self.flashing = true

		if (alphaDir == 1) then
			if ((1-(alphaTimer)) >= 0) then
				self.checkedtexture:SetVertexColor(1, 1, 1, 1)
			end
		elseif (alphaDir == 0) then
			if ((alphaTimer) <= 1) then
				self.checkedtexture:SetVertexColor(0.8, 0, 0, 1)
			end
		end

	elseif (self.flashing) then

		self.checkedtexture:SetVertexColor(1, 1, 1, 1)
		self.flashing = false
	end

	if (self.elapsed > 0.2) then
		updateActionButton(self, self.config.action)
		if (self.cooldown) then
			updateActionCooldown_OnUpdate(self, self.config.action)
		end
		if (self.buffup and self.buffupunit) then
			updateBuffup_OnUpdate(self, self.buffupunit, self.config.spell)
		end
		self.elapsed = 0;
	end
end

local function action_OnEvent(self, event, ...)

	if (event == "ACTIONBAR_SLOT_CHANGED") then

		local action = self.config.action

		if (... == 0 or ... == action) then

			updateAction_OnEvent(self, action)
			updateActionCooldown_OnEvent(self, true, 1, action)
			updateBuffup_OnEvent(self, "player", self.config.spell)
			updateBuffup_OnEvent(self, "target", self.config.spell)


			if (... ~= 0) then
				if (self:GetAttribute("showstates") == "NOACTION") then
					self:SetAttribute("showstates", self.config.showstate)
					self:Show()
				end
			end
		end

	elseif (event == "ACTIONBAR_UPDATE_COOLDOWN") then

		updateActionCooldown_OnEvent(self, true, 2, self.config.action)

	elseif ( event == "ACTIONBAR_UPDATE_STATE" or event == "CRAFT_SHOW" or event == "CRAFT_CLOSE" or event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_CLOSE" ) then

		updateActionState(self, self.config.action)

	elseif (event == "ACTIONBAR_SHOWGRID") then

		if (not InCombatLockdown()) then
			self:SetAttribute("showstates", self.config.showstate)
			if (self.config.showstate == tonumber(self:GetAttribute("state-parent"))) then
				self:Show()
			end
		end

	elseif (event == "ACTIONBAR_HIDEGRID") then

		if (not InCombatLockdown()) then
			if (not Trinity2.configMode) then
				if (not playerEnteredWorld) then
					if (not self.config["mouseover anchor"] and not self.config["click anchor"]) then
						if (not HasAction(self.config.action) and not self.dockFrame.config.showgrid and not self.config.stored) then
							self:SetAttribute("showstates", "NOACTION")
							self:Hide()
						end
					end
				else
					if (not self.config["mouseover anchor"] and not self.config["click anchor"]) then
						if (not HasAction(self.config.action) and not MouseIsOver(self) and not self.dockFrame.config.showgrid and not self.config.stored) then
							self:SetAttribute("showstates", "NOACTION")
							self:Hide()
						end
					end
				end
			end
		end

	elseif (event == "UNIT_INVENTORY_CHANGED") then

		if (... == "player") then
			local action = self.config.action
			updateActionIcon(self, HasAction(action), action)
		end

	elseif (event == "UPDATE_SHAPESHIFT_FORM" or event == "BAG_UPDATE") then

		local action = self.config.action
		updateActionCount(self, self.config.action)
		updateActionIcon(self, HasAction(action), action)

	elseif (event == "UNIT_AURA") then

		if (... == "player" or ... == "target") then
			updateActionCount(self, self.config.action)
			updateBuffup_OnEvent(self, ..., self.config.spell)
		end

	elseif (event == "UNIT_MANA" or event == "UNIT_RAGE" or event == "UNIT_ENERGY") then

		if (... == "player") then
			updateActionCount(self, self.config.action)
		end

	elseif (event == "PLAYER_TARGET_CHANGED") then

		updateBuffup_OnEvent(self, "target", self.config.spell)

	elseif (event == "PLAYER_ENTERING_WORLD") then

		local action = self.config.action

		updateAction_OnEvent(self, action)
		updateActionCooldown_OnEvent(self, nil, 3, action)
		updateBuffup_OnEvent(self, "player", self.config.spell)
		updateActionState(self, action)

	elseif ( event == "PLAYER_ENTER_COMBAT" or event == "PLAYER_LEAVE_COMBAT") then

		local action = self.config.action
		if (IsAttackAction(action)) then
			updateActionState(self, action)
		end

	elseif ( event == "START_AUTOREPEAT_SPELL" ) then

		local action = self.config.action
		if (IsAutoRepeatAction(action)) then
			updateActionState(self, action)
		end

	elseif ( event == "STOP_AUTOREPEAT_SPELL" ) then

		local action = self.config.action
		if (self.flashing and not IsAttackAction(action)) then
			updateActionState(self, action)
		end
	end
end

--[[ "spell" button functions ]]--

local function spellButton_SetTooltip(self)

	local spell = lower(self.config.spell)

	self.UpdateTooltip = nil

	if (spell and spell ~= "") then

		spell = spell..self.config.spellranktext or ""

		if (spellIndex[lower(spell)]) then

			if (self.UberTooltips) then

				GameTooltip:SetSpell(spellIndex[lower(spell)][1], "spell")

				GameTooltipTextRight1:SetText(gsub(self.config.spellranktext, "%((.*)%)", "%1"))
				GameTooltipTextRight1:SetTextColor(0.5,0.5,0.5)
				GameTooltipTextRight1:Show()

				self.UpdateTooltip = spellButton_SetTooltip
			else

				GameTooltip:SetText(self.config.spell)
				GameTooltipTextLeft1:SetTextColor(1,1,1)
				GameTooltipTextLeft1:Show()

				GameTooltipTextRight1:SetText(gsub(self.config.spellranktext, "%((.*)%)", "%1"))
				GameTooltipTextRight1:SetTextColor(0.5,0.5,0.5)
				GameTooltipTextRight1:Show()

				self.UpdateTooltip = nil
			end
		end
	end
end

local function updateSpellButton(self, spell)

	if (self.editmode) then
		self.iconframeicon:SetVertexColor(0.2, 0.2, 0.2)
	else

		if (spell and spell ~= "") then

			spell = spell..self.config.spellranktext or "()"

			local isUsable, notEnoughMana = IsUsableSpell(spell)

			if (isUsable) then
				if (IsSpellInRange(spell, self.target) == 0) then
					self.iconframeicon:SetVertexColor(self.rangecolor[1], self.rangecolor[2], self.rangecolor[3])
				else
					self.iconframeicon:SetVertexColor(1.0, 1.0, 1.0)
				end
			elseif (notEnoughMana) then
				self.iconframeicon:SetVertexColor(self.manacolor[1], self.manacolor[2], self.manacolor[3])
			else
				self.iconframeicon:SetVertexColor(0.3, 0.3, 0.3)
			end
		else
			self.iconframeicon:SetVertexColor(1.0, 1.0, 1.0)
		end
	end
end

local function updateSpellIcon(self, spell)

	if (spell and spell ~= "") then

		spell = spell..self.config.spellranktext or "()"

		self.iconframeicon:SetTexture(GetSpellTexture(spell))
		self.iconframeicon:Show()
	else
		self.iconframeicon:Hide()
	end
end

local function updateSpellCount(self, spell)

	self.count:SetText("")

	spell = spell..self.config.spellranktext or "()"

	if ( IsConsumableSpell(spell) ) then

		self.count:SetText(GetSpellCount(spell))
		self.count:SetTextColor(1,1,1)

	elseif (self.config["spell counts"]) then

		local amount, powertype = getPowertypeAmount(self)

		if (amount) then

			local count = floor(UnitMana("player")/amount)

			if (count > 0 and powerColors[powertype]) then
				self.count:SetText(count)
				self.count:SetTextColor(powerColors[powertype].r, powerColors[powertype].g, powerColors[powertype].b)
			end
		end
	end
end

local function updateSpellState(self, spell)

	if (spell and spell ~= "") then

		spell = spell..self.config.spellranktext or "()"

		if (IsCurrentSpell(spell) or IsAutoRepeatSpell(spell)) then
			self:SetChecked(1)
		else
			self:SetChecked(nil)
		end

		if ((IsAttackSpell(spell) and IsCurrentSpell(spell)) or IsAutoRepeatSpell(spell)) then
			self.flash = true
		else
			self.flash = false
		end
	else
		self:SetChecked(nil)
	end
end

local function updateSpell_OnEvent(self, spell)

	if (not self.config.spellrank or self.config.spellrank == "") then

		if (spellIndex[spell]) then
			self.config.spellrank = spellIndex[spell][2]
		else
			self.config.spellrank = 0
		end
	end

	if (not self.config.spellranktext or self.config.spellranktext == "") then

		if (spellIndex[spell]) then

			if (spellIndex[spell][2]) then
				self.config.spellranktext = "(Rank "..spellIndex[spell][2]..")"
			else
				self.config.spellranktext = "()"
			end
		else
			self.config.spellranktext = "()"
		end
	end

	if (spell and spell ~= "") then

		updateButtonColors(self, true)
	else
		updateButtonColors(self, false)
	end

	updateSpellIcon(self, spell)
	updateSpellCount(self, spell)
	updateSpellState(self, spell)
end

local function updateSpellCooldown_OnEvent(self, update, spell)

	self.cdduration = 0

	if (spell and spell ~= "") then

		spell = spell..self.config.spellranktext or "()"

		local start, duration, enable = GetSpellCooldown(spell)

		if (enable) then

			if (self.cdcolornorm and duration > 4) then
				self.cooldowntext:SetTextColor(self.cdcolornorm[1], self.cdcolornorm[2], self.cdcolornorm[3])
				self.cooldowntexthuge:SetTextColor(self.cdcolorlarge[1], self.cdcolorlarge[2], self.cdcolorlarge[3])
			end

			if ( start > 0 and duration > 0 and enable > 0) then
				CooldownFrame_SetTimer(self.iconframecooldown, start, duration, enable)
				self.cooldown = true;
				self.cdduration = duration
			else
				CooldownFrame_SetTimer(self.iconframecooldown, 0, 0, 0)
				self.cooldowntext:SetText("")
				self.cooldowntexthuge:SetText("")
			end
		end

	elseif (update) then
		CooldownFrame_SetTimer(self.iconframecooldown, 0, 0, 0)
		self.cooldowntext:SetText("")
		self.cooldowntexthuge:SetText("")
	end
end

local function updateSpellCooldown_OnUpdate(self, spell)

	local start, duration, enable = GetSpellCooldown(spell)

	if (start == 0) then
		self.cooldown = nil
	end

	if (self.alpha and duration) then
		if (self.cooldown and duration > 4) then
			if (self:GetAlpha() ~= cooldownAlpha) then
				self:SetAlpha(cooldownAlpha)
			end
		else
			if (self:GetAlpha() ~= 1) then
				self:SetAlpha(1)
			end
		end
	end

	if (checkButtons[105]) then
		updateCooldownText(self, start or 0, duration or 0, enable or 0)
	end
end

local function spellButton_OnUpdate(self, elapsed)

	self.elapsed = self.elapsed + elapsed

	if (self.flash) then

		self.flashing = true

		if (alphaDir == 1) then
			if ((1-(alphaTimer)) >= 0) then
				self.checkedtexture:SetVertexColor(1, 1, 1, 1)
			end
		elseif (alphaDir == 0) then
			if ((alphaTimer) <= 1) then
				self.checkedtexture:SetVertexColor(0.8, 0, 0, 1)
			end
		end

	elseif (self.flashing) then

		self.checkedtexture:SetVertexColor(1, 1, 1, 1)
		self.flashing = false
	end

	if (self.elapsed > 0.2) then
		updateSpellButton(self, self.config.spell)
		if (self.cooldown) then
			updateSpellCooldown_OnUpdate(self, self.config.spell)
		end
		if (self.buffup and self.buffupunit) then
			updateBuffup_OnUpdate(self, self.buffupunit, self.config.spell)
		end

		self.elapsed = 0
	end
end

local function spell_OnEvent(self, event, ...)

	if (event == "ACTIONBAR_UPDATE_COOLDOWN") then

		updateSpellCooldown_OnEvent(self, true, self.config.spell)

	elseif ( event == "ACTIONBAR_UPDATE_STATE" or event == "CRAFT_SHOW" or event == "CRAFT_CLOSE" or event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_CLOSE" ) then

		updateSpellState(self, self.config.spell)

	elseif (event == "ACTIONBAR_SHOWGRID") then

		if (not InCombatLockdown()) then
			self:SetAttribute("showstates", self.config.showstate)
			if (self.config.showstate == tonumber(self:GetAttribute("state-parent"))) then
				self:Show()
			end
		end

	elseif (event == "ACTIONBAR_HIDEGRID") then

		if (not InCombatLockdown()) then
			if (not Trinity2.configMode) then
				if (not playerEnteredWorld) then
					if (not self.config["mouseover anchor"] and not self.config["click anchor"]) then
						if (not self.config.spell or self.config.spell == "" and not self.dockFrame.config.showgrid and not self.config.stored) then
							self:SetAttribute("showstates", "NOACTION")
							self:Hide()
						end
					end
				else
					if (not self.config["mouseover anchor"] and not self.config["click anchor"]) then
						if ((not self.config.spell or self.config.spell == "") and not MouseIsOver(self) and not self.dockFrame.config.showgrid and not self.config.stored) then
							self:SetAttribute("showstates", "NOACTION")
							self:Hide()
						end
					end
				end
			end
		end

	elseif (event == "UNIT_INVENTORY_CHANGED") then

		if (... == "player") then
			updateSpellCount(self, self.config.spell)
			updateSpellIcon(self, self.config.spell)
		end

	elseif (event == "UPDATE_SHAPESHIFT_FORM" or event == "BAG_UPDATE") then

		updateSpellCount(self, self.config.spell)
		updateSpellIcon(self, self.config.spell)

	elseif (event == "UNIT_AURA") then

		if (... == "player" or ... == "target") then
			updateSpellCount(self, self.config.spell)
			updateBuffup_OnEvent(self, ..., self.config.spell)
		end

	elseif (event == "UNIT_MANA" or event == "UNIT_RAGE" or event == "UNIT_ENERGY") then

		if (... == "player") then
			updateSpellCount(self, self.config.spell)
		end

	elseif (event == "PLAYER_TARGET_CHANGED") then

		updateBuffup_OnEvent(self, "target", self.config.spell)

	elseif (event == "PLAYER_ENTERING_WORLD") then

		local spell = self.config.spell

		updateSpell_OnEvent(self, spell)
		updateBuffup_OnEvent(self, "player", self.config.spell)
		updateSpellCooldown_OnEvent(self, true, spell)

	elseif ( event == "PLAYER_ENTER_COMBAT" or event == "PLAYER_LEAVE_COMBAT") then

		local spell = self.config.spell
		if (spell and spell ~= "") then
			if (IsAttackSpell(spell)) then
				updateSpellState(self, spell)
			end
		end

	elseif ( event == "START_AUTOREPEAT_SPELL" ) then

		local spell = self.config.spell
		if (spell and spell ~= "") then
			if (IsAutoRepeatSpell(spell)) then
				updateSpellState(self, spell)
			end
		end

	elseif ( event == "STOP_AUTOREPEAT_SPELL" ) then

		local spell = self.config.spell
		if (spell and spell ~= "") then
			if (self.flashing and not IsAttackSpell(spell)) then
				updateSpellState(self, spell)
			end
		end
	end
end

--[[ "macro" button functions ]]--

local function setupMacroData(self)

	local macro = self.config.macro

	if (macro) then

		local spell, target, item, command

		self.updateCooldown = false

		--setup macro to parse correctly
		macro = "\n"..macro.."\n"; macro = gsub(macro, "(%c+)", " %1")

		for cmd, options in gmatch(macro, "(%c%p%a+)(%C+)") do

			--after gmatch, remove unneeded characters
			if (cmd) then cmd = gsub(cmd, "^%c+", "") end
			if (options) then options = gsub(options, "^%s+", "") end

			--find the spell!
			if (not spell) then

				spell, target = SecureCmdOptionParse(options)
				command = cmd

			--sometimes SecureCmdOptionParse will return "" since that is not what we want, keep looking
			elseif (#spell < 1) then

				spell, target = SecureCmdOptionParse(options)
				command = cmd
			end

   		end

     		if (spell and command == "/castsequence") then

     			_, item, spell = QueryCastSequence(spell)

     		elseif (spell) then

     		     	if (#spell < 1) then

     				spell = nil

     			elseif(GetItemInfo(spell)) then

     				item = spell; spell = nil

     			elseif(tonumber(spell) and GetInventoryItemLink("player", spell)) then

     				item = GetInventoryItemLink("player", spell); spell = nil
     			end
     		end

     		self.target = target or "target"

		if (spell) then

			self.macroitem = nil

			if (spell ~= self.macrospell) then

				self.macrospell = spell
				self.updateCooldown = true
			end
		else
			self.macrospell = nil
		end

		if (item) then

			self.macrospell = nil

			if (item ~= self.macroitem) then

				self.macroitem = item
				self.updateCooldown = true
			end
		else
			self.macroitem = nil
		end
	end
end

local function macroButton_SetTooltip(self)

	self.UpdateTooltip = nil

	if (self.config.macrousenote) then

		GameTooltip:SetText(self.config.macronote)

	else

		local spell, item, link = self.macrospell, self.macroitem, nil

		spell = lower(spell or "")

		if (spell and spell ~= "") then

			if (spellIndex[spell]) then

				GameTooltip:SetSpell(spellIndex[spell][1], "spell")

			end

			self.UpdateTooltip = macroButton_SetTooltip

		elseif (item and item ~= "") then

			--Item tooltip code by Anadale from WoWInterface

			_, link = GetItemInfo(item)

			if (link) then
				GameTooltip:SetHyperlink(link)
			end
		else

			if (self.config.macroname == TRINITYBARS2_STRINGS.MACRO_NAME) then
				self.config.macroname = ""
			end

			GameTooltip:SetText(self.config.macroname)
		end
	end
end

local function updateMacroIcon(self)

	local spell, item = self.macrospell, self.macroitem

	if (self.config.macroname == TRINITYBARS2_STRINGS.MACRO_NAME) then
		self.config.macroname = ""
	end

	self.name:SetText(self.config.macroname)

	self.count:SetText("")

	if (spell and spell ~= "") then

		if ( IsConsumableSpell(spell) ) then

			self.count:SetText(GetSpellCount(spell))
		end

		if (self.config.macroicon == 1) then

			texture = GetSpellTexture(spell)

			if (not texture) then
				GetNumMacroIcons()
				texture = GetMacroIconInfo(1)
			end

			if (texture) then
				self.iconframeicon:SetTexture(texture)
				self.iconframeicon:Show()
			else
				self.iconframeicon:SetTexture("")
				self.iconframeicon:Hide()
				self.count:SetText("")
			end
		else

			GetNumMacroIcons()
			texture = GetMacroIconInfo(self.config.macroicon)

			if (texture) then
				self.iconframeicon:SetTexture(texture)
				self.iconframeicon:Show()
			else
				self.iconframeicon:SetTexture("")
				self.iconframeicon:Hide()
				self.count:SetText("")
			end
		end

	elseif (item and item ~= "") then

		if ( IsConsumableItem(item) ) then

			self.count:SetText(GetItemCount(item))
		end

		if (self.config.macroicon == 1) then

			_, _, _, _, _, _, _, _, _, texture = GetItemInfo(item)

			if (not texture) then
				GetNumMacroIcons()
				texture = GetMacroIconInfo(1)
			end

			if (texture) then
				self.iconframeicon:SetTexture(texture)
				self.iconframeicon:Show()
			else
				self.iconframeicon:SetTexture("")
				self.iconframeicon:Hide()
				self.count:SetText("")
			end
		else

			GetNumMacroIcons()
			texture = GetMacroIconInfo(self.config.macroicon)

			if (texture) then
				self.iconframeicon:SetTexture(texture)
				self.iconframeicon:Show()
			else
				self.iconframeicon:SetTexture("")
				self.iconframeicon:Hide()
				self.count:SetText("")
			end
		end


	else
		GetNumMacroIcons()

		texture = GetMacroIconInfo(self.config.macroicon)

		if (texture) then
			self.iconframeicon:SetTexture(texture)
			self.iconframeicon:Show()
		else
			texture = GetMacroIconInfo(1)

			self.iconframeicon:SetTexture(texture)
			self.iconframeicon:Show()
		end
	end

	return texture
end

local function updateMacroCooldown_OnEvent(self, update)

	self.cdduration = 0

	local spell, item = self.macrospell, self.macroitem

	if (spell and spell ~= "") then

		local start, duration, enable = GetSpellCooldown(spell)

		if (enable) then

			if (self.cdcolornorm and duration > 4) then
				self.cooldowntext:SetTextColor(self.cdcolornorm[1], self.cdcolornorm[2], self.cdcolornorm[3])
				self.cooldowntexthuge:SetTextColor(self.cdcolorlarge[1], self.cdcolorlarge[2], self.cdcolorlarge[3])
			end

			if (enable > 0) then
				CooldownFrame_SetTimer(self.iconframecooldown, start, duration, enable)
				self.cooldown = true;
				self.cdduration = duration
			else
				CooldownFrame_SetTimer(self.iconframecooldown, 0, 0, 0)
				self.cooldowntext:SetText("")
				self.cooldowntexthuge:SetText("")
			end
		end

	elseif (item and item ~= "") then

		local start, duration, enable = GetItemCooldown(item)

		if (enable) then

			if (self.cdcolornorm and duration > 4) then
				self.cooldowntext:SetTextColor(self.cdcolornorm[1], self.cdcolornorm[2], self.cdcolornorm[3])
				self.cooldowntexthuge:SetTextColor(self.cdcolorlarge[1], self.cdcolorlarge[2], self.cdcolorlarge[3])
			end

			if (enable > 0) then
				CooldownFrame_SetTimer(self.iconframecooldown, start, duration, enable)
				self.cooldown = true;
				self.cdduration = duration
			else
				CooldownFrame_SetTimer(self.iconframecooldown, 0, 0, 0)
				self.cooldowntext:SetText("")
				self.cooldowntexthuge:SetText("")
			end
		end

	elseif (update) then

		CooldownFrame_SetTimer(self.iconframecooldown, 0, 0, 0)
		self.cooldowntext:SetText("")
		self.cooldowntexthuge:SetText("")
	end
end

local function updateMacroCooldown_OnUpdate(self)

	local spell, item = self.macrospell, self.macroitem
	local start, duration, enable = 0, 0, 0

	if (spell and spell ~= "") then

		spell = lower(spell)

		self.spelldata = spellIndex[spell]

		start, duration, enable = GetSpellCooldown(spell)

		if (start == 0) then
			self.cooldown = nil
		end

		if (self.alpha and duration) then
			if (self.cooldown and duration > 4) then
				if (self:GetAlpha() ~= cooldownAlpha) then
					self:SetAlpha(cooldownAlpha)
				end
			else
				if (self:GetAlpha() ~= 1) then
					self:SetAlpha(1)
				end
			end
		end

		if (checkButtons[105]) then
			updateCooldownText(self, start or 0, duration or 0, enable or 0)
		end

	elseif (item and item ~= "") then

		start, duration, enable = GetItemCooldown(item)

		if (start == 0) then
			self.cooldown = nil
		end

		if (self.alpha and duration) then
			if (self.cooldown and duration > 4) then
				if (self:GetAlpha() ~= cooldownAlpha) then
					self:SetAlpha(cooldownAlpha)
				end
			else
				if (self:GetAlpha() ~= 1) then
					self:SetAlpha(1)
				end
			end
		end

		if (checkButtons[105]) then
			updateCooldownText(self, start or 0, duration or 0, enable or 0)
		end
	end
end

local function updateMacroButton(self)

	if (self.editmode) then
		self.iconframeicon:SetVertexColor(0.2, 0.2, 0.2)
	else

		local spell, item = self.macrospell, self.macroitem

		if (spell and spell ~= "") then

			local isUsable, notEnoughMana = IsUsableSpell(spell)

			if (notEnoughMana) then

				self.iconframeicon:SetVertexColor(self.manacolor[1], self.manacolor[2], self.manacolor[3])

			elseif (isUsable) then

				if (IsSpellInRange(spell, self.target) == 0) then
					self.iconframeicon:SetVertexColor(self.rangecolor[1], self.rangecolor[2], self.rangecolor[3])
				else
					self.iconframeicon:SetVertexColor(1.0, 1.0, 1.0)
				end
			else
				self.iconframeicon:SetVertexColor(0.3, 0.3, 0.3)
			end

		elseif (item and item ~= "") then

                       	local isUsable, notEnoughMana = IsUsableItem(item)

			if (notEnoughMana) then
				self.iconframeicon:SetVertexColor(self.manacolor[1], self.manacolor[2], self.manacolor[3])
			elseif (isUsable) then
				if (IsItemInRange(spell, self.target) == 0) then
					self.iconframeicon:SetVertexColor(self.rangecolor[1], self.rangecolor[2], self.rangecolor[3])
				else
					self.iconframeicon:SetVertexColor(1.0, 1.0, 1.0)
				end
			else
				self.iconframeicon:SetVertexColor(0.3, 0.3, 0.3)
			end
		else
			self.iconframeicon:SetVertexColor(1.0, 1.0, 1.0)
		end

		updateMacroIcon(self)

		if (self.updateCooldown) then
			updateMacroCooldown_OnEvent(self, true)
		end
	end

end

local function updateMacroState(self)

	local spell, item = self.macrospell, self.macroitem

	if (spell and spell ~= "") then

		if (IsCurrentSpell(spell) or IsAutoRepeatSpell(spell)) then
			self:SetChecked(1)
		else
			self:SetChecked(nil)
		end

		if ((IsAttackSpell(spell) and IsCurrentSpell(spell)) or IsAutoRepeatSpell(spell)) then
			self.flash = true
		else
			self.flash = false
		end

	elseif (item and item ~= "") then

		if(IsCurrentItem(spell)) then
			self:SetChecked(1)
		else
			self:SetChecked(nil)
		end
	else
		self:SetChecked(nil)
	end
end

local function updateMacro_OnEvent(self)

	updateButtonColors(self, true)
	updateMacroIcon(self)
	updateMacroState(self)
end

local function macroButton_OnUpdate(self, elapsed)

	self.elapsed = self.elapsed + elapsed

	if (self.flash) then

		self.flashing = true

		if (alphaDir == 1) then
			if ((1-(alphaTimer)) >= 0) then
				self.checkedtexture:SetVertexColor(1, 1, 1, 1)
			end
		elseif (alphaDir == 0) then
			if ((alphaTimer) <= 1) then
				self.checkedtexture:SetVertexColor(0.8, 0, 0, 1)
			end
		end

	elseif (self.flashing) then

		self.checkedtexture:SetVertexColor(1, 1, 1, 1)
		self.flashing = false
	end

	if (self.elapsed > 0.2) then
		updateMacroButton(self)
		if (self.cooldown) then
			updateMacroCooldown_OnUpdate(self)
		end
		self.elapsed = 0;
	end
end

local function macro_OnEvent(self, event, ...)

	setupMacroData(self)

	if (event == "ACTIONBAR_UPDATE_COOLDOWN") then

		updateMacroCooldown_OnEvent(self, true)

	elseif ( event == "ACTIONBAR_UPDATE_STATE" or event == "CRAFT_SHOW" or event == "CRAFT_CLOSE" or event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_CLOSE" ) then

		updateMacroState(self)

	elseif (event == "ACTIONBAR_SHOWGRID") then

		if (not InCombatLockdown()) then
			self:SetAttribute("showstates", self.config.showstate)
			if (self.config.showstate == tonumber(self:GetAttribute("state-parent"))) then
				self:Show()
			end
		end

	elseif (event == "ACTIONBAR_HIDEGRID") then

		if (not InCombatLockdown()) then
			if (not Trinity2.configMode) then
				if (not playerEnteredWorld) then
					if (not self.config["mouseover anchor"] and not self.config["click anchor"]) then
						if (not self.config.macro or self.config.macro == "" and not self.dockFrame.config.showgrid) then
							self:SetAttribute("showstates", "NOACTION")
							self:Hide()
						end
					end
				else
					if (not self.config["mouseover anchor"] and not self.config["click anchor"]) then
						if ((not self.config.macro or self.config.macro == "") and not MouseIsOver(self) and not self.dockFrame.config.showgrid) then
							self:SetAttribute("showstates", "NOACTION")
							self:Hide()
						end
					end
				end
			end
		end

	elseif (event == "UNIT_SPELLCAST_SUCCEEDED") then

		updateMacro_OnEvent(self)
		updateMacroCooldown_OnEvent(self, true)

	elseif (event == "UNIT_SPELLCAST_INTERRUPTED" or
	        event == "UNIT_SPELLCAST_FAILED" or
	        event == "UNIT_SPELLCAST_FAILED_QUIET" or
	        event == "UNIT_SPELLCAST_STOP") then

		if (... == "player" or ... == "pet") then
			updateMacro_OnEvent(self)
			updateMacroCooldown_OnEvent(self, true)
		end

	elseif (event == "PLAYER_TARGET_CHANGED" or
		event == "PLAYER_FOCUS_CHANGED" or
		event == "PLAYER_REGEN_ENABLED" or
		event == "PLAYER_REGEN_DISABLED" or
		event == "MODIFIER_STATE_CHANGED") then

		updateMacro_OnEvent(self)
		updateMacroCooldown_OnEvent(self, true)

	elseif (event == "PLAYER_ENTERING_WORLD") then

		updateMacro_OnEvent(self)
		updateMacroCooldown_OnEvent(self)

	elseif ( event == "PLAYER_ENTER_COMBAT" or event == "PLAYER_LEAVE_COMBAT") then

		local spell = self.macrospell

		if (spell and spell ~= "") then
			if (IsAttackSpell(spell)) then
				updateMacroState(self)
			end
		end

	elseif ( event == "START_AUTOREPEAT_SPELL" ) then

		local spell = self.macrospell

		if (spell and spell ~= "") then
			if (IsAutoRepeatSpell(spell)) then
				updateMacroState(self)
			end
		end

	elseif ( event == "STOP_AUTOREPEAT_SPELL" ) then

		local spell = self.macrospell

		if (spell and spell ~= "") then
			if (self.flashing and not IsAttackSpell(spell)) then
				updateMacroState(self)
			end
		end
	end

	self.elapsed = 0.2
end

--[[ "item" button functions ]]--

local function itemButton_SetTooltip(self)

	local link = self.config.itemlink

	self.UpdateTooltip = nil

	if (link and link ~= "") then
		GameTooltip:SetHyperlink(link)
		--self.UpdateTooltip = itemButton_SetTooltip
	end
end

local function updateItemButton(self, link)

	if (self.editmode) then
		self.iconframeicon:SetVertexColor(0.2, 0.2, 0.2)
	else

		if (link and link ~= "") then

			local isUsable, notEnoughMana = IsUsableItem(link)

			if (isUsable) then
				if (IsItemInRange(link, self.target) == 0) then
					self.iconframeicon:SetVertexColor(self.rangecolor[1], self.rangecolor[2], self.rangecolor[3])
				else
					self.iconframeicon:SetVertexColor(1.0, 1.0, 1.0)
				end
			elseif (notEnoughMana) then
				self.iconframeicon:SetVertexColor(self.manacolor[1], self.manacolor[2], self.manacolor[3])
			else
				self.iconframeicon:SetVertexColor(0.3, 0.3, 0.3)
			end
		else
			self.iconframeicon:SetVertexColor(1.0, 1.0, 1.0)
		end
	end
end

local function updateItemIcon(self, link)

	if (link and link ~= "") then

		local item, _, _, _, _, _, _, _, _, texture = GetItemInfo(link)

		self.count:SetText("")

		if ( IsConsumableItem(item) ) then
			self.count:SetText(GetItemCount(item))
		end

		if ( IsEquippedItem(item) ) then
			self.border:SetVertexColor(0, 1.0, 0, 0.5)
			self.border:Show()
		else
			self.border:Hide()
		end

		self.iconframeicon:SetTexture(texture)
		self.iconframeicon:Show()
	else
		self.iconframeicon:Hide()
		self.border:Hide()
		self.count:SetText("")
	end
end

local function updateItemState(self, link)

	if (link and link ~= "") then

		if (IsCurrentItem(link)) then
			self:SetChecked(1)
		else
			self:SetChecked(nil)
		end
	end

	self.flash = false
end

local function updateItem_OnEvent(self, link)

	if (link and link ~= "") then

		updateButtonColors(self, true)
	else
		updateButtonColors(self, false)
	end

	updateItemIcon(self, link)
	updateItemState(self, link)
end

local function updateItemCooldown_OnEvent(self, update, link)

	self.cdduration = 0

	if (link and link ~= "") then

		local start, duration, enable = GetItemCooldown(link)

		if (enable) then

			if (self.cdcolornorm and duration > 4) then
				self.cooldowntext:SetTextColor(self.cdcolornorm[1], self.cdcolornorm[2], self.cdcolornorm[3])
				self.cooldowntexthuge:SetTextColor(self.cdcolorlarge[1], self.cdcolorlarge[2], self.cdcolorlarge[3])
			end

			if (enable > 0) then
				CooldownFrame_SetTimer(self.iconframecooldown, start, duration, enable)
				self.cooldown = true;
				self.cdduration = duration
			else
				CooldownFrame_SetTimer(self.iconframecooldown, 0, 0, 0)
				self.cooldowntext:SetText("")
				self.cooldowntexthuge:SetText("")
			end
		end
	elseif (update) then
		CooldownFrame_SetTimer(self.iconframecooldown, 0, 0, 0)
		self.cooldowntext:SetText("")
		self.cooldowntexthuge:SetText("")
	end
end

local function updateItemCooldown_OnUpdate(self, link)

	local start, duration, enable = GetItemCooldown(link)

	if (start == 0) then
		self.cooldown = nil
	end

	if (self.alpha and duration) then
		if (self.cooldown and duration > 4) then
			if (self:GetAlpha() ~= cooldownAlpha) then
				self:SetAlpha(cooldownAlpha)
			end
		else
			if (self:GetAlpha() ~= 1) then
				self:SetAlpha(1)
			end
		end
	end

	if (checkButtons[105]) then
		updateCooldownText(self, start or 0, duration or 0, enable or 0)
	end
end

local function itemButton_OnUpdate(self, elapsed)

	self.elapsed = self.elapsed + elapsed

	if (self.flash) then

		self.flashing = true

		if (alphaDir == 1) then
			if ((1-(alphaTimer)) >= 0) then
				self.checkedtexture:SetVertexColor(1, 1, 1, 1)
			end
		elseif (alphaDir == 0) then
			if ((alphaTimer) <= 1) then
				self.checkedtexture:SetVertexColor(0.8, 0, 0, 1)
			end
		end

	elseif (self.flashing) then

		self.checkedtexture:SetVertexColor(1, 1, 1, 1)
		self.flashing = false
	end

	if (self.elapsed > 0.2) then
		updateItemButton(self, self.config.itemlink)
		if (self.cooldown) then
			updateItemCooldown_OnUpdate(self, self.config.itemlink)
		end
		self.elapsed = 0;
	end
end

local function item_OnEvent(self, event, ...)

	if (event == "ACTIONBAR_UPDATE_COOLDOWN") then

		updateItemCooldown_OnEvent(self, true, self.config.itemlink)

	elseif ( event == "ACTIONBAR_UPDATE_STATE" or event == "CRAFT_SHOW" or event == "CRAFT_CLOSE" or event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_CLOSE" ) then

		updateItemState(self, self.config.itemlink)

	elseif (event == "ACTIONBAR_SHOWGRID") then

		if (not InCombatLockdown()) then
			self:SetAttribute("showstates", self.config.showstate)
			if (self.config.showstate == tonumber(self:GetAttribute("state-parent"))) then
				self:Show()
			end
		end

	elseif (event == "ACTIONBAR_HIDEGRID") then

		if (not InCombatLockdown()) then
			if (not Trinity2.configMode) then
				if (not playerEnteredWorld) then
					if (not self.config["mouseover anchor"] and not self.config["click anchor"]) then
						if (not self.config.item or self.config.item == "" and not self.dockFrame.config.showgrid and not self.config.stored) then
							self:SetAttribute("showstates", "NOACTION")
							self:Hide()
						end
					end
				else
					if (not self.config["mouseover anchor"] and not self.config["click anchor"]) then
						if ((not self.config.item or self.config.item == "") and not MouseIsOver(self) and not self.dockFrame.config.showgrid and not self.config.stored) then
							self:SetAttribute("showstates", "NOACTION")
							self:Hide()
						end
					end
				end
			end
		end

		updateItem_OnEvent(self, self.config.itemlink)
		updateItemCooldown_OnEvent(self, false, self.config.itemlink)

	elseif (event == "UNIT_INVENTORY_CHANGED") then

		if (... == "player") then
			updateItemIcon(self, self.config.itemlink)
		end

	elseif (event == "UPDATE_SHAPESHIFT_FORM" or event == "BAG_UPDATE") then

		updateItemIcon(self, self.config.itemlink)

	elseif (event == "PLAYER_ENTERING_WORLD" or event == "ITEM_LOCK_CHANGED" or event == "UPDATE_INVENTORY_ALERTS") then

		updateItem_OnEvent(self, self.config.itemlink)
		updateItemCooldown_OnEvent(self, false, self.config.itemlink)
	end
end

--[[ "slot" button functions ]]--

local function slotButton_SetTooltip(self)

	local slot = self.config.slot

	self.UpdateTooltip = nil

	if (slot) then
		GameTooltip:SetInventoryItem("player", slot)
		self.UpdateTooltip = slotButton_SetTooltip
	end
end

local function updateSlotButton(self, link)

	if (self.editmode) then
		self.iconframeicon:SetVertexColor(0.2, 0.2, 0.2)
	else

		if (link and link ~= "") then

			local isUsable, notEnoughMana = IsUsableItem(link)

			if (isUsable) then
				if (IsItemInRange(link, self.target) == 0) then
					self.iconframeicon:SetVertexColor(self.rangecolor[1], self.rangecolor[2], self.rangecolor[3])
				else
					self.iconframeicon:SetVertexColor(1.0, 1.0, 1.0)
				end
			elseif (notEnoughMana) then
				self.iconframeicon:SetVertexColor(self.manacolor[1], self.manacolor[2], self.manacolor[3])
			else
				self.iconframeicon:SetVertexColor(0.3, 0.3, 0.3)
			end
		else
			self.iconframeicon:SetVertexColor(1.0, 1.0, 1.0)
		end
	end
end

local function updateSlotIcon(self, link)

	if (link and link ~= "") then

		self.count:SetText("")

		local item, _, _, _, _, _, _, _, _, texture = GetItemInfo(link)

		if ( IsConsumableItem(item) ) then
			self.count:SetText(GetItemCount(item))
		end

		self.iconframeicon:SetTexture(texture)
		self.iconframeicon:Show()
	else
		self.iconframeicon:Hide()
		self.count:SetText("")
	end
end

local function updateSlotState(self, item)

	if (item and item ~= "") then

		if (IsCurrentItem(item)) then
			self:SetChecked(1)
		else
			self:SetChecked(nil)
		end
	end

	self.flash = false
end

local function updateSlot_OnEvent(self, item, link)

	local link = GetInventoryItemLink("player", self.config.slot) or ""

	self.config.item = GetItemInfo(link)
	self.config.itemlink = link

	if (self.config.item and self.config.item ~= "") then

		updateButtonColors(self, true)
	else
		updateButtonColors(self, false)
	end

	updateSlotIcon(self, link)
	updateSlotState(self, item)
end

local function updateSlotCooldown_OnEvent(self, update, item)

	self.cdduration = 0

	if (item and item ~= "") then

		local start, duration, enable = GetItemCooldown(item)

		if (enable) then

			if (self.cdcolornorm and duration > 4) then
				self.cooldowntext:SetTextColor(self.cdcolornorm[1], self.cdcolornorm[2], self.cdcolornorm[3])
				self.cooldowntexthuge:SetTextColor(self.cdcolorlarge[1], self.cdcolorlarge[2], self.cdcolorlarge[3])
			end

			if (enable > 0) then
				CooldownFrame_SetTimer(self.iconframecooldown, start, duration, enable)
				self.cooldown = true;
				self.cdduration = duration
			else
				CooldownFrame_SetTimer(self.iconframecooldown, 0, 0, 0)
				self.cooldowntext:SetText("")
				self.cooldowntexthuge:SetText("")
			end
		end
	elseif (update) then
		CooldownFrame_SetTimer(self.iconframecooldown, 0, 0, 0)
		self.cooldowntext:SetText("")
		self.cooldowntexthuge:SetText("")
	end
end

local function updateSlotCooldown_OnUpdate(self, item)

	local start, duration, enable = GetItemCooldown(item)

	if (start == 0) then
		self.cooldown = nil
	end

	if (self.alpha and duration) then
		if (self.cooldown and duration > 4) then
			if (self:GetAlpha() ~= cooldownAlpha) then
				self:SetAlpha(cooldownAlpha)
			end
		else
			if (self:GetAlpha() ~= 1) then
				self:SetAlpha(1)
			end
		end
	end

	if (checkButtons[105]) then
		updateCooldownText(self, start or 0, duration or 0, enable or 0)
	end
end

local function slotButton_OnUpdate(self, elapsed)

	self.elapsed = self.elapsed + elapsed

	if (self.flash) then

		self.flashing = true

		if (alphaDir == 1) then
			if ((1-(alphaTimer)) >= 0) then
				self.checkedtexture:SetVertexColor(1, 1, 1, 1)
			end
		elseif (alphaDir == 0) then
			if ((alphaTimer) <= 1) then
				self.checkedtexture:SetVertexColor(0.8, 0, 0, 1)
			end
		end

	elseif (self.flashing) then

		self.checkedtexture:SetVertexColor(1, 1, 1, 1)
		self.flashing = false
	end

	if (self.elapsed > 0.2) then
		updateSlotButton(self, self.config.item)
		if (self.cooldown) then
			updateSlotCooldown_OnUpdate(self, self.config.item)
		end
		self.elapsed = 0;
	end
end

local function slot_OnEvent(self, event, ...)

	if (event == "ACTIONBAR_UPDATE_COOLDOWN") then

		updateSlotCooldown_OnEvent(self, true, self.config.item)

	elseif ( event == "ACTIONBAR_UPDATE_STATE" or event == "CRAFT_SHOW" or event == "CRAFT_CLOSE" or event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_CLOSE" ) then

		updateSlotState(self, self.config.item)

	elseif (event == "ACTIONBAR_SHOWGRID") then

		if (not InCombatLockdown()) then
			self:SetAttribute("showstates", self.config.showstate)
			if (self.config.showstate == tonumber(self:GetAttribute("state-parent"))) then
				self:Show()
			end
		end

		updateSlot_OnEvent(self, self.config.item, self.config.itemlink)
		updateSlotCooldown_OnEvent(self, true, self.config.item)

	elseif (event == "ACTIONBAR_HIDEGRID") then

		if (not InCombatLockdown()) then
			self:SetAttribute("showstates", self.config.showstate)
			if (self.config.showstate == tonumber(self:GetAttribute("state-parent"))) then
				self:Show()
			end
		end

		updateSlot_OnEvent(self, self.config.item, self.config.itemlink)
		updateSlotCooldown_OnEvent(self, true, self.config.item)

	elseif (event == "UNIT_INVENTORY_CHANGED" ) then

		if (... == "player") then
			updateSlot_OnEvent(self, self.config.item, self.config.itemlink)
			updateSlotCooldown_OnEvent(self, true, self.config.item)
		end

	elseif (event == "UPDATE_SHAPESHIFT_FORM" or event == "BAG_UPDATE") then

		updateSlotIcon(self, self.config.itemlink)

	elseif (event == "PLAYER_ENTERING_WORLD" or event == "ITEM_LOCK_CHANGED" or event == "UPDATE_INVENTORY_ALERTS") then

		updateSlot_OnEvent(self, self.config.item, self.config.itemlink)
		updateSlotCooldown_OnEvent(self, true, self.config.item)
	end

end

--[[ "class" button functions ]]--

local function classButton_UpdateState(self)

	local _, _, isActive = GetShapeshiftFormInfo(self.id)

	if (self.altclass) then

		self:SetChecked(0)

		if (unitBuffs["player"][self.config.spell]) then

			self:SetChecked(1)

			if (self.altclass == 1) then
				self.iconframeicon:SetTexture("Interface\\Icons\\Spell_Nature_WispSplode")
			end

			if (self.altclass == 2) then
				self.iconframeicon:SetTexture("Interface\\Icons\\Spell_Shadow_ChillTouch")
			end
		end
	else

		if (isActive) then
			self:SetChecked(1)
		else
			self:SetChecked(0)
		end
	end
end

local function updateClassButton(self, spell)

	local _, _, _, isCastable  = GetShapeshiftFormInfo(self.id)

	if (self.altclass) then

		if (spell) then
			if ( IsUsableSpell(spell)) then
				self.iconframeicon:SetVertexColor(1.0, 1.0, 1.0)
			else
				self.iconframeicon:SetVertexColor(0.3, 0.3, 0.3)
			end
		end
	else

		if ( isCastable) then
			self.iconframeicon:SetVertexColor(1.0, 1.0, 1.0)
		else
			self.iconframeicon:SetVertexColor(0.3, 0.3, 0.3)
		end
	end
end

local function updateClassButton_OnEvent(button)

	local texture, name, isActive, isCastable, hasAction, noAction, skincolor

	if (button.altclass) then
		if (button.spellIndex) then
			texture = GetSpellTexture(button.spellIndex, BOOKTYPE_SPELL)
		end
	else
		texture, name, isActive, isCastable = GetShapeshiftFormInfo(button.id)
	end

	if ( texture ) then

		button.iconframeicon:SetTexture(texture)
		button.iconframeicon:Show()

		updateButtonColors(button, true)
	else

		button.iconframeicon:SetTexture("")
		button.iconframeicon:Hide()

		updateButtonColors(button, false)
	end
end

local function updateClassButtonCooldown_OnUpdate(self)

	local start, duration, enable = GetShapeshiftFormCooldown(self.id)

	if (start == 0) then
		self.cooldown = nil
	end

	if (self:GetParent().alpha) then
		if (self.cooldown and duration > 4) then
			self:SetAlpha(cooldownAlpha)
		else
			self:SetAlpha(1)
		end
	end

	if (checkButtons[105]) then
		updateCooldownText(self, start or 0, duration or 0, enable or 0)
	end
end

local function updateClassButtonCooldown_OnEvent(self)

	if (self.altclass) then
		if (self.spellIndex) then
			local start, duration, enable = GetSpellCooldown(self.spellIndex, BOOKTYPE_SPELL)
			CooldownFrame_SetTimer(self.iconframecooldown, start, duration, enable)
			self.cooldown = true;
		end
	else
		local start, duration, enable = GetShapeshiftFormCooldown(self.id)
		CooldownFrame_SetTimer(self.iconframecooldown, start, duration, enable)
		self.cooldown = true;
	end


end

--[[ "pet" button functions ]]--

local function updatePetButton(self)

	if (self.autocastenabled and self.autocasttype== "AutoCastSim") then

		if (alphaDir == 1) then
			if ((autocastAlpha-(alphaTimer)) >= 0) then
				self.autocastsim:SetAlpha(autocastAlpha-(alphaTimer))
			end
		else
			if ((alphaTimer) <= autocastAlpha) then
				self.autocastsim:SetAlpha((alphaTimer))
			end
		end
	end

end

local function updatePetButton_OnEvent(button)

	local name, _, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(button.id)
	local petActionsUsable = GetPetActionsUsable()

	updateButtonColors(button, true)

	if (texture) then
		button.iconframeicon:SetTexture(texture)
		button.iconframeicon:Show()

		updateButtonColors(button, true)
	else
		button.iconframeicon:SetTexture("")
		button.iconframeicon:Hide()

		updateButtonColors(button, false)
	end

	if (isToken) then
		button.iconframeicon:SetTexture(_G[texture])
		button.isToken = true
		button.tooltipName = _G[name]
	else
		button.iconframeicon:SetTexture(texture)
		button.isToken = false
		button.tooltipName = name;
	end

	button.autocast:SetAlpha(autocastAlpha)

	if ( autoCastAllowed ) then
		button.autocastable:Show()
	else
		button.autocastable:Hide()
	end

	if ( autoCastEnabled ) then
		if (button.autocasttype== "AutoCast") then
			button.autocast:Show()
			button.autocastsim:Hide()
			button.autocastable:Hide()
		else
			button.autocastsim:Show()
			button.autocast:Hide()
			button.autocastable:Hide()
		end
		button.autocastenabled = true
	else
		button.autocast:Hide()
		button.autocastsim:Hide()
		if ( autoCastAllowed ) then
			button.autocastable:Show()
		end
		button.autocastenabled = false
	end

	if ( texture ) then
		if ( petActionsUsable ) then
			SetDesaturation(button.icon, nil)
		else
			SetDesaturation(button.icon, 1)
		end
		button.iconframeicon:Show()
	else
		button.iconframeicon:Hide()
	end

	if ( isActive ) then
		button:SetChecked(1)
	else
		button:SetChecked(0)
	end

end

local function updatePetButtonCooldown_OnUpdate(self)

	local start, duration, enable = GetPetActionCooldown(self.id)

	if (start == 0) then
		self.cooldown = nil
	end

	if (self:GetParent().alpha) then
		if (self.cooldown and duration > 4) then
			self:SetAlpha(cooldownAlpha)
		else
			self:SetAlpha(1)
		end
	end

	if (checkButtons[105]) then
		updateCooldownText(self, start or 0, duration or 0, enable or 0)
	end
end

local function updatePetButtonCooldown_OnEvent(self)

	local start, duration, enable = GetPetActionCooldown(self.id)
	CooldownFrame_SetTimer(this.iconframecooldown, start, duration, enable)
	self.cooldown = true;
end

--[[ local button script handlers ]]--

local function button_OnEnter(self)

	if (checkButtons[108] and InCombatLockdown()) then
		return
	end

	if (checkButtons[101]) then

		if ( GetCVar("UberTooltips") == "1" ) then
			self.UberTooltips = true
			GameTooltip_SetDefaultAnchor(GameTooltip, self)
		else
			self.UberTooltips = false
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		end

		if (self.config.type == "action") then
			actionButton_SetTooltip(self)
		elseif (self.config.type == "spell") then
			spellButton_SetTooltip(self)
		elseif (self.config.type == "macro") then
			macroButton_SetTooltip(self)
		elseif (self.config.type == "item") then
			itemButton_SetTooltip(self)
		elseif (self.config.type == "slot") then
			slotButton_SetTooltip(self)
		end

		GameTooltip:Show()
	end
end

local function button_OnLeave(self)

	self.UpdateTooltip = nil
	GameTooltip:Hide()
end

local function button_OnShow(self)

	self:RegisterEvent("ACTIONBAR_UPDATE_USUABLE")
	self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
	self:RegisterEvent("ACTIONBAR_UPDATE_STATE")

	self:RegisterEvent("START_AUTOREPEAT_SPELL");
	self:RegisterEvent("STOP_AUTOREPEAT_SPELL");

	self:RegisterEvent("CRAFT_SHOW")
	self:RegisterEvent("CRAFT_CLOSE")

	self:RegisterEvent("TRADE_SKILL_SHOW")
	self:RegisterEvent("TRADE_SKILL_CLOSE")

	self:RegisterEvent("UPDATE_SHAPESHIFT_FORM")

	self:RegisterEvent("MODIFIER_STATE_CHANGED")

	self:RegisterEvent("UNIT_SPELLCAST_STOP")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED_QUIET")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("UNIT_MANA")
	self:RegisterEvent("UNIT_RAGE")
	self:RegisterEvent("UNIT_ENERGY")

	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("PLAYER_FOCUS_CHANGED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_ENTER_COMBAT")
	self:RegisterEvent("PLAYER_LEAVE_COMBAT")

	self:RegisterEvent("ITEM_LOCK_CHANGED")
	self:RegisterEvent("UPDATE_INVENTORY_ALERTS")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")
	self:RegisterEvent("BAG_UPDATE")

	if (self.config) then

		if (self.config.type == "action") then

			local action = self.config.action

			updateAction_OnEvent(self, action)
			updateActionCooldown_OnEvent(self, true, 1, action)

		elseif (self.config.type == "spell") then

			local spell = self.config.spell

			updateSpell_OnEvent(self, spell)
			updateSpellCooldown_OnEvent(self, true, spell)

		elseif (self.config.type == "macro") then

			local onEvent = self:GetScript("OnEvent")
			onEvent(self, "PLAYER_ENTERING_WORLD")

		elseif (self.config.type == "item") then

			local item = self.config.itemlink

			updateItem_OnEvent(self, item)
			updateItemCooldown_OnEvent(self, true, item)

		elseif (self.config.type == "slot") then

			local item, link = self.config.item, self.config.itemlink

			updateSlot_OnEvent(self, item, link)
			updateSlotCooldown_OnEvent(self, true, item)

		end

		updateBuffup_OnEvent(self, "player", self.config.spell)
		updateBuffup_OnEvent(self, "target", self.config.spell)
	end
end

local function button_OnHide(self)


	self:UnregisterEvent("ACTIONBAR_UPDATE_USUABLE")
	self:UnregisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
	self:UnregisterEvent("ACTIONBAR_UPDATE_STATE")

	self:UnregisterEvent("START_AUTOREPEAT_SPELL");
	self:UnregisterEvent("STOP_AUTOREPEAT_SPELL");

	self:UnregisterEvent("CRAFT_SHOW")
	self:UnregisterEvent("CRAFT_CLOSE")

	self:UnregisterEvent("TRADE_SKILL_SHOW")
	self:UnregisterEvent("TRADE_SKILL_CLOSE")

	self:UnregisterEvent("UNIT_INVENTORY_CHANGED")

	self:UnregisterEvent("UPDATE_SHAPESHIFT_FORM")

	self:UnregisterEvent("MODIFIER_STATE_CHANGED")

	self:UnregisterEvent("UNIT_SPELLCAST_STOP")
	self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	self:UnregisterEvent("UNIT_SPELLCAST_FAILED")
	self:UnregisterEvent("UNIT_SPELLCAST_FAILED_QUIET")
	self:UnregisterEvent("UNIT_AURA")
	self:UnregisterEvent("UNIT_MANA")
	self:UnregisterEvent("UNIT_RAGE")
	self:UnregisterEvent("UNIT_ENERGY")

	self:UnregisterEvent("PLAYER_TARGET_CHANGED")
	self:UnregisterEvent("PLAYER_FOCUS_CHANGED")
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	self:UnregisterEvent("PLAYER_ENTER_COMBAT")
	self:UnregisterEvent("PLAYER_LEAVE_COMBAT")

	self:UnregisterEvent("ITEM_LOCK_CHANGED")
	self:UnregisterEvent("UPDATE_INVENTORY_ALERTS")
	self:UnregisterEvent("UNIT_INVENTORY_CHANGED")
	self:UnregisterEvent("BAG_UPDATE")
end

--[[ Loading Functions ]]--

local function loadStageOne()

	fadeSpeed = TrinityBars2SavedState.fadeSpeed
	autocastAlpha = TrinityBars2SavedState.autocastAlpha
	cooldownAlpha = TrinityBars2SavedState.cooldownAlpha
	checkButtons = copyTable(TrinityBars2SavedState.options.CheckButtons)

	TrinityBars2SavedState.playerClass = UnitClass("player")

	updateDockPostions(TrinityBars2SavedState.firstRun)

	TrinityBars2.ClampDocks()
	TrinityBars2.SetSelfCast(TrinityBars2SavedState.selfCastOption)
	TrinityBars2.HideKeyBindings(true)
	TrinityBars2.ToggleMacroText(true)
	TrinityBars2.ToggleCountText(true)
	TrinityBars2.ToggleBlizzardMainBar(true)
	TrinityBars2.ButtonLockToggle(true)
	--TrinityBars2.ButtonModifierDragToggle()

	updateFormNames()

	for k,dockFrame in pairs(dockIndex) do

		TrinityBars2.SetBattleBar(dockFrame)
		TrinityBars2.SetRetreatBar(dockFrame)
		TrinityBars2.SetPartyBar(dockFrame)
		TrinityBars2.SetRaidBar(dockFrame)
		TrinityBars2.SetPvPBar(dockFrame)
		TrinityBars2.SetPvEBar(dockFrame)
		TrinityBars2.SetAltBar(dockFrame)
		TrinityBars2.SetCtrlBar(dockFrame)
		TrinityBars2.SetShiftBar(dockFrame)
		TrinityBars2.SetHelpHarmBar(dockFrame)
		TrinityBars2.SetStealthBar(dockFrame)
		TrinityBars2.SetProwlBar(dockFrame)
		TrinityBars2.SetPossessionBar(dockFrame)
		TrinityBars2.SetAutohide(dockFrame)
		TrinityBars2.SetAlphaup(dockFrame)
		TrinityBars2.SetButtonMouseoverAnchor(dockFrame)
		TrinityBars2.SetButtonClickAnchor(dockFrame)

		--dockFrame.normalheader:SetAttribute("state", header:GetAttribute("state-state"))

		if (UnitClass("player") ~= TRINITYBARS2_STRINGS.DRUID) then
			dockFrame.checkSet[TRINITYBARS2_STRINGS.CHECK_OPT_16] = false
		end

		if (dockFrame.config["autohide"]) then
			dockFrame.vis = 1;
		end
	end

	for k,v in pairs(dedBars.docks) do
		updateDocking(v)
		if (k == "bag") then
			setMainMenuBarBackpackButton(v.buttonCount)
		end
	end

	if (TrinityBars2SavedState.buttonLock) then
		LOCK_ACTIONBAR = "1"
	else
		LOCK_ACTIONBAR = "0"
	end

	updateSpellIndex()
end

local function loadStageTwo()

	if (not playerEnteredWorld) then

		if (checkButtons[102]) then
			updateClassBar()
		end

		for k,dockFrame in pairs(dockIndex) do
			updateDocking(dockFrame)
			TrinityBars2.SwapTextures(dockFrame, dockIndex)
			TrinityBars2.UpdateTargeting(dockFrame)
			refreshHeaders(dockFrame)
		end

		updateStorageDocking()

		TrinityBars2.UpdateBindings()

		if (TrinityBars2SavedState.convertBindings) then

			local found = false

			for i=1,12 do
				found = GetBindingKey("ACTIONBUTTON"..i)
			end

			if (found) then
				TrinityBars2.CopyKeyBindings()
			end

			TrinityBars2SavedState.convertBindings = false
		end

		playerEnteredWorld = true;
	end

	TrinityBars2SavedState.buttonGridShow = false;
	TrinityBars2.ConfigModeOnToggle()

	updateBuffInfo("player")
	updateBuffInfo("target")

	collectgarbage()
end

local function onShowgrid()

	if (not InCombatLockdown()) then
		for k,dockFrame in pairs(dockIndex) do
			if (Trinity2.configMode) then
				dockFrame:Hide()
			end
		end

		if (TrinityBars2KeyBinder:IsVisible() or TrinityBars2SimpleKeyBinder:IsVisible()) then

			for k,v in pairs(buttonIndex) do
				if (k ~= 0) then
					v.bindframe:Hide()
					v.bindframe:SetFrameStrata("LOW")
				end
			end

			for k,v in pairs(petButtonIndex) do
				v.bindframe:Hide()
				v.bindframe:SetFrameStrata("LOW")
			end

			for k,v in pairs(classButtonIndex) do
				v.bindframe:Hide()
				v.bindframe:SetFrameStrata("LOW")
			end
		end

		if (TrinityBars2ButtonEditor:IsVisible() or TrinityBars2SimpleButtonEditor:IsVisible()) then

			for k,v in pairs(buttonIndex) do
				if (k ~= 0) then
					v.editframe:Hide()
					v.editframe:SetFrameStrata("LOW")

					if (v.config.type == "action") then
						updateActionButton(v, v.config.action)
					elseif (v.config.type == "spell") then
						updateSpellButton(v, v.config.spell)
					elseif (v.config.type == "macro") then
						updateMacroButton(v)
					elseif (v.config.type == "item") then
						updateItemButton(v, v.config.itemlink)
					elseif (v.config.type == "slot") then
						updateSlotButton(v, v.config.item)
					end
				end
			end

		end

		TrinityBars2.ConfigModeOnToggle()
	end
end

local function onHidegrid()


	if (not InCombatLockdown()) then
		for k,dockFrame in pairs(dockIndex) do
			if (Trinity2.configMode) then
				if (TrinitySoloEditMode) then
					if (dockFrame.selected and not dockFrame.config.stored) then
						dockFrame:Show()
					end
				else
					if (not dockFrame.config.stored) then
						dockFrame:Show()
					end
				end
			end
		end

		if (TrinityBars2KeyBinder:IsVisible() or TrinityBars2SimpleKeyBinder:IsVisible()) then

			for k,v in pairs(buttonIndex) do
				if (k ~= 0) then
					v.bindframe:Show()
					v.bindframe:SetFrameStrata(v.dockFrame:GetFrameStrata())
					v.bindframe:SetFrameLevel(v.dockFrame:GetFrameLevel()+4)
				end
			end

			for k,v in pairs(petButtonIndex) do
				v.bindframe:Show()
				v.bindframe:SetFrameStrata(v.dockFrame:GetFrameStrata())
				v.bindframe:SetFrameLevel(v.dockFrame:GetFrameLevel()+4)
			end

			for k,v in pairs(classButtonIndex) do
				v.bindframe:Show()
				v.bindframe:SetFrameStrata(v.dockFrame:GetFrameStrata())
				v.bindframe:SetFrameLevel(v.dockFrame:GetFrameLevel()+4)
			end
		end

		if (TrinityBars2ButtonEditor:IsVisible() or TrinityBars2SimpleButtonEditor:IsVisible()) then

			for k,v in pairs(buttonIndex) do
				if (k ~= 0) then
					v.editframe:Show()
					v.editframe:SetFrameStrata(v.dockFrame:GetFrameStrata())
					v.editframe:SetFrameLevel(v.dockFrame:GetFrameLevel()+4)

					if (v.config.type == "action") then
						updateActionButton(v, v.config.action)
					elseif (v.config.type == "spell") then
						updateSpellButton(v, v.config.spell)
					elseif (v.config.type == "macro") then
						updateMacroButton(v)
					elseif (v.config.type == "item") then
						updateItemButton(v, v.config.itemlink)
					elseif (v.config.type == "slot") then
						updateSlotButton(v, v.config.item)
					end
				end
			end

		end

		TrinityBars2.ConfigModeOnToggle()
	end
end

--[[ Global Variables ]]--

TrinityBars2.AdjustableActions = {
	[TRINITYBARS2_STRINGS.DOCK_OPT_1] = {
		function(dockFrame, action)
			updateDockingPrep(dockFrame)
			if (dockFrame and action) then
				dockFrame.elapsed = 0
				TrinityBars2.UpdateArcStart(dockFrame, action)
				updateDocking(dockFrame)
			end
			if (dockFrame) then
				return dockFrame.config.arcstart
			end
		end,
		["editmode"] = 1,
	},

	[TRINITYBARS2_STRINGS.DOCK_OPT_2] = {
		function(dockFrame, action)
			updateDockingPrep(dockFrame)
			if (dockFrame and action) then
				dockFrame.elapsed = 0
				TrinityBars2.UpdateArcLength(dockFrame, action)
				updateDocking(dockFrame)
			end
			if (dockFrame) then
				return dockFrame.config.arclength
			end
		end,
		["editmode"] = 1,
	},

	[TRINITYBARS2_STRINGS.DOCK_OPT_3] = {
		function(dockFrame, arc)
			updateDockingPrep(dockFrame)
			if (dockFrame and arc) then
				dockFrame.elapsed = 0
				TrinityBars2.SetArcPreset(dockFrame, arc)
				updateDocking(dockFrame)
			end
			if (dockFrame) then
				local data = {
					[TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1_1] = TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1_1,
					[TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1_2] = TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1_2,
					[TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1_3] = TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1_3,
					[TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1_4] = TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1_4,
					[TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1_5] = TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1_5,
				}
				return TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1, data
			end
		end,
		["editmode"] = 2,
	},


	[TRINITYBARS2_STRINGS.DOCK_OPT_4] = {
		function(dockFrame, action)
			updateDockingPrep(dockFrame)
			if (dockFrame and action) then
				dockFrame.elapsed = 0
				TrinityBars2.CreateDock(true)
			end
			if (dockFrame) then
				return TRINITYBARS2_STRINGS.DOCK_FEEDBACK_2
			end
		end,
		["editmode"] = 1,
	},


	[TRINITYBARS2_STRINGS.DOCK_OPT_5] = {
		function(dockFrame, action)
			updateDockingPrep(dockFrame)
			if (dockFrame and action) then
				dockFrame.elapsed = 0
				TrinityBars2.ResetDock(dockFrame)
				updateDocking(dockFrame)
			end
			if (dockFrame) then
				return TRINITYBARS2_STRINGS.DOCK_FEEDBACK_3
			end
		end,
		["editmode"] = 1,
	},

	[TRINITYBARS2_STRINGS.DOCK_OPT_6] = {
		function(dockFrame, name)
			updateDockingPrep(dockFrame)
			if (dockFrame and name) then
				dockFrame.elapsed = 0
				TrinityBars2.UpdateBarName(dockFrame, name)
				updateDocking(dockFrame)
			end
			if (dockFrame) then
				return dockFrame.config.name
			end
		end,
		["editmode"] = 2,
	},

	[TRINITYBARS2_STRINGS.DOCK_OPT_7] = {
		function(dockFrame, action)
			updateDockingPrep(dockFrame)
			if (dockFrame and action) then
				dockFrame.elapsed = 0
				TrinityBars2.UpdateScale(dockFrame, action)
				updateDocking(dockFrame)
			end
			if (dockFrame) then
				return dockFrame.config.scale
			end
		end,
		["editmode"] = 1,
	},

	[TRINITYBARS2_STRINGS.DOCK_OPT_8] = {
		function(dockFrame, shape)
			updateDockingPrep(dockFrame)
			if (dockFrame and shape) then
				dockFrame.elapsed = 0
				TrinityBars2.ChangeShape(dockFrame, shape)
				updateDocking(dockFrame)
			end
			if (dockFrame) then

				local data = {}

				for k,v in pairs(barShapes) do
					data[v] = k
				end

				return barShapes[dockFrame.config.shape], data
			end
		end,
		["editmode"] = 2,
	},

	[TRINITYBARS2_STRINGS.DOCK_OPT_9] = {
		function(dockFrame, strata)
			updateDockingPrep(dockFrame)
			if (dockFrame and strata) then
				dockFrame.elapsed = 0
				TrinityBars2.ChangeStrata(dockFrame, strata)
				updateDocking(dockFrame)
			end
			if (dockFrame) then

				local data = {}

				for k,v in pairs(frameStratas) do
					if (v ~= "TOOLTIP") then
						data[v] = k
					end
				end

				return dockFrame.config.buttonStrata, data
			end
		end,
		["editmode"] = 2,
	},

	[TRINITYBARS2_STRINGS.DOCK_OPT_10] = {
		function(dockFrame, target)
			updateDockingPrep(dockFrame)
			if (dockFrame and target) then
				dockFrame.elapsed = 0
				TrinityBars2.ChangeTarget(dockFrame, target)
				updateDocking(dockFrame)
			end
			if (dockFrame) then

				local data = {}

				for k,v in pairs(targetNames) do
					data[v] = k
				end

				return dockFrame.config.target, data
			end
		end,
		["editmode"] = 2,
	},

	[TRINITYBARS2_STRINGS.DOCK_OPT_11] = {
		function(dockFrame, action)
			updateDockingPrep(dockFrame)
			if (dockFrame and action) then
				dockFrame.elapsed = 0
				TrinityBars2.UpdateColumns(dockFrame, action)
				updateDocking(dockFrame)
			end
			if (dockFrame) then
				return dockFrame.config.columns
			end
		end,
		["editmode"] = 1,
	},

	[TRINITYBARS2_STRINGS.DOCK_OPT_12] = {
		function(dockFrame, action)
			updateDockingPrep(dockFrame)
			if (dockFrame and action) then
				dockFrame.elapsed = 0
				TrinityBars2.ButtonCount(dockFrame, action)
				updateDocking(dockFrame)
			end
			if (dockFrame) then
				return dockFrame.buttonCount
			end
		end,
		["editmode"] = 1,
	},

	[TRINITYBARS2_STRINGS.DOCK_OPT_13] = {
		function(dockFrame, skin)
			updateDockingPrep(dockFrame)
			if (dockFrame and skin) then
				dockFrame.elapsed = 0
				TrinityBars2.ChooseButtonSkin(dockFrame, skin)
				updateDocking(dockFrame)
			end
			if (dockFrame) then
				return dockFrame.config.skin, TrinityBars2.buttonSkins
			end
		end,
		["editmode"] = 2,
	},

	[TRINITYBARS2_STRINGS.DOCK_OPT_14] = {
		function(dockFrame, action)
			updateDockingPrep(dockFrame)
			if (dockFrame and action) then
				dockFrame.elapsed = 0
				TrinityBars2.AdjustHSpacing(dockFrame, action)
				TrinityBars2.AdjustVSpacing(dockFrame, action)
				updateDocking(dockFrame)
			end
			if (dockFrame) then
				return dockFrame.config.buttonSpaceH.." / "..dockFrame.config.buttonSpaceV
			end
		end,
		["editmode"] = 1,
	},

	[TRINITYBARS2_STRINGS.DOCK_OPT_15] = {
		function(dockFrame, action)
			updateDockingPrep(dockFrame)
			if (dockFrame and action) then
				dockFrame.elapsed = 0
				TrinityBars2.AdjustHSpacing(dockFrame, action)
				updateDocking(dockFrame)
			end
			if (dockFrame) then
				return dockFrame.config.buttonSpaceH
			end
		end,
		["editmode"] = 1,
	},

	[TRINITYBARS2_STRINGS.DOCK_OPT_16] = {
		function(dockFrame, action)
			updateDockingPrep(dockFrame)
			if (dockFrame and action) then
				dockFrame.elapsed = 0
				TrinityBars2.AdjustVSpacing(dockFrame, action)
				updateDocking(dockFrame)
			end
			if (dockFrame) then
				return dockFrame.config.buttonSpaceV
			end
		end,
		["editmode"] = 1,
	},

	[TRINITYBARS2_STRINGS.DOCK_OPT_17] = {
		function(dockFrame, action)
			updateDockingPrep(dockFrame)
			if (dockFrame and action) then
				dockFrame.elapsed = 0
				TrinityBars2.ChangeTaperStyle(dockFrame, action)
				updateDocking(dockFrame)
			end
			if (dockFrame) then
				return dockFrame.config.taper[1]
			end
		end,
		["editmode"] = 1,
	},

	[TRINITYBARS2_STRINGS.DOCK_OPT_18] = {
		function(dockFrame, action)
			updateDockingPrep(dockFrame)
			if (dockFrame and action) then
				dockFrame.elapsed = 0
				TrinityBars2.ChangeTaperScale(dockFrame, action)
				updateDocking(dockFrame)
			end
			if (dockFrame) then
				return dockFrame.config.taper[2]
			end
		end,
		["editmode"] = 1,
	},

	[TRINITYBARS2_STRINGS.DOCK_OPT_19] = {
		function(dockFrame, action)
			updateDockingPrep(dockFrame)
			if (dockFrame and action) then
				dockFrame.elapsed = 0
				TrinityBars2.UpdateAlpha(dockFrame, action)
				updateDocking(dockFrame)
			end
			if (dockFrame) then
				return dockFrame.config.alpha
			end
		end,
		["editmode"] = 1,
	},

	[TRINITYBARS2_STRINGS.DOCK_OPT_20] = {
		function(dockFrame, action)
			updateDockingPrep(dockFrame)
			if (dockFrame and action) then
				dockFrame.elapsed = 0
				TrinityBars2.UpdateAlphaUp(dockFrame, action)
				updateDocking(dockFrame)
			end
			if (dockFrame) then

				local data = {}

				for k,v in pairs(alphaUp) do
					data[v] = k
				end

				return dockFrame.config.alphaup, data
			end
		end,
		["editmode"] = 2,
	},
}

TrinityBars2.CheckboxActions = {

	["TrinityBars2_1"] = {
		"paged",
		function(self, dockFrame)
			if (dockFrame) then
				TrinityBars2.TogglePagedBar(self, dockFrame)
			end
		end,
		TRINITYBARS2_STRINGS.CHECK_OPT_1,
		TRINITYBARS2_STRINGS.TOOLTIP_PAGED,
		["checkgroup"] = 1,
	},

	["TrinityBars2_2"] = {
		"stance",
		function(self, dockFrame)
			if (dockFrame) then
				TrinityBars2.ToggleStanceBar(self, dockFrame)
			end
		end,
		TRINITYBARS2_STRINGS.CHECK_OPT_2,
		TRINITYBARS2_STRINGS.TOOLTIP_STANCE,
		["checkgroup"] = 2,
	},

	["TrinityBars2_3"] = {
		"stealth",
		function(self, dockFrame)
			if (dockFrame) then
				TrinityBars2.ToggleStealthBar(self, dockFrame)
			end
		end,
		TRINITYBARS2_STRINGS.CHECK_OPT_3,
		TRINITYBARS2_STRINGS.TOOLTIP_STEALTH,
		["checkgroup"] = 3,
	},

	["TrinityBars2_4"] = {
		"alt",
		function(self, dockFrame)
			if (dockFrame) then
				TrinityBars2.ToggleAltBar(self, dockFrame)
			end
		end,
		TRINITYBARS2_STRINGS.CHECK_OPT_4,
		TRINITYBARS2_STRINGS.TOOLTIP_ALT,
		["checkgroup"] = 4,
	},

	["TrinityBars2_5"] = {
		"control",
		function(self, dockFrame)
			if (dockFrame) then
				TrinityBars2.ToggleCtrlBar(self, dockFrame)
			end
		end,
		TRINITYBARS2_STRINGS.CHECK_OPT_5,
		TRINITYBARS2_STRINGS.TOOLTIP_CTRL,
		["checkgroup"] = 5,
	},

	["TrinityBars2_6"] = {
		"shift",
		function(self, dockFrame)
			if (dockFrame) then
				TrinityBars2.ToggleShiftBar(self, dockFrame)
			end
		end,
		TRINITYBARS2_STRINGS.CHECK_OPT_6,
		TRINITYBARS2_STRINGS.TOOLTIP_SHIFT,
		["checkgroup"] = 6,
	},

	["TrinityBars2_7"] = {
		"battle",
		function(self, dockFrame)
			if (dockFrame) then
				TrinityBars2.ToggleBattleBar(self, dockFrame)
			end
		end,
		TRINITYBARS2_STRINGS.CHECK_OPT_7,
		TRINITYBARS2_STRINGS.TOOLTIP_COMBAT,
		["checkgroup"] = 7,
	},

	["TrinityBars2_8"] = {
		"pvp",
		function(self, dockFrame)
			if (dockFrame) then
				TrinityBars2.TogglePvPBar(self, dockFrame)
			end
		end,
		TRINITYBARS2_STRINGS.CHECK_OPT_8,
		TRINITYBARS2_STRINGS.TOOLTIP_PVP,
		["checkgroup"] = 7,
	},

	["TrinityBars2_9"] = {
		"party",
		function(self, dockFrame)
			if (dockFrame) then
				TrinityBars2.TogglePartyBar(self, dockFrame)
			end
		end,
		TRINITYBARS2_STRINGS.CHECK_OPT_9,
		TRINITYBARS2_STRINGS.TOOLTIP_PARTY,
		["checkgroup"] = 7,
	},

	["TrinityBars2_10"] = {
		"retreat",
		function(self, dockFrame)
			if (dockFrame) then
				TrinityBars2.ToggleRetreatBar(self, dockFrame)
			end
		end,
		TRINITYBARS2_STRINGS.CHECK_OPT_10,
		TRINITYBARS2_STRINGS.TOOLTIP_RETREAT,
		["checkgroup"] = 7,
	},

	["TrinityBars2_11"] = {
		"pve",
		function(self, dockFrame)
			if (dockFrame) then
				TrinityBars2.TogglePvEBar(self, dockFrame)
			end
		end,
		TRINITYBARS2_STRINGS.CHECK_OPT_11,
		TRINITYBARS2_STRINGS.TOOLTIP_PVE,
		["checkgroup"] = 7,
	},

	["TrinityBars2_12"] = {
		"raid",
		function(self, dockFrame)
			if (dockFrame) then
				TrinityBars2.ToggleRaidBar(self, dockFrame)
			end
		end,
		TRINITYBARS2_STRINGS.CHECK_OPT_12,
		TRINITYBARS2_STRINGS.TOOLTIP_RAID,
		["checkgroup"] = 7,
	},

	["TrinityBars2_13"] = {
		"autohide",
		function(self, dockFrame)
			if (dockFrame) then
				TrinityBars2.ToggleAutoHide(self, dockFrame)
			end
		end,
		TRINITYBARS2_STRINGS.CHECK_OPT_13,
		TRINITYBARS2_STRINGS.TOOLTIP_AUTOHIDE,
		["checkgroup"] = 8,
	},

	["TrinityBars2_14"] = {
		"showgrid",
		function(self, dockFrame)
			if (dockFrame) then
				TrinityBars2.ToggleShowGrid(self, dockFrame)
			end
		end,
		TRINITYBARS2_STRINGS.CHECK_OPT_14,
		TRINITYBARS2_STRINGS.TOOLTIP_SHOWGRID,
		["checkgroup"] = 9,
	},

	["TrinityBars2_15"] = {
		"snapto",
		function(self, dockFrame)
			if (dockFrame) then
				TrinityBars2.ToggleSnapToBar(self, dockFrame)
			end
		end,
		TRINITYBARS2_STRINGS.CHECK_OPT_15,
		TRINITYBARS2_STRINGS.TOOLTIP_SNAPTO,
		["checkgroup"] = 10,
	},

	["TrinityBars2_16"] = {
		"prowl",
		function(self, dockFrame)
			if (dockFrame) then
				TrinityBars2.ToggleProwlBar(self, dockFrame)
			end
		end,
		TRINITYBARS2_STRINGS.CHECK_OPT_16,
		TRINITYBARS2_STRINGS.TOOLTIP_PROWL,
		["checkgroup"] = 11,
	},

	["TrinityBars2_17"] = {
		"reaction",
		function(self, dockFrame)
			if (dockFrame) then
				TrinityBars2.ToggleHelpHarmBar(self, dockFrame)
			end
		end,
		TRINITYBARS2_STRINGS.CHECK_OPT_17,
		TRINITYBARS2_STRINGS.TOOLTIP_REACTION,
		["checkgroup"] = 12,
	},

	["TrinityBars2_18"] = {
		"possession",
		function(self, dockFrame)
			if (dockFrame) then
				TrinityBars2.TogglePossessionBar(self, dockFrame)
			end
		end,
		TRINITYBARS2_STRINGS.CHECK_OPT_18,
		TRINITYBARS2_STRINGS.TOOLTIP_POSSESSION,
		["checkgroup"] = 13,
	},
}

TrinityBars2.ColorPickerActions = {
	[TRINITYBARS2_STRINGS.COLOR_OPT_1] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityBars2.UpdateBuffColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.buffcolor
			end
		end },
	[TRINITYBARS2_STRINGS.COLOR_OPT_2] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityBars2.UpdateDebuffColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.debuffcolor
			end
		end },
	[TRINITYBARS2_STRINGS.COLOR_OPT_3] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityBars2.UpdateRangeColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.rangecolor
			end
		end },
	[TRINITYBARS2_STRINGS.COLOR_OPT_4] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityBars2.UpdateManaColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.manacolor
			end
		end },
	[TRINITYBARS2_STRINGS.COLOR_OPT_5] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityBars2.UpdateButtonSkinColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.skincolor
			end
		end },
	[TRINITYBARS2_STRINGS.COLOR_OPT_6] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityBars2.UpdateButtonHoverColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.hovercolor
			end
		end },
	[TRINITYBARS2_STRINGS.COLOR_OPT_7] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityBars2.UpdateButtonEquipColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.equipcolor
			end
		end },
	[TRINITYBARS2_STRINGS.COLOR_OPT_8] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityBars2.UpdateCDTextNormColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.cdcolornorm
			end
		end },
	[TRINITYBARS2_STRINGS.COLOR_OPT_9] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityBars2.UpdateCDTextLargeColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.cdcolorlarge
			end
		end },
	[TRINITYBARS2_STRINGS.COLOR_OPT_10] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityBars2.UpdateBDTextNormColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.bdcolornorm
			end
		end },
	[TRINITYBARS2_STRINGS.COLOR_OPT_11] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityBars2.UpdateBDTextLargeColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.bdcolorlarge
			end
		end },
}

TrinityBars2.ButtonOptions = {

	[TRINITYBARS2_STRINGS.BUTTON_OPT_1] = {
		function(button, action)
			if (button and action) then
				button.dockFrame.elapsed = 0
				TrinityBars2.ScaleButton(button, action)
				updateDocking(button.dockFrame)
			end
			if (button) then
				return button.config.scale
			end
		end,
		["editmode"] = 1,
	},


	[TRINITYBARS2_STRINGS.BUTTON_OPT_2] = {
		function(button, target)
			if (button and target) then
				button.dockFrame.elapsed = 0
				TrinityBars2.ChangeButtonTarget(button.dockFrame, button, target)
				updateDocking(button.dockFrame)
			end
			if (button) then
				local data = {}

				for k,v in pairs(targetNames) do
					data[v] = k
				end

				return button.config.target, data
			end
		end,
		["editmode"] = 2,
	},

	[TRINITYBARS2_STRINGS.BUTTON_OPT_3] = {
		function(button, action)
			if (button and action) then
				button.dockFrame.elapsed = 0
				TrinityBars2.AdjustXoffset(button, action)
				updateDocking(button.dockFrame)
			end
			if (button) then
				return button.config.XOffset
			end
		end,
		["editmode"] = 1,
	},

	[TRINITYBARS2_STRINGS.BUTTON_OPT_4] = {
		function(button, action)
			if (button and action) then
				button.dockFrame.elapsed = 0
				TrinityBars2.AdjustYoffset(button, action)
				updateDocking(button.dockFrame)
			end
			if (button) then
				return button.config.YOffset
			end
		end,
		["editmode"] = 1,
	},

	[TRINITYBARS2_STRINGS.BUTTON_OPT_5] = {
		function(button, action)
			if (button and action) then
				local dockFrame = button.dockFrame
				dockFrame.elapsed = 0
				TrinityBars2.SubtractButton(dockFrame, nil, button)
				updateDocking(dockFrame)
			end
			if (button) then
				return TRINITYBARS2_STRINGS.BUTTON_FEEDBACK_1
			end
		end,
		["editmode"] = 1,
	},

}

TrinityBars2.ButtonCheckOptions = {
	["TrinityBars2_1"] = {
		"Mouseover Anchor",
		function(self, button)
			if (button) then
				TrinityBars2.ToggleButtonMouseoverAnchor(self, button)
			end
		end,
		TRINITYBARS2_STRINGS.TOOLTIP_MOUSEOVER_ANCHOR,
	},
	["TrinityBars2_2"] = {
		"Click Anchor",
		function(self, button)
			if (button) then
				TrinityBars2.ToggleButtonClickAnchor(self, button)
			end
		end,
		TRINITYBARS2_STRINGS.TOOLTIP_CLICK_ANCHOR,
	},
	["TrinityBars2_3"] = {
		"Spell Counts",
		function(self, button)
			if (button) then
				TrinityBars2.ToggleButtonSpellCounts(self, button)
			end
		end,
		TRINITYBARS2_STRINGS.TOOLTIP_SPELL_COUNTS,
	},
}

-- Fadein/Fadeout code inspired by Bongos2 version of fadein/out bar.
local function loader_OnUpdate(self, elapsed)

	alphaTimer = alphaTimer + elapsed * 2

	if (alphaDir == 1) then
		if ((1-(alphaTimer)) <= 0) then
			alphaDir = 0
			alphaTimer = 0
		end
	else
		if ((alphaTimer) >= 1) then
			alphaDir = 1
			alphaTimer = 0
		end
	end

	for k,v in pairs(autohideIndex) do
		if (v~=nil) then
			if (MouseIsOver(k)) then
				if (v:GetAlpha() < k.config["alpha"]) then
					if (v:GetAlpha()+fadeSpeed <= 1) then
						v:SetAlpha(v:GetAlpha()+fadeSpeed)
					else
						v:SetAlpha(1)
					end
				else
					k.vis = 1;
				end
			end

			if (not MouseIsOver(k)) then
				if (v:GetAlpha() > 0) then
					if (v:GetAlpha()-fadeSpeed >= 0) then
						v:SetAlpha(v:GetAlpha()-fadeSpeed)
					else
						v:SetAlpha(0)
					end
				else
					k.vis = 0;
				end
			end
		end
	end

	for k,v in pairs(alphaupIndex) do
		if (v~=nil) then
			if (k.config["alphaup"] == TRINITYBARS2_STRINGS.ALPHAUP_BATTLE or k.config["alphaup"] == TRINITYBARS2_STRINGS.ALPHAUP_BATTLEMOUSE) then

				if (InCombatLockdown()) then

					if (v:GetAlpha() < 1) then
						if (v:GetAlpha()+fadeSpeed <= 1) then
							v:SetAlpha(v:GetAlpha()+fadeSpeed)
						else
							v:SetAlpha(1)
						end
					else
						k.vis = 1;
					end

				else
					if (k.config["alphaup"] == TRINITYBARS2_STRINGS.ALPHAUP_BATTLEMOUSE) then

						if (MouseIsOver(k)) then
							if (v:GetAlpha() < 1) then
								if (v:GetAlpha()+fadeSpeed <= 1) then
									v:SetAlpha(v:GetAlpha()+fadeSpeed)
								else
									v:SetAlpha(1)
								end
							else
								k.vis = 1;
							end
						else
							if (v:GetAlpha() > k.config["alpha"]) then
								if (v:GetAlpha()-fadeSpeed >= 0) then
									v:SetAlpha(v:GetAlpha()-fadeSpeed)
								else
									v:SetAlpha(k.config.alpha)
								end
							else
								k.vis = 0;
							end
						end
					else
						if (v:GetAlpha() > k.config["alpha"]) then
							if (v:GetAlpha()-fadeSpeed >= 0) then
								v:SetAlpha(v:GetAlpha()-fadeSpeed)
							else
								v:SetAlpha(k.config.alpha)
							end
						else
							k.vis = 0;
						end
					end
				end

			elseif (k.config["alphaup"] == TRINITYBARS2_STRINGS.ALPHAUP_RETREAT or k.config["alphaup"] == TRINITYBARS2_STRINGS.ALPHAUP_RETREATMOUSE) then

				if (not InCombatLockdown()) then

					if (v:GetAlpha() < 1) then
						if (v:GetAlpha()+fadeSpeed <= 1) then
							v:SetAlpha(v:GetAlpha()+fadeSpeed)
						else
							v:SetAlpha(1)
						end
					else
						k.vis = 1;
					end

				else
					if (k.config["alphaup"] == TRINITYBARS2_STRINGS.ALPHAUP_RETREATMOUSE) then

						if (MouseIsOver(k)) then
							if (v:GetAlpha() < 1) then
								if (v:GetAlpha()+fadeSpeed <= 1) then
									v:SetAlpha(v:GetAlpha()+fadeSpeed)
								else
									v:SetAlpha(1)
								end
							else
								k.vis = 1;
							end
						else
							if (v:GetAlpha() > k.config["alpha"]) then
								if (v:GetAlpha()-fadeSpeed >= 0) then
									v:SetAlpha(v:GetAlpha()-fadeSpeed)
								else
									v:SetAlpha(k.config.alpha)
								end
							else
								k.vis = 0;
							end
						end
					else
						if (v:GetAlpha() > k.config["alpha"]) then
							if (v:GetAlpha()-fadeSpeed >= 0) then
								v:SetAlpha(v:GetAlpha()-fadeSpeed)
							else
								v:SetAlpha(k.config.alpha)
							end
						else
							k.vis = 0;
						end
					end
				end

			elseif (k.config["alphaup"] == TRINITYBARS2_STRINGS.ALPHAUP_MOUSEOVER) then

				if (MouseIsOver(k)) then
					if (v:GetAlpha() < 1) then
						if (v:GetAlpha()+fadeSpeed <= 1) then
							v:SetAlpha(v:GetAlpha()+fadeSpeed)
						else
							v:SetAlpha(1)
						end
					else
						k.vis = 1;
					end
				else
					if (v:GetAlpha() > k.config["alpha"]) then
						if (v:GetAlpha()-fadeSpeed >= 0) then
							v:SetAlpha(v:GetAlpha()-fadeSpeed)
						else
							v:SetAlpha(k.config.alpha)
						end
					else
						k.vis = 0;
					end
				end
			end
		end
	end
end

function TrinityBars2.Loader_OnLoad(self)

	self.elapsed = 0
	self:RegisterEvent("VARIABLES_LOADED")
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_LEAVING_WORLD")
	self:RegisterEvent("PLAYER_LEAVE_COMBAT")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_AURAS_CHANGED")
	self:RegisterEvent("PLAYER_FLAGS_CHANGED")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("UNIT_FACTION")
	self:RegisterEvent("UNIT_PET")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
	self:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	self:RegisterEvent("UPDATE_STEALTH")
	self:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
	self:RegisterEvent("ACTIONBAR_SHOWGRID")
	self:RegisterEvent("ACTIONBAR_HIDEGRID")
	self:RegisterEvent("MODIFIER_STATE_CHANGED")
	self:RegisterEvent("SPELLS_CHANGED")
	self:RegisterEvent("LEARNED_SPELL_IN_TAB")
	self:RegisterEvent("CURSOR_UPDATE")
	self:RegisterEvent("DELETE_ITEM_CONFIRM")

	self:SetScript("OnUpdate", loader_OnUpdate)

	hooksecurefunc("updateContainerFrameAnchors", TrinityBars2.UpdateContainerFrameAnchors)
	hooksecurefunc("SpellButton_OnModifiedClick", TrinityBars2.SpellButton_OnModifiedClick)
	hooksecurefunc("HandleModifiedItemClick", TrinityBars2.ItemButton_OnModifiedClick)
	hooksecurefunc("OpenStackSplitFrame", TrinityBars2.OpenStackSplitFrame)

	--hooksecurefunc("CooldownFrame_SetTimer", updateCooldownText)
	--hooksecurefunc("QueryCastSequence", TrinityQueryCastSequence)

	MainMenuBar:Hide()
end

function TrinityBars2.Loader_OnEvent(self, event, ...)

	local dockFrame

	if (event == "VARIABLES_LOADED") then

		updateSpellIndex()

		createClassButtons()
		createPetButtons()
		createBagButtons()
		createMenuButtons()

		createAnchorHeader()
		createBattleHeader()
		createRetreatHeader()
		createPartyHeader()
		createRaidHeader()
		createPvPHeader()
		createPvEHeader()
		createPossessHeader()

		for k,v in pairs(TrinityBars2.AdjustableActions) do
			Trinity2.AdjustableActions[k] = v
		end

		for k,v in pairs(TrinityBars2.CheckboxActions) do
			Trinity2.CheckboxActions[k] = v
		end

		for k,v in pairs(TrinityBars2.ColorPickerActions) do
			Trinity2.ColorPickerActions[k] = v
		end

		Trinity2.SlashCommands["lock"] = { "toggle button lock", TrinityBars2.ButtonLockMinimapToggle }
		Trinity2.SlashCommands["buttons"] = { "toggle button type edit mode", TrinityBars2.ToggleButtonEditMode }
		Trinity2.SlashCommands["load"] = { "load the specified template", TrinityBars2.LoadTemplate }
		Trinity2.SlashCommands["loadspells"] = { "load the spells from the specified template", TrinityBars2.LoadButtons }

		if (TrinityBars2SavedState.firstRun) then
			initializeClassDefaults()
		else
			TrinityBars2.LoadSV()
		end

		TrinityBars2UpdateDocking = updateDocking
	end

	if (event == "PLAYER_LOGIN") then

		clearTable(TrinityBars2SavedState.debug)

		TrinityBars2.loadCyCircledSkins()

		local count = 1
		local array = {}

		for k,v in pairs(TrinityBars2.buttonSkins) do
			array[count] = k
			count = count + 1
		end

		table.sort(array)

		for k,v in pairs(array) do
			TrinityBars2.ButtonStyles[v] = k
		end

		loadStageOne()

	end

	if (event == "PLAYER_ENTERING_WORLD") then
		loadStageTwo()
	end

	if (event == "DELETE_ITEM_CONFIRM") then
		if (slotPickup) then
			StaticPopup_Hide("DELETE_GOOD_ITEM")
			StaticPopup_Hide("DELETE_ITEM")

			slotPickup = false

			ClearCursor()
			SetCursor(nil)
		end
	end


	if (event == "UNIT_PET") then
		if (... == "player") then
			if (dedBars.pet) then
				dockVisibility(dedBars.docks.pet)
			end
		end
	end

	if (event == "PLAYER_AURAS_CHANGED") then
		if (UnitClass("player") == TRINITYBARS2_STRINGS.PALADIN) then
			if (Trinity2.configMode) then
				for k,dockFrame in pairs(dockIndex) do
					if (dockFrame.headers.Stance.active) then
						useStates = false
						setupDockFrameUpdate(dockFrame)
					end
				end
			end
		end
	end

	if (event == "UPDATE_SHAPESHIFT_FORM") then
		if (Trinity2.configMode) then
			for k,dockFrame in pairs(dockIndex) do
				if (dockFrame.headers.Stance.active) then
					useStates = false
					setupDockFrameUpdate(dockFrame)
				end
			end
		end
	end

	if (event == "UPDATE_STEALTH") then
		if (Trinity2.configMode) then
			for k,v in pairs(dockIndex) do
				dockFrame = _G["TrinityDockFrame"..k]
				if (dockFrame.config["stealth"]) then
					useStates = false
					setupDockFrameUpdate(dockFrame)
				end
				if (dockFrame.headers.Stance.active and dockFrame.config["prowl"]) then
					useStates = false
					setupDockFrameUpdate(dockFrame)
				end
			end
		end
	end

	if (event == "ACTIONBAR_PAGE_CHANGED") then
		if (Trinity2.configMode) then
			for k,dockFrame in pairs(dockIndex) do
				if (dockFrame.headers.Actionbar.active) then
					useStates = false
					setupDockFrameUpdate(dockFrame)
				end
			end
		end
	end

	if (event == "MODIFIER_STATE_CHANGED") then
		if (Trinity2.configMode) then
			for k,dockFrame in pairs(dockIndex) do
				if (dockFrame.config["alt"] or dockFrame.config["control"] or dockFrame.config["shift"]) then
					useStates = false
					setupDockFrameUpdate(dockFrame)
				end
			end
		end
	end

	if (event == "PLAYER_TARGET_CHANGED") then
		if (Trinity2.configMode) then
			for k,dockFrame in pairs(dockIndex) do
				if (dockFrame.config["reaction"]) then
					useStates = false
					setupDockFrameUpdate(dockFrame)
				end
			end
		end

		updateBuffInfo("target")
	end

	if (event == "ACTIONBAR_SHOWGRID") then
		onShowgrid()
	end

	if (event == "ACTIONBAR_HIDEGRID") then
		onHidegrid()
	end

	if ( event == "UNIT_FACTION" ) then
		if ( ... == "player" ) then
			if (not combatLockdown) then
				if (UnitIsPVP("player")) then
					TrinityPvPHeader:SetAttribute("state", 0)
					TrinityPvEHeader:SetAttribute("state", 1)
				else
					TrinityPvPHeader:SetAttribute("state", 1)
					TrinityPvEHeader:SetAttribute("state", 0)
				end
			end
		end
	end

	if ( event == "UNIT_AURA" ) then
		if (... == "player" or ... == "target") then
			updateBuffInfo(...)
		end
	end

	if (event == "PLAYER_REGEN_DISABLED") then
		--the event "UNIT_FACTION" should catch all pvp flagging, this is just an extra check before going into combat
		if (UnitIsPVP("player")) then
			TrinityPvPHeader:SetAttribute("state", 0)
			TrinityPvEHeader:SetAttribute("state", 1)
		end

		combatLockdown = true;
	end

	if (event == "PLAYER_REGEN_ENABLED") then
		--the event "UNIT_FACTION" should catch all pvp flagging, this is just an extra check after coming out of combat
		if (not UnitIsPVP("player")) then
			TrinityPvPHeader:SetAttribute("state", 1)
			TrinityPvEHeader:SetAttribute("state", 0)
		end

		combatLockdown = false;
	end

	if (event == "UPDATE_SHAPESHIFT_FORMS") then
		if (checkButtons[102]) then
			updateClassBar()
		end
	end

	if (event == "LEARNED_SPELL_IN_TAB") then

		for k,v in pairs(buttonIndex) do

			if (v.config.type == "spell" and v.config.spell ~= "") then

				local spell = lower(v.config.spell)

				if (spellIndex[spell]) then
					print("1: pre- "..spell.." - spell exists")
				else
					print("1: pre- "..spell.." - spell did not exist")
				end

				if (spellIndex[spell] and (v.config.spellrank == 0 or v.config.spellrank == spellIndex[spell][2])) then

					v.maxrank = true

					print("2: true "..v.config.spellrank)
				else
					v.maxrank = false

					print("2: false "..v.config.spellrank)
				end
			end
		end

		updateSpellIndex()

		print(" ")

		if (not InCombatLockdown()) then

			for k,v in pairs(buttonIndex) do

				if (v.config.type == "spell" and v.config.spell ~= "") then

					local spell = lower(v.config.spell)

					if (spellIndex[spell]) then

						print("3: post- "..spell.." - spell exists")
					else
						print("3: post- "..spell.." - spell did not exist")
					end

					if (v.maxrank and spellIndex[spell]) then

						v.config.spellrank = spellIndex[spell][2] or 0
						v.config.spellranktext = "("..spellIndex[spell][3]..")" or "()"
						v.config.spellranktext = gsub(v.config.spellranktext, "^%p%l", upper)

						TrinityBars2.SetButtonType(v)

						local onEvent = v:GetScript("OnEvent")
						onEvent(v, "PLAYER_ENTERING_WORLD")

						print("4: rankup "..v.config.spellrank)
					else
						print("4: norankup "..v.config.spellrank)
					end
				end
			end
		end
	end

	if (event == "CURSOR_UPDATE") then

		if (macroDrag) then

			if (arg1 == "up") then

				for k,dockFrame in pairs(dockIndex) do
					buttonVisibility(dockFrame, false)
				end

				macroDrag = nil
				SetCursor(nil)
			else
				SetCursor(macroDrag[7])
			end
		end

		slotPickup = false
	end
end

function TrinityBars2.ConfigModeOnToggle()

	if (Trinity2.configMode or TrinityBars2SavedState.buttonGridShow) then

		TrinityBattleHeader:SetAttribute("state", "0")
		TrinityRetreatHeader:SetAttribute("state", "0")
		TrinityPartyHeader:SetAttribute("state", "0")
		TrinityRaidHeader:SetAttribute("state", "0")
		TrinityPvPHeader:SetAttribute("state", "0")
		TrinityPvEHeader:SetAttribute("state", "0")
		TrinityPossessHeader:SetAttribute("state", "0")

	else
		TrinityBattleHeader:SetAttribute("state", "1")
		TrinityRetreatHeader:SetAttribute("state", "0")

		if (GetNumPartyMembers() < 1) then
			TrinityPartyHeader:SetAttribute("state", "1")
		end

		if (GetNumRaidMembers() < 1) then
			TrinityRaidHeader:SetAttribute("state", "1")
		end

		if (UnitIsPVP("player")) then
			TrinityPvPHeader:SetAttribute("state", "0")
			TrinityPvEHeader:SetAttribute("state", "1")
		else
			TrinityPvPHeader:SetAttribute("state", "1")
			TrinityPvEHeader:SetAttribute("state", "0")
		end

		TrinityPossessHeader:SetAttribute("state", "99")
	end
end

local function PickupMacro(self, currmacro)

	for k,dockFrame in pairs(dockIndex) do
		buttonVisibility(dockFrame, true)
	end

	if (currmacro) then
		macroDrag = { currmacro[1], currmacro[2], currmacro[3], currmacro[4], currmacro[5], currmacro[6], currmacro[7] }
	else
		macroDrag = { self, self.config.macro, self.config.macroicon, self.config.macroname, self.config.macronote, self.config.macrousenote, updateMacroIcon(self) }

		if (self.dragbutton == "RightButton" and checkButtons[304]) then

		else
			self.config.macro = ""
			self.config.macroicon = 1
			self.config.macroname = ""
			self.config.macronote = ""
			self.config.macrousenote = false
		end

		TrinityBars2.SetButtonType(self)
		local onEvent = self:GetScript("OnEvent")
		onEvent(self, "PLAYER_ENTERING_WORLD")
	end

	SetCursor(macroDrag[7])
end

local function pickUpButton(self)

	if (self.config.type == "action") then

		if (self.config.action == 0) then
			if (self.id > 120) then
				self.config.action = 120
			else
				self.config.action = self.id
			end

			TrinityBars2.SetButtonType(self)
		end

		PickupAction(self.config.action)

		self.config.spell = ""
		self.config.spellrank = 0
		self.config.spellranktext = "()"

		updateAction_OnEvent(self, self.config.action)

	elseif (self.config.type == "spell") then

		if (self.config.spell and self.config.spell ~= "") then

			self.config.spellrank = tonumber(self.config.spellrank) or 0

			local spell = self.config.spell..self.config.spellranktext or ""

			PickupSpell(spell)

			if (self.dragbutton == "RightButton" and checkButtons[304]) then

			else
				self.config.spell = ""
				self.config.spellrank = 0
				self.config.spellranktext = "()"
			end

			TrinityBars2.SetButtonType(self)
		end

	elseif (self.config.type == "macro") then

		PickupMacro(self)

	elseif (self.config.type == "item") then

		if (self.config.itemlink and self.config.itemlink ~= "") then

			PickupItem(self.config.itemlink)

			if (self.dragbutton == "RightButton" and checkButtons[304]) then

			else

				self.config.item = ""
				self.config.itemlink = ""
			end

			TrinityBars2.SetButtonType(self)
		end

	elseif (self.config.type == "slot") then

		if (self.config.slot and self.config.slot ~= "") then

			PickupInventoryItem(self.config.slot)

			updateSlotState(self, self.config.item)
		end
	end
end

function TrinityBars2.ActionButton_OnDragStart(self, button)

	if (InCombatLockdown()) then
		return
	end

	self.cooldown = nil
	self.dragbutton = button

	if (not TrinityBars2SavedState.buttonLock) then
		pickUpButton(self)
	elseif (TrinityBars2SavedState.modifierButtonLock == 1 and IsShiftKeyDown()) then
		pickUpButton(self)
	elseif (TrinityBars2SavedState.modifierButtonLock == 2 and IsControlKeyDown()) then
		pickUpButton(self)
	elseif (TrinityBars2SavedState.modifierButtonLock == 3 and IsAltKeyDown()) then
		pickUpButton(self)
	end

	if (self.config.type == "slot") then
		slotPickup = true
	end

	self.dragbutton = nil
end

function TrinityBars2.ActionButton_OnDragStop(self)

	--[[

	if (self.config.type == "macro") then

		local frame = GetMouseFocus()

		--if (not find(frame:GetName(), "TrinityAction") or frame == self) then
		--	macroDrag = nil
		--	ClearCursor()
		--	SetCursor(nil)
		--end

		for k,dockFrame in pairs(dockIndex) do
			buttonVisibility(dockFrame, false)
		end
	end

	]]--
end

local function placeSpell(self, action1, action2)

	local spell, rank = GetSpellName(action1, action2)

	self.config.spell = spell or ""
	self.config.spellrank = tonumber(match(rank, "%d+")) or 0
	self.config.spellranktext = "("..rank..")"
	self.config.spellIndex = action1

	if (not self.cursor) then
		TrinityBars2.SetButtonType(self)
		updateSpell_OnEvent(self, self.config.spell)
		updateSpellCooldown_OnEvent(self, true, self.config.spell)
	end

	macroDrag = nil
	ClearCursor()
	SetCursor(nil)
end

--itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(itemID or "itemString" or "itemName" or "itemLink")

local function placeItem(self, action1, action2)

	--DEFAULT_CHAT_FRAME:AddMessage(action1)
	--DEFAULT_CHAT_FRAME:AddMessage(action2)

	local item, link = GetItemInfo(action2)

	self.config.item = item
	self.config.itemlink = link

	if (not self.cursor) then

		TrinityBars2.SetButtonType(self)

		updateItem_OnEvent(self)
		updateItemCooldown_OnEvent(self, true, self.config.itemlink)
	end

	macroDrag = nil
	ClearCursor()
	SetCursor(nil)
end

local function placeMacro(self)

	self.config.macro = macroDrag[2]
	self.config.macroicon = macroDrag[3]
	self.config.macroname = macroDrag[4]
	self.config.macronote = macroDrag[5]
	self.config.macrousenote = macroDrag[6]

	if (not self.cursor) then

		TrinityBars2.SetButtonType(self)

		local onEvent = self:GetScript("OnEvent")
		onEvent(self, "PLAYER_ENTERING_WORLD")

		if (macroDrag[1] ~= self) then

			if (macroDrag[1].dragbutton == "RightButton" and checkButtons[304]) then

			else
				macroDrag[1].config.macro = ""
				macroDrag[1].config.macroicon = 1
				macroDrag[1].config.macroname = ""
				macroDrag[1].config.macronote = ""
				macroDrag[1].config.macrousenote = false
			end

			if (not MouseIsOver(macroDrag[1]) and not macroDrag[1].dockFrame.config.showgrid) then
				macroDrag[1]:SetAttribute("showstates", "NOACTION")
				macroDrag[1]:Hide()
			end

			TrinityBars2.SetButtonType(macroDrag[1])

			onEvent = macroDrag[1]:GetScript("OnEvent")
			onEvent(macroDrag[1], "PLAYER_ENTERING_WORLD")
		end
	end

	for k,dockFrame in pairs(dockIndex) do
		buttonVisibility(dockFrame, false)
	end

	macroDrag = nil
	ClearCursor()
	SetCursor(nil)
end

function TrinityBars2.ActionButton_OnLoad(self)

	self.elapsed = 0
	self.id = 0
	self.dir = 0
	self.alphatimer = 0
	self.timedResetcount = 0
	self.cdduration = 0

	self.spells = ""

	self.flash = false
	self.flashing = false
	self.show_tooltip = false
	self.tooltip_shown = false

	if (TrinityBars2SavedState.registerForClicks == "down") then
		self:RegisterForClicks("AnyDown")
	else
		self:RegisterForClicks("AnyUp")
	end

	self:RegisterForDrag("LeftButton", "RightButton")

	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("ACTIONBAR_SHOWGRID")
	self:RegisterEvent("ACTIONBAR_HIDEGRID")
	self:RegisterEvent("ACTIONBAR_SLOT_CHANGED")

	self:HookScript("OnEnter", function(self) button_OnEnter(self) end)
	self:HookScript("OnLeave", function(self) button_OnLeave(self) end)

	self:SetScript("OnShow", function(self) button_OnShow(self) end)
	self:SetScript("OnHide", function(self) button_OnHide(self) end)

	_G[self:GetName().."CooldownTextHuge"]:SetTextColor(1,0,0)
	_G[self:GetName().."HotKey"]:SetTextColor(1,1,1)
	_G[self:GetName().."HotKey"]:Hide()

	self:SetFrameLevel(4)
end

function TrinityBars2.ActionButton_OnReceiveDrag(self, preclick)

	if (InCombatLockdown()) then
		return
	end

	local cursorType, action1, action2 = GetCursorInfo()

	--print(self.config.type)
	--print(action1)
	--print(action2)

	if (self.config.type == "action") then

		if (macroDrag and (macroDrag[1] ~= self or preclick)) then

			self.config.type = "macro"
			placeMacro(self, preclick)
		else

			if (self.config.action == 0) then
				if (self.id > 120) then
					self.config.action = 120
				else
					self.config.action = self.id
				end

				TrinityBars2.SetButtonType(self)
			end

			PlaceAction(self.config.action)
			updateAction_OnEvent(self, self.config.action)
		end

		actionButton_SetTooltip(self)

	elseif (self.config.type == "spell") then

		self.currspell = { self.config.spell, self.config.spellrank, self.config.spellranktext, self.config.spellIndex }

		if (macroDrag and (macroDrag[1] ~= self or preclick)) then

			self.config.type = "macro"
			placeMacro(self, preclick)

		elseif (cursorType == "spell") then

			placeSpell(self, action1, action2)

		elseif (cursorType == "item") then

			self.config.type = "item"
			placeItem(self, action1, action2)

		elseif (cursorType == "macro") then

			self.config.type = "action"

			if (self.config.action == 0) then
				if (self.id > 120) then
					self.config.action = 120
				else
					self.config.action = self.id
				end
			end

			TrinityBars2.SetButtonType(self)
			PlaceAction(self.config.action)
			ClearCursor()
		end

		spellButton_SetTooltip(self)

		if (self.currspell[1] and cursorType) then
			if (self.currspell[1] ~= "") then

				if (self.currspell[3] and self.currspell[3] ~= "") then
					PickupSpell(self.currspell[1]..self.currspell[3])
				else
					PickupSpell(self.currspell[1])
				end
			end
		end

		clearTable(self.currspell)

	elseif (self.config.type == "macro") then

		self.currmacro = { self, self.config.macro, self.config.macroicon, self.config.macroname, self.config.macronote, self.config.macrousenote, updateMacroIcon(self) }

		if (macroDrag) then

			placeMacro(self)

		elseif (cursorType == "spell") then

			self.config.type = "spell"
			placeSpell(self, action1, action2)

		elseif (cursorType == "item") then

			self.config.type = "item"
			placeItem(self, action1, action2)

		elseif (cursorType == "macro") then

			self.config.type = "action"

			if (self.config.action == 0) then
				if (self.id > 120) then
					self.config.action = 120
				else
					self.config.action = self.id
				end
			end

			TrinityBars2.SetButtonType(self)
			PlaceAction(self.config.action)
			ClearCursor()
		end

		macroButton_SetTooltip(self)

		if (self.currmacro[2] and cursorType) then
			if (self.currmacro[2] ~= "") then
				PickupMacro(self, self.currmacro)
			end
		end

		clearTable(self.currmacro)

	elseif (self.config.type == "item") then

		self.curritem = { self.config.itemlink }

		if (macroDrag and (macroDrag[1] ~= self or preclick)) then

			self.config.type = "macro"
			placeMacro(self, preclick)

		elseif (cursorType == "item") then

			placeItem(self, action1, action2)

		elseif (cursorType == "spell") then

			self.config.type = "spell"
			placeSpell(self, action1, action2)

		elseif (cursorType == "macro") then

			self.config.type = "action"

			if (self.config.action == 0) then
				if (self.id > 120) then
					self.config.action = 120
				else
					self.config.action = self.id
				end
			end

			TrinityBars2.SetButtonType(self)
			PlaceAction(self.config.action)
			ClearCursor()
		end

		itemButton_SetTooltip(self)

		if (self.curritem[1] and cursorType) then
			if (self.curritem[1] ~= "") then
				PickupItem(self.curritem[1])
			end
		end

		clearTable(self.curritem)

	elseif (self.config.type == "slot") then

		if (macroDrag and (macroDrag[1] ~= self or preclick)) then

			self.config.type = "macro"
			placeMacro(self, preclick)

		elseif (cursorType == "spell") then

			self.config.type = "spell"
			placeSpell(self, action1, action2)

		elseif (cursorType == "item") then
			PickupInventoryItem(self.config.slot)

		elseif (cursorType == "macro") then

			self.config.type = "action"

			if (self.config.action == 0) then
				if (self.id > 120) then
					self.config.action = 120
				else
					self.config.action = self.id
				end
			end

			TrinityBars2.SetButtonType(self)
			PlaceAction(self.config.action)
			ClearCursor()
		end

		slotPickup = false

		slotButton_SetTooltip(self)
	end

	self.elapsed = 0.2
end

function TrinityBars2.ActionButton_PreClick(self)

	self.cursor = nil

	local cursorType = GetCursorInfo()

	if (cursorType or macroDrag) then
		self.cursor = true
		TrinityBars2.SetButtonType(self, true)
		TrinityBars2.ActionButton_OnReceiveDrag(self, true)
	end
end

function TrinityBars2.ActionButton_PostClick(self)

	if (self.cursor) then
		self.cursor = nil
		TrinityBars2.SetButtonType(self)
	end

	if (self.config.type == "action") then

		updateActionState(self, self.config.action)

	elseif (self.config.type == "spell") then

		updateSpellState(self, self.config.spell)

	elseif (self.config.type == "macro") then

		local onEvent = self:GetScript("OnEvent")
		onEvent(self, "PLAYER_ENTERING_WORLD")

	elseif (self.config.type == "item") then

		updateItemState(self, self.config.itemlink)

	elseif (self.config.type == "slot") then

		updateSlotState(self, self.config.item)

	end
end

function TrinityBars2.ClassButton_OnLoad(self)

	self.classButton = true
	self.flashing = 0;
	self.flashtime = 0;
	self.elapsed = 0;
	self:RegisterForDrag("LeftButton", "RightButton")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	self:RegisterEvent("PLAYER_AURAS_CHANGED")
	self:RegisterEvent("UNIT_AURA")
	_G[self:GetName().."CooldownTextHuge"]:SetTextColor(1,0,0)
	_G[self:GetName().."HotKey"]:SetTextColor(1,1,1)
	_G[self:GetName().."HotKey"]:Hide()
	self:SetFrameLevel(4)
end

function TrinityBars2.ClassButton_OnEvent(self, event,...)

	if (event == "SPELL_UPDATE_COOLDOWN") then
		updateClassButtonCooldown_OnEvent(self)
	end

	if (event == "PLAYER_AURAS_CHANGED" or event == "UPDATE_SHAPESHIFT_FORM") then

		updateClassButton_OnEvent(self)
		classButton_UpdateState(self)
	end

	if (event == "PLAYER_ENTERING_WORLD") then

		updateClassButtonCooldown_OnEvent(self)
		classButton_UpdateState(self)

		if (TrinityBars2SavedState.registerForClicks == "down") then
			self:RegisterForClicks("AnyDown")
		else
			self:RegisterForClicks("AnyUp")
		end
	end
end

function TrinityBars2.ClassButton_OnEnter(self)

	if (checkButtons[101]) then
		if ( GetCVar("UberTooltips") == "1" ) then
			GameTooltip_SetDefaultAnchor(GameTooltip, self)
		else
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		end
		if (self.spellIndex) then
			GameTooltip:SetSpell(self.spellIndex, BOOKTYPE_SPELL)
		end
	end
end

function TrinityBars2.ClassButton_OnLeave(self)

	self.UpdateTooltip = nil;
	GameTooltip:Hide()
end

function TrinityBars2.ClassButton_PostClick(self)

	classButton_UpdateState(self)
end

function TrinityBars2.ClassButton_OnUpdate(self, elapsed)

	self.elapsed = self.elapsed + elapsed;

	if (self.elapsed > 0.15) then
		updateClassButton(self, self.config.spell)
		self.elapsed = 0;
		if (self.cooldown) then
			updateClassButtonCooldown_OnUpdate(self)
		end
	end
end

function TrinityBars2.PetButton_OnLoad(self)

	self.petButton = true
	self.flashing = 0;
	self.flashtime = 0;
	self.elapsed = 0;
	self:RegisterForDrag("LeftButton", "RightButton")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_CONTROL_LOST")
	self:RegisterEvent("PLAYER_CONTROL_GAINED")
	self:RegisterEvent("PLAYER_FARSIGHT_FOCUS_CHANGED")
	self:RegisterEvent("UNIT_PET")
	self:RegisterEvent("UNIT_FLAGS")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PET_BAR_UPDATE")
	self:RegisterEvent("PET_BAR_UPDATE_COOLDOWN")
	_G[self:GetName().."CooldownTextHuge"]:SetTextColor(1,0,0)
	_G[self:GetName().."HotKey"]:SetTextColor(1,1,1)
	_G[self:GetName().."HotKey"]:Hide()
	_G[self:GetName().."AutoCast"]:ClearAllPoints()
	_G[self:GetName().."AutoCast"]:SetPoint("TOPLEFT", 4, 4)
	_G[self:GetName().."AutoCast"]:SetPoint("BOTTOMRIGHT", 4, 4)
	_G[self:GetName().."AutoCast"]:SetScale(0.9)
	self:SetFrameLevel(4)
end

function TrinityBars2.PetButton_OnEvent(self, event)

	if ( event == "PET_BAR_UPDATE" or (event == "UNIT_PET" and arg1 == "player") ) then
		updatePetButton_OnEvent(self)
	elseif ( event == "PLAYER_CONTROL_LOST" or event == "PLAYER_CONTROL_GAINED" or event == "PLAYER_FARSIGHT_FOCUS_CHANGED" ) then
		updatePetButton_OnEvent(self)
	elseif (event == "UNIT_FLAGS" or event == "UNIT_AURA") then
		if (arg1 == "pet") then
			updatePetButton_OnEvent(self)
		end
	elseif ( event =="PET_BAR_UPDATE_COOLDOWN" ) then
		updatePetButtonCooldown_OnEvent(self)
	end

	if (event == "PLAYER_ENTERING_WORLD") then
		updatePetButtonCooldown_OnEvent(self)

		if (TrinityBars2SavedState.registerForClicks == "down") then
			self:RegisterForClicks("AnyDown")
		else
			self:RegisterForClicks("AnyUp")
		end
	end
end

function TrinityBars2.PetButton_OnEnter(self)

	if (checkButtons[101]) then
		local uber = GetCVar("UberTooltips")
		if ( self.isToken or (uber == "0") ) then
			if ( uber == "0" ) then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			else
				GameTooltip_SetDefaultAnchor(GameTooltip, self)
			end
			if (self.tooltipName) then
				GameTooltip:SetText(self.tooltipName)
			end
			if ( self.tooltipSubtext ) then
				GameTooltip:AddLine(self.tooltipSubtext, "", 0.5, 0.5, 0.5)
			end
			GameTooltip:Show()
		else
			GameTooltip_SetDefaultAnchor(GameTooltip, self)
			GameTooltip:SetPetAction(self:GetID())
		end
	end
end

function TrinityBars2.PetButton_OnLeave(self)

	self.UpdateTooltip = nil;
	GameTooltip:Hide()
end

function TrinityBars2.PetButton_OnUpdate(self, elapsed)

	self.elapsed = self.elapsed + elapsed;

	if (self.elapsed > 0.15) then
		if (self.cooldown) then
			updatePetButtonCooldown_OnUpdate(self)
		end
		self.elapsed = 0;
	end

	updatePetButton(self)
end

function TrinityBars2.PossessButton_OnLoad(self)

	self.flashing = 0
	self.flashtime = 0
	self.elapsed = 0
	self.login = false
	self:RegisterEvent("PLAYER_LOGIN")
end

function TrinityBars2.PossessButton_OnEvent(self, event)

	if (event == "PLAYER_LOGIN") then
		if (self:GetID() == 2) then
			self:SetAttribute("type", "macro")
			self:SetAttribute("macrotext", "/run local _, name = GetPossessInfo(1) CancelPlayerBuff(name)")
		end
		self.login = true
	end
end

function TrinityBars2.PossessButton_OnShow(self)

	if (self.login) then

		local texture, name = GetPossessInfo(self:GetID())

		if (texture) then

			self.iconframeicon:SetTexture(texture)
			self.iconframeicon:Show()

			updateButtonColors(self, true)
		else

			self.iconframeicon:SetTexture("")
			self.iconframeicon:Hide()

			updateButtonColors(self, false)
		end

		self:SetChecked(0)
	end
end

function TrinityBars2.PossessButton_OnEnter(self)

	if ( GetCVar("UberTooltips") == "1" ) then
		GameTooltip_SetDefaultAnchor(GameTooltip, self)
	else
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	end

	if (self:GetID() == 2) then
		local _, name = GetPossessInfo(1)
		if (name) then
			GameTooltip:SetText(CANCEL.." "..name)
		end
	else
		GameTooltip:SetPossession(self:GetID())
	end
end

function TrinityBars2.PossessButton_OnLeave(self)
	 GameTooltip:Hide()
end

function TrinityBars2.PossessButton_PostClick(self)

	if (self:GetID() == 1) then
		self:SetChecked(0)
	end

end

function TrinityBars2.BindFrame_OnLoad(self)

	self:EnableMouseWheel(true)
	self:RegisterForClicks("AnyUp")
	self:RegisterForClicks("AnyDown")
	self:Hide()
	self:SetFrameLevel(6)
end

function TrinityBars2.BindFrame_OnAction(self)

	local modifier, button, action, actionText, spell, macro, type

	if (keyBindButton ~= 0) then

		btnType = match(keyBindButton, "%d+$")

		if (btnType == "1") then
			actionText = TRINITYBARS2_STRINGS.ACTIONTEXT_ACTION..match(keyBindButton, "^%d+")
		elseif (btnType == "2") then
			actionText = TRINITYBARS2_STRINGS.ACTIONTEXT_CLASS..match(keyBindButton, "^%d+")
		elseif (btnType == "3") then
			actionText = TRINITYBARS2_STRINGS.ACTIONTEXT_PET..match(keyBindButton, "^%d+")
		end

	elseif (keyBindSpell) then
		actionText = match(keyBindSpell, "%a.+")
		spell = actionText
	elseif (keyBindMacro) then
		actionText = keyBindMacro
		macro = keyBindMacro
	end

	if (IsAltKeyDown()) then
		modifier = "ALT-"
	end

	if (IsControlKeyDown()) then
		if (modifier) then
			modifier = modifier.."CTRL-";
		else
			modifier = "CTRL-";
		end
	end

	if (IsShiftKeyDown()) then
		if (modifier) then
			modifier = modifier.."SHIFT-";
		else
			modifier = "SHIFT-";
		end
	end

	if (arg1 == "MiddleButton") then
		button = "BUTTON3";
		action = arg1
	elseif (arg1 == "Button4") then
		button = "BUTTON4";
		action = arg1
	elseif (arg1 == "Button5") then
		button = "BUTTON5";
		action = arg1
	elseif (arg1 == 1) then
		button = "MOUSEWHEELUP";
		action = "MousewheelUp"
	elseif (arg1 == -1) then
		button = "MOUSEWHEELDOWN";
		action = "MousewheelDown"
	elseif (find(arg1,"ALT") or find(arg1,"SHIFT") or find(arg1,"CTRL")) then
		return;
	else
		button = arg1
		action = arg1
	end

	if (arg1 ~= "LeftButton" and arg1~= "RightButton") then

		TrinityBars2.ProcessBinding(button, modifier, spell, macro)

		if (button == "ESCAPE") then
			Trinity2MessageFrame:AddMessage(actionText.."'s"..TRINITY2_STRINGS.DOCK_CLEARED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		elseif (modifier) then
			Trinity2MessageFrame:AddMessage(actionText..TRINITY2_STRINGS.DOCK_BOUND..modifier..action, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		else
			Trinity2MessageFrame:AddMessage(actionText..TRINITY2_STRINGS.DOCK_BOUND..action, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		end
	end
end

function TrinityBars2.BindFrame_OnEnter(self)

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")

	keyBindSpell = nil;
	keyBindMacro = nil;
	keyBindButton = 0;

	if (self.action == "action") then

		local button = self:GetParent()

		if (button.classButton) then

			if (button.spellIndex) then
				GameTooltip:SetSpell(button.spellIndex, BOOKTYPE_SPELL)
			else
				GameTooltip:SetText("Empty Button")
			end

		elseif (button.petButton) then

			if (button.isToken) then
				if (button.tooltipName) then
					GameTooltip:SetText(button.tooltipName)
				else
					GameTooltip:SetText("Empty Button")
				end

				if ( button.tooltipSubtext ) then
					GameTooltip:AddLine(button.tooltipSubtext, "", 0.5, 0.5, 0.5)
				end
			else
				GameTooltip:SetPetAction(button:GetID())
			end
		else

			if (button.config.type == "action") then

				if (HasAction(button.config.action)) then
					GameTooltip:SetAction(button.config.action)
				else
					GameTooltip:SetText("Empty Button")
				end

			elseif (button.config.type == "spell") then

				if (button.config.spell and button.config.spell ~= "") then

					local spell = lower(button.config.spell)

					if (spellIndex[spell]) then
						GameTooltip:SetSpell(spellIndex[spell][1], "spell")
					end
				else
					GameTooltip:SetText("Empty Button")
				end

			elseif (button.config.type == "macro") then

				local spell = self.macrospell

				if (spell and spell ~= "") then

					if (spellIndex[spell]) then
						GameTooltip:SetSpell(spellIndex[spell][1], "spell")
					end
				else
					GameTooltip:SetText("Empty Button")
					button.UpdateTooltip = nil;
				end

			elseif (button.config.type == "item") then

				local link = button.config.itemlink

				if (link and link ~= "") then

					GameTooltip:SetHyperlink(link)
				end

			elseif (button.config.type == "slot") then

				GameTooltip:SetInventoryItem("player", button.config.slot)
			end
		end

	elseif (self.action == "spell") then
		if (_G[self:GetParent():GetName().."IconTexture"]:IsVisible()) then
			local id = SpellBook_GetSpellID(self:GetID())
			GameTooltip:SetSpell(id, SpellBookFrame.bookType)
		end
	elseif (self.action == "macro") then
		local name, _, body, _ = GetMacroInfo(MacroFrame.macroBase + self:GetID())
		if (name and body) then
			name = "|cffffffff"..name.."|r"
			GameTooltip:AddLine(name.."\n\n"..body)
		end
	end

	GameTooltip:Show()
end

function TrinityBars2.BindFrame_OnLeave(self)

	TrinityBars2SimpleKeyBinder:EnableKeyboard(false)
	TrinityBars2KeyBinder:EnableKeyboard(false)
	self.UpdateTooltip = nil;
	GameTooltip:Hide()
end

function TrinityBars2.KeyBinder_OnUpdate(self, elapsed)

	if (self.elapsedTime) then
		self.elapsedTime = self.elapsedTime + elapsed;
	else
		self.elapsedTime = elapsed;
	end

	if (self.elapsedTime < 0.1) then
		return;
	end

	local spellid, spellName, subSpellName, texture, obj, frame, id, name, body

	self.elapsedTime = nil;

	if (keyBindButton == 0) then

		obj = GetMouseFocus()

		if (obj and obj:GetName()) then
			frame = obj:GetName()
			id = obj:GetID()
			if (find(frame, "TrinityActionButton")) then
				self:EnableKeyboard(true)
				GameTooltip:AddLine("\nHit a key to bind it to |cff00ff00Action Button "..id.."|r", 1.0, 1.0, 1.0)
				GameTooltip:AddLine("Hit |cfff00000ESC|r to clear this button's current binding", 1.0, 1.0, 1.0)
				keyBindButton = id + 0.1;
			elseif (find(frame, "TrinityClassButton")) then
				self:EnableKeyboard(true)
				GameTooltip:AddLine("\nHit a key to bind it to |cff00ff00Shapeshift Button "..id.."|r", 1.0, 1.0, 1.0)
				GameTooltip:AddLine("Hit |cfff00000ESC|r to clear this button's current binding", 1.0, 1.0, 1.0)
				keyBindButton = id + 0.2;

			elseif (find(frame, "TrinityPetButton")) then
				self:EnableKeyboard(true)
				GameTooltip:AddLine("\nHit a key to bind it to |cff00ff00Pet Action Button "..id.."|r", 1.0, 1.0, 1.0)
				GameTooltip:AddLine("Hit |cfff00000ESC|r to clear this button's current binding", 1.0, 1.0, 1.0)
				keyBindButton = id + 0.3;
			end
		end
	end

	if (not keyBindSpell) then

		obj = GetMouseFocus()

		if (obj and obj:GetName()) then
			frame = obj:GetName()
			id = obj:GetID()
			if (find(frame, "TrinitySpellBinderButton")) then
				if (find(obj:GetParent():GetName(), "SpellButton") and _G[obj:GetParent():GetName().."IconTexture"]:IsVisible()) then
					spellid = SpellBook_GetSpellID(id)
					spellName, subSpellName = GetSpellName(spellid, SpellBookFrame.bookType)
					texture = GetSpellTexture(spellid, SpellBookFrame.bookType)
					if (spellName) then
						self:EnableKeyboard(true)
						if (subSpellName) then
							GameTooltip:AddLine("\n Hit a key to bind it to |cff00ff00"..spellName.."("..subSpellName..")|r", 1.0, 1.0, 1.0)
							GameTooltip:AddLine(" Hit |cfff00000ESC|r to clear this spell's binding", 1.0, 1.0, 1.0)
							keyBindSpell = spellid..spellName.."("..subSpellName..")";
						else
							GameTooltip:AddLine("\n Hit a key to bind it to |cff00ff00"..spellName.."()|r", 1.0, 1.0, 1.0)
							GameTooltip:AddLine(" Hit |cfff00000ESC|r to clear this spell's binding", 1.0, 1.0, 1.0)
							keyBindSpell = spellid..spellName.."()";
						end
					end
				end
			end
		end
	end

	if (not keyBindMacro) then

		obj = GetMouseFocus()

		if (obj and obj:GetName()) then
			frame = obj:GetName()
			id = obj:GetID()
			if (find(frame, "TrinityMacroBinderButton")) then
				if (find(obj:GetParent():GetName(), "MacroButton") and _G[obj:GetParent():GetName().."Icon"]:IsVisible()) then
					name, _, body, _ = GetMacroInfo(MacroFrame.macroBase + id)
					if (name and body) then
						self:EnableKeyboard(true)
						GameTooltip:AddLine("\n Hit a key to bind it to macro |cff00ff00"..name.."|r", 1.0, 1.0, 1.0)
						GameTooltip:AddLine(" Hit |cfff00000ESC|r to clear this macro's binding", 1.0, 1.0, 1.0)
						keyBindMacro = name
					end
				end
			end
		end
	end

	GameTooltip:Show()
end

function TrinityBars2.CopyKeyBindings()

	local dockFrame = TrinityDockFrame1
	local button, bindkey, modifier
	local buttonList = {}

	for key,value in pairs(dockFrame.headers) do

		header = _G[dockFrame.headers[key]["name"]]

		for showstate=dockFrame.headers[key]["start"],dockFrame.headers[key]["end"] do

			if (dockFrame.headers[key]["list"][showstate]) then

				clearTable(buttonList)

				gsub(dockFrame.headers[key]["list"][showstate], "%d+", function (btn) table.insert(buttonList, btn) end)

				for k,v in ipairs(buttonList) do

					bindkey = nil
					modifier = nil

					button = _G[dockFrame.config.btnType..v]

					if (not button.config["HotKey1"] or button.config["HotKey1"] == "") then

						bindkey = GetBindingKey("ACTIONBUTTON"..k)

						if (bindkey) then

							keyBindButton = v..".1"

							if (find(bindkey, "-") and not find(bindkey, "^-$")) then
								modifier = match(bindkey, "^[^-]+")
								modifier = modifier.."-"
								bindkey = match(bindkey, "[^-]+$")

							end

							TrinityBars2.ProcessBinding(bindkey, modifier, nil, nil)
						end
					end
				end
			end
		end
	end
end

function TrinityBars2.ScaleButton(button, dir)

	if (dir == "add") then
		button.config.scale = button.config.scale + 0.01;
	else
		button.config.scale = button.config.scale - 0.01;
		if (button.config.scale < 0.2) then
			button.config.scale = 0.2;
		end
	end
end

function TrinityBars2.AdjustXoffset(button, dir)

	if (dir == "add") then
		button.config["XOffset"] = button.config["XOffset"] + 0.5;
	else
		button.config["XOffset"] = button.config["XOffset"] - 0.5;
	end
end

function TrinityBars2.AdjustYoffset(button, dir)

	if (dir == "add") then
		button.config["YOffset"] = button.config["YOffset"] + 0.5;
	else
		button.config["YOffset"] = button.config["YOffset"] - 0.5;
	end
end

function TrinityBars2.ChangeButtonTarget(dockFrame, button, target)

	button.config["target"] = target
	TrinityBars2.UpdateTargeting(dockFrame)
end

-- action - spell - macro - item - slot

function TrinityBars2.ChangeButtonType(dockFrame, button, action)

	if (button.config.homedock) then

	else
		if (action == "add") then

			if (button.config.type == "action") then
				button.config.type = "spell"
			elseif (button.config.type == "spell") then
				button.config.type = "macro"
			elseif (button.config.type == "macro") then
				button.config.type = "item"
			elseif (button.config.type == "item") then
				button.config.type = "slot"
			elseif (button.config.type == "slot") then
				button.config.type = "action"
			else
				button.config.type = "spell"
			end
		else

			if (button.config.type == "action") then
				button.config.type = "slot"
			elseif (button.config.type == "spell") then
				button.config.type = "action"
			elseif (button.config.type == "macro") then
				button.config.type = "spell"
			elseif (button.config.type == "item") then
				button.config.type = "macro"
			elseif (button.config.type == "slot") then
				button.config.type = "item"
			else
				button.config.type = "spell"
			end
		end

		TrinityBars2ButtonEditorCurrentButtonEdit2:SetText(button.config.type)
		TrinityBars2.SetButtonType(button)
	end
end

function TrinityBars2.SetButtonType(button, kill)

	if (InCombatLockdown()) then
		return
	end

	local buttonType = gsub(button.config.type, "slot", "item")

	if (kill) then

		button:SetAttribute("useparent-unit", nil)
		button:SetAttribute("type", nil)

		if (button.config.type == "action") then
			button:SetAttribute("*"..button.config.type.."*", nil)
		elseif (button.config.type == "spell") then
			button:SetAttribute("*"..button.config.type.."*", nil)
		elseif (button.config.type == "macro") then
			button:SetAttribute("*macrotext*", nil)
		elseif (button.config.type == "item") then
			button:SetAttribute("*"..button.config.type.."*", nil)
		elseif (button.config.type == "slot") then
			button:SetAttribute("*slot*", nil)
		end
	else

		button:SetAttribute("useparent-unit", true)
		button:SetAttribute("type", buttonType)

		if (button.config.homedock) then
			button.editframetype:SetText(button.config.homedock)
		else
			if (button.config.type == "action") then
				button.editframetype:SetText(button.config.type.."\nid:"..button.config.action)
			else
				button.editframetype:SetText(button.config.type)
			end
		end

		if (button.config.type == "action") then

			button:SetScript("OnEvent", action_OnEvent)
			button:SetScript("OnUpdate", actionButton_OnUpdate)

			button:SetAttribute("*"..button.config.type.."*", button.config.action)
			updateAction_OnEvent(button, button.config.action)
			updateActionCooldown_OnEvent(button, true, 4, button.config.action)

		elseif (button.config.type == "spell") then

			local spell = button.config.spell..button.config.spellranktext or "()"

			button:SetScript("OnEvent", spell_OnEvent)
			button:SetScript("OnUpdate", spellButton_OnUpdate)

			button:SetAttribute("*"..button.config.type.."*", spell)
			updateSpell_OnEvent(button, button.config.spell)
			updateSpellCooldown_OnEvent(button, true, button.config.spell)

		elseif (button.config.type == "macro") then

			button:SetScript("OnEvent", macro_OnEvent)
			button:SetScript("OnUpdate", macroButton_OnUpdate)

			button:SetAttribute("*macrotext*", button.config.macro)

			local onEvent = button:GetScript("OnEvent")
			onEvent(button, "PLAYER_ENTERING_WORLD")

		elseif (button.config.type == "item") then

			button:SetScript("OnEvent", item_OnEvent)
			button:SetScript("OnUpdate", itemButton_OnUpdate)

			--button:SetAttribute("type", "customFunc")
			--button.customFunc = function(self) DEFAULT_CHAT_FRAME:AddMessage(self:GetName()) end

			button:SetAttribute("*"..button.config.type.."*", button.config.item)
			updateItem_OnEvent(button, button.config.itemlink)
			updateItemCooldown_OnEvent(button, true, button.config.itemlink)

		elseif (button.config.type == "slot") then

			button:SetScript("OnEvent", slot_OnEvent)
			button:SetScript("OnUpdate", slotButton_OnUpdate)

			button:SetAttribute("*slot*", button.config.slot)
			updateSlot_OnEvent(button, button.config.item, button.config.itemlink)
			updateSlotCooldown_OnEvent(button, true, button.config.item)
		end
	end

end

function TrinityBars2.ToggleButtonSpellCounts(self, button)

	if (self:GetChecked()) then
		button.config["spell counts"] = true
	else
		button.config["spell counts"] = false
	end

	local onEvent = button:GetScript("OnEvent")
	onEvent(button, "PLAYER_ENTERING_WORLD")
end

function TrinityBars2.ToggleButtonClickAnchor(self, button)

	local dockButton

	for k,v in pairs(button.dockFrame.buttonList) do
		dockButton = _G[button.dockFrame.config.btnType..v]
		dockButton.config["click anchor"] = false
	end

	if (self:GetChecked()) then
		button.config["click anchor"] = true
		if (button.config["mouseover anchor"]) then
			button.config["mouseover anchor"] = false
			TrinityBars2.ClearButtonMouseoverAnchor(button, _G[button.dockFrame.headers[button.dockFrame.activeHeader]["name"]])
			SecureStateAnchor_RunChild(button, "OnEnter", "onenterbutton");
			TrinityBars2ButtonEditorAnchorOptionsCheck1:SetChecked(nil)
		end
	else
		button.config["click anchor"] = false
		button:SetAttribute("*childstate-OnEnter", "enter")
		SecureStateAnchor_RunChild(button, "OnEnter", "onenterbutton");
	end

	TrinityBars2.SetButtonClickAnchor(button.dockFrame)
end

function TrinityBars2.SetButtonClickAnchor(dockFrame)

	local button, setstate, header = nil, false, nil

	for k,v in pairs(dockFrame.buttonList) do

		button = _G[dockFrame.config.btnType..v]

		if (not button.config.anchoredheader or button.config.anchoredheader == "") then
			button.config.anchoredheader = dockFrame.headers.Normal.name
		end

		header = _G[button.config.anchoredheader]

		if (button.config["click anchor"]) then

			TrinityBars2.ApplyButtonClickAnchor(button, header)

		elseif (not button.config["mouseover anchor"]) then

			TrinityBars2.ClearButtonClickAnchor(button, header)
		end
	end

	updateDocking(dockFrame)
end

function TrinityBars2.ApplyButtonClickAnchor(button, header)

	TrinityAnchorHeader:SetAttribute("addchild", button)

	button:SetAttribute("anchorchild", header)
	button:SetAttribute("*childstate-up", "^up")
	header:SetAttribute("delaytimemap-anchor-leave",  "0:"..button.config.anchordelay)

	SecureStateAnchor_RunChild(button, "LeftButton", "onmouseupbutton");
end

function TrinityBars2.ClearButtonClickAnchor(button, header)

	button:SetAttribute("*childstate-OnEnter", "enter")
	SecureStateAnchor_RunChild(button, "OnEnter", "onenterbutton");

	button:SetAttribute("*childstate-up", nil)
	button:SetAttribute("*childstate-OnEnter", nil)
	button:SetAttribute("*childstate-OnLeave", nil)
end

function TrinityBars2.ToggleButtonMouseoverAnchor(self, button)

	local dockButton

	for k,v in pairs(button.dockFrame.buttonList) do
		dockButton = _G[button.dockFrame.config.btnType..v]
		dockButton.config["mouseover anchor"] = false
	end

	if (self:GetChecked()) then
		button.config["mouseover anchor"] = true
		if (button.config["click anchor"]) then
			button.config["click anchor"] = false
			TrinityBars2.ClearButtonClickAnchor(button, _G[button.dockFrame.headers[button.dockFrame.activeHeader]["name"]])
			SecureStateAnchor_RunChild(button, "LeftButton", "onmouseupbutton");
			TrinityBars2ButtonEditorAnchorOptionsCheck2:SetChecked(nil)
		end
	else
		button.config["mouseover anchor"] = false
		SecureStateAnchor_RunChild(button, "OnEnter", "onenterbutton");
	end

	TrinityBars2.SetButtonMouseoverAnchor(button.dockFrame)
end

function TrinityBars2.SetButtonMouseoverAnchor(dockFrame)

	local button, setstate, header = nil, false, nil

	for k,v in pairs(dockFrame.buttonList) do

		button = _G[dockFrame.config.btnType..v]

		if (not button.config.anchoredheader or button.config.anchoredheader == "") then
			button.config.anchoredheader = dockFrame.headers.Normal.name
		end

		header = _G[button.config.anchoredheader]

		if (button.config["mouseover anchor"]) then

			TrinityBars2.ApplyButtonMouseoverAnchor(button, header)

		elseif (not button.config["click anchor"]) then

			TrinityBars2.ClearButtonMouseoverAnchor(button, header)
		end

	end

	updateDocking(dockFrame)
end

function TrinityBars2.ApplyButtonMouseoverAnchor(button, header)

	TrinityAnchorHeader:SetAttribute("addchild", button)

	button:SetAttribute("anchorchild", header)
	button:SetAttribute("*childraise-OnEnter", true)
	button:SetAttribute("*childstate-OnEnter", "enter")
	button:SetAttribute("*childstate-OnLeave", "leave")
	header:SetAttribute("delaytimemap-anchor-leave",  "0:"..button.config.anchordelay)

	SecureStateAnchor_RunChild(button, "OnLeave", "onleavebutton");

end

function TrinityBars2.ClearButtonMouseoverAnchor(button, header)

	SecureStateAnchor_RunChild(button, "OnEnter", "onenterbutton");

	button:SetAttribute("*childraise-OnEnter", nil)
	button:SetAttribute("*childstate-OnEnter", nil)
	button:SetAttribute("*childstate-OnLeave", nil)

end

function TrinityBars2.ChangeShape(dockFrame, data)

	if (data == "add" or data == "subtract") then

		if (data == "subtract") then

			dockFrame.config["shape"] = dockFrame.config["shape"] - 1;
			if (dockFrame.config["shape"] < 0) then
				dockFrame.config["shape"] = Trinity2.MaxDockShapes
			end

		elseif (data == "add") then

			dockFrame.config["shape"] = dockFrame.config["shape"] + 1;
			if (dockFrame.config["shape"] > Trinity2.MaxDockShapes) then
				dockFrame.config["shape"] = 0
			end
		end
	else

		local shapeNum = 0

		for k,v in pairs(barShapes) do
			if (v == data) then
				shapeNum = k
			end
		end

		dockFrame.config["shape"] = shapeNum
	end

	setShapeOptions(dockFrame)
end

function TrinityBars2.UpdateBarName(dockFrame, name)

	dockFrame.config.name = name
	updateDockNames(dockFrame)

end

function TrinityBars2.ChangeTarget(dockFrame, data)

	if (data == "add" or data == "subtract") then

		local index

		for i=1, #targetNames do
			if (dockFrame.config["target"] == targetNames[i]) then
				index = i
				break
			end
		end

		if (not index) then
			index = 1
		end

		if (data == "subtract") then
			if (index == 1) then
				index = #targetNames
			else
				index = index - 1
			end

			dockFrame.config["target"] = targetNames[index]

		elseif (data == "add") then
			if (index == #targetNames) then
				index = 1;
			else
				index = index + 1
			end

			dockFrame.config["target"] = targetNames[index]
		end
	else
		dockFrame.config.target = data
	end

	TrinityBars2.UpdateTargeting(dockFrame)
end

function TrinityBars2.ChangeStrata(dockFrame, strata)

	local index = 2

	for k,v in pairs(frameStratas) do
		if (v == strata) then
			index = k
		end
	end

	dockFrame.config.buttonStrata = frameStratas[index]
	dockFrame.config.dockStrata = frameStratas[index+1]
end

function TrinityBars2.UpdateTargeting(dockFrame)

	local buttonList = {}
	local button;

	for key, value in pairs(dockFrame.headers) do
		if (dockFrame.headers[key]["active"]) then
			for k,v in pairs(dockFrame.headers[key]["list"]) do

				clearTable(buttonList)

				if (v and v ~= "") then
					gsub(v, "%d+", function (btn) table.insert(buttonList, btn) end)
					for i=1,#buttonList do

						button = _G[dockFrame.config.btnType..buttonList[i]]

						if (dockFrame.config["target"] == "none") then
							if (button.config["target"] == "none") then
								button:SetAttribute("unit1", nil)
								button.target = nil
							else
								button:SetAttribute("unit1", button.config["target"])
								button.target = button.config["target"]
							end
						else
							if (button.config["target"] == "none") then
								button.target = dockFrame.config["target"]
							else
								button:SetAttribute("unit1", button.config["target"])
								button.target = button.config["target"]
							end
						end
					end
				end
			end
		end
	end

	TrinityBars2.SetHelpHarmBar(dockFrame)
	setTargetBars(dockFrame)
end

function TrinityBars2.UpdateScale(dockFrame, action)

	if (action == "add") then
		dockFrame.config.scale = dockFrame.config.scale + 0.01;
	else
		dockFrame.config.scale = dockFrame.config.scale - 0.01;
		if (dockFrame.config.scale < 0.2) then
			dockFrame.config.scale = 0.2;
		end
	end
end

function TrinityBars2.UpdateAlpha(dockFrame, action)

	if (action == "add") then
		dockFrame.config["alpha"] = dockFrame.config["alpha"] + 0.05;
		if (dockFrame.config["alpha"] > 1) then
			dockFrame.config["alpha"] = 1;
		end
	else
		dockFrame.config["alpha"] = dockFrame.config["alpha"] - 0.05;
		if (dockFrame.config["alpha"] < 0) then
			dockFrame.config["alpha"] = 0;
		end
	end
end

function TrinityBars2.UpdateAlphaUp(dockFrame, data)

	if (data == "add" or data == "subtract") then

		local index

		for i=1, #alphaUp do
			if (dockFrame.config.alphaup == alphaUp[i]) then
				index = i
				break
			end
		end

		if (not index) then
			index = 1
		end

		if (data == "subtract") then
			if (index == 1) then
				index = #alphaUp
			else
				index = index - 1
			end

			dockFrame.config.alphaup = alphaUp[index]

		elseif (data == "add") then
			if (index == #alphaUp) then
				index = 1;
			else
				index = index + 1
			end

			dockFrame.config.alphaup = alphaUp[index]
		end
	else
		dockFrame.config.alphaup = data
	end

	TrinityBars2.SetAlphaup(dockFrame)
end

function TrinityBars2.ChangeTaperScale(dockFrame, action)

	if (action == "add") then
		dockFrame.config["taper"][2] = dockFrame.config["taper"][2] + 0.01;
	else
		dockFrame.config["taper"][2] = dockFrame.config["taper"][2] - 0.01;
		if (dockFrame.config["taper"][2] < 0.2) then
			dockFrame.config["taper"][2] = 0.2;
		end
	end

	TrinityBars2.SetTaper(dockFrame)
end

function TrinityBars2.ChangeTaperStyle(dockFrame, action)

	if (action == "add") then
		if (dockFrame.config["taper"][1] == "none") then
			dockFrame.config["taper"][1] = "Center"
		elseif (dockFrame.config["taper"][1] == "Center") then
			dockFrame.config["taper"][1] = "Left"
		elseif (dockFrame.config["taper"][1] == "Left") then
			dockFrame.config["taper"][1] = "Right"
		elseif (dockFrame.config["taper"][1] == "Right") then
			dockFrame.config["taper"][1] = "none"
		end
	else
		if (dockFrame.config["taper"][1] == "none") then
			dockFrame.config["taper"][1] = "Right"
		elseif (dockFrame.config["taper"][1] == "Center") then
			dockFrame.config["taper"][1] = "none"
		elseif (dockFrame.config["taper"][1] == "Left") then
			dockFrame.config["taper"][1] = "Center"
		elseif (dockFrame.config["taper"][1] == "Right") then
			dockFrame.config["taper"][1] = "Left"
		end
	end

	TrinityBars2.SetTaper(dockFrame)
end

function TrinityBars2.AdjustHSpacing(dockFrame, dir)

	if (dir == "add") then
		dockFrame.config.buttonSpaceH = dockFrame.config.buttonSpaceH + 1;
	else
		dockFrame.config.buttonSpaceH = dockFrame.config.buttonSpaceH - 1;
	end
end

function TrinityBars2.AdjustVSpacing(dockFrame, dir)

	if (dir == "add") then
		dockFrame.config.buttonSpaceV = dockFrame.config.buttonSpaceV + 1;
	else
		dockFrame.config.buttonSpaceV = dockFrame.config.buttonSpaceV - 1;
	end

end

function TrinityBars2.UpdateColumns(dockFrame, action)

	setCurrHeaderShowstate(dockFrame)

	dockFrame.config.shape = 2

	if (action == "add") then

		dockFrame.config["columns"] = dockFrame.config["columns"] + 1;
		if (dockFrame.config["columns"] > dockFrame.buttonCount) then
			dockFrame.config["columns"] = dockFrame.buttonCount;
		end
	else
		dockFrame.config["columns"] = dockFrame.config["columns"] - 1;
		if (dockFrame.config["columns"] < 2) then
			dockFrame.config["columns"] = 2;
		end
	end

end

function TrinityBars2.UpdateArcStart(dockFrame, dir)

	if (dir == "add") then
		dockFrame.config["arcstart"] = dockFrame.config["arcstart"] + 1;
		if (dockFrame.config["arcstart"] > 359) then
			dockFrame.config["arcstart"] = 0;
		end
	else
		dockFrame.config["arcstart"] = dockFrame.config["arcstart"] - 1;
		if (dockFrame.config["arcstart"] < 0) then
			dockFrame.config["arcstart"] = 359;
		end
	end

end

function TrinityBars2.UpdateArcLength(dockFrame, dir)

	if (dir == "add") then
		dockFrame.config["arclength"] = dockFrame.config["arclength"] + 1;
		if (dockFrame.config["arclength"] > 359) then
			dockFrame.config["arclength"] = 0;
		end
	else
		dockFrame.config["arclength"] = dockFrame.config["arclength"] - 1;
		if (dockFrame.config["arclength"] < 0) then
			dockFrame.config["arclength"] = 359;
		end
	end
end

-- arcPresets = { { "Top Arc", 173, 180 }, { "Bottom Arc", 353, 180 }, { "Left Arc", 262, 180 }, { "Right Arc", 82, 180 } }

function TrinityBars2.SetArcPreset(dockFrame, data)

	if (data == "add" or data == "subtract") then

		local index = 0

		for k,v in pairs(arcPresets) do
			if (v[2] == dockFrame.config.arcstart) then
				index = k
				break
			end
		end

		if (data == "add") then

			index = index + 1

			if (index > #arcPresets) then
				index = 1
			end
		else

			index = index - 1

			if (index < 1) then
				index = #arcPresets
			end
		end

		dockFrame.config.arcstart = arcPresets[index][2]
		dockFrame.config.arclength = arcPresets[index][3]

	else
		if (data == TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1_1) then

			dockFrame.config.arcstart = 173
			dockFrame.config.arclength = 180

		elseif (data == TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1_2) then

			dockFrame.config.arcstart = 353
			dockFrame.config.arclength = 180

		elseif (data == TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1_3) then

			dockFrame.config.arcstart = 262
			dockFrame.config.arclength = 180

		elseif (data == TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1_4) then

			dockFrame.config.arcstart = 82
			dockFrame.config.arclength = 180

		elseif (data == TRINITYBARS2_STRINGS.DOCK_FEEDBACK_1_5) then

			dockFrame.config.arcstart = 90
			dockFrame.config.arclength = 359
		end
	end
end

function TrinityBars2.UpdateCDTextNormColor(dockFrame, r, g, b)

	local buttonList = {}

	dockFrame.config.cdcolornorm = { r, g, b }

	for key, value in pairs(dockFrame.headers) do
		if (dockFrame.headers[key].active) then
			for k,v in pairs(dockFrame.headers[key].list) do

				clearTable(buttonList)

				if (v and v ~= "") then
					gsub(v, "%d+", function (btn) table.insert(buttonList, btn) end)
					for kk,vv in pairs(buttonList) do
						button = _G[dockFrame.config.btnType..vv]
						button.elapsed = 0.2
						button.cdcolornorm = { r, g, b }

						if (not button.config.homedock) then
							if (button.config.type == "action") then
								updateActionCooldown_OnEvent(button, true, 1, button.config.action)
							elseif (button.config.type == "spell") then
								updateSpellCooldown_OnEvent(button, true, button.config.spell)
							elseif (button.config.type == "macro") then
								updateMacroCooldown_OnEvent(button, true)
							elseif (button.config.type == "item") then
								updateItemCooldown_OnEvent(button, true, button.config.itemlink)
							elseif (button.config.type == "slot") then
								updateSlotCooldown_OnEvent(button, true, button.config.item)
							end
						end
					end
				end
			end
		end
	end
end

function TrinityBars2.UpdateCDTextLargeColor(dockFrame, r, g, b)

	local buttonList = {}

	dockFrame.config.cdcolorlarge = { r, g, b }

	for key, value in pairs(dockFrame.headers) do
		if (dockFrame.headers[key].active) then
			for k,v in pairs(dockFrame.headers[key].list) do

				clearTable(buttonList)

				if (v and v ~= "") then
					gsub(v, "%d+", function (btn) table.insert(buttonList, btn) end)
					for kk,vv in pairs(buttonList) do
						button = _G[dockFrame.config.btnType..vv]
						button.elapsed = 0.2
						button.cdcolorlarge = { r, g, b }

						if (not button.config.homedock) then
							if (button.config.type == "action") then
								updateActionCooldown_OnEvent(button, true, 1, button.config.action)
							elseif (button.config.type == "spell") then
								updateSpellCooldown_OnEvent(button, true, button.config.spell)
							elseif (button.config.type == "macro") then
								updateMacroCooldown_OnEvent(button, true)
							elseif (button.config.type == "item") then
								updateItemCooldown_OnEvent(button, true, button.config.itemlink)
							elseif (button.config.type == "slot") then
								updateSlotCooldown_OnEvent(button, true, button.config.item)
							end
						end
					end
				end
			end
		end
	end
end

function TrinityBars2.UpdateBDTextNormColor(dockFrame, r, g, b)

	local buttonList = {}

	dockFrame.config.bdcolornorm = { r, g, b }

	for key, value in pairs(dockFrame.headers) do
		if (dockFrame.headers[key].active) then
			for k,v in pairs(dockFrame.headers[key].list) do

				clearTable(buttonList)

				if (v and v ~= "") then
					gsub(v, "%d+", function (btn) table.insert(buttonList, btn) end)
					for kk,vv in pairs(buttonList) do
						button = _G[dockFrame.config.btnType..vv]
						button.elapsed = 0.2
						button.bdcolornorm = { r, g, b }
					end
				end
			end
		end
	end
end

function TrinityBars2.UpdateBDTextLargeColor(dockFrame, r, g, b)

	local buttonList = {}

	dockFrame.config.bdcolorlarge = { r, g, b }

	for key, value in pairs(dockFrame.headers) do
		if (dockFrame.headers[key].active) then
			for k,v in pairs(dockFrame.headers[key].list) do

				clearTable(buttonList)

				if (v and v ~= "") then
					gsub(v, "%d+", function (btn) table.insert(buttonList, btn) end)
					for kk,vv in pairs(buttonList) do
						button = _G[dockFrame.config.btnType..vv]
						button.elapsed = 0.2
						button.bdcolorlarge = { r, g, b }
					end
				end
			end
		end
	end
end

function TrinityBars2.UpdateBuffColor(dockFrame, r, g, b)

	local buttonList = {}

	dockFrame.config.buffcolor = { r, g, b }

	for key, value in pairs(dockFrame.headers) do
		if (dockFrame.headers[key].active) then
			for k,v in pairs(dockFrame.headers[key].list) do

				clearTable(buttonList)

				if (v and v ~= "") then
					gsub(v, "%d+", function (btn) table.insert(buttonList, btn) end)
					for kk,vv in pairs(buttonList) do
						button = _G[dockFrame.config.btnType..vv]
						button.elapsed = 0.2
						button.buffcolor = { r, g, b }

						if (not button.config.homedock) then
							updateBuffup_OnEvent(button, "player", button.config.spell)
							updateBuffup_OnEvent(button, "target", button.config.spell)
						end
					end
				end
			end
		end
	end
end

function TrinityBars2.UpdateDebuffColor(dockFrame, r, g, b)

	local buttonList = {}

	dockFrame.config.debuffcolor = { r, g, b }

	for key, value in pairs(dockFrame.headers) do
		if (dockFrame.headers[key].active) then
			for k,v in pairs(dockFrame.headers[key].list) do

				clearTable(buttonList)

				if (v and v ~= "") then
					gsub(v, "%d+", function (btn) table.insert(buttonList, btn) end)
					for kk,vv in pairs(buttonList) do
						button = _G[dockFrame.config.btnType..vv]
						button.elapsed = 0.2
						button.debuffcolor = { r, g, b }
					end
				end
			end
		end
	end
end

function TrinityBars2.UpdateRangeColor(dockFrame, r, g, b)

	local buttonList = {}

	dockFrame.config.rangecolor = { r, g, b }

	for key, value in pairs(dockFrame.headers) do
		if (dockFrame.headers[key].active) then
			for k,v in pairs(dockFrame.headers[key].list) do

				clearTable(buttonList)

				if (v and v ~= "") then
					gsub(v, "%d+", function (btn) table.insert(buttonList, btn) end)
					for kk,vv in pairs(buttonList) do
						button = _G[dockFrame.config.btnType..vv]
						button.elapsed = 0.2
						button.rangecolor = { r, g, b }
					end
				end
			end
		end
	end
end

function TrinityBars2.UpdateManaColor(dockFrame, r, g, b)

	dockFrame.config.manacolor = { r, g, b }

	local buttonList = {}
	local button, btn

	for key, value in pairs(dockFrame.headers) do
		if (dockFrame.headers[key].active) then
			for k,v in pairs(dockFrame.headers[key].list) do

				clearTable(buttonList)

				if (v and v ~= "") then
					gsub(v, "%d+", function (btn) table.insert(buttonList, btn) end)
					for kk,vv in pairs(buttonList) do
						button = _G[dockFrame.config.btnType..vv]
						button.elapsed = 0.2
						button.manacolor = { r, g, b }
					end
				end
			end
		end
	end
end

function TrinityBars2.UpdateButtonSkinColor(dockFrame, r, g, b)

	dockFrame.config.skincolor = { r, g, b }

	local buttonList = {}
	local button, element, btn, texture

	for key, value in pairs(dockFrame.headers) do
		if (dockFrame.headers[key].active) then
			for k,v in pairs(dockFrame.headers[key].list) do

				clearTable(buttonList)

				if (v and v ~= "") then
					gsub(v, "%d+", function (btn) table.insert(buttonList, btn) end)
					for kk,vv in pairs(buttonList) do

						if (dockFrame == dedBars.docks["bag"]) then

							button = _G[dockFrame.config.btnType..vv]
							button.skincolor = { r, g, b }

							if (button.config.element and button.config.element ~= "") then

								element = _G[button.config.element]

								texture = _G[element:GetName().."TrinityNormalTexture"]

								if (texture) then
									texture:SetVertexColor(button.skincolor[1],button.skincolor[2],button.skincolor[3], 1)
								else
									texture = _G[element:GetName().."NormalTexture"]

									if (texture) then
										texture:SetVertexColor(button.skincolor[1],button.skincolor[2],button.skincolor[3], 1)
									end
								end
							end

						else

							button = _G[dockFrame.config.btnType..vv]
							button.skincolor = { r, g, b }

							if (button.normaltexture) then
								button.normaltexture:SetVertexColor(button.skincolor[1],button.skincolor[2],button.skincolor[3], 1)
							end

							if (button.pushedtexture) then
								button.pushedtexture:SetVertexColor(button.skincolor[1],button.skincolor[2],button.skincolor[3], 1)
							end
						end
					end
				end
			end
		end
	end
end

function TrinityBars2.UpdateButtonHoverColor(dockFrame, r, g, b)

	dockFrame.config.hovercolor = { r, g, b }

	local buttonList = {}
	local button, element, btn, texture

	for key, value in pairs(dockFrame.headers) do
		if (dockFrame.headers[key].active) then
			for k,v in pairs(dockFrame.headers[key].list) do

				clearTable(buttonList)

				if (v and v ~= "") then
					gsub(v, "%d+", function (btn) table.insert(buttonList, btn) end)
					for kk,vv in pairs(buttonList) do

						if (dockFrame == dedBars.docks["bag"]) then

							button = _G[dockFrame.config.btnType..vv]
							button.hovercolor = { r, g, b }

							if (button.config.element and button.config.element ~= "") then

								element = _G[button.config.element]

								--texture = _G[element:GetName().."TrinityNormalTexture")
								--texture:SetVertexColor(button.skincolor[1],button.skincolor[2],button.skincolor[3], 1)
							end

						else

							button = _G[dockFrame.config.btnType..vv]
							button.hovercolor = { r, g, b }

							if (button.highlighttexture) then
								button.highlighttexture:SetVertexColor(button.hovercolor[1],button.hovercolor[2],button.hovercolor[3], 1)
							end
						end
					end
				end
			end
		end
	end
end

function TrinityBars2.UpdateButtonEquipColor(dockFrame, r, g, b)

	dockFrame.config.equipcolor = { r, g, b }

	local buttonList = {}
	local button, element, btn, texture

	for key, value in pairs(dockFrame.headers) do
		if (dockFrame.headers[key].active) then
			for k,v in pairs(dockFrame.headers[key].list) do

				clearTable(buttonList)

				if (v and v ~= "") then
					gsub(v, "%d+", function (btn) table.insert(buttonList, btn) end)
					for kk,vv in pairs(buttonList) do

						if (dockFrame == dedBars.docks["bag"]) then

							button = _G[dockFrame.config.btnType..vv]
							button.equipcolor = { r, g, b }

							if (button.config.element and button.config.element ~= "") then

								element = _G[button.config.element]

								--texture = _G[element:GetName().."TrinityNormalTexture")
								--texture:SetVertexColor(button.skincolor[1],button.skincolor[2],button.skincolor[3], 1)
							end

						else

							button = _G[dockFrame.config.btnType..vv]
							button.equipcolor = { r, g, b }

							if (button.border) then
								button.border:SetVertexColor(button.equipcolor[1],button.equipcolor[2],button.equipcolor[3], 1)
							end
						end
					end
				end
			end
		end
	end
end

function TrinityBars2.ButtonSelect(dockFrame, dir)

	if (dir == "add") then
		dockFrame.config["buttonEdit"] = dockFrame.config["buttonEdit"] + 1;
		if (dockFrame.config["buttonEdit"] > dockFrame.buttonCount) then
			dockFrame.config["buttonEdit"] = 1;
		end
	else
		dockFrame.config["buttonEdit"] = dockFrame.config["buttonEdit"] - 1;
		if (dockFrame.config["buttonEdit"] < 1) then
			dockFrame.config["buttonEdit"] = dockFrame.buttonCount;
		end
	end
end

function TrinityBars2.ButtonCount(dockFrame, dir)

	if (dir == "add") then
		TrinityBars2.AddButton(dockFrame, true)
	else
		if (IsAltKeyDown()) then
			TrinityBars2.SubtractButton(dockFrame, true)
		else
			TrinityBars2.SubtractButton(dockFrame)
		end
	end
end

function TrinityBars2.AddButton(dockFrame, msg)

	local newButton = 0;

	if (dockFrame.config.stored) then
		return
	end

	setCurrHeaderShowstate(dockFrame)

	if (dockFrame.config.btnType == "TrinityActionButton") then
		for k,v in pairs(TrinityBars2Options_Storage.data["buttonIndex"]) do
			if (v == 1 and newButton == 0) then
				newButton = k
				break
			end
		end
	elseif (dockFrame.config.btnType == "TrinityPetButton") then
		for k,v in pairs(TrinityBars2Options_Storage.data["petButtonIndex"]) do
			if (v == 1 and newButton == 0) then
				newButton = k
				break
			end
		end
	elseif (dockFrame.config.btnType == "TrinityClassButton") then
		for k,v in pairs(TrinityBars2Options_Storage.data["classButtonIndex"]) do
			if (v == 1 and newButton == 0) then
				newButton = k
				break
			end
		end
	elseif (dockFrame.config.btnType == "TrinityBagButton") then
		for k,v in pairs(TrinityBars2Options_Storage.data["bagButtonIndex"]) do
			if (v == 1 and newButton == 0) then
				newButton = k
			end
			if (v == 1 and k > newButton) then
				newButton = k
			end
		end
	elseif (dockFrame.config.btnType == "TrinityMenuButton") then
		for k,v in pairs(TrinityBars2Options_Storage.data["menuButtonIndex"]) do
			if (v == 1 and newButton == 0) then
				newButton = k
				break
			end
		end
	elseif (dockFrame.config.btnType == "TrinityMainMenuButton") then
		if (not string.find(dockFrame.headers[dockFrame.activeHeader]["list"][dockFrame.showstate], "1")) then
			newButton = 1
			MainMenuBar:Show()
		end
	end

	if (newButton ~= 0) then

		button = _G[dockFrame.config.btnType..newButton]
		button.config.dock = dockFrame:GetID()
		button.config.anchoredheader = dockFrame.headers.Normal.name
		button.config.showstate = dockFrame.showstate;
		button.config.stored = false
		button.dockFrame = dockFrame
		button:SetAttribute("showstates", dockFrame.showstate)

		updateButtonData(dockFrame, button)

		_G[dockFrame.headers[dockFrame.activeHeader]["name"]]:SetAttribute("addchild", button)

		if (not dockFrame.headers[dockFrame.activeHeader]["list"][dockFrame.showstate] or dockFrame.headers[dockFrame.activeHeader]["list"][dockFrame.showstate] == "") then
			dockFrame.headers[dockFrame.activeHeader]["list"][dockFrame.showstate] = ","..button.id..",";
		else
			if (dockFrame.config.btnType == "TrinityBagButton") then
				dockFrame.headers[dockFrame.activeHeader]["list"][dockFrame.showstate] = ","..button.id..dockFrame.headers[dockFrame.activeHeader]["list"][dockFrame.showstate]
			else
				dockFrame.headers[dockFrame.activeHeader]["list"][dockFrame.showstate] = dockFrame.headers[dockFrame.activeHeader]["list"][dockFrame.showstate]..button.id..","
			end
		end

		if (dockFrame.config.btnType == "TrinityActionButton") then
			TrinityBars2Options_Storage.data["buttonIndex"][tonumber(newButton)] = 0
		elseif (dockFrame.config.btnType == "TrinityPetButton") then
			TrinityBars2Options_Storage.data["petButtonIndex"][tonumber(newButton)] = 0
		elseif (dockFrame.config.btnType == "TrinityClassButton") then
			TrinityBars2Options_Storage.data["classButtonIndex"][tonumber(newButton)] = 0
		elseif (dockFrame.config.btnType == "TrinityBagButton") then
			TrinityBars2Options_Storage.data["bagButtonIndex"][tonumber(newButton)] = 0
			setMainMenuBarBackpackButton(dockFrame.buttonCount + 1)
		elseif (dockFrame.config.btnType == "TrinityMenuButton") then
			TrinityBars2Options_Storage.data["menuButtonIndex"][tonumber(newButton)] = 0
		end

		TrinityBars2.SwapTextures(dockFrame, dockIndex)

		updateStorageDocking()

		return

	elseif (dockFrame.config.btnType == "TrinityActionButton") then

		local button
		local index = 1
		local made = false

		while not made do

			if (not _G["TrinityActionButton"..index]) then
				button = createActionButton(index)
				TrinityBars2.SetButtonType(button)
				made = true
			end

			index = index + 1
		end

		if (button) then

			button.config.dock = dockFrame:GetID()
			button.config.anchoredheader = dockFrame.headers.Normal.name
			button.config.showstate = dockFrame.showstate
			button.dockFrame = dockFrame
			button:SetAttribute("showstates", dockFrame.showstate)

			_G[dockFrame.headers[dockFrame.activeHeader]["name"]]:SetAttribute("addchild", button)

			if (not dockFrame.headers[dockFrame.activeHeader]["list"][dockFrame.showstate] or dockFrame.headers[dockFrame.activeHeader]["list"][dockFrame.showstate] == "") then
				dockFrame.headers[dockFrame.activeHeader]["list"][dockFrame.showstate] = ","..button.id..",";
			else
				dockFrame.headers[dockFrame.activeHeader]["list"][dockFrame.showstate] = dockFrame.headers[dockFrame.activeHeader]["list"][dockFrame.showstate]..button.id..","
			end

			if (TrinityBars2KeyBinder:IsVisible() or TrinityBars2SimpleKeyBinder:IsVisible()) then
				button.bindframe:Show()
			end

			if (TrinityBars2SavedState.registerForClicks == "down") then
				button:RegisterForClicks("AnyDown")
			else
				button:RegisterForClicks("AnyUp")
			end
		end

		TrinityBars2.SwapTextures(dockFrame, dockIndex)

		updateStorageDocking()

		return
	end

	if (msg) then

		if (dockFrame.config.btnType == "TrinityActionButton") then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.STORED_EMPTY_ACTION, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
		elseif (dockFrame.config.btnType == "TrinityPetButton") then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.STORED_EMPTY_PET, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
		elseif (dockFrame.config.btnType == "TrinityClassButton") then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.STORED_EMPTY_CLASS, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
		elseif (dockFrame.config.btnType == "TrinityBagButton") then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.STORED_EMPTY_BAG, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
		elseif (dockFrame.config.btnType == "TrinityMenuButton") then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.STORED_EMPTY_MENU, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
		elseif (dockFrame.config.btnType == "TrinityMainMenuButton") then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.STORED_EMPTY_MAIN, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
		end
	end
end

function TrinityBars2.SubtractButton(dockFrame, all, removeButton)

	local count = 1
	local button, index

	setCurrHeaderShowstate(dockFrame)

	if (dockFrame.buttonCount < 1) then
		return
	end

	if (all) then
		count = dockFrame.buttonCount
	end

	if (dockFrame.config.btnType == "TrinityActionButton" and TrinityBars2Options_Storage.data["buttonCount"] > 161) then
		Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.STORED_FULL, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		return
	end

	for i=1,count do

		if (dockFrame.config.btnType == "TrinityActionButton" and TrinityBars2Options_Storage.data.buttonCount > 97) then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.STORED_FULL, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
			return
		end

		if (removeButton) then
			button = removeButton
			index = removeButton.id
		else

			if (dockFrame.config.btnType == "TrinityBagButton" and count == 1) then
				button = _G["TrinityBagButton"..dockFrame.buttonList[i]]
				index = dockFrame.buttonList[i]
			else
				button = _G[dockFrame.config.btnType..dockFrame.buttonList[#dockFrame.buttonList]]
				index = dockFrame.buttonList[#dockFrame.buttonList]
			end
		end

		button:ClearAllPoints()

		button.config["dock"] = 0
		button.config["dockpos"] = 0
		button.config.scale = 1
		button.config["XOffset"] = 0
		button.config["YOffset"] = 0
		button.config["target"] = "none"
		button.config["stored"] = true

		button:SetParent("TrinityBars2Options_Storage")
		button:SetFrameStrata("DIALOG")
		button:SetFrameLevel(4)
		if (button.iconframe) then
			button.iconframe:SetFrameLevel(2)
		end
		if (button.iconframecooldown) then
			button.iconframecooldown:SetFrameLevel(3)
		end
		if (button.iconframebuffup) then
			button.iconframebuffup:SetFrameLevel(3)
		end
		button:SetScale(0.72)

		dockFrame.headers[dockFrame.activeHeader]["list"][dockFrame.showstate] = gsub(dockFrame.headers[dockFrame.activeHeader]["list"][dockFrame.showstate], "(%D)"..index..",", "%1")

		if (dockFrame.config.btnType == "TrinityActionButton") then
			TrinityBars2Options_Storage.data["buttonIndex"][tonumber(index)] = 1;
			setDefaultButtonSkin(button)
		elseif (dockFrame.config.btnType == "TrinityPetButton") then
			TrinityBars2Options_Storage.data["petButtonIndex"][tonumber(index)] = 1;
			setDefaultButtonSkin(button)
		elseif (dockFrame.config.btnType == "TrinityClassButton") then
			TrinityBars2Options_Storage.data["classButtonIndex"][tonumber(index)] = 1;
			if (dockFrame.buttonCount == 1) then
				checkButtons[102] = nil
				TrinityBars2OptionsCheck102:SetChecked(nil)
			end
			setDefaultButtonSkin(button)
		elseif (dockFrame.config.btnType == "TrinityBagButton") then
			TrinityBars2Options_Storage.data["bagButtonIndex"][tonumber(index)] = 1;
		elseif (dockFrame.config.btnType == "TrinityMenuButton") then
			TrinityBars2Options_Storage.data["menuButtonIndex"][tonumber(index)] = 1;
		end

		if (dockFrame.config.btnType == "TrinityBagButton" and count == 1) then

			dockFrame.buttonList[1] = nil
			setMainMenuBarBackpackButton(dockFrame.buttonCount-1)

 		else

			if (removeButton) then
				for k,v in pairs(dockFrame.buttonList) do
					if (v == index) then
						dockFrame.buttonList[k] = nil
					end
				end
				TrinityBars2ButtonEditSelect:Hide()
			else
				dockFrame.buttonList[#dockFrame.buttonList] = nil;
			end
		end

		--TrinityBars2.UpdateTargeting(dockFrame)
	end

	updateStorageDocking()
end

function TrinityBars2.CreateButton()

	local button
	local index = 1
	local made = false

	if (TrinityBars2Options_Storage.data.buttonCount > 97) then
		Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.STORED_FULL, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		return
	end

	while not made do

		if (not _G["TrinityActionButton"..index]) then
			button = createActionButton(index)
			TrinityBars2.SetButtonType(button)
			made = true
		end

		index = index + 1
	end

	if (button) then

		button.config["dock"] = 0
		button.config["dockpos"] = 0
		button.config.scale = 1
		button.config["XOffset"] = 0
		button.config["YOffset"] = 0
		button.config["target"] = "none"
		button.config["stored"] = true

		button:SetParent("TrinityBars2Options_Storage")
		button:SetFrameStrata("DIALOG")
		button:SetFrameLevel(4)
		button.iconframe:SetFrameLevel(2)
		button.iconframecooldown:SetFrameLevel(3)
		button.iconframebuffup:SetFrameLevel(3)

		button:SetScale(0.72)

		TrinityBars2Options_Storage.data["buttonIndex"][tonumber(button.id)] = 1
		setDefaultButtonSkin(button)

		if (TrinityBars2KeyBinder:IsVisible() or TrinityBars2SimpleKeyBinder:IsVisible()) then
			button.bindframe:Show()
		end

		updateStorageDocking()
	end

	return
end

function TrinityBars2.DeleteButton()

	local lastButton, found = 0, false

	for k,v in pairs(TrinityBars2Options_Storage.data["buttonIndex"]) do
		if (v == 1 and k ~= 0) then
			if (k > lastButton) then
				lastButton = k
				found = true
			end
		end
	end

	if (found) then

		TrinityBars2Options_Storage.data.buttonCount = TrinityBars2Options_Storage.data.buttonCount - 1
		TrinityBars2Options_Storage.data.buttonIndex[lastButton] = nil

		buttonIndex[lastButton] = nil

		lastButton = _G["TrinityActionButton"..lastButton]
		lastButton.config = nil

		lastButton:ClearAllPoints()
		lastButton:SetParent("UIParent")
		lastButton:Hide()

		saveCurrentState()

		if (not override) then
			Trinity2MessageFrame:AddMessage(lastButton:GetName()..TRINITYBARS2_STRINGS.STORED_DELETED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		end
	else
		Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.STORED_ALL_DELETED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
	end

end

function TrinityBars2.ButtonLockToggle(login)

	if (checkButtons[201]) then

		TrinityBars2SavedState.buttonLock = true

		LOCK_ACTIONBAR = "1"

		_G[Trinity2.RegisteredAddons[TrinityBars2Options.index][5].."Icon"]:SetTexture("Interface\\Addons\\TrinityBars2\\images\\locked2.tga")

		if (not login) then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.BUTTONS_LOCKED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		end
	else

		TrinityBars2SavedState.buttonLock = false

		LOCK_ACTIONBAR = "0"

		_G[Trinity2.RegisteredAddons[TrinityBars2Options.index][5].."Icon"]:SetTexture("Interface\\Addons\\TrinityBars2\\images\\unlocked3.tga")

		if (not login) then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.BUTTONS_UNLOCKED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		end
	end
end

function TrinityBars2.ButtonLockMinimapToggle()

	if (TrinityBars2SavedState.buttonLock) then

		TrinityBars2SavedState.buttonLock = false;
		TrinityBars2OptionsCheck201:SetChecked(nil)
		TrinityBars2.SetCheckButtonOption_OnClick(TrinityBars2OptionsCheck201)

		LOCK_ACTIONBAR = "0"

		_G[Trinity2.RegisteredAddons[TrinityBars2Options.index][5].."Icon"]:SetTexture("Interface\\Addons\\TrinityBars2\\images\\unlocked3.tga")

		Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.BUTTONS_UNLOCKED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)

	else

		TrinityBars2SavedState.buttonLock = true;
		TrinityBars2OptionsCheck201:SetChecked(1)
		TrinityBars2.SetCheckButtonOption_OnClick(TrinityBars2OptionsCheck201)

		LOCK_ACTIONBAR = "1"

		_G[Trinity2.RegisteredAddons[TrinityBars2Options.index][5].."Icon"]:SetTexture("Interface\\Addons\\TrinityBars2\\images\\locked2.tga")

		Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.BUTTONS_LOCKED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
	end

end

function TrinityBars2.ButtonModifierDragToggle(self)

	if (self) then
		for i=202,204 do
			if (i ~= self:GetID()) then
				_G["TrinityBars2OptionsCheck"..i]:SetChecked(nil)
				TrinityBars2.SetCheckButtonOption_OnClick(_G["TrinityBars2OptionsCheck"..i])
			end
		end
	end

	if (checkButtons[202]) then
		TrinityBars2SavedState.modifierButtonLock = 1;
		if (not login) then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.BUTTON_SHIFT_LOCK, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		end
	elseif (checkButtons[203]) then
		TrinityBars2SavedState.modifierButtonLock = 2;
		if (not login) then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.BUTTON_CTRL_LOCK, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		end
	elseif (checkButtons[204]) then
		TrinityBars2SavedState.modifierButtonLock = 3;
		if (not login) then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.BUTTON_ALT_LOCK, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		end
	else
		TrinityBars2SavedState.modifierButtonLock = 0;
		if (not login) then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.BUTTON_NOMOD_LOCK, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		end
	end

end

function TrinityBars2.SetSelfCast(option)

	local dockFrame, header

	TrinityBars2SavedState.selfCastOption = option;

	for k,dockFrame in pairs(dockIndex) do

		header = _G[dockFrame.headers.Normal.name]

		if (option == 1 or option ~= 2) then
			--header:SetAttribute("alt-unit2", nil)
			--header:SetAttribute("ctrl-unit2", nil)
			--header:SetAttribute("shift-unit2", nil)
			header:SetAttribute("unit2", nil)
		end
		if (option == 2) then
			--header:SetAttribute("alt-unit2", "player")
			--header:SetAttribute("ctrl-unit2", "player")
			--header:SetAttribute("shift-unit2", "player")
			header:SetAttribute("unit2", "player")
		end
		if (option == 1 or option ~= 3) then
			header:SetAttribute("alt-unit*", nil)
		end
		if (option == 3) then
			header:SetAttribute("alt-unit*", "player")
		end
		if (option == 1 or option ~= 4) then
			header:SetAttribute("ctrl-unit*", nil)
		end
		if (option == 4) then
			header:SetAttribute("ctrl-unit*", "player")
		end
		if (option == 1 or option ~= 5) then
			header:SetAttribute("shift-unit*", nil)
		end
		if (option == 5) then
			header:SetAttribute("shift-unit*", "player")
		end
	end


	--[[
	if (option == 1 or option ~= 2) then
		TrinityBars2Options:SetAttribute("alt-unit2", nil)
		TrinityBars2Options:SetAttribute("ctrl-unit2", nil)
		TrinityBars2Options:SetAttribute("shift-unit2", nil)
		TrinityBars2Options:SetAttribute("unit2", nil)
	end
	if (option == 2) then
		TrinityBars2Options:SetAttribute("alt-unit2", "player")
		TrinityBars2Options:SetAttribute("ctrl-unit2", "player")
		TrinityBars2Options:SetAttribute("shift-unit2", "player")
		TrinityBars2Options:SetAttribute("unit2", "player")
	end
	if (option == 1 or option ~= 3) then
		TrinityBars2Options:SetAttribute("alt-unit*", nil)
	end
	if (option == 3) then
		TrinityBars2Options:SetAttribute("alt-unit*", "player")
	end
	if (option == 1 or option ~= 4) then
		TrinityBars2Options:SetAttribute("ctrl-unit*", nil)
	end
	if (option == 4) then
		TrinityBars2Options:SetAttribute("ctrl-unit*", "player")
	end
	if (option == 1 or option ~= 5) then
		TrinityBars2Options:SetAttribute("shift-unit*", nil)
	end
	if (option == 5) then
		TrinityBars2Options:SetAttribute("shift-unit*", "player")
	end
	--]]
end

function TrinityBars2.ToggleBattleBar(self, dockFrame)
	if (self:GetChecked()) then
		dockFrame.config["battle"] = true
		dockFrame.config["retreat"] = false
		dockFrame.config["pvp"] = false
		dockFrame.config["pve"] = false
	else
		dockFrame.config["battle"] = false
	end

	TrinityBars2.SetBattleBar(dockFrame)
end

function TrinityBars2.ToggleRetreatBar(self, dockFrame)
	if (self:GetChecked()) then
		dockFrame.config["retreat"] = true
		dockFrame.config["battle"] = false
		dockFrame.config["pvp"] = false
		dockFrame.config["pve"] = false
	else
		dockFrame.config["retreat"] = false
	end

	TrinityBars2.SetRetreatBar(dockFrame)
end

function TrinityBars2.TogglePartyBar(self, dockFrame)
	if (self:GetChecked()) then
		dockFrame.config["party"] = true
		dockFrame.config["raid"] = false
	else
		dockFrame.config["party"] = false
	end

	TrinityBars2.SetPartyBar(dockFrame)
end

function TrinityBars2.ToggleRaidBar(self, dockFrame)
	if (self:GetChecked()) then
		dockFrame.config["raid"] = true
		dockFrame.config["party"] = false
	else
		dockFrame.config["raid"] = false
	end

	TrinityBars2.SetRaidBar(dockFrame)
end

function TrinityBars2.TogglePvPBar(self, dockFrame)
	if (self:GetChecked()) then
		dockFrame.config["pvp"] = true
		dockFrame.config["battle"] = false
		dockFrame.config["retreat"] = false
		dockFrame.config["pve"] = false
	else
		dockFrame.config["pvp"] = false
	end

	TrinityBars2.SetPvPBar(dockFrame)
end

function TrinityBars2.TogglePvEBar(self, dockFrame)
	if (self:GetChecked()) then
		dockFrame.config["pve"] = true
		dockFrame.config["battle"] = false
		dockFrame.config["retreat"] = false
		dockFrame.config["pvp"] = false
	else
		dockFrame.config["pve"] = false
	end

	TrinityBars2.SetPvEBar(dockFrame)
end

function TrinityBars2.ToggleHelpHarmBar(self, dockFrame)
	if (self:GetChecked()) then
		dockFrame.config["reaction"] = true
	else
		dockFrame.config["reaction"] = false
	end

	TrinityBars2.SetHelpHarmBar(dockFrame)
end

function TrinityBars2.ToggleAltBar(self, dockFrame)
	if (self:GetChecked()) then
		dockFrame.config["alt"] = true
	else
		dockFrame.config["alt"] = false
	end

	TrinityBars2.SetAltBar(dockFrame)
end

function TrinityBars2.ToggleCtrlBar(self, dockFrame)
	if (self:GetChecked()) then
		dockFrame.config["control"] = true
	else
		dockFrame.config["control"] = false
	end

	TrinityBars2.SetCtrlBar(dockFrame)
end

function TrinityBars2.ToggleShiftBar(self, dockFrame)
	if (self:GetChecked()) then
		dockFrame.config["shift"] = true
	else
		dockFrame.config["shift"] = false
	end

	TrinityBars2.SetShiftBar(dockFrame)
end

function TrinityBars2.ToggleStealthBar(self, dockFrame)
	if (self:GetChecked()) then
		dockFrame.config["stealth"] = true
	else
		dockFrame.config["stealth"] = false
	end

	TrinityBars2.SetStealthBar(dockFrame)
end

function TrinityBars2.TogglePagedBar(self, dockFrame)
	if (self:GetChecked()) then
		dockFrame.config["paged"] = true
	else
		dockFrame.config["paged"] = false
	end

	TrinityBars2.SetPagedBar(dockFrame)
end

function TrinityBars2.ToggleStanceBar(self, dockFrame)
	if (self:GetChecked()) then
		dockFrame.config["stance"] = true
	else
		dockFrame.config["stance"] = false
		dockFrame.config["prowl"] = false
	end

	TrinityBars2.SetStanceBar(dockFrame)
end

function TrinityBars2.ToggleProwlBar(self, dockFrame)

	if (TrinityBars2SavedState.classBar["Cat Form"] == "NOTKNOWN") then
		self:SetChecked(nil)
		dockFrame.config["prowl"] = false
		return
	end

	if (self:GetChecked()) then
		dockFrame.config["prowl"] = true
	else
		dockFrame.config["prowl"] = false
	end

	TrinityBars2.SetProwlBar(dockFrame)
end

function TrinityBars2.ToggleAutoHide(self, dockFrame)

	if (self:GetChecked()) then
		dockFrame.config["autohide"] = true
		if (not Trinity2.configMode) then
			_G[dockFrame.headers.Normal.name]:SetAlpha(0)
		end
	else
		dockFrame.config["autohide"] = false
		dockFrame.config["alpha"] = 1;
		_G[dockFrame.headers.Normal.name]:SetAlpha(1)
	end

	TrinityBars2.SetAutohide(dockFrame)
end

function TrinityBars2.ToggleShowGrid(self, dockFrame)

	if (self:GetChecked()) then
		dockFrame.config["showgrid"] = true
	else
		dockFrame.config["showgrid"] = false
	end
end

function TrinityBars2.ToggleSnapToBar(self, dockFrame)

	if (self:GetChecked()) then
		dockFrame.config["snapto"] = true
	else
		dockFrame.config["snapto"] = false
	end
end

function TrinityBars2.TogglePossessionBar(self, dockFrame)

	if (self:GetChecked()) then
		dockFrame.config["possession"] = true
	else
		dockFrame.config["possession"] = false
	end

	TrinityBars2.SetPossessionBar(dockFrame)
end

function TrinityBars2.SetBattleBar(dockFrame)

	local normalHeader = _G[dockFrame.headers.Normal.name]

	if (dockFrame.config["battle"]) then
		TrinityBattleHeader:SetAttribute("addchild", normalHeader)
		normalHeader:SetAttribute("showstates", "0")
		normalHeader:SetAttribute("hidestates", "1")
		dockFrame.headers.Normal.parent = "TrinityBattleHeader"
	else
		if (dockFrame.config["retreat"] == false and
		    dockFrame.config["pvp"] == false and
		    dockFrame.config["pve"] == false and
		    dockFrame.config["party"] == false and
		    dockFrame.config["raid"] == false) then
			normalHeader:SetParent("UIParent")
			normalHeader:SetAttribute("hidestates", nil)
			dockFrame.headers.Normal.parent = "UIParent"
		end
	end

	useStates = false
	setupDockFrameUpdate(dockFrame)
end

function TrinityBars2.SetRetreatBar(dockFrame)

	local normalHeader = _G[dockFrame.headers.Normal.name]

	if (dockFrame.config["retreat"]) then
		TrinityRetreatHeader:SetAttribute("addchild", normalHeader)
		normalHeader:SetAttribute("showstates", "0")
		normalHeader:SetAttribute("hidestates", "1")
		dockFrame.headers.Normal.parent = "TrinityRetreatHeader"
	else
		if (dockFrame.config["battle"] == false and
		    dockFrame.config["pvp"] == false and
		    dockFrame.config["pve"] == false and
		    dockFrame.config["party"] == false and
		    dockFrame.config["raid"] == false) then
			normalHeader:SetParent("UIParent")
			normalHeader:SetAttribute("hidestates", nil)
			dockFrame.headers.Normal.parent = "UIParent"
		end
	end

	useStates = false
	setupDockFrameUpdate(dockFrame)
end

function TrinityBars2.SetPartyBar(dockFrame)

	local normalHeader = _G[dockFrame.headers.Normal.name]

	if (dockFrame.config["party"]) then
		TrinityPartyHeader:SetAttribute("addchild", normalHeader)
		normalHeader:SetAttribute("showstates", "0")
		normalHeader:SetAttribute("hidestates", "1")
		dockFrame.headers.Normal.parent = "TrinityPartyHeader"
	else
		if (dockFrame.config["battle"] == false and
		    dockFrame.config["pvp"] == false and
		    dockFrame.config["pve"] == false and
		    dockFrame.config["retreat"] == false and
		    dockFrame.config["raid"] == false) then
			normalHeader:SetParent("UIParent")
			normalHeader:SetAttribute("hidestates", nil)
			dockFrame.headers.Normal.parent = "UIParent"
		end
	end

	useStates = false
	setupDockFrameUpdate(dockFrame)
end

function TrinityBars2.SetRaidBar(dockFrame)

	local normalHeader = _G[dockFrame.headers.Normal.name]

	if (dockFrame.config["raid"]) then
		TrinityRaidHeader:SetAttribute("addchild", normalHeader)
		normalHeader:SetAttribute("showstates", "0")
		normalHeader:SetAttribute("hidestates", "1")
		dockFrame.headers.Normal.parent = "TrinityRaidHeader"
	else
		if (dockFrame.config["battle"] == false and
		    dockFrame.config["pvp"] == false and
		    dockFrame.config["pve"] == false and
		    dockFrame.config["party"] == false and
		    dockFrame.config["retreat"] == false) then
			normalHeader:SetParent("UIParent")
			normalHeader:SetAttribute("hidestates", nil)
			dockFrame.headers.Normal.parent = "UIParent"
		end
	end

	useStates = false
	setupDockFrameUpdate(dockFrame)
end

function TrinityBars2.SetPvPBar(dockFrame)

	local normalHeader = _G[dockFrame.headers.Normal.name]

	if (dockFrame.config["pvp"]) then
		TrinityPvPHeader:SetAttribute("addchild", normalHeader)
		normalHeader:SetAttribute("showstates", "0")
		dockFrame.headers.Normal.parent = "TrinityPvPHeader"
	else
		if (dockFrame.config["battle"] == false and
		    dockFrame.config["retreat"] == false and
		    dockFrame.config["pve"] == false and
		    dockFrame.config["party"] == false and
		    dockFrame.config["raid"] == false) then
			normalHeader:SetParent("UIParent")
			dockFrame.headers.Normal.parent = "UIParent"
		end
	end

	useStates = false
	setupDockFrameUpdate(dockFrame)

end

function TrinityBars2.SetPvEBar(dockFrame)

	local normalHeader = _G[dockFrame.headers.Normal.name]

	if (dockFrame.config["pve"]) then
		TrinityPvEHeader:SetAttribute("addchild", normalHeader)
		normalHeader:SetAttribute("showstates", "0")
		dockFrame.headers.Normal.parent = "TrinityPvEHeader"
	else
		if (dockFrame.config["battle"] == false and
		    dockFrame.config["pvp"] == false and
		    dockFrame.config["retreat"] == false and
		    dockFrame.config["party"] == false and
		    dockFrame.config["raid"] == false) then
			normalHeader:SetParent("UIParent")
			dockFrame.headers.Normal.parent = "UIParent"
		end
	end

	useStates = false
	setupDockFrameUpdate(dockFrame)

end

function TrinityBars2.SetHelpHarmBar(dockFrame)

	local normalHeader = _G[dockFrame.headers.Normal.name]

	if (dockFrame.config["reaction"]) then
		local harmText = ""
		local helpText = ""
		if (dockFrame.config.target ~= "none") then
			harmText = "[target="..dockFrame.config.target..",harm] 2; 0"
			helpText = "[target="..dockFrame.config.target..",help] 0; 0"
		else
			harmText = "[harm] 2; 0"
			helpText = "[help] 0; 0"
		end
		RegisterStateDriver(normalHeader, "harm", harmText)
		normalHeader:SetAttribute("statemap-harm", "$input")
		normalHeader:SetAttribute("state", normalHeader:GetAttribute("state-harm"))

		RegisterStateDriver(normalHeader, "help", helpText)
		normalHeader:SetAttribute("statemap-help", "$input")
		normalHeader:SetAttribute("state", normalHeader:GetAttribute("state-help"))
	else
		UnregisterStateDriver(normalHeader, "harm")
		normalHeader:SetAttribute("statemap-harm", nil)
		UnregisterStateDriver(normalHeader, "help")
		normalHeader:SetAttribute("statemap-help", nil)
		TrinityBars2.ClearHeaderStates(dockFrame, "Normal", 2, 2)
	end

	useStates = false
	setupDockFrameUpdate(dockFrame)
end

function TrinityBars2.SetAltBar(dockFrame)

	local normalHeader = _G[dockFrame.headers.Normal.name]

	if (dockFrame.config["alt"]) then
		RegisterStateDriver(normalHeader, "alt", "[modifier:alt] 3; 0")
		normalHeader:SetAttribute("statemap-alt", "$input")
		--normalHeader:SetAttribute("statemap-alt", "0,1,2,6,7,8,9:set(3);3:pop(0);$input")
	else
		UnregisterStateDriver(normalHeader, "alt")
		normalHeader:SetAttribute("statemap-alt", nil)
		TrinityBars2.ClearHeaderStates(dockFrame, "Normal", 3, 3)
	end

	useStates = false
	setupDockFrameUpdate(dockFrame)
end

function TrinityBars2.SetCtrlBar(dockFrame)

	local normalHeader = _G[dockFrame.headers.Normal.name]

	if (dockFrame.config["control"]) then
		RegisterStateDriver(normalHeader, "ctrl", "[modifier:ctrl] 4; 0")
		normalHeader:SetAttribute("statemap-ctrl", "$input")
		--normalHeader:SetAttribute("statemap-ctrl", "0,1,2,6,7,8,9:set(4);4:pop(0);$input")
	else
		UnregisterStateDriver(normalHeader, "ctrl")
		normalHeader:SetAttribute("statemap-ctrl", nil)
		TrinityBars2.ClearHeaderStates(dockFrame, "Normal", 4, 4)
	end

	useStates = false
	setupDockFrameUpdate(dockFrame)
end

function TrinityBars2.SetShiftBar(dockFrame)

	local normalHeader = _G[dockFrame.headers.Normal.name]

	if (dockFrame.config["shift"]) then
		RegisterStateDriver(normalHeader, "shift", "[modifier:shift] 5; 0")
		normalHeader:SetAttribute("statemap-shift", "$input")
		--normalHeader:SetAttribute("statemap-shift", "0,1,2,6,7,8,9:set(5);5:pop(0);$input")
	else
		UnregisterStateDriver(normalHeader, "shift")
		normalHeader:SetAttribute("statemap-shift", nil)
		TrinityBars2.ClearHeaderStates(dockFrame, "Normal", 5, 5)
	end

	useStates = false
	setupDockFrameUpdate(dockFrame)
end

--[[
function TrinityBars2.SetShiftBar(dockFrame)

	local normalHeader = _G[dockFrame.headers.Normal.name]

	if (dockFrame.config["shift"]) then
		RegisterStateDriver(normalHeader, "shift", "[modifier:shift,modifier:alt] 7;[modifier:shift] 5; 0")
		normalHeader:SetAttribute("statemap-shift", "$input")
	else
		UnregisterStateDriver(normalHeader, "shift")
		normalHeader:SetAttribute("statemap-shift", nil)
		TrinityBars2.ClearHeaderStates(dockFrame, "Normal", 5, 5)
	end

	useStates = false
	setupDockFrameUpdate(dockFrame)
end
]]--

function TrinityBars2.SetStealthBar(dockFrame)

	local normalHeader = _G[dockFrame.headers.Normal.name]

	if (dockFrame.config["stealth"]) then
		RegisterStateDriver(normalHeader, "stealth", "[stealth] 6; 0")
		normalHeader:SetAttribute("statemap-stealth", "$input")
		--normalHeader:SetAttribute("statemap-stealth", "0,1,2,3,4,5,7,8,9:set(6);6:set(0)")
	else
		UnregisterStateDriver(normalHeader, "stealth")
		normalHeader:SetAttribute("statemap-stealth", nil)
		TrinityBars2.ClearHeaderStates(dockFrame, "Normal", 6, 6)
	end

	useStates = false
	setupDockFrameUpdate(dockFrame)
end


function TrinityBars2.SetPagedBar(dockFrame)

	local header
	local buttonList = {};

	if (dockFrame.config["paged"]) then

		if (_G[dockFrame.headers.Actionbar.name]) then
			header = _G[dockFrame.headers.Actionbar.name]
		else
			header = createActionbarHeader(dockFrame)
		end

		if (dockFrame.headers.Stance.active) then
			dockFrame.headers["Stance"]["parent"] = dockFrame.headers.Actionbar.name
			header:SetAttribute("addchild", _G[dockFrame.headers.Stance.name])
			dockFrame.headers["Stance"]["order"] = 2
			_G[dockFrame.headers.Stance.name]:SetAttribute("showstates", 1)
			dockFrame.headers["Stance"]["showstate"] = 1
		else
			gsub(dockFrame.headers.Normal.list[0], "%d+", function (btn) table.insert(buttonList, btn) end)
			for k,v in pairs(buttonList) do
				dockFrame.headers.Actionbar.list[1] = dockFrame.headers.Actionbar.list[1]..v..","
			end
		end
		dockFrame.headers.Normal.list[0] = ","

		dockFrame.headers.Actionbar.active = true
		dockFrame.headers["Actionbar"]["parent"] = dockFrame.headers.Normal.name
		_G[dockFrame.headers.Normal.name]:SetAttribute("addchild", header)
		dockFrame.headers["Actionbar"]["order"] = 1
		header:SetAttribute("showstates", 0)
		dockFrame.headers["Actionbar"]["showstate"] = 0
		header:SetAttribute("useparent-unit*", true)
	else
		if (_G[dockFrame.headers.Actionbar.name]) then
			dockFrame.headers.Actionbar.active = false
			dockFrame.headers["Actionbar"]["parent"] = "UIParent"
			dockFrame.headers["Actionbar"]["showstate"] = ""
			dockFrame.headers["Actionbar"]["order"] = 99
		end

		gsub(dockFrame.headers.Actionbar.list[1], "%d+", function (btn) table.insert(buttonList, btn) end)
		for k,v in pairs(buttonList) do
			dockFrame.headers.Normal.list[0] = dockFrame.headers.Normal.list[0]..v..","
		end
		dockFrame.headers.Actionbar.list[1] = ","

		TrinityBars2.ClearHeaderStates(dockFrame, "Actionbar", dockFrame.headers["Actionbar"]["start"], dockFrame.headers["Actionbar"]["end"])
	end

	updateDocking(dockFrame)
end

function TrinityBars2.SetStanceBar(dockFrame)

	local header
	local buttonList = {};

	if (dockFrame.config["stance"]) then

		if (_G[dockFrame.headers.Stance.name]) then
			header = _G[dockFrame.headers.Stance.name]
		else
			header = createStanceHeader(dockFrame)
		end

		dockFrame.headers.Stance.active = true

		if (dockFrame.headers.Actionbar.active) then

			gsub(dockFrame.headers.Actionbar.list[1], "%d+", function (btn) table.insert(buttonList, btn) end)
			if (UnitClass("player") == TRINITYBARS2_STRINGS.WARRIOR) then
				for k,v in pairs(buttonList) do
					dockFrame.headers["Stance"]["list"][1] = dockFrame.headers["Stance"]["list"][1]..v..","
				end
			else
				for k,v in pairs(buttonList) do
					dockFrame.headers["Stance"]["list"][0] = dockFrame.headers["Stance"]["list"][0]..v..","
				end
			end
			dockFrame.headers.Actionbar.list[1] = ","

			dockFrame.headers["Stance"]["parent"] = dockFrame.headers.Actionbar.name
			_G[dockFrame.headers.Actionbar.name]:SetAttribute("addchild", header)
			dockFrame.headers["Stance"]["order"] = 2
			header:SetAttribute("showstates", 1)
			dockFrame.headers["Stance"]["showstate"] = 1
		else

			gsub(dockFrame.headers.Normal.list[0], "%d+", function (btn) table.insert(buttonList, btn) end)
			if (UnitClass("player") == TRINITYBARS2_STRINGS.WARRIOR) then
				for k,v in pairs(buttonList) do
					dockFrame.headers["Stance"]["list"][1] = dockFrame.headers["Stance"]["list"][1]..v..","
				end
			else
				for k,v in pairs(buttonList) do
					dockFrame.headers["Stance"]["list"][0] = dockFrame.headers["Stance"]["list"][0]..v..","
				end
			end
			dockFrame.headers.Normal.list[0] = ","

			dockFrame.headers["Stance"]["parent"] = dockFrame.headers.Normal.name
			_G[dockFrame.headers.Normal.name]:SetAttribute("addchild", header)
			dockFrame.headers["Stance"]["order"] = 1
			header:SetAttribute("showstates", 0)
			dockFrame.headers["Stance"]["showstate"] = 0
		end

		header:SetAttribute("useparent-unit*", true)
	else
		if (_G[dockFrame.headers.Stance.name]) then
			dockFrame.headers.Stance.active = false
			dockFrame.headers["Stance"]["parent"] = "UIParent"
			dockFrame.headers["Stance"]["showstate"] = ""
			dockFrame.headers["Stance"]["order"] = 99
		end

		if (UnitClass("player") == TRINITYBARS2_STRINGS.WARRIOR) then
			gsub(dockFrame.headers["Stance"]["list"][1], "%d+", function (btn) table.insert(buttonList, btn) end)
		else
			gsub(dockFrame.headers["Stance"]["list"][0], "%d+", function (btn) table.insert(buttonList, btn) end)
		end


		if (dockFrame.headers.Actionbar.active) then
			for k,v in pairs(buttonList) do
				dockFrame.headers.Actionbar.list[1] = dockFrame.headers.Actionbar.list[1]..v..","
			end
		else
			for k,v in pairs(buttonList) do
				dockFrame.headers.Normal.list[0] = dockFrame.headers.Normal.list[0]..v..","
			end
		end

		if (UnitClass("player") == TRINITYBARS2_STRINGS.WARRIOR) then
			dockFrame.headers["Stance"]["list"][1] = ","
		else
			dockFrame.headers["Stance"]["list"][0] = ","
		end

		TrinityBars2.ClearHeaderStates(dockFrame, "Stance", dockFrame.headers["Stance"]["start"], dockFrame.headers["Stance"]["end"])

	end

	updateDocking(dockFrame)
end

function TrinityBars2.SetProwlBar(dockFrame)

	if (TrinityBars2SavedState.classBar["Cat Form"] == "NOTKNOWN") then
		return
	end

	if (UnitClass("player") ~= TRINITYBARS2_STRINGS.DRUID) then
		dockFrame.config["prowl"] = false
		return
	end

	local catForm = TrinityBars2SavedState.classBar["Cat Form"]

	if (dockFrame.config["prowl"]) then
		if (dockFrame.headers.Stance.active) then
			local stanceHeader = _G[dockFrame.headers.Stance.name]
			RegisterStateDriver(stanceHeader, "stealth", "[stealth] 1; 0")

			stanceHeader:SetAttribute("statemap-stealth-0", "8:"..catForm..";"..catForm..":8")
			stanceHeader:SetAttribute("statemap-stealth-1", catForm..":8;8:"..catForm)
		end
	else
		if (dockFrame.headers.Stance.active) then
			local stanceHeader = _G[dockFrame.headers.Stance.name]
			UnregisterStateDriver(stanceHeader, "stealth")
			stanceHeader:SetAttribute("statemap-stealth-0", nil)
			stanceHeader:SetAttribute("statemap-stealth-1", nil)
			TrinityBars2.ClearHeaderStates(dockFrame, "Stance", 8, 8)
		end
	end

	useStates = false
	setupDockFrameUpdate(dockFrame)
end

function TrinityBars2.SetPossessionBar(dockFrame)

	local normalHeader = _G[dockFrame.headers.Normal.name]

	if (dockFrame.config["possession"]) then
		RegisterStateDriver(normalHeader, "bonusbar", "[bonusbar:5] 9; 0")
		normalHeader:SetAttribute("statemap-bonusbar", "$input")
	else
		UnregisterStateDriver(normalHeader, "bonusbar")
		normalHeader:SetAttribute("statemap-bonusbar", nil)
		TrinityBars2.ClearHeaderStates(dockFrame, "Normal", 9, 9)
	end

	useStates = false
	setupDockFrameUpdate(dockFrame)
end

function TrinityBars2.SetAutohide(dockFrame)

	if (dockFrame.config["autohide"]) then
		autohideIndex[dockFrame] = _G[dockFrame.headers.Normal.name]
	else
		autohideIndex[dockFrame] = nil
	end
end

function TrinityBars2.SetAlphaup(dockFrame)

	if (dockFrame.config["alphaup"] == TRINITYBARS2_STRINGS.ALPHAUP_NONE) then
		alphaupIndex[dockFrame] = nil
	else
		alphaupIndex[dockFrame] = _G[dockFrame.headers.Normal.name]
	end
end

function TrinityBars2.SetTaper(dockFrame)

	local buttonList = {};
	local btn, element, step, button

	for key,value in pairs(dockFrame.headers) do

		for showstate=dockFrame.headers[key]["start"],dockFrame.headers[key]["end"] do

			if (dockFrame.headers[key]["list"][showstate]) then

				clearTable(buttonList)

				gsub(dockFrame.headers[key]["list"][showstate], "%d+", function (btn) table.insert(buttonList, btn) end)

				if (#buttonList > 0) then

					step = (1-dockFrame.config["taper"][2])/#buttonList

					for k,v in pairs(buttonList) do

						button = _G[dockFrame.config.btnType..v]

						if (dockFrame.config["taper"][1] == "none") then
							button.config.scale = 1
						elseif (dockFrame.config["taper"][1] == "Center") then
							if (k <= #buttonList/2) then
								button.config.scale = 1-(step*(#buttonList-k*2))
							else
								button.config.scale = 1-(step*(k-1))
							end
						elseif (dockFrame.config["taper"][1] == "Left") then
							button.config.scale = 1-(step*(#buttonList-k))
						elseif (dockFrame.config["taper"][1] == "Right") then
							button.config.scale = 1-(step*(k-1))
						end

					end
				end
			end
		end
	end
end

function TrinityBars2.ToggleClicks(login)

	if (checkButtons[103]) then

		TrinityBars2SavedState.registerForClicks = "down"

		for k,v in pairs(buttonIndex) do
			v:RegisterForClicks("AnyDown")
		end

		for k,v in pairs(petButtonIndex) do
			v:RegisterForClicks("AnyDown")
		end

		for k,v in pairs(classButtonIndex) do
			v:RegisterForClicks("AnyDown")
		end

		if (not login) then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.CLICK_TYPE_1..TrinityBars2SavedState.registerForClicks..TRINITYBARS2_STRINGS.CLICK_TYPE_2, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		end
	else

		TrinityBars2SavedState.registerForClicks = "up"

		for k,v in pairs(buttonIndex) do
			v:RegisterForClicks("AnyUp")
		end

		for k,v in pairs(petButtonIndex) do
			v:RegisterForClicks("AnyUp")
		end

		for k,v in pairs(classButtonIndex) do
			v:RegisterForClicks("AnyUp")
		end

		if (not login) then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.CLICK_TYPE_1..TrinityBars2SavedState.registerForClicks..TRINITYBARS2_STRINGS.CLICK_TYPE_2, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		end
	end
end

function TrinityBars2.ClampDocks()

	local dockFrame

	for k,v in pairs(dockIndex) do
		if (checkButtons[104]) then
			v:SetClampedToScreen(true)
		else
			v:SetClampedToScreen(false)
		end
	end
end

function TrinityBars2.HideKeyBindings(login)

	local element, hotkey

	if (checkButtons[301]) then

		for k,v in pairs(buttonIndex) do
			v.hotkey:Show()
		end

		for k,v in pairs(petButtonIndex) do
			v.hotkey:Show()
		end

		for k,v in pairs(classButtonIndex) do
			v.hotkey:Show()
		end

		if (not login) then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.KEYBIND_TEXT_SHOWN, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		end
	else
		for k,v in pairs(buttonIndex) do
			v.hotkey:Hide()
		end

		for k,v in pairs(petButtonIndex) do
			v.hotkey:Hide()
		end

		for k,v in pairs(classButtonIndex) do
			v.hotkey:Hide()
		end

		if (not login) then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.KEYBIND_TEXT_HIDDEN, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		end
	end
end

function TrinityBars2.ToggleMacroText(login)

	if (checkButtons[302]) then

		for k,v in pairs(buttonIndex) do
			_G[v:GetName().."Name"]:Show()
			if (v.config.type == "action") then
				updateAction_OnEvent(v, v.config.action)
			elseif (v.config.type == "spell") then
				updateSpell_OnEvent(v, v.config.spell)
			elseif (v.config.type == "macro") then
				updateMacro_OnEvent(v)
			elseif (v.config.type == "item") then
				updateItem_OnEvent(v, v.config.itemlink)
			elseif (v.config.type == "slot") then
				updateSlot_OnEvent(v, v.config.item, v.config.itemlink)
			end
		end

		if (not login) then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.MACRO_TEXT_SHOWN, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		end
	else
		for k,v in pairs(buttonIndex) do
			_G[v:GetName().."Name"]:Hide()
			if (v.config.type == "action") then
				updateAction_OnEvent(v, v.config.action)
			elseif (v.config.type == "spell") then
				updateSpell_OnEvent(v, v.config.spell)
			elseif (v.config.type == "macro") then
				updateMacro_OnEvent(v)
			elseif (v.config.type == "item") then
				updateItem_OnEvent(v, v.config.itemlink)
			elseif (v.config.type == "slot") then
				updateSlot_OnEvent(v, v.config.item, v.config.itemlink)
			end
		end

		if (not login) then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.MACRO_TEXT_HIDDEN, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		end
	end
end

function TrinityBars2.ToggleCountText(login)

	if (checkButtons[303]) then

		for k,v in pairs(buttonIndex) do
			_G[v:GetName().."Count"]:Show()
			if (v.config.type == "action") then
				updateAction_OnEvent(v, v.config.action)
			elseif (v.config.type == "spell") then
				updateSpell_OnEvent(v, v.config.spell)
			elseif (v.config.type == "macro") then
				updateMacro_OnEvent(v)
			elseif (v.config.type == "item") then
				updateItem_OnEvent(v, v.config.itemlink)
			elseif (v.config.type == "slot") then
				updateSlot_OnEvent(v, v.config.item, v.config.itemlink)
			end
		end

		if (not login) then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.COUNT_TEXT_SHOWN, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		end
	else
		for k,v in pairs(buttonIndex) do
			_G[v:GetName().."Count"]:Hide()
			if (v.config.type == "action") then
				updateAction_OnEvent(v, v.config.action)
			elseif (v.config.type == "spell") then
				updateSpell_OnEvent(v, v.config.spell)
			elseif (v.config.type == "macro") then
				updateMacro_OnEvent(v)
			elseif (v.config.type == "item") then
				updateItem_OnEvent(v, v.config.itemlink)
			elseif (v.config.type == "slot") then
				updateSlot_OnEvent(v, v.config.item, v.config.itemlink)
			end
		end

		if (not login) then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.COUNT_TEXT_HIDDEN, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		end
	end
end

function TrinityBars2.TextCooldownToggle(login)

	if (not checkButtons[105]) then

		for k,v in pairs(buttonIndex) do
			_G[v:GetName().."CooldownText"]:SetText("")
			_G[v:GetName().."CooldownTextHuge"]:SetText("")
		end

		for k,v in pairs(petButtonIndex) do
			_G[v:GetName().."CooldownText"]:SetText("")
			_G[v:GetName().."CooldownTextHuge"]:SetText("")
		end

		for k,v in pairs(classButtonIndex) do
			_G[v:GetName().."CooldownText"]:SetText("")
			_G[v:GetName().."CooldownTextHuge"]:SetText("")
		end
	end
end

function TrinityBars2.ToggleBlizzardMainBar(login)

	local dockFrame, anchorButton, defaultElement, lastElement, button

	if (checkButtons[107]) then

		MainMenuBar:Show()
		MainMenuBar:SetFrameStrata("MEDIUM")
		MainMenuBar:SetFrameLevel(0)

		defaultElement = {
			[5] = MainMenuBarBackpackButton,
			[4] = CharacterBag0Slot,
			[3] = CharacterBag1Slot,
			[2] = CharacterBag2Slot,
			[1] = CharacterBag3Slot,
		}

		for i=#defaultElement,1,-1 do
			button = _G["TrinityBagButton"..i]
			button.config.element = ""
			defaultElement[i]:ClearAllPoints()
			defaultElement[i]:SetParent(MainMenuBarArtFrame)
			if (i==5) then
				defaultElement[i]:SetPoint("BOTTOMRIGHT", "MainMenuBarArtFrame", "BOTTOMRIGHT", -6, 2)
				lastElement = defaultElement[i]
			else
				defaultElement[i]:SetPoint("RIGHT", lastElement, "LEFT", -5, 0)
				lastElement = defaultElement[i]
			end
			defaultElement[i]:SetFrameStrata("MEDIUM")
			defaultElement[i]:Show()
			defaultElement[i]:SetScale(1)
		end

		defaultElement = {
			[1] = CharacterMicroButton,
			[2] = SpellbookMicroButton,
			[3] = TalentMicroButton,
			[4] = QuestLogMicroButton,
			[5] = SocialsMicroButton,
			[6] = LFGMicroButton,
			[7] = MainMenuMicroButton,
			[8] = HelpMicroButton,
		}

		for i=1,#defaultElement do
			button = _G["TrinityMenuButton"..i]
			button.config.element = ""
			defaultElement[i]:ClearAllPoints()
			defaultElement[i]:SetParent(MainMenuBarArtFrame)
			if (i==1) then
				defaultElement[i]:SetPoint("BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 552, 2)
				lastElement = defaultElement[i]
			else
				defaultElement[i]:SetPoint("BOTTOMLEFT", lastElement, "BOTTOMRIGHT", -3, 0)
				lastElement = defaultElement[i]
			end
			defaultElement[i]:SetHitRectInsets(3, 3, 23, 3)
			defaultElement[i]:SetFrameStrata("MEDIUM")
			defaultElement[i]:Show()
		end

		local children = { MainMenuBar:GetChildren() }
		for k,v in pairs(children) do
			children[k]:SetFrameStrata("MEDIUM")
		end

		SHOW_KEYRING = 1
		KeyRingButton:Show()

		if (not login) then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.MAINBAR_SHOWN, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
		end
	else

		defaultElement = {
			[5] = MainMenuBarBackpackButton,
			[4] = CharacterBag0Slot,
			[3] = CharacterBag1Slot,
			[2] = CharacterBag2Slot,
			[1] = CharacterBag3Slot,
		}

		for i=1,#defaultElement do
			button = _G["TrinityBagButton"..i]
			button.config.element = defaultElement[i]:GetName()
			defaultElement[i]:ClearAllPoints()
			defaultElement[i]:SetParent(button)
			defaultElement[i]:SetPoint("CENTER", button, "CENTER")
			defaultElement[i]:Show()
			defaultElement[i]:SetScale(0.9)
		end

		defaultElement = {
			[1] = CharacterMicroButton,
			[2] = SpellbookMicroButton,
			[3] = TalentMicroButton,
			[4] = QuestLogMicroButton,
			[5] = SocialsMicroButton,
			[6] = LFGMicroButton,
			[7] = MainMenuMicroButton,
			[8] = HelpMicroButton,
		}

		for i=1,#defaultElement do
			button = _G["TrinityMenuButton"..i]
			button.config.element = defaultElement[i]:GetName()
			defaultElement[i]:ClearAllPoints()
			defaultElement[i]:SetParent(button)
			defaultElement[i]:SetPoint("BOTTOM", button, "BOTTOM", 0, -1)
			defaultElement[i]:SetHitRectInsets(3, 3, 23, 3)
			defaultElement[i]:Show()
		end

		MainMenuBar:Hide()
		KeyRingButton:Hide()

		if (not login) then
			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.MAINBAR_HIDDEN, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
		end
	end
end

function TrinityBars2.ChooseButtonSkin(dockFrame, data)

	if (data == "add" or data == "subtract") then

		local array = createSkinConfig(dockFrame)
		local index

		for i=1,#array do
			if (array[i] == dockFrame.config.skin) then
				index = i
			end
		end

		if (not index) then
			index = 1
		end

		if (data == "add") then
			if (index+1 > #array) then
				index = 1
			else
				index = index + 1
			end
			dockFrame.config.skin = array[index]

		else
			if (index-1 < 1) then
				index = #array
			else
				index = index -1
			end
			dockFrame.config.skin = array[index]
		end

	else
		dockFrame.config.skin = data
	end

	TrinityBars2.SwapTextures(dockFrame, dockIndex)
end

function TrinityBars2.SwapTextures(dockFrame, dockIndex)

	local showstate, element, button
	local buttonList = {};
	local array = nil

	if (not dockFrame.config["skin"]) then
		createSkinConfig(dockFrame)
	end

	if (dockFrame.config.dedType == "menu" or dockFrame.config.dedType == "mainmenu") then
		return
	end

	if (not TrinityBars2.buttonSkins[dockFrame.config["skin"]]) then
		dockFrame.config["skin"] = "Square (Blizz Default)"
	end

	dockFrame.hasAction = TrinityBars2.buttonSkins[dockFrame.config["skin"]]["NormalTexture"]
	dockFrame.noAction = TrinityBars2.buttonSkins[dockFrame.config["skin"]]["NormalTextureEmpty"]

	for key,value in pairs(dockFrame.headers) do

		for showstate=dockFrame.headers[key]["start"],dockFrame.headers[key]["end"] do

			if (dockFrame.headers[key]["list"][showstate]) then

				clearTable(buttonList)

				gsub(dockFrame.headers[key]["list"][showstate], "%d+", function (btn) table.insert(buttonList, btn) end)

				for k,v in pairs(buttonList) do

					if (dockFrame:GetID() == dedBars.bag) then
						if (_G[dockFrame.config.btnType..v].config.element and _G[dockFrame.config.btnType..v].config.element ~= "") then
							element = _G[_G[dockFrame.config.btnType..v].config.element]
							TrinityBars2.SkinNonTrinityButton(element, dockFrame.config["skin"])
							TrinityBars2.UpdateDockButtons(dockFrame)
						end
					else
						array = nil

						button = _G[dockFrame.config.btnType..v]

						if (button) then

							button.skin = dockFrame.config["skin"]
							button.hasAction = dockFrame.hasAction
							button.noAction = dockFrame.noAction

							button:SetNormalTexture(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["NormalTexture"])
							button.normaltexture:SetWidth(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["NormalTextureW"])
							button.normaltexture:SetHeight(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["NormalTextureH"])

							button.border:SetTexture(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["Border"])
							button.border:SetWidth(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["BorderW"])
							button.border:SetHeight(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["BorderH"])

							button:SetHighlightTexture(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["HighlightTexture"])
							button.highlighttexture:SetWidth(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["HighlightTextureW"])
							button.highlighttexture:SetHeight(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["HighlightTextureH"])

							button.bindframe:SetHighlightTexture(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["HighlightTexture"])
							if (button.editframe) then
								button.editframe:SetHighlightTexture(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["HighlightTexture"])
							end

							button:SetCheckedTexture(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["CheckedTexture"])
							button.checkedtexture:SetWidth(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["CheckedTextureW"])
							button.checkedtexture:SetHeight(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["CheckedTextureH"])

							button:SetPushedTexture(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["PushedTexture"])
							button.pushedtexture:SetWidth(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["PushedTextureW"])
							button.pushedtexture:SetHeight(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["PushedTextureH"])
							button.pushedtexture:SetBlendMode(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["PushedBlendMode"])

							button.sheen:SetTexture(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["SheenTexture"])
							button.sheen:SetWidth(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["SheenTextureW"])
							button.sheen:SetHeight(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["SheenTextureH"])

							button.iconframe:SetWidth(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["IconFrameW"])
							button.iconframe:SetHeight(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["IconFrameH"])

							array = TrinityBars2.buttonSkins[dockFrame.config["skin"]]["IconFrameCooldownTL"]
							button.iconframecooldown:SetPoint("TOPLEFT", array[1], array[2])

							array = TrinityBars2.buttonSkins[dockFrame.config["skin"]]["IconFrameCooldownBR"]
							button.iconframecooldown:SetPoint("BOTTOMRIGHT", array[1], array[2])

							array = TrinityBars2.buttonSkins[dockFrame.config["skin"]]["IconFrameIconTexCoord"]
							button.iconframeicon:SetTexCoord(array[1], array[2], array[3], array[4])

							button.hotkey:SetTextHeight(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["HotKeyHeight"])
							array = TrinityBars2.buttonSkins[dockFrame.config["skin"]]["HotKeySetPoint"]
							button.hotkey:ClearAllPoints()
							button.hotkey:SetPoint(array[1], array[2], array[3])

							button.count:SetTextHeight(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["CountTextHeight"])
							array = TrinityBars2.buttonSkins[dockFrame.config["skin"]]["CountTextSetPoint"]
							button.count:ClearAllPoints()
							button.count:SetPoint(array[1], array[2], array[3])

							if (dockFrame:GetID() == dedBars.pet) then

								if (TrinityBars2.buttonSkins[dockFrame.config["skin"]]["AutoCastType"] == "AutoCast") then

									button.autocasttype = TrinityBars2.buttonSkins[dockFrame.config["skin"]]["AutoCastType"]

									button.autocast:ClearAllPoints()

									array = TrinityBars2.buttonSkins[dockFrame.config["skin"]]["AutoCastTL"]
									button.autocast:SetPoint("TOPLEFT", array[1], array[2])

									array = TrinityBars2.buttonSkins[dockFrame.config["skin"]]["AutoCastBR"]
									button.autocast:SetPoint("BOTTOMRIGHT", array[1], array[2])

									button.autocast:SetScale(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["AutoCastScale"])


								elseif (TrinityBars2.buttonSkins[dockFrame.config["skin"]]["AutoCastType"] == "AutoCastSim") then

									button.autocasttype = TrinityBars2.buttonSkins[dockFrame.config["skin"]]["AutoCastType"]

									button.autocast:Hide()
									button.autocastsim:SetTexture(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["CheckedTexture"])
									button.autocastsim:SetWidth(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["CheckedTextureW"])
									button.autocastsim:SetWidth(TrinityBars2.buttonSkins[dockFrame.config["skin"]]["CheckedTextureH"])

								end
							end
						end
					end
				end
			end
		end
	end

	TrinityBars2.UpdateDockButtons(dockFrame)

	updateDocking(dockFrame)
end

function TrinityBars2.SkinNonTrinityButton(button, skinset)

	if (not button) then return end

	local skin, texture, array, buttonName = nil, nil, nil, button:GetName()

	if (not skinset) then
		for k,v in pairs(TrinityBars2.ButtonStyles) do
			if (v == TrinityBars2SavedState.buttonStyle) then
				skin = k
			end
		end
	else
		skin = skinset
	end

	if (not _G[buttonName.."TrinityNormalTexture"]) then
		button:SetNormalTexture("")
		_G[buttonName.."NormalTexture"]:SetAlpha(0)
		_G[buttonName.."NormalTexture"]:Hide()
		texture = button:CreateTexture(buttonName.."TrinityNormalTexture", "ARTWORK")
	else
		button:SetNormalTexture("")
		_G[buttonName.."NormalTexture"]:SetAlpha(0)
		_G[buttonName.."NormalTexture"]:Hide()
		texture = _G[buttonName.."TrinityNormalTexture"]
	end

	texture:SetTexture(TrinityBars2.buttonSkins[skin]["NormalTexture"])
	texture:SetWidth(TrinityBars2.buttonSkins[skin]["NormalTextureW"]*1.1)
	texture:SetHeight(TrinityBars2.buttonSkins[skin]["NormalTextureH"]*1.1)
	texture:SetPoint("CENTER",0,0)
	texture:SetVertexColor(TrinityBars2SavedState.globalColor[1],TrinityBars2SavedState.globalColor[2],TrinityBars2SavedState.globalColor[3])
	texture:Show()

	button:SetHighlightTexture(TrinityBars2.buttonSkins[skin]["HighlightTexture"])
	button:SetCheckedTexture(TrinityBars2.buttonSkins[skin]["CheckedTexture"])
	button:SetPushedTexture(TrinityBars2.buttonSkins[skin]["PushedTexture"])

	if (not _G[buttonName.."Sheen"]) then
		texture = button:CreateTexture("$parentSheen", "OVERLAY", "TrinityCheckButtonSheenTemplate")
	else
		texture = _G[buttonName.."Sheen"]
	end
	texture:SetTexture(TrinityBars2.buttonSkins[skin]["SheenTexture"])
	texture:SetWidth(TrinityBars2.buttonSkins[skin]["SheenTextureW"])
	texture:SetHeight(TrinityBars2.buttonSkins[skin]["SheenTextureH"])

	if (_G[buttonName.."Icon"]) then

		_G[buttonName.."Icon"]:ClearAllPoints()

		array = TrinityBars2.buttonSkins[skin]["IconTL"]
		_G[buttonName.."Icon"]:SetPoint("TOPLEFT",array[1],array[2])

		array = TrinityBars2.buttonSkins[skin]["IconBR"]
		_G[buttonName.."Icon"]:SetPoint("BOTTOMRIGHT",array[1],array[2])


		array = TrinityBars2.buttonSkins[skin]["IconTexCoord"]
		_G[buttonName.."Icon"]:SetTexCoord(array[1],array[2],array[3],array[4])
	end

	if (_G[buttonName.."IconTexture"]) then

		_G[buttonName.."IconTexture"]:ClearAllPoints()

		array = TrinityBars2.buttonSkins[skin]["IconTL"]
		_G[buttonName.."IconTexture"]:SetPoint("TOPLEFT",array[1],array[2])

		array = TrinityBars2.buttonSkins[skin]["IconBR"]
		_G[buttonName.."IconTexture"]:SetPoint("BOTTOMRIGHT",array[1],array[2])

		array = TrinityBars2.buttonSkins[skin]["IconTexCoord"]
		_G[buttonName.."IconTexture"]:SetTexCoord(array[1],array[2],array[3],array[4])
	end

	if (_G[buttonName.."Cooldown"]) then
		_G[buttonName.."Cooldown"]:ClearAllPoints()
		_G[buttonName.."Cooldown"]:SetPoint("CENTER", 0, 0)
		_G[buttonName.."Cooldown"]:SetWidth(TrinityBars2.buttonSkins[skin]["IconFrameW"])
		_G[buttonName.."Cooldown"]:SetHeight(TrinityBars2.buttonSkins[skin]["IconFrameW"])
	end

	_G[buttonName.."Count"]:SetDrawLayer("OVERLAY")
end

function TrinityBars2.ToggleSimpleButtonEditMode()

	if (TrinityBars2SimpleButtonEditor:IsVisible()) then
		TrinityBars2SimpleButtonEditor:Hide()
		for k,dockFrame in pairs(dockIndex) do
			buttonVisibility(dockFrame, false)
		end
	else
		TrinityBars2SimpleButtonEditor:Show()
		for k,dockFrame in pairs(dockIndex) do
			buttonVisibility(dockFrame, true)
		end
	end
end

function TrinityBars2.ToggleButtonEditMode()

	if (TrinityBars2ButtonEditor:IsVisible()) then
		TrinityBars2ButtonEditor:Hide()
		for k,dockFrame in pairs(dockIndex) do
			buttonVisibility(dockFrame, false)
		end
	else
		TrinityBars2ButtonEditor:Show()
		for k,dockFrame in pairs(dockIndex) do
			buttonVisibility(dockFrame, true)
		end
	end
end

function TrinityBars2.SimpleButtonEditor_OnShow(self)

	if (playerEnteredWorld) then

		Trinity2MinimapButton:SetFrameStrata("DIALOG")

		for k,v in pairs(Trinity2.RegisteredPanels) do
			if (v[1] ~= self) then
				v[1]:Hide()
			end
		end

		Trinity2.configMode = true

		for k,v in pairs(buttonIndex) do
			if (k ~= 0) then
				v.editframe:Show()
				v.editframe:SetFrameStrata(v.dockFrame:GetFrameStrata())
				v.editframe:SetFrameLevel(v.dockFrame:GetFrameLevel()+4)

				v.editmode = true

				if (v.config.type == "action") then
					updateActionButton(v, v.config.action)
				elseif (v.config.type == "spell") then
					updateSpellButton(v, v.config.spell)
				elseif (v.config.type == "macro") then
					updateMacroButton(v)
				elseif (v.config.type == "item") then
					updateItemButton(v, v.config.itemlink)
				elseif (v.config.type == "slot") then
					updateSlotButton(v, v.config.item)
				end
			end
		end

		for k,v in pairs(petButtonIndex) do
			v.editframe:Show()
			v.editframe:SetFrameStrata(v.dockFrame:GetFrameStrata())
			v.editframe:SetFrameLevel(v.dockFrame:GetFrameLevel()+4)

			v.editmode = true
		end

		for k,v in pairs(classButtonIndex) do
			v.editframe:Show()
			v.editframe:SetFrameStrata(v.dockFrame:GetFrameStrata())
			v.editframe:SetFrameLevel(v.dockFrame:GetFrameLevel()+4)

			v.editmode = true
		end

		for k,v in pairs(bagButtonIndex) do
			v.editframe:Show()
			v.editframe:SetFrameStrata(v.dockFrame:GetFrameStrata())
			v.editframe:SetFrameLevel(v.dockFrame:GetFrameLevel()+4)

			v.editmode = true
		end

		for k,v in pairs(menuButtonIndex) do
			v.editframe:Show()
			v.editframe:SetFrameStrata(v.dockFrame:GetFrameStrata())
			v.editframe:SetFrameLevel(v.dockFrame:GetFrameLevel()+4)

			v.editmode = true
		end

		for k,v in pairs(Trinity2.RegisteredDocks) do
			dockFrame = _G[k]
			v(dockFrame)
		end

		for i=1, #Trinity2.RegisteredAddons do
			if (Trinity2.RegisteredAddons[i][6]) then
				Trinity2.RegisteredAddons[i][6]()
			end
		end
	end
end

function TrinityBars2.SimpleButtonEditor_OnHide(self)

	if (playerEnteredWorld) then

		Trinity2.configMode = false

		Trinity2MinimapButton:SetFrameStrata(MinimapCluster:GetFrameStrata())

		for k,v in pairs(buttonIndex) do
			if (k ~= 0) then
				v.editframe:Hide()
				v.editframe:SetFrameStrata("LOW")

				v.editmode = false

				if (v.config.type == "action") then
					updateActionButton(v, v.config.action)
				elseif (v.config.type == "spell") then
					updateSpellButton(v, v.config.spell)
				elseif (v.config.type == "macro") then
					updateMacroButton(v)
				elseif (v.config.type == "item") then
					updateItemButton(v, v.config.itemlink)
				elseif (v.config.type == "slot") then
					updateSlotButton(v, v.config.item)
				end
			end
		end

		for k,v in pairs(petButtonIndex) do
			v.editframe:Hide()
			v.editframe:SetFrameStrata("LOW")

			v.editmode = false
		end

		for k,v in pairs(classButtonIndex) do
			v.editframe:Hide()
			v.editframe:SetFrameStrata("LOW")

			v.editmode = false
		end

		for k,v in pairs(bagButtonIndex) do
			v.editframe:Hide()
			v.editframe:SetFrameStrata("LOW")

			v.editmode = false
		end

		for k,v in pairs(menuButtonIndex) do
			v.editframe:Hide()
			v.editframe:SetFrameStrata("LOW")

			v.editmode = false
		end

		for k,v in pairs(Trinity2.RegisteredDocks) do
			dockFrame = _G[k]
			v(dockFrame)
		end

		for i=1, #Trinity2.RegisteredAddons do
			if (Trinity2.RegisteredAddons[i][6]) then
				Trinity2.RegisteredAddons[i][6]()
			end
		end

		TrinityBars2ButtonEditSelect:Hide()
	end
end


function TrinityBars2.ButtonEditor_OnShow(self)

	if (playerEnteredWorld) then

		for k,v in pairs(Trinity2.RegisteredOptions, self) do
			if (v:IsVisible()) then
				InterfaceOptionsFrameOkay_OnClick()
				break
			end
		end

		Trinity2MinimapButton:SetFrameStrata("DIALOG")

		for k,v in pairs(Trinity2.RegisteredPanels) do
			if (v[1] ~= self) then
				v[1]:Hide()
			end
		end

		Trinity2.configMode = true

		for k,v in pairs(buttonIndex) do
			if (k ~= 0) then
				v.editframe:Show()
				v.editframe:SetFrameStrata(v.dockFrame:GetFrameStrata())
				v.editframe:SetFrameLevel(v.dockFrame:GetFrameLevel()+4)

				v.editmode = true

				if (v.config.type == "action") then
					updateActionButton(v, v.config.action)
				elseif (v.config.type == "spell") then
					updateSpellButton(v, v.config.spell)
				elseif (v.config.type == "macro") then
					updateMacroButton(v)
				elseif (v.config.type == "item") then
					updateItemButton(v, v.config.itemlink)
				elseif (v.config.type == "slot") then
					updateSlotButton(v, v.config.item)
				end
			end
		end

		for k,v in pairs(petButtonIndex) do
			v.editframe:Show()
			v.editframe:SetFrameStrata(v.dockFrame:GetFrameStrata())
			v.editframe:SetFrameLevel(v.dockFrame:GetFrameLevel()+4)

			v.editmode = true
		end

		for k,v in pairs(classButtonIndex) do
			v.editframe:Show()
			v.editframe:SetFrameStrata(v.dockFrame:GetFrameStrata())
			v.editframe:SetFrameLevel(v.dockFrame:GetFrameLevel()+4)

			v.editmode = true
		end

		for k,v in pairs(bagButtonIndex) do
			v.editframe:Show()
			v.editframe:SetFrameStrata(v.dockFrame:GetFrameStrata())
			v.editframe:SetFrameLevel(v.dockFrame:GetFrameLevel()+4)

			v.editmode = true
		end

		for k,v in pairs(menuButtonIndex) do
			v.editframe:Show()
			v.editframe:SetFrameStrata(v.dockFrame:GetFrameStrata())
			v.editframe:SetFrameLevel(v.dockFrame:GetFrameLevel()+4)

			v.editmode = true
		end

		for k,v in pairs(Trinity2.RegisteredDocks) do
			dockFrame = _G[k]
			v(dockFrame)
		end

		for i=1, #Trinity2.RegisteredAddons do
			if (Trinity2.RegisteredAddons[i][6]) then
				Trinity2.RegisteredAddons[i][6]()
			end
		end
	end
end

function TrinityBars2.ButtonEditor_OnHide(self)

	if (playerEnteredWorld) then

		Trinity2.configMode = false

		Trinity2MinimapButton:SetFrameStrata(MinimapCluster:GetFrameStrata())

		for k,v in pairs(buttonIndex) do
			if (k ~= 0) then
				v.editframe:Hide()
				v.editframe:SetFrameStrata("LOW")

				v.editmode = false

				if (v.config.type == "action") then
					updateActionButton(v, v.config.action)
				elseif (v.config.type == "spell") then
					updateSpellButton(v, v.config.spell)
				elseif (v.config.type == "macro") then
					updateMacroButton(v)
				elseif (v.config.type == "item") then
					updateItemButton(v, v.config.itemlink)
				elseif (v.config.type == "slot") then
					updateSlotButton(v, v.config.item)
				end
			end
		end

		for k,v in pairs(petButtonIndex) do
			v.editframe:Hide()
			v.editframe:SetFrameStrata("LOW")

			v.editmode = false
		end

		for k,v in pairs(classButtonIndex) do
			v.editframe:Hide()
			v.editframe:SetFrameStrata("LOW")

			v.editmode = false
		end

		for k,v in pairs(bagButtonIndex) do
			v.editframe:Hide()
			v.editframe:SetFrameStrata("LOW")

			v.editmode = false
		end

		for k,v in pairs(menuButtonIndex) do
			v.editframe:Hide()
			v.editframe:SetFrameStrata("LOW")

			v.editmode = false
		end

		for k,v in pairs(Trinity2.RegisteredDocks) do
			dockFrame = _G[k]
			v(dockFrame)
		end

		for i=1, #Trinity2.RegisteredAddons do
			if (Trinity2.RegisteredAddons[i][6]) then
				Trinity2.RegisteredAddons[i][6]()
			end
		end

		TrinityBars2ButtonEditSelect:Hide()
	end
end

function TrinityBars2.ButtonEditor_OnClick(self)

	if (self.button == "prev") then
		Trinity2DockFrameOptions.optionSet = Trinity2DockFrameOptions.optionSet - 1
		if (Trinity2DockFrameOptions.optionSet < 1) then
			Trinity2DockFrameOptions.optionSet = maxOptionSets
		end
	elseif (self.button == "next") then
		Trinity2DockFrameOptions.optionSet = Trinity2DockFrameOptions.optionSet + 1
		if (Trinity2DockFrameOptions.optionSet > maxOptionSets) then
			Trinity2DockFrameOptions.optionSet = 1
		end
	elseif (self.button == "close") then
		TrinityBars2.ToggleButtonEditMode()
	end

	TrinityBars2.ButtonEditor_Update()
end

function TrinityBars2.SetButtonEditorAdjustableOptions()

	Trinity2.EditBox_PopUpInitialize(TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Edit1.popup, TrinityBars2.ButtonOptions, nil)
end

function TrinityBars2.ButtonEditorCurrentButtonEdit1_OnShow(self)

	local data = {}

	for k,v in pairs(buttonIndex) do
		if (k ~= 0) then
			if (k < 10) then
				data[" Button   "..k] = v:GetName()
			elseif (k < 100) then
				data[" Button  "..k] = v:GetName()
			else
				data[" Button "..k] = v:GetName()
			end
		end
	end

	for k,v in pairs(petButtonIndex) do
		if (k < 10) then
			data["Pet Button  "..k] = v:GetName()
		else
			data["Pet Button "..k] = v:GetName()
		end
	end

	for k,v in pairs(classButtonIndex) do
		if (k < 10) then
			data["Class Button  "..k] = v:GetName()
		else
			data["Class Button "..k] = v:GetName()
		end
	end

	for k,v in pairs(bagButtonIndex) do
		if (k < 10) then
			data["Bag Button  "..k] = v:GetName()
		else
			data["Bag Button "..k] = v:GetName()
		end
	end

	for k,v in pairs(menuButtonIndex) do
		if (k < 10) then
			data["Menu Button  "..k] = v:GetName()
		else
			data["Menu Button "..k] = v:GetName()
		end
	end

	Trinity2.EditBox_PopUpInitialize(self.popup, data, TrinityBars2ButtonEditor)

	if (playerEnteredWorld) then

		TrinityBars2.SetButtonEditorAdjustableOptions()

		TrinityBars2.ButtonEditorCurrentButtonEdit2_OnTextChanged(TrinityBars2ButtonEditorCurrentButtonEdit2)

	end


end

function TrinityBars2.ButtonEditorCurrentButtonEdit1_OnTextChanged(self)

	for i=1,2 do
		_G["TrinityBars2ButtonEditorAnchorOptionsCheck"..i].func = nil
	end

	Trinity2.EditBox_PopUpInitialize(TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Edit1.popup, nil, nil)

	if (TrinityBars2ButtonEditor.currFrame) then

		TrinityBars2ButtonEditSelect:SetScale(TrinityBars2ButtonEditor.currFrame:GetEffectiveScale())
		TrinityBars2ButtonEditSelect:SetPoint("TOPLEFT", TrinityBars2ButtonEditor.currFrame.editframe, "TOPLEFT")
		TrinityBars2ButtonEditSelect:SetPoint("BOTTOMRIGHT", TrinityBars2ButtonEditor.currFrame.editframe, "BOTTOMRIGHT")
		TrinityBars2ButtonEditSelect:Show()

		TrinityBars2.SetButtonEditorAdjustableOptions()

		if (TrinityBars2ButtonEditor.currFrame.config.homedock) then
			TrinityBars2ButtonEditorCurrentButtonEdit2:SetText(TrinityBars2ButtonEditor.currFrame.config.homedock)
		else
			TrinityBars2ButtonEditorCurrentButtonEdit2:SetText(TrinityBars2ButtonEditor.currFrame.config.type)
		end

		TrinityBars2.ButtonEditorCurrentButtonEdit2_OnTextChanged(TrinityBars2ButtonEditorCurrentButtonEdit2)

		local barIndex = match(TrinityBars2ButtonEditor.currFrame.config.anchoredheader, "%d+")
		if (barIndex) then
			local dockFrame = _G["TrinityDockFrame"..barIndex]
			TrinityBars2ButtonEditorAnchorOptionsEdit1:SetText(dockFrame.config.name)
		else
			TrinityBars2ButtonEditorAnchorOptionsEdit1:SetText("")
		end

		TrinityBars2.ButtonEditorAnchorOptionsEdit1_OnTextChanged(TrinityBars2ButtonEditorAnchorOptionsEdit1)

		TrinityBars2.ButtonEditorAdjustableOptionsFrameOpt1Edit1_OnTextChanged(TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Edit1)

		TrinityBars2ButtonEditorAnchorOptionsEdit2:SetText(TrinityBars2ButtonEditor.currFrame.config.anchordelay)

		if ( TrinityBars2ButtonEditorMacroEdit:IsVisible()) then
			TrinityBars2.MacroEditor_SaveMacro()
			TrinityBars2ButtonEditorMacroEdit:Show()
		end

		for k,v in pairs(TrinityBars2.ButtonCheckOptions) do
			local checkNum = match(k, "%d+$")
			local text = v[1]

			_G["TrinityBars2ButtonEditorAnchorOptionsCheck"..checkNum.."Text"]:SetText(text)
			_G["TrinityBars2ButtonEditorAnchorOptionsCheck"..checkNum].func = v[2]
			_G["TrinityBars2ButtonEditorAnchorOptionsCheck"..checkNum].tooltip = v[3]
			_G["TrinityBars2ButtonEditorAnchorOptionsCheck"..checkNum].currFrame = TrinityBars2ButtonEditor.currFrame
			_G["TrinityBars2ButtonEditorAnchorOptionsCheck"..checkNum]:Show()

			if (TrinityBars2ButtonEditor.currFrame.config[string.lower(text)]) then
				_G["TrinityBars2ButtonEditorAnchorOptionsCheck"..checkNum]:SetChecked(1)
			else
				_G["TrinityBars2ButtonEditorAnchorOptionsCheck"..checkNum]:SetChecked(nil)
			end
		end
	end

	TrinityBars2.ButtonEditor_Update()

end

function TrinityBars2.ButtonEditor_Update()

	TrinityBars2ButtonEditor:SetHeight(TrinityBars2ButtonEditor:GetTop() - TrinityBars2ButtonEditor.bottom + 7)
end

function TrinityBars2.ButtonEditorCurrentButtonEdit2_OnShow(self)

	local data

	if (TrinityBars2ButtonEditor.currFrame) then

		if (TrinityBars2ButtonEditor.currFrame.config.homedock) then
			data = { [TrinityBars2ButtonEditor.currFrame.config.homedock] = true }
		else
			data = { action = true, macro = true, item = true, slot = true, spell = true, }
		end
	end

	Trinity2.EditBox_PopUpInitialize(self.popup, data)
end

function TrinityBars2.ButtonEditorCurrentButtonEdit2_OnTextChanged(self)

	local data

	TrinityBars2ButtonEditorActionEdit:Hide()
	TrinityBars2ButtonEditorSlotEdit:Hide()
	TrinityBars2ButtonEditorMacroEdit:Hide()

	if (TrinityBars2ButtonEditor.currFrame) then

		if (TrinityBars2ButtonEditor.currFrame.config.homedock) then

			data = { [TrinityBars2ButtonEditor.currFrame.config.homedock] = true }

		else
			data = { action = true, macro = true, item = true, slot = true, spell = true, }

			if (TrinityBars2ButtonEditor.currFrame.config.type ~= self:GetText()) then

				TrinityBars2ButtonEditor.currFrame.config.type = self:GetText()

				TrinityBars2.SetButtonType(TrinityBars2ButtonEditor.currFrame)

				if (self:GetText() == "action") then

					updateAction_OnEvent(TrinityBars2ButtonEditor.currFrame, TrinityBars2ButtonEditor.currFrame.config.action)

				elseif (self:GetText() == "spell") then

				elseif (self:GetText() == "slot") then

				elseif (self:GetText() == "item") then

				elseif (self:GetText() == "macro") then

				end
			end
		end

		Trinity2.EditBox_PopUpInitialize(self.popup, data)
	end

	TrinityBars2ButtonEditor.bottom = TrinityBars2ButtonEditorAdjustableOptionsFrame:GetBottom()


	if (self:GetText() == "action") then

		TrinityBars2ButtonEditorActionEdit:Show()

		TrinityBars2ButtonEditor.bottom = TrinityBars2ButtonEditorActionEdit:GetBottom()

	elseif (self:GetText() == "spell") then


	elseif (self:GetText() == "slot") then

		TrinityBars2ButtonEditorSlotEdit:Show()

		TrinityBars2ButtonEditor.bottom = TrinityBars2ButtonEditorSlotEdit:GetBottom()

	elseif (self:GetText() == "item") then


	elseif (self:GetText() == "macro") then

		TrinityBars2ButtonEditorMacroEdit:Show()

		TrinityBars2ButtonEditor.bottom = TrinityBars2ButtonEditorMacroEdit:GetBottom()
	end

	TrinityBars2.ButtonEditor_Update()

end

function TrinityBars2.ButtonEditorAnchorOptionsEdit1_OnShow(self)

	local data = {}

	for k,v in pairs(Trinity2.RegisteredDocks) do
		if (_G[k].owner) then
			if (_G[k].owner == "TrinityBars2_") then
				if (_G[k].config) then
					if (_G[k].config.name) then
						data[_G[k].config.name] = _G[_G[k].headers.Normal.name]
					end
				end
			end
		end
	end

	Trinity2.EditBox_PopUpInitialize(self.popup, data)

end

function TrinityBars2.ButtonEditorAnchorOptionsEdit1_OnTextChanged(self)

	if (TrinityBars2ButtonEditor.currFrame) then

		local header = _G[TrinityBars2ButtonEditor.currFrame.config.anchoredheader]

		if (header) then

			if (TrinityBars2ButtonEditor.currFrame.config["click anchor"]) then

				TrinityBars2.ClearButtonClickAnchor(TrinityBars2ButtonEditor.currFrame, header)

			elseif (TrinityBars2ButtonEditor.currFrame.config["mouseover anchor"]) then

				TrinityBars2.ClearButtonMouseoverAnchor(TrinityBars2ButtonEditor.currFrame, header)
			end

		end

		local dockFrame

		for k,v in pairs(Trinity2.RegisteredDocks) do
			if (_G[k].config) then
				if (_G[k].config.name) then
					if (_G[k].config.name == self:GetText()) then
						dockFrame = _G[k]
					end
				end
			end
		end

		if (dockFrame) then
			TrinityBars2ButtonEditor.currFrame.config.anchoredheader = dockFrame.headers.Normal.name
		end

		header = _G[TrinityBars2ButtonEditor.currFrame.config.anchoredheader]

		if (TrinityBars2ButtonEditor.currFrame.config["click anchor"]) then

			TrinityBars2.ApplyButtonClickAnchor(TrinityBars2ButtonEditor.currFrame, header)

		elseif (TrinityBars2ButtonEditor.currFrame.config["mouseover anchor"]) then

			TrinityBars2.ApplyButtonMouseoverAnchor(TrinityBars2ButtonEditor.currFrame, header)
		end

	end
end

function TrinityBars2.ButtonEditorAdjustableOptionsFrameOpt1Edit1_OnTextChanged(self)

	TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Subtract.func = nil
	TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Subtract:Disable()

	TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Add.func = nil
	TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Add:Disable()


	if (TrinityBars2.ButtonOptions[self:GetText()]) then

		local data = {}
		local found = false
		local func1 = TrinityBars2.ButtonOptions[self:GetText()][1]
		local currval, data1 = func1(TrinityBars2ButtonEditor.currFrame)

		if (currval) then
			if (TrinityBars2.ButtonOptions[self:GetText()]["editmode"] == 1) then
				TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Edit2:SetText(currval)
			elseif (TrinityBars2.ButtonOptions[self:GetText()]["editmode"] == 2) then
				TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Edit3:SetText(currval)
			end
		end

		if (func1) then

			if (TrinityBars2.ButtonOptions[self:GetText()]["editmode"] == 1) then

				TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Edit3:Hide()

				TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Edit2:Show()

				TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Subtract.func = func1
				TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Subtract:Enable()
				TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Subtract:Show()

				TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Add.func = func1
				TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Add:Enable()
				TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Add:Show()

			elseif (TrinityBars2.ButtonOptions[self:GetText()]["editmode"] == 2) then

				TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Edit2:Hide()
				TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Subtract:Hide()
				TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Add:Hide()

				TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Edit3.func = func1
				TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Edit3:Show()

				Trinity2.EditBox_PopUpInitialize(TrinityBars2ButtonEditorAdjustableOptionsFrameOpt1Edit3.popup, data1)
			end
		end
	end
end

function TrinityBars2.ButtonEditorAdjustableOptionsFrameOpt1Edit3_OnTextChanged(self)

	if (self.func) then
		self.func(TrinityBars2ButtonEditor.currFrame, self:GetText())
	end
end

function TrinityBars2.EditFrame_OnClick(button, click, doubleclick)

	if (TrinityBars2ButtonEditor.currFrame and TrinityBars2ButtonEditor.currFrame.config.type == "macro") then
		TrinityBars2.MacroEditor_SaveMacro()
	end

	TrinityBars2.SetButtonEditorAdjustableOptions(button)

	TrinityBars2ButtonEditSelect:SetScale(button:GetEffectiveScale())

	TrinityBars2ButtonEditSelect:SetPoint("TOPLEFT", button.editframe, "TOPLEFT")

	TrinityBars2ButtonEditSelect:SetPoint("BOTTOMRIGHT", button.editframe, "BOTTOMRIGHT")

	TrinityBars2ButtonEditSelect:Show()

	TrinityBars2ButtonEditor.currFrame = button

	if (button.config.homedock) then

		local prefix = gsub(button.config.homedock, "^%l", upper)

		TrinityBars2ButtonEditorCurrentButtonEdit1:SetText(prefix.." Button "..button.id)

	else

		TrinityBars2ButtonEditorCurrentButtonEdit1:SetText("Button "..button.id)

		if (click == "RightButton") then
			TrinityBars2.ChangeButtonType(nil, button, "add")
		end
	end

	if (doubleclick) then
		TrinityBars2ButtonEditor:Show()
	end

end

function TrinityBars2.EditFrame_OnEnter(button)

	GameTooltip:SetOwner(button, "ANCHOR_RIGHT")

	if (button.config.type == "action") then

		if (HasAction(button.config.action)) then
			GameTooltip:SetAction(button.config.action)
		else
			GameTooltip:SetText("Empty Button")
		end

	elseif (button.config.type == "spell") then

		if (button.config.spell and button.config.spell ~= "") then

			local spell = lower(button.config.spell)

			if (spellIndex[spell]) then
				GameTooltip:SetSpell(spellIndex[spell][1], "spell")
			end
		else
			GameTooltip:SetText("Empty Button")
			button.UpdateTooltip = nil;
		end

	elseif (button.config.type == "macro") then

		--local spell = button.macroList[button.sequence]

		--if (spell and spell ~= "") then

		--	if (spellIndex[spell]) then
		--		GameTooltip:SetSpell(spellIndex[spell][1], "spell")
		--	end
		--else
		--	GameTooltip:SetText("Empty Button")
		--	button.UpdateTooltip = nil;
		--end

	elseif (button.config.type == "item") then

		if (button.config.itemlink and button.config.itemlink ~= "") then

			GameTooltip:SetHyperlink(button.config.itemlink)
		end

	elseif (button.config.type == "slot") then

		GameTooltip:SetInventoryItem("player", button.config.slot)
	end

	GameTooltip:AddLine("\nLeftClick to Edit |cff00ff00Button "..button.id.."|r", 1.0, 1.0, 1.0)
	GameTooltip:AddLine("RightClick to cycle button types", 1.0, 1.0, 1.0)

	GameTooltip:Show()
end

function TrinityBars2.EditFrame_OnLeave(button)

	button.UpdateTooltip = nil;
	GameTooltip:Hide()
end

function TrinityBars2.ProcessBinding(bindkey, modifier, spell, macro)

	local key, keytext, actionButton, id, btnType, config, parent, button, element

	if (spell or macro) then
		actionButton = TrinityActionButton0;
	else
		id = match(keyBindButton, "^%d+")
		btnType = match(keyBindButton, "%d+$")

		if (btnType == "1") then
			btnType = "TrinityActionButton"
		elseif (btnType == "2") then
			btnType = "TrinityClassButton"
		elseif (btnType == "3") then
			btnType = "TrinityPetButton"
		end

		actionButton = _G[btnType..id]
	end

	config = actionButton.config
	parent = actionButton:GetParent()

	if (bindkey == "PRINTSCREEN") then
		return;
	end

	if (bindkey == "ESCAPE") then

		if (spell) then

			key = TrinityBars2SavedState.spellBindings[spell]
			keytext = TrinityBars2SavedState.spellBindings[spell.."-HotKey"]
			TrinityBars2.ClearSpellBinding(key, keytext)

		elseif (macro) then

			key = TrinityBars2SavedState.macroBindings[macro]
			keytext = TrinityBars2SavedState.macroBindings[macro.."-HotKey"]
			TrinityBars2.ClearMacroBinding(key, keytext)

		else
			key = config["HotKey1"]

			if (btnType == "TrinityBagButton" or btnType == "TrinityMenuButton") then
				TrinityBars2.ClearBinding(actionButton, key, keytext, true)
			else
				TrinityBars2.ClearBinding(actionButton, key, keytext)
			end
		end

		TrinityBars2.UpdateBindings()

		return;
	end

	if (modifier) then
		key = modifier..bindkey
		keytext = Trinity2.GetKeyText(bindkey, modifier)
	else
		key = bindkey
		keytext = Trinity2.GetKeyText(bindkey)
	end

	if (btnType == "TrinityBagButton" or btnType == "TrinityMenuButton") then
		TrinityBars2.ClearBinding(actionButton, config.HotKey1, config.HotKeyText1, true)
	else
		TrinityBars2.ClearBinding(actionButton, config.HotKey1, config.HotKeyText1)
	end

	TrinityBars2.ClearSpellBinding(key, keytext)

	TrinityBars2.ClearMacroBinding(key, keytext)

	local function checkButtons(button1, button2)

		if (button2.config) then
			if (button1:GetName() ~= button2:GetName() and k ~= 0) then
				if (config.dock == button2.config.dock) then
					if (parent == button2:GetParent()) then
						if (config.showstate == button2.config.showstate) then
							if (key == button2.config["HotKey1"]) then
								TrinityBars2.ClearBinding(button2, key, keytext)							end
						elseif (config.dockpos == button2.config.dockpos) then
							if (not button2.config["HotKey1"] or button2.config["HotKey1"] == "") then
								TrinityBars2.SetBinding(button2, key, keytext)
							end
						end
					elseif (config.dockpos == button2.config.dockpos) then
						if (not button2.config["HotKey1"] or button2.config["HotKey1"] == "") then
							TrinityBars2.SetBinding(button2, key, keytext)
						end
					end
				else
					if (key == button2.config["HotKey1"]) then
						TrinityBars2.ClearBinding(button2, key, keytext)
					end
				end
			end
		end
	end


	for k,button in pairs(buttonIndex) do
		checkButtons(actionButton, button)
	end

	for k,button in pairs(petButtonIndex) do
		checkButtons(actionButton, button)
	end

	for k,button in pairs(classButtonIndex) do
		checkButtons(actionButton, button)
	end

	if (key and not spell and not macro) then
		if (btnType == "TrinityBagButton" or btnType == "TrinityMenuButton") then
			TrinityBars2.SetBinding(actionButton, key, keytext, true)
		else
			TrinityBars2.SetBinding(actionButton, key, keytext)
		end
	end

	if (spell) then
		TrinityBars2SavedState.spellBindings[spell] = key;
		TrinityBars2SavedState.spellBindings[spell.."-HotKey"] = keytext;
		SetBindingSpell(key, spell)
	end

	if (macro) then
		TrinityBars2SavedState.macroBindings[macro] = key;
		TrinityBars2SavedState.macroBindings[macro.."-HotKey"] = keytext;
		SetBindingMacro(key, macro)
	end
end

function TrinityBars2.SetBinding(button, key, keytext, anchor)

	if (not button.hotkey) then
		return;
	end

	if (not key or key == "") then
		return
	end

	SetBindingClick(key, button:GetName())
	TrinityBars2.SetStateBindings(button, key)

	button.hotkey:SetText(keytext)

	if (checkButtons[301]) then
		button.hotkey:Show()
	else
		button.hotkey:Hide()
	end

	if (anchor) then
		button:GetParent().config["HotKey1"] = key;
		button:GetParent().config["HotKeyText1"] = keytext;
	else
		button.config["HotKey1"] = key;
		button.config["HotKeyText1"] = keytext;
	end
end

function TrinityBars2.ClearBinding(button, key, keytext, anchor)

	if (not button.hotkey) then
		return;
	end

	if (not key or key == "") then
		return
	end

	if (anchor) then
		SetOverrideBinding(button:GetParent():GetParent(), false, key, nil)
	else
		SetOverrideBinding(button:GetParent(), false, key, nil)
	end

	TrinityBars2.SetStateBindings(button, nil)

	button.hotkey:SetText("")

	if (checkButtons[301]) then
		button.hotkey:Show()
	else
		button.hotkey:Hide()
	end

	if (anchor) then
		button:GetParent().config["HotKey1"] = "";
		button:GetParent().config["HotKeyText1"] = "";
	else
		button.config["HotKey1"] = "";
		button.config["HotKeyText1"] = "";
	end

	SetBindingClick(key, TrinityActionButton0:GetName())
end

function TrinityBars2.ClearSpellBinding(key, keytext)

	if (key) then

		SetBinding(key, nil)

		for k,v in pairs(TrinityBars2SavedState.spellBindings) do
			if (v == key) then
				TrinityBars2SavedState.spellBindings[k] = "";
			end
			if (v == keytext) then
				TrinityBars2SavedState.spellBindings[k] = "";
			end
		end
	end
end

function TrinityBars2.ClearMacroBinding(key, keytext)

	if (key) then

		SetBinding(key, nil)

		for k,v in pairs(TrinityBars2SavedState.macroBindings) do
			if (v == key) then
				TrinityBars2SavedState.macroBindings[k] = "";
			end
			if (v == keytext) then
				TrinityBars2SavedState.macroBindings[k] = "";
			end
		end
	end
end

function TrinityBars2.ClearBindingKeys()

	local button, key

	for k,button in pairs(buttonIndex) do
		if (k ~= 0) then

			key = button.config["HotKey1"]

			if (key and key ~= "") then
				SetOverrideBinding(button:GetParent(), false, key, nil)
				SetBinding(key, nil)
			end
		end
	end

	for key, value in pairs(TrinityBars2SavedState.spellBindings) do
		if (not find(key, "-HotKey")) then
			SetBinding(key, nil)
		end
	end

	for key, value in pairs(TrinityBars2SavedState.macroBindings) do
		if (not find(key, "-HotKey")) then
			SetBinding(key, nil)
		end
	end
end

function TrinityBars2.UpdateBindings()

	local dockFrame, button, header, state

	if (not playerEnteredWorld) then
		TrinityBars2.ClearBindingKeys()
	end

	for k,button in pairs(buttonIndex) do
		key = button.config["HotKey1"]
		if (key and key ~= "") then
			TrinityBars2.SetStateBindings(button, key)
			button.hotkey:SetText(button.config["HotKeyText1"])
		end
	end

	for k,button in pairs(petButtonIndex) do
		key = button.config["HotKey1"]
		if (key and key ~= "") then
			TrinityBars2.SetStateBindings(button, key)
			button.hotkey:SetText(button.config["HotKeyText1"])
		end
	end

	for k,button in pairs(classButtonIndex) do
		key = button.config["HotKey1"]
		if (key and key ~= "") then
			TrinityBars2.SetStateBindings(button, key)
			button.hotkey:SetText(button.config["HotKeyText1"])
		end
	end

	for k,v in pairs(TrinityBars2SavedState.spellBindings) do
		if (not find(k, "-HotKey")) then
			SetBindingSpell(v, k)
		end
	end

	for k,v in pairs(TrinityBars2SavedState.macroBindings) do
		if (not find(k, "-HotKey")) then
			SetBindingMacro(v, k)
		end
	end

	for k,dockFrame in pairs(dockIndex) do
		refreshHeaders(dockFrame)
	end

	SecureStateHeader_Refresh(TrinityBars2Options_Storage, "STORED")

	SaveBindings(2)

 	saveCurrentState()
end


function TrinityBars2.SetStateBindings(button, key)

	if (key) then

		if (tonumber(button:GetAttribute("showstates")) == tonumber(button:GetParent():GetAttribute("state"))) then
			SetBindingClick(key, button:GetName())
		end

		if (tonumber(button:GetAttribute("showstates")) == 0) then
			button:SetAttribute("bindings-zero", key)
		elseif (tonumber(button:GetAttribute("showstates")) == 1) then
			button:SetAttribute("bindings-one", key)
		elseif (tonumber(button:GetAttribute("showstates")) == 2) then
			button:SetAttribute("bindings-two", key)
		elseif (tonumber(button:GetAttribute("showstates")) == 3) then
			button:SetAttribute("bindings-three", key)
		elseif (tonumber(button:GetAttribute("showstates")) == 4) then
			button:SetAttribute("bindings-four", key)
		elseif (tonumber(button:GetAttribute("showstates")) == 5) then
			button:SetAttribute("bindings-five", key)
		elseif (tonumber(button:GetAttribute("showstates")) == 6) then
			button:SetAttribute("bindings-six", key)
		elseif (tonumber(button:GetAttribute("showstates")) == 7) then
			button:SetAttribute("bindings-seven", key)
		elseif (tonumber(button:GetAttribute("showstates")) == 8) then
			button:SetAttribute("bindings-eight", key)
		elseif (tonumber(button:GetAttribute("showstates")) == 9) then
			button:SetAttribute("bindings-nine", key)
		elseif (button:GetAttribute("showstates") == "STORED") then
			button:SetAttribute("bindings-stored", key)
		end

	else

		button:SetAttribute("bindings-zero", nil)
		button:SetAttribute("bindings-one", nil)
		button:SetAttribute("bindings-two", nil)
		button:SetAttribute("bindings-three", nil)
		button:SetAttribute("bindings-four", nil)
		button:SetAttribute("bindings-five", nil)
		button:SetAttribute("bindings-six", nil)
		button:SetAttribute("bindings-seven", nil)
		button:SetAttribute("bindings-eight", nil)
		button:SetAttribute("bindings-nine", nil)
		button:SetAttribute("bindings-stored", nil)

	end
end

function TrinityBars2.KeyBinder_OnShow(self)

	if (playerEnteredWorld) then

		self:EnableKeyboard(false)

		for i=1,12 do
			_G["TrinitySpellBinderButton"..i]:Show()
		end

		for i=1,18 do
			_G["TrinityMacroBinderButton"..i]:Show()
		end

		for k,v in pairs(buttonIndex) do
			if (k ~= 0) then
				v.bindframe:Show()
				v.bindframe:SetFrameStrata(v.dockFrame:GetFrameStrata())
				v.bindframe:SetFrameLevel(v.dockFrame:GetFrameLevel()+4)

				v.editmode = true
			end
		end

		for k,v in pairs(petButtonIndex) do
			v.bindframe:Show()
			v.bindframe:SetFrameStrata(v.dockFrame:GetFrameStrata())
			v.bindframe:SetFrameLevel(v.dockFrame:GetFrameLevel()+4)

			v.editmode = true
		end

		for k,v in pairs(classButtonIndex) do
			v.bindframe:Show()
			v.bindframe:SetFrameStrata(v.dockFrame:GetFrameStrata())
			v.bindframe:SetFrameLevel(v.dockFrame:GetFrameLevel()+4)

			v.editmode = true
		end
	end
end

function TrinityBars2.KeyBinder_OnHide(self)

	if (playerEnteredWorld) then

		self:EnableKeyboard(false)

		for i=1,12 do
			_G["TrinitySpellBinderButton"..i]:Hide()
		end

		for i=1,18 do
			_G["TrinityMacroBinderButton"..i]:Hide()
		end

		for k,v in pairs(buttonIndex) do
			if (k ~= 0) then
				v.bindframe:Hide()
				v.bindframe:SetFrameStrata("LOW")

				v.editmode = false
			end
		end

		for k,v in pairs(petButtonIndex) do
			v.bindframe:Hide()
			v.bindframe:SetFrameStrata("LOW")

			v.editmode = false
		end

		for k,v in pairs(classButtonIndex) do
			v.bindframe:Hide()
			v.bindframe:SetFrameStrata("LOW")

			v.editmode = false
		end
	end
end

function TrinityBars2.SpellBinder_OnLoad(self)

	local posCount = 5
	local negCount = 0;
	local bindFrame

	self:RegisterEvent("SPELLS_CHANGED")
	self:RegisterEvent("UPDATE_BINDINGS"				)
	self:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	self:RegisterEvent("CRAFT_SHOW")
	self:RegisterEvent("CRAFT_CLOSE")
	self:RegisterEvent("TRADE_SKILL_SHOW")
	self:RegisterEvent("TRADE_SKILL_CLOSE")
	self:RegisterEvent("PET_BAR_UPDATE")

	for i=1,12 do
		bindFrame = CreateFrame("Button", "TrinitySpellBinderButton"..i, _G["SpellButton"..i], "TrinityBindFrameTemplate")
		bindFrame.action = "spell"
		if (mod(i,2) == 0) then
			bindFrame:SetID(i+posCount)
			posCount = posCount - 1;
		else
			bindFrame:SetID(i+negCount)
			 negCount = negCount - 1;
		end
		bindFrame:SetPoint("TOPLEFT", _G["SpellButton"..i], "TOPLEFT", 0 ,0)
		bindFrame:SetPoint("BOTTOMRIGHT", _G["SpellButton"..i], "BOTTOMRIGHT", 0 ,0)
		bindFrame:SetFrameLevel(_G["SpellButton"..i]:GetFrameLevel()+1)

		_G["SpellButton"..i]:CreateFontString("$parentHotKey", "ARTWORK", "NumberFontNormalSmall")
		_G["SpellButton"..i.."HotKey"]:SetPoint("TOPRIGHT", -1, -5)
	end
end

function TrinityBars2.SpellBookFrame_OnEvent(self, event)

	local frameid, spellid, spellName, subSpellName, flashFrame

	if ( event == "SPELLS_CHANGED" or "UPDATE_BINDINGS") then
		if ( SpellBookFrame:IsVisible() ) then
			for i=1,12 do

				local hotkey = _G["SpellButton"..i.."HotKey"]

				hotkey:SetText()
				frameid = _G["TrinitySpellBinderButton"..i]:GetID()
				spellid = SpellBook_GetSpellID(frameid)
				spellName, subSpellName = GetSpellName(spellid, SpellBookFrame.bookType)
				if (spellName) then
					if (subSpellName) then
						spellName = spellName.."("..subSpellName..")".."-HotKey";
					else
						spellName = spellName.."()".."-HotKey";
					end
					for k,v in pairs(TrinityBars2SavedState.spellBindings) do
						if (k == spellName) then
							hotkey:SetText(v)
						end
					end
				end
			end
		end
	end
end

function TrinityBars2.MacroBinder_OnLoad(self)

	local bindFrame

	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("UPDATE_BINDINGS")
	CREATE_MACROS = " "
	self:Hide()

	for i=1,18 do
		bindFrame = CreateFrame("Button", "TrinityMacroBinderButton"..i, TrinityMacroBinder, "TrinityBindFrameTemplate")
		bindFrame.action = "macro"
		bindFrame:Hide()
	end
end

function TrinityBars2.MacroBinder_OnEvent(self, event)

	if (event == "ADDON_LOADED") then
		TrinityBars2.MacroBinderAddonLoaded(arg1)
	end

	TrinityBars2.MacroBinder_Update()
end

function TrinityBars2.MacroBinderAddonLoaded(addon)

	if (addon == "Blizzard_MacroUI") then

		hooksecurefunc("MacroFrame_Show", TrinityBars2.MacroBinder_Update)
		hooksecurefunc("MacroFrame_Update", TrinityBars2.MacroBinder_Update)

		local bindFrame

		TrinityMacroBinderKeyBind:SetParent("MacroFrame")
		TrinityMacroBinderKeyBind:SetPoint("TOPLEFT", "MacroFrame", "TOPLEFT", 90, -13)
		TrinityMacroBinderKeyBind:Show()

		for i=1,18 do

			bindFrame = _G["TrinityMacroBinderButton"..i]
			bindFrame:SetID(i)
			bindFrame:SetParent("MacroButton"..i)
			bindFrame:SetPoint("TOPLEFT", _G["MacroButton"..i], "TOPLEFT", 0 ,0)
			bindFrame:SetPoint("BOTTOMRIGHT", _G["MacroButton"..i], "BOTTOMRIGHT", 0 ,0)
			bindFrame:SetFrameLevel(_G["MacroButton"..i]:GetFrameLevel()+1)

			_G["MacroButton"..i]:CreateFontString("$parentHotKey", "ARTWORK", "NumberFontNormalSmall")
			_G["MacroButton"..i.."HotKey"]:SetPoint("TOPRIGHT", -1, -5)
		end
	end

end

function TrinityBars2.MacroBinder_Update()

	if (MacroFrame) then

		local name, body, hotkey

		for i=1,18 do

			hotkey = _G["MacroButton"..i.."HotKey"]

			if (hotkey) then
				hotkey:SetText()
				name, _, body, _ = GetMacroInfo(MacroFrame.macroBase + i)
				for k,v in pairs(TrinityBars2SavedState.macroBindings) do
					if (k == name) then
						hotkey:SetText(v)
					end
				end
			end
		end
	end

end


function TrinityBars2.LoadSV()

	local dockFrame, button, index
	local normalHeader, actionbarHeader, stanceHeader
	local defaultConfig = {}
	local savedState = copyTable(TrinityBars2SavedState)

	for k,v in pairs(defaultSavedState) do
		if (savedState[k] == nil) then
			TrinityBars2SavedState[k] = v
		end
	end

	if (savedState["docks"]) then

		index = 1

		for k,v in pairs(savedState["docks"]) do

			dockFrame = createDockFrame(index)

			for key,value in pairs(dockFrame.config) do
				defaultConfig[key] = value
			end

			dockFrame.headers = savedState["docks"][k][1];
			dockFrame.config = savedState["docks"][k][2];

			if (dockFrame.config.dedType) then
				dedBars[dockFrame.config.dedType] = dockFrame:GetID()
				dedBars.docks[dockFrame.config.dedType] = dockFrame

				if (dockFrame.config.dedType == "pet") then
					petDockOptions(dockFrame)
				elseif (dockFrame.config.dedType == "class") then
					classDockOptions(dockFrame)
				elseif (dockFrame.config.dedType == "bag") then
					bagDockOptions(dockFrame)
				elseif (dockFrame.config.dedType == "menu") then
					menuDockOptions(dockFrame)
				elseif (dockFrame.config.dedType == "mainmenu") then
					mainMenuBarDockOptions(dockFrame)
				end
			end

			-- Add new vars
			for key,value in pairs(defaultConfig) do
				if (dockFrame.config[key] == nil) then

					if (dockFrame.config[lower(key)] ~= nil) then

						dockFrame.config[key] = dockFrame.config[lower(key)]
						dockFrame.config[lower(key)] = nil
					else

						dockFrame.config[key] = value
					end
				end
			end
			-- Add new vars

			-- Kill old vars
			--for key,value in pairs(dockFrame.config) do
			--	if (defaultConfig[key] == nil) then
			--		dockFrame.config[key] = nil
			--	end
			--end
			-- Kill old vars


			for key,value in pairs(dockFrame.headers) do

				dockFrame.headers[key]["name"] = "Trinity"..key.."Header"..dockFrame:GetID()

				if (key == "Normal") then
					normalHeader = createNormalHeader(dockFrame)

					if (dockFrame.config.dedType == "pet") then
						dockFrame.config["target"] = "pet"
						--setPossessHeader(normalHeader)
					end
				end

				if (dockFrame.headers[key]) then
					if (dockFrame.headers[key]["active"]) then
						if (key == "Actionbar") then
							actionbarHeader = createActionbarHeader(dockFrame)
							dockFrame.config["paged"] = true
						elseif (key == "Stance") then
							stanceHeader = createStanceHeader(dockFrame)
							dockFrame.config["stance"] = true
						end
					end
				end
			end

			for key,value in pairs(dockFrame.headers) do
				if (dockFrame.headers[key]["active"]) then

					if (key == "Actionbar") then
						_G[dockFrame.headers.Normal.name]:SetAttribute("addchild", actionbarHeader)
						actionbarHeader:SetAttribute("showstates", "0")
						actionbarHeader:SetAttribute("useparent-unit*", true)
					elseif (key == "Stance") then
						if (dockFrame.headers.Actionbar.active) then
							_G[dockFrame.headers.Actionbar.name]:SetAttribute("addchild", stanceHeader)
							stanceHeader:SetAttribute("showstates", "1")
							stanceHeader:SetAttribute("useparent-unit*", true)
						else
							_G[dockFrame.headers.Normal.name]:SetAttribute("addchild", stanceHeader)
							stanceHeader:SetAttribute("showstates", "0")
							stanceHeader:SetAttribute("useparent-unit*", true)
						end
					end
				end
			end

			index = index + 1

		end
	end

	clearTable(defaultConfig)

	if (savedState["buttons"]) then
		for k,v in pairs(savedState["buttons"]) do
			if (k ~= 0) then

				button = createActionButton(k)

				for key,value in pairs(button.config) do
					defaultConfig[key] = value
				end

				if (savedState["buttons"][k][1]) then
					button.config = savedState["buttons"][k][1];
				end


				-- Add new vars
				for key,value in pairs(defaultConfig) do
					if (button.config[key] == nil) then

						if (button.config[lower(key)]) then

							button.config[key] = button.config[lower(key)]
							button.config[lower(key)] = nil
						else

							button.config[key] = value
						end
					end
				end
				-- Add new vars

				-- Kill old vars
				for key,value in pairs(button.config) do
					if (defaultConfig[key] == nil) then
						button.config[key] = nil
					end
				end
				-- Kill old vars

				button:SetScale(0.72)
				button:ClearAllPoints()
				button:SetClampedToScreen(false)
				button:SetParent("TrinityBars2Options_Storage")
				button:SetFrameStrata("DIALOG")
				button.config["stored"] = true

				TrinityBars2Options_Storage.data["buttonIndex"][tonumber(k)] = 1

				TrinityBars2.SetButtonType(button)
			end
		end
	end

	clearTable(defaultConfig)

	if (TrinityBars2SavedState["pet"]) then

		for k,v in pairs(TrinityBars2SavedState["pet"]) do

			button = _G["TrinityPetButton"..k]

			for key,value in pairs(button.config) do
				defaultConfig[key] = value
			end

			if (savedState["pet"][k][1]) then
				button.config = savedState["pet"][k][1];
			end

			-- Add new vars
			for key,value in pairs(defaultConfig) do
				if (button.config[key] == nil) then

					if (button.config[lower(key)]) then

						button.config[key] = button.config[lower(key)]
						button.config[lower(key)] = nil
					else

						button.config[key] = value
					end
				end
			end
			-- Add new vars

			-- Kill old vars
			for key,value in pairs(button.config) do
				if (defaultConfig[key] == nil) then
					button.config[key] = nil
				end
			end
			-- Kill old vars

			button:SetScale(0.72)
			button:ClearAllPoints()
			button:SetClampedToScreen(false)
			button:SetParent("TrinityBars2Options_Storage")
			button:SetFrameStrata("DIALOG")

			TrinityBars2Options_Storage.data["petButtonIndex"][tonumber(k)] = 1
		end
	end

	clearTable(defaultConfig)

	if (savedState["class"]) then
		for k,v in pairs(savedState["class"]) do

			button = _G["TrinityClassButton"..k]

			for key,value in pairs(button.config) do
				defaultConfig[key] = value
			end

			if (savedState["class"][k][1]) then
				button.config = savedState["class"][k][1];
			end

			-- Add new vars
			for key,value in pairs(defaultConfig) do
				if (button.config[key] == nil) then

					if (button.config[lower(key)]) then

						button.config[key] = button.config[lower(key)]
						button.config[lower(key)] = nil
					else

						button.config[key] = value
					end
				end
			end
			-- Add new vars

			-- Kill old vars
			for key,value in pairs(button.config) do
				if (defaultConfig[key] == nil) then
					button.config[key] = nil
				end
			end
			-- Kill old vars

			button:SetScale(0.72)
			button:ClearAllPoints()
			button:SetClampedToScreen(false)
			button:SetParent("TrinityBars2Options_Storage")
			button:SetFrameStrata("DIALOG")

			TrinityBars2Options_Storage.data["classButtonIndex"][tonumber(k)] = 1
		end
	end

	clearTable(defaultConfig)

	if (savedState["bag"]) then
		for k,v in pairs(savedState["bag"]) do

			button = _G["TrinityBagButton"..k]

			for key,value in pairs(button.config) do
				defaultConfig[key] = value
			end

			if (savedState["bag"][k][1]) then
				button.config = savedState["bag"][k][1];
			end

			-- Add new vars
			for key,value in pairs(defaultConfig) do
				if (button.config[key] == nil) then

					if (button.config[lower(key)]) then

						button.config[key] = button.config[lower(key)]
						button.config[lower(key)] = nil
					else

						button.config[key] = value
					end
				end
			end
			-- Add new vars

			-- Kill old vars
			for key,value in pairs(button.config) do
				if (defaultConfig[key] == nil) then
					button.config[key] = nil
				end
			end
			-- Kill old vars

			button:SetScale(0.72)
			button:ClearAllPoints()
			button:SetClampedToScreen(false)
			button:SetParent("TrinityBars2Options_Storage")
			button:SetFrameStrata("DIALOG")

			TrinityBars2Options_Storage.data["bagButtonIndex"][tonumber(k)] = 1
		end
	end

	clearTable(defaultConfig)

	if (savedState["menu"]) then

		for k,v in pairs(savedState["menu"]) do

			button = _G["TrinityMenuButton"..k]

			for key,value in pairs(button.config) do
				defaultConfig[key] = value
			end

			if (savedState["menu"][k][1]) then
				button.config = savedState["menu"][k][1];
			end

			-- Add new vars
			for key,value in pairs(defaultConfig) do
				if (button.config[key] == nil) then

					if (button.config[lower(key)]) then

						button.config[key] = button.config[lower(key)]
						button.config[lower(key)] = nil
					else

						button.config[key] = value
					end
				end
			end
			-- Add new vars

			-- Kill old vars
			for key,value in pairs(button.config) do
				if (defaultConfig[key] == nil) then
					button.config[key] = nil
				end
			end
			-- Kill old vars

			button:SetScale(0.72)
			button:ClearAllPoints()
			button:SetClampedToScreen(false)
			button:SetParent("TrinityBars2Options_Storage")
			button:SetFrameStrata("DIALOG")

			TrinityBars2Options_Storage.data["menuButtonIndex"][tonumber(k)] = 1
		end
	end
end

function TrinityBars2.LoadTemplate(templateName, enabled)

	--if (not enabled) then
	--	Trinity2MessageFrame:AddMessage("Loading Templates Currently Disabled", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
	--	return
	--end

	if (not TrinityBars2Templates[templateName]) then
		Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.TEMPLATE_UNAVAIL, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		return
	end

	local dockFrame, button, index, normalHeader, actionbarHeader, stanceHeader
	local oldDockFrames = {}
	local oldButtons = {}
	local defaultConfig = {}
	local template = copyTable(TrinityBars2Templates[templateName])

	clearTable(TrinityBars2SavedState)

	for k,v in pairs(dockIndex) do
		oldDockFrames[k] = v
	end

	for k,v in pairs(buttonIndex) do
		oldButtons[k] = v
	end

	clearTable(dockIndex)
	clearTable(dockNames)
	clearTable(autohideIndex)
	clearTable(alphaupIndex)
	clearTable(dedBars)

	dedBars.docks = {}

	for templateData,templateValue in pairs(template) do

		if (templateData == "docks") then

			index = 1

			for k,v in pairs(template["docks"]) do

				if (_G["TrinityDockFrame"..index]) then
					dockFrame = _G["TrinityDockFrame"..index]
					dockFrameDefaults(index, dockFrame)
					dockIndex[index] = dockFrame
					Trinity2.RegisteredDocks[dockFrame:GetName()] = function(frame) updateDocking(frame) frame.vis = 1 end
				else
					dockFrame = createDockFrame(index)
					dockIndex[index] = dockFrame
				end

				for key,value in pairs(dockFrame.config) do
					defaultConfig[key] = value
				end

				dockFrame.headers = template["docks"][k][1]
				dockFrame.config = template["docks"][k][2]

				if (dockFrame.config.dedType) then

					dedBars[dockFrame.config.dedType] = dockFrame:GetID()
					dedBars.docks[dockFrame.config.dedType] = dockFrame

					if (dockFrame.config.dedType == "pet") then
						petDockOptions(dockFrame)
					elseif (dockFrame.config.dedType == "class") then
						classDockOptions(dockFrame)
					elseif (dockFrame.config.dedType == "bag") then
						bagDockOptions(dockFrame)
					elseif (dockFrame.config.dedType == "menu") then
						menuDockOptions(dockFrame)
					end
				end

				-- Add new vars
				for key,value in pairs(defaultConfig) do
					if (dockFrame.config[key] == nil) then

						if (dockFrame.config[lower(key)]) then

							dockFrame.config[key] = dockFrame.config[lower(key)]
							dockFrame.config[lower(key)] = nil
						else

							dockFrame.config[key] = value
						end

					end
				end
				-- Add new vars

				-- Kill old vars
				--for key,value in pairs(dockFrame.config) do
				--	if (defaultConfig[key] == nil) then
				--		dockFrame.config[key] = nil
				--	end
				--end
				-- Kill old vars

				for key,value in pairs(dockFrame.headers) do

					dockFrame.headers[key]["name"] = "Trinity"..key.."Header"..dockFrame:GetID()

					if (key == "Normal") then
						if (_G[dockFrame.headers[key]["name"]]) then
							normalHeader = _G[dockFrame.headers[key]["name"]]
						else
							normalHeader = createNormalHeader(dockFrame)
						end
					end

					if (dockFrame.headers[key]["active"]) then
						if (key == "Actionbar") then
							if (_G[dockFrame.headers[key]["name"]]) then
								actionbarHeader = _G[dockFrame.headers[key]["name"]]
							else
								actionbarHeader = createActionbarHeader(dockFrame)
							end
						elseif (key == "Stance") then
							if (_G[dockFrame.headers[key]["name"]]) then
								stanceHeader = _G[dockFrame.headers[key]["name"]]
							else
								stanceHeader = createStanceHeader(dockFrame)
							end
						end
					end
				end

				for key,value in pairs(dockFrame.headers) do
					if (dockFrame.headers[key]["active"]) then

						if (key == "Actionbar") then
							_G[dockFrame.headers.Normal.name]:SetAttribute("addchild", actionbarHeader)
							actionbarHeader:SetAttribute("showstates", "0")
							actionbarHeader:SetAttribute("useparent-unit*", true)
						elseif (key == "Stance") then
							if (dockFrame.headers.Actionbar.active) then
								_G[dockFrame.headers.Actionbar.name]:SetAttribute("addchild", stanceHeader)
								stanceHeader:SetAttribute("showstates", "1")
								stanceHeader:SetAttribute("useparent-unit*", true)
							else
								_G[dockFrame.headers.Normal.name]:SetAttribute("addchild", stanceHeader)
								stanceHeader:SetAttribute("showstates", "0")
								stanceHeader:SetAttribute("useparent-unit*", true)
							end
						end
					end
				end

				oldDockFrames[index] = nil

				index = index + 1
			end

		elseif (templateData == "buttons") then

			clearTable(defaultConfig)

			clearTable(buttonIndex)

			clearTable(TrinityBars2Options_Storage.data["buttonIndex"])

			for k,v in pairs(template["buttons"]) do

				if (k ~= 0) then

					if (_G["TrinityActionButton"..k]) then
						button = _G["TrinityActionButton"..k]
						actionButtonDefaults(k, button)
						buttonIndex[k] = button
					else
						button = createActionButton(k)
						buttonIndex[k] = button
					end

					for key,value in pairs(button.config) do
						defaultConfig[key] = value
					end

					button.config = template["buttons"][k][1];

					-- Add new vars
					for key,value in pairs(defaultConfig) do
						if (button.config[key] == nil) then

							if (button.config[lower(key)]) then

								button.config[key] = button.config[lower(key)]
								button.config[lower(key)] = nil
							else

								button.config[key] = value
							end
						end
					end
					-- Add new vars

					-- Kill old vars
					for key,value in pairs(button.config) do
						if (defaultConfig[key] == nil) then
							button.config[key] = nil
						end
					end
					-- Kill old vars

					button:SetScale(0.72)
					button:ClearAllPoints()
					button:SetClampedToScreen(false)
					button:SetParent("TrinityBars2Options_Storage")
					button:SetFrameStrata("DIALOG")

					TrinityBars2Options_Storage.data["buttonIndex"][tonumber(k)] = 1

					TrinityBars2.SetButtonType(button)

					oldButtons[k] = nil
				end
			end

		elseif (templateData == "pet") then

			clearTable(defaultConfig)

			clearTable(TrinityBars2Options_Storage.data["petButtonIndex"])

			for k,v in pairs(template["pet"]) do

				button = _G["TrinityPetButton"..k]

				for key,value in pairs(button.config) do
					defaultConfig[key] = value
				end

				button.config = template["pet"][k][1];

				-- Add new vars
				for key,value in pairs(defaultConfig) do
					if (button.config[key] == nil) then

						if (button.config[lower(key)]) then

							button.config[key] = button.config[lower(key)]
							button.config[lower(key)] = nil
						else

							button.config[key] = value
						end
					end
				end
				-- Add new vars

				-- Kill old vars
				for key,value in pairs(button.config) do
					if (defaultConfig[key] == nil) then
						button.config[key] = nil
					end
				end
				-- Kill old vars


				button:SetScale(0.72)
				button:ClearAllPoints()
				button:SetClampedToScreen(false)
				button:SetParent("TrinityBars2Options_Storage")
				button:SetFrameStrata("DIALOG")

				TrinityBars2Options_Storage.data["petButtonIndex"][tonumber(k)] = 1
			end

		elseif (templateData == "class") then

			clearTable(defaultConfig)

			clearTable(TrinityBars2Options_Storage.data["classButtonIndex"])

			for k,v in pairs(template["class"]) do

				button = _G["TrinityClassButton"..k]

				for key,value in pairs(button.config) do
					defaultConfig[key] = value
				end

				button.config = template["class"][k][1];

				-- Add new vars
				for key,value in pairs(defaultConfig) do
					if (button.config[key] == nil) then

						if (button.config[lower(key)]) then

							button.config[key] = button.config[lower(key)]
							button.config[lower(key)] = nil
						else

							button.config[key] = value
						end
					end
				end
				-- Add new vars

				-- Kill old vars
				for key,value in pairs(button.config) do
					if (defaultConfig[key] == nil) then
						button.config[key] = nil
					end
				end
				-- Kill old vars

				button:SetScale(0.72)
				button:ClearAllPoints()
				button:SetClampedToScreen(false)
				button:SetParent("TrinityBars2Options_Storage")
				button:SetFrameStrata("DIALOG")

				TrinityBars2Options_Storage.data["classButtonIndex"][tonumber(k)] = 1
			end

		elseif (templateData == "bag") then

			clearTable(defaultConfig)

			clearTable(TrinityBars2Options_Storage.data["bagButtonIndex"])

			for k,v in pairs(template["bag"]) do

				button = _G["TrinityBagButton"..k]

				for key,value in pairs(button.config) do
					defaultConfig[key] = value
				end

				button.config = template["bag"][k][1];

				-- Add new vars
				for key,value in pairs(defaultConfig) do
					if (button.config[key] == nil) then

						if (button.config[lower(key)]) then

							button.config[key] = button.config[lower(key)]
							button.config[lower(key)] = nil
						else

							button.config[key] = value
						end
					end
				end
				-- Add new vars

				-- Kill old vars
				for key,value in pairs(button.config) do
					if (defaultConfig[key] == nil) then
						button.config[key] = nil
					end
				end
				-- Kill old vars

				button:SetScale(0.72)
				button:ClearAllPoints()
				button:SetClampedToScreen(false)
				button:SetParent("TrinityBars2Options_Storage")
				button:SetFrameStrata("DIALOG")

				TrinityBars2Options_Storage.data["bagButtonIndex"][tonumber(k)] = 1
			end

		elseif (templateData == "menu") then

			clearTable(defaultConfig)

			clearTable(TrinityBars2Options_Storage.data["menuButtonIndex"])

			for k,v in pairs(template["menu"]) do

				button = _G["TrinityMenuButton"..k]

				for key,value in pairs(button.config) do
					defaultConfig[key] = value
				end

				button.config = template["menu"][k][1];

				-- Add new vars
				for key,value in pairs(defaultConfig) do
					if (button.config[key] == nil) then

						if (button.config[lower(key)]) then

							button.config[key] = button.config[lower(key)]
							button.config[lower(key)] = nil
						else

							button.config[key] = value
						end
					end
				end
				-- Add new vars

				-- Kill old vars
				for key,value in pairs(button.config) do
					if (defaultConfig[key] == nil) then
						button.config[key] = nil
					end
				end
				-- Kill old vars

				button:SetScale(0.72)
				button:ClearAllPoints()
				button:SetClampedToScreen(false)
				button:SetParent("TrinityBars2Options_Storage")
				button:SetFrameStrata("DIALOG")

				TrinityBars2Options_Storage.data["menuButtonIndex"][tonumber(k)] = 1
			end

		else
			TrinityBars2SavedState[templateData] = templateValue
		end
	end

	saveCurrentState()

	for k,v in pairs(checkButtons) do
		--if (_G["TrinityBars2OptionsCheck"..k]) then
		--	_G["TrinityBars2OptionsCheck"..k]:SetChecked(v)
		--end
	end

	for k,v in pairs(oldDockFrames) do
		if (oldDockFrames[k]) then

			Trinity2.RegisteredDocks[v:GetName()] = nil
			dockIndex[k] = nil;
			dockFrameDefaults(k, v)

			v:Hide()
		end
	end

	for k,v in pairs(oldButtons) do
		if (oldButtons[k]) then

			buttonIndex[k] = nil;
			actionButtonDefaults(k, v)

			v:Hide()
		end
	end

	playerEnteredWorld = false

	TrinityBars2.ClearBindingKeys()

	loadStageOne()
	loadStageTwo()

	for k,v in pairs(oldDockFrames) do
		if (oldDockFrames[k] ~= nil) then
			v:Hide()
		end
	end

	for k,v in pairs(oldButtons) do
		if (oldButtons[k] ~= nil) then
			v:Hide()
		end
	end

	saveCurrentState()

	Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.TEMPLATE..templateName..TRINITYBARS2_STRINGS.TEMPLATE_LOADED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
end

function TrinityBars2.DeleteTemplate(templateName)

	TrinityBars2Templates[templateName] = nil

	Trinity2.EditBox_PopUpInitialize(TrinityBars2Options_TemplatesEdit3.popup, TrinityBars2Templates)

	_G[this:GetParent():GetName().."Edit3"]:SetText("")

	Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.TEMPLATE..templateName..TRINITYBARS2_STRINGS.TEMPLATE_DELETED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)

end

function TrinityBars2.SaveTemplate(templateName)

	if (strlen(templateName) < 1) then
		Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.TEMPLATE_INVALID, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		return
	end

	if (TrinityBars2Templates[templateName]) then
		clearTable(TrinityBars2Templates[templateName])
	else
		TrinityBars2Templates[templateName] = {}
	end

	local template = copyTable(TrinityBars2SavedState)

	TrinityBars2Templates[templateName] = template

	Trinity2.EditBox_PopUpInitialize(TrinityBars2Options_TemplatesEdit3.popup, TrinityBars2Templates)

	Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.TEMPLATE..templateName..TRINITYBARS2_STRINGS.TEMPLATE_SAVED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
end

function TrinityBars2.LoadButtons(templateName)

	if (not TrinityBars2Templates[templateName]) then
		Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.TEMPLATE_UNAVAIL, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		return
	end

	local button, defaultConfig = nil, {}
	local template = copyTable(TrinityBars2Templates[templateName])

	if (template.playerClass ~= UnitClass("player")) then
		Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.TEMPLATE_WRONGCLASS, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		return
	end

	for k,v in pairs(template["buttons"]) do

		if (_G["TrinityActionButton"..k]) then

			button = _G["TrinityActionButton"..k]

			for key,value in pairs(button.config) do
				defaultConfig[key] = value
			end

			button.config = template["buttons"][k][1];

			-- Add new vars
			for key,value in pairs(defaultConfig) do
				if (button.config[key] == nil) then
					button.config[key] = value
				end
			end
			-- Add new vars

			-- Kill old vars
			for key,value in pairs(button.config) do
				if (defaultConfig[key] == nil) then
					button.config[key] = nil
				end
			end
			-- Kill old vars

			TrinityBars2.SetButtonType(button)
		end
	end

	TrinityBars2.ClearBindingKeys()
	TrinityBars2.UpdateBindings()

	saveCurrentState()
end

function TrinityBars2.ResetDock(dockFrame)

	local origConfig = copyTable(dockFrame.config)
	local resetConfig = copyTable(TrinityDockFrame0.config)

	dockFrame.config = copyTable(resetConfig)

	dockFrame.config.btnType = origConfig.btnType
	dockFrame.config.name = origConfig.name

	if (origConfig.dedType) then
		dockFrame.config.dedType = origConfig.dedType
	end
	if (origConfig.orientation) then
		dockFrame.config.orientation = "VERTICAL"
	end
	if (origConfig.anchorwidth) then
		dockFrame.config.anchorwidth = 10
	end
	if (origConfig.anchorheight) then
		dockFrame.config.anchorheight = 215
	end

	dockFrame:SetUserPlaced(false)
	dockFrame:ClearAllPoints()
	dockFrame:SetPoint("CENTER", "UIParent", "CENTER", 0, 0)
	dockFrame:SetUserPlaced(true)

	TrinityBars2.SetTaper(dockFrame)
	TrinityBars2.SwapTextures(dockFrame, dockIndex)

	Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.BAR..dockFrame:GetID()..TRINITYBARS2_STRINGS.BAR_RESET, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
end


function TrinityBars2.DeleteDock(dockFrame, override)

	local count = 0;
	local showstate

	if (not override) then
		if (dockFrame:GetID() == dedBars.bag or
		    dockFrame:GetID() == dedBars.menu or
		    dockFrame:GetID() == dedBars.pet or
		    dockFrame:GetID() == dedBars.class or
		    dockFrame:GetID() == 1) then

			Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.BAR_NODELETE, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
			return;
		end
	end

	for key,value in pairs(dockFrame.headers) do
		TrinityBars2.ClearHeaderStates(dockFrame, key, dockFrame.headers[key]["start"], dockFrame.headers[key]["end"])
	end

	dockFrame:Hide()

	Trinity2.RegisteredDocks[dockFrame:GetName()] = nil
	dockIndex[dockFrame:GetID()] = nil;

	saveCurrentState()

	if (not override) then
		Trinity2MessageFrame:AddMessage(dockFrame.config["name"]..TRINITYBARS2_STRINGS.BAR_DELETE, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
	end

end

function TrinityBars2.StoreDock(dockFrame)

	local count = 0;
	local showstate

	if (dockFrame.config.stored) then

		dockFrame.config.stored = false

		if (Trinity2.configMode) then
			dockFrame:Show()
		end

		saveCurrentState()

		Trinity2MessageFrame:AddMessage(dockFrame.config["name"]..TRINITYBARS2_STRINGS.BAR_RESTORED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)

	else

		for key,value in pairs(dockFrame.headers) do
			TrinityBars2.ClearHeaderStates(dockFrame, key, dockFrame.headers[key]["start"], dockFrame.headers[key]["end"])
		end

		dockFrame.config.stored = true
		dockFrame:Hide()

		saveCurrentState()

		Trinity2MessageFrame:AddMessage(dockFrame.config["name"]..TRINITYBARS2_STRINGS.BAR_STORED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
	end

	updateDocking(dockFrame)

	Trinity2.DockFrame_OnClick(dockFrame, nil, true)

	saveCurrentState()
end

function TrinityBars2.CreateDock(msg)

	local dockFrame, normalHeader, newNum = nil, nil, 1
	local index = 0

	for k,v in pairs(dockIndex) do
		if (k > index) then
			index = k
		end
	end

	index = index + 1

	if (_G["TrinityDockFrame"..index]) then
		dockFrame = _G["TrinityDockFrame"..index]
		normalHeader = _G["TrinityNormalHeader"..index]
		dockFrameDefaults(index, dockFrame)
		dockIndex[index] = dockFrame
		Trinity2.RegisteredDocks[dockFrame:GetName()] = function(frame) updateDocking(frame) frame.vis = 1 end
	else
		dockFrame = createDockFrame(index)
		normalHeader = createNormalHeader(dockFrame)
	end

	if (UnitClass("player") ~= TRINITYBARS2_STRINGS.DRUID) then
		dockFrame.checkSet[TRINITYBARS2_STRINGS.CHECK_OPT_16] = false
	end

	normalHeader:SetAttribute("showstates", "0")
	dockFrame.config.btnType = "TrinityActionButton"
	for k,v in pairs(dockIndex) do
		if (find(v.config.name, "New Bar")) then
			local barNum = match(v.config.name, "%d+")

			if (barNum) then
				barNum = barNum + 1
				if(barNum > newNum) then
					newNum = barNum
				end
			end
		end
	end
	dockFrame.config["name"] = "New Bar "..newNum
	dockFrame.headers.Normal.parent = "UIParent"
	dockFrame.headers["Normal"]["showstate"] = "0";
	dockFrame.headers["Normal"]["order"] = 0;
	dockFrame.headers.Normal.list[0] = ",";

	dockFrame:SetUserPlaced(false)
	dockFrame:ClearAllPoints()
	dockFrame:SetPoint("TOP", "Trinity2DockFrameOptions", "BOTTOM", 0, -45)
	dockFrame.config.centerx, dockFrame.config.centery = dockFrame:GetCenter()
	dockFrame:SetUserPlaced(true)

	updateDocking(dockFrame)
	dockFrame:Show()

	TrinityBars2.SetSelfCast(TrinityBars2SavedState.selfCastOption)

	Trinity2.DockFrame_OnClick(dockFrame, "LeftButton", nil, true)

	saveCurrentState()

	if (msg) then
		Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.BAR_CREATE, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
	end

	return dockFrame
end

function TrinityBars2.CloneDock(dockFrame)

	local cloneDock = TrinityBars2.CreateDock()
	local buttonList, header = {}, nil

	cloneDock.headers = copyTable(dockFrame.headers)
	cloneDock.config = copyTable(dockFrame.config)

	cloneDock.config["name"] = TRINITYBARS2_STRINGS.BAR_CLONEOF..dockFrame.config["name"]

	for key,value in pairs(cloneDock.headers) do
		cloneDock.headers[key]["name"] = "Trinity"..key.."Header"..cloneDock:GetID()
	end

	for key,value in pairs(cloneDock.headers) do

		if (cloneDock.headers[key]["active"]) then
			if (key == "Actionbar") then
				if (not _G[cloneDock.headers[key]["name"]]) then
					createActionbarHeader(cloneDock)
				end
			elseif (key == "Stance") then
				if (not _G[cloneDock.headers[key]["name"]]) then
					createStanceHeader(cloneDock)
				end
			end
		end

		header = _G[cloneDock.headers[key]["name"]]

		for showstate=cloneDock.headers[key]["start"],cloneDock.headers[key]["end"] do

			if (cloneDock.headers[key]["list"][showstate]) then

				clearTable(buttonList)

				gsub(cloneDock.headers[key]["list"][showstate], "%d+", function (btn) table.insert(buttonList, btn) end)

				cloneDock.headers[key]["list"][showstate] = ""

				for k,v in pairs(buttonList) do

					local button = _G[dockFrame.config.btnType..v]
					local cloneButton, index, made = nil, 1, false

					while not made do

						if (not _G["TrinityActionButton"..index]) then
							cloneButton = createActionButton(index)
							cloneButton.config = copyTable(button.config)
							TrinityBars2.SetButtonType(cloneButton)
							made = true
						end

						index = index + 1
					end

					if (cloneButton) then

						cloneButton.config.dock = cloneDock:GetID()
						cloneButton.config.HotKey1 = ""
						cloneButton.config.HotKeyText1 = ""
						cloneButton.config.anchoredheader = cloneDock.headers.Normal.name
						cloneButton.config["mouseover anchor"] = false
						cloneButton.config["click anchor"] = false

						cloneButton.dockFrame = cloneDock
						cloneButton.config["showstate"] = showstate
						cloneButton:SetAttribute("showstates", showstate)

						header:SetAttribute("addchild", cloneButton)

						if (not cloneDock.headers[key]["list"][showstate] or cloneDock.headers[key]["list"][showstate] == "") then
							cloneDock.headers[key]["list"][showstate] = ","..cloneButton.id..",";
						else
							cloneDock.headers[key]["list"][showstate] = cloneDock.headers[key]["list"][showstate]..cloneButton.id..","
						end

						if (TrinityBars2KeyBinder:IsVisible() or TrinityBars2SimpleKeyBinder:IsVisible()) then
							cloneButton.bindframe:Show()
						end
					end
				end
			end
		end
	end

	TrinityBars2.SwapTextures(cloneDock)

	updateDocking(cloneDock)

	saveCurrentState()
end

function TrinityBars2.CycleStates(dockFrame, action)

	setCurrHeaderShowstate(dockFrame)

	local stateNormal, statePaged, stateStance
	local data = {}
	local forms = {}

	data.normal = {
		[0] = "normal",
		[2] = "reaction",
		[3] = "alt",
		[4] = "control",
		[5] = "shift",
		[6] = "stealth",
		[7] = "unknown",
		[8] = "unknown",
		[9] = "possession",
	}

	data.paged = {}
	for i=1,6 do
		data.paged[i] = "page"..i
	end

	data.stance = {}
	for k,v in pairs(TrinityBars2SavedState.classBar) do
		if (v ~= "NOTKNOWN") then
			data.stance[v] = k
		end
	end

	stateNormal = _G[dockFrame.headers.Normal.name]:GetAttribute("state")
	stateNormal = tonumber(stateNormal)

	if (dockFrame.headers.Actionbar.active) then
		statePaged = _G[dockFrame.headers.Actionbar.name]:GetAttribute("state")
		statePaged = tonumber(statePaged)
	end

	if (dockFrame.headers.Stance.active) then
		stateStance = _G[dockFrame.headers.Stance.name]:GetAttribute("state")
		stateStance = tonumber(stateStance)
	end

	if (statePaged) then
		data.normal[0] = "paged"
		if (stateStance) then
			data.normal[1] = "stance"
		end
	elseif (stateStance) then
		data.normal[0] = "stance"
	end

	if (action == 1) then
		if (data.normal[0] == "paged" and stateNormal == 0) then
			if (data.normal[1] == "stance") then
				local found = false

				for k,v in pairs(TrinityBars2SavedState.classBar) do
					if (v ~= "NOTKNOWN") then
						if (k == "Prowl") then
							if (dockFrame.config.prowl) then
								forms[v] = k
							end
						else
							forms[v] = k
						end
					end
				end

				for i=0,8 do
					if (i > stateStance) then
						if (forms[i]) then
							stateStance = i
							found = true
							break
						end
					end
				end
				if (not found) then
					statePaged = statePaged + 1
					if (statePaged > 6) then
						statePaged = 6
						for i=0,6 do
							if (i > stateNormal and i ~= 1) then
								if (dockFrame.config[data.normal[i]]) then
									stateNormal = i
									break
								end
							end
						end
					end
				end
			else
				statePaged = statePaged + 1
				if (statePaged > 6) then
					statePaged = 6
					for i=0,6 do
						if (i > stateNormal and i ~= 1) then
							if (dockFrame.config[data.normal[i]]) then
								stateNormal = i
								break
							end
						end
					end
				end
			end
		elseif (data.normal[0] == "stance" and stateNormal == 0) then

			local found = false

			for k,v in pairs(TrinityBars2SavedState.classBar) do
				if (v ~= "NOTKNOWN") then
					if (k == "Prowl") then
						if (dockFrame.config.prowl) then
							forms[v] = k
						end
					else
						forms[v] = k
					end
				end
			end

			for i=0,8 do
				if (i > stateStance) then
					if (forms[i]) then
						stateStance = i
						found = true
						break
					end
				end
			end
			if (not found) then
				for i=0,6 do
					if (i > stateNormal and i ~= 1) then
						if (dockFrame.config[data.normal[i]]) then
							stateNormal = i
							break
						end
					end
				end
			end
		else
			for i=0,9 do
				if (i > stateNormal and i ~= 1) then
					if (dockFrame.config[data.normal[i]]) then
						stateNormal = i
						break
					end
				end
			end
		end
	else
		if (data.normal[0] == "paged" and stateNormal == 0) then
			if (data.normal[1] == "stance") then
				local found = false

				for k,v in pairs(TrinityBars2SavedState.classBar) do
					if (v ~= "NOTKNOWN") then
						if (k == "Prowl") then
							if (dockFrame.config.prowl) then
								forms[v] = k
							end
						else
							forms[v] = k
						end
					end
				end
				for i=8,0,-1 do
					if (i < stateStance) then
						if (forms[i]) then
							stateStance = i
							found = true
							break
						end
					end
				end
				if (not found) then
					statePaged = statePaged - 1
					if (statePaged < 1) then
						statePaged = 1
						for i=6,0,-1 do
							if (i < stateNormal and i ~= 1) then
								if (dockFrame.config[data.normal[i]]) then
									stateNormal = i
									break
								end
							end
						end
					end
				end
			else
				statePaged = statePaged - 1
				if (statePaged < 1) then
					statePaged = 1
					for i=9,0,-1 do
						if (i < stateNormal and i ~= 1) then
							if (dockFrame.config[data.normal[i]]) then
								stateNormal = i
								break
							end
						end
					end

				end
			end
		elseif (data.normal[0] == "stance" and stateNormal == 0) then

			local found = false

			for k,v in pairs(TrinityBars2SavedState.classBar) do
				if (v ~= "NOTKNOWN") then
					if (k == "Prowl") then
						if (dockFrame.config.prowl) then
							forms[v] = k
						end
					else
						forms[v] = k
					end
				end
			end
			for i=8,0,-1 do
				if (i < stateStance) then
					if (forms[i]) then
						stateStance = i
						found = true
						break
					end
				end
			end
			if (not found) then
				for i=6,0,-1 do
					if (i < stateNormal and i ~= 1) then
						if (dockFrame.config[data.normal[i]]) then
							stateNormal = i
							break
						end
					end
				end
			end
		else
			for i=6,0,-1 do
				if (i < stateNormal and i ~= 1) then
					if (dockFrame.config[data.normal[i]]) then
						stateNormal = i
						break
					end
				end
			end
		end
	end

	_G[dockFrame.headers.Normal.name]:SetAttribute("state", stateNormal)

	if (dockFrame.headers.Actionbar.active) then
		_G[dockFrame.headers.Actionbar.name]:SetAttribute("state", statePaged)
	end

	if (dockFrame.headers.Stance.active) then
		_G[dockFrame.headers.Stance.name]:SetAttribute("state", stateStance)
	end

	useStates = true
	dockFrame.elapsed = 0
	setupDockFrameUpdate(dockFrame)
	updateDockNames(dockFrame)

end

function TrinityBars2.UpdateDockButtons(dockFrame)

	local buttonList = {};
	local btn, element, button

	for key,value in pairs(dockFrame.headers) do

		for showstate=dockFrame.headers[key]["start"],dockFrame.headers[key]["end"] do

			if (dockFrame.headers[key]["list"][showstate]) then

				clearTable(buttonList)

				gsub(dockFrame.headers[key]["list"][showstate], "%d+", function (btn) table.insert(buttonList, btn) end)

				for k,v in pairs(buttonList) do

					if (dockFrame.config.btnType == "TrinityActionButton") then
						button = _G[dockFrame.config.btnType..v]
						if (button.config.type == "action") then
							updateAction_OnEvent(button, button.config.action)
						elseif (button.config.type == "spell") then
							updateSpell_OnEvent(button, button.config.spell)
						elseif (button.config.type == "macro") then
							local onEvent = button:GetScript("OnEvent")
							onEvent(button, "PLAYER_ENTERING_WORLD")
						elseif (button.config.type == "item") then
							updateItem_OnEvent(button, button.config.itemlink)
						elseif (button.config.type == "slot") then
							updateSlot_OnEvent(button, button.config.item, button.config.itemlink)
						end
					elseif (dockFrame.config.btnType == "TrinityPetButton") then
						updatePetButton_OnEvent(_G[dockFrame.config.btnType..v])
					elseif (dockFrame.config.btnType == "TrinityClassButton") then
						updateClassButton_OnEvent(_G[dockFrame.config.btnType..v])
					elseif (dockFrame.config.btnType == "TrinityBagButton") then
						if (_G[dockFrame.config.btnType..v].config.element and _G[dockFrame.config.btnType..v].config.element ~= "") then
							element = _G[_G[dockFrame.config.btnType..v].config.element]
							if (_G[element:GetName().."TrinityNormalTexture"]) then
								_G[element:GetName().."TrinityNormalTexture"]:SetVertexColor(dockFrame.config["skincolor"][1],dockFrame.config["skincolor"][2],dockFrame.config["skincolor"][3],1)
							end
						end
					end
				end
			end
		end
	end
end

function TrinityBars2.ClearHeaderStates(dockFrame, header, start, last)

	local buttonList, showstate, button = {}, nil, nil
	local count = 0

	for showstate=start,last do
		if (dockFrame.headers[header]["list"][showstate]) then

			clearTable(buttonList)

			gsub(dockFrame.headers[header]["list"][showstate], "%d+", function (btn) table.insert(buttonList, btn) end)
			for k,v in pairs(buttonList) do


				button = _G[dockFrame.config.btnType..v]

				button:ClearAllPoints()

				button.config["dock"] = 0
				button.config["dockpos"] = 0
				button.config.scale = 1
				button.config["XOffset"] = 0
				button.config["YOffset"] = 0
				button.config["target"] = "none"
				button.config["stored"] = true

				button:SetParent("TrinityBars2Options_Storage")
				button:SetFrameStrata("DIALOG")
				button:SetFrameLevel(4)
				if (button.iconframe) then
					button.iconframe:SetFrameLevel(2)
				end
				if (button.iconframecooldown) then
					button.iconframecooldown:SetFrameLevel(3)
				end
				if (button.iconframebuffup) then
					button.iconframebuffup:SetFrameLevel(3)
				end

				button:SetScale(0.72)

				dockFrame.headers[header]["list"][showstate] = gsub(dockFrame.headers[header]["list"][showstate], "(%D)"..v..",", "%1")

				if (dockFrame.config.btnType == "TrinityActionButton") then
					TrinityBars2Options_Storage.data["buttonIndex"][tonumber(v)] = 1;
					setDefaultButtonSkin(button)
				elseif (dockFrame.config.btnType == "TrinityPetButton") then
					TrinityBars2Options_Storage.data["petButtonIndex"][tonumber(v)] = 1;
					setDefaultButtonSkin(button)
				elseif (dockFrame.config.btnType == "TrinityClassButton") then
					TrinityBars2Options_Storage.data["classButtonIndex"][tonumber(v)] = 1;
					setDefaultButtonSkin(button)
				elseif (dockFrame.config.btnType == "TrinityBagButton") then
					TrinityBars2Options_Storage.data["bagButtonIndex"][tonumber(v)] = 1;
				elseif (dockFrame.config.btnType == "TrinityMenuButton") then
					TrinityBars2Options_Storage.data["menuButtonIndex"][tonumber(v)] = 1;
				end

				buttonList[v] = nil
				count = count + 1
			end
		end
	end

	updateStorageDocking()

	if (count > 0) then
		Trinity2MessageFrame:AddMessage(count..TRINITYBARS2_STRINGS.STORED_CLEARED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
	end
end

function TrinityBars2.OptionsEdit1_OnEvent(self)

	_G[self:GetName().."Text"]:SetText(TRINITYBARS2_STRINGS.EDITBOX_1)
	_G[self:GetName().."Text"]:SetPoint("BOTTOM", "$parent", "TOP", 30, -1)
	--_G[self:GetName().."ScrollFrame"]:SetPoint("TOPRIGHT", "$parent", "BOTTOMRIGHT", 62 ,5)
end

function TrinityBars2.OptionsEdit1_OnTextChanged(self)

	if (TrinityBars2.SelfCastOptions[self:GetText()]) then
		TrinityBars2SavedState.selfCastOption = TrinityBars2.SelfCastOptions[self:GetText()]
		TrinityBars2.SetSelfCast(TrinityBars2SavedState.selfCastOption)
	end
	self:ClearFocus()
end

function TrinityBars2.OptionsEdit1_OnShow(self)

	Trinity2.EditBox_PopUpInitialize(self.popup, TrinityBars2.SelfCastOptions)
	for k,v in pairs(TrinityBars2.SelfCastOptions) do
		if (v == TrinityBars2SavedState.selfCastOption) then
			self:SetText(k)
		end
	end
end

function TrinityBars2.OptionsEdit2_OnEvent(self)

	_G[self:GetName().."Text"]:SetText(TRINITYBARS2_STRINGS.EDITBOX_2)
	_G[self:GetName().."Text"]:SetPoint("BOTTOM", "$parent", "TOP", 30, -1)
	--_G[self:GetName().."ScrollFrame"]:SetPoint("TOPRIGHT", "$parent", "BOTTOMRIGHT", 62 ,5)
end

function TrinityBars2.OptionsEdit2_OnShow(self)

	local count = 1
	local array = {}

	for k,v in pairs(TrinityBars2.buttonSkins) do
		array[count] = k
		count = count + 1
	end

	table.sort(array)

	for k,v in pairs(array) do
		TrinityBars2.ButtonStyles[v] = k
	end

	Trinity2.EditBox_PopUpInitialize(self.popup, TrinityBars2.ButtonStyles)

	for k,v in pairs(TrinityBars2.ButtonStyles) do
		if (v == TrinityBars2SavedState.buttonStyle) then
			self:SetText(k)
		end
	end
end

function TrinityBars2.Options_TemplatesEdit3_OnShow(self)
	Trinity2.EditBox_PopUpInitialize(self.popup, TrinityBars2Templates)
end

function TrinityBars2.Options_TemplatesEdit5_OnShow(self)
	Trinity2.EditBox_PopUpInitialize(self.popup, TrinityBars2Templates)
end

function TrinityBars2.OptionsEdit15_OnEvent(self)

	_G[self:GetName().."Text"]:SetText(TRINITYBARS2_STRINGS.EDITBOX_15)
	_G[self:GetName().."Text"]:SetPoint("BOTTOM", "$parent", "TOP", 0, -1)
end

function TrinityBars2.OptionsEdit15_OnTextChanged(self)

	if (TrinityBars2SavedState.skinPlugins[self:GetText()]) then
		_G[self:GetParent():GetName().."Check8"]:SetChecked(TrinityBars2SavedState.skinPlugins[self:GetText()][1])
	end
end

function TrinityBars2.OptionsEdit15_OnShow(self)

	local data = {}
	for k,v in pairs(TrinityBars2SavedState.skinPlugins) do
		if (_G[TrinityBars2SavedState.skinPlugins[k][2]]) then
			data[k] = v
		end
	end
	Trinity2.EditBox_PopUpInitialize(self.popup, data)
end

function TrinityBars2.OptionsConfirm1_OnClick(self)

	PlaySound("gsTitleOptionOK")
	local option = _G[self:GetParent():GetName().."Edit1"]:GetText()

	if (TrinityBars2.SelfCastOptions[option]) then
		TrinityBars2SavedState.selfCastOption = TrinityBars2.SelfCastOptions[option]
		TrinityBars2.SetSelfCast(TrinityBars2SavedState.selfCastOption)
		Trinity2MessageFrame:AddMessage(TRINITYBARS2_STRINGS.SELFCAST_SET..option)
	end
end

function TrinityBars2.OptionsConfirm2_OnClick(self)

	PlaySound("gsTitleOptionOK")

	local skin = _G[self:GetParent():GetName().."Edit2"]:GetText()

	for k,v in pairs(dockIndex) do
		v.config["skin"] = skin
		TrinityBars2SavedState.buttonStyle = TrinityBars2.ButtonStyles[skin]
		TrinityBars2.SwapTextures(v)
	end

	--for k,v in pairs(TrinityBars2SavedState.skinPlugins) do
	--	if (TrinityBars2SavedState.skinPlugins[k][1] and _G[TrinityBars2SavedState.skinPlugins[k][2]]) then
	--		TrinityBars2[TrinityBars2SavedState.skinPlugins[k][3]](skin)
	--	end
	--end
end

function TrinityBars2.OptionsCheck8_OnClick(self)

	PlaySound("gsTitleOptionOK")

	local plugin = _G[self:GetParent():GetName().."Edit15"]:GetText()

	if (self:GetChecked()) then
		if (TrinityBars2SavedState.skinPlugins[plugin]) then
			TrinityBars2SavedState.skinPlugins[plugin][1] = true
		end
	else
		if (TrinityBars2SavedState.skinPlugins[plugin]) then
			TrinityBars2SavedState.skinPlugins[plugin][1] = false
		end
	end
end

function TrinityBars2.OptionsSlider1_OnShow(self)

	self:SetMinMaxValues(0, GetScreenWidth()-ContainerFrame1:GetWidth()*ContainerFrame1:GetEffectiveScale())
	self:SetValue(TrinityBars2SavedState.containerOffsetX)
	if (TrinityBars2OptionsSliderEdit1) then
		TrinityBars2OptionsSliderEdit1:SetText(TrinityBars2SavedState.containerOffsetX)
	end
end

function TrinityBars2.OptionsSlider1_OnValueChanged(self)

	TrinityBars2SavedState.containerOffsetX = self:GetValue()
	if (TrinityBars2OptionsSliderEdit1) then
		TrinityBars2OptionsSliderEdit1:SetText(TrinityBars2SavedState.containerOffsetX)
	end
	updateContainerFrameAnchors()
end

function TrinityBars2.OptionsSlider2_OnShow(self)

	self:SetMinMaxValues(0, GetScreenHeight()-ContainerFrame1:GetHeight()*ContainerFrame1:GetEffectiveScale())
	self:SetValue(TrinityBars2SavedState.containerOffsetY)
	if (TrinityBars2OptionsSliderEdit2) then
		TrinityBars2OptionsSliderEdit2:SetText(TrinityBars2SavedState.containerOffsetY)
	end
end

function TrinityBars2.OptionsSlider2_OnValueChanged(self)

	TrinityBars2SavedState.containerOffsetY = self:GetValue()
	if (TrinityBars2OptionsSliderEdit2) then
		TrinityBars2OptionsSliderEdit2:SetText(TrinityBars2SavedState.containerOffsetY)
	end
	updateContainerFrameAnchors()
end

function TrinityBars2.OptionsSlider3_OnShow(self)

	self:SetValue(TrinityBars2SavedState.containerScale)
	if (TrinityBars2OptionsSliderEdit3) then
		TrinityBars2OptionsSliderEdit3:SetText(string.format("%.1f",TrinityBars2SavedState.containerScale))
	end
end

function TrinityBars2.OptionsSlider3_OnValueChanged(self)

	TrinityBars2SavedState.containerScale = self:GetValue()
	if (TrinityBars2OptionsSliderEdit3) then
		TrinityBars2OptionsSliderEdit3:SetText(string.format("%.1f",TrinityBars2SavedState.containerScale))
	end
	updateContainerFrameAnchors()
end

function TrinityBars2.OptionsSlider4_OnShow(self)

	self:SetValue(TrinityBars2SavedState.cooldownAlpha)
	if (TrinityBars2OptionsSliderEdit4) then
		TrinityBars2OptionsSliderEdit4:SetText(string.format("%.2f",TrinityBars2SavedState.cooldownAlpha))
	end
end

function TrinityBars2.OptionsSlider4_OnValueChanged(self)

	TrinityBars2SavedState.cooldownAlpha = self:GetValue()
	cooldownAlpha = self:GetValue()
	if (TrinityBars2OptionsSliderEdit4) then
		TrinityBars2OptionsSliderEdit4:SetText(string.format("%.2f",TrinityBars2SavedState.cooldownAlpha))
	end
end

function TrinityBars2.OptionsSlider5_OnShow(self)

	self:SetValue(TrinityBars2SavedState.autocastAlpha)
	if (TrinityBars2OptionsSliderEdit5) then
		TrinityBars2OptionsSliderEdit5:SetText(string.format("%.2f",TrinityBars2SavedState.autocastAlpha))
	end
end

function TrinityBars2.OptionsSlider5_OnValueChanged(self)

	TrinityBars2SavedState.autocastAlpha = self:GetValue()
	autocastAlpha = TrinityBars2SavedState.autocastAlpha
	if (TrinityBars2OptionsSliderEdit5) then
		TrinityBars2OptionsSliderEdit5:SetText(string.format("%.2f",TrinityBars2SavedState.autocastAlpha))
	end
	for k,v in pairs(petButtonIndex) do
		updatePetButton_OnEvent(v)
	end
end

function TrinityBars2.OptionsSlider6_OnShow(self)

	self:SetValue(TrinityBars2SavedState.fadeSpeed)
	if (TrinityBars2OptionsSliderEdit6) then
		TrinityBars2OptionsSliderEdit6:SetText(string.format("%.0f",TrinityBars2SavedState.fadeSpeed*100))
	end
end

function TrinityBars2.OptionsSlider6_OnValueChanged(self)

	TrinityBars2SavedState.fadeSpeed = self:GetValue()
	fadeSpeed = TrinityBars2SavedState.fadeSpeed
	if (TrinityBars2OptionsSliderEdit6) then
		TrinityBars2OptionsSliderEdit6:SetText(string.format("%.0f",TrinityBars2SavedState.fadeSpeed*100))
	end
end

function TrinityBars2.ActionEditSlider1_OnShow(self)

	if (TrinityBars2ButtonEditor.currFrame) then
		self:SetValue(TrinityBars2ButtonEditor.currFrame.config.action)
		_G[self:GetParent():GetName().."SliderEdit101"]:SetText(TrinityBars2ButtonEditor.currFrame.config.action)
	end
end

function TrinityBars2.ActionEditSlider1_OnValueChanged(self)

	if (TrinityBars2ButtonEditor.currFrame) then
		TrinityBars2ButtonEditor.currFrame.config.action = self:GetValue()
		_G[self:GetParent():GetName().."SliderEdit101"]:SetText(TrinityBars2ButtonEditor.currFrame.config.action)
		TrinityBars2.SetButtonType(TrinityBars2ButtonEditor.currFrame)
		updateAction_OnEvent(TrinityBars2ButtonEditor.currFrame, TrinityBars2ButtonEditor.currFrame.config.action)
	end
end

function TrinityBars2.ActionEditPropagate_OnClick(self)

	if (TrinityBars2ButtonEditor.currFrame) then

		local button, offset, dockFrame, action = nil, nil, TrinityBars2ButtonEditor.currFrame.dockFrame, TrinityBars2ButtonEditor.currFrame.config.action

		for k,v in pairs(dockFrame.buttonList) do

			button = _G[dockFrame.config.btnType..v]

			if (button ~= TrinityBars2ButtonEditor.currFrame) then

				offset = TrinityBars2ButtonEditor.currFrame.config.dockpos - button.config.dockpos

				button.config.action = action - offset

				if (button.config.action < 1) then
					button.config.action = 1
				end

				if (button.config.action > 120) then
					button.config.action = 120
				end

				TrinityBars2.SetButtonType(button)

				updateAction_OnEvent(button, button.config.action)
			end

		end

	end

end

function TrinityBars2.SlotEditSlider1_OnShow(self)

	if (TrinityBars2ButtonEditor.currFrame) then
		self:SetValue(TrinityBars2ButtonEditor.currFrame.config.slot)
		_G[self:GetParent():GetName().."SliderEdit102"]:SetText(TrinityBars2ButtonEditor.currFrame.config.slot)
	end
end

function TrinityBars2.SlotEditSlider1_OnValueChanged(self)

	if (TrinityBars2ButtonEditor.currFrame) then
		TrinityBars2ButtonEditor.currFrame.config.slot = self:GetValue()
		_G[self:GetParent():GetName().."SliderEdit102"]:SetText(TrinityBars2ButtonEditor.currFrame.config.slot)
		TrinityBars2.SetButtonType(TrinityBars2ButtonEditor.currFrame)

		local text = gsub(charSlots[TrinityBars2ButtonEditor.currFrame.config.slot], "Slot", "")

		TrinityBars2ButtonEditorSlotEditSlotString:AddMessage(text..": "..TrinityBars2ButtonEditor.currFrame.config.itemlink)

		--silliness to get the effect I want.
		TrinityBars2ButtonEditorSlotEditSlotStringAnchorText:SetText(text..": "..TrinityBars2ButtonEditor.currFrame.config.itemlink)
		TrinityBars2ButtonEditorSlotEditSlotStringAnchor:SetWidth(TrinityBars2ButtonEditorSlotEditSlotStringAnchorText:GetWidth())
		TrinityBars2ButtonEditorSlotEditSlotStringAnchorText:SetText("")

		updateSlot_OnEvent(TrinityBars2ButtonEditor.currFrame, TrinityBars2ButtonEditor.currFrame.config.item, TrinityBars2ButtonEditor.currFrame.config.itemlink)
		updateSlotCooldown_OnEvent(TrinityBars2ButtonEditor.currFrame, true, TrinityBars2ButtonEditor.currFrame.config.item)

		TrinityBars2.SetButtonType(TrinityBars2ButtonEditor.currFrame)
	end
end

function TrinityBars2.FunctionCounter(functionName)

	if (debugActive) then
		if (TrinityBars2SavedState.debug[functionName]) then
			TrinityBars2SavedState.debug[functionName] = TrinityBars2SavedState.debug[functionName] + 1;
		else
			TrinityBars2SavedState.debug[functionName] = 1;
		end
	end
end

function TrinityBars2.Options_Storage_OnEvent(self, event)

	if (event == "VARIABLES_LOADED") then
		self:SetAttribute("state-stored", "STORED")
		self:SetAttribute("statemap-stored", "STORED:STORED")
		self:SetAttribute("statebindings","STORED:stored")
		optionsDockFrameSetup(self)
	end

	if (event == "PLAYER_LOGIN") then
		tinsert(Trinity2.RegisteredOptions, self)
		InterfaceOptions_AddCategory(self)
	end
end

function TrinityBars2.Options_OnEvent(self, event)

	if (event == "VARIABLES_LOADED") then

	end

	if (event == "PLAYER_LOGIN") then
		local index = #Trinity2.RegisteredAddons+1
		local texture

		texture = "Interface\\MacroFrame\\MacroFrame-Icon"

		Trinity2.RegisteredAddons[index] = {
			"Trinity Bars 2.0",
			"TrinityBars2_EditButton",
			TrinityBars2.ToggleSimpleButtonEditMode,
			texture,
			TRINITYBARS2_STRINGS.TOOLTIP_4,
			nil,
			TrinityBars2.ToggleButtonEditMode,
			Trinity2TemplateManager_TrinityBars2,
		}

		Trinity2.RegisterAddon(index)

		if (TrinityBars2SavedState.buttonLock) then
			texture = "Interface\\Addons\\TrinityBars2\\images\\locked2.tga"
		else
			texture = "Interface\\Addons\\TrinityBars2\\images\\unlocked3.tga"
		end

		Trinity2.RegisteredAddons[index+1] = {
			"dummy",
			"TrinityBars2Options",
			TrinityBars2.ButtonLockMinimapToggle,
			texture,
			TRINITYBARS2_STRINGS.TOOLTIP_1,
			TrinityBars2.ConfigModeOnToggle,
		}

		Trinity2.RegisterAddon(index+1)
		self.index = index+1

		tinsert(Trinity2.RegisteredOptions, self)
		InterfaceOptions_AddCategory(self)
	end
end

function TrinityBars2.MacroEditor_ScrollFrame2Update()

	if (not TrinityBars2ButtonEditor.currFrame) then
		return
	end

	local frame = TrinityBars2ButtonEditorMacroEditScrollFrame2

	local numMacroIcons = GetNumMacroIcons()
	local macroPopupIcon, macroPopupButton, index, texture
	local macroPopupOffset = FauxScrollFrame_GetOffset(frame)

	local macroicon = TrinityBars2ButtonEditor.currFrame.config.macroicon

	TrinityBars2ButtonEditorMacroEditMacroIconIcon:SetTexture(GetMacroIconInfo(macroicon))

	for i=1,30 do
		macroPopupIcon = _G["TrinityBars2ButtonEditorMacroEditButton"..i.."Icon"]
		macroPopupButton = _G["TrinityBars2ButtonEditorMacroEditButton"..i]
		index = (macroPopupOffset * 6) + i
		texture = GetMacroIconInfo(index)
		if ( index <= numMacroIcons ) then
			macroPopupIcon:SetTexture(texture)
			macroPopupButton:Show()
		else
			macroPopupIcon:SetTexture("")
			macroPopupButton:Hide()
		end
		macroPopupButton.iconindex = index
	end

	-- Scrollbar stuff

	FauxScrollFrame_Update(frame, ceil(numMacroIcons/6), 5, 2)

	if (not TrinityBars2ButtonEditorMacroEditMacroIcon.click) then
		frame:Hide()
	end
end

function TrinityBars2.MacroEditor_ScrollFrame3Update()

	if (not TrinityBars2ButtonEditor.currFrame) then
		return
	end

	local frame = TrinityBars2ButtonEditorMacroEditScrollFrame3

	local button, buttonIndex, buttonBody, index, text, body
	local dataOffset = FauxScrollFrame_GetOffset(frame)
	local count = 1
	local data = {}

	for k,v in pairs(TrinityBars2MacroMaster) do
		if (TrinityBars2MacroMaster[k][1] and TrinityBars2MacroMaster[k][1] ~= "") then
			if (find(k, "^%a")) then
				data[count] = k
				count = count + 1
			end
		end
	end

	table.sort(data)

	for i=1,6 do

		count = i+40

		button = _G["TrinityBars2ButtonEditorMacroEditButton"..count]
		button:SetChecked(nil)
		button.tooltip = nil
		button.macro = ""
		button.macroicon = 1
		button.macroname = ""
		button.macronote = ""
		button.macrousenote = false

		buttonIndex = _G["TrinityBars2ButtonEditorMacroEditButton"..count.."MacroIndex"]
		buttonBody = _G["TrinityBars2ButtonEditorMacroEditButton"..count.."MacroBody"]

		index = dataOffset + i

		if (data[index]) then

			button.macro = TrinityBars2MacroMaster[data[index]][1]
			button.macroicon = TrinityBars2MacroMaster[data[index]][2]
			button.macroname = TrinityBars2MacroMaster[data[index]][3]
			button.macronote = TrinityBars2MacroMaster[data[index]][4]
			button.macrousenote = TrinityBars2MacroMaster[data[index]][5]

			buttonIndex:SetText(data[index])
			buttonBody:SetText(button.macro)
			button.tooltip = button.macro

			button:Show()
		else
			button:Hide()
		end
	end

	-- Scrollbar stuff

	count = 7

	if (#data > count) then
		count = #data
	end

	FauxScrollFrame_Update(frame, count, 6, 2)

	if (not TrinityBars2ButtonEditorMacroEditMacroMaster.click) then
		frame:Hide()
	end
end

function TrinityBars2.MacroEditor_OnLoad(self)

	local button, lastButton, rowButton, count, fontString, script = false, false, false, 0, nil, nil

	for i=1,30 do
		button = CreateFrame("CheckButton", self:GetName().."Button"..i, TrinityBars2ButtonEditorMacroEditScrollFrame2, "TrinityBars2MacroButtonTemplate")
		button:SetID(i)
		button:SetFrameLevel(TrinityBars2ButtonEditorMacroEditScrollFrame2:GetFrameLevel()+2)

		if (not lastButton) then
			if (not rowButton) then
				button:SetPoint("TOPLEFT",5,5)
				rowButton = button
			else
				button:SetPoint("TOP", rowButton, "BOTTOM", 0, -10)
				rowButton = button
			end
			lastButton = button
		else
			button:SetPoint("LEFT", lastButton, "RIGHT", 7, 0)
			lastButton = button
		end

		count = count + 1

		if (count == 6) then
			lastButton = false
			count = 0
		end
	end

	lastButton = false
	count = 0

	for i=41,46 do

		button = CreateFrame("CheckButton", self:GetName().."Button"..i, TrinityBars2ButtonEditorMacroEditScrollFrame3, "Trinity2ButtonTemplate3")
		button:SetScript("OnClick",
			function(self)
				local button, buttonIndex, buttonBody
				for i=41,46 do
					button = _G["TrinityBars2ButtonEditorMacroEditButton"..i]
					buttonIndex = _G["TrinityBars2ButtonEditorMacroEditButton"..i.."MacroIndex"]
					buttonBody = _G["TrinityBars2ButtonEditorMacroEditButton"..i.."MacroBody"]
					if (i == self:GetID()) then
						TrinityBars2ButtonEditorMacroEditScrollFrame3.currButton = self
					else
						button:SetChecked(nil)
					end
				end
			end
		)

		fontString = button:CreateFontString(button:GetName().."MacroIndex", "ARTWORK", "GameFontNormalSmall");
		fontString:SetPoint("BOTTOMLEFT", button, "LEFT")
		fontString:SetPoint("TOPRIGHT", button, "TOPRIGHT")
		fontString:SetJustifyH("LEFT")

		fontString = button:CreateFontString(button:GetName().."MacroBody", "ARTWORK", "GameFontNormalSmall");
		fontString:SetPoint("TOPLEFT", button, "LEFT")
		fontString:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT")
		fontString:SetJustifyH("LEFT")
		fontString:SetTextColor(1,1,1)

		button:SetID(i)
		button:SetFrameLevel(TrinityBars2ButtonEditorMacroEditScrollFrame3:GetFrameLevel()+2)

		button:SetWidth(TrinityBars2ButtonEditorMacroEditScrollFrame3:GetWidth()*0.92)
		button:SetHeight(TrinityBars2ButtonEditorMacroEditScrollFrame3:GetHeight()/7)
		button:Show()

		if (not lastButton) then
			button:SetPoint("TOPLEFT",5,-(button:GetHeight()*0.85))
			lastButton = button
		else
			button:SetPoint("TOPLEFT", lastButton, "BOTTOMLEFT", 0, -2)
			lastButton = button
		end
	end
end

function TrinityBars2.MacroEditor_SaveMacro()

	if (not TrinityBars2ButtonEditor.currFrame) then
		return
	end

	if (TrinityBars2ButtonEditor.currFrame.config.macroname == TRINITYBARS2_STRINGS.MACRO_NAME) then
		TrinityBars2ButtonEditor.currFrame.config.macroname = ""
	end

	if (TrinityBars2ButtonEditor.currFrame.config.macronote == TRINITYBARS2_STRINGS.MACRO_EDITNOTE) then
		TrinityBars2ButtonEditor.currFrame.config.macronote = ""
	end

	--local hash = strlen(TrinityBars2ButtonEditor.currFrame.config.macro)*10

	--if (hash > 0) then
	--	for i=1,strlen(TrinityBars2ButtonEditor.currFrame.config.macro) do
	--		hash = hash + string.byte(string.sub(TrinityBars2ButtonEditor.currFrame.config.macro, i))
	--	end
	--end

	local key = GetRealmName()..":"..UnitName("player")..":"..TrinityBars2ButtonEditor.currFrame.id


	if (key) then
		--hash = upper(format("%.6x", hash))
		TrinityBars2MacroMaster[key] = {
			TrinityBars2ButtonEditor.currFrame.config.macro,
			TrinityBars2ButtonEditor.currFrame.config.macroicon,
			TrinityBars2ButtonEditor.currFrame.config.macroname,
			TrinityBars2ButtonEditor.currFrame.config.macronote,
			TrinityBars2ButtonEditor.currFrame.config.macrousenote,
		}

	end

	TrinityBars2.SetButtonType(TrinityBars2ButtonEditor.currFrame)

	local onEvent = TrinityBars2ButtonEditor.currFrame:GetScript("OnEvent")
	onEvent(TrinityBars2ButtonEditor.currFrame, "PLAYER_ENTERING_WORLD")

end

function TrinityBars2.SetCheckButtonOption_OnEvent(self)


end

function TrinityBars2.SetCheckButtonOption_OnClick(self)

	TrinityBars2SavedState.options["CheckButtons"][self:GetID()] = self:GetChecked()
	checkButtons[self:GetID()] = self:GetChecked()

end

function TrinityBars2.DockFrameOptionsTransitions_OnEvent(self, event, ...)

	if (UnitClass("player") == TRINITYBARS2_STRINGS.DRUID or UnitClass("player") == TRINITYBARS2_STRINGS.HUNTER) then

		local func = function()

			Trinity2.EditBox_PopUpInitialize(Trinity2DockFrameOptionsTransitionsOpt1Edit1.popup, Trinity2DockFrameOptions.currFrame.config.pagingTrans, nil)
			Trinity2.EditBox_PopUpInitialize(Trinity2DockFrameOptionsTransitionsOpt1Edit2.popup, Trinity2DockFrameOptions.currFrame.config.pagingTrans, nil)

			if (UnitClass("player") == TRINITYBARS2_STRINGS.HUNTER) then

				if (Trinity2DockFrameOptions.currFrame and Trinity2DockFrameOptions.currFrame:GetID() == dedBars.class) then

					local data = {
						["No Page"] = "No Page",
					}

					for k,v in pairs(Trinity2DockFrameOptions.currFrame.config.pagingTrans) do
						data[k] = v
					end

					Trinity2.EditBox_PopUpInitialize(Trinity2DockFrameOptionsTransitionsOpt2Edit1.popup, Trinity2DockFrameOptions.currFrame.config.stanceTrans, nil)
					Trinity2.EditBox_PopUpInitialize(Trinity2DockFrameOptionsTransitionsOpt2Edit2.popup, data, nil)

					Trinity2DockFrameOptionsTransitionsOpt2:Show()
					Trinity2DockFrameOptionsTransitions:SetHeight(143)
				else
					Trinity2DockFrameOptionsTransitionsOpt2:Hide()
					Trinity2DockFrameOptionsTransitions:SetHeight(76)
				end
			else
				Trinity2.EditBox_PopUpInitialize(Trinity2DockFrameOptionsTransitionsOpt2Edit1.popup, Trinity2DockFrameOptions.currFrame.config.stanceTrans, nil)
				Trinity2.EditBox_PopUpInitialize(Trinity2DockFrameOptionsTransitionsOpt2Edit2.popup, Trinity2DockFrameOptions.currFrame.config.stanceTrans, nil)

				Trinity2DockFrameOptionsTransitionsOpt2:Show()
				Trinity2DockFrameOptionsTransitions:SetHeight(143)
			end
		end

		Trinity2.OptionSets[6] = { Trinity2DockFrameOptionsTransitions, 3, 2, func}
		Trinity2DockFrameOptionsTransitionsOpt2:Hide()
		Trinity2DockFrameOptionsTransitions:SetHeight(76)
	else
		local func = function()
			Trinity2.EditBox_PopUpInitialize(Trinity2DockFrameOptionsTransitionsOpt1Edit1.popup, Trinity2DockFrameOptions.currFrame.config.pagingTrans, nil)
			Trinity2.EditBox_PopUpInitialize(Trinity2DockFrameOptionsTransitionsOpt1Edit2.popup, Trinity2DockFrameOptions.currFrame.config.pagingTrans, nil)
		end

		Trinity2.OptionSets[6] = { Trinity2DockFrameOptionsTransitions, 3, 2, func}
		Trinity2DockFrameOptionsTransitionsOpt2:Hide()
		Trinity2DockFrameOptionsTransitions:SetHeight(76)
	end
end

function TrinityBars2.DockFrameOptionsTransitionsOpt1Edit1_OnTextChanged(self)

	if (Trinity2DockFrameOptions.currFrame) then

		local pagingTrans = Trinity2DockFrameOptions.currFrame.config.pagingTrans

		if (pagingTrans) then
			if (pagingTrans[self:GetText()]) then
				Trinity2DockFrameOptionsTransitionsOpt1Edit2:SetText(pagingTrans[self:GetText()])
			end
		end
	end

end

function TrinityBars2.DockFrameOptionsTransitionsOpt1Edit2_OnTextChanged(self)

	if (Trinity2DockFrameOptions.currFrame) then

		local pagingTrans = Trinity2DockFrameOptions.currFrame.config.pagingTrans
		local page = Trinity2DockFrameOptionsTransitionsOpt1Edit1:GetText()

		if (pagingTrans) then
			if (pagingTrans[page]) then
				Trinity2DockFrameOptions.currFrame.config.pagingTrans[page] = self:GetText()
			end
		end
	end
end

function TrinityBars2.DockFrameOptionsTransitionsOpt2Edit1_OnTextChanged(self)

	if (Trinity2DockFrameOptions.currFrame) then

		local stanceTrans = Trinity2DockFrameOptions.currFrame.config.stanceTrans

		if (stanceTrans) then
			if (stanceTrans[self:GetText()]) then
				Trinity2DockFrameOptionsTransitionsOpt2Edit2:SetText(stanceTrans[self:GetText()])
			end
		end
	end

end

function TrinityBars2.DockFrameOptionsTransitionsOpt2Edit2_OnTextChanged(self)

	if (Trinity2DockFrameOptions.currFrame) then

		local stanceTrans = Trinity2DockFrameOptions.currFrame.config.stanceTrans
		local stance = Trinity2DockFrameOptionsTransitionsOpt2Edit1:GetText()

		if (stanceTrans) then
			if (stanceTrans[stance]) then
				Trinity2DockFrameOptions.currFrame.config.stanceTrans[stance] = self:GetText()
			end
		end
	end
end


-- Blizzard functions hooked and modified
function TrinityBars2.UpdateContainerFrameAnchors()

	if (checkButtons[207]) then

		if (not TrinityBars2SavedState.containerScale) then
			TrinityBars2SavedState.containerScale = 1
		end

		local frame, xOffset, yOffset, screenHeight, freeScreenHeight, leftMostPoint, column;
		local screenWidth = GetScreenWidth();
		local containerScale = 1;
		local leftLimit = 0;

		if ( BankFrame:IsShown() ) then
			leftLimit = BankFrame:GetRight() - 25;
		end

		if (TrinityBars2SavedState.containerScale == 1) then

			while ( containerScale > CONTAINER_SCALE ) do
				screenHeight = GetScreenHeight() / containerScale;
				-- Adjust the start anchor for bags depending on the multibars
				xOffset = CONTAINER_OFFSET_X / containerScale;
				yOffset = CONTAINER_OFFSET_Y / containerScale;
				-- freeScreenHeight determines when to start a new column of bags
				freeScreenHeight = screenHeight - yOffset;
				leftMostPoint = screenWidth - xOffset;
				column = 1;
				local frameHeight;
				for index, frameName in ipairs(ContainerFrame1.bags) do
					frameHeight = _G[frameName]:GetHeight();
					if ( freeScreenHeight < frameHeight ) then
						-- Start a new column
						column = column + 1;
						leftMostPoint = screenWidth - ( column * CONTAINER_WIDTH * containerScale ) - xOffset;
						freeScreenHeight = screenHeight - yOffset;
					end
					freeScreenHeight = freeScreenHeight - frameHeight - VISIBLE_CONTAINER_SPACING;
				end
				if ( leftMostPoint < leftLimit ) then
					containerScale = containerScale - 0.01;
				else
					break;
				end
			end

			if ( containerScale < CONTAINER_SCALE ) then
				containerScale = CONTAINER_SCALE;
			end
		else
			containerScale = TrinityBars2SavedState.containerScale
		end

		screenHeight = GetScreenHeight() / containerScale;
		xOffset = TrinityBars2SavedState.containerOffsetX / containerScale;
		yOffset = TrinityBars2SavedState.containerOffsetY / containerScale;
		freeScreenHeight = screenHeight - yOffset;
		column = 0;

		for index, frameName in ipairs(ContainerFrame1.bags) do
			frame = _G[frameName]
			frame:SetScale(containerScale)
			frame:ClearAllPoints()
			if ( index == 1 ) then
				-- First bag
				frame:SetPoint("BOTTOMRIGHT", frame:GetParent(), "BOTTOMRIGHT", -xOffset, yOffset )
			elseif ( freeScreenHeight < frame:GetHeight() ) then
				-- Start a new column
				column = column + 1;
				freeScreenHeight = screenHeight - yOffset;
				frame:SetPoint("BOTTOMRIGHT", frame:GetParent(), "BOTTOMRIGHT", -(column * CONTAINER_WIDTH) - xOffset, yOffset )
			else
				-- Anchor to the previous bag
				frame:SetPoint("BOTTOMRIGHT", ContainerFrame1.bags[index - 1], "TOPRIGHT", 0, CONTAINER_SPACING)
			end
			freeScreenHeight = freeScreenHeight - frame:GetHeight() - VISIBLE_CONTAINER_SPACING;
		end
	end
end

function TrinityBars2.SpellButton_OnModifiedClick(button)

	local id = SpellBook_GetSpellID(this:GetID())
	if ( id > MAX_SPELLS ) then
		return;
	end

	if (CursorHasSpell() and TrinityBars2ButtonEditorMacroEdit:IsVisible() ) then
		ClearCursor()
	end

	if ( IsModifiedClick("CHATLINK") ) then
		if ( TrinityBars2ButtonEditorMacroEdit:IsVisible() ) then
			local spellName, subSpellName = GetSpellName(id, SpellBookFrame.bookType);
			if ( spellName and not IsPassiveSpell(id, SpellBookFrame.bookType) ) then
				if ( subSpellName and (strlen(subSpellName) > 0) ) then
					TrinityBars2.InsertLink(spellName.."("..subSpellName..")")
				else
					TrinityBars2.InsertLink(spellName)
				end
			end
			return;
		end
	end

	if ( IsModifiedClick("PICKUPACTION") ) then
		PickupSpell(id, SpellBookFrame.bookType);
		return;
	end
end

function TrinityBars2.ItemButton_OnModifiedClick(link)

	if ( IsModifiedClick("CHATLINK") ) then
		if ( TrinityBars2ButtonEditorMacroEdit:IsVisible() ) then
			local itemName = GetItemInfo(link)
			if (itemName) then
				TrinityBars2.InsertLink(itemName)
			end
			return true
		end
	end
end

function TrinityBars2.OpenStackSplitFrame(maxStack, parent, anchor, anchorTo)

	if ( TrinityBars2ButtonEditorMacroEdit:IsVisible() ) then
		StackSplitFrame:Hide()
	end
end

function TrinityBars2.InsertLink(text)

	local item = GetItemInfo(text)

	if ( TrinityBars2ButtonEditorMacroEditScrollFrame1Edit1:GetText() == "" ) then
		if ( item ) then
			if ( GetItemSpell(text) ) then
				TrinityBars2ButtonEditorMacroEditScrollFrame1Edit1:Insert(SLASH_USE1.." "..item)
			else
				TrinityBars2ButtonEditorMacroEditScrollFrame1Edit1:Insert(SLASH_EQUIP1.." "..item)
			end
		else
			TrinityBars2ButtonEditorMacroEditScrollFrame1Edit1:Insert(SLASH_CAST1.." "..text)
		end
	else
		TrinityBars2ButtonEditorMacroEditScrollFrame1Edit1:Insert(item or text)
	end
end

local SavedUpdateTalentButton = UpdateTalentButton;
function TrinityUpdateTalentButton()

	if ( UnitLevel("player") < 10 ) then
		TalentMicroButton:Hide()
	else
		TalentMicroButton:Show()
	end
end
UpdateTalentButton = TrinityUpdateTalentButton


function TrinityQueryCastSequence(sequence)
	--DEFAULT_CHAT_FRAME:AddMessage(sequence)
end