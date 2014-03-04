QuestHelper_ChangeLog="|cffffff00       Version ??? ??/??/????|r\
\
• Removed data that appeared to have come from people on private servers.\
• Removed field repair bots from the static data.\
• Routes should be slightly more stable than they were before.\
• Should hopefully not lockup on timed quests.\
• Should again be working properly for German users.\
• Updated translations.\
• Fixed the help command. \
\
|cffffff00       Version 0.47 05/20/2008|r\
\
• Added an in-game copy of the change log, to be displayed when an upgrade is detected.\
• The zone filter has been fixed, and will consider whether any of the known locations for an objective are where the player is or is flying to. Before, only the most probable location was considered.\
• Made some changes to the quest tracker:\
    • The progress for objectives for which only one thing is required is omitted. It's either there or it isn't.\
    • Option to add quest levels to quest names: |cff40bbff/qh tlevel|r\
    • Option to colour quest names by their difficulty: |cff40bbff/qh tqcol|r\
    • Option to colour objectives by their progress: |cff40bbff/qh tocol|r\
    • Option to scale the quest tracker: |cff40bbff/qh tscale|r\
    • Added a small button to quickly minimize or restore the quest tracker. The button will be invisible unless the cursor is over the quest tracker, and transparent when the quest tracker is minimized.\
    • The quest tracker can be repositioned by dragging the above button. The tracker will be re-anchored to the button depending on where on the screen it is placed so that when it changes size, it will grow away from the edges of the screen.\
    • The position of the quest tracker can be reset with this command: |cff40bbff/qh treset|r\
    • Hiding QuestHelper will now also hide the quest tracker.\
    • Will now force watched quests to be put at the top of the list, with a small gap seperating them from the automatically added quests. You can use the builtin quest log, beql, or DoubleWide to manage quest watches. Other addons might also work if they hook Blizzard's original quest watch functions properly. I also tried to make this work properly with UberQuest, but your milage may vary.\
    • Will include the quests of your party members, if sharing is enabled and they are also using QuestHelper.\
    • Will display the progress of your party members as a comma seperated list, although the list will only include unique values, so if everyone's progress is the same, this will appear as a single number.\
• Fixed a bug with objective icons inheriting their alpha value from the map frame, which Cartographer could hide.\
• Fixed a bug in routing, was caching the objective locations.\
• Assumes that if you die, you'll need to return to your body.\
• QuestHelper won't try to track objectives for failed quests.\
• Includes a submitted Russian translation.\
\
|cffffff00       Version 0.46 05/14/2008|r\
\
• Replaced the COPPER, SILVER, and GOLD strings that Blizzard renamed.\
• Added a replacement for the built in quest tracker that automatically populates itself and sorts itself to reflect QuestHelper's route.\
    • It only includes your own quests and objectives.\
    • Right click on a quest name to open that quest in your questlog.\
    • It can't be configured and you can't manually add or remove quests from it.\
    • You may disable it and restore the built in quest tracker by typing '|cff40bbff/qh track|r'.\
• Added objective information to the tooltips of items and monsters.\
    • They include information on the progress of party members also using QuestHelper.\
    • You may disable this by typing '|cff40bbff/qh tooltip|r'.\
• QuestHelper should dedicate less CPU time to routing when inside instances.\
• The pathing resets and flight time calculations now happen in a coroutine, so as to not lock up the game while the magic is happening.\
• Offended creationists by reimplementing routing using genetic algorithms.\
• Menus were given borders, and made more opaque.\
• Included an update for the Danish translation.\
• Will verify that QuestHelper's files all came from the same version, to ensure you installed or upgraded it properly.\
• Fixed a bug that sometimes broke the blocked objective filter an made objectives appear complete when there weren't.\
• Fixed a bug involving factions that broke objectives involving buying things from vendors.\
• Made some changes requested by the author of AlphaMap.\
\
|cffffff00       Version 0.45 05/06/2008|r\
\
• Added new filter option: '|cff40bbff/qh filter blocked|r' will hide objectives which can't be accomplished yet, such as turn-ins for incomplete quests.\
• Resolved issue which caused route to change around repeatedly.\
• |cff40bbff/qh share|r and |cff40bbff/qh solo|r should now be working again.\
• Added support for using TomTom in place of Cartographer Waypoints.\
• Warsky/Wars120 wants recognition for creating a Dutch translation.\
• Includes submitted Turkish translation.\
• Custom fonts can be placed in Fonts directory, see the readme.txt file there for information.\
• Added Globe icon to locale menu.\
• Added option to hide the map button '|cff40bbff/qh button|r'.\
• Includes update to the Spanish translation.\
• Added performance scaling option to menu.\
• Did some stuff to try to improve performance - some small, some drastic.\
• Made menus one point bigger.\
• Fixed translation name for Danish.\
• Added slash command for settings menu '|cff40bbff/qh settings|r'.\
• Added 'Close Menu' to end of each menu.\
• Number of players per quest was calculated wrong, should be fixed.\
\
|cffffff00       Version 0.44 04/24/2008|r\
\
• Added World Map button to disable/enable QuestHelper.\
• Added slash command '|cff40bbff/qh perf|r' to set a Performance Factor: lower is better performance (i.e. frame rate), higher is more aggressive routing/updating.\
• Added a right-click menu for the World Map button. It's probably only temporary and isn't translated.\
• Made menus smaller, and they are no longer scaled when showing/hiding.\
• '|cff40bbff/qh locale|r' Now prints the language, and will accept just the language code (en, de, es, etc.)\
• Includes a submitted translation for Danish, as there isn't a Danish version of Warcraft, you'll need to select it using the '|cff40bbff/qh locale|r' command in order to use it.\
• Includes an updated translations for German and Spanish.\
• Made the Spanish translations for Mexico reference the Spanish translations for Spain.\
• Possibly fixed passing a boolean to math.max in questlog.lua.\
• '|cff40bbff/qh locale|r' Now prints the language, and will accept just the language code (en, de, es, etc.)\
• '|cff40bbff/qh purge|r' will now reset the locale of the saved data, so you can use it if you change the language of your client.\
• When using Cartographer Waypoints, if LibRock or LibBabble are missing, QuestHelper will avoid trying to use them to translate the zone name. This will probably still work if you're using an English client, otherwise your best best would be to make sure Cartographer is up to date.\
"
