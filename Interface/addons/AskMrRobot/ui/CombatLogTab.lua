local _, AskMrRobot = ...

-- initialize the ExportTab class
AskMrRobot.CombatLogTab = AskMrRobot.inheritsFrom(AskMrRobot.Frame)

-- helper to create text for this tab
local function CreateText(tab, font, relativeTo, xOffset, yOffset, text)
    local t = tab:CreateFontString(nil, "ARTWORK", font)
	t:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", xOffset, yOffset)
	t:SetPoint("RIGHT", tab, "RIGHT", -25, 0)
	t:SetWidth(t:GetWidth())
	t:SetJustifyH("LEFT")
	t:SetText(text)
    
    return t
end

function AskMrRobot.CombatLogTab:new(parent)

	local tab = AskMrRobot.Frame:new(nil, parent)	
	setmetatable(tab, { __index = AskMrRobot.CombatLogTab })
	tab:SetPoint("TOPLEFT")
	tab:SetPoint("BOTTOMRIGHT")
	tab:Hide()

	local text = tab:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	text:SetPoint("TOPLEFT", 0, -5)
	text:SetText("Combat Logging")
    
    text = CreateText(tab, "GameFontRedLarge", text, 0, -15, "ALPHA TEST: this is a preview of Mr. Robot's in-game features for his upcoming combat logging tool.  You can't actually upload a log on the site yet!")
        
    local btn = CreateFrame("Button", "AmrCombatLogStart", tab, "UIPanelButtonTemplate")
	btn:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -15)
	btn:SetText("Start Logging")
	btn:SetWidth(120)
	btn:SetHeight(30)
    tab.btnStart = btn
    
    btn:SetScript("OnClick", function()
        tab:StartLogging()
    end)
    
    btn = CreateFrame("Button", "AmrCombatLogEnd", tab, "UIPanelButtonTemplate")
	btn:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 150, -15)
	btn:SetText("Stop Logging")
	btn:SetWidth(120)
	btn:SetHeight(30)
    tab.btnEnd = btn
    
    btn:SetScript("OnClick", function()
        tab:StopLogging()
    end)
    
    text = CreateText(tab, "GameFontNormalLarge", text, 0, -80, "INSTRUCTIONS")
    text = CreateText(tab, "GameFontWhite", text, 0, -15, "1. Press 'Start Logging' to begin logging combat data.")
    text = CreateText(tab, "GameFontWhite", text, 0, -15, "2. When your raid or dungeon is complete, press 'Stop Logging'.")
    text = CreateText(tab, "GameFontWhite", text, 0, -15, "3. Copy the text below by pressing Ctrl+C (or Cmd+C on a Mac).")
    
	local txtExportString = CreateFrame("ScrollFrame", "AmrScrollFrame", tab, "InputScrollFrameTemplate")
	txtExportString:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 12, -10)
	txtExportString:SetPoint("RIGHT", -25, 0)
	txtExportString:SetWidth(txtExportString:GetWidth())
	txtExportString:SetHeight(50)
	txtExportString.EditBox:SetWidth(txtExportString:GetWidth())
    txtExportString.EditBox:SetMaxLetters(0)
	txtExportString.CharCount:Hide()
	tab.txtExportString = txtExportString

    text = CreateText(tab, "GameFontWhite", txtExportString, -12, -20, "4. Go to AskMrRobot.com and paste into the Character Data box when you upload your log.")
    
    -- when we start up, ensure that logging is still enabled if it was enabled when they last used the addon
    if (tab:IsLogging()) then
        SetCVar("advancedCombatLogging", 1)
        LoggingCombat(true)
    end
    
    tab:SetScript("OnShow", function()
        tab:Update()
	end)

    return tab
end

function AskMrRobot.CombatLogTab:IsLogging()
    return AmrLogData["_logging"] == true
end

function AskMrRobot.CombatLogTab:StartLogging()
    -- reset data with the start of a new logging session
    AmrLogData = {}
    AmrLogData["_logging"] = true
    
    -- always enable advanced combat logging via our addon, gathers more detailed data for better analysis
    SetCVar("advancedCombatLogging", 1)
    
    LoggingCombat(true)
    self:Update()
    
    print("You are now logging combat, and Mr. Robot is logging character data for your raid.")
end

function AskMrRobot.CombatLogTab:StopLogging()
    LoggingCombat(false)
    AmrLogData["_logging"] = false
    self:Update()
    
    print("Combat logging has been stopped.")
end

-- update the panel and state
function AskMrRobot.CombatLogTab:Update()
    local isLogging = self:IsLogging()
    
    if isLogging then
        self.btnStart:Disable()
        self.btnEnd:Enable()
        self.txtExportString.EditBox:SetText("")
    else
        self.btnStart:Enable()
        self.btnEnd:Disable()
        
        -- generate a map of unique setups used by each character
        local setupsByName = {}
        local setupIdCounter = 1
        
        -- generate a single copy/paste blob from all of the character info that has been saved
        local str = {}
        for name, timeList in AskMrRobot.spairs(AmrLogData) do
            if name ~= "_logging" and name ~= "_previousSetup" then
                setupsByName[name] = {}
                for timestamp, dataString in AskMrRobot.spairs(timeList) do
                    local setupId = setupsByName[name][dataString]
                    
                    -- this is the first time we have encountered this setup
                    if (setupId == nil) then
                        setupsByName[name][dataString] = setupIdCounter
                        setupId = setupIdCounter
                        setupIdCounter = setupIdCounter + 1
                    end
                    
                    local line = timestamp .. ";" .. name .. ";" .. setupId
                    table.insert(str, line)
                end
            end
        end
        
        -- now put the setup map into the data
        for name, setupList in AskMrRobot.spairs(setupsByName) do
            for setup, id in AskMrRobot.spairs(setupList) do
                table.insert(str, "m__" .. name .. "__" .. id .. "__" .. setup)
            end
        end
        
        self.txtExportString.EditBox:SetText(table.concat(str, "\n"))
        self.txtExportString.EditBox:HighlightText()
        self.txtExportString.EditBox:SetFocus()
    end
end

-- read a message sent to the addon channel with a player's info at the time an encounter started
function AskMrRobot.CombatLogTab:ReadAddonMessage(message)

    -- message will be of format: timestamp\nrealm\nname\n[stuff]
    local parts = {}
	for part in string.gmatch(message, "([^\n]+)") do
		tinsert(parts, part)
	end
    
    local timestamp = parts[1]
    local name = parts[2] .. ":" .. parts[3]
    local data = parts[4]
    
    if (data == "done") then
        -- we have finished receiving this message; now process it to reduce the amount of duplicate data
        local setup = AmrLogData[name][timestamp]
        
        if (AmrLogData["_previousSetup"] == nil) then
            AmrLogData["_previousSetup"] = {}
        end
        
        local previousSetup = AmrLogData["_previousSetup"][name]
        
        if (previousSetup == setup) then
            -- if the last-seen setup for this player is the same as the current one, we don't need this entry
            AmrLogData[name][timestamp] = nil
        else
            -- record the last-seen setup
            AmrLogData["_previousSetup"][name] = setup
        end
    else
        -- concatenate messages with the same timestamp+name
        if (AmrLogData[name] == nil) then
            AmrLogData[name] = {}
        end
        
        if (AmrLogData[name][timestamp] == nil) then
            AmrLogData[name][timestamp] = data
        else
            AmrLogData[name][timestamp] = AmrLogData[name][timestamp] .. data
        end
    end
end
