GuildBankRepairToggle = LibStub("AceAddon-3.0"):NewAddon("GuildBankRepairToggle", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")

-- Keep track of if we've enabled or disabled repairs for the toggle command.
local isEnabled = false;

-- Table of guild ranks and their settings. The default is false.
local defaultRanks = {}
for i = 1, GuildControlGetNumRanks() do
	table.insert(defaultRanks, i, false)
end

-- Defaults
local defaults = {
    char = {
        amount = "100",
		ranks = defaultRanks,
		announce = true,
		timer = "5",
		logout = false,
    },
}

-- create the options list
local options = {
    name = "GuildBankRepairToggle",
    handler = GuildBankRepairToggle,
    type = 'group',
    args = {
        enable = {
            type = "execute",
            name = "Enable Repairs",
            desc = "Enable guild bank repairs for all configured ranks.",
            func = "EnableRepairs",
			order = 1,
        },
        disable = {
            type = "execute",
            name = "Disable Repairs",
            desc = "Disable guild bank repairs for all configured ranks.",
            func = "DisableRepairs",
			order = 2,
        },
        toggle = {
            type = "execute",
            name = "Toggle Repairs",
            desc = "Toggle Repairs on/off (switches the state)",
            func = "ToggleRepairsCommand",
			order = 3,
			guiHidden = true,
        },
        setlimit = {
            type = "execute",
            name = "Set Repair Limit",
            desc = "Resets guild bank repair/withdrawl limits to defined amount for all selected ranks.",
            func = "SetRepairLimit",
			order = 6,
        },
        gui = {
            type = "execute",
            name = "Show GUI",
            desc = "Show the options GUI.",
            func = "ShowGUI",
			guiHidden = true,
        },
        amount = {
            type = "input",
            name = "Repair Amount",
            desc = "Maximum amount of repairs, in gold.",
            usage = "<Gold>",
            get = "GetRepairAmount",
            set = "SetRepairAmount",
			validate = "ValidateRepairAmount",
			order = 5,
        },
        announce = {
            type = "toggle",
            name = "Announce to Group",
            desc = "If enabled, will announce repairs to the raid.",
            get = "GetAnnounce",
            set = "SetAnnounce",
			order = 4,
        },
        ranks = {
            type = "multiselect",
            name = "Repair Ranks",
            desc = "Ranks that repairs should be turned on for, when Enable is presed. All others will be disabled.",
            values = "GetRanks",
            get = "GetRankState",
            set = "SetRankState",
			cmdHidden = true,
			order = 3,
        },
		timer = {
            type = "input",
            name = "Disable Repairs timer",
            desc = "Time to close the guild bank, in minutes.",
            usage = "<Minutes>",
            get = "GetTimerMinutes",
            set = "SetTimerMinutes",
			validate = "ValidateRepairAmount",
			order = 8,
        },
		starttimer = {
            type = "execute",
            name = "Start Timer",
            desc = "Starts the timer to disable repairs after a delay. The delay is set with the timer option.",
            func = "StartTimer",
			order = 9,
        },
        logout = {
            type = "toggle",
            name = "Disable repairs on logout",
            desc = "If enabled, will disable guild bank repairs when you log out.",
            get = "GetLogout",
            set = "SetLogout",
			order = 7,
			width = "full",
        },
    },
}


-- Store the logout and exit functions so we can call them again
local blizzLogout = Logout
local blizzQuit = Quit

function GuildBankRepairToggle:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("GuildBankRepairToggleDB", defaults, "Default")
    LibStub("AceConfig-3.0"):RegisterOptionsTable("GuildBankRepairToggle", options, {"guildbankrepairtoggle", "repairtoggle"})
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GuildBankRepairToggle", "GuildBankRepairToggle")
	self:RegisterMessage("GuildBankRepairToggle_Logout", "LogoutEvent")
	self:RegisterMessage("GuildBankRepairToggle_Quit", "QuitEvent")
end

-- Called when the user logs out of the game. Do the logout stuff, then call the Blizzard logout code.
function Logout()
	LibStub("AceEvent-3.0"):SendMessage("GuildBankRepairToggle_Logout")
	blizzLogout()
end

-- Called by the addon's logout message. 
function GuildBankRepairToggle:LogoutEvent()
	if self:GetLogout() then
		self:ToggleRepairs(false)
	end
end

-- Called when the user exits the game. Do the logout stuff, then call the Blizzard exit code.
function Quit()
	LibStub("AceEvent-3.0"):SendMessage("GuildBankRepairToggle_Quit")
	blizzQuit()
end

-- Called by the addon's quit message. 
function GuildBankRepairToggle:QuitEvent()
	if self:GetLogout() then
		self:ToggleRepairs(false)
	end
end

function GuildBankRepairToggle:OnEnable()
    -- Called when the addon is enabled
end

function GuildBankRepairToggle:OnDisable()
    -- Called when the addon is disabled
end

function GuildBankRepairToggle:EnableRepairs()
	self:ToggleRepairs(true)
	self:Print("Repairs enabled.")
end

function GuildBankRepairToggle:DisableRepairs()
	self:ToggleRepairs(false)
	self:Print("Repairs Disabled.")
end

function GuildBankRepairToggle:ToggleRepairsCommand()
	isEnabled = not isEnabled
	self:ToggleRepairs(isEnabled)
	if isEnabled then
		self:Print("Repairs Enabled.")
	else
		self:Print("Repairs Disabled.")	
	end
end

-- Set the repair/withdrawl limit for every selected rank.
-- Selected ranks come from the ranks list.
function GuildBankRepairToggle:SetRepairLimit()
    for i,v in pairs(self.db.char.ranks) do
	if v then
	    GuildControlSetRank(i)
	    SetGuildBankWithdrawGoldLimit(self.db.char.amount)
	    GuildControlSaveRank(GuildControlGetRankName(i))
	end
    end
    self:Print("Withdrawl amounts reset to " .. self.db.char.amount)
end

function GuildBankRepairToggle:GetRepairAmount(info)
    return self.db.char.amount
end

function GuildBankRepairToggle:SetRepairAmount(info, newValue)
    self.db.char.amount = newValue
end

function GuildBankRepairToggle:GetAnnounce(info)
    return self.db.char.announce
end

function GuildBankRepairToggle:SetAnnounce(info, newValue)
    self.db.char.announce = newValue
end

function GuildBankRepairToggle:GetLogout(info)
    return self.db.char.logout
end

function GuildBankRepairToggle:SetLogout(info, newValue)
    self.db.char.logout = newValue
end

function GuildBankRepairToggle:GetTimerMinutes(info)
    return self.db.char.timer
end

function GuildBankRepairToggle:SetTimerMinutes(info, newValue)
    self.db.char.timer = newValue
end

function GuildBankRepairToggle:ValidateRepairAmount(info, newValue)
     return tonumber(newValue) >= 0;
end

function GuildBankRepairToggle:ShowGUI()
    InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
end

-- Get the rank table for the GUI options.
-- Ranks in the settings are stored as index and true/false for enabled/disabled.
-- In the GUI we want names, so we create a new table with the rank names.
function GuildBankRepairToggle:GetRanks(info)
    local returnRanks = {}
    for i = 1, GuildControlGetNumRanks() do
	table.insert(returnRanks, i, GuildControlGetRankName(i))
    end
    return returnRanks
end

-- Set the value of the rank to what they selected.
-- Value is the key, state is the value.
function GuildBankRepairToggle:SetRankState(info, value, state)
    self.db.char.ranks[value] = state
end

-- Get the setting of a rank. Value in this case is the rank's index.
function GuildBankRepairToggle:GetRankState(info, value)
    return self.db.char.ranks[value]
end


-- Toggle repairs for all selected ranks.
-- State is the repair state (true/false).
function GuildBankRepairToggle:ToggleRepairs(state)
   -- 15 is the option to set repairs or not
   for i,v in pairs(self.db.char.ranks) do
	if v then
	    GuildControlSetRank(i)
	    GuildControlSetRankFlag(15, state)
	    -- There's a weird case where the withdraw limit gets set to 100,000 if you don't touch it. This tries to prevent that.
	    SetGuildBankWithdrawGoldLimit(GetGuildBankWithdrawGoldLimit())
	    GuildControlSaveRank(GuildControlGetRankName(i))
	    -- Announce to the raid if set
	    if self.db.char.announce then
		if state then
			SendChatMessage("Guild Bank Repairs enabled for " .. GuildControlGetRankName(i) ,"GUILD");
		else
			SendChatMessage("Guild Bank Repairs disabled for " .. GuildControlGetRankName(i) ,"GUILD");
		end
	    end
	end
    end
end


-- Start the timer
function GuildBankRepairToggle:StartTimer()
	self:ScheduleTimer("ToggleRepairs", self:GetTimerMinutes() * 60, false)
	SendChatMessage("Guild Bank Repairs will be disabled in " .. self:GetTimerMinutes() .. " minutes." ,"GUILD");
end