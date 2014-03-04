local L = LibStub("AceLocale-3.0"):NewLocale("EnsidiaFails", "enUS", true)

--- Addon Description and Options ----
L["addon_desc"] = "EnsidiaFails is an addon that reports if a player in the raid fails to avoid an ability during a boss encoutner, that could have been avoided.\n"

L["filter"] = "Filter"
L["filter_desc"] = "Tick in the fails you want to track! If a fail doesn't have a tick next to its name, that fail won't be tracked or announced!"
L["general"] = "General"

L["Top X Stats"] = "Top X Stats"
L["Amount of entries to display"] = "Amount of entries to display"
L["Show all"] = "Show all"

L["reset"] = "Reset"
L["reset_desc"] = "Reset the fail counter"
L["oreset"] = "Reset Overall"
L["oreset_desc"] = "Reset the overall fail counter"

L["announce"] = "Announce to"
L["announce_desc"] = "Set Announce output"
L["announce_style"] = "Announce style"
L["announce_style_desc"] = "When to report fails"
L["announce_after_style"] = "Announce after style"
L["announce_after_style_desc"] = "How should the fail report look after combat"
L["Disabled"] = "Disabled"
L["stats"] = "Stats"
L["stats_desc"] = "Report Stats"
L["ostats"] = "Overall Stats"
L["ostats_desc"] = "Report Overall Stats"

L["Say"] = "Say"
L["Party"] = "Party"
L["Raid"] = "Raid"
L["Guild"] = "Guild"
L["Officer"] = "Officer"
L["Channel"] = "Channel"
L["Self"] = "Self"

L["during"] = "During combat"
L["after"] = "After combat"
L["during_and_after"] = "During and after combat"

L["Group by player"] = "Group by player"
L["Group by fails"] = "Group by fails"

L["remove"] = "Remove a Fail"
L["remove_desc"] = "Remove a fail from the player"
L["Wrong name!"] = "Wrong name!"

L["Reset EnsidiaFails?"] = "Reset EnsidiaFails?"
L["Reset Data?"] = "Reset Data?"
L["Yes"] = "Yes"
L["No"] = "No"

L["Auto Delete New Instance"] = "Auto Delete New Instance"
L["Delete New Instance Only"] = "Delete New Instance Only"
L["Confirm Delete Instance"] = "Confirm Delete Instance"
L["Delete on Raid Join"] = "Delete on Raid Join"
L["Confirm Delete on Raid Join"] = "Confirm Delete on Raid Join"

L["Disable announce override"] = "Disable announce override"
L["Announcing Disabled! %s is the main announcer. (He/She has the same version as you (%s))"] = "Announcing Disabled! %s is the main announcer. (He/She has the same version as you (%s))"
L["Disallows accepting commands from other users that'd change the announcing settings"] = "Disallows accepting commands from other users that'd change the announcing settings"
L["Announcing Enabled! YOU are the main announcer for EnsidiaFails, please check your announcing settings"] = "Announcing Enabled! YOU are the main announcer for EnsidiaFails, please check your announcing settings"
L["Announcing Disabled! %s is the main announcer. (Please consider updating your addon his/her version was %s)(yours: %s)"] = "Announcing Disabled! %s is the main announcer. (Please consider updating your addon his/her version was %s)(yours: %s)"

L["Only report overkills"] = "Only report overkills"
L["Only report overkills in LFR"] = "Only report overkills in LFR"

---------------------------------------

--- Fail Reporting ---
L["susped"] = "Fail reporting suspended for 60 seconds."
L["resume"] = "Fail reporting resumed."
L["removed"] = "Removed a fail from "
L["reseted"] = "Fail counter reset."
L["oreseted"] = "Overall fail counter reset."

L["nobody_failed"] = "EnsidiaFails - Nobody failed!"

L["we_have"] = "EnsidiaFails - We have "
L["fails_on"] = " FAILS on "
L["diff%..."] = " different players! Displaying the TOP %s..."

L["admiral"] = "Admiral of the FAILFLEET is: "
L["captain"] = "Captain of the FAILBOAT is: "

L["failed"] = " failed "

L["didnt_fail"] = "Players who did not fail: "
