-- Coding standards brought to you by the East India Trading Company in association with the Save the Camel Foundation
local L = LibStub("AceLocale-3.0"):GetLocale("Utopia")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local SM = LibStub("LibSharedMedia-3.0")
local LGT = LibStub("LibGroupTalents-1.0")
local commPrefix = "Utopia"
local playerName, playerClass, db, title, d
local new, del, copy, deepDel, Gradient, UnitFullName, ClassColour, SmoothColour, SmoothColourStr, rotate
local throttle
local totemSpells
local specChangers = {}
for index,spellid in ipairs(_G.TALENT_ACTIVATION_SPELLS) do
	specChangers[GetSpellInfo(spellid)] = index
end

assert(AceGUIWidgetLSMlists, "Utopia requires AceGUI-3.0-SharedMediaWidgets")

local module = LibStub("AceAddon-3.0"):NewAddon("Utopia", "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0", "AceComm-3.0", "AceTimer-3.0")
module:SetDefaultModuleState(false)
--[===[@debug@
Utopia = module
--@end-debug@]===]
module.version = tonumber(strmatch("$Revision: 217 $", "(%d+)")) or 0
module.version = max(module.version, tonumber(strmatch("219", "(%d+)")) or 0)
function module:UpdateVersion(ver)
	self.version = max(tonumber(strmatch(ver, "(%d+)")) or 0, self.version)
end
module.callbacks = LibStub("CallbackHandler-1.0"):New(module)

local configMode
CONFIGMODE_CALLBACKS = CONFIGMODE_CALLBACKS or {}
CONFIGMODE_CALLBACKS["Utopia"] = function(action)
	if action == "ON" then
		configMode = true
	elseif action == "OFF" then
		configMode = nil
	end
	module:IterateFrames("SetLocked")
end

local petClasses = {HUNTER = true, WARLOCK = true}
module.petClasses = petClasses

local satedDebuff = UnitFactionGroup("player") == "Horde" and GetSpellInfo(57724) or GetSpellInfo(57723) -- Sated/Exhaustion

local LDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("Utopia", {
	type = "launcher",
	label = L["TITLE"],
	icon = select(3, GetSpellInfo(7386)),
})

-- LDB Bits
function LDB:Update()
	self.label = Gradient(L["TITLE"], 1, 0.1, 0.1, 1, 1, 0.1)
end

-- OnClick
function LDB.OnClick(self, button)
	if (not IsModifierKeyDown()) then
		if (button == "LeftButton") then
			module:ToggleActive()
		elseif (button == "RightButton") then
			module:OpenConfig()
		end
	elseif (IsControlKeyDown() and not IsShiftKeyDown() and not IsAltKeyDown()) then
		if (button == "LeftButton") then
			if (module.modules.UpTime) then
				module.modules.UpTime:Toggle()
			end
		end
	end
end

-- OnTooltipShow
function LDB.OnTooltipShow(tt)
	tt:AddLine(module.title)

	local gotTalents = LGT:GetTalentCount()
	local missing = module:GetTalentMissingPeople()

	local raidSize = GetNumRaidMembers()
	if (raidSize == 0) then
		raidSize = GetNumPartyMembers() + 1
	end

	local r, g, b = SmoothColour(gotTalents / raidSize)
	tt:AddDoubleLine(L["Group size:"], tostring(raidSize), 1, 1, 1, 0, 1, 0)
	tt:AddDoubleLine(L["Got Talents for:"], tostring(gotTalents), 1, 1, 1, r, g, b)
	if (missing) then
		tt:AddLine(format(L["Missing: %s"], missing), 1, 1, 1, 1)
	end

	tt:AddLine(" ")
	local str = L["HINT"]
	if (module.modules.UpTime) then
		str = str.." "..L["HINTUPTIME"]
	end
	tt:AddLine(str, 0, 1, 0, 1)
end

module.options = {
	type = 'group',
	order = 15,
	name = L["TITLE"],
	desc = L["Configuration"],
	handler = module,
	get = function(info) return db[info[#info]] end,
	set = function(info, value) db[info[#info]] = value end,
	args = {
		General = {
			type = 'group',
			order = 1,
			name = L["General Settings"],
			desc = L["General Settings"],
			args = {
				enable = {
					type = 'toggle',
					name = L["Enable"],
					desc = L["Enable target debuff status display"],
					width = "full",
					set = function(info, n) db.enable = n module:ShowWhen() end,
					order = 5,
				},
				locked = {
					type = 'toggle',
					name = L["Locked"],
					desc = L["Toggle locked position. When unlocked, you can move the display with the bar"],
					set = function(info, n)
						db.locked = n
						module:IterateFrames("SetLocked")
					end,
					order = 20,
				},
--[===[@debug@
				pvp = {
					type = 'toggle',
					name = "PvP (debug only)",
					desc = "Enable in pvp instances",
					get = function() return module.pvp end,
					set = function(info, n) module.pvp = n module:ShowWhen() end,
					order = 25,
				},
--@end-debug@]===]
				mode = {
					type = 'group',
					name = L["Mode Options"],
					desc = L["Mode Options"],
					guiInline = true,
					order = 100,
					args = {
						automode = {
							type = 'toggle',
							name = L["Auto Mode"],
							desc = L["Automatically choose buffs mode out of combat and Debuffs mode in combat"],
							order = 5,
						},
						dualframe = {
							type = 'toggle',
							name = L["Dual Frames"],
							desc = L["Use two frames to display buffs and debuffs simultaniously"],
							order = 50,
							set = function(_, n)
								db.dualframe = n
								module:ShowWhen()
							end,
						},
						allPlayers = {
							type = 'toggle',
							name = L["All Players"],
							desc = L["Targetting players will show their buff status instead of your own"],
							order = 100,
						},
					},
				},
				icon = {
					type = 'group',
					name = L["Icon Options"],
					desc = L["Icon Options"],
					guiInline = true,
					set = function(info, value)
						db[info[#info]] = value
						module:IterateFrames("SetMode", true)
					end,
					order = 100,
					args = {
						showCooldown = {
							type = "toggle",
							order = 10,
							name = L["Show Cooldown"],
							desc = L["Show buff cooldown indication on Utopia icons"],
						},
						drawEdge = {
							type = "toggle",
							order = 15,
							name = L["Edge Highlight"],
							desc = L["Show leading edge on cooldown for clarity"],
						},
						showCountdown = {
							type = "toggle",
							order = 20,
							name = L["Show Countdown"],
							desc = L["Show buff countdown in Utopia icons"],
						},
						minCountdown = {
							type = "range",
							name = L["Minimum Duration"],
							desc = L["Set minumum time left before the expirey countdown shows"],
							order = 2,
							min = 10,
							max = 86400,
							step = 1,
							bigStep = 10,
							order = 30,
						},
					},
				},
				tooltip = {
					type = 'group',
					name = L["Tooltip Options"],
					desc = L["Options for default values when unavaible"],
					guiInline = true,
					order = 150,
					args = {
						defaultMax = {
							type = 'toggle',
							name = L["Max Possible"],
							desc = L["Unavailable spells are shown as max possible talented value, instead of the untalented base value"],
							order = 5,
						},
						totemsTemporary = {
							type = 'toggle',
							name = L["Totems are Temporary"],
							desc = L["Treat all totem buffs as if they are temporary and not important pre-combat."],
							order = 10,
							set = function(info, value)
								db[info[#info]] = value
								module:IterateFrames("SetMode", true)
							end,
						},
						hints = {
							type = 'toggle',
							name = L["Hints"],
							desc = L["Show hints about click availability on Utopia's icons"],
							order = 20,
						},
					},
				},
				talent = {
					type = 'group',
					name = L["Talent Options"],
					desc = L["Talent Options"],
					guiInline = true,
					order = 170,
					args = {
						storeGuildTalents = {
							type = 'toggle',
							name = L["Store Guild Members"],
							desc = L["Store last seen guild member talents for faster initial display. Talents are still refreshed when the members are seen. Talents are only stored when you are in a raid, as it's more likely for players to use alternate specs when in a party."],
							order = 10,
							disabled = function() return not IsInGuild() end,
						},
						clear = {
							type = 'execute',
							name = L["Clear Guild Members"],
							desc = L["Clear stored guild member talents."],
							order = 15,
							disabled = function()
								local guildName = GetGuildInfo("player")
								return not guildName or not module.db.realm.guildTalents or not module.db.realm.guildTalents[guildName]
							end,
							func = function()
								local guildName = GetGuildInfo("player")
								if (guildName) then
									local gdb = module.db.realm.guildTalents
									if (gdb) then
										gdb[guildName] = deepDel(gdb[guildName])
									end
								end
							end,
						},
						reset = {
							type = 'execute',
							name = L["Rescan Talents"],
							desc = L["Clear talent cache and rescan everyone"],
							func = function()
								LGT:PurgeAndRescanTalents()
								--module:ScanRoster()
							end,
							order = 30,
						},
					},
				},
				misc = {
					type = 'group',
					name = L["Miscellaneous Options"],
					desc = L["Other options"],
					guiInline = true,
					order = 200,
					args = {
						tooltip = {
							type = 'toggle',
							name = L["Tooltip Enhancements"],
							desc = L["Improve the information shown in default buff tooltips to reflect the talent enchanced amounts and show extra bonus affects granted."],
							order = 5,
							set = function(info, value)
								db[info[#info]] = value 
								module:CheckXPerlTooltipNamesOption()
							end,
						},
						--tooltiprank = {
						--	type = 'toggle',
						--	name = L["Spell Rank"],
						--	desc = L["Show spell rank in standard tooltips."],
						--	order = 10,
						--	disabled = function() return not db.tooltip end,
						--},
						warnLosses = {
							type = 'toggle',
							name = L["Warn Losses"].." (Don't report issues with this yet)",
							desc = L["Warn when your raid group loses the ability to apply a buff or debuff. Will also notify you if you quickly regain this aura"],
							order = 15,
						},
						showRespecs = {
							type = 'toggle',
							name = L["Show Respecs"],
							desc = L["Show in chat when someone swaps talent sets"],
							order = 20,
						}
					},
				},
			},
		},
		icons = {
			type = 'group',
			name = L["Icons"],
			desc = L["Icon Settings"],
			order = 5,
			args = {
				automatic = {
					type = "toggle",
					order = 10,
					name = L["Automatic"],
					desc = L["Automatically show the buffs relevant for your class"],
					set = function(info, value)
						db.automatic = value
						module:IterateFrames("SetMode", true)
					end,
				},
				onlyAvailable = {
					type = "toggle",
					order = 20,
					name = L["Only Available"],
					desc = L["Only show available icons in the set, hiding all icons your group cannot apply buffs or debuffs for"],
					set = function(info, value)
						db.onlyAvailable = value
						module:IterateFrames("SetMode", true)
					end,
				},
				alwaysStandardBuffs = {
					type = "toggle",
					order = 30,
					name = L["Always Standard Buffs"],
					desc = format(L["Always show standard raid buffs (%s, %s, %s) in automatic mode, regardless of other settings"], GetSpellInfo(1126), GetSpellInfo(79105), GetSpellInfo(45525)),
					disabled = function() return not db.automatic end,
					set = function(info, value)
						db.alwaysStandardBuffs = value
						module:ScanRosterActual()
					end,
				},
				alwaysRuneScrolls = {
					type = "toggle",
					order = 40,
					name = L["Runescrolls & Drums"],
					desc = L["Always show Runescrolls and Drums as available"],
					set = function(info, value)
						db.alwaysRuneScrolls = value
						module:ScanRosterActual()
					end,
				},
				buffs = {
					type = 'group',
					order = 100,
					name = L["Buffs"],
					desc = L["Buff Icon Options"],
					disabled = function() return db.automatic end,
					guiInline = true,
					get = function(info)
						local self = module.options.args.icons.args.buffs.args[info[#info]]
						return not (db.disabled and db.disabled.buffs and db.disabled.buffs[self.name])
					end,
					set = function(info, value)
						local self = module.options.args.icons.args.buffs.args[info[#info]]
						value = not value
						if (value) then
							if (not db.disabled) then
								db.disabled = new()
							end
							if (not db.disabled.buffs) then
								db.disabled.buffs = new()
							end
							db.disabled.buffs[self.name] = true
						else
							db.disabled.buffs[self.name] = nil
							if (not next(db.disabled.buffs)) then
								db.disabled.buffs = del(db.disabled.buffs)
								if (not next(db.disabled)) then
									db.disabled = del(db.disabled)
								end
							end
						end
						if (not db.dualframe and module.frames) then
							module.frames[1]:SetMode("buffs")
						end
					end,
					args = {},		-- Filled later
				},
				debuffs = {
					type = 'group',
					order = 200,
					name = L["Debuffs"],
					desc = L["Debuff Icon Options"],
					disabled = function() return db.automatic end,
					guiInline = true,
					get = function(info)
						local self = module.options.args.icons.args.debuffs.args[info[#info]]
						return not (db.disabled and db.disabled.debuffs and db.disabled.debuffs[self.name])
					end,
					set = function(info, value)
						local self = module.options.args.icons.args.debuffs.args[info[#info]]

						value = not value
						if (value) then
							if (not db.disabled) then
								db.disabled = new()
							end
							if (not db.disabled.debuffs) then
								db.disabled.debuffs = new()
							end
							db.disabled.debuffs[self.name] = true
						else
							db.disabled.debuffs[self.name] = nil
							if (not next(db.disabled.debuffs)) then
								db.disabled.debuffs = del(db.disabled.debuffs)
								if (not next(db.disabled)) then
									db.disabled = del(db.disabled)
								end
							end
						end
						if (not db.dualframe and module.frames) then
							module.frames[1]:SetMode("debuffs")
						end
					end,
					args = {},		-- Filled later
				}
			}
		},
		display = {
			type = 'group',
			name = L["Display"],
			desc = L["Display settings"],
			order = 10,
			args = {
				colours = {
					type = 'group',
					name = L["Colour"],
					order = 50,
					guiInline = true,
					get = function(info)
						local c = db.colour[info[#info]]
						return c.r, c.g, c.b, c.a
					end,
					set = function(info, r, g, b, a)		--value)
						local c = db.colour[info[#info]]
						c.r, c.g, c.b, c.a = r, g, b, a
						module:IterateFrames("UpdateBuffs")
					end,
					args = {
						active = {
							type = "color",
							name = L["Active Colour"],
							desc = L["Set the colour for debuffs which your group has applied."],
							hasAlpha = true,
							order = 1,
						},
						inactive = {
							type = "color",
							name = L["Inactive Colour"],
							desc = L["Set the colour for debuffs which your group is able to apply, but has not done so."],
							hasAlpha = true,
							order = 2,
						},
          				partActive = {
							type = "color",
							name = L["Partial Colour"],
							desc = L["Set the colour for auras which someone has applied, but it is an unimproved version of the spell."],
							hasAlpha = true,
							order = 4,
						},
          				unavailable = {
							type = "color",
							name = L["Unavailable Colour"],
							desc = L["Set the colour for debuffs which your group is not able to apply."],
							hasAlpha = true,
							order = 4,
						},
          				excluded = {
							type = "color",
							name = L["Excluded Colour"],
							desc = L["Set the colour for debuffs which your group is able to apply, but another spell is excluding it."],
							hasAlpha = true,
							order = 5,
						},
						temporary = {
							type = "color",
							name = L["Temporary Colour"],
							desc = L["Set the colour for debuffs which your group is able to apply, but usually only during combat. They're expected to not be active when idle."],
							hasAlpha = true,
							order = 6,
						}
					},
				},
				icons = {
					type = 'group',
					order = 100,
					name = L["Icons"],
					desc = L["Display options for the icons"],
					guiInline = true,
					args = {
						size = {
							type = "range",
							name = L["Icon Size"],
							desc = L["Set the size of the icons"],
							order = 10,
							set = function(info, n)
								db.size = n
								module:IterateFrames("SetIconSize")
							end,
							min = 8,
							max = 64,
							step = 1,
							order = 20,
						},
						scale = {
							type = "range",
							name = L["Scale"],
							desc = L["Set the scale of the icons"],
							order = 20,
							set = function(info, n)
								db.scale = n
								module:IterateFrames("SetScale", n)
								module:SavePosition(module.frames[1])
								if (module.frames[2]) then
									module:SavePosition(module.frames[2])
								end
							end,
							min = 0.2,
							max = 2,
							step = 0.01,
							bigStep = 0.1,
							order = 30,
						},
					},
				},
				bar = {
					type = 'group',
					order = 150,
					name = L["Bar"],
					desc = L["Display options for the status bar"],
					guiInline = true,
					args = {
						bar = {
							type = "toggle",
							order = 10,
							name = L["Enable"],
							desc = L["Enable the status bar"],
							set = function(_, n)
								db.bar = n
								module:IterateFrames("EnableBar")
							end,
						},
						side = {
							type = 'select',
							name = L["Bar Placement"],
							desc = L["Which side to put the bar"],
							values = {B = L["Bottom/Right"], T = L["Top/Left"]},
							order = 20,
							set = function() module:SetOrientation() end,
						},
						texture = {
							type = 'select', dialogControl = 'LSM30_Statusbar',
							name = L["Bar Texture"],
							desc = L["Set the texture for the bar"],
							values = AceGUIWidgetLSMlists.statusbar,
							order = 30,
							set = function(v,n)
								db.texture = n
								local tex = SM:Fetch("statusbar", n)
								for i,frame in pairs(module.frames) do
									frame.bar:SetStatusBarTexture(tex)
									frame.bar.bg:SetTexture(tex)
								end
							end,
						},
						barwidth = {
							type = "range",
							name = L["Width"],
							desc = L["Set the width of the status bar"],
							order = 40,
							set = function(info, n)
								db.barwidth = n
								module:IterateFrames("SetOrientation")
							end,
							min = 1,
							max = 20,
							step = 1,
							order = 50,
						},
					},
				},
				buttons = {
					type = 'group',
					name = L["Buttons"],
					order = 200,
					guiInline = true,
					set = function(info, value)
						db[info[#info]] = value
						module:IterateFrames("SetOrientation")
					end,
					args = {
						orientation = {
							type = 'select',
							name = L["Orientation"],
							desc = L["Set the orientation for the display"],
							values = {V = L["Vertical"], H = L["Horizontal"]},
							order = 1,
						},
						hspacing = {
							type = "range",
							name = L["Horizontal Spacing"],
							desc = L["Set the horizontal spacing of the buttons"],
							order = 2,
							min = 0,
							max = 20,
							step = 1,
							order = 5,
						},
						vspacing = {
							type = "range",
							name = L["Vertical Spacing"],
							desc = L["Set the vertical spacing of the buttons"],
							order = 2,
							min = 0,
							max = 20,
							step = 1,
							order = 10,
						},
						columns = {
							type = "range",
							name = L["Columns"],
							desc = L["Set the buttons before breaking to next row/column"],
							order = 2,
							min = 1,
							max = 15,
							step = 1,
							order = 20,
						},
						popupPos = {
							type = 'select',
							name = L["Popup Toggle"],
							desc = L["Select the position for the popup toggle button"],
							values = {top = L["Top"], bottom = L["Bottom"]},
							order = 50,
						},
					},
				},
				background = {
					type = "group",
					name = L["Background Options"],
					guiInline = true,
					order = 400,
					get = function(info) return db.Background[ info[#info] ] end,
					set = function(info, value)
						db.Background[ info[#info] ] = value
						module:IterateFrames("UpdateBackdrop")
					end,
					args = {
						Enable = {
							type = "toggle",
							order = 1,
							name = L["Enable"],
							desc = L["Enable the frame background"],
						},
						Texture = {
							type = "select", dialogControl = 'LSM30_Background',
							order = 10,
							name = L["Background Texture"],
							desc = L["Texture to use for the frame's background"],
							values = AceGUIWidgetLSMlists.background,
						},
						BorderTexture = {
							type = "select", dialogControl = 'LSM30_Border',
							order = 20,
							name = L["Border Texture"],
							desc = L["Texture to use for the frame's border"],
							values = AceGUIWidgetLSMlists.border,
						},
						Color = {
							type = "color",
							order = 30,
							name = L["Background Colour"],
							desc = L["Frame's background colour"],
							hasAlpha = true,
							get = function(info)
								local t = db.Background.Color
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = db.Background.Color
								t.r, t.g, t.b, t.a = r, g, b, a
								module:IterateFrames("UpdateBackdrop")
							end,
						},
						BorderColourAsStatus = {
							type = "toggle",
							order = 50,
							name = L["Status Border Colour"],
							desc = L["Border colour will reflect the progressive buff/debuff status as the bar indicator does."],
							set = function(info, value)
								db.Background.BorderColourAsStatus = value
								if (value) then
									module:IterateFrames("UpdateBuffs")
								else
									module:IterateFrames("DoBackdropColour")
								end
							end,
						},
						BorderColor = {
							type = "color",
							order = 40,
							name = L["Border Colour"],
							desc = L["Frame's border colour"],
							hasAlpha = true,
							get = function(info)
								local t = db.Background.BorderColor
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = db.Background.BorderColor
								t.r, t.g, t.b, t.a = r, g, b, a
								module:IterateFrames("UpdateBackdrop")
							end,
						},
						Tile = {
							type = "toggle",
							order = 50,
							name = L["Tile Background"],
							desc = L["Tile the background texture"],
						},
						TileSize = {
							type = "range",
							order = 60,
							name = L["Background Tile Size"],
							desc = L["The size used to tile the background texture"],
							min = 16, max = 256, step = 1,
							disabled = function() return not db.Background.Tile end,
						},
						EdgeSize = {
							type = "range",
							order = 70,
							name = L["Border Thickness"],
							desc = L["The thickness of the border"],
							min = 1, max = 24, step = 1,
						},
					},
				},
			},
		},
		show = {
			type = 'group',
			name = L["Show When"],
			desc = L["Set rules for when to show Utopia"],
			get = function(info) return db.show[info[#info]] end,
			set = function(info, value)
				db.show[info[#info]] = value
				module:ShowWhen()
			end,
			order = 50,
			args = {
				when = {
					type = "group",
					name = L["Show When"],
					guiInline = true,
					order = 10,
					args = {
						desc = {
							order = 0,
							type = "description",
							name = L["Set rules for when to show Utopia"],
						},
						always = {
							type = 'toggle',
							name = L["Always Show"],
							desc = L["Always show the bar"],
							order = 1,
						},
						solo = {
							type = 'toggle',
							name = SOLO,
							desc = L["Show when solo"],
							disabled = function() return db.show.always end,
							order = 10,
						},
						party = {
							type = 'toggle',
							name = PARTY,
							desc = L["Show when in a party"],
							disabled = function() return db.show.always end,
							order = 20,
						},
						raid = {
							type = 'toggle',
							name = RAID,
							desc = L["Show when in a raid"],
							disabled = function() return db.show.always end,
							order = 30,
						},
					},
				},
				what = {
					type = "group",
					name = L["With What"],
					guiInline = true,
					order = 20,
					args = {
						desc = {
							order = 0,
							type = "description",
							name = L["Set rules for what to show Utopia with"],
						},
						enemy = {
							type = 'toggle',
							name = L["Enemy"],
							desc = L["Only show when targetting a hostile unit"],
							disabled = function() return db.show.always end,
							order = 35,
						},
						boss = {
							type = 'toggle',
							name = L["Bosses"],
							desc = L["Only show when targetting boss mobs"],
							disabled = function() return db.show.always or db.show.enemy end,
							order = 40,
						},
					},
				},
				opts = {
					type = "group",
					name = L["Show If"],
					guiInline = true,
					order = 30,
					args = {
						desc = {
							order = 0,
							type = "description",
							name = L["Only if these conditions are met"],
						},
						combat = {
							type = 'toggle',
							name = L["In-Combat"],
							desc = L["Show when in combat"],
							disabled = function() return db.show.always or db.show.enemy end,
							order = 50,
						},
						oocombat = {
							type = 'toggle',
							name = L["Out-of-Combat"],
							desc = L["Show when out of combat"],
							disabled = function() return db.show.always or db.show.enemy end,
							order = 60,
						},
					},
				},
			},
		},
	},
}

AceConfig:RegisterOptionsTable("Utopia", module.options)

-- FirstInitData
function module:FirstInitData()
	local function PullSpellInfo(name, spellInfo, key)
		if (type(spellInfo[key]) == "number") then
			local keyID = key.."ID"
			spellInfo[keyID] = spellInfo[key]
			spellInfo[key] = GetSpellInfo(spellInfo[keyID])
			if (not spellInfo[key]) then
				error("Missing spell for ID %d in %s", spellInfo[key], name)
			end
		end
	end

	local function DoList(list)
		for name,info in pairs(list) do
			local newlist = {}
			for spell,spellInfo in pairs(info.spells) do
				PullSpellInfo(name, spellInfo, "improved")
				PullSpellInfo(name, spellInfo, "requiredTalent")
				PullSpellInfo(name, spellInfo, "source")
				PullSpellInfo(name, spellInfo, "alternate")

				if (type(spell) == "number") then
					local id = spell
					spell = GetSpellInfo(id)
					if (not spell) then
						error(format("Missing spell for ID %d in %s", id, name))
					end
					spellInfo.id = id
					newlist[spell] = spellInfo
					info.spells[id] = nil
				else
					newlist[spell] = spellInfo
					info.spells[spell] = nil
				end
			end
			info.spells = newlist
		end
	end
	DoList(self.buffs)
	DoList(self.debuffs)

	local newList = {}
	for id,info in pairs(self.otherBuffs) do
		local name = GetSpellInfo(id)
		newList[name] = info
		info.id = id
		PullSpellInfo(name, info, "improved")
		PullSpellInfo(name, info, "requiredTalent")
		PullSpellInfo(name, info, "source")
		PullSpellInfo(name, info, "alternate")
	end
	self.otherBuffs = newList

	self.FirstInitData = nil
end

-- AddExclusiveData
function module:AddExclusiveData(spellInfo)
	local ex = spellInfo.exclusive or spellInfo.totem
	if (ex) then
		local tab = self.exclusive[ex]
		if (not tab) then
			tab = new()
			self.exclusive[ex] = tab
		end
		if (not tab[spellInfo.name]) then
			tab[spellInfo.name] = true
		end
	end
end

-- InitData
function module:InitData()
	if (self.lookup) then
		del(self.lookup.buffs)
		del(self.lookup.debuffs)
		del(self.lookup)
	end
	deepDel(self.classes)
	deepDel(self.exclusive)

	local menu = module.options.args.icons.args
	menu.buffs.args = deepDel(menu.buffs.args)
	menu.debuffs.args = deepDel(menu.debuffs.args)

	self.lookup = new()
	self.lookup.buffs = new()
	self.lookup.debuffs = new()
	self.classes = new()
	self.exclusive = new()					-- Exclusives lookup

	menu.buffs.args = new()
	menu.debuffs.args = new()

	if (self.FirstInitData) then
		self:FirstInitData()
	end

	local list = new()
	for name,info in pairs(self.buffs) do
		tinsert(list, name)
		info.key = name
		for spell,spellInfo in pairs(info.spells) do
			spellInfo.name = spell
			spellInfo.key = name

			local old = self.lookup.buffs[spell]
			if (old) then
				-- Multiple actions for one debuff (Curse of Weakness) will not go
				-- into lookup, so we build a table on the one that is in lookup
				if (not old.multiple) then
					old.multiple = new()
				end
				tinsert(old.multiple, name)
			else
				self.lookup.buffs[spell] = spellInfo
			end

			if (spellInfo.alternate) then
				self.lookup.buffs[spellInfo.alternate] = spellInfo
			end

			self:AddExclusiveData(spellInfo)

			if (spellInfo.class) then
				local c = self.classes[spellInfo.class]
				if (not c) then
					c = new()
					self.classes[spellInfo.class] = c
				end
				if (not c.buffs) then
					c.buffs = new()
				end
				c.buffs[name] = spell
			end
		end
	end
	sort(list)
	for i,name in ipairs(list) do
		local m = new()
		menu.buffs.args[tostring(i)] = m
		m.type = "toggle"
		m.name = name
		m.desc = name
		m.order = i
	end
	del(list)

	local list = new()
	for name,info in pairs(self.debuffs) do
		tinsert(list, name)
		info.key = name
		for spell,spellInfo in pairs(info.spells) do
			spellInfo.name = spell
			spellInfo.key = name

			local old = self.lookup.debuffs[spell]
			if (old) then
				-- Multiple actions for one debuff (Curse of Weakness) will not go
				-- into lookup, so we build a table on the one that is in lookup
				if (not old.multiple) then
					old.multiple = new()
				end
				tinsert(old.multiple, name)
			else
				self.lookup.debuffs[spell] = spellInfo
			end

			self:AddExclusiveData(spellInfo)

			local c = self.classes[spellInfo.class]
			if (not c) then
				c = new()
				self.classes[spellInfo.class] = c
			end
			if (not c.debuffs) then
				c.debuffs = new()
			end
			c.debuffs[name] = spell
		end
	end
	sort(list)
	for i,name in ipairs(list) do
		local m = new()
		menu.debuffs.args[tostring(i)] = m
		m.type = "toggle"
		m.name = name
		m.desc = name
		m.order = i
	end
	del(list)

	del(self.mappingLookup)
	self.mappingLookup = new()

	for targetSpell,data in pairs(self.mapping) do
		data.key = targetSpell
		for sourceSpell,info in pairs(data.list) do
			-- Mappings now a list of mappings. Some spells have more than 1 possible
			-- ie: Devotion Aura -> Improved Devotion Aura OR to Swift Retribution OR to Sanctified Retribution
			local cur = self.mappingLookup[sourceSpell]
			if (not cur) then
				cur = new()
				self.mappingLookup[sourceSpell] = cur
			end
			tinsert(cur, data)

			--self.mappingLookup[sourceSpell] = data
		end
	end
end

-- SavePosition
function module:SavePosition(frame)
	local point, _, relPoint, x, y = frame:GetPoint(1)
	if (point) then
		if (not self.db.char.pos) then
			self.db.char.pos = {}
		end
		self.db.char.pos[frame:GetName()] = {point, "UIParent", relPoint, x, y}
		if (frame:IsResizable()) then
			if (not self.db.char.frameSizes) then
				self.db.char.frameSizes = {}
			end
			self.db.char.frameSizes[frame:GetName()] = {frame:GetWidth(), frame:GetHeight()}
		end
	end
end

-- RestorePosition
function module:RestorePosition(frame)
	local pos = self.db.char.pos and self.db.char.pos[frame:GetName()]
	if (pos) then
		frame:SetPoint(unpack(pos))
		if (self.db.char.frameSizes) then
			if (frame:IsResizable()) then
				local size = self.db.char.frameSizes[frame:GetName()]
				if (size) then
					frame:SetWidth(size[1])
					frame:SetHeight(size[2])
				end
			else
				self.db.char.frameSizes[frame:GetName()] = nil
			end
		end
	else
		frame:SetPoint("CENTER")
	end
end

-- MyLevelRank
--function module:MyLevelRank(ranks)
--	if (ranks) then
--		local lvl = UnitLevel("player")
--		local rank
--		for i,level in pairs(ranks) do
--			if (lvl >= level) then
--				rank = i
--			end
--		end
--		return rank
--	end
--end

-- MySpellRank
--function module:MySpellRank(spellInfo)
--	local name, rank = GetSpellInfo(spellInfo.name)
--	if (not name and spellInfo.source) then
--		name, rank = GetSpellInfo(spellInfo.source)
--	end
--	if (name and rank) then
--		return tonumber(strmatch(rank, "(%d+)"))
--	end
--end

-- GetAmount
function module:GetAmount(info, short, getMaximum, auraCaster, auraName, auraRank, auraTex, auraCount, auraDebuffType, auraDuration, auraEndTime, auraIsStealable)
--[===[@debug@
-- So I can run from command line :)
	if (type(info) == "string") then
		info = self.lookup.buffs[info] or self.lookup.debuffs[info]
	end
--@end-debug@]===]
	local casterName = auraCaster and UnitFullName(auraCaster) or auraCaster
	if (not casterName and auraName) then
		-- We've been given buff info of someone out of sight, so caster name is missing, so we need to use UNKNOWN
		-- So that we don't pull in the talented max amount by mistake
		casterName = UNKNOWN
	end
	local ret = info.amount
	local suffix

	if (info.minLevel and UnitLevel("player") < info.minLevel) then
		return "--"
	end

	local name, rank, stacks
	if (auraName) then
		rank = auraRank

		if (rank and auraName == info.alternate and info.alternateOffset) then
			rank = rank + info.alternateOffset
		end
		if (info.maxStacks) then
			stacks = auraCount
		--elseif (auraCount and auraCount > 1) then
		--	error(format("%s has %d stacks. info.maxStacks not set", info.name, auraCount))
		end
	--else
		--local myRankLevel = rank
		--if (auraCaster and UnitIsUnit("player", auraCaster)) then
		--	myRankLevel = self:MySpellRank(info)
		--end
		--if (not myRankLevel) then
		--	myRankLevel = self:MyLevelRank(info.rankLevels)
		--end
		--if (myRankLevel) then
		--	rank = myRankLevel
		--else
		--	rank = -1
		--end
	end

	if (info.amountFunc) then
		ret = info.amountFunc(casterName)
	--elseif (info.amountsPerStack) then
	--	ret = info.amountsPerStack[rank or #info.amountsPerStack]
	--	if (not ret) then
	--		error(format("No info.amountsPerStack[%s] for %s", tostring(rank or #info.amountsPerStack), tostring(info.name)))
	--	end
	--	if (not short) then
	--		suffix = format(L["(for %d %s)"], stacks or info.maxStacks, L["stacks"])
	--	end
	elseif (info.amountPerStack) then
		ret = info.amountPerStack
		assert(ret)
		if (not short) then
			suffix = format(L["(for %d %s)"], stacks or info.maxStacks, L["stacks"])
		end
	--elseif (info.amounts) then
	--	if (rank == -1) then
	--		return "--"
	--	else
	--		ret = info.amounts[rank or #info.amounts]
	--		if (not ret) then
	--			error(format("No info.amounts[%s] for %s", tostring(rank or #info.amounts), tostring(info.name)))
	--		end
	--	end
	end

--[[if (info.improvedAmountPerTalentPoint) then
		if (ret) then
			if (casterName) then
				local points = LGT:UnitHasTalent(casterName, info.improved)
				if (points) then
					if (points > info.maxTalentPoints) then
						LGT:RefreshTalentsByUnit(casterName)
						points = 0
--[===[@debug@
						self:Print(format("Resetting %s's talent points due to mismatch with maxTalentPoints for %s", casterName, info.name))
--@end-debug@]===]
					end
					ret = ret + info.improvedAmountPerTalentPoint * points
				end
			else
				local potentialLevel = self.spellPotential[info.name] or (db.defaultMax and info.maxTalentPoints or 0)
				if (not getMaximum and potentialLevel) then
					if (potentialLevel > 0) then
						ret = ret + info.improvedAmountPerTalentPoint * potentialLevel
					end
				else
					if (getMaximum ~= -1) then
						ret = ret + info.improvedAmountPerTalentPoint * (info.maxTalentPoints or 1)
					end
				end
			end
			ret = ret and floor(ret)
		end

	elseif (info.improvedPercentagePerTalentPoint) then
		if (ret) then
			if (casterName) then
				local points = LGT:UnitHasTalent(casterName, info.improved)
				if (points) then
					if (points > info.maxTalentPoints) then
						LGT:RefreshTalentsByUnit(casterName)
						points = 0
--[===[@debug@
						self:Print(format("Resetting %s's talent points due to mismatch with maxTalentPoints for %s", casterName, info.name))
--@end-debug@]===]
					end
					if (info.amountType == "%") then
						ret = ret + info.improvedPercentagePerTalentPoint * points
					else
						ret = ret * (1 + (info.improvedPercentagePerTalentPoint * points / 100))
					end
				end
			else
				local potentialLevel = self.spellPotential[info.name] or (db.defaultMax and info.maxTalentPoints or 0)
				if (not getMaximum and potentialLevel) then
					if (potentialLevel > 0) then
						if (info.amountType == "%") then
							ret = ret + info.improvedPercentagePerTalentPoint * potentialLevel
						else
							ret = ret * (1 + (info.improvedPercentagePerTalentPoint * potentialLevel / 100))
						end
					end
				else
					if (getMaximum ~= -1) then
						if (info.amountType == "%") then
							ret = ret + info.improvedPercentagePerTalentPoint * (info.maxTalentPoints or 1)
						else
							ret = ret * (1 + (info.improvedPercentagePerTalentPoint * (info.maxTalentPoints or 1) / 100))
						end
					end
				end
			end
			ret = ret and floor(ret)
		end

	else ]]
		
	if (info.amountPerTalentPoint) then
		local aptp
		if (type(info.amountPerTalentPoint) == "function") then
			aptp = info.amountPerTalentPoint(auraCaster)
		else
			aptp = info.amountPerTalentPoint
		end

		if (casterName) then
			local points = LGT:UnitHasTalent(casterName, info.requiredTalent)
			if (points) then
				if (points > info.maxTalentPoints) then
					LGT:RefreshTalentsByUnit(casterName)
					points = info.maxTalentPoints
--[===[@debug@
					self:Print(format("Resetting %s's talent points due to mismatch with data", casterName))
--@end-debug@]===]
				end
				ret = aptp * points
			end
		else
			local potentialLevel = self.spellPotential[info.name]
			if (not getMaximum and potentialLevel) then
				if (potentialLevel > 0) then
					ret = aptp * potentialLevel
				end
			else
				if (getMaximum ~= -1) then
					ret = aptp * (info.maxTalentPoints or 1)
				end
			end
		end
		ret = ret and floor(0.5 + ret)
	end

--[[
	if (info.glpyhImprovedPercentage) then
		if (casterName) then
			if (LGT:UnitHasGlyph(casterName, info.glyphImproved)) then
				ret = ret * (100 + info.glpyhImprovedPercentage) / 100
			end
		end
	elseif (info.glpyhImprovedAmount) then
		if (casterName) then
			if (LGT:UnitHasGlyph(casterName, info.glyphImproved)) then
				ret = ret + info.glpyhImprovedAmount
			end
		end
	end
]]

	if (ret and info.maxStacks) then
		if (info.assumeMaxStacks) then
			ret = ret * info.maxStacks
		else
			ret = ret * (stacks or info.maxStacks or 1)
		end
		if (not short) then
			suffix = format(L["(for %d %s)"], (info.assumeMaxStacks and info.maxStacks) or stacks or info.maxStacks, info.stacksDescription or L["stacks"])
		end
--[===[@debug@
	else
		if (stacks and stacks > 1 and not info.maxStacks) then
			error(format("%s has %d stacks. info.maxStacks not set", info.name, stacks))
		end
--@end-debug@]===]
	end

	if (ret) then
		--ret = floor(0.5 + ret)
		if (suffix) then
			return format("%s%s %s", ret, info.amountType or "", suffix), ret
		else
			return format("%s%s", ret, info.amountType or ""), ret
		end
	end
	return ""
end

-- OnEnter
function module:OnEnter(frame)
	if (frame ~= self.frames[3]) then
		frame:SetScript("OnUpdate", nil)
		if (not self.popup) then
			self:MakePopupButton()
		end
		if (not self.popup:IsShown()) then
			self.popup:SetParent(frame)
			self.popup:ClearAllPoints()
			if (db.popupPos == "top") then
				self.popup:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, db.Background.EdgeSize / 2)
			else
				self.popup:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 0, -db.Background.EdgeSize / 2)
			end

			self.popup:FadeIn()
		end
	end
end

-- onLeaveCheckOnUpdate
local function onLeaveCheckOnUpdate(self)
	if (not self:IsMouseOver() and not module.popup:IsMouseOver()) then
		self:SetScript("OnUpdate", nil)
		module.popup:FadeOut()
	end
end

-- OnLeave
function module:OnLeave(frame)
	if (self.popup) then
		if (not frame:IsMouseOver() and not self.popup:IsMouseOver()) then
			module.popup:FadeOut()
		else
			frame:SetScript("OnUpdate", onLeaveCheckOnUpdate)
		end
	end
end

local function dragStart(self)
	self:SetScript("OnUpdate", nil)
	if (module.popup) then
		module.popup:Hide()
	end
	self:StartMoving()
	GameTooltip:Hide()
end
local function dragStop(self)
	self:StopMovingOrSizing()

	local point, parent, relpoint, x, y = self:GetPoint(1)
	parent = UIParent
	local leave
	if (db.popupPos == "top") then
		if (point:find("BOTTOM")) then
			y = y + self:GetHeight()
			point = point:gsub("BOTTOM", "TOP")
		elseif (not point:find("TOP")) then
			y = y + self:GetHeight() / 2
			if (point == "CENTER") then
				point = "TOP"
			else
				point = "TOP"..point
			end
		else
			leave = true
		end
	else
		if (point:find("TOP")) then
			y = y - self:GetHeight()
			point = point:gsub("TOP", "BOTTOM")
		elseif (not point:find("BOTTOM")) then
			y = y - self:GetHeight() / 2
			if (point == "CENTER") then
				point = "BOTTOM"
			else
				point = "BOTTOM"..point
			end
		else
			leave = true
		end
	end
	if (not leave) then
		self:ClearAllPoints()
		self:SetPoint(point, UIParent, relpoint, x, y)
	end

	module:SavePosition(self)
end

local function parentOnDragStart(self)
	return dragStart(self:GetParent())
end

local function parentOnDragStop(self)
	return dragStop(self:GetParent())
end

local function parentOnEnter(self)
	return module:OnEnter(self:GetParent())
end

local function parentOnLeave(self)
	return module:OnLeave(self:GetParent())
end

local info
local function sortList(a, b)
	local _
	local infoA = info.spells[a]
	local infoB = info.spells[b]
	local _, aa = module:GetAmount(infoA, true)
	local _, bb = module:GetAmount(infoB, true)

	if (aa == bb) then
		-- Alpha sort, with exception of spells that require a pet or a runescroll etc. We want plain ones first
		return (((infoA.runescroll or infoA.pet) and "Z" or "A") .. a) < (((infoB.runescroll or infoB.pet) and "Z" or "A") .. b)
	else
		if (type(aa) == type(bb)) then
			return aa > bb
		else
			return (tonumber(aa) or 0) > (tonumber(bb) or 0)
		end
	end
end

local function popupButtonOnLeave(self)
	GameTooltip:Hide()
	module:OnLeave(self:GetParent():GetParent())
end

-- MakePopupButton
function module:MakePopupButton()
	local fname = self.frames[1]:GetName().."Popup"
	local f = CreateFrame("Frame", fname, self.frames[1])
	self.popup = f
	f.buttons = {}
	f:SetScale(0.5)
	f:SetHeight(36)
	f:SetWidth(144)

	local function fadeIn(self, elapsed)
		local a = self:GetAlpha()
		if (a >= 1) then
			self:SetScript("OnUpdate", nil)
			return
		end
		a = min(1, a + elapsed * 2)
		self:SetAlpha(a)
	end

	local function fadeOut(self, elapsed)
		if (self.fadeHold) then
			self.fadeHold = self.fadeHold - elapsed
			if (self.fadeHold <= 0) then
				self.fadeHold = nil
			end
			return
		end

		local a = self:GetAlpha()
		a = a - elapsed * 2
		if (a <= 0) then
			self:Hide()
			self:SetScript("OnUpdate", nil)
		else
			self:SetAlpha(a)
		end
	end

	function f:FadeIn()
		self.fadeHold = nil
		self:Show()
		self:SetAlpha(0)
		self:SetScript("OnUpdate", fadeIn)
	end

	function f:FadeOut()
		if (self:GetAlpha() == 1) then
			self.fadeHold = 0.5
		end
		self:SetScript("OnUpdate", fadeOut)
	end

	f:SetScript("OnShow",
		function(self)
			self:SetScript("OnUpdate", fadeIn)

			if (db.dualframe) then
				self.buttons[1]:Hide()
				self.buttons[2]:SetPoint("TOPRIGHT")
			else
				self.buttons[1]:Show()
				self.buttons[2]:SetPoint("TOPRIGHT", self.buttons[1], "TOPLEFT", -2, 0)
			end
		end
	)

	local plusIcon = select(3, GetSpellInfo(28062))
	local minusIcon = select(3, GetSpellInfo(28085))

	local b = CreateFrame("Button", fname.."Button1", self.popup, "ActionButtonTemplate")
	tinsert(f.buttons, b)
	b:SetPoint("TOPRIGHT")
	b.icon = getglobal(fname.."Button1Icon")
	b.icon:SetTexture(self.frames[1].mode == "buffs" and plusIcon or minusIcon)

	b:SetScript("OnClick",
		function(self)
			if (not db.dualframe) then
				local frame = self:GetParent():GetParent()
				frame:SetMode(frame.mode == "buffs" and "debuffs" or "buffs")
				self.icon:SetTexture(frame.mode == "buffs" and plusIcon or minusIcon)
			end
		end
	)
	b:SetScript("OnEnter",
		function(self)
			module.popup:SetScript("OnUpdate", fadeIn)

			GameTooltip:SetOwner(self, "LEFT")
			GameTooltip:SetText(L["Mode"], 1, 1, 1)
			GameTooltip:AddLine(format(L["Switch mode between |T%s:0|t (Buffs) and |T%s:0|t (Debuffs)"], plusIcon, minusIcon))
			GameTooltip:Show()
		end
	)
	b:SetScript("OnLeave", popupButtonOnLeave)

	local manualIcon = "Interface\\Addons\\Utopia\\Textures\\filtered-off"
	local autoIcon = "Interface\\Addons\\Utopia\\Textures\\filtered-on"

	local b2 = CreateFrame("Button", fname.."Button2", self.popup, "ActionButtonTemplate")
	tinsert(f.buttons, b2)
	b2:SetPoint("TOPRIGHT", b, "TOPLEFT", -2, 0)
	b2.icon = getglobal(fname.."Button2Icon")
	b2.icon:SetTexture(db.automatic and autoIcon or manualIcon)

	b2:SetScript("OnClick",
		function(self)
			db.automatic = not db.automatic
			local frame = self:GetParent():GetParent()
			module:IterateFrames("FlagReset")
			module:IterateFrames("SetMode")
			self.icon:SetTexture(db.automatic and autoIcon or manualIcon)
		end
	)
	b2:SetScript("OnEnter",
		function(self)
			module.popup:SetScript("OnUpdate", fadeIn)

			GameTooltip:SetOwner(self, "LEFT")
			GameTooltip:SetText(L["Automatic Toggle"], 1, 1, 1)
			GameTooltip:AddLine(format(L["Switch mode between |T%s:0|t (Automatic Icon Selection) and |T%s:0|t (Manual Icons)"], autoIcon, manualIcon), nil, nil, nil, 1)
			GameTooltip:Show()
		end
	)
	b2:SetScript("OnLeave", popupButtonOnLeave)

	local allIcon = "Interface\\Addons\\Utopia\\Textures\\automatic-on"
	local availableIcon = "Interface\\Addons\\Utopia\\Textures\\automatic-off"

	local b3 = CreateFrame("Button", fname.."Button3", self.popup, "ActionButtonTemplate")
	tinsert(f.buttons, b3)
	b3:SetPoint("TOPRIGHT", b2, "TOPLEFT", -2, 0)
	b3.icon = getglobal(fname.."Button3Icon")
	b3.icon:SetTexture(db.onlyAvailable and allIcon or availableIcon)

	b3:SetScript("OnClick",
		function(self)
			db.onlyAvailable = not db.onlyAvailable
			local frame = self:GetParent():GetParent()
			module:IterateFrames("FlagReset")
			module:IterateFrames("SetMode")
			self.icon:SetTexture(db.onlyAvailable and allIcon or availableIcon)
		end
	)
	b3:SetScript("OnEnter",
		function(self)
			module.popup:SetScript("OnUpdate", fadeIn)

			GameTooltip:SetOwner(self, "LEFT")
			GameTooltip:SetText(L["Available Only Toggle"], 1, 1, 1)
			GameTooltip:AddLine(format(L["Switch mode between |T%s:0|t (All Icons) and |T%s:0|t (Only Available Icons)"], allIcon, availableIcon), nil, nil, nil, 1)
			GameTooltip:Show()
		end
	)
	b3:SetScript("OnLeave", popupButtonOnLeave)

	f:SetAlpha(0)
	f:Hide()
	return f
end

-- MakeBaseFrame
function module:MakeBaseFrame(name)
	local frame = CreateFrame("Frame", name, UIParent)
	frame:SetHeight(1)
	frame:SetWidth(1)
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)

	frame:SetScale(db.scale)
	module:RestorePosition(frame)

	frame.icons = {}

	return frame
end

-- GetUnitSpellInfo
function module:GetUnitSpellInfo(unit, mode, spellName)
	local spell = module.lookup[mode][spellName]
	if (spell and spell.identify) then
		local valid, other = spell.identify(self.unit or "player")
		if (not valid and other) then
			spell = self.buffs[spell.key].spells[other]
--[===[@debug@
			assert(spell)
--@end-debug@]===]
		end
	end
	return spell
end

local function iconDragStart(self, button)
--d("iconDragStart(%s, %s)", tostring(self:GetName()), tostring(button))
	if (button == "RightButton") then
		
		
	else
		dragStart(self:GetParent(), button)
	end
end
local function iconDragStop(self, button)
--p("iconDragStop(%s, %s)", tostring(self:GetName()), tostring(button))
	if (button == "RightButton") then
		
	else
		dragStop(self:GetParent(), button)
	end
end

do
	-- ICON FUNCTIONS --

	-- icon.OnEnter
	local function iconOnEnter(self)
		parentOnEnter(self)
		GameTooltip:SetOwner(self, "LEFT")
		GameTooltip:SetText(self.key, 1, 1, 1)

		info = module[self.mode][self.key]					-- DO NOT LOCALIZE, it's up there with the sortList func
		if (not info) then
			return
		end

		local list = new()
		for name,spellInfo in pairs(info.spells) do
			tinsert(list, name)
		end
		sort(list, sortList)

		local unit = self:GetParent().unit
		local active, missing = module:GetActiveAurasForKey(unit, self.mode, self.key)
		local bestAmount

		for i = 1,#list do
			local name = list[i]
			local spellInfo = info.spells[name]

			local canDo = module.spellPotential[name]
			if (not canDo) then
				if (petClasses[spellInfo.class]) then
					canDo = module.petPotential and module.petPotential[name]
				end
			end
			if (spellInfo.runescroll and db.alwaysRuneScrolls) then
				canDo = 1
			end
			local div = canDo and 1 or 1.6

			local c = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[spellInfo.class]
			local potentialAmount, potentialAmountNum = module:GetAmount(spellInfo)

			if (potentialAmountNum) then
				if (not bestAmount or potentialAmountNum > bestAmount) then
					-- Items are already sorted highest first
					bestAmount = potentialAmountNum
				end
				if (bestAmount and potentialAmountNum < bestAmount) then
					r, g, b = 1, 1, 0.3
				else
					r, g, b = 1, 1, 1
				end
			else
				r, g, b = 1, 1, 1
			end

			if (spellInfo.runescroll) then
				local itemName = GetItemInfo(spellInfo.runescroll)
				if (not itemName) then
					if (not module.TempTooltip) then
						module.TempTooltip = CreateFrame("GameTooltip")
					end
					module.TempTooltip:SetHyperlink("item:"..spellInfo.runescroll)
					module.TempTooltip:Hide()
					itemName = "Runescroll/Drums"		-- Not going to localise, as it's only the first time you mouseover
				end
				GameTooltip:AddDoubleLine(itemName, potentialAmount, 1 / div, 0.7 / div, 0.7 / div, r / div, g / div, b / div)
			elseif (spellInfo.pet) then
				GameTooltip:AddDoubleLine(format("%s (%s)", name, spellInfo.pet), potentialAmount, c.r / div, c.g / div, c.b / div, r / div, g / div, b / div)
			else
				GameTooltip:AddDoubleLine(name, potentialAmount, c.r / div, c.g / div, c.b / div, r / div, g / div, b / div)
			end

			if (canDo or (active and active[name])) then
	  			GameTooltip:AddTexture(active and active[name] and "Interface\\RAIDFRAME\\ReadyCheck-Ready" or "Interface\\RaidFrame\\ReadyCheck-NotReady")
			end

			local act = active and active[name]
			if (act) then
				local auraCaster = act.caster
				local pet
				if (auraCaster and strfind(auraCaster, "pet")) then
					pet = auraCaster
					auraCaster = auraCaster:gsub("(%a+)pet(%d+)", "%1%2")
				end

				if (not spellInfo.class or not auraCaster or select(2, UnitClass(auraCaster)) == spellInfo.class) then
					local actualAmount = module:GetAmount(spellInfo, nil, nil, auraCaster, act.name, act.rank, act.tex, act.count, act.debuffType, act.duration, act.endTime, act.isStealable)
					local who
					if (pet) then
						who = format(L["  by %s (%s's pet)"], module:ColourPlayer(pet), module:ColourPlayer(auraCaster))
					else
						who = format(L["  by %s"], auraCaster and module:ColourPlayer(auraCaster) or UNKNOWN)
					end

					if (actualAmount < potentialAmount) then
						GameTooltip:AddDoubleLine(who, actualAmount, 0.5, 0.5, 0.5, 1, 0.25, 0.25)
					else
						GameTooltip:AddLine(who, 0.5, 0.5, 0.5)
					end
				end
			end

			if (module.bloodlustList[spellInfo.id]) then
				local ready, cooldown, whoCanCast, benefitRatio = module:GetBloodlustAvailable()
				if (ready) then
					GameTooltip:AddLine(format(L["|cFF00FF00Ready!|r (%s)"], whoCanCast), 1, 1, 1)
				elseif (cooldown and cooldown ~= -1) then
					GameTooltip:AddLine(format(L["|cFFFF8080Cooldown:|r %s"], date("%X", cooldown)), 1, 1, 1)
				end
				if (benefitRatio and benefitRatio > 0 and benefitRatio < 100) then
					GameTooltip:AddLine(format(L["%d%% without %s debuff"], benefitRatio, satedDebuff), 1, 1, 1)
				end
			end
		end
		del(list)

		if (db.hints) then
			local blank
			if (db.modules.Details) then
				blank = true
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(L["|cFF80FF80Left Click|r for details"])
			end

			local who, spellId = module:ReportMissingIcon(unit, self.mode, self.key, true)
			if (who and spellId) then
				if (not UnitIsUnit(who, "player")) then
					if (not blank) then
						blank = true
						GameTooltip:AddLine(" ")
					end
					GameTooltip:AddLine(format(L["|cFF80FF80Right Click|r to ask %s for %s"], module:ColourPlayer(who), module:LinkSpell(spellId)))
				end
			end

			if (module:HasCancelableAurasForIcon(self)) then
				if (not blank) then
					GameTooltip:AddLine(" ")
				end
				GameTooltip:AddLine(L["|cFF80FF80Shift-Right Click|r to cancel auras"])
			end
		end

		GameTooltip:Show()

		deepDel(active)
		del(missing)
	end

	-- icon.OnLeave
	local function iconOnLeave(self)
		parentOnLeave(self)
		GameTooltip:Hide()
	end

	-- icon.ShowCountdown
	local function iconShowCountdown(self)
		local cd = self.countdown
		local timeLeft = self.timeLeft
		if (timeLeft < 0) then
			cd:Hide()
		elseif (timeLeft <= db.minCountdown) then
			if (timeLeft >= 86400) then
				cd:SetFormattedText("%dd", timeLeft / 86400)
			elseif (timeLeft >= 3600) then
				cd:SetFormattedText("%dh", timeLeft / 3600)
			elseif (timeLeft >= 60) then
				cd:SetFormattedText("%dm", timeLeft / 60)
			elseif (timeLeft >= 1) then
				cd:SetFormattedText("%d", floor(timeLeft))
			else
				cd:SetFormattedText(".%d", timeLeft * 10)
			end
			cd:Show()
		else
			cd:Hide()
		end
	end

	-- icon.OnUpdateCountdown
	local function iconOnUpdateCountdown(self, elapsed)
		self.refresh = self.refresh - elapsed
		self.timeLeft = self.timeLeft - elapsed

		if (self.refresh <= 0) then
			if (self.timeLeft > 60) then
				self.refresh = 1
			elseif (self.timeLeft <= 2) then
				self.refresh = 0
			else
				self.refresh = 0.2
			end
			self:ShowCountdown()
		end
	end

	-- icon.HideCooldown
	local function iconHideCooldown(self)
		if (self.cooldown) then
			self.cooldown:Hide()
		end
		if (self.countdown) then
			self:SetScript("OnUpdate", nil)
			self.countdown:Hide()
		end
	end

	-- icon.ShowCooldown
	local function iconShowCooldown(self, duration, endTime)
		local cd = self.cooldown
		local countdownParent = self
		local valid = duration and duration > 0 and endTime and endTime > GetTime() 
		if (valid and db.showCooldown) then
			if (not cd) then
				cd = CreateFrame("Cooldown", nil, self)
				cd:SetAllPoints()
				cd:SetReverse(true)
				self.cooldown = cd
			else
				cd:Show()
			end

			cd:SetDrawEdge(db.drawEdge)
			cd:SetCooldown(endTime - duration, duration)
			countdownParent = cd
		else
			if (cd) then
				cd:Hide()
			end
		end

		local parent = cd and cd:IsShown() and self.cooldown or self

		cd = self.countdown
		if (valid and db.showCountdown) then
			if (not cd) then
				cd = countdownParent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
				cd:SetPoint("BOTTOM")
				cd:SetTextColor(1, 1, 1)
				self.countdown = cd
			else
				cd:SetParent(countdownParent)
				cd:Show()
			end
			self.timeLeft = endTime - GetTime()
			self.duration = duration
			self.refresh = 1
			self:ShowCountdown()
			self:SetScript("OnUpdate", iconOnUpdateCountdown)
		else
			self.timeLeft, self.duration, self.refresh = nil
			self:SetScript("OnUpdate", nil)
			if (cd) then
				cd:Hide()
			end
		end
	end

	-- icon.Activate
	local function iconActivate(self, debuff, caster, duration, endTime)
		self.toggle = "on"
		local c = db.colour.active

		local info = module.lookup[self.mode][debuff]
		if (info and info.improved) then
			local points = LGT:UnitHasTalent(caster, info.improved)
			if (not points or points < info.maxTalentPoints) then
				c = db.colour.partActive
			end
		end

		self.tex:SetVertexColor(c.r, c.g, c.b, c.a)

		self:ShowCooldown(duration, endTime)

		if (GameTooltip:IsOwned(self)) then
			self:OnEnter()
		end
	end

	-- icon.ShowCount
	local function iconShowCount(self, count)
		if (count and count < 100) then
			if (not self.count) then
				self.count = self:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
				self.count:SetPoint("TOPLEFT", -2, 0)
				self.count:SetPoint("BOTTOMRIGHT", 2, 0)
			end
			self.count:SetFormattedText("%d%%", count)
			local r, g, b = SmoothColour(count / 100)
			self.count:SetTextColor(r, g, b)
			self.count:Show()

		elseif (self.count) then
			self.count:Hide()
		end

		if (GameTooltip:IsOwned(self)) then
			self:OnEnter()
		end
	end

	-- icon.Deactivate
	local function iconDeactivate(self, tempOnly)
		self.toggle = "off"
		local c = db.colour[tempOnly and "temporary" or "inactive"]
		self.tex:SetVertexColor(c.r, c.g, c.b, c.a)
		if (self.count) then
			self.count:Hide()
		end
		if (GameTooltip:IsOwned(self)) then
			self:OnEnter()
		end
	end

	-- icon.Unavailable
	local function iconUnavailable(self, excluded)
		if (self.toggle and self:IsShown()) then
			local frame = self:GetParent()
			frame.totalAvailable = max(0, frame.totalAvailable - 1)
			if (not self.tempOnly) then
				frame.totalAvailableNonTemporary = max(0, frame.totalAvailableNonTemporary - 1)
			end
		end
		self.toggle = nil
		local c = db.colour[excluded and "excluded" or "unavailable"]
		self.tex:SetVertexColor(c.r, c.g, c.b, c.a)
		if (self.count) then
			self.count:Hide()
		end
		if (GameTooltip:IsOwned(self)) then
			self:OnEnter()
		end
	end

	-- button.OnClick
	local function buttonOnClick(self, button)
		if (button == "LeftButton") then
			module:ToggleDetailsSuper(self.mode, self.key)
		elseif (button == "RightButton") then
			if (IsShiftKeyDown()) then
				module:CancelAurasForIcon(self)
			else
				module:ReportMissingIcon(self:GetParent().unit, self.mode, self.key)
			end
		end
	end

	-- FRAME FUNCTIONS --

	-- frame.OnUpdate
	local function frameOnUpdate(self, elapsed)
		if (self.waitUpdate) then
			self.waitUpdate = self.waitUpdate + 1
			if (self.waitUpdate > 1) then
				self.waitUpdate = nil
				module:OnRaidRosterUpdate()
				self:SetScript("OnUpdate", nil)
			end
		end
	end

	-- frame.TriggerRosterUpdate
	local function frameTriggerRosterUpdate(self)
		self.waitUpdate = 0
		self:SetScript("OnUpdate", frameOnUpdate)
	end

	-- frame.OnShow
	local function frameOnShow(self)
		self.lastTargetGUID = ""
		self:SetTargetUnit()
		self:RedrawIfNewGUID()
		self:RegisterEvent("UNIT_AURA")
	end

	-- frame.OnHide
	local function frameOnHide(self)
		self:UnregisterEvent("UNIT_AURA")
	end

	-- frame.OnEvent
	local function frameOnEvent(self, event, ...)
		local f = self[event]
		if (f) then
			f(self, ...)
		end
	end

	-- SetIconSize
	local function frameSetIconSize(self)
		for i,icon in pairs(self.icons) do
			icon:SetWidth(db.size)
			icon:SetHeight(db.size)
		end
		self:SetFrameSize()
		module:SavePosition(self)
	end

	-- frame.SetTitle
	local function frameSetTitle(self)
		if (self:IsShown() and self.backdrop and self.backdrop:IsShown()) then
			local gotTalents = LGT:GetTalentCount()
			local raidSize = GetNumRaidMembers()
			if (raidSize == 0) then
				raidSize = GetNumPartyMembers() + 1
			end
			if (gotTalents < raidSize) then
				local perc = gotTalents / raidSize
				local r1, g1, b1 = SmoothColour(max(0, perc - 0.33))
				local r2, g2, b2 = SmoothColour(min(1, perc + 0.33))
				self.backdrop.title:SetText(Gradient(format(L["Talents %d/%d"], gotTalents, raidSize), r1, g1, b1, r2, g2, b2))
				return
			else
				if (UnitExists(self.unit) and not UnitIsUnit("player", self.unit)) then
					if (self.mode == "buffs" and (UnitInParty(self.unit) or UnitInRaid(self.unit)) or not UnitIsFriend("player", self.unit)) then
						local r, g, b
						if (UnitIsPlayer(self.unit)) then
							local _, class = UnitClass(self.unit)
							local c = class and (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
							if (c) then
								r, g, b = c.r, c.g, c.b
							else
								r, g, b = module:ReactionColour(self.unit)
							end
						else
							r, g, b = module:ReactionColour(self.unit)
						end
						self.backdrop.title:SetText(UnitFullName(self.unit))
						self.backdrop.title:SetTextColor(r, g, b)
						return
					end
				end
			end

			if (db.dualframe) then
				self.backdrop.title:SetFormattedText("%s %s", module.label, self.mode == "buffs" and L["Buffs"] or L["Debuffs"])
			else
				self.backdrop.title:SetText(module.label)
			end
			self.backdrop.title:SetTextColor(1, 1, 1)
		end
	end

	-- frame.SetFrameSize
	local function frameSetFrameSize(self)
		local db = db
		local cols = db.columns
		local rows = ceil((self.shown + self.fakeShown) / cols)
		local size = db.size

		if (db.orientation == "H") then
			self:SetWidth(size * cols + (db.hspacing * (cols - 1)))
			self:SetHeight(size * rows + (db.vspacing * (rows - 1)) + (db.bar and db.barwidth or 0) + self.extraVSize)
		else
			self:SetWidth(size * rows + (db.hspacing * (rows - 1)) + (db.bar and db.barwidth or 0) + self.extraVSize)
			self:SetHeight(size * cols + (db.vspacing * (cols - 1)))
		end
	end

	-- frame.SetBarOrientation
	local function frameSetBarOrientation(self, info, n)
		if (n == "B" or n == "T") then
			db.side = n
		end

		self:SetFrameSize()
		if (self.bar) then
			self.bar:ClearAllPoints()
			if (db.orientation == "H") then
				if (db.side == "B") then
					self.bar:SetPoint("BOTTOMLEFT")
					self.bar:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, db.barwidth)
				else
					self.bar:SetPoint("TOPLEFT")
					self.bar:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, -db.barwidth)
				end
			else
				if (db.side == "B") then
					self.bar:SetPoint("TOPRIGHT")
					self.bar:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", -db.barwidth, 0)
				else
					self.bar:SetPoint("TOPLEFT")
					self.bar:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", db.barwidth, 0)
				end
			end
		end
	end

	-- frame.SetOrientation
	local function frameSetOrientation(self)
		self.shown = 0
		self.fakeShown = 0
		self.extraVSize = 0
		local prev, prevRow

		local keySortCounts = new()
		for i,icon in ipairs(self.icons) do
			if (icon:IsShown()) then
				keySortCounts[icon.keySort] = (keySortCounts[icon.keySort] or 0) + 1
			end
		end

		for i,icon in ipairs(self.icons) do
			if (icon:IsShown()) then
				self.shown = self.shown + 1
				icon:ClearAllPoints()
				if (prev) then
					local specialBreak = prev and (db.automatic or self == module.frames[3]) and icon.keySort ~= prev.keySort
					local rowRemaining = db.columns - (self.shown + self.fakeShown - 1) % db.columns
					local endOfRow = rowRemaining == db.columns

					if (endOfRow or ((specialBreak and rowRemaining < keySortCounts[icon.keySort] + 1) and db.columns > 1)) then
						local extraVSize = 0
						if (specialBreak) then
							if (not endOfRow) then
								self.fakeShown = self.fakeShown + rowRemaining
							end
							extraVSize = floor(db.size / 4)
							self.extraVSize = self.extraVSize + extraVSize
						end
						if (db.orientation == "H") then
							icon:SetPoint("TOPLEFT", prevRow, "BOTTOMLEFT", 0, -(db.vspacing + extraVSize))
						else
							icon:SetPoint("TOPLEFT", prevRow, "TOPRIGHT", db.hspacing + extraVSize, 0)
						end
						prevRow = icon
					else
						local extraSpacing = 0
						if (specialBreak) then
							extraSpacing = db.size
							self.fakeShown = self.fakeShown + 1
						end
						if (db.orientation == "H") then
							icon:SetPoint("TOPLEFT", prev, "TOPRIGHT", db.hspacing + extraSpacing, 0)
						else
							icon:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -(db.vspacing + extraSpacing))
						end
					end
				else
					if (db.side == "T") then
						if (db.orientation == "H") then
							icon:SetPoint("TOPLEFT", 0, -db.barwidth)
						else
							icon:SetPoint("TOPLEFT", db.barwidth, 0)
						end
					else
						icon:SetPoint("TOPLEFT")
					end
					prevRow = icon
				end
				prev = icon
			end
		end
		del(keySortCounts)
		self:SetBarOrientation()
		self:UpdateBackdrop()
	end

	-- frame.SetLocked
	local function frameSetLocked(self)
		if (self.bar) then
			self.bar:EnableMouse(not db.locked or configMode)
		end

		for i,icon in pairs(self.icons) do
			if (db.locked and not configMode) then
				icon:RegisterForDrag(nil)
			else
				icon:RegisterForDrag("LeftButton")		-- ,RightButton
			end
		end

		if (self.backdrop) then
			self.backdrop:EnableMouse(not db.locked or configMode)
		end
	end

	-- frame.UpdateBackdrop
	local bgFrame = {insets = {}}
	local function frameUpdateBackdrop(self)
		if (db.Background.Enable) then
			bgFrame.bgFile = SM:Fetch("background", db.Background.Texture)
			bgFrame.edgeFile = SM:Fetch("border", db.Background.BorderTexture)
			bgFrame.tile = db.Background.Tile
			bgFrame.tileSize = db.Background.TileSize
			bgFrame.edgeSize = db.Background.EdgeSize
			local inset = floor(db.Background.EdgeSize / 4)
			bgFrame.insets.left = inset
			bgFrame.insets.right = inset
			bgFrame.insets.top = inset
			bgFrame.insets.bottom = inset

			local bd = self.backdrop
			if (not bd) then
				-- Backdrop is going to be larger than the frame proper
				bd = CreateFrame("Frame", nil, self)
				self.backdrop = bd
				bd:SetFrameLevel(self:GetFrameLevel() - 1)
				bd:SetScript("OnDragStart", parentOnDragStart)
				bd:SetScript("OnDragStop", parentOnDragStop)
				bd:SetScript("OnEnter", parentOnEnter)
				bd:SetScript("OnLeave", parentOnLeave)

				bd:RegisterForDrag("LeftButton")
				if (not db.locked or configMode) then
					bd:EnableMouse(true)
				end

				bd.title = bd:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
				bd.title:SetText(self.label)
				bd.title:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -1, 1)
				bd.title:SetPoint("TOPRIGHT", self, "TOPRIGHT", 1, 11)
				bd.title:SetJustifyH("LEFT")
			end

			local esd2 = db.Background.EdgeSize / 2
			bd:ClearAllPoints()
			bd:SetPoint("TOPLEFT", -esd2, esd2)
			bd:SetPoint("BOTTOMRIGHT", esd2, -esd2)
	
			bd:SetBackdrop(bgFrame)
	
			local c = db.Background.Color
			bd:SetBackdropColor(c.r, c.g, c.b, c.a)

			self:DoBackdropColour()
			bd:Show()

		elseif (self.backdrop) then
			self.backdrop:Hide()
		end
	end

	-- frame.EnableBar
	local function frameEnableBar(self)
		if (db.bar) then
			if (not self.bar) then
				self:CreateFramesBar()
			end
			self.bar:Show()
		else
			if (self.bar) then
				self.bar:Hide()
			end
		end
		self:SetFrameSize()
	end

	-- frame.CreateFramesBar
	local function frameCreateFramesBar(self)
		if (db.bar) then
			local bar = CreateFrame("StatusBar", self:GetName().."Bar", self)
			self.bar = bar

			bar:SetStatusBarTexture(SM:Fetch("statusbar", db.texture))
			bar:SetStatusBarColor(0, 1, 0)
			bar:SetMinMaxValues(0, self.shown or 1)

			bar:RegisterForDrag("LeftButton")
			bar:SetScript("OnDragStart", parentOnDragStart)
			bar:SetScript("OnDragStop", parentOnDragStop)
			bar:SetScript("OnEnter", parentOnEnter)
			bar:SetScript("OnLeave", parentOnLeave)

			bar.bg = bar:CreateTexture(nil, "BACKGROUND")
			bar.bg:SetAllPoints()
			bar.bg:SetTexture(SM:Fetch("statusbar", db.texture))
			bar.bg:SetVertexColor(0, 1, 0, 0.3)

			if (not db.locked or configMode) then
				bar:EnableMouse(true)
			end
		end
	end

	-- frame.UpdateProgressBar
	local function frameUpdateProgressBar(self)
		if (self.bar) then
			local total = max(self.progress, UnitAffectingCombat("player") and self.totalAvailable or self.totalAvailableNonTemporary)
			self.bar:SetMinMaxValues(0, total)
			self.bar:SetValue(self.progress)
			local r, g, b = SmoothColour(self.progress / total)
			self.bar:SetStatusBarColor(r, g, b)
			self.bar.bg:SetVertexColor(r, g, b, 0.3)
		end
	end

	-- frame.UpdateBuffs
	local function frameUpdateBuffs(self)
		if (not self:IsShown() or not module.spellPotential) then
			self.lastTargetGUID = ""
			return
		end

		self:AllOff()

		local unit, auraType
		unit = self.unit
		auraType = self.mode == "buffs" and "HELPFUL" or "HARMFUL"

		local on = 0
		for i = 1,1000 do
			local name, rank, tex, count, debuffType, duration, endTime, caster, isStealable = UnitAura(unit, i, auraType)
			if (name == nil) then
				break
			end

			on = on + self:AddActiveAura(name, caster, count, duration, endTime)
		end

		local totems = module:AllActiveBufflessTotems()
		for casterGUID,bufflessTotems in pairs(totems) do
			for school,name in pairs(bufflessTotems) do
				on = on + self:AddActiveAura(name)
			end
		end

		self.progress = on
		self:UpdateProgressBar()
		self:DoBackdropColour()
	end

	-- frame.DoBackdropColour
	local function frameDoBackdropColour(self)
		local bd = self.backdrop
		if (bd) then
			if (db.Background.BorderColourAsStatus) then
				local num = UnitAffectingCombat("player") and self.totalAvailable or self.totalAvailableNonTemporary
				if (num) then
					local perc = self.progress / max(self.progress or 0, num)
					local r, g, b = SmoothColour(perc)
					bd:SetBackdropBorderColor(r, g, b, db.Background.BorderColor.a)
				end
			else
				local c = db.Background.BorderColor
				bd:SetBackdropBorderColor(c.r, c.g, c.b, c.a)
			end
		end
	end

	-- frame.AddActiveAura
	-- *** RECURSIVE ***
	local function frameAddActiveAura(self, name, caster, count, duration, endTime)
		local on = 0
		local icon, spell = self:GetIconForSpell(name)
		if (icon and icon:IsShown()) then
			icon:Activate(name, caster, duration, endTime)
			if (count and count > 0 and spell.maxStacks) then
				icon:ShowCount(100 * count / spell.maxStacks)
			end
			on = on + 1

			if (not icon.data) then
				icon.data = new()
			end
			icon.data[name] = caster
		end

		if (spell and spell.multiple) then
			for i,key in ipairs(spell.multiple) do
				local icon = self:GetIconForKey(key)
				if (icon) then
					icon:Activate(name, caster, duration, endTime)
					if (count and count > 0 and spell.maxStacks) then
						icon:ShowCount(100 * count / spell.maxStacks)
					end
					on = on + 1
					if (not icon.data) then
						icon.data = new()
					end
					icon.data[name] = caster
				end
			end
		end

		local exclusive
		if (spell) then
			exclusive = spell.exclusive or spell.totem
		else
			-- Check if it's in the exclusive list that lists un-monitored spells
			local ex = module.otherBuffs[name]
			if (ex) then
				exclusive = ex.exclusive or ex.totem
			end

			if (not exclusive) then
				-- Check if it's a buffless totem
				exclusive = totemSpells[name]
			end
		end

		if (exclusive) then
			-- Handle exclusive auras (Paladin Judgements/Blessings, Warlock Curses, Warrior Shouts, Totems etc)

			-- We have a pre-built list of paired exclusive spell names in module.exclusive
			local list = module.exclusive[exclusive]
			if (list) then
				for spellname in pairs(list) do
					if (spellname ~= name) then			-- Don't check current spell
						local icon2, spell2 = self:GetIconForSpell(spellname)
						if (icon2 and icon2:IsShown() and icon2.toggle == "off") then
							-- Found a potentially unavailable aura because the caster has already done something
							-- of the same class. Now we need to check if there are any other people who could cast
							-- this before we flag the icon as unavailable

							-- Now we have a possibly conflicting icon, we'll go through each of the spells that
							-- affects this icon and see if there's anyone who can cast it
							local spells = module[self.mode][spell2.key].spells
							local canCast = 0
							if (spells) then
								for name,spellInfo in pairs(spells) do
									local canDo = module.spellPotential[name]
									if (canDo) then							-- Quick check first
										-- Now count who can do it
										if (spellInfo.required) then
											-- Spell requires a talent, so check who can cast it
											for unit in module:IterateRoster() do
												if (not UnitIsUnit(unit, caster)) then
													local _, class = UnitClass(unit)
													if (class == spellInfo.class) then
														if (LGT:UnitHasTalent(unit, spellInfo.required)) then
															if (not (spellInfo.exclusive or spellInfo.totem) or not module:HasExclusiveAura(self.mode, self.unit, spellInfo.exclusive or spellInfo.totem, UnitGUID(unit))) then
																canCast = canCast + 1
															end
														end
													end
												end
											end
										else
											-- No requirements, add classcount
											canCast = canCast + module.classcount[spellInfo.class]
											if (spellInfo.exclusive or spellInfo.totem) then
												-- And remove how many auras of this class there are active
												canCast = canCast - module:ExclusiveAuraCount(self.mode, self.unit, spellInfo.exclusive or spellInfo.totem)
											end
										end
									end
								end
							end

							if (canCast == 0) then
								icon2:Unavailable(true)
							end
						end
					end
				end
			end
		end

		local mappings = module.mappingLookup[name]
		if (mappings) then
			for i,mapping in ipairs(mappings) do
				if (not mapping.requiredTalent or (caster and LGT:UnitHasTalent(caster, mapping.requiredTalent))) then
--[===[@debug@
					assert(mapping.key ~= name)			-- Would trigger a stack overflow
--@end-debug@]===]
					on = on + self:AddActiveAura(mapping.key, caster, count, duration, endTime)
				end
			end
		end

		return on
	end

	-- frame.GetIconForKey
	local function frameGetIconForKey(self, key)
		local index = self.keysLookup[key]
		if (index) then
			return self.icons[index]
		end
	end

	-- frame.GetIconForSpell
	local function frameGetIconForSpell(self, spellName)
		local spell = module:GetUnitSpellInfo(self.unit or "player", self.mode, spellName)
		if (spell) then
			return self:GetIconForKey(spell.key), spell
		end
	end

	-- frame.AllOff
	local function frameAllOff(self)
		self.totalAvailable = 0
		self.totalAvailableNonTemporary = 0

		for i,icon in ipairs(self.icons) do
			icon.data = deepDel(icon.data)
			icon:HideCooldown()

			if (icon:IsShown()) then
				local section = module[self.mode][icon.key]
				local exclude = section and section.exclude
				icon.tempOnly = nil

				local temp, nontemp = 0, 0
				for spellName,info in pairs(section.spells) do
					if (module.spellPotential[spellName]) then
						if (info.temporary or (info.totem and db.totemsTemporary)) then
							temp = temp + 1
						else
							nontemp = nontemp + 1
						end
					end
				end

				if (nontemp > 0 or temp > 0) then
					self.totalAvailable = self.totalAvailable + 1
				end
				if (nontemp > 0 and temp == 0) then
					self.totalAvailableNonTemporary = self.totalAvailableNonTemporary + 1
				elseif (temp > 0 and nontemp == 0) then
					icon.tempOnly = true
				end

				if (exclude and exclude(self.unit)) then
					icon:Unavailable(true)
				else
					local pot = module.potential[self.mode]
					if (pot and pot[icon.key]) then
						icon:Deactivate(not UnitAffectingCombat("player") and icon.tempOnly)
					else
						if (module.petPotentialKeys and module.petPotentialKeys[icon.key]) then
							icon:Deactivate(not UnitAffectingCombat("player") and icon.tempOnly)
						else
							icon:Unavailable()
						end
					end
				end
			end
		end
		if (self.bar) then
			self.bar:SetMinMaxValues(0, UnitAffectingCombat("player") and self.totalAvailable or self.totalAvailableNonTemporary)
			self.bar:SetValue(0)
			self.bar:SetStatusBarColor(1, 0, 0)
			self.bar.bg:SetVertexColor(1, 0, 0, 0.3)
		end
	end

	local keySort
	-- sortFuncKeySort
	local function sortFuncKeySort(a, b)
		if (keySort[a] == keySort[b]) then
			return a < b
		else
			return keySort[a] < keySort[b]
		end
	end

	-- CreateAuraIcon
	local function frameCreateAuraIcon(self)
		-- TODO: Mouseover highlight and other eye-candy
		-- And fix the sizing problem on startup
		local icon = CreateFrame("Button", self:GetName()..(#self.icons + 1), self)
		icon.tex = icon:CreateTexture(nil, "OVERLAY")
		icon.tex:SetAllPoints()

		icon.parent = self
		icon:SetWidth(db.size)
		icon:SetHeight(db.size)
		icon:EnableMouse(true)

		if (not db.locked or configMode) then
			icon:RegisterForDrag("LeftButton")		-- ,RightButton
		end
		icon:RegisterForClicks("AnyUp")

		icon.OnEnter = iconOnEnter
		icon.OnLeave = iconOnLeave

		icon:SetScript("OnEnter", iconOnEnter)
		icon:SetScript("OnLeave", iconOnLeave)
		icon:SetScript("OnDragStart", iconDragStart)
		icon:SetScript("OnDragStop", iconDragStop)
		icon:SetScript("OnClick", buttonOnClick)

		icon.Activate = iconActivate
		icon.Deactivate = iconDeactivate
		icon.Unavailable = iconUnavailable
		icon.ShowCount = iconShowCount
		icon.ShowCooldown = iconShowCooldown
		icon.ShowCountdown = iconShowCountdown
		icon.HideCooldown = iconHideCooldown

		return icon
	end

	-- frame.SetMode
	local function frameSetMode(self, mode)
		if (mode == true) then
			self.lastTargetGUID = nil
			mode = nil
		end
		if (db.dualframe) then
			if (mode) then
				self.mode = mode
			else
				self.mode = self == module.frames[1] and "buffs" or "debuffs"
			end
		else
			if (mode) then
				assert(mode == "buffs" or mode == "debuffs")
				db.mode = mode
			elseif (not db.mode) then
				db.mode = "debuffs"
			end
			self.mode = db.mode
		end
		mode = self.mode

		self:SetTargetUnit()

		-- checkUnit is for role determination when viewing other players
		local checkUnit = module.frames and module.frames[1] and module.frames[1].unit
		if (checkUnit and not UnitIsFriend("player", checkUnit)) then
			checkUnit = nil
		end
		local mana = UnitPowerMax(checkUnit or "player", 0) > 0
		local role = LGT:GetUnitRole(checkUnit or "player")

		del(self.keys)
		del(self.keysLookup)
		del(keySort)
		self.keys = new()
		self.keysLookup = new()
		keySort = new()
		for key,data in pairs(module[mode]) do
			local on
			if (db.onlyAvailable) then
				local pot = module.potential[self.mode]
				if (pot and pot[key]) then
					on = true
				else
					if (module.petPotentialKeys and module.petPotentialKeys[key]) then
						on = true
					end
				end
			else
				on = true
			end

			if (on) then
				if (db.automatic) then
					if (db.alwaysStandardBuffs and data.raidbuff and (data.interested ~= "manauser" or mana)) then
						tinsert(self.keys, key)
						keySort[key] = 4

					elseif (data.interested and role) then
						if (strfind(data.interested, role)) then
							-- It's something interesting to my class, so let's see it
							tinsert(self.keys, key)
							keySort[key] = 1

						elseif (mana and strfind(data.interested, "manauser")) then
							tinsert(self.keys, key)
							keySort[key] = 2

						else
							-- Might not be something interesting, but if we can cast it then we show it
							local canCast
							for spellName,spellInfo in pairs(data.spells) do
								if (spellInfo.class == playerClass) then
									if (spellInfo.requiredTalent) then
										if (LGT:UnitHasTalent(playerName, spellInfo.requiredTalent)) then
											canCast = true
											break
										end
									else
										canCast = true
										break
									end
								end
							end
							if (canCast) then
								tinsert(self.keys, key)
								keySort[key] = 3
							end
						end
					else
						tinsert(self.keys, key)
						keySort[key] = 1
					end
				else
					if (not (db.disabled and db.disabled[mode] and db.disabled[mode][key])) then
						tinsert(self.keys, key)
						keySort[key] = 1
					end
				end
			end
		end
		sort(self.keys, sortFuncKeySort)
		for i,key in ipairs(self.keys) do
			self.keysLookup[key] = i
		end

		self.shown = 0
		for i = 1,#self.keys do
			local icon = self.icons[i]
			if (not icon) then
				icon = self:CreateAuraIcon()
				self.icons[i] = icon
			end

			icon.mode = mode
			icon.key = self.keys[i]
			icon.keySort = keySort[icon.key]
			local data = module[mode][icon.key]
			icon.tex:SetTexture(data.icon)

			icon:Show()
			self.shown = self.shown + 1
		end
		for i = #self.keys + 1,#self.icons do
			local icon = self.icons[i]
			if (icon) then
				icon:Hide()
			end
		end
		if (self.bar) then
			self.bar:SetMinMaxValues(0, self.shown)
		end

		keySort = del(keySort)

		self:FlagReset()
		self:RedrawIfNewGUID()

		self:SetOrientation()
	end

	-- frame.SetTargetUnit
	local function frameSetTargetUnit(self)
		if (self.mode == "buffs") then
			if (db.allPlayers and (UnitInRaid("target") or UnitInParty("target"))) then
				self.unit = "target"
			else
				self.unit = "player"
			end
		else
			if (UnitIsEnemy("player", "target") and not UnitIsDead("target")) then
				self.unit = "target"
			elseif (UnitIsEnemy("player", "focus") and not UnitIsDead("focus")) then
				self.unit = "focus"
			elseif (UnitIsEnemy("player", "targettarget") and not UnitIsDead("targettarget")) then
				self.unit = "targettarget"
			elseif (UnitIsEnemy("player", "focustarget") and not UnitIsDead("focustarget")) then
				self.unit = "focustarget"
			else
				self.unit = "target"
			end
			if (not UnitExists(self.unit)) then
				self.unit = "target"
			end
		end
	end

	-- frame.RedrawIfNewGUID
	local function frameRedrawIfNewGUID(self)
		local guid = UnitGUID(self.unit)
		if (guid ~= self.lastTargetGUID) then
			self:UpdateBuffs()
			self.lastTargetGUID = guid
		end
	end

	-- frame.FlagReset
	local function frameFlagReset(self)
		self.lastTargetGUID = ""			-- Mustn't use nil, because with no target, it comes up as the same and won't refresh on Role change with no target
	end

	-- frame.AuraOnUpdate
	local function frameAuraOnUpdate(self)
		local frame = self:GetParent()
		frame:UpdateBuffs()
		self:Hide()
	end

	-- frame.UNIT_AURA
	local function frameUNIT_AURA(self, unit)
		-- Don't use UnitIsUnit(), because we only want to do this once
		-- We'll get the event for each immediate unit anyway
		if (unit == self.unit) then
			self.auraUpdateFrame:Show()		-- Throttle UNIT_AURA's to once per frame
		end
	end

	-- CreateUtopianFrame
	function module:CreateUtopianFrame()
		local frame = self:MakeBaseFrame("UtopiaAnchorFrame"..(#self.frames + 1))

		--frame:SetScript("OnUpdate",	frameOnUpdate)
		frame:SetScript("OnShow",	frameOnShow)
		frame:SetScript("OnHide",	frameOnHide)
		frame:SetScript("OnEvent",	frameOnEvent)

		frame.auraUpdateFrame = CreateFrame("Frame", nil, frame)
		frame.auraUpdateFrame:SetScript("OnUpdate", frameAuraOnUpdate)
		frame.auraUpdateFrame:Hide()

		frame.TriggerRosterUpdate	= frameTriggerRosterUpdate
		frame.SetMode				= frameSetMode
		frame.SetTitle				= frameSetTitle
		frame.SetFrameSize			= frameSetFrameSize
		frame.SetBarOrientation		= frameSetBarOrientation
		frame.SetOrientation		= frameSetOrientation
		frame.UpdateBackdrop		= frameUpdateBackdrop
		frame.UpdateProgressBar		= frameUpdateProgressBar
		frame.DoBackdropColour		= frameDoBackdropColour
		frame.SetIconSize			= frameSetIconSize
		frame.EnableBar				= frameEnableBar
		frame.CreateFramesBar		= frameCreateFramesBar
		frame.SetLocked				= frameSetLocked
		frame.CreateAuraIcon		= frameCreateAuraIcon

		frame.UpdateBuffs			= frameUpdateBuffs
		frame.AddActiveAura			= frameAddActiveAura
		frame.AllOff				= frameAllOff
		frame.GetIconForKey			= frameGetIconForKey
		frame.GetIconForSpell		= frameGetIconForSpell
		frame.FlagReset				= frameFlagReset
		frame.SetTargetUnit			= frameSetTargetUnit
		frame.RedrawIfNewGUID		= frameRedrawIfNewGUID

		frame.UNIT_AURA				= frameUNIT_AURA

		frame:CreateFramesBar()
		frame.mode = db.mode or "debuffs"
		frame:Hide()

		return frame
	end
end

-- GetAuraForName
-- Like UnitAura, but also checks mappings
-- *** RECURSIVE ***
function module:GetAuraForName(unit, name, unitAuraFunc)
	local auraName, auraRank, auraTex, auraCount, auraDebuffType, auraDuration, auraEndTime, auraCaster, auraIsStealable = unitAuraFunc(unit, name)
	if (auraName) then
		auraRank = tonumber(auraRank:match("(%d+)"))
	else
		local mapping = self.mapping[name]
		if (mapping) then
			-- Check for mappings
			for mappingName in pairs(mapping.list) do
				local valid
				auraName, auraRank, auraTex, auraCount, auraDebuffType, auraDuration, auraEndTime, auraCaster, auraIsStealable = self:GetAuraForName(unit, mappingName, unitAuraFunc)
				if (auraName and (auraName ~= mappingName or (not mapping.requiredTalent or (auraCaster and LGT:UnitHasTalent(auraCaster, mapping.requiredTalent))))) then
					valid = true
				else
					auraName, auraCaster = nil, nil
				end
				if (valid) then
					if (type(auraRank) == "string") then
						auraRank = tonumber(auraRank:match("(%d+)"))
					end
					break
				end
			end
		end
	end
	return auraName, auraRank, auraTex, auraCount, auraDebuffType, auraDuration, auraEndTime, auraCaster, auraIsStealable
end

-- GetActiveAurasForKey
function module:GetActiveAurasForKey(unit, mode, key)
	info = module[mode][key]					-- DO NOT LOCALIZE, it's up there with the sortList func
	if (not info) then
		return
	end
	local unitAuraFunc = mode == "buffs" and UnitBuff or UnitDebuff

	local list = new()
	for name,spellInfo in pairs(info.spells) do
		tinsert(list, name)
	end
	sort(list, sortList)

	local active, missing
	for i = 1,#list do
		local name = list[i]
		local spellInfo = info.spells[name]

		local auraName, auraRank, auraTex, auraCount, auraDebuffType, auraDuration, auraEndTime, auraCaster, auraIsStealable = self:GetAuraForName(unit, name, unitAuraFunc)
		if (not auraName and spellInfo.alternate) then
			auraName, auraRank, auraTex, auraCount, auraDebuffType, auraDuration, auraEndTime, auraCaster, auraIsStealable = unitAuraFunc(unit, spellInfo.alternate)
			if (auraName) then
				auraRank = tonumber(auraRank:match("(%d+)"))
			end
		end

		if (auraName) then
			if (spellInfo.identify) then
				if (not spellInfo.identify(unit)) then
					auraName = nil
				end
			end
		end

		if (auraName) then
			if (not active) then
				active = new()
			end
			local n = new()
			active[name] = n
			n.name = auraName
			n.rank = auraRank
			n.tex = auraTex
			n.count = auraCount
			n.type = auraDebuffType
			n.duration = auraDuration
			n.endTime = auraEndTime
			n.caster = auraCaster
			n.isStealable = auraIsStealable
		else
			if (not missing) then
				missing = new()
			end
			missing[name] = true
		end
	end

	return active, missing
end

-- ExclusiveAuraCount
function module:ExclusiveAuraCount(mode, unit, exclusive)
	assert(exclusive)

	local total = 0
	local unitAuraFunc = mode == "buffs" and UnitBuff or UnitDebuff
	for i = 1,1000 do
		local name, rank, tex, count, debuffType, duration, endTime, caster, isStealable = unitAuraFunc(unit, i)
		if (not name) then
			break
		end

		local info = self.lookup[mode][name]
		if (info) then
			if ((info.exclusive or info.totem) == exclusive) then
				total = total + 1
			end
		else
			info = self.otherBuffs[name]
			if (info and (info.exclusive or info.totem) == exclusive) then
				total = total + 1
			end
		end
	end

	local totems = self:AllActiveBufflessTotems()
	for casterGUID,bufflessTotems in pairs(totems) do
		for school,name in pairs(bufflessTotems) do
			if (school == exclusive) then
				total = total + 1
			end
		end
	end

	return total
end

-- HasExclusiveAura
function module:HasExclusiveAura(mode, unit, exclusive, guid)
	assert(exclusive)

	local unitAuraFunc = mode == "buffs" and UnitBuff or UnitDebuff

	for i = 1,1000 do
		local name, rank, tex, count, debuffType, duration, endTime, caster, isStealable = unitAuraFunc(unit, i)
		if (not name) then
			break
		end
		if (caster) then
			local casterGUID = UnitGUID(caster)
			if (casterGUID == guid) then
				local info = self.lookup[mode][name]
				if (info) then
					if (info.exclusive == exclusive or info.totem == exclusive) then
						return info.id
					end
				else
					info = self.otherBuffs[name]
					if (info and (info.exclusive == exclusive or info.totem == exclusive)) then
						return info.id
					end
				end
			end
		end
	end	

	local totems = self:AllActiveBufflessTotems()
	for casterGUID,bufflessTotems in pairs(totems) do
		for school,name in pairs(bufflessTotems) do
			if (school == exclusive) then
				return name
			end
		end
	end
end

-- HasCancelableAurasForIcon
function module:HasCancelableAurasForIcon(icon)
	if (icon.mode == "buffs" and UnitIsUnit(icon:GetParent().unit or "player", "player")) then
		local buffs = self.buffs[icon.key]
		local spellList = buffs and buffs.spells
		if (spellList) then
			for spellName,info in pairs(spellList) do
				local name, rank, tex, count, Type, duration, endTime, caster, isStealable = UnitBuff("player", spellName)
				if (name and duration and duration > 0) then
					return true
				end
				if (info.alternate) then
					local name, rank, tex, count, Type, duration, endTime, caster, isStealable = UnitBuff("player", info.alternate)
					if (name and duration and duration > 0) then
						return true
					end
				end
			end
		end
	end
end

-- CancelAurasForIcon
function module:CancelAurasForIcon(icon)
	if (icon.mode == "buffs" and UnitIsUnit(icon:GetParent().unit or "player", "player")) then
		local buffs = self.buffs[icon.key]
		local spellList = buffs and buffs.spells
		if (spellList) then
			for spellName,info in pairs(spellList) do
				CancelUnitBuff("player", spellName)
				if (info.alternate) then
					CancelUnitBuff("player", info.alternate)
				end
			end
		end
	end
end 

-- BuffNameIfOnlyOne
function module:BuffNameIfOnlyOne(key)
	local ret
	local list = self.buffs[key] and self.buffs[key].spells
	if (list) then
		for spellName,info in ipairs(list) do
			if (ret) then
				return key
			end
			ret = spellName
		end
	end
	return ret
end

-- ReportMissingIcon
function module:ReportMissingIcon(testunit, mode, key, findWho)
	if (select(2, IsInInstance()) == "pvp") then
		return
	end
	info = module[mode][key]							-- DO NOT LOCALIZE, it's up there with the sortList func
	if (not info or not info.reportable) then
		return
	end

	if (mode == "debuffs") then
		if (UnitIsDead(testunit) or not UnitCanAttack("player", testunit)) then
			return
		end
	end

	local active, missing = module:GetActiveAurasForKey(testunit, mode, key)
	if (active) then
		-- Some active spell for this key, so nothing to ask anyone
		deepDel(active)
		del(missing)
		return
	end

	local list = new()
	for name,spellInfo in pairs(info.spells) do
		tinsert(list, name)
	end
	sort(list, sortList)

	local testtype = mode == "buffs" and L["buff"] or L["debuff"]
	local bestUnit, bestSpell, bestAmount, bestPriority, couldCast
	for i = 1,#list do
		local name = list[i]
		local spellInfo = info.spells[name]

		local canDo = module.spellPotential[name]
		if (not canDo) then
			if (petClasses[spellInfo.class]) then
				canDo = module.petPotential and module.petPotential[name]
			end
		end
		local div = canDo and 1 or 2

		if (canDo and (not active or not active[name])) then
			assert(missing and missing[name])

			for unit in self:IterateRoster() do
				local _, class = UnitClass(unit)
				if (class == spellInfo.class) then
					local canCast
					if (spellInfo.requiredTalent) then
						canCast = LGT:UnitHasTalent(unit, spellInfo.requiredTalent)
					else
						canCast = true
					end

					if (canCast) then
						if (spellInfo.exclusive or spellInfo.totem) then
							local id = self:HasExclusiveAura(mode, testunit, spellInfo.exclusive or spellInfo.totem, UnitGUID(unit))
							if (id) then
								if (not couldCast) then
									couldCast = new()
								end

								couldCast[unit] = id
								canCast = nil
							end
						end

						if (canCast) then
							if (UnitIsConnected(unit) and UnitIsVisible(unit) and UnitExists(unit)) then
								if (spellInfo.improved) then
									if (LGT:UnitHasTalent(unit, spellInfo.improved)) then
										local _, amount = self:GetAmount(spellInfo, true, true)
										if (not bestAmount or amount > bestAmount) then
											if (not bestPriority or not spellInfo.priority or spellInfo.priority < bestPriority) then
												bestUnit = unit
												bestSpell = spellInfo
												bestAmount = amount
												bestPriority = spellInfo.priority
											end
										end
									end
								else
									local _, amount = self:GetAmount(spellInfo, true)
									if (not bestAmount or amount > bestAmount) then
										if (not bestPriority or not spellInfo.priority or spellInfo.priority < bestPriority) then
											bestUnit = unit
											bestSpell = spellInfo
											bestAmount = amount
											bestPriority = spellInfo.priority
										end
									end
								end
							end
						end
					end					
				end
			end
		end
	end

	if (findWho) then
		return bestUnit, bestSpell and bestSpell.id, testtype
	end

	if (bestUnit) then
		local spellLink = self:LinkSpell(bestSpell.id)
		if (UnitIsUnit(bestUnit, "player")) then
			if (UnitIsUnit(testunit, "player")) then
				self:Print(format(L["You are missing your own %s %s"], spellLink, testtype))
			else
				self:Print(format(L["%s is missing your own %s %s"], self:ColourPlayer(testunit), spellLink, testtype))
			end
		else
			self:Print(format(L["Notifying %s regarding %s"], self:ColourPlayer(bestUnit), spellLink))
			if (UnitIsUnit(testunit, "player")) then
				SendChatMessage("Utopia> "..format(L["I am missing your %s %s"], spellLink, testtype), "WHISPER", nil, UnitFullName(bestUnit))
			else
				SendChatMessage("Utopia> "..format(L["%s is missing your %s %s"], UnitFullName(testunit), spellLink, testtype), "WHISPER", nil, UnitFullName(bestUnit))
			end
		end
	else
		local spellName = self:BuffNameIfOnlyOne(key)

		self:Print(format(L["There is noone to cast |cFFFFFF80%s|r"], spellName))
		if (couldCast) then
			for unit,spellId in pairs(couldCast) do
				local spell
				if (type(spellId) == "string") then
					spell = spellId
				else
					spell = self:LinkSpell(spellId)
				end
				self:Print(format("%s could cast this but currently has %s active", self:ColourPlayer(unit), spell))
			end
		end
	end

	del(couldCast)
	deepDel(active)
	del(missing)
end

-- LinkSpell
function module:LinkSpell(id)
	return format("|cff71d5ff|Hspell:%d|h[%s]|h|r", id, (GetSpellInfo(id)))
end

do
	local function chatFilterInform(self, event, ...)
		local msg, sender = ...
		if (strfind(msg, "^Utopia>")) then
			return true
		end
		return false
	end

	-- HookChat
	function module:HookChat()
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", chatFilterInform)
	end

	-- z:UnhookChat
	function module:UnhookChat()
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER_INFORM", chatFilterInform)
	end
end

-- CountTree
local function CountTree(branch)
	local count = 0
	for i = 1,#branch do
		count = count + branch:byte(i) - 48
	end
	return count
end

-- ReactionColour
function module:ReactionColour(unit)
	if (not UnitPlayerControlled(unit)) then
		if (UnitIsDeadOrGhost(unit)) then
			return 0.4, 0.4, 0.4
		elseif (UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)) then
			return 0.6, 0.6, 0.6
		else
			local reaction = UnitReaction(unit, "player")
			if (reaction) then
				if (reaction >= 5) then
					return 0, 1, 0
				elseif (reaction <= 2) then
					return 1, 0, 0
				elseif (reaction == 3) then
					return 1, 0.5, 0
				else
					return 1, 1, 0
				end
			end
		end
	end
	return 0, 0.5, 1
end

-- SetOrientation
function module:SetOrientation(self, info, newValue)
	local n
	if (newValue == "V" or newValue == "H") then
		db.orientation = newValue
	elseif (newValue == "T" or newValue == "B") then
		db.side = newValue
	end
	self:IterateFrames("SetOrientation")
end

-- ToggleActive
function module:ToggleActive()
	db.enable = not db.enable
	self:ShowWhen()
	if (db.enable) then
		self:ScanRosterActual()
		self:IterateFrames("SetTitle")
	end
end

-- ShouldShow
function module:ShouldShow()
	local show = db.show.always
	if (not show) then
		local pvpInstance = select(2, IsInInstance()) == "pvp"
		if (self.pvp or not pvpInstance) then
			if (GetNumRaidMembers() > 0) then
				show = db.show.raid
			elseif (GetNumPartyMembers() > 0) then
				show = db.show.party
			else
				show = db.show.solo
			end
		end
	end
	if (show and not db.show.always) then
		if (UnitAffectingCombat("player")) then
			if (not db.show.combat) then
				show = false
			end
		else
			if (not db.show.oocombat) then
				show = false
			end
		end
		if (show) then
			if (UnitCanAttack("player", "target") and not UnitIsDead("target")) then
				if (db.show.enemy) then
					show = true
				elseif (db.show.boss) then
					local enemyFrame = self.frames[db.dualframe and 2 or 1]
					if (UnitClassification(enemyFrame.unit) == "worldboss") then
						show = true
					else
						show = false
					end
				end
			else
				show = not db.show.enemy and not db.show.boss
			end
		end
	end
	return show
end

-- ShowWhen
function module:ShowWhen()
	if (db.enable) then
		if (not self.frames) then
			self.frames = {}
		end
		if (not self.frames[1]) then
			self.frames[1] = self:CreateUtopianFrame()
		end
		if (db.dualframe) then
			if (not self.frames[2]) then
				self.frames[2] = self:CreateUtopianFrame()
			end
		end

		local show = self:ShouldShow()
		if (show) then
			local friendlyFrame = self.frames[1]
			local enemyFrame = self.frames[db.dualframe and 2 or 1]

			if (db.dualframe) then
				friendlyFrame:SetMode("buffs")
				enemyFrame:SetMode("debuffs")
				self:IterateFrames("Show")
			else
				local newmode = db.mode
				if (db.automode) then
					if (enemyFrame.mode ~= "debuffs") then
						if (UnitCanAttack("player", enemyFrame.unit or "target") and not UnitIsDead(enemyFrame.unit or "target")) then
							newmode = "debuffs"
						end
					end
					if (friendlyFrame.mode ~= "buffs") then
						if (not UnitExists("target") or UnitIsUnit("player", "target") or (UnitIsFriend("player", "target") and db.allPlayers) or UnitIsDead("target")) then
							newmode = "buffs"
						end
					end
				end

				if (self.frames[2]) then
					self.frames[2]:Hide()
				end

				friendlyFrame:SetMode(newmode or db.mode)
				friendlyFrame:Show()
			end

			self.callbacks:Fire("ShowingFrames")
			self:IterateFrames("SetTitle")
		else
			self:IterateFrames("Hide")
		end
	else
		self:IterateFrames("Hide")
	end
end

-- IterateFrames
function module:IterateFrames(func, ...)
	if (self.frames and self.spellPotential) then
		for i,frame in pairs(self.frames) do
			if (frame:IsShown() or func == "Show") then
				frame[func](frame, ...)
			end
		end
	end
end

-- PLAYER_TARGET_CHANGED
function module:PLAYER_TARGET_CHANGED()
	self:ShowWhen()
end
module.PLAYER_FOCUS_CHANGED = module.PLAYER_TARGET_CHANGED

-- PARTY_MEMBERS_CHANGED
function module:PARTY_MEMBERS_CHANGED()
	local f = module.frames
	if (f and f[1] and f[1]:IsShown()) then
		f[1]:TriggerRosterUpdate()
	end
end

-- OnRaidRosterUpdate
function module:OnRaidRosterUpdate()
	self.distribution = nil
	if (self.pvp or select(2, IsInInstance()) ~= "pvp") then
		if (GetNumRaidMembers() > 0) then
			self.distribution = "RAID"
		elseif (GetNumPartyMembers() > 0) then
			self.distribution = "PARTY"
		end
	end

	if (self.distribution) then
		if (self.sentHello ~= self.distribution) then
			self.sentHello = self.distribution
			self:SendCommMessage(commPrefix, "HELLO "..self.version, self.distribution)
		end
	else
		self.sentHello = nil
		self.recentlyWarnedLosses = del(self.recentlyWarnedLosses)
	end

	self:ScanRoster()
	if (self.distribution or db.show.always or db.show.solo) then
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("PLAYER_FOCUS_CHANGED")
	else
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		self:UnregisterEvent("PLAYER_FOCUS_CHANGED")
	end

	self:PLAYER_TARGET_CHANGED()
end

do
	local function iter(t)
		local key = t.id
		local ret
		if (t.mode == "raid") then
			if (key > t.r) then
				del(t)
				return nil
			end
			ret = "raid"..key
		else
			if (key > t.p) then
				del(t)
				return nil
			end
			ret = key == 0 and "player" or "party"..key
		end
		t.id = key + 1
		return ret
	end

	-- IterateRoster
	function module:IterateRoster()
		local t = new()
		if (GetNumRaidMembers() > 0) then
			t.mode = "raid"
			t.id = 1
			t.r = GetNumRaidMembers()
		else
			t.mode = "party"
			t.id = 0
			t.p = GetNumPartyMembers()
		end
		return iter, t
	end
end

-- GetTalentMissingPeople
function module:GetTalentMissingPeople()
	local nameString = LGT:GetTalentMissingNames()
	local missing
	if (nameString) then
		local list = new(strsplit(",", nameString))
		if (#list > 0) then
			sort(list)
			for i,name in ipairs(list) do
				list[i] = self:ColourPlayer(name)
			end
			missing = table.concat(list, ", ")
		end
		del(list)
	end
	return missing
end

local classCountMeta = {__index = function() return 0 end}

-- ScanRoster
function module:ScanRoster()
	-- There's a lot of roster update that don't change members, so we'll now throttle these.
	-- Is a bit of extra checking when ppl join/leave, but overall is less work
	local subtractions = new()
	local additions = new()

	if (self.roster) then
		for name,info in pairs(self.roster) do
			subtractions[name] = info.level
		end
	else
		self.roster = new()
	end

	--del(self.roster)
	--self.roster = new()
	for unit in self:IterateRoster() do
		local name = UnitFullName(unit)
		if (name ~= UNKNOWN) then
			local n = self.roster[name]
			if (not n) then
				n = new()
				self.roster[name] = n
				n.guid = UnitGUID(unit)
			end

			n.name = name
			n.level = UnitLevel(unit)

			if (subtractions[name]) then
				subtractions[name] = nil
			end
		end
	end

	for name in pairs(subtractions) do
		self.roster[name] = del(self.roster[name])
	end

	local refresh = next(additions) or next(subtractions)
	if (refresh) then
		self:ScanRosterActual()

		for name in pairs(subtractions) do
			if (self.users) then
				self.users[name] = nil
			end
			if (throttle) then
				throttle[name] = nil
			end
		end

		if (self.users and not next(self.users)) then
			self.users = del(self.users)
		end
		if (throttle and not next(throttle)) then
			throttle = del(throttle)
		end
	end
	del(subtractions)
	del(additions)
end

-- ScanRosterActual
function module:ScanRosterActual()
	local prevPotential, prevPotentialWho
	if (db.warnLosses) then
		prevPotential = self.potential
		prevPotentialWho = self.potentialWho
		self.potential = new()

		self.potentialWho = new()
		self.potentialWho.buffs = new()
		self.potentialWho.debuffs = new()
	else
		self.potential.buffs = del(self.potential.buffs)
		self.potential.debuffs = del(self.potential.debuffs)
		self.potentialWho = deepDel(self.potentialWho)
	end
	self.potential.buffs = new()
	self.potential.debuffs = new()

	del(self.spellPotential)
	self.spellPotential = new()
	self.petPotential = deepDel(self.petPotential)
	self.pets = del(self.pets)
	self.petlookup = del(self.petlookup)
	self.temporary = deepDel(self.temporary)

	self.temporary = new()
	self.temporary.buffs = new()
	self.temporary.debuffs = new()

	self.classcount = setmetatable(new(), classCountMeta)

	for unit in self:IterateRoster() do
		local level = UnitLevel(unit)
		local _, class = UnitClass(unit)
		if (class and level ~= 0) then
			local name = UnitFullName(unit)

			self.classcount[class] = self.classcount[class] + 1

			local talents = LGT:GetUnitTalents(unit)
			self:AddPotential(unit, talents)

			local r = self.roster[name]
			if (r) then
				-- Flags this unit as having passed through ScanRosterActual (as apposed to added from LGT_Add)
				-- so only an AddPotential is needed when talents are received
				r.updated = true
			end

			if (petClasses[class]) then
				self:UpdateUnitPet(unit, true)
			end
		end
	end

	self:MakePetPotentialKeys()
	self:IterateFrames("UpdateBuffs")

	if (GetNumRaidMembers() > 0 or GetNumPartyMembers() > 0 and select(2, IsInInstance()) ~= "pvp") then
		-- See if we've lost some buff/debuff ability
		if (prevPotential) then
			for mode,list in pairs(prevPotential) do
				for key in pairs(list) do
					if (not self.potential[mode][key]) then
						local who = prevPotentialWho and prevPotentialWho[mode][key]
						if (who) then
							local reason
							if (UnitInParty(who.name) or UnitInRaid(who.name)) then
								reason = L["Respec"]
							else
								reason = L["Left raid"]
							end

							self.announceLosses = self.announceLosses or new()
							self.announceLosses[who.name] = self.announceLosses[who.name] or new()
							tinsert(self.announceLosses[who.name], {spell = self:LinkSpell(who.spellId) or who.spellName, name = ClassColour(who.class)..who.name.."|r", reason = reason, key = key, mode = mode})
						end

						if (not self.recentlyWarnedLosses) then
							self.recentlyWarnedLosses = new()
						end

						local n = new()
						n.mode = mode
						n.key = key
						if (who) then
							n.name = who.name
							n.spellName = who.spellName
							n.spellId = who.spellId
						end
						n.warned = time()

	                    self.recentlyWarnedLosses[mode.."-"..key] = n
					end
				end
			end
		end

		-- Now see if we've regained some previously lost ability
		if (self.recentlyWarnedLosses and db.warnLosses) then
			for k,info in pairs(self.recentlyWarnedLosses) do
				if (self.potential[info.mode][info.key]) then
					local who = self.potentialWho and self.potentialWho[info.mode][info.key]

					self.announceGains = self.announceGains or new()
					self.announceGains[who.name] = self.announceGains[who.name] or new()
					tinsert(self.announceGains[who.name], {spell = self:LinkSpell(who.spellId), name = self:ColourPlayer(who.name), reason = reason, key = info.key, mode = info.mode})

					self.recentlyWarnedLosses[k] = del(self.recentlyWarnedLosses[k])
				elseif (info.warned < time() - 180) then
					self.recentlyWarnedLosses[k] = del(self.recentlyWarnedLosses[k])
				end
			end
			if (not next(self.recentlyWarnedLosses)) then
				self.recentlyWarnedLosses = del(self.recentlyWarnedLosses)
			end
		end

		if (self.announceGains or self.announceLosses) then
			self:ScheduleTimer("AnnounceGainsAndLossses", 1, self)
		end

		self.recheckLosses = nil
	end

	deepDel(prevPotential)
	deepDel(prevPotentialWho)

	self:CleanupTotems()
end

-- AnnounceGainsAndLossesPart
function module:AnnounceGainsAndLossesPart(mode, list)
	if (list and next(list)) then
		local sortedList = new()
		for name,info in pairs(list) do
			tinsert(sortedList, name)
		end
		sort(sortedList)

		for amode = 1,2 do
			local auraMode = amode == 1 and "buffs" or "debuffs"
			local doneTitle
			for i,name in ipairs(sortedList) do
				local infolist = list[name]
				for i,info in ipairs(infolist) do
					if (info.mode == auraMode) then
						if (not doneTitle) then
							doneTitle = true
						end
						local indicator = mode == "gains" and "++" or "--"
						indicator = format("|cFF%s%s|r", auraMode == "buffs" and "80FF80" or "FF8080", indicator)

						self:Printf(L["%s |cFFFFFF80%s|r : %s from %s%s"], indicator, info.key, info.spell, info.name, info.reason and " ("..info.reason..")" or "")
					end
				end
			end
		end

		del(sortedList)
	end
	deepDel(list)
end

-- AnnounceGainsAndLossses
function module:AnnounceGainsAndLossses()
	if (self.announceGains and self.announceLosses) then
		for name,infolist in pairs(self.announceGains) do
			for i,info in ipairs(infolist) do
				for name2,infolist2 in pairs(self.announceLosses) do
					for j,info2 in ipairs(infolist2) do
						if (info2.key == info.key) then
							del(self.announceLosses[j])
							self.announceLosses[j] = nil
						end
					end
				end
			end
		end
	end

	self.announceGains	= self:AnnounceGainsAndLossesPart("gains", self.announceGains)
	self.announceLosses	= self:AnnounceGainsAndLossesPart("losses", self.announceLosses)
end

-- UNIT_PET
function module:UNIT_PET(event, ownerunit)
	self:UpdateUnitPet(ownerunit)
end

-- PurgePetsForOwner
function module:PurgePetsForOwner(owner)
	local ret
	if (self.petlookup) then
		for petguid,ownerName in pairs(self.petlookup) do
			if (ownerName == owner) then
				self.petlookup[petguid] = nil
				ret = true
				break
			end
		end
		if (not next(self.petlookup)) then
			self.petlookup = del(self.petlookup)
--[===[@debug@
		else
			for petguid,ownerName in pairs(self.petlookup) do
				if (ownerName == owner) then
					error("Unexpected pet registered to %s", self:ColourPlayer(owner))
				end
			end
--@end-debug@]===]
		end
	end
	return ret
end

-- UpdateUnitPet
function module:UpdateUnitPet(unit, noPetUpdate)
	local owner = UnitFullName(unit)
	local petid
	if (unit == "player") then
		petid = "pet"
	else
		petid = unit:gsub("^(%a+)(%d+)$", "%1pet%2")
	end
	local petguid = UnitGUID(petid)

	-- Maintain the pet->owner lookup
	local okpet = UnitExists(petid)
	if (okpet and self.petlookup and self.petlookup[petguid] == owner) then
		-- No change. ie: Superfluous UNIT_PET event. They happen often
		return
	end
	if (not self:PurgePetsForOwner(owner) and not okpet) then
		-- Also no change, pet was absent and still is
		return
	end
	if (okpet) then
		if (not self.petlookup) then
			self.petlookup = new()
		end
		self.petlookup[petguid] = owner
	end

	-- Now check type of pet and see what has to be made available or removed
	local _, class = UnitClass(unit)
	if (petClasses[class]) then
		local cType = UnitCreatureFamily(petid)				-- UnitExists(petid) and 
		local remove
		if (cType) then
			if (not self.pets) then
				self.pets = new()
			end
			if (self.pets[owner] == cType) then
				return				-- No change
			end

			-- 'owner' now has a new pet of type 'cType'
			self.pets[owner] = cType
		else
			if (self.pets) then
				if (not self.pets[owner]) then
					return				-- No change
				end
				cType = self.pets[owner]				-- Set this so we know what to remove in next section
				remove = true

				-- 'owner' had a pet of 'cType', but lost it
				self.pets[owner] = nil
				if (not next(self.pets)) then
					self.pets = del(self.pets)
				end
			end
		end

		if (cType) then
			local change
			local c = self.classes[class]
			if (c) then
				for buffsDebuffs,buffList in pairs(c) do
					for key, name in pairs(buffList) do
						local info = self.lookup.debuffs[name] or self.lookup.buffs[name]		-- Assumption

						if (info and info.pet == "any" or info.pet == cType) then
							local list = self.petPotential and self.petPotential[name]

							if (remove) then
								if (list and list[owner]) then
									-- Removing pet triggered aura (name) from player (owner)
									list[owner] = nil
									if (not next(list)) then
										self.petPotential[name] = del(list)
										change = true
									end
								end
							else
								if (not self.petPotential) then
									self.petPotential = new()
								end
								if (not list) then
									list = new()
									self.petPotential[name] = list
								end

								-- Adding pet triggered aura (name) to player (owner)
								if (not list[owner]) then
									change = true
									list[owner] = true
								end
							end
						end
					end
				end
			end
		end
		if (change) then
			if (not noPetUpdate) then
				self:MakePetPotentialKeys()
				self:IterateFrames("UpdateBuffs")
			end
		end
	end
end

-- MakePetPotentialKeys
function module:MakePetPotentialKeys()
	self.petPotentialKeys = del(self.petPotentialKeys)

	if (self.petPotential) then
		for spellName,list in pairs(self.petPotential) do
			local spell = self.lookup.debuffs[spellName] or self.lookup.buffs[spellName]
			if (not self.petPotentialKeys) then
			 	self.petPotentialKeys = new()
			end
			self.petPotentialKeys[spell.key] = true
		end
	end
end

-- AddPotentialSpells
function module:AddPotentialSpells(unit, talents, class, Type)
	local unitLevel = UnitLevel(unit)
	if (unitLevel == 0) then
		unitLevel = MAX_PLAYER_LEVEL or 80
	end
	for category, spells in pairs(self[Type]) do
		for spellName, info in pairs(spells.spells) do
			if (info.class == class) then
				if (not info.minLevel or unitLevel >= info.minLevel) then
					if (not info.rankLevels or unitLevel >= info.rankLevels[1]) then
						if (not info.excludingGlyph or not LGT:UnitHasGlyph(info.excludingGlyph)) then
							local needsPet = info.pet	-- and petClasses[class]

							if (not info.requiredTalent and not needsPet) then
								local level = 0
								if (info.improved) then
									level = LGT:UnitHasTalent(unit, info.improved) or 0
								end

								self.potential[Type][info.key] = max(self.potential[Type][info.key] or 0, level)
								self.spellPotential[spellName] = max(self.spellPotential[spellName] or 0, level)
								if (self.potentialWho) then
									local who = new()
									who.name = UnitFullName(unit)
									who.class = class
									who.spellName = spellName
									who.spellId = info.id
									self.potentialWho[Type][info.key] = who
								end

								if (info.temporary or (info.totem and db.totemsTemporary)) then
									self.temporary[Type][spellName] = true
								end
							else
								if (talents) then
									local level = LGT:UnitHasTalent(unit, info.requiredTalent)
									if (level and level > 0) then
										if (info.improved) then
											level = LGT:UnitHasTalent(unit, info.improved) or level
										end

										if (info.maxTalentPoints and level > info.maxTalentPoints) then
											LGT:RefreshTalentsByUnit(unit)
										else
											if (not needsPet) then
												self.potential[Type][info.key] = max(self.potential[Type][info.key] or 0, level)
												self.spellPotential[spellName] = max(self.spellPotential[spellName] or 0, level)
												if (self.potentialWho) then
													local who = new()
													who.name = UnitFullName(unit)
													who.class = class
													who.spellName = spellName
													who.spellId = info.id
													self.potentialWho[Type][info.key] = who
												end
											end

											if (info.temporary or (info.totem and db.totemsTemporary)) then
												self.temporary[Type][spellName] = true
											end
										end
									end
								end
							end
						end
					end
				end
			elseif (info.runescroll and db.alwaysRuneScrolls) then
				self.potential[Type][info.key] = max(self.potential[Type][info.key] or 0, 1)
				self.spellPotential[spellName] = 1
			end
		end
	end
end

-- AddPotential
function module:AddPotential(unit, talents)
	local _, class = UnitClass(unit)
	if (class) then
		self:AddPotentialSpells(unit, talents, class, "debuffs")
		self:AddPotentialSpells(unit, talents, class, "buffs")
	end
end

-- LibGroupTalents_Update
--[===[@debug@
local checked = {}
--@end-debug@]===]
function module:LibGroupTalents_Update(e, guid, unit, newSpec, n1, n2, n3, oldSpec, o1, o2, o3)
--[===[@debug@
do
	local _, class = UnitClass(unit)
	if (not checked[class]) then
		checked[class] = true
		module:ValidateAgainstClassData(class)
	end
end
--@end-debug@]===]
	local name = UnitFullName(unit)
	local n = self.roster[name]
	local specDiff = o1 ~= n1 or o2 ~= n2 or o3 ~= n3
	if (n) then
		local name, realm = UnitName(unit)
		self:SeeToSavePlayerTalents(guid, name, realm)

		local _, class = UnitClass(unit)

		if (not oldSpec or specDiff or not self.potential or not self.potential.buffs or petClasses[class]) then
			self:ScanRosterActual()
			self:ShowWhen()
		else
			local talents = LGT:GetUnitTalents(unit)
			self:AddPotential(unit, talents)
			self.recheckLosses = true
	
			self:IterateFrames("SetTitle")
			self:IterateFrames("UpdateBuffs")
		end
	end

	if (db.showRespecs and oldSpec) then
		if (newSpec and oldSpec) then
			if (newSpec == oldSpec) then
				if (specDiff) then
					-- First check they didn't just spend a few points more than they had before
					local oldSpent = o1 + o2 + o3
					local newSpent = n1 + n2 + n3
					if (newSpent <= oldSpent and newSpent > 0) then
						self:Print(format(L["%s changed talent set from |cFFFFFF80%s|r (%d/%d/%d) to |cFFFFFF80%s|r (%d/%d/%d)"], self:ColourPlayer(unit), oldSpec, o1, o2, o3, newSpec, n1, n2, n3))
					end
				end
			else
				self:Print(format(L["%s changed talent set from |cFFFFFF80%s|r to |cFFFFFF80%s|r"], self:ColourPlayer(unit), oldSpec, newSpec))
			end
		elseif (newSpec) then
			self:Print(format(L["%s changed talent set to |cFFFFFF80%s|r"], self:ColourPlayer(unit), newSpec))
		end
	end
end

-- LibGroupTalents_RoleChange
function module:LibGroupTalents_RoleChange(e, guid, unit)
	if (self.frames) then
		if (UnitIsUnit(self.frames[1].unit or "player", unit)) then
			self:IterateFrames("SetMode", true)
		end
	end
end

do
	-- guildMemberLookup
	local guildMemberLookup
	local function BuildGuildList()
		guildMemberLookup = new()
		if (IsInGuild()) then
			for i = 1,GetNumGuildMembers(true) do
				local name, rank, rankIndex, level, class, zone, note, officernote, online = GetGuildRosterInfo(i)
				guildMemberLookup[name] = level
			end
		end
		BuildGuildList = nil
	end

	-- IsGuildMember
	function module:IsGuildMember(name)
		if (not guildMemberLookup) then
			BuildGuildList()
		end
		return guildMemberLookup[name]
	end

	-- TODO:
	-- Store guild name, in case you switch guilds on this char and need to delete all of guild data.
	-- Store last logged in time per char also, and delete stuff older than a month
	-- Remove Respec event, combine with Update

	-- GUILD_ROSTER_UPDATE
	function module:GUILD_ROSTER_UPDATE()
		self:UnregisterEvent("GUILD_ROSTER_UPDATE")
		self:StoreLoginGuildAndTime()
		self:CheckSavedTalents()

		self.StoreLoginGuildAndTime = nil
		self.CheckSavedTalents = nil
		self.GUILD_ROSTER_UPDATE = nil
	end

	-- StoreLoginGuildAndTime
	function module:StoreLoginGuildAndTime()
		local dbp = self.db.realm.players
		if (not dbp) then
			dbp = {}
			self.db.realm.players = dbp
		end
		local n = dbp[UnitGUID("player")]	-- Store by GUID, because names can be changed, but the GUID remains the same
		if (not n) then
			n = {}
			dbp[UnitGUID("player")] = n
		end
		n.name = UnitName("player")
		n.login = time()
		n.guild = GetGuildInfo("player")
	end

	-- CheckSavedTalents
	-- Do some validation against our realm saved talents
	-- 1. We are in a guild that has saved talent data
	-- 2. We have logged in recently on that guild (1 month cutoff)
	function module:CheckSavedTalents()
		local realm = self.db.realm
		local dbinfo = realm and realm.guildTalents
		if (dbinfo) then
			if (db.storeGuildTalents) then
				local dbp = realm.players
				assert(dbp)
				local cutoff = time() - (30 * 24 * 60 * 60)

				-- Get list of all the guilds we in, that we've logged into in the last month
				local myGuilds = new()
				for guid,info in pairs(dbp) do
					if (info.guild and info.login >= cutoff) then
						myGuilds[info.guild] = (myGuilds[info.guild] or 0) + 1
					end
				end

				-- Now iterate our saved talent info, and purge any guilds we're no longer interested in
				for guildName,info in pairs(dbinfo) do
					if (not myGuilds[guildName]) then
						dbinfo[guildName] = deepDel(info)
						self:Print(format("Purged saved talent data for |cFFFFFF80%s|r", guildName))
					end
				end
				del(myGuilds)

				if (not next(dbinfo)) then
					realm.guildTalents = del(dbinfo)
				end
			end
		end
	end

	-- SeeToLoadPlayerTalents
	function module:SeeToLoadPlayerTalents(guid, unit, name, realm)
		if (db.storeGuildTalents and guid ~= UnitGUID("player") and (not realm or realm == "")) then
			local guildName = GetGuildInfo("player")
			if (guildName) then
				local dbinfo = self.db.realm and self.db.realm.guildTalents
				if (dbinfo) then
					local guild = dbinfo[guildName]
					if (guild) then
						local player = guild[name]
						if (player) then
							local ok, err = LGT:SetStorageString(player)
							if (not ok) then
								guild[name] = nil
								if (not next(guild)) then
									dbinfo[guildName] = del(dbinfo[guildName])
									if (not next(dbinfo)) then
										self.db.realm.guildTalents = del(dbinfo)
									end
								end
							end
						end
					end
				end
			end
		end
	end

	-- LibGroupTalents_Add
	-- Player added to raid, so we see if we have a pre-stored talent set for them from LibGroupTalents-1.0
	function module:LibGroupTalents_Add(e, guid, unit, name, realm)
		-- We have to add to roster here too because it's entirely possible that LGT gets the RosterUpdate
		-- event before us and starts sending us events about players we don't know of yet
		self:AddToRoster(guid, unit)
		self:SeeToLoadPlayerTalents(guid, unit, name, realm)
	end

	-- SeeToSavePlayerTalents
	function module:SeeToSavePlayerTalents(guid, name, realm)
		if (db.storeGuildTalents and guid ~= UnitGUID("player") and (not realm or realm == "")) then
			local guildName = GetGuildInfo("player")
			if (guildName) then
				if (self:IsGuildMember(name)) then
					local str = LGT:GetGUIDStorageString(guid)
					if (str) then
						if (not self.db.realm.guildTalents) then
							self.db.realm.guildTalents = {}
						end
						if (not self.db.realm.guildTalents[guildName]) then
							self.db.realm.guildTalents[guildName] = {}
						end
						self.db.realm.guildTalents[guildName][name] = str
					end
				end
				if (self.CheckGuildStorage) then
					self:CheckGuildStorage()
				end
			end
		end
	end

	-- LibGroupTalents_Remove
	-- Player removed from raid, so we'll store their talents from LibGroupTalents-1.0
	function module:LibGroupTalents_Remove(e, guid, name, realm)
		self:SeeToSavePlayerTalents(guid, name, realm)
		self:RemoveFromRoster(guid, name, realm)
	end

	-- CheckGuildStorage
	function module:CheckGuildStorage()
		local guildName = GetGuildInfo("player")
		if (guildName) then
			local dbinfo = self.db.realm and self.db.realm.guildTalents
			if (dbinfo) then
				local guild = dbinfo[guildName]
				if (guild) then
					for name,info in pairs(guild) do
						if (not self:IsGuildMember(name)) then
							guild[name] = nil
						end
					end
				end
			end
		end
		self.CheckGuildStorage = nil				-- We only do this once per login
	end
end

-- AddToRoster
function module:AddToRoster(guid, unit)
	local name = UnitFullName(unit)
	local n = self.roster[name]
	if (not n) then
		n = new()
		self.roster[name] = n

		n.guid = guid
		n.level = UnitLevel(name)
	end
end

-- AddToRoster
function module:RemoveFromRoster(guid, name, realm)
	if (realm and realm ~= "") then
		name = name .. "-" .. realm
	end
	local n = self.roster[name]
	if (n) then
		n.removed = true
	end
end

-- PLAYER_ENTERING_WORLD
function module:PLAYER_ENTERING_WORLD()
	if (not self.initialLogin) then
		self.initialLogin = 1
		self:ScheduleTimer("PLAYER_ENTERING_WORLD", 4, self)
		return
	end

	if (self.pvp or select(2, IsInInstance()) ~= "pvp") then
		self:IterateFrames("RedrawIfNewGUID")
	end
end

-- Throttle - Purposely local to here
-- Abuse prevention. Yes, who would abuse addon comms? Noone would make a macro to crash a mod user would they. Right?
-- Well, this one time, at band camp. Someone thought it was super funny to make a macro that DCd PallyPower users
local commsThrottle
local function CommsThrottle(sender, key)
	if (not commsThrottle) then
		commsThrottle = {}
	end
	local s = commsThrottle[sender]
	if (not s) then
		s = {}
		commsThrottle[sender] = s
	end

	if ((s[key] or 0) < GetTime() - 4.5) then
		-- Same message key only allowable once every 4.5 secs from 1 person (Respec cast time is 5 seconds)
		s[key] = GetTime()
		return true
	end
end

-- OnCommReceived
function module:OnCommReceived(prefix, msg, channel, sender)
	if (sender == playerName) then
		return
	elseif (not UnitInRaid(sender) and not UnitInParty(sender)) then
		return
	end

	if (prefix == commPrefix) then
		local cmd, str = msg:match("^(%a+) *(.*)$")
		if (not cmd) then
			return
		end

		if (cmd == "HELLO") then
			local version = tonumber(str)
			if (version) then
				if (not self.users) then
					self.users = new()
				end
				self.users[sender] = version

				if (channel ~= "WHISPER" and sender ~= playerName) then
					if (CommsThrottle(sender, "HELLO")) then
						self:SendCommMessage(commPrefix, "HELLO "..self.version, "WHISPER", sender)
					end
				end
			end
		end
	end
end

-- UserCount
function module:UserCount()
	local count = 0
	if (self.users) then
		for name,ver in pairs(self.users) do
			if (type(ver) == "number") then
				if (UnitInRaid(name) or UnitInParty(name)) then
					count = count + 1
				else
					self.users[name] = nil
				end
			end
		end
		if (not next(self.users)) then
			self.users = del(self.users)
		end
	end
	return count
end

-- GetBloodlustAvailable
function module:GetBloodlustAvailable()
	local satedEnd, freeShaman, bloodLustCooldown, whoCanCast
	local shamans = 0
	local now = GetTime()
	local totalPlayers, playersWithSated = 0, 0

	for unit in self:IterateRoster() do
		if (not UnitIsDeadOrGhost(unit) and UnitIsConnected(unit)) then
			totalPlayers = totalPlayers + 1
			local name, rank, tex, count, Type, duration, endTime, caster, isStealable = UnitDebuff(unit, satedDebuff)
			if (name) then
				playersWithSated = playersWithSated + 1
				if (not satedEnd or endTime < satedEnd) then
					satedEnd = endTime
				end
			end
		end

		local _, class = UnitClass(unit)
		local level = UnitLevel(unit)
		if (class == "SHAMAN" and level >= 70) or (class == "MAGE" and level >= 85) or (class == "HUNTER" and level >= 57 and (self.pets and self.pets[UnitFullName(unit)]) == L["Core Hound"]) then
			shamans = shamans + 1
			if (self.usedBloodlust) then
				local guid = UnitGUID(unit)
				local t = self.usedBloodlust[guid]
				if (t) then
					if (t + 5*60 <= now + 2) then
						self.usedBloodlust[guid] = nil
						if (not next(self.usedBloodlust)) then
							self.usedBloodlust = del(self.usedBloodlust)
						end
						freeShaman = true
						whoCanCast = (whoCanCast or "") .. (whoCanCast and ", " or "") .. self:ColourPlayer(unit)
					else
						local cd = t + 5*60
						if (not bloodLustCooldown or cd < bloodLustCooldown) then
							bloodLustCooldown = cd
						end
					end
				else
					freeShaman = true
					whoCanCast = (whoCanCast or "") .. (whoCanCast and ", " or "") .. self:ColourPlayer(unit)
				end
			else
				freeShaman = true
				whoCanCast = (whoCanCast or "") .. (whoCanCast and ", " or "") .. self:ColourPlayer(unit)
			end
		end
	end

	if (shamans == 0) then
		return false, -1

	elseif (satedEnd) then
		if (freeShaman) then
			return false, abs(satedEnd - GetTime()), whoCanCast, 100 - floor(playersWithSated / totalPlayers * 100)
		end
		return false, abs(max(satedEnd, bloodLustCooldown or satedEnd) - GetTime()), whoCanCast, 100 - floor(playersWithSated / totalPlayers * 100)

	else
		if (freeShaman) then
			return true, 0, whoCanCast, 100
		end
		return false, abs(bloodLustCooldown - GetTime()), whoCanCast, 100
	end
end

-- UNIT_SPELLCAST_SUCCEEDED
function module:UNIT_SPELLCAST_SUCCEEDED(ev, unit, spell)
	--if (spell == GetSpellInfo(self.bloodlustID)) then
	if (self.bloodlustNames[spell]) then
		if (UnitInParty(unit) or UnitInRaid(unit)) then
			local guid = UnitGUID(unit)
			if (guid) then
				if (not self.usedBloodlust) then
					self.usedBloodlust = new()
				end
				self.usedBloodlust[guid] = GetTime()
			end
		end
	end
end

-- PLAYER_REGEN_DISABLED
function module:PLAYER_REGEN_DISABLED()
	self:ShowWhen()
	if (self.frames and self.spellPotential) then
		if (db.dualframe) then
			--self:IterateFrames("SetMode", true)
			self:IterateFrames("UpdateBuffs")
		else
			if (db.automode and self.frames[1].mode ~= "debuffs") then
				if (UnitCanAttack("player", "target")) then
					self.frames[1]:SetMode("debuffs")
					return
				end
			end
			self.frames[1]:UpdateBuffs()
		end
	end
end

-- PLAYER_REGEN_ENABLED
function module:PLAYER_REGEN_ENABLED()
	self:ShowWhen()
	if (self.frames) then
		if (db.dualframe) then
			--self:IterateFrames("SetMode", true)
			self:IterateFrames("UpdateBuffs")
		else
			if (db.automode and self.frames[1].mode ~= "buffs") then
				self.frames[1]:SetMode("buffs")
				return
			end
			self.frames[1]:UpdateBuffs()
		end
	end
end

do
	-- Monitoring here for totems that are created which don't provide a buff or debuff,
	-- but we'd like to know if they're active so we can determine exlusives
	do
		local temp = {
			[2062] = "earth",				-- Earth Elemental Totem
			[2484] = "earth",				-- Earthbind Totem
			[2894] = "fire",				-- Fire Elemental Totem
			[3599] = "fire",				-- Searing Totem
			[5394] = "water",				-- Healing Stream Totem
			[5730] = "earth",				-- Stoneclaw Totem
			[8143] = "earth",				-- Tremor Totem
			[8190] = "fire",				-- Magma Totem
		}

		totemSpells = {}
		for id,school in pairs(temp) do
			totemSpells[GetSpellInfo(id)] = school
		end
		temp = nil
	end

	local totems = {}						-- Contains list of running totems per raid guid
	local ownerLookup = {}					-- Contains object GUID -> owner GUID lookup
	local totemLookup = {}					-- Contains object GUID -> object type lookup
	local totemNameLookup = {}				-- Contains object GUID -> object name lookup

	-- COMBAT_LOG_EVENT_UNFILTERED
	function module:COMBAT_LOG_EVENT_UNFILTERED(_, timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...)
		if (event == "SPELL_SUMMON") then
			if (UnitInRaid(sourceName) or UnitInParty(sourceName)) then
				local spellId, spellName, spellSchool = ...

				local totem = totemSpells[spellName]
				if (totem) then
					local player = totems[sourceGUID]
					if (not player) then
						player = new()
						totems[sourceGUID] = player
					end

					player[totem] = spellName
					ownerLookup[destGUID] = sourceGUID
					totemLookup[destGUID] = totem
					totemNameLookup[destGUID] = spellName

					if (self.frames and self.frames[1]:IsShown()) then
						self.frames[1]:UpdateBuffs()
					end
				end
			end

		elseif (event == "UNIT_DIED") then
			local guid = ownerLookup[destGUID]
			if (guid) then
				local player = totems[guid]
				if (player) then
					local spellName = totemNameLookup[destGUID]

					local totem = totemLookup[destGUID]
					assert(totem)

					if (spellName == player[totem]) then
						-- Checking spellName matches expected totem, cos when a totem
						-- of same type is cast over top of existing one, the death of
						-- the old one comes after the summoning of the new one
						player[totem] = nil
						if (not next(player)) then
							totems[guid] = nil
						end

						if (self.frames and self.frames[1]:IsShown()) then
							self.frames[1]:UpdateBuffs()
						end
					end

					totemLookup[destGUID] = nil
					ownerLookup[destGUID] = nil
					totemNameLookup[destGUID] = nil
				end
			end
		end
	end

	-- ActiveBufflessTotems
	-- Returns: {earth = "Earth Spell Name", fire = ...}
	function module:ActiveBufflessTotems(unit)
		local guid = UnitGUID(unit)
		if (guid) then
			return totems[guid]
		end
	end

	-- AllActiveBufflessTotems
	function module:AllActiveBufflessTotems()
		return totems
	end

	-- CleanupTotems
	-- Clear out totems from shamans who left raid
	function module:CleanupTotems()
		local shamans = new()
		for unit in module:IterateRoster() do
			if (select(2, UnitClass(unit)) == "SHAMAN") then
				shamans[UnitGUID(unit)] = true
			end
		end

		for guid,info in pairs(totems) do
			if (not shamans[guid]) then
				shamans[guid] = del(shamans[guid])

				for totemGUID,playerGUID in pairs(ownerLookup) do
					if (playerGUID == guid) then
						totemLookup[totemGUID] = nil
						totemNameLookup[totemGUID] = nil
						ownerLookup[totemGUID] = nil
					end
				end
			end
		end

		del(shamans)
	end

	-- PLAYER_LEAVING_WORLD
	function module:PLAYER_LEAVING_WORLD()
		deepDel(totems)
		totems = new()
		del(ownerLookup)
		ownerLookup = new()
		del(totemLookup)
		totemLookup = new()
		del(totemNameLookup)
		totemNameLookup = new()
	end
end

do
	-- replaceFunc
	local replaceIndex, thisIndex, replaceValue, replaceColour, replacePercent
	local function replaceFunc(str)
		thisIndex = thisIndex + 1
		if (type(replaceIndex) == "number" and thisIndex == replaceIndex) then
			return replaceValue
		elseif (type(replaceIndex) == "table" and replaceIndex[thisIndex]) then
			return replaceValue
		end
		return str
	end

	local function replaceTalentFunc(str)
		thisIndex = thisIndex + 1
		local num = tonumber(str)
		if (num) then
			if (not replaceIndex or (type(replaceIndex) == "number" and thisIndex == replaceIndex) or (type(replaceIndex) == "table" and replaceIndex[thisIndex])) then
				if (replacePercent) then
					str = replaceColour..tostring(floor(num * replacePercent + 0.5)).."|r"
				elseif (replaceValue) then
					str = replaceColour..tostring(num + replaceValue).."|r"
				end
			end
		end
		return str
	end

	-- AddTooltipMapping
	-- *** RECURSIVE ***
	function module:AddTooltipMapping(tooltip, unit, filter, base, name, strrank, tex, count, debuffType, duration, endTime, caster, isStealable)
		local casterName, owner
		if (caster) then
			casterName = self:ColourPlayer(caster)
			if (not UnitIsPlayer(caster) and (UnitPlayerOrPetInRaid(caster) or UnitPlayerOrPetInParty(caster))) then
				-- Is a pet of someone in raid
				local ownerName = self.petlookup and self.petlookup[UnitGUID(caster)]
				if (ownerName) then
					casterName = format("%s <%s>", casterName, self:ColourPlayer(ownerName))
					owner = ownerName
				end
			elseif (name == satedDebuff) then
				if (self.usedBloodlust) then
					local satedStart = endTime - duration

					for guid,when in pairs(self.usedBloodlust) do
						if (abs(when - satedStart) < 5) then
							-- Find a Bloodlust spell cast within 5 seconds of when we gained Sated debuff
							for name,info in pairs(self.roster) do
								if (info.guid == guid) then
									casterName = format("%s (%s)", casterName, self:ColourPlayer(name))
									break
								end
							end
							break
						end
					end
				end
			end
		end

		-- Add this spell
		local nameDone
		local buffmode = strfind(filter, "HELPFUL") and "buffs" or "debuffs"
		--local info = self.lookup[buffmode][name]
		local info = self:GetUnitSpellInfo(unit, buffmode, name)
		if (not info) then
			info = self.otherBuffs[name]
			if (not info) then
				info = self.classSpells and self.classSpells[name]
			end
		end
		if (info) then
			if (UnitInParty(owner or caster) or UnitInRaid(owner or caster)) then
				local region = _G[tooltip:GetName().."TextLeft2"]
				if (region) then
					local rank
					if (type(strrank) == "string" and strrank ~= "") then
						rank = (tonumber(strrank:match("(%d+)"))) or 1
					end
					local text = region:GetText()

					if (base) then
						--if (db.tooltiprank and strrank and strrank ~= "") then
						--	local rankRegion = _G[tooltip:GetName().."TextRight1"]
						--	if (rankRegion:GetText() and rankRegion:GetText() ~= strrank) then
						--		rankRegion = _G[tooltip:GetName().."TextRight3"]
						--	end
						--	rankRegion:SetText(strrank)
						--	rankRegion:SetTextColor(0.5, 0.5, 0.5)
						--	rankRegion:Show()
						--end

						if (info.improved or (info.glyphImproved and LGT:GetUnitGlyphs(caster))) then
							local points, colour
							if (info.improved) then
								points = LGT:UnitHasTalent(owner or caster, info.improved) or 0
								colour = SmoothColourStr(points / info.maxTalentPoints, true)
							elseif (info.glyphImproved) then
								points = LGT:UnitHasGlyph(caster, info.glyphImproved) and 1 or 0
								colour = SmoothColourStr(points / 1, true)
							end

							local amount = self:GetAmount(info, nil, nil, owner or caster, name, rank, tex, count, debuffType, duration, endTime, isStealable)
							if ((amount and amount ~= "") or info.regex == "TALENT") then
								local colourAmount = format("%s%s|r", colour, tostring(amount))

								thisIndex = 0
								local regex = info.regex
								if (type(regex) == "boolean") then
									text = text:gsub("(%d+)", colourAmount)
								elseif (type(regex) == "number") then
									replaceIndex = regex
									replaceValue = colourAmount
									text = text:gsub("(%d+)", replaceFunc)
									replaceIndex = nil
									thisIndex = nil
									replaceValue = nil
								elseif (type(regex) == "string") then
									if (regex == "TALENT" and info.improved) then
										replaceIndex = info.regexIndex
										if (info.improvedPercentagePerTalentPoint) then
											replacePercent = 1 + (points * info.improvedPercentagePerTalentPoint / 100)
										elseif (info.improvedAmountPerTalentPoint) then
											replaceValue = floor(points * info.improvedAmountPerTalentPoint)
										end
										replaceColour = colour
										text = text:gsub("(%d+)", replaceTalentFunc)
										replaceColour, replacePercent, replaceValue, replaceIndex = nil, nil, nil, nil
									else
										text = text:gsub(regex, colourAmount)
									end
								elseif (type(regex) == "table") then
									text = text:gsub(regex[1], regex[2]..colourAmount..regex[3])
								end
							end

							local nameString
							local tex = format("Interface\\Addons\\Utopia\\Textures\\%s", (select(2, UnitClass(owner or caster))))
							if (info.improved) then
								if (points > 0) then
									-- Add 'Improved 5/5' to end
									nameString = format("%s - %s %s%d|r/%d", casterName, L["Improved"], colour, points, info.maxTalentPoints)
								else
									nameString = format("%s - %s", casterName, L["Not Improved"])
								end
							else
								if (points == 1) then
									-- Add 'Glyph Name' to end
									nameString = format("%s - %s%s|r", casterName, colour, GetSpellInfo(info.glyphImproved))
								else
									nameString = format("%s - %s", casterName, L["Not Glyphed"])
								end
							end
							tooltip:AddLine(nameString, 0.9, 0.8, 0.5)
							tooltip:AddTexture(tex)
							nameDone = true
						end
					else
						local amount = self:GetAmount(info, nil, nil, owner or caster, name, rank, tex, count, debuffType, duration, endTime, isStealable)
						local spellinfo = info.key and self.buffs[info.key]
						if (spellinfo) then
							local descriptor = spellinfo.attributeShort or spellinfo.attribute
							text = format("%s\n|cFFFFFF80%s|r: |cFF80FF80%s|r %s", text, name, amount, descriptor or "")
						end
					end

					if (info.rankLevels and rank) then
						local shouldHaveRank = self:MyLevelRank(info.rankLevels)
--[===[@debug@
						assert(shouldHaveRank, format("No shouldHaveRank at level %d for %s", UnitLevel("player"), name))
--@end-debug@]===]
						if (info.alternateOffset and info.alternate and name == info.alternate) then
							rank = rank + info.alternateOffset
						end

						if (rank < shouldHaveRank) then
							if (info.alternateOffset and info.alternate and name == info.alternate) then
								shouldHaveRank = shouldHaveRank - info.alternateOffset
								rank = rank - info.alternateOffset
							end
							local shouldHaveAmount = self:GetAmount(info, nil, nil, owner or caster, name, shouldHaveRank, tex, count, debuffType, duration, endTime, isStealable)
							local spellinfo = info.key and self.buffs[info.key]
							if (spellinfo) then
								local descriptor = spellinfo.attributeShort or spellinfo.attribute
								tooltip:AddLine(format(L["This is a rank |cFFFF0000%d|r spell instead of rank |cFFFF0000%d|r which would give you |cFFFFFF80%d %s|r"], rank, shouldHaveRank, shouldHaveAmount, descriptor or ""), 1, 0.4, 0.3, true)
								--tooltip:AddTexture("Interface\\DialogFrame\\DialogAlertIcon")   GameTooltip bugs with a texture on a wrapping line..
							end
						end
					end

					region:SetText(text)
				end
			end
		end

		-- Check mappings for the spell and add those
		local mappings = module.mappingLookup[name]
		if (mappings) then
			for i,mapping in ipairs(mappings) do
				if (not mapping.requiredTalent or (caster and LGT:UnitHasTalent(owner or caster, mapping.requiredTalent))) then
--[===[@debug@
					assert(mapping.key ~= name)			-- Would trigger a stack overflow
--@end-debug@]===]
					self:AddTooltipMapping(tooltip, unit, filter, false, mapping.key, strrank, tex, count, debuffType, duration, endTime, caster, isStealable)
				end
			end
		end

		if (base and not nameDone and caster) then
			tooltip:AddLine(casterName)
			tooltip:AddTexture(format("Interface\\Addons\\Utopia\\Textures\\%s", (select(2, UnitClass(owner or caster)))))

			--if (db.tooltiprank and strrank and strrank ~= "") then
			--	local rankRegion = _G[tooltip:GetName().."TextRight3"]
			--	if (rankRegion:GetText() and rankRegion:GetText() ~= strrank) then
			--		rankRegion = _G[tooltip:GetName().."TextRight3"]
			--	end
			--	rankRegion:SetText(strrank)
			--	rankRegion:SetTextColor(0.5, 0.5, 0.5)
			--	rankRegion:Show()
			--end
		end
	end

	-- SetUnitAuraExtraInfo
	function module:SetUnitAuraExtraInfo(tooltip, unit, index, filter)
		if (db.tooltip) then
			local name, rank, tex, count, debuffType, duration, endTime, caster, isStealable = UnitAura(unit, index, type(index) == "number" and filter or nil, type(index) == "string" and filter or nil)
			self:AddTooltipMapping(tooltip, unit, filter, true, name, rank, tex, count, debuffType, duration, endTime, caster, isStealable)
			tooltip:Show()
		end
	end
end

-- HookTooltip
function module:HookTooltip()
	self:SecureHook(GameTooltip, "SetUnitAura",
		function(tooltip, unit, index, filter)
			module:SetUnitAuraExtraInfo(tooltip, unit, index, filter or "HELPFUL")
		end
	)

	self:SecureHook(GameTooltip, "SetUnitBuff",
		function(tooltip, unitid, index)
			module:SetUnitAuraExtraInfo(tooltip, unitid, index, "HELPFUL")
		end
	)

	self:SecureHook(GameTooltip, "SetUnitDebuff",
		function(tooltip, unitid, index)
			module:SetUnitAuraExtraInfo(tooltip, unitid, index, "HARMFUL")
		end
	)
end

-- OpenConfig
function module:OpenConfig(input)
	local sel = InterfaceOptionsFrameAddOns.selection
	if (sel and (sel.name == "Utopia" or sel.parent == "Utopia")) then
		InterfaceOptionsFrame_OpenToCategory("Addons")
		return
	end

	local buttonHeight = InterfaceOptionsFrameCategories and InterfaceOptionsFrameCategories.buttonHeight
	local numButtons = #InterfaceOptionsFrameCategories.buttons

	if (self.optionsFrames.Utopia.collapsed) then
		local dummy = {element = self.optionsFrames.Utopia}
		InterfaceOptionsListButton_ToggleSubCategories(dummy)
	end
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.Utopia)
	sel = InterfaceOptionsFrameAddOns.selection
	if (not sel or sel.name ~= "Utopia") then
		InterfaceOptionsFrameAddOns.scrollFrame:SetVerticalScroll(0)
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.Utopia)
	end

	sel = InterfaceOptionsFrameAddOns.selection
	if (not sel or sel.name ~= "Utopia") then
		local entries = 0
		local utopiaChildren = 0
		for i, element in pairs(INTERFACEOPTIONS_ADDONCATEGORIES) do
			if (not element.parent) then
				entries = entries + 1
			elseif (element.parent == "Utopia") then
				utopiaChildren = utopiaChildren + 1
			end
		end

		if (entries + utopiaChildren >= numButtons) then
			InterfaceOptionsFrameAddOns.scrollFrame:SetVerticalScroll((entries + utopiaChildren - numButtons) * buttonHeight)
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrames.Utopia)
		end
	end
end

-- OnProfileChanged
function module:OnProfileChanged(event, database, newProfileKey)
	db = database.profile
	if (self.frames) then
		self:IterateFrames("SetOrientation")
		for i,frame in pairs(self.frames) do
			self:RestorePosition(frame)
		end
	end
	self:ShowWhen()
end

-- ModuleOptions
function module:ModuleOptions()
	local moduleNames = {}

	for i = 1,GetNumAddOns() do
		local name, _, _, enabled, loadable = GetAddOnInfo(i)
		if (name and enabled and loadable and strfind(name, "^Utopia")) then
			local data = GetAddOnMetadata(name, "X-Utopia-SkipOptions")
			if (tonumber(data) ~= 1) then
				local suffixName = strmatch(name, "^Utopia_(%a+)")
				if (suffixName) then
					tinsert(moduleNames, suffixName)
					if (self.db.profile.modules[suffixName] ~= false) then
						local data = GetAddOnMetadata(name, "X-Utopia-LoadOnDemand")
						if (tonumber(data) ~= 1) then
							LoadAddOn(name)
						end
					end
				end
			end
		end
	end

	for k, v in self:IterateModules() do
		local t = v.options
		if (t) then
			local name = k:gsub(" ", "_")
			self.options.args[name] = t
		end
	end

	sort(moduleNames)
	for i,name in pairs(moduleNames) do
		local t = self.options.args[name]
		if (not t) then
			t = {
				type = "group",
				name = L[name],
				desc = L[name],
				guiInline = true,
				args = {}
			}
			self.options.args[name] = t
		end
		t.order = 100 + i

		t.args.toggle = {
			type = "toggle",
			name = L["Enable "] .. L[name], 
			width = "full",
			desc = L["Enable "] .. L[name],
			order = 1,
			get = function()
				return self.db.profile.modules[name] ~= false or false
			end,
			set = function(info, v)
				self.db.profile.modules[name] = v
				if v then
					if (self.modules[name]) then
						self:EnableModule(name)
					else
						local data = GetAddOnMetadata("Utopia_"..name, "X-Utopia-LoadOnDemand")
						if (tonumber(data) ~= 1) then
							LoadAddOn(name)
							self:ModuleOptions()
							self:EnableModule(name)
						end
					end
					self:Print(L["Enabled"], L[name], L["Module"])
				else
					if (self.modules[name]) then
						self:DisableModule(name)
					end
					self:Print(L["Disabled"], L[name], L["Module"])
				end
			end
		}
	end

	if (#moduleNames > 0) then
		if (not self.addedToOptions) then
			self.addedToOptions = {}
		end
		local ACD3 = LibStub("AceConfigDialog-3.0")
		sort(moduleNames)
		for _, name in ipairs(moduleNames) do
			if (not self.addedToOptions[name]) then
				self.addedToOptions[name] = true
				ACD3:AddToBlizOptions("Utopia", name, "Utopia", name)
			end
		end
	end
end

-- SetupOptions
function module:SetupOptions()
	self.optionsFrames = {}

	-- setup options table
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Utopia", self.options)
	local ACD3 = LibStub("AceConfigDialog-3.0")

	self.optionsFrames.Utopia = ACD3:AddToBlizOptions("Utopia", nil, nil, "General")
	self.optionsFrames.Display = ACD3:AddToBlizOptions("Utopia", L["Display"], "Utopia", "display")
	self.optionsFrames.Icons = ACD3:AddToBlizOptions("Utopia", L["Icons"], "Utopia", "icons")
	self.optionsFrames.ShowWhen = ACD3:AddToBlizOptions("Utopia", L["Show When"], "Utopia", "show")
	self:RegisterChatCommand("utopia", "OpenConfig")

	self:ModuleOptions()

	self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db), L["Profiles"])
	-- Add ordering data to the option table generated by AceDBOptions-3.0
	self.options.args.Profiles.order = -2

	self.SetupOptions = nil
end

-- RegisterModuleOptions
function module:RegisterModuleOptions(name, optionTbl, displayName)
	self.options.args[name] = (type(optionTbl) == "function") and optionTbl() or optionTbl
	self.optionsFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Utopia", displayName, "Utopia", name)
end

-- CheckXPerlTooltipNamesOption
function module:CheckXPerlTooltipNamesOption()
	if (XPerlDB and XPerlDB.buffs) then
		if (db.tooltip) then
			db.wasXPerlNamesOn = XPerlDB.buffs.names
			XPerlDB.buffs.names = nil
		else
			XPerlDB.buffs.names = db.wasXPerlNamesOn
			db.wasXPerlNamesOn = nil
		end
	end
end

-- ToggleDetailsSuper
function module:ToggleDetailsSuper(mode, key)
	if (db.modules.Details ~= false) then
		if (not self.modules.Details) then
			LoadAddOn("Utopia_Details")
			if (self.modules.Details) then
				self:ModuleOptions()
			end
		end
		if (self.modules.Details) then
			self.modules.Details:ToggleDetails(mode, key)
		end
	end
end

-- OnModuleInitialize
function module:OnInitialize()
	new, del, copy, deepDel = self.new, self.del, self.copy, self.deepDel
	Gradient, UnitFullName, ClassColour, SmoothColour, SmoothColourStr = self.Gradient, self.UnitFullName, self.ClassColour, self.SmoothColour, self.SmoothColourStr
	d, rotate = self.debugprint, self.rotate
	self.potential = {}
	self.label = Gradient(L["TITLE"], 1, 0.1, 0.1, 1, 1, 0.1)

	module.options.name = Gradient(L["TITLE"], 1, 0.1, 0.1, 1, 1, 0.1)

	LGT.RegisterCallback(self, "LibGroupTalents_Update")
	LGT.RegisterCallback(self, "LibGroupTalents_RoleChange")
	LGT.RegisterCallback(self, "LibGroupTalents_Add")
	LGT.RegisterCallback(self, "LibGroupTalents_Remove")

	playerClass = select(2, UnitClass("player"))
	playerName = UnitName("player")

	SM:Register("border", "Vista", [[Interface\Addons\Utopia\Textures\Border-Vista]])
	SM:Register("border", "Thin", [[Interface\Addons\Utopia\Textures\Border-Thin]])

	self.db = LibStub("AceDB-3.0"):New("UtopiaDB", nil, "Default")
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")

	self.db:RegisterDefaults({
		profile = {
			auto = true,
			automode = true,
			modules = {
				UpTime = true,
				Details = true,
			},
			enable = true,
			tooltip = true,
			--tooltiprank = true,
			mode = "debuffs",
			show = {
				--always = false,
				--solo = false,
				party = true,
				raid = true,
				combat = true,
				oocombat = true,
			},
			popupPos = "bottom",
			size = 20,
			scale = 1,
			texture = "Blizzard",
			orientation = "H",
			side = "B",
			barwidth = 7,
			hspacing = 0,
			vspacing = 0,
			columns = 5,
			defaultMax = true,
			totemsTemporary = true,
--			warnLosses = true,
--			showRespecs = false,
			minCountdown = 60,
			showCountdown = nil,
			showCooldown = nil,
			drawEdge = true,
			hints = true,
			colour = {
				active = {r = 1, g = 1, b = 1, a = 1},
				inactive = {r = 1, g = 0, b = 0, a = 1},
				unavailable = {r = 1, g = 1, b = 1, a = 0.25},
				partActive = {r = 1, g = 0.8, b = 0.2, a = 1},
				excluded = {r = 0.22, g = 0.62, b = 1, a = 0.75},
				temporary = {r = 0.2, g = 1, b = 0.3, a = 0.75},
			},
			Background = {
				Enable = true,
				Texture = "Solid",
				BorderTexture = "Thin",
				BorderColourAsStatus = true,
				Color = {r = 0.06, g = 0.06, b = 0.06, a = 0.5},
				BorderColor = {r = 1, g = 1, b = 1, a = 1},
				Tile = false,
				TileSize = 32,
				EdgeSize = 4,
			},
		}
	})
	db = self.db.profile

	if (self.GetClassSpells) then
		self:GetClassSpells()
	end

	self.OnInitialize = nil
end

-- OnModuleEnable
function module:OnEnable()
	if (self.db) then
		local class = select(2, UnitClass("player"))
		if (class ~= playerClass and self.OnModuleInitialize) then
			self:OnModuleInitialize()
		end

		self.roster = new()
		self:RegisterComm(commPrefix)
		self:SetupOptions()
		self:InitData()

		self:RegisterEvent("PLAYER_ENTERING_WORLD")
		self:RegisterEvent("PLAYER_LEAVING_WORLD")
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("PARTY_MEMBERS_CHANGED")
		self:RegisterEvent("UNIT_PET")
		self:RegisterEvent("RAID_ROSTER_UPDATE", "PARTY_MEMBERS_CHANGED")
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("GUILD_ROSTER_UPDATE")
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

		self:CheckXPerlTooltipNamesOption()
		self:HookChat()
		self:HookTooltip()

		-- Moved talents to faction db, under guild name
		db.guildTalents = nil
		self.db.char.guildTalents = nil
		-- And moved again to realm, with use of new LibGroupTalents-1.0
		self.db.faction.guildTalents = nil

		-- Import old frame pos to new name
		if (self.db.char.pos) then
			if (self.db.char.pos.UtopiaAnchorFrame) then
				if (not self.db.char.pos.UtopiaAnchorFrame1) then
					self.db.char.pos.UtopiaAnchorFrame1 = self.db.char.pos.UtopiaAnchorFrame
				end
				self.db.char.pos.UtopiaAnchorFrame = nil
			end
		end

		for k,v in self:IterateModules() do
			if (self.db.profile.modules[k] ~= false) then
				v:Enable()
			end
		end

		self.title = Gradient(L["TITLE"].." r"..module.version, 1, 0.1, 0.1, 1, 1, 0.1)
	end
end

-- OnDisable
function module:OnDisable()
	self:UnhookChat()
	self.lookup.buffs = del(self.lookup.buffs)
	self.lookup.debuffs = del(self.lookup.debuffs)
	self.lookup = del(self.lookup)
	self.buffLookup = del(self.buffLookup)
	self.mappingLookup = del(self.mappingLookup)
	self.classes = deepDel(self.classes)
	self:IterateFrames("Hide")
end
