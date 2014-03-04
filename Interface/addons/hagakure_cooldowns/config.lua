if not HCoold then return false end
local AceConfig = LibStub("AceConfigDialog-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
local L = HCoold:GetLocale()

do -- register statusbar's media
	local folder = "Interface\\AddOns\\hagakure_cooldowns\\media\\"
	LSM:Register("statusbar", "Otravi", folder .. "otravi")
	LSM:Register("statusbar", "Smooth", folder .. "smooth")
	LSM:Register("statusbar", "Glaze", folder .. "glaze")
	LSM:Register("statusbar", "Charcoal", folder .. "Charcoal")
	LSM:Register("statusbar", "BantoBar", folder .. "default")
end

local function t01to16(num)
	num = num or 0
	local tmp = num * 255
	local a1 = math.floor(tmp/16)
	local a2 = math.floor(tmp - a1*16)
	local out = ""

	if a1 < 10 then out = tostring(a1) end
	if a1 == 10 then out = "A" end
	if a1 == 11 then out = "B" end
	if a1 == 12 then out = "C" end
	if a1 == 13 then out = "D" end
	if a1 == 14 then out = "E" end
	if a1 == 15 then out = "F" end

	if a2 < 10 then out = out .. tostring(a2) end
	if a2 == 10 then out = out .. "A" end
	if a2 == 11 then out = out .. "B" end
	if a2 == 12 then out = out .. "C" end
	if a2 == 13 then out = out .. "D" end
	if a2 == 14 then out = out .. "E" end
	if a2 == 15 then out = out .. "F" end
	
	return out
end

local function t16to01(str)
	local a1 = string.sub(str,1,1)
	local a2 = string.sub(str,2)
	local s1 = tonumber(a1)
	local s2 = tonumber(a2)
	
	if string.lower(a1) == "a" then s1 = 10 end
	if string.lower(a1) == "b" then s1 = 11 end
	if string.lower(a1) == "c" then s1 = 12 end
	if string.lower(a1) == "d" then s1 = 13 end
	if string.lower(a1) == "e" then s1 = 14 end
	if string.lower(a1) == "f" then s1 = 15 end

	if string.lower(a2) == "a" then s2 = 10 end
	if string.lower(a2) == "b" then s2 = 11 end
	if string.lower(a2) == "c" then s2 = 12 end
	if string.lower(a2) == "d" then s2 = 13 end
	if string.lower(a2) == "e" then s2 = 14 end
	if string.lower(a2) == "f" then s2 = 15 end
	
	local out = (s1*16+s2)/255
	
	return out
end

local function getRGBA(color)
	--HCoold:Print(color)
	local a = string.sub(color,3,4)
	local r = string.sub(color,5,6)
	local g = string.sub(color,7,8)
	local b = string.sub(color,9,10)
	
	local a_ = t16to01(a)
	local r_ = t16to01(r)
	local g_ = t16to01(g)
	local b_ = t16to01(b)
	
	return r_, g_, b_, a_
end

local function setRGBA(r,g,b,a)
	local out = string.format("|c%s%s%s%s",t01to16(a),t01to16(r),t01to16(g),t01to16(b))
	return out
end

function HCoold:RunConfig()
	AceConfig:SetDefaultSize(HCoold.name,800,600)
	AceConfig:Open(HCoold.name)
end

local options = {
	type = "group",
	get = getProfileOption,
	set = setProfileOptionAndClearCache,
	args = {
		lock = {
			type = "execute",
			name = L["lock frames"],
			desc = L["desc lock frames"],
			order = 1,
			func = function () HCoold:LockFrames() end,
		},
		unlock = {
			type = "execute",
			name = L["unlock frames"],
			desc = L["desc unlock frames"],
			order = 2,
			func = function () HCoold:UnlockFrames() end,
		},
		wipe = {
			type = "execute",
			name = L["redraw"],
			desc = L["desc redraw"],
			--cmdHidden = true,
			order = 3,
			confirm = true,
			func = function () HCoold:OnProfileGlobalChange() end,
		},
		config = {
			type = "execute",
			guiHidden = true,
			name = L["run config"],
			desc = L["desc run config"],
			order = 4,
			func = HCoold.RunConfig,
		},
		hide = {
			type = "execute",
			name = L["show/hide all"],
			desc = L["desc show/hide all"],
			order = 5,
			func = function ()
				local show = false
				for _, i in next, HCoold.types do if i:Enable() then show = true end end
				for _, i in next, HCoold.types do 
					i:Enable(not show)
					HCoold.db.profile.types[i.type].enable = not show
				end
				if show then HCoold.db.profile.active_spells.enable = false end
			end,
		},
		debug_on = {
			type = "execute",
			name = L["debug mode on"],
			desc = L["desc debug mode on"],
			order = 6,
			func = function () HCoold:SpellDebugModeOn() end,
		},
		symbiosys = {
			type = "execute",
			name = L["symbiosys tracking"],
			desc = L["desc symbiosys tracking"],
			order = 7,
			func = function () GameTooltip:Hide(); HCoold:SymbiosysTrakingList() end,
		},
		talents = {
			type = "execute",
			name = L["talents tracking"],
			desc = L["desc talents tracking"],
			order = 8,
			func = function () GameTooltip:Hide(); HCoold:ShowScanedTalents() end,
		},
		minimap = {
			name = L["toggle minimap"],
			desc = L["desc toggle minimap"],
			order = 9,
			--func = function () HCoold:MinimapOn(not ) end, -- self.db.char.minimap.hide
			type = "toggle",
			set = function(_,val) HCoold:MinimapOn(val) end,
			get = function() return not HCoold.db.char.minimap.hide end,
		},
	},
}
if HCoold.debug then
	local f = function() -- function for test scripts
		-- HCoold:RunTalentsSpellSelection()
		-- HCoold:RunPersonalSpellConfig() 
		-- HCoold:RunSymbiosysSetup()
		-- HCoold:SymbiosysTrakingList()
		-- HCoold:TestFunc()
		-- HCoold:CheckSymbiosysBuffs()
		-- HCoold:CheckTalents()
	end
	
	options.args.test = {
		type = "execute",
		name = "test script",
		func = f,
	}
end

local function func1() -- options.spells main page
	options.args.spells.args.header = {
		type = "header",
		order = 19,
		name = L["color setup"],
	}
	do -- font config + icon size
		options.args.spells.args.font = {
			type = "select",
			order = 1,
			name = L["font name"],
			desc = L["desc font name"],
			values = LSM:HashTable("font"),
			dialogControl = "LSM30_Font",
			set = function(_,val) HCoold.db.profile.font.name = val end,
			get = function() return HCoold.db.profile.font.name end,
			cmdHidden = true,
		}
		options.args.spells.args.font_size = {
			type = "input",
			order = 2,
			width = "half",
			name = L["font size"],
			desc = L["desc font size"],
			set = function(_,val) 
				local tmp = tonumber(val) or 18
				if tmp <= 0 then tmp = 18 end
				HCoold.db.profile.font.size = tmp
			end,
			get = function() return tostring(HCoold.db.profile.font.size) end,
			cmdHidden = true,
		}
		options.args.spells.args.icon_size = {
			type = "input",
			order = 3,
			width = "half",
			name = L["icon size"],
			desc = L["desc icon size"],
			set = function(_,val) 
				local tmp = tonumber(val) or 16
				if tmp <= 0 then tmp = 16 end
				HCoold.db.profile.icon.w = tmp
			end,
			get = function() return tostring(HCoold.db.profile.icon.w) end,
			cmdHidden = true,
		}
		options.args.spells.args.server_names = {
			type = "toggle",
			cmdHidden = true,
			name = L["server names"],
			desc = L["server names desc"],
			order = 4,
			--width = "half",
			set = function(a1, val)
				HCoold.db.profile.server_names = not HCoold.db.profile.server_names
			end,
			get = function()
				return HCoold.db.profile.server_names
			end,
		}
		options.args.spells.args.tooltip_spells = {
			type = "toggle",
			cmdHidden = true,
			name = L["tooltip spells"],
			desc = L["tooltip spells desc"],
			order = 5,
			--width = "half",
			set = function(a1, val)
				HCoold.db.profile.tooltip_spells = not HCoold.db.profile.tooltip_spells
				StaticPopupDialogs["HCooldRedoLayout"]= {
					text = string.format(L["Don't forget to redraw layout to aply settings."]), 
					button1 = ACCEPT,
					timeout = 30, 
					whileDead = 0, 
					hideOnEscape = 1, 
				}
				StaticPopup_Show("HCooldRedoLayout")
			end,
			get = function()
				return HCoold.db.profile.tooltip_spells
			end,
		}
		options.args.spells.args.tooltip_active_spells = {
			type = "toggle",
			cmdHidden = true,
			name = L["tooltip active spells"],
			desc = L["tooltip active spells desc"],
			order = 6,
			--width = "half",
			set = function(a1, val)
				HCoold.db.profile.tooltip_active_spells = not HCoold.db.profile.tooltip_active_spells
			end,
			get = function()
				return HCoold.db.profile.tooltip_active_spells
			end,
		}
		options.args.spells.args.auto_talents_scan = {
			type = "toggle",
			cmdHidden = true,
			name = L["auto talents scan"],
			desc = L["desc auto talents scan"],
			order = 7,
			--width = "half",
			set = function(a1, val)
				HCoold.db.profile.auto_scan_talents = not HCoold.db.profile.auto_scan_talents
			end,
			get = function()
				return HCoold.db.profile.auto_scan_talents
			end,
		}
	end
	do -- color config
		options.args.spells.args.exl_color = {
			type = "color",
			order = 20,
			name = L["exl spell color"],
			desc = L["desc exl spell color"],
			hasAlpha = true,
			set = function(_,r,g,b,a) HCoold.db.profile.color.supergood = setRGBA(r,g,b,a) end,
			get = function() return getRGBA(HCoold.db.profile.color.supergood) end,
			cmdHidden = true,
		}
		options.args.spells.args.good_color = {
			type = "color",
			order = 21,
			name = L["good spell color"],
			hasAlpha = true,
			desc = L["desc good spell color"],
			set = function(_,r,g,b,a) HCoold.db.profile.color.good = setRGBA(r,g,b,a) end,
			get = function() return getRGBA(HCoold.db.profile.color.good) end,
			cmdHidden = true,
		}
		options.args.spells.args.bad_color = {
			type = "color",
			order = 22,
			name = L["bad spell color"],
			hasAlpha = true,
			desc = L["desc bad spell color"],
			set = function(_,r,g,b,a) HCoold.db.profile.color.bad = setRGBA(r,g,b,a) end,
			get = function() return getRGBA(HCoold.db.profile.color.bad) end,
			cmdHidden = true,
		}
		options.args.spells.args.off_color = {
			type = "color",
			order = 23,
			name = L["off spell color"],
			hasAlpha = true,
			desc = L["desc off spell color"],
			set = function(_,r,g,b,a) HCoold.db.profile.color.offline = setRGBA(r,g,b,a) end,
			get = function() return getRGBA(HCoold.db.profile.color.offline) end,
			cmdHidden = true,
		}
		options.args.spells.args.dead_color = {
			type = "color",
			order = 24,
			name = L["dead spell color"],
			desc = L["desc dead spell color"],
			hasAlpha = true,
			set = function(_,r,g,b,a) HCoold.db.profile.color.dead = setRGBA(r,g,b,a) end,
			get = function() return getRGBA(HCoold.db.profile.color.dead) end,
			cmdHidden = true,
		}
		options.args.spells.args.cd_color = {
			type = "color",
			order = 25,
			name = L["cd spell color"],
			desc = L["desc cd spell color"],
			hasAlpha = true,
			set = function(_,r,g,b,a) HCoold.db.profile.color.cd = setRGBA(r,g,b,a) end,
			get = function() return getRGBA(HCoold.db.profile.color.cd) end,
			cmdHidden = true,
		}
	end
	do -- active spells' frame
		options.args.spells.args.acheader = {
			type = "header",
			order = 30,
			name = L["active spells"],
		}
		local conf = HCoold.db.profile.active_spells
		local sm = {}
		for i,j in next, HCoold.sort_methods do sm[i] = j.desc end
		options.args.spells.args.acwidth = {
			type = "input",
			cmdHidden = true,
			name = L["actspell width"],
			desc = L["desc actspell width"],
			order = 31,
			width = "half",
			set = function(a1,val)
				val = tonumber(val)
				conf.w = val or conf.w
			end,
			get = function()
				return tostring(conf.w)
			end,
		}
		options.args.spells.args.acsort = {
			type = "select",
			cmdHidden = true,
			name = L["actspell sort method"],
			desc = L["actspell desc sort method"],
			order = 32,
			values = sm,
			get = function() 
				return conf.sm 
			end,
			set = function(tmp, val) 
				conf.sm = val
			end,
		}
		options.args.spells.args.acenable = {
			type = "toggle",
			name = L["actspell enable"],
			desc = L["actspell desc enable"],
			cmdHidden = true,
			order = 33,
			width = "half",
			set = function(t, val)
				conf.enable = val
			end,
			get = function() return conf.enable end,
		}
		options.args.spells.args.acnamesenable = {
			type = "toggle",
			name = L["ac names enable"],
			desc = L["desc ac names enable"],
			cmdHidden = true,
			order = 34,
			set = function(t, val)
				conf.names_enable = val
			end,
			get = function() return conf.names_enable end,
		}
		options.args.spells.args.accancel = {
			type = "toggle",
			name = L["ac cancel by click"],
			desc = L["desc ac cancel by click"],
			cmdHidden = true,
			order = 35,
			set = function(t, val)
				conf.cancel_by_click = val
			end,
			get = function() return conf.cancel_by_click end,
		}
	end
end

local function func2() -- expert config
	options.args.expert  = {
		type = "group",
		cmdHidden = true,
		name = L["expert"],
		desc = L["desc expert"],
		order = 6,
		args = {}
	}
	local ex = options.args.expert.args
	
	do -- timer + group's track section
		ex.group_track = {
			type = "input",
			width = "half",
			name = L["track groups"],
			desc = L["desc track groups"],
			order = 1,
			get = function() return tostring(HCoold.db.profile.group_track) end,
			set = function(_,val) HCoold.db.profile.group_track = math.max(1, math.floor(tonumber(val) or 5)) end,
		}
		ex.slow_timer = {
			type = "input",
			width = "half",
			name = L["fast timer"],
			desc = L["desc fast timer"],
			order = 2,
			get = function() return tostring(HCoold.db.profile.timer_fast_delay) end,
			set = function(_,val) HCoold.db.profile.timer_fast_delay = math.max(0.01,tonumber(val) or 1) end,
		}
		ex.fast_timer = {
			type = "input",
			width = "half",
			name = L["slow timer"],
			desc = L["desc slow timer"],
			order = 3,
			get = function() return tostring(HCoold.db.profile.timer_delay) end,
			set = function(_,val) HCoold.db.profile.timer_delay = math.max(0.01,tonumber(val) or 1) end,
		}
		ex.min_time = {
			type = "input",
			width = "half",
			name = L["min time"],
			desc = L["desc min time"],
			order = 4,
			get = function() return tostring(HCoold.db.profile.timer_min_diff) end,
			set = function(_,val) HCoold.db.profile.timer_min_diff = math.max(0.01,tonumber(val) or 1) end,
		}
		ex.raid_only = {
			type = "toggle",
			order = 5,
			name = L["raid only"],
			desc = L["desc raid only"],
			set = function(_,val) HCoold.db.profile.raid_only = val end,
			get = function() return HCoold.db.profile.raid_only end,
		}
	end
	
	do -- announce CDs section
		--[[
			ann = { -- announces of finishing spell's CD
				rw = false,
				raid = false,
				say = false,
				yell = false,
				only_rl = true,
				self = false,
				addons = {
					dbm = false,
					bw = false,
					dxe = false,
				},
			},
		--]]
		local conf = HCoold.db.profile.ann
		do -- announce through chat channels end cd
			ex.header1 = {
				type = "header",
				name = L["announce CDs"],
				order = 20,
			}
			ex.rw = {
				type = "toggle",
				order = 21,
				name = L["ann rw"],
				desc = L["desc ann rw"],
				set = function(_,val) conf.rw = val end,
				get = function() return conf.rw end,
			}
			ex.raid = {
				type = "toggle",
				order = 22,
				name = L["ann raid"],
				desc = L["desc ann raid"],
				set = function(_,val) conf.raid = val end,
				get = function() return conf.raid end,
			}
			ex.party = {
				type = "toggle",
				order = 23,
				name = L["ann party"],
				desc = L["desc ann party"],
				set = function(_,val) conf.party = val end,
				get = function() return conf.party end,
			}
			ex.say = {
				type = "toggle",
				order = 24,
				name = L["ann say"],
				desc = L["desc ann say"],
				set = function(_,val) conf.say = val end,
				get = function() return conf.say end,
			}
			ex.yell = {
				type = "toggle",
				order = 25,
				name = L["ann yell"],
				desc = L["desc ann yell"],
				set = function(_,val) conf.yell = val end,
				get = function() return conf.yell end,
			}
			ex.self = {
				type = "toggle",
				order = 26,
				name = L["ann self"],
				desc = L["desc ann self"],
				set = function(_,val) conf.self = val end,
				get = function() return conf.self end,
			}
			ex.only_rl = {
				type = "toggle",
				order = 27,
				name = L["ann only rl"],
				desc = L["desc ann only rl"],
				set = function(_,val) conf.only_rl = val end,
				get = function() return conf.only_rl end,
			}
		end
		do -- announce through chat channels start cd
			ex.header2 = {
				type = "header",
				name = L["announce CDs start"],
				order = 30,
			}
			ex.s_self = {
				type = "toggle",
				order = 31,
				name = L["ann self start"],
				desc = L["desc ann self start"],
				set = function(_,val) conf.s_self = val end,
				get = function() return conf.s_self end,
			}
		end
		do -- addon announce
			ex.header2 = {
				type = "header",
				name = L["addon announce"],
				order = 50
			}
			ex.dbm = {
				type = "toggle",
				order = 55,
				name = L["ann DBM"],
				desc = L["desc ann DBM"],
				set = function(_,val) conf.addons.dbm = val end,
				get = function() return conf.addons.dbm end,
			}
			ex.dxe = {
				type = "toggle",
				order = 56,
				name = L["ann DXE"],
				desc = L["desc ann DXE"],
				set = function(_,val) conf.addons.dxe = val end,
				get = function() return conf.addons.dxe end,
			}
			ex.bw = {
				type = "toggle",
				order = 57,
				name = L["ann BigWigs"],
				desc = L["desc ann BigWigs"],
				set = function(_,val) conf.addons.bw = val end,
				get = function() return conf.addons.bw end,
			}
		end
	end
	
	do -- personal settings
		ex.header3 = {
			order = 100,
			type = "header",
			name = L["Manual spell settings"],
		}
		ex.spconfig = {
			order = 101,
			type = "execute",
			name = L["Personal spells"],
			desc = L["desc presonal spells"],
			func = function() 
				AceConfig:Close(HCoold.name)
				GameTooltip:Hide()
				HCoold:RunPersonalSpellConfig() 
			end,
		}
		ex.talentconfig = {
			order = 102,
			type = "execute",
			name = L["Talent selection"],
			desc = L["desc talent selection"],
			func = function() 
				AceConfig:Close(HCoold.name)
				GameTooltip:Hide()
				HCoold:RunTalentsSpellSelection() 
			end,
		}
		ex.gridIntegration = {
			order = 103,
			type = "toggle",
			name = L["grid integration"],
			desc = L["turn on grid integration"],
			set = function()
				StaticPopupDialogs["ConfirmGridIntegration"]= {
					text = L["To apply setting need to reload interface, press ACCEPT to do this now"], 
					button1 = ACCEPT, 
					showAlert = true,
					button2 = CANCEL,
					timeout = 30, 
					whileDead = 0, 
					hideOnEscape = 1, 
					OnAccept = function() ReloadUI() end,
				}
				StaticPopup_Show("ConfirmGridIntegration")
				HCoold.db.profile.grid_integration = not HCoold.db.profile.grid_integration
			end,
			get = function() return HCoold.db.profile.grid_integration end,
		}
	end

	do -- bar's config
		local conf = HCoold.db.profile.bars
		ex.header4 = {
			order = 150,
			type = "header",
			name = L["Bar settings"],
		}
		ex.barsenable = {
			order = 160,
			type = "toggle",
			set = function(_,val) conf.enable = val end,
			get = function() return conf.enable end,
			name = L["bars enable"],
			desc = L["desc bars enable"],
		}
		ex.barsbgenable = {
			order = 161,
			type = "toggle",
			set = function(_,val) conf.bgenable = val end,
			get = function() return conf.bgenable end,
			name = L["bar background enable"],
			desc = L["desc bar background enable"],
		}
		ex.barsbgcolor = {
			type = "color",
			order = 162,
			name = L["bar bg color"],
			desc = L["desc bar bg color"],
			hasAlpha = true,
			set = function(_,r,g,b,a) 
				conf.bg_color.r = r 
				conf.bg_color.g = g 
				conf.bg_color.b = b 
				conf.bg_color.a = a 
			end,
			get = function() return conf.bg_color.r, conf.bg_color.g, conf.bg_color.b, conf.bg_color.a end,
		}
		ex.barscastcolor = {
			type = "color",
			order = 163,
			name = L["bar casting spell color"],
			desc = L["desc bar casting spell color"],
			hasAlpha = true,
			set = function(_,r,g,b,a)
				conf.cast_color.r = r 
				conf.cast_color.g = g 
				conf.cast_color.b = b 
				conf.cast_color.a = a 
			end,
			get = function() return conf.cast_color.r, conf.cast_color.g, conf.cast_color.b, conf.cast_color.a end,
		}
		ex.barscdcolor = {
			type = "color",
			order = 164,
			name = L["bar cd spell color"],
			desc = L["desc bar cd spell color"],
			hasAlpha = true,
			set = function(_,r,g,b,a)
				conf.cd_color.r = r 
				conf.cd_color.g = g 
				conf.cd_color.b = b 
				conf.cd_color.a = a 
			end,
			get = function() return conf.cd_color.r, conf.cd_color.g, conf.cd_color.b, conf.cd_color.a end,
		}
		ex.bartexture = {
			type = "select",
			order = 165,
			dialogControl = "LSM30_Statusbar",
			name = L["bar texture"],
			desc = L["desc bar texture"],
			values = LSM:HashTable("statusbar"),
			set = function(__,key) conf.texture = key end,
			get = function() return conf.texture end,
		}
	end
end

function HCoold:GenerateOptions()
	options.args.spells = {
		type = "group",
		cmdHidden = true,
		name = L["spells"],
		desc = L["desc spells"],
		order = 5,
		args = HCoold:GenerateSpellList()
	}
	func1()
	func2()
	
	options.args.profiles = LibStub('AceDBOptions-3.0'):GetOptionsTable(HCoold.db)
	options.args.profiles.order = -1
	--options.args.profiles.cmdHidden = true
	options.args.profiles.disabled = false
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable(HCoold.name, options, "hcd")
	AceConfig:AddToBlizOptions(HCoold.name,L["Hagakure cooldowns"])
end






































