local addon_name = "hagakure_cooldowns"
HCoold = LibStub("AceAddon-3.0"):NewAddon(addon_name,"AceEvent-3.0","AceTimer-3.0")
HCoold.name = addon_name
do -- turn on debug mod
	HCoold.debug = true
	local name = UnitName("Player")
	local plist = { "Лиззэ", "Калдох" } -- "Лиззэ", "Калдох", "Эллиандрессе", 
	if HCoold.debug then
		HCoold.debug = false
		for _, i in next, plist do if i == name then HCoold.debug = true end end
	end
end

function HCoold:GetLocale()
	local L  = LibStub("AceLocale-3.0"):GetLocale(HCoold.name,true)
	if not L then
		L = {}
		setmetatable(L,{
			__index =  function (table_,key)
				return key
			end,
		})
	end
	return L
end
local L = HCoold:GetLocale()

--[[
DEFAULT_CHAT_FRAME
GetRaidRosterInfo
--]]

local conf = {
	group = {
		h = 20,
	},
	spell = {
		w = 150,
	},
	icon = {
		w = 16,
	},
	text = {
		w = 130,
		big_w = 200,
	},
	types = {
		[1] = {
			top = 700,
			left = 228,
			point = "BOTTOMLEFT",
			w = 120,
			sm = 1,
			enable = true,
		},
		[2] = {
			top = 700,
			left = 334,
			point = "BOTTOMLEFT",
			w = 120,
			sm = 1,
			enable = true,
		},
		[3] = {
			top = 700,
			left = 440,
			point = "BOTTOMLEFT",
			w = 120,
			sm = 1,
			enable = true,
		},
		[4] = {
			top = 700,
			left = 549,
			point = "BOTTOMLEFT",
			w = 120,
			sm = 1,
			enable = true,
		},
		[5] = {
			top = 700,
			left = 659,
			point = "BOTTOMLEFT",
			w = 120,
			sm = 1,
			enable = true,
		},
		[6] = {
			top = 700,
			left = 773,
			point = "BOTTOMLEFT",
			w = 120,
			sm = 1,
			enable = true,
		},
		[7] = {
			top = 700,
			left = 878,
			point = "BOTTOMLEFT",
			w = 120,
			sm = 1,
			enable = true,
		},
		[8] = {
			top = 700,
			left = 989,
			point = "BOTTOMLEFT",
			w = 120,
			sm = 1,
			enable = false,
		},
		[9] = {
			top = 700,
			left = 1089,
			point = "BOTTOMLEFT",
			w = 120,
			sm = 1,
			enable = false,
		},
		[10] = {
			top = 700,
			left = 1200,
			point = "BOTTOMLEFT",
			w = 120,
			sm = 1,
			enable = false,
		},
	},
	timer_delay = 1,
	timer_fast_delay = 0.1,
	timer_min_diff = 15,
	timer_uncombat_delay = 15,
	group_track = 5,
	raid_only = true,
	color = {
		active = "|cffff0000",
		cd = "|caaaaaaaa",
		supergood = "|cffff00ff",
		good = "|cff00ff00",
		bad = "|cff00ffff",
		offline = "|ca0000000",
		dead = "|ca0b0b0ff",
	},
	bars = {
		cd_color = {
			r = 0.4,
			g = 0.4,
			b = 0.4,
			a = 0.9,
		},
		cast_color = {
			r = 0,
			g = 1,
			b = 0,
			a = 1,
		},
		bg_color = {
			r = 0.5,
			g = 0.5,
			b = 0.5,
			a = 0.3,
		},
		texture = "Charcoal",
		enable = false,
		bgenable = false,
	},
	font = {
		size = 14,
		name = "Arial Narrow",
		big_size = 30,
	},
	server_names = false,
	tooltip_spells = false,
	tooltip_active_spells = false,
	auto_scan_talents = true,
	grid_integration = false,
	active_spells = {
		top = 500,
		left = 100,
		point = "BOTTOMLEFT",
		w = 100,
		sm = 1,
		enable = true,
		names_enable = true,
		cancel_by_click = false,
	},
	ann = { -- announces of finishing spell's CD
		rw = false,
		raid = false,
		party = false,
		say = false,
		yell = false,
		only_rl = true,
		self = false,
		
		s_self = false,
		
		addons = {
			dbm = false,
			bw = false,
			dxe = false,
			grid = false,
		},
	},
	trackSpells = {},
	trackManualSpells = {},
	druids_arr = {},
}

HCoold.sort_methods = {
	[1] = {
		desc = L["from top to bottom"],
		point1 = "TOPLEFT",
		point2 = "BOTTOMLEFT",
		fpoint1 = "TOPLEFT",
		fpoint2 = "TOPLEFT",
	},
	[2] = {
		desc = L["from left to right"],
		point1 = "TOPLEFT",
		point2 = "TOPRIGHT",
		fpoint1 = "TOPLEFT",
		fpoint2 = "TOPLEFT",
	},
	[3] = {
		desc = L["from right to left"],
		point1 = "TOPRIGHT",
		point2 = "TOPLEFT",
		fpoint1 = "TOPLEFT",
		fpoint2 = "TOPLEFT",
	},
	[4] = {
		desc = L["from bottom to top"],
		point1 = "BOTTOMLEFT",
		point2 = "TOPLEFT",
		fpoint1 = "BOTTOMLEFT",
		fpoint2 = "BOTTOMLEFT",
	},
}

HCoold.config = {
	dropdownwidth = 200,
	editboxwidth = 150,
	addbuttonwidth = 100,
	deletebuttonwidth = 100,
	checkboxwidth = 150,
	timer_combat_symbiosys_delay = 5,
	max_CD_for_reset = 300,
	boss_check_timer = 10,
	grid_integration_delay_timer = 0.1,
}


do -- addon initialize section
	local console = LibStub("AceConsole-3.0")
	function HCoold:Printf(inp, ...)
		if self.debug then DEFAULT_CHAT_FRAME:AddMessage(string.format(inp, ...)) end
	end

	function HCoold:Print(...)
		if self.debug then DEFAULT_CHAT_FRAME:AddMessage(...) end
	end

	function HCoold:Chat(...)
		console:Print(...)
	end
	
	function HCoold:Chatf(...)
		console:Printf(...)
	end
	
	function HCoold:OnInitialize()
		local defaults = {
			profile = conf,
		}
		self.db = LibStub("AceDB-3.0"):New("hagakure_cooldownsDB", defaults)
		self.db.RegisterCallback(self, "OnNewProfile", "OnProfileGlobalChange")
		self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileGlobalChange")
		self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileGlobalChange")
		self.db.RegisterCallback(self, "OnProfileReset", "OnProfileGlobalChange")
		
		if not self.db.char.minimap then -- инициализация минимапы
			self.db.char.minimap = {
				hide = false,
				minimapPos = 250,
				radius = 80,
			}
		end
		self:RegisterMinimap()
		self:Minimap(not self.db.char.minimap.hide)
	end
	
	function HCoold:OnProfileGlobalChange()
		self:WIPE()
		self:DrawNew()
	end
	
	function HCoold:RegisterBossMods()
		if not self.bw and BigWigs then
			self.bw = BigWigs--:GetPlugin("Messages",true)
			--self.bwsound = BigWigs:GetPlugin("Sounds",true)
		end
		if not self.dxe and DXE then
			self.dxe = DXE:GetModule("Alerts",true)
		end
		if not self.dbm and DBM then
			self.dbm = DBM:NewMod(L["Hagakure cooldowns"])
		end
	end

	function HCoold:OnEnable()
		self:Chatf(L["|cffff0000Hagakure cooldowns, greet %s! run /hcd"],UnitName("player"))
		
		self:RegisterEvent("RAID_INSTANCE_WELCOME","ChangedZone") -- change zone
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED","CombatLog") -- COMBAT_LOG_EVENT_UNFILTERED  COMBAT_LOG_EVENT -- combat log event handler
		self:RegisterEvent("PLAYER_REGEN_DISABLED","EnterCombat") -- enter combat
		self:RegisterEvent("PLAYER_REGEN_ENABLED","LeaveCombat") -- leave combat
		-- self:RegisterEvent("RAID_ROSTER_UPDATE","RaidRosterUpdate") 
		self:RegisterEvent("GROUP_ROSTER_UPDATE","RaidRosterUpdate") 
		--self:RegisterEvent("PARTY_MEMBER_DISABLE","RaidRosterUpdate") -- не пашет
		--self:RegisterEvent("PARTY_MEMBER_ENABLE","RaidRosterUpdate")
		self:RegisterEvent("INSPECT_READY","InspectEvent") -- триггер пришедшей информации по талантам юнита
		self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT","BossEnable") -- триггер появления баров боссов?
		
		self:RenewPlayersList(true) -- making array with player's specs
		self.db.faction.PlayersSpells = self.db.faction.PlayersSpells or {}
		self.db.faction.PlayersTalents = self.db.faction.PlayersTalents or {}
		self.db.faction.AutoTalents = self.db.faction.AutoTalents or {}
		
		self:ClearSessionCD()
		self:DrawNew()
		self:GenerateOptions() -- generate addon options and registering command /hc
	end
end

function HCoold:RaidRosterUpdate()
	self:CheckPlayersCDs()
	if self.db.profile.auto_scan_talents then self:StartRescanTalents() end
end

function HCoold:RenewPlayersList(first)
	self.db.faction.players = self.db.faction.players or {} 
	for i=1, self:NumRaidMembers() do
		local name = select(1,GetRaidRosterInfo(i))
		if name then if not self.db.faction.players[name] then self.db.faction.players[name]=0 end end
	end
	if not first then self:CheckPlayersCDs() end
end

function HCoold:ChangedZone(...)
	local _,name, ttl = ...
	self:Printf("You entered %s.",name)
end

function HCoold:CombatLog(...)
	--[[
		... :
			2 - timestamp
			3 - event
			6 - sourceName
			10 - destName
				SPELL:
					13 - spellID
					14 - spellName
					15 - spellSchool
				_AURA_APPLIED
				_AURA_REMOVED
					16 - auraType  // BUFF DEBUFF
				_HEAL
				_CAST_START
				_CAST_SUCCESS
				_MISS
				_RESURRECT
				UNIT_DIED
	]]
	local inp = {...}
	local event = inp[3]

	if string.find(event,"UNIT_DIED") then
		self:KillUnit(inp[10])
		return
	end
	
	if not self:IsInRaid(inp[6]) then return false end

	if string.find(event,"SPELL") then 
		local spellID, spellName = inp[13], inp[14]
		self:Print(string.format("cast - %s %s %s",inp[13],inp[14], event))
		self:RenewSpec(inp[13],inp[6])
		if self:CheckGridIntegration() then self.grid:CheckTrigger(inp[13], inp[6], event) end
		local spell = self:IsTrackSpell(spellID,inp[6])
		if spell then
			if spell.succ then
				if type(spell.succ) == "table" then
					local b = true
					for _,i in next, spell.succ do
						if i == event then b = false end
					end
					if b then return end
				elseif spell.succ ~= event then return end 
			end
			-- у нас есть спелл, который мы отслеживаем, 
			-- при этом его каст прошел, те надо запустить кд 
			self:StartCD(inp[6],spell)
			return true
		end
		self:CheckSymbiosys(inp)
	end
end

function HCoold:KillUnit(name)
	if not self:IsInRaid(name) then return end
	if self:IsInCombat() then self.combat_spec[name]=nil end
	self:RenewStatus()
end

do -- секция с вход/выход из боя
	local combat = false
	local boss_fight = false
	local temp_timer = nil 
	function HCoold:EnterCombat()
		--self:Printf("enter combat")
		if boss_fight then
			-- если бой с боссом уже шел, то надо отменить таймер
			if temp_timer then
				HCoold:CancelTimer(temp_timer, true)
				temp_timer = nil
			end
		else
			self.combat_spec = {}
			-- запускаем таймер в 5 секунд для проверки симбиоза
			self:ScheduleTimer(function() HCoold.db.profile.druids_arr = {}; HCoold:CheckSymbiosysBuffs() end, self.config.timer_combat_symbiosys_delay)
		end
		combat = true
		
		
		if not temp_timer then temp_timer = self:ScheduleRepeatingTimer(function() 
				if HCoold:BossStatus() then 
					HCoold:ChangeBossStatus(true)
					HCoold:CancelTimer(temp_timer, true)
					temp_timer = nil
				end
			end, self.config.boss_check_timer) end 
	end

	function HCoold:LeaveCombat()
		--self:Printf("leave combat")
		combat = false
		if not boss_fight then 
			if temp_timer then self:CancelTimer(temp_timer, true); temp_timer = nil end 
		else
			-- идет энкаунтер, но мы сдохли, поэтому запускаем проверку на боссов
			if not temp_timer then temp_timer = self:ScheduleRepeatingTimer(function() 
					if not HCoold:BossStatus() then 
						HCoold:CancelTimer(temp_timer, true)
						temp_timer = nil
						HCoold:ChangeBossStatus(false)
					end
				end, self.config.boss_check_timer) end 
			
		end
	end

	function HCoold:IsInCombat()
		return combat or boss_fight
	end
	
	function HCoold:ChangeBossStatus(val)
		if boss_fight and (not val) then
			-- был бой с боссом, но прошел
			boss_fight = false
			--self:Print("|cffffff00boss fight stop|r")
			HCoold:ResetLongCDs()
		end
		if (not boss_fight) and val then
			-- не было боя с боссом, но начался
			--self:Print("|cffff0000boss fight start|r")
			boss_fight = true
		end
	end
	
	function HCoold:BossEnable()
		-- self:Print("Trigger event INSTANCE_ENCOUNTER_ENGAGE_UNIT")
		self:ScheduleTimer(function() 
			if self:BossStatus() then HCoold:ChangeBossStatus(true)
			else HCoold:ChangeBossStatus(false) end
		end, self.config.boss_check_timer) 
	end
end

local uncombat_spec = {} -- array that prevent checking spec out of combat more often then conf.timer_uncombat_delay
function HCoold:RenewSpec(...)
	local spellID, name = ...
	if self:IsInCombat() and self.combat_spec[name] then return false end
	if uncombat_spec[name] then return false end
	local spec = self:GetSpecBySpell(spellID)
	if spec == 0 then return false end
	
	self:UpdateSpec(name, spec)
end

function HCoold:UpdateSpec(name, spec)
	if (self:IsInCombat() and self.combat_spec[name] ) or uncombat_spec[name] then return false end

	local changed_spec = false
	if self.db.faction.players[name] ~= spec then changed_spec = true end
	self.db.faction.players[name] = spec
	if self:IsInCombat() then self.combat_spec[name] = spec
	else
		uncombat_spec[name] = spec
		self:ScheduleTimer(function() uncombat_spec[name] = nil end,self.db.profile.timer_uncombat_delay)
	end
	if changed_spec then 
		-- спек сменился значит надо запустить перепроверку на кдшки
		self:CheckPlayersCDs() 
		-- и если есть грид интеграция, то обновить игрока
		if self:CheckGridIntegration() then
			self.grid:UpdateUnit(name)
		end
	end
end

function HCoold:CheckPlayersCDs() -- check players cd and add/delete spells if needed
	local raid = self:GetRaidList()
	--[[
		raid = {
			{
				name = <player name>
				CDs = {
					[i] = spell, -- формат исходного спелла
				},
			},
		}
	]]
	-- сначала проверяем какие спеллы надо добавить и делаем это
	for _,member in next, raid do
		for _,spell in next, member.CDs do
			local spell_cont = self:GetSpell(member.name,spell.spellID)
			if not spell_cont then self:AddSpell(member.name,spell) end
		end
	end
	
	-- теперь надо проверить какие спеллы надо удалить и сделать это
	self:DeleteSpells()
	
	-- обновляем фреймы
	self:RenewStatus()
end

function HCoold:StartTimer() -- run timer for updating frames
	--self:RenewStatus()
	if self.timer_type == 2 and self.timer then
		self:CancelTimer(self.timer, true)
		self.timer = nil
	end
	if self.timer then return nil end
	self.timer = self:ScheduleRepeatingTimer("TimerActions",self.db.profile.timer_delay)
	self.timer_type = 1
end

function HCoold:StartFastTimer()
	if self.timer then self:CancelTimer(self.timer, true) end
	self.timer = self:ScheduleRepeatingTimer("TimerActions",self.db.profile.timer_fast_delay)
	self.timer_type = 2
end

function HCoold:TimerActions()
	local find = true
	local min_cd = self.db.profile.timer_min_diff + 1
	for _,i in next, self.trackCDs do
		i:Update()
	end
	for k = # self.trackCDs, 1, -1 do 
		local state = self.trackCDs[k]:GetState()
		local diff = -1
		if state == 1 then 
			self:AnnounceCDEnd(self.trackCDs[k])
			table.remove(self.trackCDs,k)
		end 
		if state == 2 then diff = self.trackCDs[k].state_casting_end
		elseif state == 3 then diff = self.trackCDs[k].state_cd_end end
		if diff ~= -1 then 
			diff = self:GetDiff(diff) 
			min_cd = math.min(min_cd,diff)
		end
	end
	if min_cd < self.db.profile.timer_min_diff and self.timer_type == 1 then self:StartFastTimer() end
	if min_cd >= self.db.profile.timer_min_diff and self.timer_type == 2 then self:StartTimer() end
	if # self.trackCDs == 0 then
		self:ClearSessionCD()
		self:CancelTimer(self.timer,true)
		self.timer = nil
	end
end

function HCoold:InspectEvent( arg1, arg2 ) -- срабатывает когда приходят данные по инспекту
	--self:Print("EVENT!")
	self:InspectTalents(arg2)
end













