if not Skada or not EnsidiaFails then return end
local fail, Skada = EnsidiaFails, Skada
local L = LibStub("AceLocale-3.0"):GetLocale("LibFail-MoP", false)
local lf = LibStub("LibFail-MoP")

-- legacy support
local failCata, LC, lfCata, cata_fail_events
if EnsidiaFailsCataclysm then
	failCata = EnsidiaFailsCataclysm
	LC = LibStub("AceLocale-3.0"):GetLocale("LibFail-2.0", false)
	lfCata = LibStub("LibFail-2.0")
	cata_fail_events = lfCata:GetSupportedEvents()
end

local mod = Skada:NewModule("EnsidiaFails")
local playermod = Skada:NewModule("EnsidiaFailsModePlayerView")
local eventmod = Skada:NewModule("EnsidiaFailsModeEventView")

-- Disable the default Fail module
-- ohh well guess this only works for svn checkout since the default module gets loaded later :S
if Skada.modules.Fails then
	Skada.modules.Fails.enabledState = false
end

local fail_events = lf:GetSupportedEvents()

function mod:AddToTooltip(set, tooltip)
 	GameTooltip:AddDoubleLine(L["Fails"], set.effails, 1,1,1)
end

function mod:GetSetSummary(set)
	return set.effails
end

-- Called by Skada when a new player is added to a set.
function mod:AddPlayerAttributes(player)
	if not player.effails then
		player.effails = 0
		player.effailevents = {}
	end
end

-- Called by Skada when a new set is created.
function mod:AddSetAttributes(set)
	if not set.effails then
		set.effails = 0
	end
end

local function onFail(event, who, failType, ...)
	if event and who then
		-- Always log to Total set. Current only if we are active.
		-- Idea: let modes force-start a set, so we can get a set
		-- for these things.
		local eventName = lf:GetEventName(event) or ""
		if EnsidiaFailsCataclysm and eventName == "" then
			eventName = lfCata:GetEventName(event) or ""
		end
		if Skada.current then
			local unitGUID = UnitGUID(who)
			local player = Skada:get_player(Skada.current, unitGUID, who)
			player.effails = player.effails + 1

			if player.effailevents[eventName] then
				player.effailevents[eventName] = player.effailevents[eventName] + 1
			else
				player.effailevents[eventName] = 1
			end
			Skada.current.effails = Skada.current.effails + 1
		end

		if Skada.total then
			local unitGUID = UnitGUID(who)
			local player = Skada:get_player(Skada.total, unitGUID, who)
			player.effails = player.effails + 1

			if player.effailevents[eventName] then
				player.effailevents[eventName] = player.effailevents[eventName] + 1
			else
				player.effailevents[eventName] = 1
			end
			Skada.total.effails = Skada.total.effails + 1
		end
	end
end

for _, event in ipairs(fail_events) do
	fail.RegisterCallback("SkadaEnsidiaFails", event, onFail)
end

if EnsidiaFailsCataclysm then
	for _, event in ipairs(cata_fail_events) do
		failCata.RegisterCallback("SkadaEnsidiaFailsCataclysm", event, onFail)
	end
end

function mod:Update(win, set)
	local nr = 1
	local max = 0
	for i, player in ipairs(set.players) do
		if player.effails > 0 then

			local d = win.dataset[nr] or {}
			win.dataset[nr] = d

			d.id = player.id
			d.value = player.effails
			d.label = player.name
			d.class = player.class
			d.valuetext = tostring(player.effails)

			if player.effails > max then
				max = player.effails
			end

			nr = nr + 1
		end
	end

	win.metadata.maxvalue = max
end

function playermod:Enter(win, id, label)
	playermod.playerid = id
	playermod.title = label..L["'s Fails"]
end

function eventmod:Enter(win, id, label)
	eventmod.playerid = id
	eventmod.title = label..L["'s Failers"]
end

-- Detail view of an event.
function eventmod:Update(win, set)
	if win.selectedmode then
		local event = win.selectedmode.playerid

		local nr = 1
		local max = 0
		for i=1, #set.players do
			if set.players[i].effailevents[event] then
				local d = win.dataset[nr]
				d.id = set.players[i].name
				d.label = set.players[i].name
				d.value = set.players[i].effailevents[event]
				d.valuetext = set.players[i].effailevents[event]
				d.class = set.players[i].class

				if set.players[i].effailevents[event] > max then
					max = set.players[i].effailevents[event]
				end

				nr = nr + 1
			end
		end

		win.metadata.maxvalue = max
	end
end

-- Detail view of a player.
function playermod:Update(win, set)
	local player = Skada:find_player(set, self.playerid)
	local nr = 1
	if player then
		for event, fails in pairs(player.effailevents) do
			local d = win.dataset[nr] or {}
			win.dataset[nr] = d

			d.id = event
			d.value = fails
			d.label = event
			d.valuetext = fails

			nr = nr + 1
		end
	end

	win.metadata.maxvalue = player.effails
end

function mod:OnEnable()
	mod.metadata 		= {click1 = playermod, showspots = true}
	playermod.metadata 	= {click1 = eventmod, showspots = true}
	eventmod.metadata 	= {}

	Skada:AddMode(self)
end

function mod:OnDisable()
	Skada:RemoveMode(self)
end
