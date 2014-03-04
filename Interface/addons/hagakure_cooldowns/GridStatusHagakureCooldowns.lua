if not HCoold then return end
if not Grid then return end
local L = HCoold:GetLocale()
local GHC = Grid:GetModule("GridStatus"):NewModule("GridStatusHagakureCooldowns", "AceTimer-3.0")
GHC.menuName = L["Grid menu name"]
local GridRoster = Grid:GetModule("GridRoster")

local hcd_status = "hagakure_cooldowns_cd"
--GHC.options = false
GHC.defaultDB = {
	debug = false,
	status_amount = 3,
	[hcd_status .. 1] = {
		text =  string.format(L["Enable hcd %d"], 1),
		enable = true,
		color = { r = 1, g = 1, b = 1, a = 1 },
		opacity = 1,
		priority = 50,
		range = false,
		spells = {},
	},
	[hcd_status .. 2] = {
		text =  string.format(L["Enable hcd %d"], 2),
		enable = true,
		color = { r = 1, g = 1, b = 1, a = 1 },
		opacity = 1,
		priority = 50,
		range = false,
		spells = {},
	},
	[hcd_status .. 3] = {
		text =  string.format(L["Enable hcd %d"], 3),
		enable = true,
		color = { r = 1, g = 1, b = 1, a = 1 },
		opacity = 1,
		priority = 50,
		range = false,
		spells = {},
	},
}

if HCoold.grid_def_track_values then
	for i = 1, 3 do
		GHC.defaultDB[hcd_status .. i].spells = HCoold.grid_def_track_values[hcd_status .. i].spells
	end
end

GHC.menuName = L["Hagakure cooldowns"]
GHC.extraOptions = {
	statusAmount = {
		order = 100,
		name = L["Amount of turned on statuses"],
		desc = L["desc amount of turned on statuses"],
		type = "input",
		set = function( _, value)
			value = math.max(math.floor(tonumber(value) or GHC.db.profile.status_amount),3)
			GHC:NewStatusAmount(value)
		end,
		get = function()
			return tostring(GHC.db.profile.status_amount)
		end,
	}
}


function GHC:NewStatusAmount(value)
	old = self.db.profile.status_amount
	if old == value then return end

	if old < value then
		for i = old + 1, value do
			self:RegisterNewStatus(i)
		end
	end
	
	if old > value then
		for i = value+1, old do	
			self:UnregisterStatus(hcd_status .. i)
			self.db.profile[hcd_status .. i].enable = false
			self.options.args[hcd_status .. i] = nil
		end
	end
	
	self.db.profile.status_amount = value
end

function GHC:RegisterNewStatus(num)
		if not self.db.profile[hcd_status .. num] then 
			self:Debug("register _" .. hcd_status .. num .. "_.+" .. string.format(L["Enable hcd %d"], num))
			self.db.profile[hcd_status .. num] = {
				text =  string.format(L["Enable hcd %d"], num),
				enable = true,
				color = { r = 1, g = 1, b = 1, a = 1 },
				opacity = 1,
				priority = 50,
				range = false,
				spells = {},
			}
		end
		local db = self.db.profile[hcd_status .. num]
		local menu, count, class_order, class_count, spec_list = {}, 1, {}, {}, {}
		
		local function add_string(class, id)
			local i = class
			local output = id ~= nil
			if not id then
				id = 1
				for j, _ in next, db.spells do
					if j >= id then id = j + 1 end
				end
				db.spells[id] = {
					ID = nil,
					class = i,
					spec = nil,
					priority = 50,
					sp_ids = {},
				}
			end
			local tt = i .. "_spell_options_" .. class_order[i] .. "_" .. class_count[i]
			local opt =  {
				type = "group",
				name = "",
				desc = "group desc",
				args = {},
				order = class_order[i] + 4 + class_count[i]*7,
				dialogInline = true
			}
			local cpt = opt.args
			
			local spells_for_spell, values_for_spell_name = {}, {}
			
			local function RedoSpellsForSpec()
				spells_for_spell = HCoold:GetSpellsForSpec(i,db.spells[id].spec)
				for id_num, spell in next, spells_for_spell do
					values_for_spell_name[id_num] = GetSpellInfo(spell.spellID)
				end
				cpt["_spell_name"].values = values_for_spell_name
				GHC:RedoTrackList()
			end
			
			cpt["_spell_name"] = {
				type = "select",
				values = {},
				set = function(_, value) 
					local list = spells_for_spell[value]
					local out = { list.spellID }
					if list.trigger then for _, tr in next, list.trigger do table.insert(out, tr) end end
					table.sort(out)
					db.spells[id].sp_ids = out
					db.spells[id].spell = list
					GHC:RedoTrackList()
				end,
				get = function() 
					for sp_id, spell in next, spells_for_spell do
						if HCoold:CompairSpellID({trigger = db.spells[id].sp_ids}, spell) then return sp_id end
					end
					db.spells[id].sp_ids = nil
				end,
				name = string.format(L["select spell for %d"], L[i]),
				desc = L["Select spell for tracking"],
				order = 5,
			}
			RedoSpellsForSpec()
			if not spec_list[i] then 
				spec_list[i] = {}
				local ss = HCoold:GetSpecsForClass(i) 
				for _, k in next, ss do
					spec_list[i][k] = L[i .. k]
				end
			end
			cpt["_spec"] = {
				type = "select",
				values = spec_list[i],
				set = function(_, value) db.spells[id].spec = value; RedoSpellsForSpec() end,
				get = function() return db.spells[id].spec end,
				name = string.format(L["select spec for %s"], L[i]),
				desc = L["Select spec for tracking spell"],
				width = "half",
				order = 4,
			}
			cpt["_priority"] = {
				type = "range", min = 0, max = 99, step = 1,
				set = function(_, value) db.spells[id].priority = value; GHC:RedoTrackList() end,
				get = function() return db.spells[id].priority end,
				name = L["Priority"],
				desc = L["Select priority for tracking spell"],
				width = "half",
				order = 6,
			}
			cpt["delete_butt"] = {
				type = "execute",
				name = L["delete"],
				--image = "Interface/BUTTONS/UI-MinusButton-Up",
				imageWidth = 25,
				imageHeight = 25,
				func = function()
					self.options.args[hcd_status .. num].args[tt] = nil
					db.spells[id] = nil
					GHC:RedoTrackList()
				end,
				width = "half",
				desc = L["delete spell from tracking"],
				order = 2,
			}
			if output then
				return tt, opt
			else
				self.options.args[hcd_status .. num].args[tt] = opt
			end
		end
		
		for _, i in next, HCoold.class_list do
			class_count[i] = 0
			class_order[i] = count * 100
			menu[i .. "_header"] = {
				type = "header",
				name = L[i],
				order = class_order[i],
			}
			menu[i .. "_add_button"] = {
				type = "execute",
				name = L["add"],
				-- image = "Interface/BUTTONS/UI-PlusButton-Up",
				imageWidth = 25,
				imageHeight = 25,
				width = "half",
				func = function()
					class_count[i] = class_count[i] + 1
					add_string(i)
				end,
				desc = L["Add one more rule for tracking"],
				order = class_order[i]  + 3,
			}
			for id, val in next, db.spells do
				if val then
					if val.class == i then
						class_count[i] = class_count[i] + 1
						local k, r = add_string(i, id)
						menu[k] = r
					end
				end
			end
				
			count = count + 1
		end
		self:RegisterStatus(hcd_status .. num, string.format(L["Hagakure cooldown slot %d"], num), menu, false)
end

function GHC:RedoTrackList()
	-- проходим по всем включенным статусам
	-- по всем спеллам
	--[[ забиваем в массив в формате
		[spell_id] = {
			class = "",
			spell = {},
			CDstart = nil,
			spec = "",
		}
		[trigger_id] = spell_id
	--]]
	local out = {}
	for status_name, options in next, self.db.profile do
		if string.find(status_name, hcd_status) and type(options) == "table" then
			for _, s in next, options.spells do
				if s.spell then
					if  type(out[s.spell.spellID]) ~= "table" then out[s.spell.spellID] = {} end
					table.insert(out[s.spell.spellID],{
						class = s.class,
						spec = s.spec,
						spell = s.spell,
						status = status_name,
					})
					for _, j in next, s.sp_ids do
						if not out[j] then out[j] = s.spell.spellID end
					end
				end
			end
		end
	end
	self.track_list = out
	self:UpdateAllUnits()
end

function GHC:OnInitialize()
	HCoold.grid = self
	self.super.OnInitialize(self)
end

function GHC:PostInitialize()
	if not HCoold.db.profile.grid_integration then 
		-- self.options = nil
		self.extraOptions = nil
		HCoold.grid = nil
		return
	end
	for i = 1, self.db.profile.status_amount do 
		self:RegisterNewStatus(i)
	end
	self:RedoTrackList()
end

function GHC:OnStatusEnable(status)
	if status ~= hcd_status then return end
	self:RegisterMessage("Grid_UnitJoined")
	self:UpdateAllUnits()
end

function GHC:OnStatusDisable(status)
	if status == hcd_status then
		self.core:SendStatusLostAllUnits(hcd_status)
		self:UnregisterMessage("Grid_UnitJoined")
	end
end

function GHC:Grid_UnitJoined(event, guid, unitid)
	if guid then
		self:UpdateGuid(guid, unitid)
	end
end

function GHC:Reset()
	self.super.Reset(self)
	self:UpdateAllUnits()
end

function GHC:UpdateAllUnits()
	local guid = UnitGUID("player")
	self:UpdateGuid(guid)
	for guid, unitid in GridRoster:IterateRoster() do
		 self:UpdateGuid(guid, unitid)
	end
end

function GHC:UpdateUnit(name)
	local guid = UnitGUID(name)
	self:UpdateGuid(guid)
end

local trigger_arr = {}
function GHC:CheckTrigger(spellID, name, event)
	if not self.track_list[spellID] then return end
	local out ={
		time = HCoold:GetTime(),
		spellID = spellID,
		name = name,
		event = event,
	}
	
	table.insert(trigger_arr, out)
	self:UpdateUnit(name)
	if not out.exists then
		for i, k in next, trigger_arr do
			if k == out then 
				--self:Debug("remove trigger from array ", out.spellID)
				table.remove(trigger_arr,i)
			end
		end
	end
end

function GHC:UpdateGuid(guid, unitid)
	-- self:Debug("Start UpdateGuid")
	if not guid then return end
	local locClass, engClass, locRace, engRace, gender, nameP, realm = GetPlayerInfoByGUID(guid)
	if realm and realm ~= "" then nameP = nameP .. "-" .. realm end
	local pinfo = HCoold:GetSpec(nameP)
	-- функция, которая в общем-то и должна выдавать изначальную картинку на grid
	-- и во время каждого обновления...

	-- нам нужно пройти по всем активным статусам
	for status_name, options in next, self.db.profile do
		if string.find(status_name, hcd_status) and type(options) == "table" then
			if options.enable then 
				-- и так, у нас есть включенный статус, теперь надо пройтись по всем спеллам
				-- и проверить спек, класс
				-- и не забыть проверить в случае симбиоза и талантов изучен ли этот талант у чела        
				
				local spell_for_unit = {} -- массив в который забиваем подошедшие нам спеллы из данного статуса
				for _, s in next, options.spells do
					if s.spell then
						--self:Debug(s.spec .. " " ..  s.class .. " " .. s.spell.spellID .. " " .. s.priority .. " " .. nameP .. " spec is ", "s", pinfo.spec)
						local check = false -- переменная по проверке добавления спелла в лист
						
						local symb_and_talent_check = true -- если заклинание из симбиоза или таланта, то эта переменная будет false
						-- сначала проверка подходит этот талант или спелл симбиоза для данного парня
						if s.spell.symb then ----------------------------------------------------------------------- ласт херня для проверки
							symb_and_talent_check = false
							-- self:Debug("symbiosys spell and type is " .. s.spell.symb)
							-- у нас спелл который получает рейд
							if s.spell.symb == "raid" then
								if pinfo.class == "DRUID" then
									-- но у нас друид, значит добавлять нельзя
									-- ничего не делаем
								else
									-- у нас член рейда, и значит надо проверить есть ли симбиоз на нем
									-- если на нем симбиоз есть, значит спелл добавить для отслеживания
									local symbArr = HCoold.db.profile.druids_arr
									for _, i in next, symbArr do
										if i == nameP then
											check = true
										end
									end
								end
							end
							-- у нас спелл, который получает друид
							if s.spell.symb == "druid" then
								if pinfo.class ~= "DRUID" then
									-- у нас не друид, при этом спелл друидский - ничего не делаем
								else
									-- у нас и друид и спелл друидский, значит если он кастанул симбиоз, то надо добавить для трекинга
									if HCoold.db.profile.druids_arr[nameP] then check = true end
								end
							end
						end
						
						if s.spell.talent then
							symb_and_talent_check = false
							--self:Debug("talent spell")
							-- и так, у нас талант и нам надо проверить вкачан он или нет ;/
							--[[
							self.db.faction.AutoTalents[name] = {
								talents = talents,
								name = name,
								last_scan = GetTime(),
							}
							--]]
							check = HCoold:GetTalentSpellForGridIntegration(pinfo, s.spell)
						end
						
						if s.class == pinfo.class and (s.spec == 0 or s.spec == pinfo.spec) and symb_and_talent_check then check = true end
						if check then table.insert(spell_for_unit, s) end
					end
				end
				
				-- теперь выбираем из массива спеллов тот спелл, который непосредственно и будет отображаться в этом статусе
				local acspell = nil
				for _, i in next, spell_for_unit do
					if acspell == nil then acspell = i end
					if acspell ~= i then
						if acspell.priority < i.priority then acspell = i end
					end
				end
				
				if acspell then 
					--self:Debug("spell for " .. status_name .. " is " .. acspell.spell.spellID) 
				
					-- проверяем есть ли кд на абилку из главного аддона
					local cd_ends = HCoold:GetLastSessionCD(acspell.spell.spellID, nameP)
					if cd_ends == -1 then
						-- потом проверяем есть ли кд на абилку из массива trigger_arr и удаляем из него триггеры если кд абилки уже прошел
						for k, i in next, trigger_arr do
							if HCoold:CompairSpellID(i, acspell.spell) then
								local b = false
								if type(acspell.spell.succ) == "table" then
									for _,j in next, acspell.spell.succ do
										if j == i.event then b = true end
									end
								else if acspell.spell.succ == i.event then b = true end	end
								if b then
									-- и так триггеры совпадают, значит надо проверить прошел ли кд или еще и нет удалить если надо
									cd_ends = i.time + acspell.spell.CD
									i.exists = true
									if cd_ends < HCoold:GetTime() then
										-- все-таки надо удалять
										table.remove(trigger_arr, k)
										cd_ends = -1 
									end
								end
							end
						end
					end
					
					-- ну и результаты посылаем в путь
					-- self:Debug(acspell.spell.spellID .. " has CD till " .. cd_ends)
					local spname, _, spicon = GetSpellInfo(acspell.spell.spellID)
					if cd_ends == -1 then
						-- абилка без кд
						self:NoCD(guid, spicon, spname, status_name)
					else
						-- у абилки куллдаун
						local left_time = cd_ends - HCoold:GetTime()
						local start_time = GetTime() + left_time - acspell.spell.CD
						self:SetCD(guid, spicon, spname, start_time, acspell.spell.CD, status_name)
					end
				else 
					-- self:Debug("No spell for status " .. status_name) 
					-- надо обнулить данный статус 
					self.core:SendStatusLost(guid, status_name)
				end
			end
		end
	end
end

function GHC:SetCD(guid, icon, spname, time_start, time_left, status)
	-- self:Debug("sending " .. status .. " name " .. spname .. " start="..time_start.." left="..time_left.." now="..GetTime())
	self.core:SendStatusGained(
		guid, 
		status, 
		self.db.profile[status].priority, 
		nil, 
		self.db.profile[status].color,
		spname,
		nil,
		nil,
		icon,
		math.ceil(time_start),
		time_left,
		nil) 
	-- запускаем на перепроверку данного юнита по окончанию всего действия
	self:ScheduleTimer(function() GHC:UpdateGuid(guid) end, time_start + time_left - GetTime() + HCoold.config.grid_integration_delay_timer)
end

function GHC:NoCD(guid, icon, spname, status)
	-- self:Debug("sending " .. status .. " name " .. spname)
	self.core:SendStatusGained(
		guid, 
		status, 
		self.db.profile[status].priority, 
		nil, 
		self.db.profile[status].color,
		spname,
		nil,
		nil,
		icon,
		nil,
		nil,
		nil) 
end









