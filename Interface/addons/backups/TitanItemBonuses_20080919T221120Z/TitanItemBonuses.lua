-- **************************************************************************
-- * TitanItemBonuses.lua
-- *
-- * By: Titan Development Team 
-- *     (HonorGoG, jaketodd422, joejanko, Lothayer, Tristanian)
-- *
-- * Note: Rquires BonusScanner 3.2 or better.
-- **************************************************************************

-- ******************************** Constants *******************************
TITAN_ITEMBONUSES_ID = "ItemBonuses";

-- ******************************** Variables *******************************
TitanItemBonuses_active = nil;


-- ******************************** Functions *******************************

-- **************************************************************************
-- NAME : TitanPanelItemBonusesButton_OnLoad()
-- DESC : Registers the plugin upon it loading
-- **************************************************************************
function TitanPanelItemBonusesButton_OnLoad()
     this.registry = {
          id = TITAN_ITEMBONUSES_ID,
          builtIn = 1,
          version = TITAN_VERSION,
          menuText = TITAN_ITEMBONUSES_TEXT,
          buttonTextFunction = "TitanPanelItemBonusesButton_GetButtonText",
          tooltipTitle = TITAN_ITEMBONUSES_TEXT,
          tooltipTextFunction = "TitanPanelItemBonusesButton_GetTooltipText",
          icon = "Interface\\Icons\\Spell_Nature_EnchantArmor.blp";
          iconWidth = 16,
          savedVariables = {
               ShowLabelText = 1,
               ShowColoredText = TITAN_NIL,
               ShowIcon = 1,
               ShowPoints = TITAN_NIL,
               ShowGems = TITAN_NIL,
               shortdisplay = TITAN_NIL,
               displaybonuses = {},
          }
     };

     this:RegisterEvent("PLAYER_ENTERING_WORLD");
end

-- **************************************************************************
-- NAME : TitanPanelItemBonusesButton_OnEvent() 
-- DESC : Parse events registered to plugin and act on them
-- **************************************************************************
function TitanPanelItemBonusesButton_OnEvent() 
     if (event == "PLAYER_ENTERING_WORLD") then
          TitanItemBonuses_active = 1;
     end
end

-- **************************************************************************
-- NAME : TitanPanelItemBonusesButton_FormatShortText(short,val)
-- DESC : Condense text into shortened format
-- VARS : short = <research>, val = <research>
-- **************************************************************************
function TitanPanelItemBonusesButton_FormatShortText(short,val)
     local color = 'FFFFFF';
     local text = string.sub(short,2);
     local colorcode = string.sub(short,1,1);
     if(TitanItemBonuses_colors[colorcode]) then
          color = TitanItemBonuses_colors[colorcode];
     end;
     if(val) then
          return '|cff'.. color .. val .. FONT_COLOR_CODE_CLOSE
     else 
          return '|cff'.. color .. text .. FONT_COLOR_CODE_CLOSE
     end;
end


-- **************************************************************************
-- NAME : TitanPanelItemBonusesButton_GetButtonText(id)
-- DESC : Calculate bonuses logic then display data on button
-- VARS : id = button ID
-- **************************************************************************
function TitanPanelItemBonusesButton_GetButtonText(id)

     local title = TITAN_ITEMBONUSES_TEXT;
     local text = "";
     local disp = TitanGetVar(TITAN_ITEMBONUSES_ID, "displaybonuses");
     -- preventing getting inaccessible due to no display at all
     if(     (not disp or (table.getn(disp) == 0 ) or not BonusScanner or not BonusScanner.active)
          and not TitanGetVar(TITAN_ITEMBONUSES_ID, "ShowLabelText")
          and not TitanGetVar(TITAN_ITEMBONUSES_ID, "ShowIcon")) then
          TitanSetVar(TITAN_ITEMBONUSES_ID, "ShowLabelText", 1);
          TitanPanelButton_UpdateButton(TITAN_ITEMBONUSES_ID);
     end;

     if(not BonusScanner or not BonusScanner.active) then
          return TITAN_ITEMBONUSES_TEXT,"";
     end
     
     local i,d,e;
     local liste = {};
     for i,d in pairs(disp) do
          e = TITAN_ITEMBONUSES_EFFECTS[d];
          if(TitanGetVar(TITAN_ITEMBONUSES_ID, "shortdisplay")) then
               title = TitanPanelItemBonusesButton_FormatShortText(e.short);
          else
               title = BONUSSCANNER_NAMES[e.effect]..": ";
          end
          if(BonusScanner.bonuses[e.effect]) then
               if (TitanGetVar(TITAN_ITEMBONUSES_ID, "ShowPoints")) then
               level = UnitLevel("player");
                    temp = BonusScanner:GetRatingBonus(e.effect, BonusScanner.bonuses[e.effect],level)
                     if temp~=nil then
                     val = temp
                    else
                    val = BonusScanner.bonuses[e.effect];
                    end
                    else
                    val = BonusScanner.bonuses[e.effect];
               end     
          else
               val = 0;
          end
               if(TitanGetVar(TITAN_ITEMBONUSES_ID, "ShowPoints")) and (e.pformat) then
               text = format(e.pformat,val);
               else
             text = format(e.format,val);
             end
          if(TitanGetVar(TITAN_ITEMBONUSES_ID, "ShowColoredText")) then
               text = TitanPanelItemBonusesButton_FormatShortText(e.short,text);
          end;
          table.insert(liste,title);
          table.insert(liste,TitanUtils_GetHighlightText(text));
     end;
     if(table.getn(liste) == 0) then
          return TITAN_ITEMBONUSES_TEXT,"";
     end
     return unpack(liste);
end

-- **************************************************************************
-- NAME : TitanPanelItemBonusesButton_isdisp(val)
-- DESC : <research>
-- VARS : val = <research>
-- **************************************************************************
function TitanPanelItemBonusesButton_isdisp(val)
     local disp = TitanGetVar(TITAN_ITEMBONUSES_ID, "displaybonuses");
     local i,d;
     for i,d in pairs(disp) do
          if(d==val) then
               return 1;
          end
     end
     return nil;
end

-- **************************************************************************
-- NAME : TitanPanelItemBonusesButton_hasdisp()
-- DESC : <research>
-- **************************************************************************
function TitanPanelItemBonusesButton_hasdisp()
     local disp = TitanGetVar(TITAN_ITEMBONUSES_ID, "displaybonuses");
     if(not disp) then
          return nil;
     end
     return table.getn(disp) > 0;
end


-- **************************************************************************
-- NAME : TitanPanelItemBonusesButton_GetTooltipText()
-- DESC : Display tooltip text
-- **************************************************************************
function TitanPanelItemBonusesButton_GetTooltipText()

     if(not BonusScanner or not BonusScanner.active) then
          return "\n" ..TITAN_ITEMBONUSES_BONUSSCANNER_MISSING;
     end

     local retstr,cat,val = "","","","";
     local i;

     for i,e in pairs(TITAN_ITEMBONUSES_EFFECTS) do

          if(BonusScanner.bonuses[e.effect]) then
               if(e.format) then
                    if (TitanGetVar(TITAN_ITEMBONUSES_ID, "ShowPoints")) and (e.pformat) then
                          level = UnitLevel("player");
                                val, points = BonusScanner:ProcessSpecialBonus (e.effect, BonusScanner.bonuses[e.effect], level);
                                if val=="" then
                       val = format(e.pformat,points);
                         end
                       else
                       val = format(e.format,BonusScanner.bonuses[e.effect]);
                  end     
               else
                    val = BonusScanner.bonuses[e.effect];
               end;
               if(e.cat ~= cat) then
                    cat = e.cat;
                    if(retstr ~= "") then
                         retstr = retstr .. "\n"
                    end
                    retstr = retstr .. "\n" .. TitanUtils_GetGreenText(getglobal('TITAN_ITEMBONUSES_CAT_'..cat)..":");
               end
               retstr = retstr.. "\n".. BONUSSCANNER_NAMES[e.effect]..":\t".. TitanUtils_GetHighlightText(val);
          end
     end
     
     if (TitanGetVar(TITAN_ITEMBONUSES_ID, "ShowGems")) and BONUSSCANNER_VERSION >= "3.2" then
                          retstr = retstr .. "\n";
           if BonusScanner.GemsRed~=0 or BonusScanner.GemsYellow~=0 or BonusScanner.GemsBlue~=0 then
                         retstr = retstr .. "\n"..GREEN_FONT_COLOR_CODE..BONUSSCANNER_TOOLTIPGEMS_STRING..":";
                     end
                     if BonusScanner.GemsRed~=0 then
                         retstr = retstr .. "\n"..BONUSSCANNER_GEMCOUNT_LABEL..RED_FONT_COLOR_CODE..BONUSSCANNER_GEMRED_LABEL.."|cffffd200"..":\t"..HIGHLIGHT_FONT_COLOR_CODE..BonusScanner.GemsRed;
                     end
                     if BonusScanner.GemsYellow~=0 then
                         retstr = retstr .. "\n"..BONUSSCANNER_GEMCOUNT_LABEL..LIGHTYELLOW_FONT_COLOR_CODE..BONUSSCANNER_GEMYELLOW_LABEL.."|cffffd200"..":\t"..HIGHLIGHT_FONT_COLOR_CODE..BonusScanner.GemsYellow;
                     end
                    if BonusScanner.GemsBlue~=0 then
                         retstr = retstr .. "\n"..BONUSSCANNER_GEMCOUNT_LABEL.."|cff2459ff"..BONUSSCANNER_GEMBLUE_LABEL.."|cffffd200"..":\t"..HIGHLIGHT_FONT_COLOR_CODE..BonusScanner.GemsBlue;
                     end
     
     end
     return retstr;
end

-- **************************************************************************
-- NAME : TitanPanelItemBonuses_Update()
-- DESC : Update button data
-- **************************************************************************
function TitanPanelItemBonuses_Update()
     --oldBonusScanner_Update();
     if(TitanItemBonuses_active) then
          TitanPanelButton_UpdateButton(TITAN_ITEMBONUSES_ID);
     end
     return TitanItemBonuses.hooks.BonusScanner_Update();
end

--oldBonusScanner_Update = BonusScanner_Update;
--BonusScanner_Update = TitanPanelItemBonuses_Update;
TitanItemBonuses = Rock:NewAddon("TitanItemBonuses", "LibRockHook-1.0");
TitanItemBonuses:AddHook("BonusScanner_Update",TitanPanelItemBonuses_Update);

-- **************************************************************************
-- NAME : TitanPanelRightClickMenu_PrepareItemBonusesMenu()
-- DESC : Display rightclick menu options
-- **************************************************************************
function TitanPanelRightClickMenu_PrepareItemBonusesMenu()
     local id = "ItemBonuses";
     local info = {};
     local i,cat,disp,val;

     if ( UIDROPDOWNMENU_MENU_LEVEL == 2 ) then
          for i,e in pairs(TITAN_ITEMBONUSES_EFFECTS) do
               if(e.cat == UIDROPDOWNMENU_MENU_VALUE) then
                    info = {};
                    info.text = '[' .. TitanPanelItemBonusesButton_FormatShortText(e.short) .. '] ' .. BONUSSCANNER_NAMES[e.effect];
                    if(BonusScanner.bonuses[e.effect]) then
                              
                              if(e.format) then
                    if (TitanGetVar(TITAN_ITEMBONUSES_ID, "ShowPoints")) and (e.pformat) then
                          level = UnitLevel("player");
                                val = BonusScanner:GetRatingBonus (e.effect, BonusScanner.bonuses[e.effect], level);
                                info.text = info.text .. " (".. format(e.pformat,val).. ")";                                
                       else
                       val = BonusScanner.bonuses[e.effect];
                       info.text = info.text .. " (".. format(e.format,val).. ")";
                  end     
               else
                    val = BonusScanner.bonuses[e.effect];
                    info.text = info.text .. " (".. format(e.format,val).. ")";
               end;
                              
                         --val = BonusScanner.bonuses[e.effect];
                            --info.text = info.text .. " (".. format(e.format,val).. ")";
                       end
                    info.value = i;
                    info.func = TitanPanelItemBonuses_SetDisplay;
                    info.checked = TitanPanelItemBonusesButton_isdisp(i);
                    info.keepShownOnClick = 1;
                    UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
               end
          end
     else
     
          if(not BonusScanner or not BonusScanner.active) then
               TitanPanelRightClickMenu_AddToggleIcon(TITAN_ITEMBONUSES_ID);
               TitanPanelRightClickMenu_AddToggleLabelText(TITAN_ITEMBONUSES_ID);
               TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, id, TITAN_PANEL_MENU_FUNC_HIDE);     
          else
               TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_ITEMBONUSES_ID].menuText);
               TitanPanelRightClickMenu_AddSpacer(UIDROPDOWNMENU_MENU_LEVEL);
     
               info = {};
               info.text = TITAN_ITEMBONUSES_DISPLAY_NONE;
               info.value = 0;
               info.func = TitanPanelItemBonuses_SetDisplay;
               disp = TitanGetVar(TITAN_ITEMBONUSES_ID, "displaybonuses");
               info.checked = not TitanPanelItemBonusesButton_hasdisp();
               UIDropDownMenu_AddButton(info);
               
               TitanPanelRightClickMenu_AddToggleVar(TITAN_ITEMBONUSES_RATING_CONVERSION, TITAN_ITEMBONUSES_ID,'ShowPoints');
               TitanPanelRightClickMenu_AddToggleVar(TITAN_ITEMBONUSES_SHOWGEMS, TITAN_ITEMBONUSES_ID,'ShowGems');
               
               for i,cat in pairs(TITAN_ITEMBONUSES_CATEGORIES) do
                    info = {};
                    info.text = getglobal('TITAN_ITEMBONUSES_CAT_'..cat);
                    info.hasArrow = 1;
                    info.value = cat;
                    UIDropDownMenu_AddButton(info);
               end;
     
               TitanPanelRightClickMenu_AddSpacer(UIDROPDOWNMENU_MENU_LEVEL);
     
               TitanPanelRightClickMenu_AddToggleIcon(TITAN_ITEMBONUSES_ID);
               TitanPanelRightClickMenu_AddToggleVar(TITAN_ITEMBONUSES_SHORTDISPLAY, TITAN_ITEMBONUSES_ID,'shortdisplay');
               TitanPanelRightClickMenu_AddToggleLabelText(TITAN_ITEMBONUSES_ID);
               TitanPanelRightClickMenu_AddToggleColoredText(TITAN_ITEMBONUSES_ID);
               TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, id, TITAN_PANEL_MENU_FUNC_HIDE);
          end
               
     end
end

-- **************************************************************************
-- NAME : TitanPanelItemBonuses_SetDisplay()
-- DESC : <research>
-- **************************************************************************
function TitanPanelItemBonuses_SetDisplay()
     local db = TitanGetVar(TITAN_ITEMBONUSES_ID, "displaybonuses");
     local i,d,found;
     if(this.value == 0) then
          TitanSetVar(TITAN_ITEMBONUSES_ID, "displaybonuses", {});
     else
          found = 0;
          for i,d in pairs(db) do
               if(d == this.value)then
                    found = i;
               end
          end
          if(found > 0) then
               table.remove(db,found)
          else
               while(table.getn(db)>3) do
                    table.remove(db);
               end;
               table.insert(db,this.value);
          end
          TitanSetVar(TITAN_ITEMBONUSES_ID, "displaybonuses", db);
     end;
     TitanPanelButton_UpdateButton(TITAN_ITEMBONUSES_ID);
end
