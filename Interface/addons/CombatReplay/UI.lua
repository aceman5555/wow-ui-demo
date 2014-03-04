--ы
function crframeopen()



--drop down menu for combats:
cropendropdowncombats()
  

--create all frames
if crPlayersFrames==nil then

  crPlayersFrames={}
  crPlayersFramesColor={}
  crPlayersFramesIcons={}
  crPlayersFramesNames={}
  crPlayersButtons={}
  crPlayersButtonsColor={}
  crPlayersButtonsText={}
  
  for i=1,25 do
    --квадрат для игрока
    local p=CreateFrame("Button",nil,crframecenter)
    p:SetWidth(crPlayersSizeOnMap)
    p:SetHeight(crPlayersSizeOnMap)
    p:Hide()
    p:SetScript("OnEnter", function(self) crPlayersFramesNames[i]:Show() end)
    p:SetScript("OnLeave", function(self) if (crPlayersActive[1]~=i and crPlayersActive[2]~=i) then crPlayersFramesNames[i]:Hide() end end)
    table.insert(crPlayersFrames, p)
    --текстура для цвета
    local y = p:CreateTexture(nil,"ARTWORK")
    y:SetAllPoints(p)
    table.insert(crPlayersFramesColor, y)
    
    
    --метка для каждого игрока
    local t = p:CreateTexture(nil,"OVERLAY")
    if crPlayerIconPositionShow then
      t:SetPoint("CENTER",0,crPlayersSizeOnMap+1)
    else
      t:SetPoint("CENTER",0,0)
    end
    t:SetWidth(crPlayersSizeOnMap-2)
    t:SetHeight(crPlayersSizeOnMap-2)
    table.insert(crPlayersFramesIcons,t)
    
    --ник над головой
    tt = p:CreateFontString()
    tt:SetPoint("CENTER",0,crPlayersSizeOnMap/2+8)
    tt:SetFont(GameFontNormal:GetFont(), 11)
    tt:SetJustifyH("CENTER")
    tt:SetJustifyV("BOTTOM")
    tt:Hide()
    table.insert(crPlayersFramesNames,tt)
    
    --для левого фрейма 25 кнопок:
    local pl = CreateFrame("Button", nil, crframeleft);
    pl:Hide()
    pl:SetWidth("128")
    pl:SetHeight("25")
    pl:SetPoint("TOP",0,-10-28*i)
    
    table.insert(crPlayersButtons,pl)
    --текстура для цвета

    local y2 = pl:CreateTexture(nil,"BACKGROUND")
    --y2:SetAllPoints(pl)
	
    y2:SetPoint("TOPLEFT",0,0)
    y2:SetWidth(128)
	y2:SetHeight("25")
	
	
    table.insert(crPlayersButtonsColor, y2)
    --текст
    local y3 = pl:CreateFontString()
    y3:SetWidth(118)
    y3:SetHeight(25)
    y3:SetFont(GameFontNormal:GetFont(), 12)
    y3:SetPoint("CENTER",0,0)
    y3:SetJustifyH("CENTER")
    y3:SetJustifyV("CENTER")
    table.insert(crPlayersButtonsText, y3)

  end
  
  
  -- distance check
  crRangeLine = crframecenter:CreateTexture("DistanceLine1", "BACKGROUND");
  crRangeLine:SetTexture("Interface\\TaxiFrame\\UI-Taxi-Line");
  
  crRangeLineText = crframecenter:CreateFontString()
  crRangeLineText:SetFont(GameFontNormal:GetFont(), 16)
  crRangeLineText:SetJustifyH("RIGHT")
  crRangeLineText:SetJustifyV("CENTER")
  
  --show current distance
  crRangeDistanceBottom = crframecenter:CreateFontString()
  crRangeDistanceBottom:SetWidth(500)
  crRangeDistanceBottom:SetHeight(25)
  crRangeDistanceBottom:SetFont(GameFontNormal:GetFont(), 14)
  crRangeDistanceBottom:SetPoint("BOTTOMRIGHT",-15,13)
  crRangeDistanceBottom:SetJustifyH("RIGHT")
  crRangeDistanceBottom:SetJustifyV("BOTTOM")
  
  --show current fail raid distance
  crRangeDistanceBottom2 = crframecenter:CreateFontString()
  crRangeDistanceBottom2:SetWidth(500)
  crRangeDistanceBottom2:SetHeight(25)
  crRangeDistanceBottom2:SetFont(GameFontNormal:GetFont(), 14)
  crRangeDistanceBottom2:SetPoint("BOTTOMRIGHT",-15,40)
  crRangeDistanceBottom2:SetJustifyH("RIGHT")
  crRangeDistanceBottom2:SetJustifyV("BOTTOM")
  
  
  crButtonStop:Hide()

  
    --для правого фрейма КАСТБАР:
    crCastBar1 = CreateFrame("Frame", nil, crframeright);
    crCastBar1:Hide()
    crCastBar1:SetWidth(176)
    crCastBar1:SetHeight(24)
    crCastBar1:SetPoint("TOPLEFT",11,-150)
    
    --текстура для кастбара
    crCastBar2 = crCastBar1:CreateTexture(nil,"OVERLAY")
    crCastBar2:SetPoint("TOPLEFT",25,0)
    crCastBar2:SetWidth(1)
    crCastBar2:SetHeight(24)
    crCastBar2:SetTexture(0, 1, 0, 0.7)
    
    local crCastBar3 = crCastBar1:CreateTexture(nil,"BACKGROUND")
    crCastBar3:SetWidth(152)
    crCastBar3:SetHeight(24)
    crCastBar3:SetPoint("TOPLEFT",25,0)
    crCastBar3:SetTexture(0, 0, 1, 0.8)
    
    crCastBar4 = crCastBar1:CreateFontString()
    crCastBar4:SetAllPoints(crCastBar1)
    crCastBar4:SetFont(GameFontNormal:GetFont(), 14)
    crCastBar4:SetJustifyH("RIGHT")
    crCastBar4:SetJustifyV("CENTER")
    
    --crCastBar5 = crCastBar1:CreateTexture(nil,"OVERLAY")
    --crCastBar5:SetWidth(24)
    --crCastBar5:SetHeight(24)
    --crCastBar5:SetPoint("TOPLEFT",0,0)
    
      crCastBar6 = CreateFrame("Button",nil,crCastBar1)
      crCastBar6:SetWidth(24)
      crCastBar6:SetHeight(24)
      crCastBar6:SetPoint("TOPLEFT",0,0)
      crCastBar6:SetScript("OnEnter", function(self) if crCurrentlyCastingSpellPlayer then GameTooltip:SetOwner(self or UIParent, "ANCHOR_LEFT") GameTooltip:SetText(GetSpellInfo(crCurrentlyCastingSpellPlayer).."\n"..GetSpellDescription(crCurrentlyCastingSpellPlayer)) crPlayerCastMouseOverActive=1 end end)
      crCastBar6:SetScript("OnLeave", function(self) GameTooltip:Hide() crPlayerCastMouseOverActive=nil end)
    
      crCastBar5 = crCastBar6:CreateTexture(nil,"OVERLAY")
      crCastBar5:SetAllPoints(crCastBar6)
    
    
    --три текстуры для отображение инстанс кастов
    crInstanceCastsFrames={}
    crInstanceCastsFrames2={}
    for i=1,10 do
      local fds = CreateFrame("Button",nil,crframeright)
      fds:SetWidth(24)
      fds:SetHeight(24)
      fds:Hide()
      fds:SetScript("OnEnter", function(self) if crInstanceSpellsShow[i] then GameTooltip:SetOwner(self or UIParent, "ANCHOR_LEFT") GameTooltip:SetText(GetSpellInfo(crInstanceSpellsShow[i][1]).."\n"..GetSpellDescription(crInstanceSpellsShow[i][1])) end end)
      fds:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
      
      local qcrCastBar5 = fds:CreateTexture(nil,"OVERLAY")
      qcrCastBar5:SetAllPoints(fds)
      table.insert(crInstanceCastsFrames,qcrCastBar5)
      table.insert(crInstanceCastsFrames2,fds)
    end
    
    
    --правый фрейм ХП
    crHPBar1 = CreateFrame("Frame", nil, crframeright);
    crHPBar1:SetWidth(176)
    crHPBar1:SetHeight(24)
    crHPBar1:SetPoint("TOPLEFT",11,-63)
    
    crHPBar2 = crHPBar1:CreateTexture(nil,"OVERLAY")
    crHPBar2:SetPoint("TOPLEFT",0,0)
    crHPBar2:SetWidth(0.001)
    crHPBar2:SetHeight(24)
    crHPBar2:SetTexture(0, 1, 0, 0.7)
    
    crHPBar3 = crHPBar1:CreateFontString(nil, "OVERLAY")
    crHPBar3:SetAllPoints(crHPBar1)
    crHPBar3:SetFont(GameFontNormal:GetFont(), 14)
    crHPBar3:SetJustifyH("RIGHT")
    crHPBar3:SetJustifyV("CENTER")
    
    local crHPBar4 = crHPBar1:CreateTexture(nil,"BACKGROUND")
    crHPBar4:SetWidth(176)
    crHPBar4:SetHeight(24)
    crHPBar4:SetPoint("TOPLEFT",0,0)
    crHPBar4:SetTexture(0, 0, 1, 0.8)
	
	
    --левый вертикальный фрейм общее ХП рейда
    crRaidHPBar1 = CreateFrame("Frame", nil, crframeleft);
    crRaidHPBar1:SetWidth(25)
    crRaidHPBar1:SetHeight(950)
    crRaidHPBar1:SetPoint("BOTTOMLEFT",-21,0)
    
    crRaidHPBar2 = crRaidHPBar1:CreateTexture(nil,"OVERLAY")
    crRaidHPBar2:SetPoint("BOTTOM",0,0)
    crRaidHPBar2:SetWidth(25)
    crRaidHPBar2:SetHeight(0.001)
    crRaidHPBar2:SetTexture(0, 1, 0, 0.7)
    
    crRaidHPBar3 = crRaidHPBar1:CreateFontString(nil, "OVERLAY")
    crRaidHPBar3:SetAllPoints(crRaidHPBar1)
    crRaidHPBar3:SetFont(GameFontNormal:GetFont(), 13)
    crRaidHPBar3:SetJustifyH("CENTER")
    crRaidHPBar3:SetJustifyV("BOTTOM")
	
    crRaidHPBar32 = crRaidHPBar1:CreateFontString(nil, "OVERLAY")
    crRaidHPBar32:SetAllPoints(crRaidHPBar1)
    crRaidHPBar32:SetFont(GameFontNormal:GetFont(), 13)
    crRaidHPBar32:SetJustifyH("CENTER")
    crRaidHPBar32:SetJustifyV("TOP")
    
    local crRaidHPBar4 = crRaidHPBar1:CreateTexture(nil,"BACKGROUND")
    crRaidHPBar4:SetWidth(25)
    crRaidHPBar4:SetHeight(950)
    crRaidHPBar4:SetPoint("TOPLEFT",0,0)
    crRaidHPBar4:SetTexture(0, 0, 1, 0.4)
    
    
    --фреймы для дебаффов 5 рядов по 3 шт // 4 шт в ряду теперь
    crDebuffFramesRightFrame={}
    crDebuffFramesRightIcon={}
    crDebuffFramesRightText={}
    crPalyerDebuffTable={}
    local left=13
    local top=0
    for i=1,15 do
      local fram = CreateFrame("Button",nil,crframeright)
      fram:SetWidth(40)
      fram:SetHeight(40)
      fram:SetPoint("TOPLEFT",left,-250-top)
      fram:SetScript("OnEnter", function(self) if crPalyerDebuffTable[i] then GameTooltip:SetOwner(self or UIParent, "ANCHOR_LEFT") GameTooltip:SetText(GetSpellInfo(crPalyerDebuffTable[i]).."\n"..GetSpellDescription(crPalyerDebuffTable[i])) end end)
      fram:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    
      local ico = fram:CreateTexture(nil,"OVERLAY")
      ico:SetAllPoints(fram)

      local tex = crframeright:CreateFontString(nil, "OVERLAY")
      tex:SetPoint("TOPLEFT",left-4,-290-top)
      tex:SetFont(GameFontNormal:GetFont(), 12)
      tex:SetWidth(50)
      tex:SetJustifyH("CENTER")
      tex:SetJustifyV("TOP")
      
      left=left+43
      if left>160 then
        left=13
        top=top+58
      end
      table.insert(crDebuffFramesRightFrame,fram)
      table.insert(crDebuffFramesRightIcon,ico)
      table.insert(crDebuffFramesRightText,tex)
    end
    
    --фреймы для общих рейд баффов, 1 ряд 5 штук
    crRaidBuffFramesIcon={}
    crRaidBuffFramesText={}
    for i=1,5 do
      local ico = crframecenter:CreateTexture(nil,"OVERLAY")
      ico:SetWidth(28)
      ico:SetHeight(28)
      ico:SetPoint("TOPRIGHT",20-i*30,-12)

      local tex = crframecenter:CreateFontString()
      tex:SetPoint("TOPRIGHT",31-i*30,-43)
      tex:SetFont(GameFontNormal:GetFont(), 12)
      tex:SetWidth(50)
      tex:SetJustifyH("CENTER")
      tex:SetJustifyV("TOP")
      
      table.insert(crRaidBuffFramesIcon,ico)
      table.insert(crRaidBuffFramesText,tex)
    end
    
  
  --show current time frame
  crCurrentTimeShow = crframecenter:CreateFontString()
  crCurrentTimeShow:SetWidth(700)
  crCurrentTimeShow:SetHeight(25)
  crCurrentTimeShow:SetFont(GameFontNormal:GetFont(), 16)
  crCurrentTimeShow:SetPoint("BOTTOMLEFT",13,13)
  crCurrentTimeShow:SetJustifyH("LEFT")
  crCurrentTimeShow:SetJustifyV("BOTTOM")
  

  
  
  --text for right frame, name info
  crRightInfoText = crframeright:CreateFontString()
  crRightInfoText:SetWidth(335)
  crRightInfoText:SetHeight(425)
  crRightInfoText:SetFont(GameFontNormal:GetFont(), 14)
  crRightInfoText:SetPoint("TOPLEFT",20,-15)
  crRightInfoText:SetJustifyH("LEFT")
  crRightInfoText:SetJustifyV("TOP")
  
  
    --квадрат для ассистов
    local p=CreateFrame("Button",nil,crframeright)
    p:SetWidth(20)
    p:SetHeight(15)
    p:SetPoint("TOPLEFT", crframeright, "TOPLEFT", 13, -42)
    p:SetScript("OnEnter", function(self) if crPlayerTargetAssist:IsShown() and crPlayerTargetAssistList then GameTooltip:SetOwner(self or UIParent, "ANCHOR_LEFT")	GameTooltip:SetText(crPlayerTargetAssistList) crPlayerTargetToolTipActive=i end end)
    p:SetScript("OnLeave", function(self) if crPlayerTargetAssist:IsShown() then GameTooltip:Hide() end crPlayerTargetToolTipActive=nil end)
    
    --текст ассистов
    crPlayerTargetAssist = p:CreateFontString(nil,"OVERLAY")
    crPlayerTargetAssist:SetPoint("CENTER")
    crPlayerTargetAssist:SetFont(GameFontNormal:GetFont(), 14)
    crPlayerTargetAssist:SetJustifyH("RIGHT")
    crPlayerTargetAssist:SetJustifyV("TOP")
    crPlayerTargetAssist:Hide()
    

  --text fot right frame, spell's history
  crRightSpellHistory = crframeright:CreateFontString()
  crRightSpellHistory:SetWidth(335)
  crRightSpellHistory:SetHeight(425)
  crRightSpellHistory:SetFont(GameFontNormal:GetFont(), 12)
  crRightSpellHistory:SetPoint("BOTTOMLEFT",15,170)
  crRightSpellHistory:SetJustifyH("LEFT")
  crRightSpellHistory:SetJustifyV("BOTTOM")



  --set the slider
  if crsaveddata[1] then
  
    local combatTime=math.floor(crsaveddata[1].events[#crsaveddata[1].events].t-crsaveddata[1].events[1].t)
    local min=math.floor(combatTime/60)
    local sec=combatTime%60
    if sec<10 then
      sec="0"..sec
    end
    
    getglobal("crPlaySliderHigh"):SetText(min..":"..sec)
    getglobal("crPlaySliderLow"):SetText("00:00")
    crPlaySlider:SetMinMaxValues(1, #crsaveddata[1].events)
    crPlaySlider:SetValueStep(1)

  end
  
    --create the timeline frame under slider
    crTimeLineBar = CreateFrame("Frame", nil, crframebottom);
    crTimeLineBar:SetWidth(crCenterFrameSizeDef-130)
    crTimeLineBar:SetHeight(20)
    crTimeLineBar:SetPoint("CENTER",0,15)
    
    crTimeLineButton={}
    crTimeLineButtonColor={}
    
    --засечка для кастбара // 50 штук?
    for i=1,50 do
      local p=CreateFrame("Button",nil,crTimeLineBar)
      p:SetWidth("5")
      p:SetHeight("20")
      p:Hide()
      table.insert(crTimeLineButton, p)
      --текстура для цвета
      local y = p:CreateTexture(nil,"OVERLAY")
      y:SetAllPoints(p)
      table.insert(crTimeLineButtonColor, y)
    end
    
    
    
    --bosses
    --==========================================================================
      --bossframe model
      crBossFrameModel1={}
      crBossFrameAssists={}
      crBossFrameName1={}
      crCastBarBoss11={}
      crCastBarBoss12={}
      --crCastBarBoss13={}
      crCastBarBoss14={}
      crCastBarBoss15={}
      crCastBarBoss16={}
      crHPBarBoss11={}
      crHPBarBoss12={}
      crHPBarBoss13={}
      crHPBarBoss14={}
      crBossBuffFrame={}
      crBossBuffIcon={}
      crBossBuffText={}
      crPowerBarBoss1={}
      crBossBuffTable={}
      
    for i=1,4 do
      local bmframe = CreateFrame("PlayerModel", nil, crframetop)
      bmframe:SetPoint("TOPLEFT", crframetop, "TOPLEFT", -230+i*240, -14)
      bmframe:SetWidth(100)
      bmframe:SetHeight(75)
      bmframe:SetPortraitZoom(0.4)
      bmframe:SetRotation(0)
      bmframe:SetClampRectInsets(0, 0, 24, 0)
      bmframe:Show()
      bmframe:SetSequence(4)
      bmframe:SetFrameStrata("DIALOG")
      bmframe:SetDisplayInfo(0)
      table.insert(crBossFrameModel1,bmframe)
      
      
    --квадрат для ассистов
    local p=CreateFrame("Button",nil,crframetop)
    p:SetWidth(20)
    p:SetHeight(15)
    p:SetPoint("TOPLEFT", crframetop, "TOPLEFT", -166+i*240, -14)
    p:SetScript("OnEnter", function(self) if crBossFrameAssists[i]:IsShown() then GameTooltip:SetOwner(self or UIParent, "ANCHOR_LEFT")	GameTooltip:SetText(crBossAssists[i]) crBossTargetToolTipActive=i end end)
    p:SetScript("OnLeave", function(self) if crBossFrameAssists[i]:IsShown() then GameTooltip:Hide() end crBossTargetToolTipActive=nil end)
    
    --текст ассистов
    tt = p:CreateFontString(nil,"OVERLAY")
    tt:SetPoint("CENTER")
    tt:SetFont(GameFontNormal:GetFont(), 14)
    tt:SetJustifyH("RIGHT")
    tt:SetJustifyV("TOP")
    tt:Hide()
    table.insert(crBossFrameAssists,tt)
      
      
    --bossname and target
    local bname = crframetop:CreateFontString()
    bname:SetWidth(335)
    bname:SetHeight(100)
    bname:SetFont(GameFontNormal:GetFont(), 14)
    bname:SetPoint("TOPLEFT",-140+i*240,-12)
    bname:SetJustifyH("LEFT")
    bname:SetJustifyV("TOP")
    table.insert(crBossFrameName1,bname)
  
    --босс1 КАСТБАР:
    local a1 = CreateFrame("Frame", nil, crframetop);
    a1:Hide()
    a1:SetWidth(126)
    a1:SetHeight(18)
    a1:SetPoint("TOPLEFT",-140+i*240,-68)
    table.insert(crCastBarBoss11,a1)
    
    --текстура для кастбара
    local a2 = a1:CreateTexture(nil,"OVERLAY")
    a2:SetPoint("TOPLEFT",19,0)
    a2:SetWidth(1)
    a2:SetHeight(18)
    a2:SetTexture(0, 1, 0, 0.7)
    table.insert(crCastBarBoss12,a2)
    
    local crCastBarBoss13 = a1:CreateTexture(nil,"BACKGROUND")
    crCastBarBoss13:SetWidth(107)
    crCastBarBoss13:SetHeight(18)
    crCastBarBoss13:SetPoint("TOPLEFT",19,0)
    crCastBarBoss13:SetTexture(0, 0, 1, 0.8)
    
    local a4 = a1:CreateFontString()
    a4:SetAllPoints(a1)
    a4:SetFont(GameFontNormal:GetFont(), 12)
    a4:SetJustifyH("RIGHT")
    a4:SetJustifyV("CENTER")
    table.insert(crCastBarBoss14,a4)
    
    local a5 = a1:CreateTexture(nil,"OVERLAY")
    a5:SetWidth(18)
    a5:SetHeight(18)
    a5:SetPoint("TOPLEFT",0,0)
    
    
      local a6 = CreateFrame("Button",nil,a1)
      a6:SetWidth(18)
      a6:SetHeight(18)
      a6:SetPoint("TOPLEFT",0,0)
      a6:SetScript("OnEnter", function(self) if crCurrentlyCastingSpellBoss[i] then GameTooltip:SetOwner(self or UIParent, "ANCHOR_LEFT") GameTooltip:SetText(GetSpellInfo(crCurrentlyCastingSpellBoss[i]).."\n"..GetSpellDescription(crCurrentlyCastingSpellBoss[i])) crBossCastMouseOverActive[i]=1 end end)
      a6:SetScript("OnLeave", function(self) GameTooltip:Hide() crBossCastMouseOverActive[i]=nil end)
      table.insert(crCastBarBoss16,a6)
    
      local a5 = a6:CreateTexture(nil,"OVERLAY")
      a5:SetAllPoints(a6)
      table.insert(crCastBarBoss15,a5)
    
    --фрейм ХП босса
    local b1 = CreateFrame("Frame", nil, crframetop);
    b1:Hide()
    b1:SetWidth(126) -- НЕ ЗАБЫТЬ! если меняю тут цифру, в бинд дата искать 126 и менять тоже
    b1:SetHeight(18)
    b1:SetPoint("TOPLEFT",-140+i*240,-45)
    table.insert(crHPBarBoss11,b1)
    
    local b2 = b1:CreateTexture(nil,"OVERLAY")
    b2:SetPoint("TOPLEFT",0,0)
    b2:SetWidth(0.001)
    b2:SetHeight(18)
    b2:SetTexture(0, 1, 0, 0.7)
    table.insert(crHPBarBoss12,b2)
    
    local b3 = b1:CreateTexture(nil,"BACKGROUND")
    b3:SetWidth(126)
    b3:SetHeight(18)
    b3:SetAllPoints(b1)
    b3:SetTexture(0, 0, 1, 0.8)
    table.insert(crHPBarBoss13,b3)
    
    local b4 = b1:CreateFontString(nil, "OVERLAY")
    b4:SetAllPoints(b1)
    b4:SetFont(GameFontNormal:GetFont(), 12)
    b4:SetJustifyH("RIGHT")
    b4:SetJustifyV("CENTER")
    table.insert(crHPBarBoss14,b4)
    
    --полоска для отображения повера
    local m2 = crframetop:CreateTexture(nil,"OVERLAY")
    m2:SetPoint("TOPLEFT",-140+i*240,-64)
    m2:SetWidth(0.001)
    m2:SetHeight(3)
    m2:SetTexture(1, 0, 0, 0.7)
    table.insert(crPowerBarBoss1,m2)
    
    
    --фреймы для дебаффов 2 столбика по 3 шт

    table.insert(crBossBuffFrame,{})
    table.insert(crBossBuffIcon,{})
    table.insert(crBossBuffText,{})
    local left=-8+i*240
    local top=0
    for bi=1,6 do
    
      table.insert(crBossBuffTable,{})
      
      local fram = CreateFrame("Button",nil,crframetop)
      fram:SetWidth(18)
      fram:SetHeight(18)
      fram:SetPoint("TOPLEFT",left,-14-top)
      fram:SetScript("OnEnter", function(self) if crBossBuffTable[i][bi] then GameTooltip:SetOwner(self or UIParent, "ANCHOR_LEFT") GameTooltip:SetText(GetSpellInfo(crBossBuffTable[i][bi]).."\n"..GetSpellDescription(crBossBuffTable[i][bi])) end end)
      fram:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    
      local ico = fram:CreateTexture(nil,"OVERLAY")
      ico:SetAllPoints(fram)

      local tex = crframetop:CreateFontString(nil, "OVERLAY")
      tex:SetPoint("TOPLEFT",left-15,-33-top)
      tex:SetFont(GameFontNormal:GetFont(), 12)
      tex:SetWidth(50)
      tex:SetJustifyH("CENTER")
      tex:SetJustifyV("TOP")
      
      top=top+30
      if top>89 then
        top=0
        left=left+25
      end
      table.insert(crBossBuffFrame[#crBossBuffFrame], fram)
      table.insert(crBossBuffIcon[#crBossBuffIcon],ico)
      table.insert(crBossBuffText[#crBossBuffText],tex)
    end
    
    
  end
    --boss end ====================================================
    
    --edit box
    crRaidRangeEditBox:SetScript("onescapepressed", function(self) crRaidRangeEditBox:ClearFocus() end)
    crRaidRangeEditBox:SetScript("OnTextChanged", function(self) crRaidRangeCheckValue=crRaidRangeEditBox:GetNumber() crShowEventFrame(crPlayingCombatID,crPlayingCombatEvent) end )
    crRaidRangeEditBox:SetNumber(crRaidRangeCheckValue)



end
    crPlaySlider:SetWidth(crCenterFrameSizeDef-100)
    crPlaySlider:SetValue(1)
    crPlaySlider:SetScript("OnValueChanged", function(self) if (crPlayingCombatUpdateTime==nil or (crPlayingCombatUpdateTime and crPlayingCombatEvent~=math.floor(crPlaySlider:GetValue()))) and (crCurrentClickedSLiderTime==nil or crCurrentClickedSLiderTime~=math.floor(crPlaySlider:GetValue())) then crCurrentClickedSLiderTime=math.floor(crPlaySlider:GetValue()) crShowEventFrame(crPlayingCombatID,math.floor(crPlaySlider:GetValue())) end end )

end





--Drop Down frame with combats
function cropendropdowncombats()
if not DropDownMenuCombatChoose then
CreateFrame("Frame", "DropDownMenuCombatChoose", crframeleft, "UIDropDownMenuTemplate")
end

DropDownMenuCombatChoose:ClearAllPoints()
DropDownMenuCombatChoose:SetPoint("BOTTOMLEFT", 0, 20)
DropDownMenuCombatChoose:Show()



local items={}
if #crsaveddata>0 then
  for i=1,#crsaveddata do
    local name=""
    if crsaveddata[i].boss[1] and crsaveddata[i].boss[1][2] then
      name=crsaveddata[i].boss[1][2]..", "
    end
    --if combat is today - delete its date
    local _, month, day, year = CalendarGetDate()
    if month<10 then month="0"..month end
    if day<10 then day="0"..day end
    --if year>2000 then year=year-2000 end
    local text=month.."/"..day.."/"..year
    if string.find(crsaveddata[i].date, text) then
      name=name..string.sub(crsaveddata[i].date,1,string.find(crsaveddata[i].date,",")-1)
    else
      name=name..crsaveddata[i].date
    end
    table.insert(items,name)
  end
else
  items={"no data"}
end


local function OnClick(self)
UIDropDownMenu_SetSelectedID(DropDownMenuCombatChoose, self:GetID())

  crCurrentClickedSLiderTime=nil
  if crPlayersActive[1] then
    crPlayersFramesNames[crPlayersActive[1]]:Hide()
  end
  if crPlayersActive[2] then
    crPlayersFramesNames[crPlayersActive[2]]:Hide()
  end
  table.wipe(crPlayersActive)
  
  --drop down value changed
  if crsaveddata and #crsaveddata>0 then
    crStopReplay()
    crPlayingCombatID=self:GetID()
    
    --скрывать баффы рейда
    for m=1,#crRaidBuffFramesIcon do
      crRaidBuffFramesIcon[m]:Hide()
      crRaidBuffFramesText[m]:Hide()
    end
    
    crShowCombat(crPlayingCombatID)
    
    --update slider info:
    local combatTime=math.floor(crsaveddata[crPlayingCombatID].events[#crsaveddata[crPlayingCombatID].events].t-crsaveddata[crPlayingCombatID].events[1].t)
    local min=math.floor(combatTime/60)
    local sec=combatTime%60
    if sec<10 then
      sec="0"..sec
    end
    
    getglobal("crPlaySliderHigh"):SetText(min..":"..sec)
    
    crPlaySlider:SetMinMaxValues(1, #crsaveddata[crPlayingCombatID].events)
    crPlaySlider:SetValue(1)
    

  end


end

local function initialize(self, level)
local info = UIDropDownMenu_CreateInfo()
for k,v in pairs(items) do
	info = UIDropDownMenu_CreateInfo()
	info.text = v
	info.value = v
	info.func = OnClick
	UIDropDownMenu_AddButton(info, level)
end
end


UIDropDownMenu_Initialize(DropDownMenuCombatChoose, initialize)
UIDropDownMenu_SetWidth(DropDownMenuCombatChoose, 105)
UIDropDownMenu_SetButtonWidth(DropDownMenuCombatChoose, 120)
UIDropDownMenu_SetSelectedID(DropDownMenuCombatChoose,1)
UIDropDownMenu_JustifyText(DropDownMenuCombatChoose, "LEFT")
end


function crUpdateTimeLine(nr)
if crsaveddata[nr] then
  --update timeline zasechki
  local m=1 -- how much frames am I using, max 50.
  local deathrun=0
  while (m<=50) do
    --zasechki for death, red color
    if deathrun==0 and crsaveddata[crPlayingCombatID] and crsaveddata[crPlayingCombatID].death and #crsaveddata[crPlayingCombatID].death>0 then
      for i=1,#crsaveddata[crPlayingCombatID].death do
        crTimeLineButton[m]:Show()
        
        crTimeLineButton[m]:SetScript("OnEnter", function(self)
          if crsaveddata[crPlayingCombatID] and crsaveddata[crPlayingCombatID].players[crsaveddata[crPlayingCombatID].death[i].p] then
            GameTooltip:SetOwner(self or UIParent, "ANCHOR_LEFT")
            GameTooltip:SetText(crlocplayerdied.." "..crClassColors[crsaveddata[crPlayingCombatID].players[crsaveddata[crPlayingCombatID].death[i].p].class].h..crsaveddata[crPlayingCombatID].players[crsaveddata[crPlayingCombatID].death[i].p].name.."|r")
          end
        end)
        crTimeLineButton[m]:SetScript("OnLeave", function(self)
          GameTooltip:Hide()
        end)
        
        crTimeLineButton[m]:SetScript("OnClick", function(self)
        crPlaySlider:SetValue(crsaveddata[crPlayingCombatID].death[i].e)
        --выбраного игрока ставлю цветом класса:
        if crPlayersActive[1]~=crPlayersActive[2] then
          if crRangeCheckRaidActive and crRangeCheckRaidTable[crPlayersActive[1]] then
            crPlayersFramesColor[crPlayersActive[1]]:SetTexture(1, 0, 0, 1)
          else
            crPlayersFramesColor[crPlayersActive[1]]:SetTexture(crClassColors[crsaveddata[nr].players[crPlayersActive[1]].class].r, crClassColors[crsaveddata[nr].players[crPlayersActive[1]].class].g, crClassColors[crsaveddata[nr].players[crPlayersActive[1]].class].b, 1)
          end
            crPlayersButtonsColor[crPlayersActive[1]]:SetTexture(crClassColors[crsaveddata[nr].players[crPlayersActive[1]].class].r, crClassColors[crsaveddata[nr].players[crPlayersActive[1]].class].g, crClassColors[crsaveddata[nr].players[crPlayersActive[1]].class].b, 1)
            crPlayersFramesNames[crPlayersActive[1]]:Hide()
        end
        
        --удаляю с таблицы его ник
        table.remove(crPlayersActive,1)
        
        --выделяю игрока зеленым цветоми кнопку нажатой
        table.insert(crPlayersActive,crsaveddata[crPlayingCombatID].death[i].p)
        table.wipe(crInstanceSpellsShow)
        crPlayersFramesColor[crsaveddata[crPlayingCombatID].death[i].p]:SetTexture(0, 1, 0, 1)
        crPlayersButtonsColor[crsaveddata[crPlayingCombatID].death[i].p]:SetTexture(crClassColors[crsaveddata[nr].players[crsaveddata[crPlayingCombatID].death[i].p].class].r, crClassColors[crsaveddata[nr].players[crsaveddata[crPlayingCombatID].death[i].p].class].g, crClassColors[crsaveddata[nr].players[crsaveddata[crPlayingCombatID].death[i].p].class].b, 0.2)
        crPlayersFramesNames[crsaveddata[crPlayingCombatID].death[i].p]:Show()
        crUpdateFrameRight(1,0)
              --рендж чек между 2 игроков
               crGetRangeBetweenPlayers(nil,nil,0)
        end )
        crTimeLineButtonColor[m]:SetTexture(1, 0, 0, 1)
        crTimeLineButton[m]:SetPoint("LEFT",((570*crsaveddata[crPlayingCombatID].death[i].e)/#crsaveddata[crPlayingCombatID].events),0)
        m=m+1
        deathrun=1
      end
    end
    if crTimeLineButton[m]:IsShown() then
      crTimeLineButton[m]:Hide()
    else
      m=9999
    end
    m=m+1
  end
end
end



function crShowMapOnBackground(guid)
--local id=tonumber(string.sub(guid,6,10),16)
--print ("bossid: "..id)

--crMapBackground = crframecenter:CreateTexture(nil,"BACKGROUND")
--crMapBackground:SetTexture("Interface\\AddOns\\CombatReplay\\tortos")
--crMapBackground:SetPoint("CENTER",0,0)
--crMapBackground:SetTexCoord(0,1,0,1)
--crMapBackground:SetSize(700,700)
end