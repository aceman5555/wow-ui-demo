local L = LibStub("AceLocale-3.0"):NewLocale("Utopia", "enUS", true)
if not L then return end

L["TITLE"]									= "Utopia"
L["HINT"]									= "|cffeda55fClick|r to toggle Utopia. |cffeda55fRight-Click|r for options."
L["HINTUPTIME"]								= "|cffeda55fCtrl-Click|r to open UpTime window."
L["Configuration"]							= true
L["Standalone Config"]						= true
L["Open a standalone config window. You might consider installing |cffffff00BetterBlizzOptions|r to make the Blizzard UI options panel resizable."] = true
L["Enable"]									= true
L["Enable target debuff status display"]	= true
L["Display"]								= true
L["Display settings"]						= true
L["Icons"]									= true
L["Display options for the icons"]			= true
L["Bar"]									= true
L["Display options for the status bar"]		= true
L["Enable the status bar"]					= true
L["Icon Size"]								= true
L["Set the size of the icons"]				= true
L["Scale"]									= true
L["Set the scale of the icons"]				= true
L["Locked"]									= true
L["Toggle locked position. When unlocked, you can move the display with the bar"] = true
L["Popup Toggle"]							= true
L["Select the position for the popup toggle button"] = true
L["Top"]									= true
L["Bottom"]									= true
L["Always Show"]							= true
L["Always show the bar"]					= true
L["Active Colour"]							= true
L["Set the colour for debuffs which your group has applied."] = true
L["Inactive Colour"]						= true
L["Set the colour for debuffs which your group is able to apply, but has not done so."] = true
L["Partial Colour"]							= true
L["Set the colour for auras which someone has applied, but it is an unimproved version of the spell."] = true
L["Unavailable Colour"]						= true
L["Set the colour for debuffs which your group is not able to apply."] = true
L["Excluded Colour"]						= true
L["Set the colour for debuffs which your group is able to apply, but another spell is excluding it."] = true
L["Temporary Colour"]						= true
L["Set the colour for debuffs which your group is able to apply, but usually only during combat. They're expected to not be active when idle."] = true
L["Size"]									= true
L["Colour"]									= true
L["Bar"]									= true
L["Bar Texture"]							= true
L["Set the texture for the bar"]			= true
L["Show When"]								= true
L["With What"]								= true
L["Set rules for what to show Utopia with"] = true
L["Show If"]								= true
L["Only if these conditions are met"]		= true
L["Set rules for when to show Utopia"]		= true
L["Show when solo"]							= true
L["Show when in a party"]					= true
L["Show when in a raid"]					= true
L["Enemy"]									= true
L["Only show when targetting a hostile unit"] = true
L["Bosses"]									= true
L["Only show when targetting boss mobs"]	= true
L["In-Combat"]								= true
L["Show when in combat"]					= true
L["Out-of-Combat"]							= true
L["Show when out of combat"]				= true
L["Orientation"]							= true
L["Set the orientation for the display"]	= true
L["Vertical"]								= true
L["Horizontal"]								= true
L["Bar Placement"]							= true
L["Which side to put the bar"]				= true
L["Bottom/Right"]							= true
L["Top/Left"]								= true
L["Width"]									= true
L["Set the width of the status bar"]		= true
L["Buttons"]								= true
L["Horizontal Spacing"]						= true
L["Set the horizontal spacing of the buttons"] = true
L["Vertical Spacing"]						= true
L["Set the vertical spacing of the buttons"] = true
L["Columns"]								= true
L["Set the buttons before breaking to next row/column"] = true
L["Background Options"]						= true
L["Enable the frame background"]			= true
L["Background Texture"]						= true
L["Texture to use for the frame's background"] = true
L["Border Texture"]							= true
L["Texture to use for the frame's border"]	= true
L["Background Colour"]						= true
L["Frame's background colour"]				= true
L["Status Border Colour"]					= true
L["Border colour will reflect the progressive buff/debuff status as the bar indicator does."] = true
L["Border Colour"]							= true
L["Frame's border colour"]					= true
L["Tile Background"]						= true
L["Tile the background texture"]			= true
L["Background Tile Size"]					= true
L["The size used to tile the background texture"] = true
L["Border Thickness"]						= true
L["The thickness of the border"]			= true
L["Profiles"]								= true
L["General Settings"]						= true
L["Mode"]									= true
L["Switch mode between |T%s:0|t (Buffs) and |T%s:0|t (Debuffs)"] = true
L["Automatic Toggle"]						= true
L["Switch mode between |T%s:0|t (Automatic Icon Selection) and |T%s:0|t (Manual Icons)"] = true
L["Available Only Toggle"]					= true
L["Switch mode between |T%s:0|t (All Icons) and |T%s:0|t (Only Available Icons)"] = true
L["|cFF00FF00Ready!|r (%s)"]				= true
L["|cFFFF8080Cooldown:|r %s"]				= true
L["%d%% without %s debuff"]					= true
L["Mode Options"]							= true
L["Mode Options"]							= true
L["Auto Mode"]								= true
L["Automatically choose buffs mode out of combat and Debuffs mode in combat"] = true
L["Dual Frames"]							= true
L["Use two frames to display buffs and debuffs simultaniously"] = true
L["All Players"]							= true
L["Targetting players will show their buff status instead of your own"] = true
L["Miscellaneous Options"]					= true
L["Other options"]							= true
L["Tooltip Enhancements"]					= true
L["Improve the information shown in default buff tooltips to reflect the talent enchanced amounts and show extra bonus affects granted."] = true
L["Store Guild Members"]					= true
L["Store last seen guild member talents for faster initial display. Talents are still refreshed when the members are seen. Talents are only stored when you are in a raid, as it's more likely for players to use alternate specs when in a party."] = true
L["Talent Options"]							= true
L["Clear Guild Members"]					= true
L["Clear stored guild member talents."]		= true
L["Only Available"]							= true
L["Only show available icons in the set, hiding all icons your group cannot apply buffs or debuffs for"] = true
L["Tooltip Options"]						= true
L["Options for default values when unavaible"] = true
L["Max Possible"]							= true
L["Unavailable spells are shown as max possible talented value, instead of the untalented base value"] = true
L["Totems are Temporary"]					= true
L["Treat all totem buffs as if they are temporary and not important pre-combat."] = true
L["Warn Losses"]							= true
L["Warn when your raid group loses the ability to apply a buff or debuff. Will also notify you if you quickly regain this aura"] = true
L["Show Respecs"]							= true
L["Show in chat when someone swaps talent sets"] = true
L["Always Standard Buffs"]					= true
L["Always show standard raid buffs (%s, %s, %s) in automatic mode, regardless of other settings"] = true
L["Runescrolls & Drums"]					= true
L["Always show Runescrolls and Drums as available"] = true
L["Hints"]									= true
L["Show hints about click availability on Utopia's icons"] = true

L["  by %s (%s's pet)"]						= true		-- In tooltip "  by Wasp (Zek's pet)"
L["  by %s"]								= true		-- In tooltip "  by Zek"
L["buff"]									= true
L["debuff"]									= true
L["Notifying %s regarding %s"]				= true		-- Notifying [Player Name] regarding [Spell Name]
L["You are missing your own %s %s"]			= true		-- You are missing your own [Blessing of Kings] buff
L["%s is missing your own %s %s"]			= true		-- Targetname is missing your own [Judgement of Wisdom] debuff
L["I am missing your %s %s"]				= true		-- I am missing your [Blessing of Kings] buff
L["%s is missing your %s %s"]				= true		-- Targetname is missing your [Judgement of Wisdom] debuff
L["There is noone to cast |cFFFFFF80%s|r"]	= true
L["Improved"]								= true
L["Not Improved"]							= true
L["Not Glyphed"]							= true
L["This is a rank |cFFFF0000%d|r spell instead of rank |cFFFF0000%d|r which would give you |cFFFFFF80%d %s|r"] = true
L["%s |cFFFFFF80%s|r : %s from %s%s"]		= true		-- -- Critical Strike Change Taken : [Master Poisoner] from Zek (Respec)
L["Respec"]									= true
L["Left raid"]								= true
L["%s changed talent set from |cFFFFFF80%s|r (%d/%d/%d) to |cFFFFFF80%s|r (%d/%d/%d)"] = true
L["%s changed talent set from |cFFFFFF80%s|r to |cFFFFFF80%s|r"] = true
L["%s changed talent set to |cFFFFFF80%s|r"] = true

L["(for %d %s)"]							= true
L["stacks"]									= true
L["combos"]									= true
L["Armor"]									= true
L["Attack Power"]							= true
L["Maximum potential amount for group is %s%s"] = true
L["Maximum possible amount is %s%s"]		= true
L["Not available"]							= true
L["Can apply"]								= true
L["Can apply. Un-improved"]					= true
L["Can apply. Partially improved (|cFFFF8080%d|r of |cFF80FF80%d|r talent points)"] = true
L["Can apply. Improved"]					= true
L["Can apply partially (|cFFFF8080%d|r of |cFF80FF80%d|r talent points)"] = true
L["|cFFFF8080Cannot apply because they have |cFFFFFF80%s|cFFFF8080 active"] = true
L["Talents unscanned"]						= true
L["Cannot apply this debuff"]				= true
L["Cannot apply this buff"]					= true
L["Requires a |cFFFFFF80%s|r pet, currently has a |cFFFFFF80%s|r"] = true
L["%s with |cFFFFFF80%s|r"]					= true
L["%s from %s"]								= true
L["%s from an %s%s"]						= true
L["%s from a %s%s"]							= true
L["%s from an %s%s with |cFFFFFF80%s|r"]	= true
L["%s from a %s%s with |cFFFFFF80%s|r"]		= true
L["Anyone"]									= true
L["%s%s needs to be level %s for this ability"] = true
L["Requires level %s"]						= true
L["Rescan Talents"]							= true
L["Clear talent cache and rescan everyone"]	= true
L["Group size:"]							= true
L["Got Talents for:"]						= true
L["Missing: %s"]							= true
L["Talents %d/%d"]							= true
L["Icon Settings"]							= true
L["Automatic"]								= true
L["Automatically show the buffs relevant for your class"] = true
L["Buffs"]									= true
L["Buff Icon Options"]						= true
L["Debuffs"]								= true
L["Debuff Icon Options"]					= true
L["Available from these sources:"]			= true
L["Icon Options"]							= true
L["Show Cooldown"]							= true
L["Show buff cooldown indication on Utopia icons"] = true
L["Edge Highlight"]							= true
L["Show leading edge on cooldown for clarity"] = true
L["Show Countdown"]							= true
L["Show buff countdown in Utopia icons"]	= true
L["Minimum Duration"]						= true
L["Set minumum time left before the expirey countdown shows"] = true
L["|cFF80FF80Left Click|r for details"]		= true
L["|cFF80FF80Right Click|r to ask %s for %s"] = true
L["|cFF80FF80Shift-Right Click|r to cancel auras"] = true

-- Pets
L["Wasp"]									= true					-- Hunter Wasp Pet
L["Worm"]									= true					-- Hunter Worm Pet
L["Core Hound"]								= true					-- Hunter Core Hound Pet
L["Sporebat"]								= true					-- Hunter Sporebat Pet
L["Bird of Prey"]							= true					-- Hunter Bird pet (Owl)
L["Wolf"]									= true					-- Hunter Wolf Pet
L["Rhino"]									= true					-- Hunter Rhino Pet
L["Devilsaur"]								= true					-- Hunter Devilsaur Pet
L["Silithid"]								= true					-- Hunter bug
L["Cat"]									= true					-- Hunter cat
L["Shale Spider"]							= true					-- Hunter shale spider
L["Raptor"]									= true					-- Hunter raptor
L["Serpent"]								= true					-- Hunter serpent
L["Boar"]									= true					-- Hunter boar
L["Hyena"]									= true					-- Hunter hyena
L["Ravager"]								= true					-- Hunter ravager
L["Fox"]									= true					-- Hunter fox
L["Tallstrider"]							= true					-- Hunter tallstrider
L["Dragonhawk"]								= true					-- Hunter dragonhawk
L["Wind Serpent"]							= true					-- Hunter wind serpent

L["Felhunter"]								= true					-- Warlock Felhunter Pet
L["Imp"]									= true					-- Warlock Imp Pet
L["Felguard"]								= true					-- Warlock Felguard Pet


-- Buffs
L["Strength & Agility"]						= true
L["Attack Power (%)"]						= true
L["Critical Strike Chance"]					= true
L["Damage (%)"]								= true
L["Damage Reduction (%)"]					= true
L["Damage Reduction Physical (%)"]			= true
L["Haste"]									= true
L["Attack Speed"]							= true
L["Spell Haste"]							= true
L["Healing Received"]						= true
L["Health"]									= true
L["Intellect"]								= true
L["Mana Regen"]								= true
L["Replenishment"]							= GetSpellInfo(57669)
L["Spell Power"]							= true
L["Spirit"]									= true
L["Stamina"]								= true
L["Stats"]									= true
L["Spell Pushback Prevention"]				= true


-- Buffs Info Mode
L["Str & Agi"]								= true
--L["Armor"]								= true
L["AP"]										= true
L["Crit"]									= true
--L["Melee Crit"]								= true
--L["Spell Crit"]								= true
L["Damage Modifier"]						= true
L["Damage"]									= true			-- Short version of above
L["Damage Reduction"]						= true
L["Physical Damage Reduction"]				= true
L["Reduction"]								= true			-- Short version of above
L["Haste"]									= true
L["Healing"]								= true
L["Health"]									= true
L["Mana"]									= true
L["Spell Power"]							= true
L["Spirit"]									= true
L["Health"]									= true
L["Stats"]									= true
L["mp5"]									= true
L["Resists"]								= true
L["Resistance"]								= true
L["Pushback"]								= true

-- Buff Descriptions
L["DESC.buffs.Armor"]						= "Increases the Armor of the player by the specified amount."
L["DESC.buffs.Attack Power"]				= "Increases the Attack Power of the player by the specified amount."
L["DESC.buffs.Bloodlust/Heroism"]			= "Greatly Increase the Attack and Cast Speed of all players in the group for a short time."
L["DESC.buffs.Critical Strike Chance"]		= "Increase the Critical Strike Chance of the player by the specified percentage."
L["DESC.buffs.Damage (%)"]					= "Increases the damage of the player by the specified percentage."
L["DESC.buffs.Damage Reduction (%)"]		= "Reduces the damage taken of the player by the specified percentage."
L["DESC.buffs.Damage Reduction Physical (%)"] = "Reduces the physical damage taken of the player by the specified percentage."
L["DESC.buffs.Haste"]						= "Increases the Haste of the player by the specified percentage."
L["DESC.buffs.Attack Speed"]				= "Increases the Attack Speed of the player by the specified percentage."
L["DESC.buffs.Spell Haste"]					= "Increases the Spell Haste of the player by the specified percentage."
L["DESC.buffs.Healing Received"]			= "Increases the Healing Received of the player by the specified amount."
L["DESC.buffs.Health"]						= "Increases the Health of the player by the specified amount."
L["DESC.buffs.Mana"]						= "Increases the Mana of the player by the specified amount."
L["DESC.buffs.Mana Regen"]					= "Increases the Mana Regen of the player by the specified amount."
L["DESC.buffs.Replenishment"]				= "Restores percentage of maximum mana to players over time."
L["DESC.buffs.Spell Power"]					= "Increases the Spell Power of the player by the specified amount."
L["DESC.buffs.Spirit"]						= "Increases the Spirit of the player by the specified amount."
L["DESC.buffs.Stamina"]						= "Increases the Stamina of the player by the specified amount."
L["DESC.buffs.Stats"]						= "Increases the Stats of the player by the specified amount."
L["DESC.buffs.Strength & Agility"]			= "Increases the Strength and Agility of the player by the specified amount."
L["DESC.buffs.Resistance"]					= "Increases magical resistances by the specified amount."
L["DESC.buffs.Spell Pushback Prevention"]	= "Descreases the spell pushback suffered by the specified amount."

-- Debuffs
L["Attack Power"]							= true
L["Bleed Damage"]							= true
L["Cast Speed Slow"]						= true
L["Critical Strike Chance Taken"]			= true
L["Healing Taken"]							= true
L["Health Restore"]							= true
L["Mana Restore"]							= true
L["Melee Attack Speed Slow"]				= true
L["Physical Vulnerability"]					= true
L["Physical Damage"]						= true
L["Spell Critical Strike Chance"]			= true
L["Spell Damage Taken"]						= true
L["Damage Done (Physical)"]					= true

-- Debuff Descriptions
L["DESC.debuffs.Armor"]							= "Decreases the armor of the target by the specified amount."
L["DESC.debuffs.Attack Power"]					= "Decreases the Attack Power of the target by the specified amount."
L["DESC.debuffs.Bleed Damage"]					= "Increases the damage done by bleed affects by the specified percentage."
L["DESC.debuffs.Cast Speed Slow"]				= "Decreases the cast speed of the target by specified percentage."
L["DESC.debuffs.Critical Strike Chance Taken"]	= "Increases the Critical Strike of all attacks made against the target."
L["DESC.debuffs.Healing Taken"]					= "Decreases the healing received by the target by the specified percentage."
L["DESC.debuffs.Melee Attack Speed Slow"]		= "Increases the time between attacks of the target by the specified amount."
L["DESC.debuffs.Physical Vulnerability"]		= "Increases physical damage done to the target by the specified amount."
L["DESC.debuffs.Spell Critical Strike Chance"]	= "Increases the critical strike chance of spells cast on the target by the specified amount."
L["DESC.debuffs.Spell Damage Taken"]			= "Increases the damage of spells against the target by the specified amount."
L["DESC.debuffs.Damage Done (Physical)"]		= "Decreases the physical damage done by the target."

L["Enable "]									= true
L["Module"]										= true
L["Modules"]									= true
L["Enabled"]									= true
L["Disabled"]									= true

-- Details Module
L["Details"]									= true
L["Show enchanced details of available auras, who can cast them and at what levels"] = true

-- Up-Time Module
L["UpTime"]										= "Up-Time"
L["Up-Time"]									= true
L["Records debuff up-time on fights"]			= true
L["Bosses Only"]								= true
L["Only record boss fights"]					= true
L["Notifications"]								= true
L["Display start and end statistics of fights. More to remind you that data is being stored and munching your addon ram up than anything else"] = true
L["Minimum Duration"]							= true
L["Set the minimum duration for a fight to be stored for (last fight is always stored temporarily)"] = true
L["History Size"]								= true
L["How many fights to keep"]					= true
L["Coloured Categories"]						= true
L["Colour the category names to reflect all the class colours applicable (Bring Shades)"] = true
L["Record DPS"]									= true
L["Records DPS during fights. Just the basics; damage done to each mob per second by any source in your group. So you can see how raid debuffs are affecting things"] = true
L["Individual Raid DPS"]						= true
L["Records DPS seperately for each raid member during fights. Simply dmg done in each 1 second window during a fight, with no number crunching until you view it later. This will obviously store a little more data than without"] = true
L["Typed DPS"]									= true
L["Records Physical and Magical DPS seperately for the whole raid"] = true
L["Record Deaths"]								= true
L["Records raid member deaths during fights"]	= true
L["Record Events"]								= true
L["Records significant events during a boss encounter which can be later marked on the chart"] = true
L["Do not automatically purge this fight when it expires past the present age/size limits defined in options"] = true
L["DPS Smoothing will average out the dmg over the given number of seconds to provide a more useful visual representation of the damage output"] = true
L["Recording Options"]							= true
L["Merge Appliers"]								= true
L["Merge appliers of the same spell into a single display texture if they are just swapping application of a debuff. %s for example"] = true
L["Cycle through DPS modes for this fight."]	= true
L["Combined"]									= true
L["Physical"]									= true
L["Magical"]									= true
L[" stacked with "]								= true
L["Heroic"]										= true			-- Purely to display old logs pre-3.2

L["Recorded |cFFFFFF80%s|r (%d secs) - |cFF80FF80%d|r auras %s"] = true
L["You can access |cFFFFFF80UpTime|r at any time with |cFF80FF80Ctrl-Click|r on the LDB or Fubar icon, or with the |cFF80FF80/uptime|r command."] = true
L["View"]										= true
L["Send"]										= true
L["Today"]										= true
L["Yesterday"]									= true
L["%.1f mins"]									= true
L["%d secs"]									= true
L["%s Fight Listing"]							= true
L["By Category"]								= true
L["By Spell"]									= true
L["Names"]										= true
L["DPS"]										= true
L["Enemy DPS"]									= true
L["Deaths"]										= true
L["Events"]										= true
L["Zoom: %d%%"]									= true
L["Keep"]										= true
L["Open"]										= true
L["History Size: %d"]							= true
L["Raid DPS: "]									= true
L["Enemy DPS: "]								= true
L["%s |cFF808080on %s"]							= true			-- Spellname on Mobname
L["%s on %s by %s: %.2f%% Up-Time"]				= true			-- [Spelllink] on Mobname by Playername
L["Improved"]									= true
L["Improved %d/%d"]								= true
L["Partial %d/%d"]								= true
L["Received from %s"]							= true
L["Listing"]									= true
L["%s ressed by %s"]							= true

-- uptime/comms.lua
L["%s wants to send you %d fight debuff |4log:logs;"] = true
L["|cFF80FF80|Hutopia_accept:%s:%s|h[Click here to accept]|h|r"] = true
L["Send the selected fights to:"]				= true
L["%s did not accept within thirty seconds; cancelled"] = true
L["Received from %s: Fight data for |cFFFF0000%s|r %s"] = true
L["Sending to %s: Fight data for |cFFFF0000%s|r"] = true
L["Finished sending"]							= true
L["Send failed; %s is offline"]					= true
L["Send failed; %s is not running Utopia_UpTime"] = true

-- uptime/ignore.lua
L["Ignore Options"]								= true
L["Purge"]										= true
L["Selected Fight"]								= true
L["Currently Ignored"]							= true
L["Ignore the selected mobs"]					= true
L["Remove the selected mobs from the ignored list"] = true
L["Purge all existing fights of the currently defined ignored mobs"] = true
L["Purged from %d |4fight:fights; totalling %d |4mob:mobs;, and a total of %d data |4element:elements;"] = true
L["Really purge all existing fights of all currently ignored mobs? This action is irreversable!"] = true

L["Yogg-Saron"]									= true
L["Mimiron"]									= true
L["Assembly of Iron"]							= true
L["The Four Horsemen"]							= true
L["Faction Champions"]							= true
L["Val'kyr Twins"]								= true
L["Beasts of Northrend"]						= true
L["Gunship Battle"]								= true
L["BOSSPHASE"]									= "Phase %d"

-- update/frames.lua
L["|cFFFFFF80Click|r and drag to |cFFFFFFFFResize|r"] = true
L["|cFFFFFF80Shift-Click|r and drag to |cFFFFFFFFScale|r"] = true
L["Scale: |cFF80FF80%.1f%%|r"]					= true

-- Module Names
L["Filter"]										= true
L["Custom"]										= true
L["CustomConfig"]								= "Custom Icons Config"

-- Custom Icons
L["%s Custom Configuration"]					= true
L["Show Configuration"]							= true
L["Aura Type"]									= true
L["Up"]											= true
L["Down"]										= true
L["Search"]										= true
L["Move the selected spell up"]					= true
L["Move the selected spell down"]				= true
L["Toggle between buff and debuff for the selected spell"] = true
L["Delete the selected spell"]					= true
L["Reload the defaults for this class and spec"] = true
L["Spacer"]										= true
L["Insert a spacer at the current point to seperate the icons"] = true
