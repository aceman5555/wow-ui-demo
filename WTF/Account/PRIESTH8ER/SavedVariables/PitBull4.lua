
PitBull4DB = {
	["namespaces"] = {
		["LeaderIcon"] = {
		},
		["LibDualSpec-1.0"] = {
			["char"] = {
				["Burk - Azuremyst"] = {
					["profile"] = "Custom - Heals",
					["talentGroup"] = 2,
					["enabled"] = true,
				},
				["Cowbeary - Azuremyst"] = {
					["profile"] = "Default",
					["talentGroup"] = 1,
					["enabled"] = false,
				},
			},
		},
		["RangeFader"] = {
		},
		["Border"] = {
			["profiles"] = {
				["Git - Tanl"] = {
					["layouts"] = {
						["Target"] = {
							["enabled"] = false,
						},
					},
				},
			},
		},
		["PhaseIcon"] = {
		},
		["ComboPoints"] = {
			["profiles"] = {
				["Default"] = {
					["layouts"] = {
						["Target"] = {
							["location"] = "edge_top",
						},
					},
					["global"] = {
						["enabled"] = false,
					},
				},
			},
		},
		["RoleIcon"] = {
		},
		["Aggro"] = {
			["profiles"] = {
				["Default"] = {
					["global"] = {
						["enabled"] = false,
					},
				},
			},
		},
		["DeadIcon"] = {
		},
		["MasterLooterIcon"] = {
		},
		["CombatText"] = {
		},
		["LuaTexts"] = {
			["profiles"] = {
				["Custom - Heals"] = {
					["layouts"] = {
						["Normal"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Experience"] = {
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
								},
								["Lua:Power"] = {
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Threat"] = {
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
								},
								["Lua:Reputation"] = {
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
								},
								["Lua:Druid mana"] = {
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Cast"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
								},
								["Lua:Health"] = {
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nreturn \"%s/%s\",Short(HP(unit),true),Short(MaxHP(unit),true)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["exists"] = true,
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["enabled"] = false,
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
								},
								["Lua:Cast time"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Name"] = {
									["enabled"] = false,
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
								},
							},
							["first"] = false,
						},
						["Focus"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Experience"] = {
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
								},
								["Lua:Name"] = {
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
								},
								["Lua:Threat"] = {
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
								},
								["Lua:Power"] = {
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Cast"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Cast time"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Health"] = {
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["exists"] = true,
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
								},
								["Lua:Druid mana"] = {
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Reputation"] = {
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
								},
							},
							["first"] = false,
						},
						["Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Reputation"] = {
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
								},
								["Lua:Power"] = {
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Threat"] = {
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
								},
								["Lua:Name"] = {
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
								},
								["Lua:Cast time"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Cast"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Health"] = {
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["exists"] = true,
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
								},
								["Lua:Druid mana"] = {
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Experience"] = {
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
								},
							},
							["first"] = false,
						},
						["Target of Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Experience"] = {
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
								},
								["Lua:Power"] = {
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Threat"] = {
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
								},
								["Lua:Reputation"] = {
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
								},
								["Lua:Druid mana"] = {
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Cast time"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Health"] = {
									["enabled"] = false,
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["exists"] = true,
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
								},
								["Lua:Cast"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
								},
								["Lua:Name"] = {
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
								},
							},
							["first"] = false,
						},
						["Focus Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Reputation"] = {
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
								},
								["Lua:Name"] = {
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
								},
								["Lua:Threat"] = {
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
								},
								["Lua:Experience"] = {
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
								},
								["Lua:Druid mana"] = {
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Cast"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
								},
								["Lua:Health"] = {
									["enabled"] = false,
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["exists"] = true,
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
								},
								["Lua:Cast time"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Power"] = {
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
							},
							["first"] = false,
						},
					},
				},
				["Lihte-DPS"] = {
					["layouts"] = {
						["Normal"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["enabled"] = false,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nreturn \"%s/%s\",Short(HP(unit),true),Short(MaxHP(unit),true)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["enabled"] = false,
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Focus"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Target of Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["enabled"] = false,
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Focus Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["enabled"] = false,
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
					},
				},
				["Gitt Tank"] = {
					["layouts"] = {
						["Normal"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Threat"] = {
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
								},
								["Lua:Reputation"] = {
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
								},
								["Lua:Power"] = {
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Health percent"] = {
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nreturn \"%s%%\",Percent(HP(unit),MaxHP(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
								},
								["Lua:Cast time"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Alternate power"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "local max = MaxPower(unit,ALTERNATE_POWER_INDEX)\nif max > 0 then\n  return \"%s%%\",Percent(Power(unit,ALTERNATE_POWER_INDEX),max)\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "AltPowerBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
								},
								["Lua:Health"] = {
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nreturn \"%s/%s\",Short(HP(unit),true),Short(MaxHP(unit),true)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["enabled"] = false,
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
								},
								["Lua:Druid mana"] = {
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Name"] = {
									["enabled"] = false,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["position"] = 1.00001,
									["location"] = "left",
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Focus"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Reputation"] = {
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
								},
								["Lua:Power"] = {
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Threat"] = {
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
								},
								["Lua:Name"] = {
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
								},
								["Lua:Cast"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Cast time"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Health"] = {
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
								},
								["Lua:Druid mana"] = {
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Experience"] = {
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
								},
							},
							["first"] = false,
						},
						["Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Experience"] = {
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
								},
								["Lua:Name"] = {
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
								},
								["Lua:Threat"] = {
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
								},
								["Lua:Power"] = {
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Cast time"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Cast"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Health"] = {
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
								},
								["Lua:Druid mana"] = {
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Reputation"] = {
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
								},
							},
							["first"] = false,
						},
						["Focus Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Experience"] = {
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
								},
								["Lua:Power"] = {
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Threat"] = {
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
								},
								["Lua:Reputation"] = {
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
								},
								["Lua:Druid mana"] = {
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Cast"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
								},
								["Lua:Health"] = {
									["enabled"] = false,
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
								},
								["Lua:Cast time"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Name"] = {
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
								},
							},
							["first"] = false,
						},
						["Target of Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Reputation"] = {
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
								},
								["Lua:Name"] = {
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
								},
								["Lua:Threat"] = {
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
								},
								["Lua:Experience"] = {
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
								},
								["Lua:Druid mana"] = {
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Cast time"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Health"] = {
									["enabled"] = false,
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
								},
								["Lua:Cast"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
								},
								["Lua:Power"] = {
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
							},
							["first"] = false,
						},
						["Ragebar"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["exists"] = true,
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
					},
				},
				["Giit tank"] = {
					["layouts"] = {
						["Normal"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["enabled"] = false,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nreturn \"%s/%s\",Short(HP(unit),true),Short(MaxHP(unit),true)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["enabled"] = false,
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Focus"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Target of Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["enabled"] = false,
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Focus Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["enabled"] = false,
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
					},
				},
				["Giit -Tank"] = {
					["layouts"] = {
						["Normal"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Reputation"] = {
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
								},
								["Lua:Name"] = {
									["enabled"] = false,
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
								},
								["Lua:Threat"] = {
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
								},
								["Lua:Experience"] = {
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
								},
								["Lua:Druid mana"] = {
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Cast"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
								},
								["Lua:Health"] = {
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nreturn \"%s/%s\",Short(HP(unit),true),Short(MaxHP(unit),true)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["enabled"] = false,
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
								},
								["Lua:Cast time"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Power"] = {
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
							},
							["first"] = false,
						},
						["Focus"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Reputation"] = {
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
								},
								["Lua:Power"] = {
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Threat"] = {
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
								},
								["Lua:Name"] = {
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
								},
								["Lua:Cast"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Cast time"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Health"] = {
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
								},
								["Lua:Druid mana"] = {
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Experience"] = {
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
								},
							},
							["first"] = false,
						},
						["Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Experience"] = {
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
								},
								["Lua:Name"] = {
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
								},
								["Lua:Threat"] = {
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
								},
								["Lua:Power"] = {
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Cast time"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Cast"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Health"] = {
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
								},
								["Lua:Druid mana"] = {
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Reputation"] = {
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
								},
							},
							["first"] = false,
						},
						["Target of Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Reputation"] = {
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
								},
								["Lua:Name"] = {
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
								},
								["Lua:Threat"] = {
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
								},
								["Lua:Experience"] = {
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
								},
								["Lua:Druid mana"] = {
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Cast time"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Health"] = {
									["enabled"] = false,
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
								},
								["Lua:Cast"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
								},
								["Lua:Power"] = {
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
							},
							["first"] = false,
						},
						["Focus Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Experience"] = {
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
								},
								["Lua:Power"] = {
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Threat"] = {
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
								},
								["Lua:Reputation"] = {
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
								},
								["Lua:Druid mana"] = {
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Cast"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
								},
								["Lua:Health"] = {
									["enabled"] = false,
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
								},
								["Lua:Cast time"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Name"] = {
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
								},
							},
							["first"] = false,
						},
					},
				},
				["Default"] = {
					["layouts"] = {
						["Normal"] = {
							["first"] = false,
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
								},
								["Lua:Name"] = {
									["enabled"] = false,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["exists"] = true,
									["position"] = 1.00001,
									["location"] = "left",
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["attach_to"] = "HealthBar",
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
								},
								["Lua:PVPTimer"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["exists"] = true,
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
									["location"] = "out_right_top",
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
								},
								["Lua:Health"] = {
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nreturn \"%s/%s\",Short(HP(unit),true),Short(MaxHP(unit),true)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
								},
								["Lua:Alternate power"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["exists"] = true,
									["code"] = "local max = MaxPower(unit,ALTERNATE_POWER_INDEX)\nif max > 0 then\n  return \"%s%%\",Percent(Power(unit,ALTERNATE_POWER_INDEX),max)\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "AltPowerBar",
								},
								["Lua:Class"] = {
									["enabled"] = false,
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
								},
								["Lua:Health percent"] = {
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nreturn \"%s%%\",Percent(HP(unit),MaxHP(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
								},
							},
						},
						["Focus"] = {
							["first"] = false,
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
								},
								["Lua:Health"] = {
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
								},
								["Lua:PVPTimer"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["exists"] = true,
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
									["location"] = "out_right_top",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
								},
							},
						},
						["Target"] = {
							["first"] = false,
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
								},
								["Lua:Health"] = {
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
								},
								["Lua:PVPTimer"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["exists"] = true,
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
									["location"] = "out_right_top",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
								},
							},
						},
						["Focus Target"] = {
							["first"] = false,
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
								},
								["Lua:Health"] = {
									["enabled"] = false,
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
								},
								["Lua:PVPTimer"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["exists"] = true,
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
									["location"] = "out_right_top",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
								},
							},
						},
						["Target of Target"] = {
							["first"] = false,
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
								},
								["Lua:Health"] = {
									["enabled"] = false,
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
								},
								["Lua:PVPTimer"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["exists"] = true,
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
									["location"] = "out_right_top",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
								},
							},
						},
						["Ragebar"] = {
							["first"] = false,
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
								},
								["Lua:Health"] = {
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
								},
								["Lua:PVPTimer"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["exists"] = true,
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
									["location"] = "out_right_top",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
								},
							},
						},
					},
				},
				["Ezyn Tank"] = {
					["layouts"] = {
						["Normal"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Reputation"] = {
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
								},
								["Lua:Name"] = {
									["enabled"] = false,
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
								},
								["Lua:Threat"] = {
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
								},
								["Lua:Experience"] = {
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
								},
								["Lua:Druid mana"] = {
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Cast"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
								},
								["Lua:Health"] = {
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nreturn \"%s/%s\",Short(HP(unit),true),Short(MaxHP(unit),true)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["enabled"] = false,
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
								},
								["Lua:Cast time"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Power"] = {
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
							},
							["first"] = false,
						},
						["Focus"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Reputation"] = {
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
								},
								["Lua:Power"] = {
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Threat"] = {
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
								},
								["Lua:Name"] = {
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
								},
								["Lua:Cast"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Cast time"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Health"] = {
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
								},
								["Lua:Druid mana"] = {
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Experience"] = {
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
								},
							},
							["first"] = false,
						},
						["Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Experience"] = {
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
								},
								["Lua:Name"] = {
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
								},
								["Lua:Threat"] = {
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
								},
								["Lua:Power"] = {
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Cast time"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Cast"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Health"] = {
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
								},
								["Lua:Druid mana"] = {
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
								},
								["Lua:Reputation"] = {
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
								},
							},
							["first"] = false,
						},
						["Target of Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Reputation"] = {
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
								},
								["Lua:Name"] = {
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
								},
								["Lua:Threat"] = {
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
								},
								["Lua:Experience"] = {
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
								},
								["Lua:Druid mana"] = {
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Cast time"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Health"] = {
									["enabled"] = false,
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
								},
								["Lua:Cast"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
								},
								["Lua:Power"] = {
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
							},
							["first"] = false,
						},
						["Focus Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["exists"] = true,
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Experience"] = {
									["exists"] = true,
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
								},
								["Lua:Power"] = {
									["exists"] = true,
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Threat"] = {
									["exists"] = true,
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
								},
								["Lua:Reputation"] = {
									["exists"] = true,
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
								},
								["Lua:Druid mana"] = {
									["exists"] = true,
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
								},
								["Lua:Cast"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
								},
								["Lua:Health"] = {
									["enabled"] = false,
									["exists"] = true,
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["exists"] = true,
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
								},
								["Lua:Cast time"] = {
									["exists"] = true,
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
								},
								["Lua:Name"] = {
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
								},
							},
							["first"] = false,
						},
					},
				},
				["Evyyn - Azuremyst"] = {
					["layouts"] = {
						["Normal"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nreturn \"%s/%s\",Short(HP(unit),true),Short(MaxHP(unit),true)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["exists"] = true,
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["enabled"] = false,
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["enabled"] = false,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Focus"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["exists"] = true,
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["exists"] = true,
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Target of Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["enabled"] = false,
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["exists"] = true,
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Focus Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["enabled"] = false,
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["exists"] = true,
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
					},
				},
				["Git - Tanl"] = {
					["layouts"] = {
						["Normal"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["enabled"] = false,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nreturn \"%s/%s\",Short(HP(unit),true),Short(MaxHP(unit),true)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["enabled"] = false,
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Focus"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_MAXPOWER"] = true,
										["UNIT_POWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Target of Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["exists"] = true,
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["enabled"] = false,
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Focus Target"] = {
							["elements"] = {
								["Lua:Eclipse"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "return math.abs(Power(unit,SPELL_POWER_ECLIPSE))\n",
									["location"] = "center",
									["attach_to"] = "Eclipse",
									["exists"] = true,
								},
								["Lua:Experience"] = {
									["events"] = {
										["UNIT_PET_EXPERIENCE"] = true,
										["PLAYER_XP_UPDATE"] = true,
									},
									["code"] = "local cur, max, rest = XP(unit), MaxXP(unit), RestXP(unit)\nif rest then\n  return \"%s/%s (%s%%) R: %s%%\",cur,max,Percent(cur,max),Percent(rest,max)\nelse\n  return \"%s/%s (%s%%)\",cur,max,Percent(cur,max)\nend",
									["location"] = "center",
									["attach_to"] = "ExperienceBar",
									["exists"] = true,
								},
								["Lua:Name"] = {
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
										["UNIT_NAME_UPDATE"] = true,
									},
									["code"] = "return '%s %s%s%s',Name(unit),Angle(AFK(unit) or DND(unit))",
									["location"] = "left",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:Threat"] = {
									["events"] = {
										["UNIT_THREAT_LIST_UPDATE"] = true,
										["UNIT_THREAT_SITUATION_UPDATE"] = true,
									},
									["code"] = "local unit_a,unit_b = ThreatPair(unit)\nif unit_a and unit_b then\n  local _,_,percent = UnitDetailedThreatSituation(unit_a, unit_b)\n  if percent and percent ~= 0 then\n    return \"%s%%\",Round(percent,1)\n  end\nend\nreturn ConfigMode()",
									["location"] = "center",
									["attach_to"] = "ThreatBar",
									["exists"] = true,
								},
								["Lua:Power"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "local max = MaxPower(unit)\nif max > 0 then\n  return \"%s/%s\",Power(unit),max\nend",
									["location"] = "right",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Cast"] = {
									["events"] = {
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  local spell,stop_message,target = cast_data.spell,cast_data.stop_message,cast_data.target\n  local stop_time,stop_duration = cast_data.stop_time\n  if stop_time then\n    stop_duration = GetTime() - stop_time\n  end\n  Alpha(-(stop_duration or 0) + 1)\n  if stop_message then\n    return stop_message\n  elseif target then\n    return \"%s (%s)\",spell,target\n  else\n    return spell \n  end\nend\nreturn ConfigMode()",
									["location"] = "left",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Cast time"] = {
									["events"] = {
										["UNIT_SPELLCAST_SUCCEEDED"] = true,
										["UNIT_SPELLCAST_START"] = true,
										["UNIT_SPELLCAST_CHANNEL_START"] = true,
										["UNIT_SPELLCAST_DELAYED"] = true,
										["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
										["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
										["UNIT_SPELLCAST_STOP"] = true,
										["UNIT_SPELLCAST_INTERRUPTED"] = true,
										["UNIT_SPELLCAST_FAILED"] = true,
									},
									["code"] = "local cast_data = CastData(unit)\nif cast_data then\n  if not cast_data.stop_time then\n    local delay,end_time = cast_data.delay, cast_data.end_time\n    local duration\n    if end_time then\n      duration = end_time - GetTime()\n    end\n    if delay and delay ~= 0 then\n      local delay_sign = '+'\n      if delay < 0 then\n        delay_sign = ''\n      end\n      if duration and duration >= 0 then\n        return \"|cffff0000%s%s|r %.1f\",delay_sign,Round(delay,1),duration\n      else\n        return \"|cffff0000%s%s|r\",delay_sign,Round(delay,1)\n      end\n    elseif duration and duration >= 0 then\n      return \"%.1f\",duration\n    end\n  end\nend\nreturn ConfigMode()",
									["location"] = "right",
									["attach_to"] = "CastBar",
									["exists"] = true,
								},
								["Lua:Health"] = {
									["enabled"] = false,
									["events"] = {
										["UNIT_HEALTH"] = true,
										["UNIT_AURA"] = true,
										["UNIT_MAXHEALTH"] = true,
									},
									["code"] = "local s = Status(unit)\nif s then\n  return s\nend\nlocal cur, max = HP(unit), MaxHP(unit)\nreturn \"%s/%s || %s%%\",Short(cur,true),Short(max,true),Percent(cur,max)",
									["location"] = "right",
									["attach_to"] = "HealthBar",
									["exists"] = true,
								},
								["Lua:PVPTimer"] = {
									["location"] = "out_right_top",
									["exists"] = true,
									["events"] = {
										["PLAYER_FLAGS_CHANGED"] = true,
									},
									["code"] = "if unit == \"player\" then\n  local pvp = PVPDuration()\n  if pvp then\n    return \"|cffff0000%s|r\",FormatDuration(pvp)\n  end\nend",
								},
								["Lua:Class"] = {
									["events"] = {
										["UNIT_LEVEL"] = true,
										["UNIT_CLASSIFICATION_CHANGED"] = true,
										["UNIT_AURA"] = true,
									},
									["code"] = "local dr,dg,db = DifficultyColor(unit)\nlocal form = DruidForm(unit)\nlocal classification = Classification(unit)\nif UnitIsPlayer(unit) or (not UnitIsFriend(unit,\"player\") and not IsPet(unit)) then\n  local cr,cg,cb = ClassColor(unit)\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),cr,cg,cb,Class(unit),SmartRace(unit) or ''\n  end\nelse\n  if form then\n    return \"%s%s|cff%02x%02x%02x%s|r (%s) %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),form,SmartRace(unit) or ''\n  else\n    return \"%s%s|cff%02x%02x%02x%s|r %s\",classification or '',classification and ' ' or '',dr,dg,db,Level(unit),SmartRace(unit) or ''\n  end\nend",
									["location"] = "left",
									["attach_to"] = "PowerBar",
									["exists"] = true,
								},
								["Lua:Druid mana"] = {
									["events"] = {
										["UNIT_POWER"] = true,
										["UNIT_MAXPOWER"] = true,
									},
									["code"] = "if UnitPowerType(unit) ~= 0 then\n  return \"%s/%s\",Power(unit,0),MaxPower(unit,0)\nend",
									["location"] = "center",
									["attach_to"] = "DruidManaBar",
									["exists"] = true,
								},
								["Lua:Reputation"] = {
									["events"] = {
										["UNIT_FACTION"] = true,
										["UPDATE_FACTION"] = true,
									},
									["code"] = "local name, _, min , max, value, id = GetWatchedFactionInfo()\nif IsMouseOver() then\n  return name or ConfigMode() \nelse\n  local fs_id, fs_rep, _, _, _, _, _, fs_threshold, next_fs_threshold = GetFriendshipReputation(id)\n  if fs_id then\n    if next_fs_threshold then\n      min, max, value = fs_threshold, next_fs_threshold, fs_rep\n    else\n      min, max, value = 0, 1, 1\n    end\n  end\n  local bar_cur,bar_max = value-min,max-min\n  return \"%d/%d (%s%%)\",bar_cur,bar_max,Percent(bar_cur,bar_max)\nend",
									["location"] = "center",
									["attach_to"] = "ReputationBar",
									["exists"] = true,
								},
							},
							["first"] = false,
						},
					},
				},
			},
		},
		["ReadyCheckIcon"] = {
		},
		["HostilityFader"] = {
		},
		["Highlight"] = {
		},
		["ThreatBar"] = {
		},
		["Portrait"] = {
		},
		["ExperienceBar"] = {
			["profiles"] = {
				["Default"] = {
					["layouts"] = {
						["Normal"] = {
							["position"] = 2,
							["size"] = 4,
						},
						["Target"] = {
							["position"] = 3,
						},
						["Ragebar"] = {
							["position"] = 3,
						},
					},
				},
				["Gitt Tank"] = {
					["layouts"] = {
						["Normal"] = {
							["position"] = 2,
							["size"] = 4,
						},
						["Target"] = {
							["position"] = 3,
						},
						["Ragebar"] = {
							["position"] = 3,
						},
					},
				},
			},
		},
		["RaidTargetIcon"] = {
		},
		["Eclipse"] = {
			["profiles"] = {
				["Default"] = {
					["layouts"] = {
						["Normal"] = {
							["size"] = 1.800000071525574,
						},
					},
					["global"] = {
						["enabled"] = false,
					},
				},
				["Custom - Heals"] = {
					["layouts"] = {
						["Normal"] = {
							["size"] = 1.800000071525574,
						},
					},
					["global"] = {
						["enabled"] = false,
					},
				},
			},
		},
		["CastBar"] = {
			["profiles"] = {
				["Default"] = {
					["layouts"] = {
						["Normal"] = {
							["enabled"] = false,
						},
						["Target"] = {
							["size"] = 2,
							["position"] = 1,
							["texture"] = "Smooth",
						},
						["Focus Target"] = {
							["enabled"] = false,
						},
					},
				},
			},
		},
		["LeaderIconEx"] = {
		},
		["Sounds"] = {
		},
		["CastBarLatency"] = {
		},
		["Background"] = {
		},
		["Aura"] = {
			["profiles"] = {
				["Giit tank"] = {
					["layouts"] = {
						["Target"] = {
							["max_buffs"] = 8,
							["layout"] = {
								["buff"] = {
									["width_percent"] = 1,
									["my_size"] = 30,
									["size"] = 30,
								},
								["debuff"] = {
									["my_size"] = 30,
									["side"] = "TOP",
									["width_percent"] = 1,
									["anchor"] = "TOPRIGHT",
									["width"] = 65,
									["growth"] = "left_up",
									["size"] = 15,
								},
							},
							["max_debuffs"] = 50,
							["texts"] = {
								["my_buffs"] = {
									["count"] = {
										["size"] = 1.75,
									},
								},
								["my_debuffs"] = {
									["count"] = {
										["size"] = 1.75,
									},
								},
							},
						},
						["Focus"] = {
							["enabled_debuffs"] = false,
						},
						["Target of Target"] = {
							["enabled_buffs"] = false,
							["layout"] = {
								["debuff"] = {
									["side"] = "TOP",
									["width_percent"] = 1,
									["anchor"] = "TOPRIGHT",
									["my_size"] = 48,
									["growth"] = "left_up",
									["size"] = 48,
								},
							},
							["max_debuffs"] = 5,
							["enabled_weapons"] = false,
						},
						["Focus Target"] = {
							["enabled_weapons"] = false,
							["enabled_buffs"] = false,
						},
					},
					["global"] = {
						["filters"] = {
							["*E"] = {
								["name_list"] = {
									["Void Diffusion"] = true,
								},
							},
							["*C"] = {
								["name_list"] = {
									["Void Diffusion"] = true,
								},
							},
						},
					},
				},
				["Custom - Heals"] = {
					["layouts"] = {
						["Target"] = {
							["max_buffs"] = 8,
							["layout"] = {
								["debuff"] = {
									["my_size"] = 30,
									["side"] = "TOP",
									["width_percent"] = 1,
									["anchor"] = "TOPRIGHT",
									["width"] = 65,
									["growth"] = "left_up",
									["size"] = 15,
								},
								["buff"] = {
									["width_percent"] = 1,
									["my_size"] = 30,
									["size"] = 30,
								},
							},
							["max_debuffs"] = 50,
							["texts"] = {
								["my_debuffs"] = {
									["count"] = {
										["size"] = 1.75,
									},
								},
								["my_buffs"] = {
									["count"] = {
										["size"] = 1.75,
									},
								},
							},
						},
						["Focus"] = {
							["enabled_debuffs"] = false,
						},
						["Target of Target"] = {
							["layout"] = {
								["debuff"] = {
									["side"] = "TOP",
									["width_percent"] = 1,
									["anchor"] = "TOPRIGHT",
									["my_size"] = 48,
									["growth"] = "left_up",
									["size"] = 48,
								},
							},
							["enabled_buffs"] = false,
							["max_debuffs"] = 5,
							["enabled_weapons"] = false,
						},
						["Focus Target"] = {
							["enabled_weapons"] = false,
							["enabled_buffs"] = false,
						},
					},
					["global"] = {
						["filters"] = {
							["*E"] = {
								["name_list"] = {
									["Void Diffusion"] = true,
								},
							},
							["*C"] = {
								["name_list"] = {
									["Void Diffusion"] = true,
								},
							},
						},
					},
				},
				["Lihte-DPS"] = {
					["layouts"] = {
						["Target"] = {
							["texts"] = {
								["my_buffs"] = {
									["count"] = {
										["size"] = 1.75,
									},
								},
								["my_debuffs"] = {
									["count"] = {
										["size"] = 1.75,
									},
								},
							},
							["layout"] = {
								["buff"] = {
									["size"] = 30,
									["my_size"] = 30,
									["width_percent"] = 1,
								},
								["debuff"] = {
									["size"] = 15,
									["side"] = "TOP",
									["width_percent"] = 1,
									["anchor"] = "TOPRIGHT",
									["width"] = 65,
									["growth"] = "left_up",
									["my_size"] = 30,
								},
							},
							["max_debuffs"] = 50,
							["max_buffs"] = 8,
						},
						["Focus"] = {
							["enabled_debuffs"] = false,
						},
						["Target of Target"] = {
							["enabled_buffs"] = false,
							["layout"] = {
								["debuff"] = {
									["side"] = "TOP",
									["width_percent"] = 1,
									["anchor"] = "TOPRIGHT",
									["size"] = 48,
									["growth"] = "left_up",
									["my_size"] = 48,
								},
							},
							["max_debuffs"] = 5,
							["enabled_weapons"] = false,
						},
						["Focus Target"] = {
							["enabled_buffs"] = false,
							["enabled_weapons"] = false,
						},
					},
					["global"] = {
						["filters"] = {
							["*E"] = {
								["name_list"] = {
									["Void Diffusion"] = true,
								},
							},
							["*C"] = {
								["name_list"] = {
									["Void Diffusion"] = true,
								},
							},
						},
					},
				},
				["Git - Tanl"] = {
					["layouts"] = {
						["Target"] = {
							["texts"] = {
								["my_buffs"] = {
									["count"] = {
										["size"] = 1.75,
									},
								},
								["my_debuffs"] = {
									["count"] = {
										["size"] = 1.75,
									},
								},
							},
							["layout"] = {
								["debuff"] = {
									["size"] = 15,
									["side"] = "TOP",
									["width_percent"] = 1,
									["anchor"] = "TOPRIGHT",
									["width"] = 65,
									["growth"] = "left_up",
									["my_size"] = 30,
								},
								["buff"] = {
									["size"] = 30,
									["my_size"] = 30,
									["width_percent"] = 1,
								},
							},
							["max_debuffs"] = 50,
							["max_buffs"] = 8,
						},
						["Focus"] = {
							["enabled_debuffs"] = false,
						},
						["Target of Target"] = {
							["enabled_buffs"] = false,
							["layout"] = {
								["debuff"] = {
									["side"] = "TOP",
									["width_percent"] = 1,
									["anchor"] = "TOPRIGHT",
									["size"] = 48,
									["growth"] = "left_up",
									["my_size"] = 48,
								},
							},
							["max_debuffs"] = 5,
							["enabled_weapons"] = false,
						},
						["Focus Target"] = {
							["enabled_buffs"] = false,
							["enabled_weapons"] = false,
						},
					},
					["global"] = {
						["filters"] = {
							["*E"] = {
								["name_list"] = {
									["Void Diffusion"] = true,
								},
							},
							["*C"] = {
								["name_list"] = {
									["Void Diffusion"] = true,
								},
							},
						},
					},
				},
				["Ezyn Tank"] = {
					["layouts"] = {
						["Target"] = {
							["max_buffs"] = 8,
							["layout"] = {
								["buff"] = {
									["width_percent"] = 1,
									["my_size"] = 30,
									["size"] = 30,
								},
								["debuff"] = {
									["my_size"] = 30,
									["side"] = "TOP",
									["width_percent"] = 1,
									["anchor"] = "TOPRIGHT",
									["width"] = 65,
									["growth"] = "left_up",
									["size"] = 15,
								},
							},
							["max_debuffs"] = 50,
							["texts"] = {
								["my_buffs"] = {
									["count"] = {
										["size"] = 1.75,
									},
								},
								["my_debuffs"] = {
									["count"] = {
										["size"] = 1.75,
									},
								},
							},
						},
						["Focus Target"] = {
							["enabled_weapons"] = false,
							["enabled_buffs"] = false,
						},
						["Target of Target"] = {
							["enabled_buffs"] = false,
							["layout"] = {
								["debuff"] = {
									["side"] = "TOP",
									["width_percent"] = 1,
									["anchor"] = "TOPRIGHT",
									["my_size"] = 48,
									["growth"] = "left_up",
									["size"] = 48,
								},
							},
							["max_debuffs"] = 5,
							["enabled_weapons"] = false,
						},
						["Focus"] = {
							["enabled_debuffs"] = false,
						},
					},
					["global"] = {
						["filters"] = {
							["*E"] = {
								["name_list"] = {
									["Void Diffusion"] = true,
								},
							},
							["25"] = {
								["name_list"] = {
									["Sated"] = true,
								},
							},
							["22"] = {
								["name_list"] = {
									["Bloodlust"] = true,
								},
							},
							["*C"] = {
								["name_list"] = {
									["Void Diffusion"] = true,
								},
							},
						},
					},
				},
				["Default"] = {
					["layouts"] = {
						["Normal"] = {
							["enabled"] = false,
						},
						["Focus Target"] = {
							["enabled_weapons"] = false,
							["enabled_buffs"] = false,
						},
						["Target"] = {
							["max_debuffs"] = 50,
							["layout"] = {
								["debuff"] = {
									["width_percent"] = 1,
									["my_size"] = 30,
									["anchor"] = "TOPRIGHT",
									["size"] = 15,
									["side"] = "TOP",
									["width"] = 65,
									["growth"] = "left_up",
								},
								["buff"] = {
									["width_percent"] = 1,
									["my_size"] = 30,
									["size"] = 30,
								},
							},
							["max_buffs"] = 8,
							["texts"] = {
								["my_debuffs"] = {
									["count"] = {
										["size"] = 1.75,
									},
								},
								["my_buffs"] = {
									["count"] = {
										["size"] = 1.75,
									},
								},
							},
						},
						["Focus"] = {
							["enabled_debuffs"] = false,
						},
						["Target of Target"] = {
							["enabled_weapons"] = false,
							["max_debuffs"] = 5,
							["layout"] = {
								["debuff"] = {
									["width_percent"] = 1,
									["my_size"] = 48,
									["anchor"] = "TOPRIGHT",
									["size"] = 48,
									["side"] = "TOP",
									["growth"] = "left_up",
								},
							},
							["enabled_buffs"] = false,
						},
						["Ragebar"] = {
							["max_debuffs"] = 50,
							["layout"] = {
								["debuff"] = {
									["width_percent"] = 1,
									["my_size"] = 30,
									["anchor"] = "TOPRIGHT",
									["size"] = 15,
									["side"] = "TOP",
									["width"] = 65,
									["growth"] = "left_up",
								},
								["buff"] = {
									["width_percent"] = 1,
									["my_size"] = 30,
									["size"] = 30,
								},
							},
							["max_buffs"] = 8,
							["texts"] = {
								["my_debuffs"] = {
									["count"] = {
										["size"] = 1.75,
									},
								},
								["my_buffs"] = {
									["count"] = {
										["size"] = 1.75,
									},
								},
							},
						},
					},
					["global"] = {
						["filters"] = {
							["*E"] = {
								["name_list"] = {
									["Void Diffusion"] = true,
								},
							},
							["*C"] = {
								["name_list"] = {
									["Void Diffusion"] = true,
								},
							},
						},
					},
				},
				["Gitt Tank"] = {
					["layouts"] = {
						["Normal"] = {
							["enabled"] = false,
						},
						["Focus Target"] = {
							["enabled_weapons"] = false,
							["enabled_buffs"] = false,
						},
						["Target"] = {
							["max_buffs"] = 8,
							["layout"] = {
								["buff"] = {
									["width_percent"] = 1,
									["my_size"] = 30,
									["size"] = 30,
								},
								["debuff"] = {
									["my_size"] = 30,
									["side"] = "TOP",
									["width_percent"] = 1,
									["anchor"] = "TOPRIGHT",
									["width"] = 65,
									["growth"] = "left_up",
									["size"] = 15,
								},
							},
							["max_debuffs"] = 50,
							["texts"] = {
								["my_buffs"] = {
									["count"] = {
										["size"] = 1.75,
									},
								},
								["my_debuffs"] = {
									["count"] = {
										["size"] = 1.75,
									},
								},
							},
						},
						["Focus"] = {
							["enabled_debuffs"] = false,
						},
						["Target of Target"] = {
							["enabled_buffs"] = false,
							["layout"] = {
								["debuff"] = {
									["side"] = "TOP",
									["width_percent"] = 1,
									["anchor"] = "TOPRIGHT",
									["my_size"] = 48,
									["growth"] = "left_up",
									["size"] = 48,
								},
							},
							["max_debuffs"] = 5,
							["enabled_weapons"] = false,
						},
						["Ragebar"] = {
							["max_buffs"] = 8,
							["layout"] = {
								["debuff"] = {
									["my_size"] = 30,
									["side"] = "TOP",
									["width_percent"] = 1,
									["anchor"] = "TOPRIGHT",
									["width"] = 65,
									["growth"] = "left_up",
									["size"] = 15,
								},
								["buff"] = {
									["width_percent"] = 1,
									["my_size"] = 30,
									["size"] = 30,
								},
							},
							["max_debuffs"] = 50,
							["texts"] = {
								["my_buffs"] = {
									["count"] = {
										["size"] = 1.75,
									},
								},
								["my_debuffs"] = {
									["count"] = {
										["size"] = 1.75,
									},
								},
							},
						},
					},
					["global"] = {
						["filters"] = {
							["*E"] = {
								["name_list"] = {
									["Void Diffusion"] = true,
								},
							},
							["*C"] = {
								["name_list"] = {
									["Void Diffusion"] = true,
								},
							},
						},
					},
				},
				["Giit -Tank"] = {
					["layouts"] = {
						["Target"] = {
							["max_buffs"] = 8,
							["layout"] = {
								["buff"] = {
									["width_percent"] = 1,
									["my_size"] = 30,
									["size"] = 30,
								},
								["debuff"] = {
									["my_size"] = 30,
									["side"] = "TOP",
									["width_percent"] = 1,
									["anchor"] = "TOPRIGHT",
									["width"] = 65,
									["growth"] = "left_up",
									["size"] = 15,
								},
							},
							["max_debuffs"] = 50,
							["texts"] = {
								["my_buffs"] = {
									["count"] = {
										["size"] = 1.75,
									},
								},
								["my_debuffs"] = {
									["count"] = {
										["size"] = 1.75,
									},
								},
							},
						},
						["Focus Target"] = {
							["enabled_weapons"] = false,
							["enabled_buffs"] = false,
						},
						["Target of Target"] = {
							["enabled_buffs"] = false,
							["layout"] = {
								["debuff"] = {
									["side"] = "TOP",
									["width_percent"] = 1,
									["anchor"] = "TOPRIGHT",
									["my_size"] = 48,
									["growth"] = "left_up",
									["size"] = 48,
								},
							},
							["max_debuffs"] = 5,
							["enabled_weapons"] = false,
						},
						["Focus"] = {
							["enabled_debuffs"] = false,
						},
					},
					["global"] = {
						["filters"] = {
							["*E"] = {
								["name_list"] = {
									["Void Diffusion"] = true,
								},
							},
							["*C"] = {
								["name_list"] = {
									["Void Diffusion"] = true,
								},
							},
						},
					},
				},
			},
		},
		["RestIcon"] = {
		},
		["PvPIcon"] = {
		},
		["PowerBar"] = {
			["profiles"] = {
				["Custom - Heals"] = {
					["layouts"] = {
						["Normal"] = {
							["position"] = 1,
						},
						["Focus"] = {
							["enabled"] = false,
							["texture"] = "Glamour7",
							["position"] = 1,
						},
						["Target"] = {
							["texture"] = "Smooth",
							["position"] = 1,
						},
						["Target of Target"] = {
							["enabled"] = false,
							["texture"] = "Glamour7",
							["position"] = 1,
						},
						["Focus Target"] = {
							["enabled"] = false,
							["texture"] = "Glamour7",
							["position"] = 1,
						},
					},
				},
				["Lihte-DPS"] = {
					["layouts"] = {
						["Normal"] = {
							["position"] = 1,
						},
						["Focus"] = {
							["enabled"] = false,
							["position"] = 1,
							["texture"] = "Glamour7",
						},
						["Target"] = {
							["position"] = 1,
							["texture"] = "Smooth",
						},
						["Target of Target"] = {
							["enabled"] = false,
							["position"] = 1,
							["texture"] = "Glamour7",
						},
						["Focus Target"] = {
							["enabled"] = false,
							["position"] = 1,
							["texture"] = "Glamour7",
						},
					},
				},
				["Gitt Tank"] = {
					["layouts"] = {
						["Normal"] = {
							["size"] = 1,
							["position"] = 3,
						},
						["Focus"] = {
							["texture"] = "Glamour7",
							["position"] = 1,
						},
						["Target"] = {
							["texture"] = "Smooth",
						},
						["Focus Target"] = {
							["enabled"] = false,
							["texture"] = "Glamour7",
							["position"] = 1,
						},
						["Target of Target"] = {
							["enabled"] = false,
							["texture"] = "Glamour7",
							["position"] = 1,
						},
						["Ragebar"] = {
							["texture"] = "Smooth",
						},
					},
				},
				["Giit tank"] = {
					["layouts"] = {
						["Normal"] = {
							["position"] = 1,
						},
						["Focus"] = {
							["enabled"] = false,
							["texture"] = "Glamour7",
							["position"] = 1,
						},
						["Target"] = {
							["texture"] = "Smooth",
							["position"] = 1,
						},
						["Target of Target"] = {
							["enabled"] = false,
							["texture"] = "Glamour7",
							["position"] = 1,
						},
						["Focus Target"] = {
							["enabled"] = false,
							["texture"] = "Glamour7",
							["position"] = 1,
						},
					},
				},
				["Giit -Tank"] = {
					["layouts"] = {
						["Normal"] = {
							["position"] = 1,
						},
						["Focus"] = {
							["enabled"] = false,
							["texture"] = "Glamour7",
							["position"] = 1,
						},
						["Target"] = {
							["texture"] = "Smooth",
							["position"] = 1,
						},
						["Target of Target"] = {
							["enabled"] = false,
							["texture"] = "Glamour7",
							["position"] = 1,
						},
						["Focus Target"] = {
							["enabled"] = false,
							["texture"] = "Glamour7",
							["position"] = 1,
						},
					},
				},
				["Default"] = {
					["layouts"] = {
						["Normal"] = {
							["size"] = 1,
							["position"] = 3,
						},
						["Focus"] = {
							["texture"] = "Glamour7",
							["position"] = 1,
						},
						["Target"] = {
							["size"] = 6,
							["texture"] = "Smooth",
						},
						["Focus Target"] = {
							["texture"] = "Glamour7",
							["enabled"] = false,
							["position"] = 1,
						},
						["Target of Target"] = {
							["texture"] = "Glamour7",
							["enabled"] = false,
							["position"] = 1,
						},
						["Ragebar"] = {
							["texture"] = "Smooth",
						},
					},
				},
				["Ezyn Tank"] = {
					["layouts"] = {
						["Normal"] = {
							["position"] = 1,
						},
						["Focus"] = {
							["enabled"] = false,
							["texture"] = "Glamour7",
							["position"] = 1,
						},
						["Target"] = {
							["texture"] = "Smooth",
							["position"] = 1,
						},
						["Target of Target"] = {
							["enabled"] = false,
							["texture"] = "Glamour7",
							["position"] = 1,
						},
						["Focus Target"] = {
							["enabled"] = false,
							["texture"] = "Glamour7",
							["position"] = 1,
						},
					},
				},
				["Evyyn - Azuremyst"] = {
					["layouts"] = {
						["Normal"] = {
							["texture"] = "Glamour7",
							["position"] = 1,
						},
						["Focus"] = {
							["enabled"] = false,
							["texture"] = "Glamour7",
							["position"] = 1,
						},
						["Target"] = {
							["enabled"] = false,
							["texture"] = "Glamour7",
							["position"] = 1,
						},
						["Target of Target"] = {
							["enabled"] = false,
							["texture"] = "Glamour7",
							["position"] = 1,
						},
						["Focus Target"] = {
							["enabled"] = false,
							["texture"] = "Glamour7",
							["position"] = 1,
						},
					},
				},
				["Git - Tanl"] = {
					["layouts"] = {
						["Normal"] = {
							["position"] = 1,
						},
						["Focus"] = {
							["enabled"] = false,
							["position"] = 1,
							["texture"] = "Glamour7",
						},
						["Target"] = {
							["position"] = 1,
							["texture"] = "Smooth",
						},
						["Target of Target"] = {
							["enabled"] = false,
							["position"] = 1,
							["texture"] = "Glamour7",
						},
						["Focus Target"] = {
							["enabled"] = false,
							["position"] = 1,
							["texture"] = "Glamour7",
						},
					},
				},
			},
		},
		["HideBlizzard"] = {
			["profiles"] = {
				["Git - Tanl"] = {
					["global"] = {
						["altpower"] = false,
					},
				},
				["Lihte-DPS"] = {
					["global"] = {
						["altpower"] = false,
					},
				},
				["Ezyn Tank"] = {
					["global"] = {
						["altpower"] = false,
					},
				},
				["Giit -Tank"] = {
					["global"] = {
						["altpower"] = false,
					},
				},
				["Custom - Heals"] = {
					["global"] = {
						["altpower"] = false,
					},
				},
			},
		},
		["ReputationBar"] = {
		},
		["NamePlate"] = {
		},
		["HealthBar"] = {
			["profiles"] = {
				["Custom - Heals"] = {
					["layouts"] = {
						["Normal"] = {
							["position"] = 2,
						},
						["Focus"] = {
							["texture"] = "Minimalist",
							["position"] = 2,
						},
						["Target"] = {
							["position"] = 2,
						},
						["Target of Target"] = {
							["position"] = 2,
						},
						["Focus Target"] = {
							["texture"] = "Glamour",
							["position"] = 2,
						},
					},
				},
				["Lihte-DPS"] = {
					["layouts"] = {
						["Normal"] = {
							["position"] = 2,
						},
						["Focus"] = {
							["position"] = 2,
							["texture"] = "Minimalist",
						},
						["Target"] = {
							["position"] = 2,
						},
						["Target of Target"] = {
							["position"] = 2,
						},
						["Focus Target"] = {
							["position"] = 2,
							["texture"] = "Glamour",
						},
					},
				},
				["Gitt Tank"] = {
					["layouts"] = {
						["Normal"] = {
							["size"] = 5,
						},
						["Focus"] = {
							["texture"] = "Smooth",
							["position"] = 3,
						},
						["Target"] = {
							["size"] = 7,
						},
						["Focus Target"] = {
							["position"] = 2,
						},
						["Target of Target"] = {
							["position"] = 2,
						},
						["Ragebar"] = {
							["size"] = 7,
						},
					},
				},
				["Giit tank"] = {
					["layouts"] = {
						["Normal"] = {
							["position"] = 2,
						},
						["Focus"] = {
							["texture"] = "Minimalist",
							["position"] = 2,
						},
						["Target"] = {
							["position"] = 2,
						},
						["Target of Target"] = {
							["position"] = 2,
						},
						["Focus Target"] = {
							["texture"] = "Glamour",
							["position"] = 2,
						},
					},
				},
				["Giit -Tank"] = {
					["layouts"] = {
						["Normal"] = {
							["position"] = 2,
						},
						["Focus"] = {
							["texture"] = "Minimalist",
							["position"] = 2,
						},
						["Target"] = {
							["position"] = 2,
						},
						["Target of Target"] = {
							["position"] = 2,
						},
						["Focus Target"] = {
							["texture"] = "Glamour",
							["position"] = 2,
						},
					},
				},
				["Default"] = {
					["layouts"] = {
						["Normal"] = {
							["size"] = 5,
						},
						["Focus"] = {
							["texture"] = "Smooth",
							["position"] = 3,
						},
						["Target"] = {
							["size"] = 7,
						},
						["Focus Target"] = {
							["position"] = 2,
						},
						["Target of Target"] = {
							["position"] = 2,
						},
						["Ragebar"] = {
							["size"] = 7,
						},
					},
				},
				["Ezyn Tank"] = {
					["layouts"] = {
						["Normal"] = {
							["position"] = 2,
						},
						["Focus"] = {
							["texture"] = "Minimalist",
							["position"] = 2,
						},
						["Target"] = {
							["position"] = 2,
						},
						["Target of Target"] = {
							["position"] = 2,
						},
						["Focus Target"] = {
							["texture"] = "Glamour",
							["position"] = 2,
						},
					},
				},
				["Evyyn - Azuremyst"] = {
					["layouts"] = {
						["Normal"] = {
							["texture"] = "Glamour2",
							["position"] = 2,
						},
						["Focus"] = {
							["texture"] = "Glamour7",
							["position"] = 2,
						},
						["Target"] = {
							["texture"] = "Glamour6",
							["position"] = 2,
						},
						["Target of Target"] = {
							["texture"] = "Glamour7",
							["position"] = 2,
						},
						["Focus Target"] = {
							["texture"] = "Glamour",
							["position"] = 2,
						},
					},
				},
				["Git - Tanl"] = {
					["layouts"] = {
						["Normal"] = {
							["position"] = 2,
						},
						["Focus"] = {
							["position"] = 2,
							["texture"] = "Minimalist",
						},
						["Target"] = {
							["position"] = 2,
						},
						["Target of Target"] = {
							["position"] = 2,
						},
						["Focus Target"] = {
							["position"] = 2,
							["texture"] = "Glamour",
						},
					},
				},
			},
		},
		["CombatIcon"] = {
		},
		["VoiceIcon"] = {
		},
		["QuestIcon"] = {
		},
		["VisualHeal"] = {
		},
		["DCIcon"] = {
		},
		["CombatFader"] = {
		},
		["BattlePet"] = {
		},
		["AltPowerBar"] = {
			["profiles"] = {
				["Gitt Tank"] = {
					["layouts"] = {
						["Normal"] = {
							["position"] = 4,
							["size"] = 5,
						},
						["Target"] = {
							["enabled"] = false,
							["position"] = 3.00001,
						},
						["Target of Target"] = {
							["enabled"] = false,
						},
						["Focus"] = {
							["texture"] = "Smooth",
							["position"] = 2,
						},
					},
				},
				["Default"] = {
					["layouts"] = {
						["Normal"] = {
							["position"] = 4,
							["size"] = 5,
						},
						["Focus"] = {
							["texture"] = "Smooth",
							["position"] = 2,
						},
						["Target"] = {
							["enabled"] = false,
							["position"] = 3.00001,
						},
						["Target of Target"] = {
							["enabled"] = false,
						},
					},
				},
			},
		},
		["BlankSpace"] = {
			["profiles"] = {
				["Default"] = {
					["layouts"] = {
						["Normal"] = {
							["elements"] = {
								["Default"] = {
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Focus"] = {
							["elements"] = {
								["Default"] = {
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Target"] = {
							["elements"] = {
								["Default"] = {
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Target of Target"] = {
							["elements"] = {
								["Default"] = {
									["exists"] = true,
								},
							},
							["first"] = false,
						},
						["Focus Target"] = {
							["elements"] = {
								["Default"] = {
									["exists"] = true,
								},
							},
							["first"] = false,
						},
					},
				},
			},
		},
		["RaidRoleIcon"] = {
		},
		["RaceIcon"] = {
		},
		["HolyPower"] = {
			["profiles"] = {
				["Default"] = {
					["layouts"] = {
						["Normal"] = {
							["inactive_color"] = {
								0.5, -- [1]
								0.5, -- [2]
								0.5, -- [3]
								0.5, -- [4]
							},
							["side"] = false,
							["text_size"] = 1,
							["attach_to"] = "root",
							["vertical"] = false,
							["active_color"] = {
								0.95, -- [1]
								0.9, -- [2]
								0.6, -- [3]
								1, -- [4]
							},
							["position"] = 1,
							["location"] = "out_top",
							["background_color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
								0.5, -- [4]
							},
							["enabled"] = true,
							["size"] = 1.5,
						},
						["Target"] = {
							["inactive_color"] = {
								0.5, -- [1]
								0.5, -- [2]
								0.5, -- [3]
								0.5, -- [4]
							},
							["side"] = false,
							["text_size"] = 1,
							["attach_to"] = "root",
							["vertical"] = false,
							["active_color"] = {
								0.95, -- [1]
								0.9, -- [2]
								0.6, -- [3]
								1, -- [4]
							},
							["position"] = 1,
							["location"] = "out_top",
							["background_color"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
								0.5, -- [4]
							},
							["enabled"] = true,
							["size"] = 1.5,
						},
					},
					["global"] = {
						["enabled"] = true,
					},
				},
			},
		},
		["ClassIcon"] = {
		},
	},
	["global"] = {
		["config_version"] = 2,
	},
	["profileKeys"] = {
		["Gyit - Area 52"] = "Default",
		["Ghit - Azuremyst"] = "Default",
		["Giit - Azuremyst"] = "Giit -Tank",
		["Evyyn - Azuremyst"] = "Evyyn - Azuremyst",
		["Giitt - Silvermoon"] = "Default",
		["Cowbeary - Azuremyst"] = "Custom - Heals",
		["Gilt - Azuremyst"] = "Default",
		["Ezyn - Azuremyst"] = "Ezyn Tank",
		["Worgit - Moon Guard"] = "Default",
		["Gitt - Cho'gall"] = "Gitt Tank",
		["Giit - Cho'gall"] = "Giit tank",
		["Burk - Azuremyst"] = "Default",
		["Git - Azuremyst"] = "Git - Tanl",
		["Git - Cho'gall"] = "Default",
		["Giitt - Feathermoon"] = "Default",
		["Lihte - Cho'gall"] = "Lihte-DPS",
		["Spih - Cho'gall"] = "Default",
		["Gimm - Cho'gall"] = "Default",
	},
	["profiles"] = {
		["Custom - Heals"] = {
			["class_order"] = {
				"WARRIOR", -- [1]
				"DEATHKNIGHT", -- [2]
				"PALADIN", -- [3]
				"PRIEST", -- [4]
				"SHAMAN", -- [5]
				"DRUID", -- [6]
				"ROGUE", -- [7]
				"MAGE", -- [8]
				"WARLOCK", -- [9]
				"HUNTER", -- [10]
			},
			["layouts"] = {
				["Normal"] = {
					["font_size"] = 0.75,
					["font"] = "DorisPP",
					["bar_padding"] = 1,
					["bar_spacing"] = 0,
					["exists"] = true,
					["bar_texture"] = "Smooth",
				},
				["Focus"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "SCT Emblem",
					["exists"] = true,
					["size_y"] = 25,
					["bar_texture"] = "Glamour2",
				},
				["Target"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "DorisPP",
					["size_x"] = 250,
					["exists"] = true,
					["bar_texture"] = "Fourths",
				},
				["Target of Target"] = {
					["font_size"] = 2,
					["font"] = "DorisPP",
					["size_x"] = 250,
					["exists"] = true,
					["bar_texture"] = "Smooth",
				},
				["Focus Target"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "SCT Emblem",
					["size_x"] = 145,
					["size_y"] = 25,
					["exists"] = true,
					["bar_texture"] = "Glamour2",
				},
			},
			["made_groups"] = true,
			["units"] = {
				["targettargettarget"] = {
					["enabled"] = false,
				},
				["focustarget"] = {
					["layout"] = "Focus Target",
					["position_x"] = 680.8621193527738,
					["position_y"] = 460.7997876720904,
				},
				["targettarget"] = {
					["layout"] = "Target of Target",
					["position_x"] = 133.3003973908576,
					["position_y"] = -424.2689687413083,
				},
				["player"] = {
					["position_x"] = -356.8672911905637,
					["position_y"] = -560.7693051778615,
				},
				["focus"] = {
					["layout"] = "Focus",
					["position_x"] = 655.0146871618017,
					["position_y"] = 509.5384717465342,
				},
				["target"] = {
					["layout"] = "Target",
					["position_x"] = -119.2715685070646,
					["position_y"] = -424.2425177220493,
				},
				["pet"] = {
					["position_x"] = 496.98384633611,
					["position_y"] = -286.5225868663857,
				},
				["focustargettarget"] = {
					["enabled"] = false,
				},
				["pettarget"] = {
					["position_x"] = 716.3079246711072,
					["position_y"] = -288.0000652278536,
				},
			},
			["minimap_icon"] = {
				["hide"] = true,
			},
			["lock_movement"] = true,
			["groups"] = {
				["Party pets"] = {
					["exists"] = true,
					["unit_group"] = "partypet",
				},
			},
			["colors"] = {
				["reaction"] = {
					["civilian"] = {
						0.1882352941176471, -- [1]
						0.4431372549019608, -- [2]
					},
				},
			},
			["frame_snap"] = false,
		},
		["Lihte-DPS"] = {
			["colors"] = {
				["reaction"] = {
					["civilian"] = {
						0.1882352941176471, -- [1]
						0.4431372549019608, -- [2]
					},
				},
			},
			["groups"] = {
				["Party pets"] = {
					["exists"] = true,
					["unit_group"] = "partypet",
				},
			},
			["class_order"] = {
				"WARRIOR", -- [1]
				"DEATHKNIGHT", -- [2]
				"PALADIN", -- [3]
				"PRIEST", -- [4]
				"SHAMAN", -- [5]
				"DRUID", -- [6]
				"ROGUE", -- [7]
				"MAGE", -- [8]
				"WARLOCK", -- [9]
				"HUNTER", -- [10]
				"MONK", -- [11]
			},
			["layouts"] = {
				["Normal"] = {
					["font_size"] = 0.75,
					["font"] = "DorisPP",
					["bar_padding"] = 1,
					["bar_spacing"] = 0,
					["exists"] = true,
					["bar_texture"] = "Smooth",
				},
				["Focus"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "SCT Emblem",
					["exists"] = true,
					["size_y"] = 25,
					["bar_texture"] = "Glamour2",
				},
				["Target"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "DorisPP",
					["size_x"] = 250,
					["exists"] = true,
					["bar_texture"] = "Fourths",
				},
				["Target of Target"] = {
					["font_size"] = 2,
					["font"] = "DorisPP",
					["size_x"] = 250,
					["exists"] = true,
					["bar_texture"] = "Smooth",
				},
				["Focus Target"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "SCT Emblem",
					["size_x"] = 145,
					["size_y"] = 25,
					["exists"] = true,
					["bar_texture"] = "Glamour2",
				},
			},
			["minimap_icon"] = {
				["hide"] = true,
			},
			["made_groups"] = true,
			["units"] = {
				["targettargettarget"] = {
					["enabled"] = false,
				},
				["focustarget"] = {
					["layout"] = "Focus Target",
					["position_x"] = 680.8621193527738,
					["position_y"] = 460.7997876720904,
				},
				["targettarget"] = {
					["layout"] = "Target of Target",
					["position_x"] = 133.3003973908576,
					["position_y"] = -424.2689687413083,
				},
				["player"] = {
					["position_x"] = -356.8672911905637,
					["position_y"] = -560.7693051778615,
				},
				["focus"] = {
					["layout"] = "Focus",
					["position_x"] = 655.0146871618017,
					["position_y"] = 509.5384717465342,
				},
				["target"] = {
					["layout"] = "Target",
					["position_x"] = -119.2715685070646,
					["position_y"] = -424.2425177220493,
				},
				["pettarget"] = {
					["position_x"] = 716.3079246711072,
					["position_y"] = -288.0000652278536,
				},
				["focustargettarget"] = {
					["enabled"] = false,
				},
				["pet"] = {
					["position_x"] = 743.7041625976563,
					["position_y"] = -175.9750671386719,
				},
			},
		},
		["Gitt Tank"] = {
			["units"] = {
				["targettargettarget"] = {
					["enabled"] = false,
				},
				["focustarget"] = {
					["layout"] = "Focus Target",
					["position_x"] = 338.8618774414063,
					["position_y"] = 512.5497436523438,
				},
				["targettarget"] = {
					["position_x"] = 141.7502091317062,
					["position_y"] = -424.0002004808823,
					["size_y"] = 0.550000011920929,
					["size_x"] = 1.400000095367432,
					["layout"] = "Target of Target",
				},
				["player"] = {
					["position_x"] = -353.8671875,
					["position_y"] = -425.0190124511719,
				},
				["focus"] = {
					["layout"] = "Focus",
					["position_x"] = 313.7644653320313,
					["position_y"] = 559.7885131835938,
				},
				["target"] = {
					["layout"] = "Target",
					["position_x"] = -119.2715685070646,
					["position_y"] = -424.2425177220493,
				},
				["pettarget"] = {
					["position_x"] = 716.3079246711072,
					["position_y"] = -288.0000652278536,
				},
				["focustargettarget"] = {
					["enabled"] = false,
				},
				["pet"] = {
					["position_x"] = 496.98384633611,
					["position_y"] = -286.5225868663857,
				},
			},
			["colors"] = {
				["reaction"] = {
					["civilian"] = {
						0.1882352941176471, -- [1]
						0.4431372549019608, -- [2]
					},
				},
			},
			["groups"] = {
				["Party pets"] = {
					["exists"] = true,
					["unit_group"] = "partypet",
				},
			},
			["class_order"] = {
				"WARRIOR", -- [1]
				"DEATHKNIGHT", -- [2]
				"PALADIN", -- [3]
				"PRIEST", -- [4]
				"SHAMAN", -- [5]
				"DRUID", -- [6]
				"ROGUE", -- [7]
				"MAGE", -- [8]
				"WARLOCK", -- [9]
				"HUNTER", -- [10]
				"MONK", -- [11]
			},
			["layouts"] = {
				["Normal"] = {
					["font_size"] = 0.75,
					["font"] = "DorisPP",
					["bar_padding"] = 1,
					["bar_spacing"] = 0,
					["exists"] = true,
					["bar_texture"] = "Smooth",
				},
				["Focus"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "DorisPP",
					["exists"] = true,
					["size_y"] = 40,
					["bar_texture"] = "Glamour2",
				},
				["Target"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "DorisPP",
					["size_x"] = 250,
					["exists"] = true,
					["bar_texture"] = "Fourths",
				},
				["Focus Target"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "DorisPP",
					["size_x"] = 145,
					["size_y"] = 25,
					["exists"] = true,
					["bar_texture"] = "Smooth",
				},
				["Target of Target"] = {
					["font_size"] = 2,
					["font"] = "DorisPP",
					["size_x"] = 195,
					["scale"] = 0.8999999761581421,
					["size_y"] = 120,
					["exists"] = true,
					["bar_texture"] = "Smooth",
				},
				["Ragebar"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "DorisPP",
					["size_x"] = 250,
					["exists"] = true,
					["bar_texture"] = "Fourths",
				},
			},
			["minimap_icon"] = {
				["hide"] = true,
			},
			["made_groups"] = true,
			["frame_snap"] = false,
		},
		["Giit tank"] = {
			["class_order"] = {
				"WARRIOR", -- [1]
				"DEATHKNIGHT", -- [2]
				"PALADIN", -- [3]
				"PRIEST", -- [4]
				"SHAMAN", -- [5]
				"DRUID", -- [6]
				"ROGUE", -- [7]
				"MAGE", -- [8]
				"WARLOCK", -- [9]
				"HUNTER", -- [10]
				"MONK", -- [11]
			},
			["layouts"] = {
				["Normal"] = {
					["font_size"] = 0.75,
					["font"] = "DorisPP",
					["bar_padding"] = 1,
					["bar_spacing"] = 0,
					["exists"] = true,
					["bar_texture"] = "Smooth",
				},
				["Focus"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "SCT Emblem",
					["exists"] = true,
					["size_y"] = 25,
					["bar_texture"] = "Glamour2",
				},
				["Target"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "DorisPP",
					["size_x"] = 250,
					["exists"] = true,
					["bar_texture"] = "Fourths",
				},
				["Target of Target"] = {
					["font_size"] = 2,
					["font"] = "DorisPP",
					["size_x"] = 250,
					["exists"] = true,
					["bar_texture"] = "Smooth",
				},
				["Focus Target"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "SCT Emblem",
					["size_x"] = 145,
					["size_y"] = 25,
					["exists"] = true,
					["bar_texture"] = "Glamour2",
				},
			},
			["lock_movement"] = true,
			["units"] = {
				["targettargettarget"] = {
					["enabled"] = false,
				},
				["focustarget"] = {
					["layout"] = "Focus Target",
					["position_x"] = 680.8621193527738,
					["position_y"] = 460.7997876720904,
				},
				["targettarget"] = {
					["layout"] = "Target of Target",
					["position_x"] = 133.3003973908576,
					["position_y"] = -424.2689687413083,
				},
				["player"] = {
					["position_x"] = -356.8672911905637,
					["position_y"] = -560.7693051778615,
				},
				["focus"] = {
					["layout"] = "Focus",
					["position_x"] = 655.0146871618017,
					["position_y"] = 509.5384717465342,
				},
				["target"] = {
					["layout"] = "Target",
					["position_x"] = -119.2715685070646,
					["position_y"] = -424.2425177220493,
				},
				["pettarget"] = {
					["position_x"] = 716.3079246711072,
					["position_y"] = -288.0000652278536,
				},
				["focustargettarget"] = {
					["enabled"] = false,
				},
				["pet"] = {
					["position_x"] = 496.98384633611,
					["position_y"] = -286.5225868663857,
				},
			},
			["colors"] = {
				["reaction"] = {
					["civilian"] = {
						0.1882352941176471, -- [1]
						0.4431372549019608, -- [2]
					},
				},
			},
			["minimap_icon"] = {
				["hide"] = true,
			},
			["groups"] = {
				["Party pets"] = {
					["exists"] = true,
					["unit_group"] = "partypet",
				},
			},
			["made_groups"] = true,
			["frame_snap"] = false,
		},
		["Giit -Tank"] = {
			["class_order"] = {
				"WARRIOR", -- [1]
				"DEATHKNIGHT", -- [2]
				"PALADIN", -- [3]
				"PRIEST", -- [4]
				"SHAMAN", -- [5]
				"DRUID", -- [6]
				"ROGUE", -- [7]
				"MAGE", -- [8]
				"WARLOCK", -- [9]
				"HUNTER", -- [10]
				"MONK", -- [11]
			},
			["layouts"] = {
				["Normal"] = {
					["font_size"] = 0.75,
					["font"] = "DorisPP",
					["bar_padding"] = 1,
					["bar_spacing"] = 0,
					["exists"] = true,
					["bar_texture"] = "Smooth",
				},
				["Focus"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "SCT Emblem",
					["exists"] = true,
					["size_y"] = 25,
					["bar_texture"] = "Glamour2",
				},
				["Target"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "DorisPP",
					["size_x"] = 250,
					["exists"] = true,
					["bar_texture"] = "Fourths",
				},
				["Target of Target"] = {
					["font_size"] = 2,
					["font"] = "DorisPP",
					["size_x"] = 250,
					["exists"] = true,
					["bar_texture"] = "Smooth",
				},
				["Focus Target"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "SCT Emblem",
					["size_x"] = 145,
					["size_y"] = 25,
					["exists"] = true,
					["bar_texture"] = "Glamour2",
				},
			},
			["lock_movement"] = true,
			["units"] = {
				["targettargettarget"] = {
					["enabled"] = false,
				},
				["focustarget"] = {
					["layout"] = "Focus Target",
					["position_x"] = 680.8621193527738,
					["position_y"] = 460.7997876720904,
				},
				["targettarget"] = {
					["layout"] = "Target of Target",
					["position_x"] = 133.3003973908576,
					["position_y"] = -424.2689687413083,
				},
				["player"] = {
					["position_x"] = -356.8672911905637,
					["position_y"] = -560.7693051778615,
				},
				["focus"] = {
					["layout"] = "Focus",
					["position_x"] = 655.0146871618017,
					["position_y"] = 509.5384717465342,
				},
				["target"] = {
					["layout"] = "Target",
					["position_x"] = -119.2715685070646,
					["position_y"] = -424.2425177220493,
				},
				["pettarget"] = {
					["position_x"] = 716.3079246711072,
					["position_y"] = -288.0000652278536,
				},
				["focustargettarget"] = {
					["enabled"] = false,
				},
				["pet"] = {
					["position_x"] = 496.98384633611,
					["position_y"] = -286.5225868663857,
				},
			},
			["colors"] = {
				["reaction"] = {
					["civilian"] = {
						0.1882352941176471, -- [1]
						0.4431372549019608, -- [2]
					},
				},
			},
			["minimap_icon"] = {
				["hide"] = true,
			},
			["groups"] = {
				["Party pets"] = {
					["exists"] = true,
					["unit_group"] = "partypet",
				},
			},
			["made_groups"] = true,
			["frame_snap"] = false,
		},
		["Default"] = {
			["class_order"] = {
				"WARRIOR", -- [1]
				"DEATHKNIGHT", -- [2]
				"PALADIN", -- [3]
				"PRIEST", -- [4]
				"SHAMAN", -- [5]
				"DRUID", -- [6]
				"ROGUE", -- [7]
				"MAGE", -- [8]
				"WARLOCK", -- [9]
				"HUNTER", -- [10]
				"MONK", -- [11]
			},
			["layouts"] = {
				["Normal"] = {
					["bar_spacing"] = 0,
					["bar_padding"] = 1,
					["font_size"] = 0.75,
					["font"] = "DorisPP",
					["exists"] = true,
					["bar_texture"] = "Smooth",
				},
				["Focus"] = {
					["size_y"] = 40,
					["font_size"] = 0.699999988079071,
					["font"] = "DorisPP",
					["exists"] = true,
					["bar_texture"] = "Glamour2",
				},
				["Target"] = {
					["size_x"] = 250,
					["font_size"] = 0.699999988079071,
					["font"] = "DorisPP",
					["exists"] = true,
					["bar_texture"] = "Fourths",
				},
				["Focus Target"] = {
					["size_x"] = 145,
					["size_y"] = 25,
					["font_size"] = 0.699999988079071,
					["font"] = "DorisPP",
					["exists"] = true,
					["bar_texture"] = "Smooth",
				},
				["Target of Target"] = {
					["size_x"] = 195,
					["size_y"] = 120,
					["font_size"] = 2,
					["font"] = "DorisPP",
					["exists"] = true,
					["scale"] = 0.8999999761581421,
					["bar_texture"] = "Smooth",
				},
				["Ragebar"] = {
					["size_x"] = 250,
					["font_size"] = 0.699999988079071,
					["font"] = "DorisPP",
					["exists"] = true,
					["bar_texture"] = "Fourths",
				},
			},
			["made_groups"] = true,
			["units"] = {
				["targettargettarget"] = {
					["enabled"] = false,
				},
				["focustarget"] = {
					["position_x"] = 338.8618774414063,
					["position_y"] = 512.5497436523438,
					["layout"] = "Focus Target",
				},
				["targettarget"] = {
					["position_x"] = 141.7502091317062,
					["size_y"] = 0.550000011920929,
					["position_y"] = -424.0002004808823,
					["layout"] = "Target of Target",
					["size_x"] = 1.400000095367432,
				},
				["player"] = {
					["position_x"] = -353.8671875,
					["position_y"] = -425.0190124511719,
				},
				["focus"] = {
					["position_x"] = 313.7644653320313,
					["position_y"] = 559.7885131835938,
					["layout"] = "Focus",
				},
				["target"] = {
					["position_x"] = -119.2715685070646,
					["position_y"] = -424.2425177220493,
					["layout"] = "Target",
				},
				["pet"] = {
					["position_x"] = 496.98384633611,
					["position_y"] = -286.5225868663857,
				},
				["focustargettarget"] = {
					["enabled"] = false,
				},
				["pettarget"] = {
					["position_x"] = 716.3079246711072,
					["position_y"] = -288.0000652278536,
				},
			},
			["groups"] = {
				["Party pets"] = {
					["unit_group"] = "partypet",
					["exists"] = true,
				},
			},
			["colors"] = {
				["reaction"] = {
					["civilian"] = {
						0.1882352941176471, -- [1]
						0.4431372549019608, -- [2]
					},
				},
			},
			["minimap_icon"] = {
				["hide"] = true,
			},
			["frame_snap"] = false,
		},
		["Ezyn Tank"] = {
			["class_order"] = {
				"WARRIOR", -- [1]
				"DEATHKNIGHT", -- [2]
				"PALADIN", -- [3]
				"PRIEST", -- [4]
				"SHAMAN", -- [5]
				"DRUID", -- [6]
				"ROGUE", -- [7]
				"MAGE", -- [8]
				"WARLOCK", -- [9]
				"HUNTER", -- [10]
			},
			["layouts"] = {
				["Normal"] = {
					["font_size"] = 0.75,
					["font"] = "DorisPP",
					["bar_padding"] = 1,
					["bar_spacing"] = 0,
					["exists"] = true,
					["bar_texture"] = "Smooth",
				},
				["Focus"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "SCT Emblem",
					["exists"] = true,
					["size_y"] = 25,
					["bar_texture"] = "Glamour2",
				},
				["Target"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "DorisPP",
					["size_x"] = 250,
					["exists"] = true,
					["bar_texture"] = "Fourths",
				},
				["Target of Target"] = {
					["font_size"] = 2,
					["font"] = "DorisPP",
					["size_x"] = 250,
					["exists"] = true,
					["bar_texture"] = "Smooth",
				},
				["Focus Target"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "SCT Emblem",
					["size_x"] = 145,
					["size_y"] = 25,
					["exists"] = true,
					["bar_texture"] = "Glamour2",
				},
			},
			["lock_movement"] = true,
			["units"] = {
				["targettargettarget"] = {
					["enabled"] = false,
				},
				["focustarget"] = {
					["layout"] = "Focus Target",
					["position_x"] = 680.8621193527738,
					["position_y"] = 460.7997876720904,
				},
				["targettarget"] = {
					["layout"] = "Target of Target",
					["position_x"] = 133.3003973908576,
					["position_y"] = -424.2689687413083,
				},
				["player"] = {
					["position_x"] = -356.8672911905637,
					["position_y"] = -560.7693051778615,
				},
				["focus"] = {
					["layout"] = "Focus",
					["position_x"] = 655.0146871618017,
					["position_y"] = 509.5384717465342,
				},
				["target"] = {
					["layout"] = "Target",
					["position_x"] = -119.2715685070646,
					["position_y"] = -424.2425177220493,
				},
				["pettarget"] = {
					["position_x"] = 716.3079246711072,
					["position_y"] = -288.0000652278536,
				},
				["focustargettarget"] = {
					["enabled"] = false,
				},
				["pet"] = {
					["position_x"] = 496.98384633611,
					["position_y"] = -286.5225868663857,
				},
			},
			["colors"] = {
				["reaction"] = {
					["civilian"] = {
						0.1882352941176471, -- [1]
						0.4431372549019608, -- [2]
					},
				},
			},
			["minimap_icon"] = {
				["hide"] = true,
			},
			["groups"] = {
				["Party pets"] = {
					["exists"] = true,
					["unit_group"] = "partypet",
				},
			},
			["made_groups"] = true,
			["frame_snap"] = false,
		},
		["Evyyn - Azuremyst"] = {
			["units"] = {
				["targettargettarget"] = {
					["enabled"] = false,
				},
				["focustarget"] = {
					["layout"] = "Focus Target",
					["position_x"] = 682.339057897522,
					["position_y"] = 483.6921191890015,
				},
				["targettarget"] = {
					["layout"] = "Target of Target",
					["position_x"] = 342.3328339794382,
					["position_y"] = -446.7050651607279,
				},
				["player"] = {
					["position_x"] = -119.4142960477193,
					["position_y"] = -404.9538946616554,
				},
				["focus"] = {
					["layout"] = "Focus",
					["position_x"] = 655.0146871618017,
					["position_y"] = 509.5384717465342,
				},
				["target"] = {
					["layout"] = "Target",
					["position_x"] = 138.1177937718785,
					["position_y"] = -403.8482060688473,
				},
				["pet"] = {
					["position_x"] = 540.5531015528095,
					["position_y"] = -208.2459596159457,
				},
				["focustargettarget"] = {
					["enabled"] = false,
				},
				["pettarget"] = {
					["position_x"] = 750.2770793469426,
					["position_y"] = -243.692232775436,
				},
			},
			["groups"] = {
				["Party pets"] = {
					["exists"] = true,
					["unit_group"] = "partypet",
				},
			},
			["class_order"] = {
				"WARRIOR", -- [1]
				"DEATHKNIGHT", -- [2]
				"PALADIN", -- [3]
				"PRIEST", -- [4]
				"SHAMAN", -- [5]
				"DRUID", -- [6]
				"ROGUE", -- [7]
				"MAGE", -- [8]
				"WARLOCK", -- [9]
				"HUNTER", -- [10]
				"MONK", -- [11]
			},
			["layouts"] = {
				["Normal"] = {
					["font_size"] = 0.75,
					["font"] = "SCT Emblem",
					["size_x"] = 250,
					["exists"] = true,
					["bar_texture"] = "Glamour",
				},
				["Focus"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "SCT Emblem",
					["exists"] = true,
					["size_y"] = 25,
					["bar_texture"] = "Glamour2",
				},
				["Target"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "SCT Emblem",
					["size_x"] = 250,
					["exists"] = true,
					["bar_texture"] = "Glamour",
				},
				["Target of Target"] = {
					["font_size"] = 2,
					["font"] = "SCT Emblem",
					["size_x"] = 250,
					["scale"] = 0.5,
					["exists"] = true,
					["bar_texture"] = "Glamour2",
				},
				["Focus Target"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "SCT Emblem",
					["size_x"] = 145,
					["size_y"] = 25,
					["exists"] = true,
					["bar_texture"] = "Glamour2",
				},
			},
			["minimap_icon"] = {
				["hide"] = true,
			},
			["made_groups"] = true,
			["frame_snap"] = false,
		},
		["Git - Tanl"] = {
			["class_order"] = {
				"WARRIOR", -- [1]
				"DEATHKNIGHT", -- [2]
				"PALADIN", -- [3]
				"PRIEST", -- [4]
				"SHAMAN", -- [5]
				"DRUID", -- [6]
				"ROGUE", -- [7]
				"MAGE", -- [8]
				"WARLOCK", -- [9]
				"HUNTER", -- [10]
			},
			["layouts"] = {
				["Normal"] = {
					["font_size"] = 0.75,
					["font"] = "DorisPP",
					["bar_padding"] = 1,
					["bar_spacing"] = 0,
					["exists"] = true,
					["bar_texture"] = "Smooth",
				},
				["Focus"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "SCT Emblem",
					["exists"] = true,
					["size_y"] = 25,
					["bar_texture"] = "Glamour2",
				},
				["Target"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "DorisPP",
					["size_x"] = 250,
					["exists"] = true,
					["bar_texture"] = "Fourths",
				},
				["Target of Target"] = {
					["font_size"] = 2,
					["font"] = "DorisPP",
					["size_x"] = 250,
					["exists"] = true,
					["bar_texture"] = "Smooth",
				},
				["Focus Target"] = {
					["font_size"] = 0.699999988079071,
					["font"] = "SCT Emblem",
					["size_x"] = 145,
					["size_y"] = 25,
					["exists"] = true,
					["bar_texture"] = "Glamour2",
				},
			},
			["lock_movement"] = true,
			["units"] = {
				["targettargettarget"] = {
					["enabled"] = false,
				},
				["focustarget"] = {
					["layout"] = "Focus Target",
					["position_x"] = 680.8621193527738,
					["position_y"] = 460.7997876720904,
				},
				["targettarget"] = {
					["layout"] = "Target of Target",
					["position_x"] = 133.3003973908576,
					["position_y"] = -424.2689687413083,
				},
				["player"] = {
					["position_x"] = -356.8672911905637,
					["position_y"] = -560.7693051778615,
				},
				["focus"] = {
					["layout"] = "Focus",
					["position_x"] = 655.0146871618017,
					["position_y"] = 509.5384717465342,
				},
				["target"] = {
					["layout"] = "Target",
					["position_x"] = -119.2715685070646,
					["position_y"] = -424.2425177220493,
				},
				["pettarget"] = {
					["position_x"] = 716.3079246711072,
					["position_y"] = -288.0000652278536,
				},
				["focustargettarget"] = {
					["enabled"] = false,
				},
				["pet"] = {
					["position_x"] = 496.98384633611,
					["position_y"] = -286.5225868663857,
				},
			},
			["minimap_icon"] = {
				["hide"] = true,
			},
			["colors"] = {
				["reaction"] = {
					["civilian"] = {
						0.1882352941176471, -- [1]
						0.4431372549019608, -- [2]
					},
				},
			},
			["groups"] = {
				["Party pets"] = {
					["exists"] = true,
					["unit_group"] = "partypet",
				},
			},
			["made_groups"] = true,
			["frame_snap"] = false,
		},
	},
}
