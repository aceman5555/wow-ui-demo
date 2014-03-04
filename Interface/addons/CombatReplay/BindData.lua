--ы
local _
function crShowCombat(nr)


if crsaveddata[nr].scale==nil then
  --1 запуск этого боя, готовим переменные
  crPrepareVariabiles(nr)
end
if crPlayingCombatID==nil then
  crPlayingCombatID=1
end

crPlaySlider:SetValue(1)
crShowEventFrame(nr,1)
end


--создает фрейм боя
function crShowEventFrame(nr,ev)

  if #crsaveddata>0 then
    if nr==nil then
      nr=1
    end
    crPlayingCombatID=nr

    --если игрок не выбран, или выбран но плохо - выбирать первого из рейда
    if (#crPlayersActive==0 and crsaveddata[nr]) or (#crPlayersActive>0 and crPlayersActive[#crPlayersActive] and crsaveddata[nr].players[crPlayersActive[#crPlayersActive]].name==nil) then
      local i=1
      while i<=25 do
        if crsaveddata[nr].players[i].name then
          crPlayersActive[1]=i
          crPlayersActive[2]=i
          crPlayersFramesNames[i]:Show()
          i=100
        end
        i=i+1
      end
    end

    --установка координат
    if crsaveddata and crsaveddata[nr] and crsaveddata[nr].events and crsaveddata[nr].events[ev] and crsaveddata[nr].events[ev].p then
      table.wipe(crLastShownPlayersCoordX)
      table.wipe(crLastShownPlayersCoordY)
      for j=1,25 do
        if crsaveddata[nr].events[ev].p[j] and j<=25 then
          local x=0
          local y=0
          local m=ev
          local bil=0
          while (m>0 and bil<2) do
            if x==0 and crsaveddata[nr].events[m].p[j].x and crsaveddata[nr].events[m].p[j].x~=0 then
              x=crsaveddata[nr].events[m].p[j].x
              crLastShownPlayersCoordX[j]=x
              bil=bil+1
            end
            if y==0 and crsaveddata[nr].events[m].p[j].y and crsaveddata[nr].events[m].p[j].y~=0 then
              y=crsaveddata[nr].events[m].p[j].y
              crLastShownPlayersCoordY[j]=y
              bil=bil+1
            end
            m=m-1
          end
          local icon=0
          m=ev
          while (m>0) do
            if crsaveddata[nr].events[m].p[j].icon then
              icon=crsaveddata[nr].events[m].p[j].icon
              m=1
            end
            m=m-1
          end
          --размещаю квадрат этого игрока на его координатах
          if x>0 and y>0 then
            crPlayersFrames[j]:SetPoint("TOPLEFT", (x-crsaveddata[nr].xmin)*crsaveddata[nr].scale+crsaveddata[nr].xadd-crPlayersSizeOnMap/2, (y-crsaveddata[nr].ymin)*crsaveddata[nr].scale*(-1)-crsaveddata[nr].yadd+crPlayersSizeOnMap/2)
          end
          --отображаю иконку если нужно
          if icon>0 then
            crPlayersFramesIcons[j]:SetTexture("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_"..icon)
            crPlayersFramesIcons[j]:Show()
          elseif crPlayersFramesIcons[j]:IsShown() then
            crPlayersFramesIcons[j]:Hide()
          end
          
          if j==crPlayersActive[1] or j==crPlayersActive[2] then
            --выбранный игрок зеленым!
            crPlayersFramesColor[j]:SetTexture(0, 1, 0, 1)
          elseif ev==1 then
            if crRangeCheckRaidActive and crRangeCheckRaidTable[j] then
              crPlayersFramesColor[j]:SetTexture(1, 0, 0, 1)
            else
              crPlayersFramesColor[j]:SetTexture(crClassColors[crsaveddata[nr].players[j].class].r, crClassColors[crsaveddata[nr].players[j].class].g, crClassColors[crsaveddata[nr].players[j].class].b, 1)
            end
          end
          
          crPlayersFramesNames[j]:SetText(crsaveddata[nr].players[j].name)
            
          --следующие приставивать только на 1 евенте
          if ev==1 then
            crPlayersFrames[j]:Show()
            crPlayersFrames[j]:SetScript("OnClick", function(self)
            if #crsaveddata>0 then
              if crPlayersActive[1]~=crPlayersActive[2] then
                if crRangeCheckRaidActive and crRangeCheckRaidTable[crPlayersActive[1]] then
                  crPlayersFramesColor[crPlayersActive[1]]:SetTexture(1, 0, 0, 1)
                else
                  crPlayersFramesColor[crPlayersActive[1]]:SetTexture(crClassColors[crsaveddata[nr].players[crPlayersActive[1]].class].r, crClassColors[crsaveddata[nr].players[crPlayersActive[1]].class].g, crClassColors[crsaveddata[nr].players[crPlayersActive[1]].class].b, 1)
                end
                crPlayersButtonsColor[crPlayersActive[1]]:SetTexture(crClassColors[crsaveddata[nr].players[crPlayersActive[1]].class].r, crClassColors[crsaveddata[nr].players[crPlayersActive[1]].class].g, crClassColors[crsaveddata[nr].players[crPlayersActive[1]].class].b, 1)
                crPlayersFramesNames[crPlayersActive[1]]:Hide()
              end
              table.remove(crPlayersActive,1)

              table.insert(crPlayersActive,j)
              table.wipe(crInstanceSpellsShow)
              crPlayersButtonsColor[j]:SetTexture(crClassColors[crsaveddata[nr].players[j].class].r, crClassColors[crsaveddata[nr].players[j].class].g, crClassColors[crsaveddata[nr].players[j].class].b, 0.2)
              crPlayersFramesColor[j]:SetTexture(0, 1, 0, 1)
              crPlayersFramesNames[j]:Show()
              crUpdateFrameRight(1,0)
              --рендж чек между 2 игроков
               crGetRangeBetweenPlayers(nil,nil,0)
            end
            end )
            

         
            --показываю кнопку слева, ник игрока и его цвет
            local alphabg=1
            if crPlayersActive[1]==j or crPlayersActive[2]==j then
              alphabg=0.2
            end
            crPlayersButtonsColor[j]:SetTexture(crClassColors[crsaveddata[nr].players[j].class].r, crClassColors[crsaveddata[nr].players[j].class].g, crClassColors[crsaveddata[nr].players[j].class].b, alphabg)
            crPlayersButtons[j]:Show()
            if crsaveddata[nr].players[j].class==4 or crsaveddata[nr].players[j].class==7 then
              crPlayersButtonsText[j]:SetText("|cffff0000"..crsaveddata[nr].players[j].name.."|r")
            else
              crPlayersButtonsText[j]:SetText(crsaveddata[nr].players[j].name)
            end
            crPlayersButtons[j]:SetScript("OnClick", function(self)
            if #crsaveddata>0 then
              if crPlayersActive[1]~=crPlayersActive[2] then
                if crRangeCheckRaidActive and crRangeCheckRaidTable[crPlayersActive[1]] then
                  crPlayersFramesColor[crPlayersActive[1]]:SetTexture(1, 0, 0, 1)
                else
                  crPlayersFramesColor[crPlayersActive[1]]:SetTexture(crClassColors[crsaveddata[nr].players[crPlayersActive[1]].class].r, crClassColors[crsaveddata[nr].players[crPlayersActive[1]].class].g, crClassColors[crsaveddata[nr].players[crPlayersActive[1]].class].b, 1)
                end
                crPlayersButtonsColor[crPlayersActive[1]]:SetTexture(crClassColors[crsaveddata[nr].players[crPlayersActive[1]].class].r, crClassColors[crsaveddata[nr].players[crPlayersActive[1]].class].g, crClassColors[crsaveddata[nr].players[crPlayersActive[1]].class].b, 1)
                crPlayersFramesNames[crPlayersActive[1]]:Hide()
              end
              table.remove(crPlayersActive,1)

              table.insert(crPlayersActive,j)
              table.wipe(crInstanceSpellsShow)
              crPlayersButtonsColor[j]:SetTexture(crClassColors[crsaveddata[nr].players[j].class].r, crClassColors[crsaveddata[nr].players[j].class].g, crClassColors[crsaveddata[nr].players[j].class].b, 0.2)
              crPlayersFramesColor[j]:SetTexture(0, 1, 0, 1)
              crPlayersFramesNames[j]:Show()
              crUpdateFrameRight(1,0)
              --рендж чек между 2 игроков
               crGetRangeBetweenPlayers(nil,nil,0)
            end
              end )
          end
        else
          crPlayersButtons[j]:Hide()
          crPlayersFrames[j]:Hide()
        end
      end
      
      crGetRangeBetweenPlayers(nr,ev,0)
      crFillRangeRaidCheckTable()
      
      --игрок красным если в рендже
      if crRangeCheckRaidActive then
        for m=1,25 do
          if crRangeCheckRaidTable[m] then
            if crPlayersActive[1]==m or crPlayersActive[2]==m then
              crPlayersFramesColor[m]:SetTexture(0, 1, 0, 1)
            else
              crPlayersFramesColor[m]:SetTexture(1, 0, 0, 1)
            end
          end
        end
      end
	  
      if ev==1 then
        --обновляю засечки под слайдером:
        crUpdateTimeLine(nr)

        --модельку босса раз за бой ставлю
        for i=1,#crBossFrameModel1 do
          if crsaveddata[nr].boss[i] then
            crBossFrameModel1[i]:SetDisplayInfo(crGetBossModelID(crsaveddata[nr].boss[i][1]))
            crBossFrameModel1[i]:Show()
          else
            crBossFrameModel1[i]:SetDisplayInfo(0)
            crBossFrameModel1[i]:Hide()
          end
      end
      crShowMapOnBackground(crGetBossModelID(crsaveddata[nr].boss[1][1]))
    end
  end
end


crPlayingCombatEvent=ev
--если двигаю слайдер во время ролика
if ev and crsaveddata[nr] and crsaveddata[nr].events[ev+1] and crPlayingCombatUpdateTime then
  crPlayingCombatTimeLast=GetTime()
  crPlayingCombatTimeNext=GetTime()+(crsaveddata[nr].events[ev+1].t-crsaveddata[nr].events[ev].t)
  crPlayingCombatUpdateTime=GetTime()+0.1
end

crShowCurrentTime(nr,ev,0)
crUpdateFrameRight(1,0)
crUpdateFrameCenterUtilities(1)
crUpdateFrameTop(1,0)


end














--создает фрейм боя, с неточными координатами "плавный переход между фреймами"
function crShowEventPlaying(changedEvent)

--как с обычным фреймом размещаю квадрат по этим координатам, только координаты беру между "будующие и прошедшие взависимости как соотносится время
if crsaveddata and crsaveddata[crPlayingCombatID] and crsaveddata[crPlayingCombatID] and crsaveddata[crPlayingCombatID].events and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1] and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p then
--высчитать в каком моменте мы находимся между переменными:
local thecurrentposition=0
thecurrentposition=(GetTime()-crPlayingCombatTimeLast)/(crPlayingCombatTimeNext-crPlayingCombatTimeLast)
if thecurrentposition>1 then
  thecurrentposition=0
end

  --так как здесь координаты меняются только если игрок двинулся
  --table.wipe(crLastShownPlayersCoordX)
  --table.wipe(crLastShownPlayersCoordY)
  for j=1,25 do
    if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[j] and (crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[j].x or crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[j].y) and j<=25 then
      --размещаю квадрат этого игрока на его координатах
      local x=0
      local y=0
      local m=crPlayingCombatEvent
      local bil=0
      while (m>0 and bil<2) do
        if x==0 and crsaveddata[crPlayingCombatID].events[m].p[j].x and crsaveddata[crPlayingCombatID].events[m].p[j].x~=0 then
          x=crsaveddata[crPlayingCombatID].events[m].p[j].x
          crLastShownPlayersCoordX[j]=x
          bil=bil+1
        end
        if y==0 and crsaveddata[crPlayingCombatID].events[m].p[j].y and crsaveddata[crPlayingCombatID].events[m].p[j].y~=0 then
          y=crsaveddata[crPlayingCombatID].events[m].p[j].y
          crLastShownPlayersCoordY[j]=y
          bil=bil+1
        end
        m=m-1
      end
      local icon=0
      m=crPlayingCombatEvent
      while (m>0) do
        if crsaveddata[crPlayingCombatID].events[m].p[j].icon then
          icon=crsaveddata[crPlayingCombatID].events[m].p[j].icon
          m=1
        end
        m=m-1
      end
      if x>0 and y>0 then
        if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[j].x and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[j].y then
          crPlayersFrames[j]:SetPoint("TOPLEFT", (((((crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[j].x-x)*thecurrentposition)+x)-crsaveddata[crPlayingCombatID].xmin)*crsaveddata[crPlayingCombatID].scale)+crsaveddata[crPlayingCombatID].xadd - crPlayersSizeOnMap/2, (((((crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[j].y-y)*thecurrentposition)+y)-crsaveddata[crPlayingCombatID].ymin)*crsaveddata[crPlayingCombatID].scale*(-1))-crsaveddata[crPlayingCombatID].yadd + crPlayersSizeOnMap/2)
        elseif crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[j].x then
          crPlayersFrames[j]:SetPoint("TOPLEFT", (((((crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[j].x-x)*thecurrentposition)+x)-crsaveddata[crPlayingCombatID].xmin)*crsaveddata[crPlayingCombatID].scale)+crsaveddata[crPlayingCombatID].xadd - crPlayersSizeOnMap/2, ((y-crsaveddata[crPlayingCombatID].ymin)*crsaveddata[crPlayingCombatID].scale*(-1))-crsaveddata[crPlayingCombatID].yadd + crPlayersSizeOnMap/2)
        else
          crPlayersFrames[j]:SetPoint("TOPLEFT", ((x-crsaveddata[crPlayingCombatID].xmin)*crsaveddata[crPlayingCombatID].scale)+crsaveddata[crPlayingCombatID].xadd - crPlayersSizeOnMap/2, (((((crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[j].y-y)*thecurrentposition)+y)-crsaveddata[crPlayingCombatID].ymin)*crsaveddata[crPlayingCombatID].scale*(-1))-crsaveddata[crPlayingCombatID].yadd + crPlayersSizeOnMap/2)
        end
      end
      --отображаю иконку если нужно
      if icon>0 then
        crPlayersFramesIcons[j]:SetTexture("Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_"..icon)
        crPlayersFramesIcons[j]:Show()
      elseif crPlayersFramesIcons[j]:IsShown() then
        crPlayersFramesIcons[j]:Hide()
      end
    else
      --if the player doesn't exists anymore BUT it was at the beginning - HIDE frame
      if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[j]==nil and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[j]==nil and crsaveddata[crPlayingCombatID].events[1].p[j] then
        crPlayersButtons[j]:Hide()
        crPlayersFrames[j]:Hide()
      end
    end
  end
  
  
  -- раз в 0.5 сек!
  if changedEvent==1 then
    crGetRangeBetweenPlayers(crPlayingCombatID,crPlayingCombatEvent,thecurrentposition)
    crFillRangeRaidCheckTable()
    --игрок красным если в рендже
    if crRangeCheckRaidActive then
      for m=1,25 do
        if crRangeCheckRaidTable[m] then
          if crPlayersActive[1]==m or crPlayersActive[2]==m then
            crPlayersFramesColor[m]:SetTexture(0, 1, 0, 1)
          else
            crPlayersFramesColor[m]:SetTexture(1, 0, 0, 1)
          end
        end
      end
    end
  end
  
  --показывает текущее время
  crShowCurrentTime(crPlayingCombatID,crPlayingCombatEvent,thecurrentposition)
  
  --if changedEvent then--правый фрейм все же обновляем постоянно или хотя бы ЧАСТИЧНО ТОЛЬКО КАСТ
  crUpdateFrameRight(changedEvent,thecurrentposition)
  crUpdateFrameCenterUtilities(changedEvent)
  crUpdateFrameTop(changedEvent,thecurrentposition)
  --end
end

end


--воспроизведение записи боя
function crPlayReplay(nr,speed)
table.wipe(crInstanceSpellsShow)
crPlaySpeed=speed
  if crsaveddata[crPlayingCombatID] then
    --стартовать повтор зависимо от слайдера, его позиция. бой сначала или с середины?
    if nr==nil then
      nr=1
    end

    crPlayingCombatID=nr -- какой бой смотрим
    crPlayingCombatEvent=math.floor(crPlaySlider:GetValue()) --евент который уже прошел
    if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1] then
      crPlayingCombatTimeLast=GetTime()
      crPlayingCombatTimeNext=GetTime()+((crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].t-crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t)/speed)
      crPlayingCombatUpdateTime=GetTime()
    end

    crButtonPlay:Hide()
    crButtonStop:Show()
    crButtonNextEvent:Hide()
    crButtonPreviousEvent:Hide()
  end
end



function crStopReplay()
  crPlayingCombatUpdateTime=nil
  crButtonPlay:Show()
  crButtonStop:Hide()
  crButtonNextEvent:Show()
  crButtonPreviousEvent:Show()
end
















function crUpdateFrameRight(changedEvent,thecurrentposition)
if crsaveddata[crPlayingCombatID] then

  --если плеер больше не существует:
  if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]]==nil or (crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1] and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[crPlayersActive[#crPlayersActive]]==nil) then
   local i=1
   while i<=#crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p do
      if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[i] and (crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1]==nil or (crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p)) then
              crPlayersButtonsColor[crPlayersActive[#crPlayersActive]]:SetTexture(crClassColors[crsaveddata[crPlayingCombatID].players[crPlayersActive[#crPlayersActive]].class].r, crClassColors[crsaveddata[crPlayingCombatID].players[crPlayersActive[#crPlayersActive]].class].g, crClassColors[crsaveddata[crPlayingCombatID].players[crPlayersActive[#crPlayersActive]].class].b, 1)
              crPlayersFramesColor[crPlayersActive[#crPlayersActive]]:SetTexture(crClassColors[crsaveddata[crPlayingCombatID].players[crPlayersActive[#crPlayersActive]].class].r, crClassColors[crsaveddata[crPlayingCombatID].players[crPlayersActive[#crPlayersActive]].class].g, crClassColors[crsaveddata[crPlayingCombatID].players[crPlayersActive[#crPlayersActive]].class].b, 1)
              crPlayersFramesNames[crPlayersActive[#crPlayersActive]]:Hide()
              table.remove(crPlayersActive,1)
              table.insert(crPlayersActive,i)
              table.wipe(crInstanceSpellsShow)
              crPlayersButtonsColor[i]:SetTexture(crClassColors[crsaveddata[crPlayingCombatID].players[i].class].r, crClassColors[crsaveddata[crPlayingCombatID].players[i].class].g, crClassColors[crsaveddata[crPlayingCombatID].players[i].class].b, 0.2)
              crPlayersFramesColor[i]:SetTexture(0, 1, 0, 1)
              crPlayersFramesNames[i]:Show()
              i=100
              --рендж чек между 2 игроков
              crGetRangeBetweenPlayers(nil,nil,0)
      end
      i=i+1
    end
  end


  local maxletters=15
  if GetLocale()=="ruRU" then
    maxletters=32
  end

  local text=crsaveddata[crPlayingCombatID].players[crPlayersActive[#crPlayersActive]].name
  if string.len(text)>maxletters then
    text=string.sub(text,1,maxletters+3)..".."
  end
  text=crClassColors[crsaveddata[crPlayingCombatID].players[crPlayersActive[#crPlayersActive]].class].h..text.."|r"
  text=text.."\nClass: "..crClassColors[crsaveddata[crPlayingCombatID].players[crPlayersActive[#crPlayersActive]].class].c
  local target="|cffff0000"..crlocempty.."|r"
  local tnr=crPlayingCombatEvent
  local taregetid=0
  while (tnr>0 and target=="|cffff0000"..crlocempty.."|r") do
    if crsaveddata[crPlayingCombatID].events[tnr].p[crPlayersActive[#crPlayersActive]].t then
      if (crsaveddata[crPlayingCombatID].events[tnr].p[crPlayersActive[#crPlayersActive]].t.id and crsaveddata[crPlayingCombatID].events[tnr].p[crPlayersActive[#crPlayersActive]].t.id~=0) then
        taregetid=crsaveddata[crPlayingCombatID].events[tnr].p[crPlayersActive[#crPlayersActive]].t.id
        if crsaveddata[crPlayingCombatID].events[tnr].p[crPlayersActive[#crPlayersActive]].t.id>50 then
          target=crsaveddata[crPlayingCombatID].boss[crsaveddata[crPlayingCombatID].events[tnr].p[crPlayersActive[#crPlayersActive]].t.id-50][2]
          if string.len(target)>maxletters-2 then
            target=string.sub(target,1,maxletters-4)..".."
          end
        else
          target=crsaveddata[crPlayingCombatID].players[crsaveddata[crPlayingCombatID].events[tnr].p[crPlayersActive[#crPlayersActive]].t.id].name
          if string.len(target)>maxletters-2 then
            target=string.sub(target,1,maxletters-4)..".."
          end
          target=crClassColors[crsaveddata[crPlayingCombatID].players[crsaveddata[crPlayingCombatID].events[tnr].p[crPlayersActive[#crPlayersActive]].t.id].class].h..target.."|r"
        end
        tnr=0
      elseif crsaveddata[crPlayingCombatID].events[tnr].p[crPlayersActive[#crPlayersActive]].t.i and crsaveddata[crPlayingCombatID].events[tnr].p[crPlayersActive[#crPlayersActive]].t.i~=0 then
        target=crsaveddata[crPlayingCombatID].events[tnr].p[crPlayersActive[#crPlayersActive]].t.n
        taregetid=crsaveddata[crPlayingCombatID].events[tnr].p[crPlayersActive[#crPlayersActive]].t.i
        if string.len(target)>maxletters-2 then
          target=string.sub(target,1,maxletters-4)..".."
        end
        tnr=0
      elseif (crsaveddata[crPlayingCombatID].events[tnr].p[crPlayersActive[#crPlayersActive]].t.i and crsaveddata[crPlayingCombatID].events[tnr].p[crPlayersActive[#crPlayersActive]].t.i==0) or (crsaveddata[crPlayingCombatID].events[tnr].p[crPlayersActive[#crPlayersActive]].t.id and crsaveddata[crPlayingCombatID].events[tnr].p[crPlayersActive[#crPlayersActive]].t.id==0) then
        tnr=0
      end
      
    end
    tnr=tnr-1
  end
  --йфя
  if taregetid~=0 then
      --высчитываем список тех, кто таргетит сейчас этого моба
      local num=0
      crPlayerTargetAssistList=""
      for pl=1,25 do
        if crsaveddata[crPlayingCombatID].players[pl] and crsaveddata[crPlayingCombatID].players[pl].name then
          local tnr=crPlayingCombatEvent
          while tnr>0 do
            if crsaveddata[crPlayingCombatID].events[tnr].p and crsaveddata[crPlayingCombatID].events[tnr].p[pl] and crsaveddata[crPlayingCombatID].events[tnr].p[pl].t and (crsaveddata[crPlayingCombatID].events[tnr].p[pl].t.id or crsaveddata[crPlayingCombatID].events[tnr].p[pl].t.i) then
              if ((crsaveddata[crPlayingCombatID].events[tnr].p[pl].t.id and crsaveddata[crPlayingCombatID].events[tnr].p[pl].t.id==taregetid) or (crsaveddata[crPlayingCombatID].events[tnr].p[pl].t.i and crsaveddata[crPlayingCombatID].events[tnr].p[pl].t.i==taregetid)) then
                num=num+1
                if string.len (crPlayerTargetAssistList)>2 then
                  crPlayerTargetAssistList=crPlayerTargetAssistList..", "
                end
                if (num%4==0) then
                  crPlayerTargetAssistList=crPlayerTargetAssistList.."\n"
                end
                crPlayerTargetAssistList=crPlayerTargetAssistList..crClassColors[crsaveddata[crPlayingCombatID].players[pl].class].h..crsaveddata[crPlayingCombatID].players[pl].name.."|r"
              end
              tnr=0
            end
            tnr=tnr-1
          end
        end
      end
      crPlayerTargetAssist:SetText("|cff00ff00["..num.."]|r")
      crPlayerTargetAssist:Show()
      
      if crPlayerTargetToolTipActive then
        GameTooltip:SetText(crPlayerTargetAssistList)
      end
  else
    crPlayerTargetAssist:Hide()
  end
      

  text=text.."\n    "..crloctarget.." "..target
  
  --только раз в 0.5 сек!!!
  if changedEvent==1 then

    --HP Bar
    local hp1=0
    if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].hp1 then
      hp1=crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].hp1
    else
      local bil=crPlayingCombatEvent
      while (bil>0) do
        if crsaveddata[crPlayingCombatID].events[bil].p[crPlayersActive[#crPlayersActive]].hp1 then
          hp1=crsaveddata[crPlayingCombatID].events[bil].p[crPlayersActive[#crPlayersActive]].hp1
          bil=0
        end
        bil=bil-1
      end
    end
    
    local hp2=0
    if crsaveddata[crPlayingCombatID].players[crPlayersActive[#crPlayersActive]].hp2 then
      hp2=crsaveddata[crPlayingCombatID].players[crPlayersActive[#crPlayersActive]].hp2
    else
      if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].hp2 then
        hp2=crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].hp2
      else
        local bil=crPlayingCombatEvent
        while (bil>0) do
          if crsaveddata[crPlayingCombatID].events[bil].p[crPlayersActive[#crPlayersActive]].hp2 then
            hp2=crsaveddata[crPlayingCombatID].events[bil].p[crPlayersActive[#crPlayersActive]].hp2
            bil=0
          end
          bil=bil-1
        end
      end
    end

    crHPBar3:SetText(crDamageCeil(hp1).." / "..crDamageCeil(hp2))
    if hp1==0 then
      crHPBar2:SetWidth(0.001)
    else
      crHPBar2:SetWidth((hp1*176)/hp2)
    end
    if hp1/hp2<=0.3 then
      crHPBar2:SetTexture(1, 0, 0, 0.7)
    else
      crHPBar2:SetTexture(0, 1, 0, 0.7)
    end
	
	
	--new 5.4.2
	--высчитываем общее количество ХП всех игроков рейда
	
	--/script crPlayersButtonsColor[2]:SetWidth(133)
	-- отображаем заодно размер фреймов по хп игроков
	
	local totalhp1=0
	local totalhp2=0
	for tpl=1,25 do
		local thisplayerhp1=0
		local thisplayerhp2=0
		if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[tpl] then
			if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[tpl].hp1 then
				totalhp1=totalhp1+crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[tpl].hp1
				thisplayerhp1=crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[tpl].hp1
			else
			  local bil=crPlayingCombatEvent
			  while (bil>0) do
				if crsaveddata[crPlayingCombatID].events[bil].p[tpl].hp1 then
					totalhp1=totalhp1+crsaveddata[crPlayingCombatID].events[bil].p[tpl].hp1
					thisplayerhp1=crsaveddata[crPlayingCombatID].events[bil].p[tpl].hp1
					bil=0
				end
				bil=bil-1
			  end
			end
		end
		if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[tpl] then
			if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[tpl].hp2 then
				totalhp2=totalhp2+crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[tpl].hp2
				thisplayerhp2=crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[tpl].hp2
			else
			  local bil=crPlayingCombatEvent
			  while (bil>0) do
				if crsaveddata[crPlayingCombatID].events[bil].p[tpl].hp2 then
					totalhp2=totalhp2+crsaveddata[crPlayingCombatID].events[bil].p[tpl].hp2
					thisplayerhp2=crsaveddata[crPlayingCombatID].events[bil].p[tpl].hp2
					bil=0
				end
				bil=bil-1
			  end
			end
		end
		
		--отображаем фрейм другим, если вкл
		if crShowPlayersHpDynamic then
			--ыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыыы
			if thisplayerhp1==0 then
			  crPlayersButtonsColor[tpl]:SetWidth(0.001)
			else
			  crPlayersButtonsColor[tpl]:SetWidth((thisplayerhp1*128)/thisplayerhp2)
			end
		end
		
	end

	--отображаем полоску с ХП и подписываем % зеленого ХП.
	
	--ВАЖНО!!! изменяя высоту фрайма менять здесь цифры и в др месте тоже!  в уи
	local totalRaidHpPerc=math.ceil((totalhp1/totalhp2)*100)
    crRaidHPBar3:SetText(totalRaidHpPerc.."\n%")
	crRaidHPBar32:SetText("%\n"..totalRaidHpPerc)
    if totalhp1==0 then
      crRaidHPBar2:SetHeight(0.001)
    else
      crRaidHPBar2:SetHeight((totalhp1*950)/totalhp2)
    end
    if totalhp1/totalhp2<=0.3 then
      crRaidHPBar2:SetTexture(1, 0, 0, 0.7)
    else
      crRaidHPBar2:SetTexture(0, 1, 0, 0.7)
    end
	

    --дебаффы
    if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].deb and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].deb[1] then
      for i=1,#crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].deb do
      
        local _, _, icon = GetSpellInfo(crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].deb[i].id)
        local tm=""
        if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].deb[i].exp then
          --if crPlayingCombatTimeLast then
          --  tm=math.floor((crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].deb[i].exp-crPlayingCombatTimeLast)*10)/10
          --else
            tm=math.floor((crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].deb[i].exp-crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t)*10)/10
            if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].deb[i].exp==0 then
              tm=""
            elseif tm>60 then
              local min=math.floor(tm/60)
              local sec=math.floor(tm%60)
              if sec<10 then
                sec="0"..sec
              end
              tm=min..":"..sec
            end
          --end
        end
        
        --сколько стаков
        if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].deb[i].c then
          if tm=="" then
            tm="["..crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].deb[i].c.."]"
          else
            tm="["..crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].deb[i].c.."] "..tm
          end
        end
        
        if i<=15 then
          crPalyerDebuffTable[i]=crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].deb[i].id
          crDebuffFramesRightIcon[i]:SetTexture(icon)
          crDebuffFramesRightFrame[i]:Show()
          crDebuffFramesRightText[i]:SetText(tm)
          crDebuffFramesRightText[i]:Show()
        end
        
      end
      if #crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].deb<15 then
        local j=#crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].deb+1
        while j<=15 do
          if crDebuffFramesRightFrame[j]:IsShown() then
            crDebuffFramesRightFrame[j]:Hide()
            crDebuffFramesRightText[j]:Hide()
          else
            j=50
          end
          j=j+1
        end
      end
    else
      --если дебафов нет, убирать показаные
        local j=1
        while j<=15 do
          if crDebuffFramesRightFrame[j]:IsShown() then
            crDebuffFramesRightFrame[j]:Hide()
            crDebuffFramesRightText[j]:Hide()
          else
            j=50
          end
          j=j+1
        end
    end
    
    --табл для хистори кастов
    local casthistory={}
    local starthistoryhere=0
    
    --добавлять инстанс касты в список
    table.wipe(crInstanceSpellsShow)
    local spellsVisible=1
    local timeToLook=crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t-2
    if #crsaveddata[crPlayingCombatID].casts[crPlayersActive[#crPlayersActive]]>1 then
      local s=2
      while s<=#crsaveddata[crPlayingCombatID].casts[crPlayersActive[#crPlayersActive]] do
        if crsaveddata[crPlayingCombatID].casts[crPlayersActive[#crPlayersActive]][s][2]>timeToLook then
          if starthistoryhere==nil then
            starthistoryhere=s
          end
          if crsaveddata[crPlayingCombatID].casts[crPlayersActive[#crPlayersActive]][s][2]>timeToLook+5 then
            s=#crsaveddata[crPlayingCombatID].casts[crPlayersActive[#crPlayersActive]]
          else
            if crsaveddata[crPlayingCombatID].casts[crPlayersActive[#crPlayersActive]][s][3]==0 then
              table.insert(crInstanceSpellsShow,{})
              crInstanceSpellsShow[#crInstanceSpellsShow][1]=crsaveddata[crPlayingCombatID].casts[crPlayersActive[#crPlayersActive]][s][1]
              crInstanceSpellsShow[#crInstanceSpellsShow][2]=GetTime()+(crsaveddata[crPlayingCombatID].casts[crPlayersActive[#crPlayersActive]][s][2]-timeToLook)
            end
            --отображать сразу
            if crsaveddata[crPlayingCombatID].casts[crPlayersActive[#crPlayersActive]][s][2]<=timeToLook+2 then
              starthistoryhere=s
              if crsaveddata[crPlayingCombatID].casts[crPlayersActive[#crPlayersActive]][s][3]==0 and crInstanceCastsFrames[#crInstanceSpellsShow] then
                local _, _, icon = GetSpellInfo(crsaveddata[crPlayingCombatID].casts[crPlayersActive[#crPlayersActive]][s][1])
                crInstanceCastsFrames[#crInstanceSpellsShow]:SetTexture(icon)
                if crInstanceCastsFrames2[#crInstanceSpellsShow]:IsShown()==nil then
                  crInstanceCastsFrames2[#crInstanceSpellsShow]:Show()
                end
                spellsVisible=spellsVisible+1
                local position=(crsaveddata[crPlayingCombatID].casts[crPlayersActive[#crPlayersActive]][s][2]-timeToLook)/2
                crInstanceCastsFrames2[#crInstanceSpellsShow]:SetPoint("TOPLEFT",180*position,-180)
              end
            end
          end
        end
      s=s+1
      end
    end
    --убираю спелы что не надо отображать
    local m=spellsVisible
    while m<=#crInstanceCastsFrames do
      if crInstanceCastsFrames2[m]:IsShown() then
        crInstanceCastsFrames2[m]:Hide()
      else
        --m=100
      end
      m=m+1
    end
    
    -- заполняю таблицу с спелл хистори
    if starthistoryhere==0 then
      starthistoryhere=#crsaveddata[crPlayingCombatID].casts[crPlayersActive[#crPlayersActive]]
    end
    while starthistoryhere>0 do
      if crsaveddata[crPlayingCombatID].casts[crPlayersActive[#crPlayersActive]][starthistoryhere][2]<crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t then
        if #casthistory<10 then
          if crsaveddata[crPlayingCombatID].casts[crPlayersActive[#crPlayersActive]][starthistoryhere][2]~=0 then
            table.insert(casthistory,{{},{},{}})
            casthistory[#casthistory][2]=crsaveddata[crPlayingCombatID].casts[crPlayersActive[#crPlayersActive]][starthistoryhere][2]
            casthistory[#casthistory][1]=crsaveddata[crPlayingCombatID].casts[crPlayersActive[#crPlayersActive]][starthistoryhere][1]
            casthistory[#casthistory][3]=crsaveddata[crPlayingCombatID].casts[crPlayersActive[#crPlayersActive]][starthistoryhere][3] --длина каста
          end
        else
          starthistoryhere=0
        end
      end
      starthistoryhere=starthistoryhere-1
    end


    --отображаю спелл хистори
    local txthis=crloclastcasts.."\n"
    for i=1,10 do
      if casthistory[i] then
        local tm=""
        local stm=math.ceil((crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t-casthistory[i][2])*10)/10
        if stm<10 then
          if stm%1==0 then
            stm=stm..".0"
          end
          stm="0"..stm
        else
          if stm%1==0 then
            stm=stm..".0"
          end
        end
        stm="-"..stm.." "
        if casthistory[i][3]~=0 then
          tm=" ("..casthistory[i][3]..")"
        end
        local splname=GetSpellInfo(casthistory[i][1])
        if splname==nil then
          splname=casthistory[i][1]
        end
        txthis=txthis..stm..splname..tm.."\n"
      else
        txthis=txthis.."\n"
      end
    end
    if #casthistory>0 then
      if crRightSpellHistory:IsShown()==nil then
        crRightSpellHistory:Show()
      end
    else
      if crRightSpellHistory:IsShown() then
        crRightSpellHistory:Hide()
      end
    end
    crRightSpellHistory:SetText(txthis)
    
    
        
  else
    --ТОЛЬКО ЕСЛИ время МЕЖДУ ЕВЕНТАМИ!!!
    --отображение инстанс спеллов
    local i=1
    local spellsVisible=1
    while i<=#crInstanceSpellsShow do
      if crInstanceSpellsShow[i] then

        --проверка не дошел ли до конца дебаф
        if GetTime()>crInstanceSpellsShow[i][2] then
          table.remove(crInstanceSpellsShow,i)
          crInstanceCastsFrames2[i]:Hide()
          i=i-1
        else
          if crInstanceSpellsShow[i][2]<GetTime()+2 and crInstanceCastsFrames2[i] then
            local position=(crInstanceSpellsShow[i][2]-GetTime())/2
            if crInstanceCastsFrames2[i] and crInstanceCastsFrames2[i]:IsShown()==nil then
              crInstanceCastsFrames2[i]:Show()
            end
            spellsVisible=spellsVisible+1
            crInstanceCastsFrames2[i]:SetPoint("TOPLEFT",180*position,-180)
            local _, _, icon = GetSpellInfo(crInstanceSpellsShow[i][1])
            crInstanceCastsFrames[i]:SetTexture(icon)
          end
        end
      end
      i=i+1
    end
    
    --убираю спелы что не надо отображать
    local m=spellsVisible
    while m<=#crInstanceCastsFrames2 do
      if crInstanceCastsFrames2[m]:IsShown() then
        crInstanceCastsFrames2[m]:Hide()
      else
        m=100
      end
      m=m+1
    end
  end




  if thecurrentposition and (crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].cast or (crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1] and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[crPlayersActive[#crPlayersActive]].cast)) then
  
    local casttime=0
    local curspelltime=1
    local icon =""
    if crCurrentlyCastingSpellPlayer==nil then
      crCurrentlyCastingSpellPlayer=""
    end

    if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].cast then
      casttime=math.floor((crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].cast.e-crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].cast.s)*100)/100
      if crPlayingCombatTimeLast then
        curspelltime=(crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t-crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].cast.s)+((crPlayingCombatTimeNext-crPlayingCombatTimeLast)*thecurrentposition)
      else
        curspelltime=(crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t-crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].cast.s)
      end
      _, _, icon = GetSpellInfo(crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].cast.n)
      if crCurrentlyCastingSpellPlayer~=crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].cast.n then
        crCurrentlyCastingSpellPlayer=crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].p[crPlayersActive[#crPlayersActive]].cast.n
        if crPlayerCastMouseOverActive then
          GameTooltip:SetText(GetSpellInfo(crCurrentlyCastingSpellPlayer).."\n"..GetSpellDescription(crCurrentlyCastingSpellPlayer))
        end
      end

    end
    
    if curspelltime>casttime then
    --если каст докастился, проверять, а не начнется ли каститься новый каст, и сделать ПРЕЖДЕВРЕМЕННЫЙ КАСТ ЕГО!!!!
      if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1] and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[crPlayersActive[#crPlayersActive]].cast then
        casttime=math.floor((crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[crPlayersActive[#crPlayersActive]].cast.e-crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[crPlayersActive[#crPlayersActive]].cast.s)*100)/100
        if crPlayingCombatTimeLast then
        curspelltime=(crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t-crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[crPlayersActive[#crPlayersActive]].cast.s)+((crPlayingCombatTimeNext-crPlayingCombatTimeLast)*thecurrentposition)
        else
        curspelltime=(crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t-crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[crPlayersActive[#crPlayersActive]].cast.s)
        end
        _, _, icon = GetSpellInfo(crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[crPlayersActive[#crPlayersActive]].cast.n)
        if crCurrentlyCastingSpellPlayer~=crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[crPlayersActive[#crPlayersActive]].cast.n then
          crCurrentlyCastingSpellPlayer=crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].p[crPlayersActive[#crPlayersActive]].cast.n
          if crPlayerCastMouseOverActive then
            GameTooltip:SetText(GetSpellInfo(crCurrentlyCastingSpellPlayer).."\n"..GetSpellDescription(crCurrentlyCastingSpellPlayer))
          end
        end
      end
    end


    
    if curspelltime>0 then
      crCastBar5:SetTexture(icon)
      
      crCastBar4:SetText(casttime.." "..crlocsec)

      if casttime>curspelltime then
        crCastBar2:SetWidth((curspelltime*152)/casttime)
        crCastBar1:Show()
      else
        if crCastBar1:IsShown() then
          crCastBar1:Hide()
        end
      end
    else
      if crCastBar1:IsShown() then
        crCastBar1:Hide()
      end
    end
  else
    if crCastBar1:IsShown() then
      crCastBar1:Hide()
    end
  end


  crRightInfoText:SetText(text)

end
end





function crUpdateFrameCenterUtilities(changedEvent)
if crsaveddata[crPlayingCombatID] then
--только раз в 0.5 сек!!!
if changedEvent==1 then

    local buffShowIn=1
    if crsaveddata[crPlayingCombatID].buffs then
      for i=1,#crsaveddata[crPlayingCombatID].buffs do
        if crsaveddata[crPlayingCombatID].buffs[i].t<crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t and crsaveddata[crPlayingCombatID].buffs[i].tf>crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t then
          local _, _, icon = GetSpellInfo(crsaveddata[crPlayingCombatID].buffs[i].id)
          local tm=""
          if crsaveddata[crPlayingCombatID].buffs[i].tf then
            tm=math.floor((crsaveddata[crPlayingCombatID].buffs[i].tf-crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t)*10)/10
          end

          crRaidBuffFramesIcon[buffShowIn]:SetTexture(icon)
          crRaidBuffFramesIcon[buffShowIn]:Show()
          crRaidBuffFramesText[buffShowIn]:SetText(tm)
          crRaidBuffFramesText[buffShowIn]:Show()
          
          buffShowIn=buffShowIn+1
        end

      end
    end
    local max=1
    if crsaveddata[crPlayingCombatID].buffs then
      max=#crsaveddata[crPlayingCombatID].buffs
    end
    if buffShowIn<=max then
    local j=buffShowIn
      while j<=max do
        if crRaidBuffFramesIcon[j]:IsShown() then
          crRaidBuffFramesIcon[j]:Hide()
          crRaidBuffFramesText[j]:Hide()
        else
          j=99
        end
        j=j+1
      end
    end
end
end
end














function crUpdateFrameTop(changedEvent,thecurrentposition)
if crsaveddata[crPlayingCombatID] then

--некоторые вещи раз в 0.5 сек
if changedEvent==1 then

    
  --ыытест если ячейки босса нет значит босс недоступен !!!!!!!!!!!!!!!!!
  for i=1,#crsaveddata[crPlayingCombatID].boss do
  if i<=4 then
    local bossIsNotTargeted=0
    if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i]==nil then
      bossIsNotTargeted=1
    end
    --HP Bar
    local hp1=0
    if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i] and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].hp1 then
      hp1=crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].hp1
    else
      local bil=crPlayingCombatEvent
      while (bil>0) do
        if crsaveddata[crPlayingCombatID].events[bil].b[i] and crsaveddata[crPlayingCombatID].events[bil].b[i].hp1 then
          hp1=crsaveddata[crPlayingCombatID].events[bil].b[i].hp1
          bil=0
        end
        bil=bil-1
      end
    end
    
    local hp2=0
    if crsaveddata[crPlayingCombatID].boss[i].hp2 then
      hp2=crsaveddata[crPlayingCombatID].boss[i].hp2
    else
      if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i] and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].hp2 then
        hp2=crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].hp2
      else
        local bil=crPlayingCombatEvent
        while (bil>0) do
          if crsaveddata[crPlayingCombatID].events[bil].b[i] and crsaveddata[crPlayingCombatID].events[bil].b[i].hp2 then
            hp2=crsaveddata[crPlayingCombatID].events[bil].b[i].hp2
            bil=0
          end
          bil=bil-1
        end
      end
    end
    
    --power bar
    local po1=0
    if crsaveddata[crPlayingCombatID].boss[i].po1 then
      po1=crsaveddata[crPlayingCombatID].boss[i].po1
    else
      if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i] and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].po1 then
        po1=crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].po1
      else
        local bil=crPlayingCombatEvent
        while (bil>0) do
          if crsaveddata[crPlayingCombatID].events[bil].b[i] and crsaveddata[crPlayingCombatID].events[bil].b[i].po1 then
            po1=crsaveddata[crPlayingCombatID].events[bil].b[i].po1
            bil=0
          end
          bil=bil-1
        end
      end
    end
    local po2=0
    if crsaveddata[crPlayingCombatID].boss[i].po2 then
      po2=crsaveddata[crPlayingCombatID].boss[i].po2
    else
      if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i] and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].po2 then
        po2=crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].po2
      else
        local bil=crPlayingCombatEvent
        while (bil>0) do
          if crsaveddata[crPlayingCombatID].events[bil].b[i] and crsaveddata[crPlayingCombatID].events[bil].b[i].po2 then
            po2=crsaveddata[crPlayingCombatID].events[bil].b[i].po2
            bil=0
          end
          bil=bil-1
        end
      end
    end
    
    
    local maxletters=12
    if GetLocale()=="ruRU" then
      maxletters=24
    end
            
    local text=crsaveddata[crPlayingCombatID].boss[i][2]
    if string.len(text)>maxletters then
      text=string.sub(text,1,maxletters+3)..".."
    end
    local target="|cffff0000"..crlocempty.."|r"
    local tnr=crPlayingCombatEvent
    while (tnr>0 and target=="|cffff0000"..crlocempty.."|r") do
        if crsaveddata[crPlayingCombatID].events[tnr].b[i] and crsaveddata[crPlayingCombatID].events[tnr].b[i].tid and crsaveddata[crPlayingCombatID].events[tnr].b[i].tid~=0 then
          if crsaveddata[crPlayingCombatID].events[tnr].b[i].tid>50 then
            target=crsaveddata[crPlayingCombatID].boss[crsaveddata[crPlayingCombatID].events[tnr].b[i].tid-50][2]
          else
            local namet=crsaveddata[crPlayingCombatID].players[crsaveddata[crPlayingCombatID].events[tnr].b[i].tid].name
            if string.len(namet)>maxletters then
              namet=string.sub(namet,1,maxletters-2)..".."
            end
            target=crClassColors[crsaveddata[crPlayingCombatID].players[crsaveddata[crPlayingCombatID].events[tnr].b[i].tid].class].h..namet.."|r"
          end
          tnr=0
        elseif crsaveddata[crPlayingCombatID].events[tnr].b[i] and crsaveddata[crPlayingCombatID].events[tnr].b[i].tn and crsaveddata[crPlayingCombatID].events[tnr].b[i].tn~=0 then
          local namet=crsaveddata[crPlayingCombatID].events[tnr].b[i].tn
          if string.len(namet)>maxletters then
            namet=string.sub(namet,1,maxletters-2)..".."
          end
          target=namet
          tnr=0
        elseif crsaveddata[crPlayingCombatID].events[tnr].b[i] and crsaveddata[crPlayingCombatID].events[tnr].b[i].tn and crsaveddata[crPlayingCombatID].events[tnr].b[i].tn==0 then
          tnr=0
        end
      tnr=tnr-1
    end
    text=text.."\n"..crloctarget.." "..target

    if crHPBarBoss11[i] then
      crHPBarBoss11[i]:Show()
    end
    
    crHPBarBoss14[i]:SetText(crDamageCeil(hp1,1).." / "..crDamageCeil(hp2,1))
    if hp1==0 then
      crHPBarBoss12[i]:SetWidth(0.001)
    else
      crHPBarBoss12[i]:SetWidth((hp1*126)/hp2)
    end
    crHPBarBoss12[i]:SetTexture(0, 1, 0, 0.7)
    
    if po1==0 then
      crPowerBarBoss1[i]:SetWidth(0.001)
    elseif po2>0 then
      crPowerBarBoss1[i]:SetWidth((po1*126)/po2)
    end
    
    if (bossIsNotTargeted==1) then
      crBossFrameName1[i]:SetText("boss not in combat") --ыытест
      crBossFrameAssists[i]:Hide()
    else
      crBossFrameName1[i]:SetText(text)
      crBossFrameName1[i]:Show()
      --высчитываем список тех, кто таргетит сейчас этого босса
      local num=0
      crBossAssists[i]=""
      for pl=1,25 do
        if crsaveddata[crPlayingCombatID].players[pl] and crsaveddata[crPlayingCombatID].players[pl].name then
          local tnr=crPlayingCombatEvent
          while tnr>0 do
            if crsaveddata[crPlayingCombatID].events[tnr].p and crsaveddata[crPlayingCombatID].events[tnr].p[pl] and crsaveddata[crPlayingCombatID].events[tnr].p[pl].t and crsaveddata[crPlayingCombatID].events[tnr].p[pl].t.id then
              if (crsaveddata[crPlayingCombatID].events[tnr].p[pl].t.id==50+i) then
                num=num+1
                if string.len (crBossAssists[i])>2 then
                  crBossAssists[i]=crBossAssists[i]..", "
                end
                if (num%4==0) then
                  crBossAssists[i]=crBossAssists[i].."\n"
                end
                crBossAssists[i]=crBossAssists[i]..crClassColors[crsaveddata[crPlayingCombatID].players[pl].class].h..crsaveddata[crPlayingCombatID].players[pl].name.."|r"
              end
              tnr=0
            elseif crsaveddata[crPlayingCombatID].events[tnr].p and crsaveddata[crPlayingCombatID].events[tnr].p[pl] and crsaveddata[crPlayingCombatID].events[tnr].p[pl].t and crsaveddata[crPlayingCombatID].events[tnr].p[pl].t.i and crsaveddata[crPlayingCombatID].events[tnr].p[pl].t.i then
              tnr=0
            end
            tnr=tnr-1
          end
        end
      end
      crBossFrameAssists[i]:SetText("|cff00ff00["..num.."]|r")
      crBossFrameAssists[i]:Show()
      
      if crBossTargetToolTipActive and crBossTargetToolTipActive==i then
        GameTooltip:SetText(crBossAssists[i])
      end
    end



    --баффы боссов
    if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i] and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].buff and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].buff[1] then
      for b=1,#crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].buff do
      
        local _, _, icon = GetSpellInfo(crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].buff[b].id)
        local tm=""
        if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].buff[b].exp then
            tm=math.floor((crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].buff[b].exp-crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t)*10)/10
            if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].buff[b].exp==0 then
              tm=""
            elseif tm>60 then
              local min=math.floor(tm/60)
              local sec=math.floor(tm%60)
              if sec<10 then
                sec="0"..sec
              end
              tm=min..":"..sec
            end
          --end
        end
        
        --сколько стаков
        if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].buff[b].c then
          if tm=="" then
            tm="["..crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].buff[b].c.."]"
          else
            tm="["..crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].buff[b].c.."] "..tm
          end
        end
        
        if b<=6 then
          crBossBuffTable[i][b] = crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].buff[b].id
          crBossBuffIcon[i][b]:SetTexture(icon)
          crBossBuffFrame[i][b]:Show()
          crBossBuffText[i][b]:SetText(tm)
          crBossBuffText[i][b]:Show()
        end
        
      end
      if #crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].buff<6 then
        local j=#crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].buff+1
        while j<=6 do
          if crBossBuffFrame[i][j]:IsShown() then
            crBossBuffFrame[i][j]:Hide()
            crBossBuffText[i][j]:Hide()
          else
            j=50
          end
          j=j+1
        end
      end
    else
      --если дебафов нет, убирать показаные
        local j=1
        while j<=6 do
          if crBossBuffFrame[i][j]:IsShown() then
            crBossBuffFrame[i][j]:Hide()
            crBossBuffText[i][j]:Hide()
          else
            j=50
          end
          j=j+1
        end
    end
    --конец баффов
  end
  end

end


--постоянно обновлять
for i=1,#crsaveddata[crPlayingCombatID].boss do
  if i<=4 then
    --каст бар
    if thecurrentposition and ((crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i] and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].cast) or (crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1] and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].b[i] and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].b[i].cast)) then
    
      local casttime=0
      local curspelltime=1
      local icon =""
      if crCurrentlyCastingSpellBoss[i]==nil then
        crCurrentlyCastingSpellBoss[i]={}
      end

      if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i] and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].cast then
        casttime=math.floor((crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].cast.e-crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].cast.s)*100)/100
        if crPlayingCombatTimeLast then
          curspelltime=(crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t-crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].cast.s)+((crPlayingCombatTimeNext-crPlayingCombatTimeLast)*thecurrentposition)
        else
          curspelltime=(crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t-crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].cast.s)
        end
        _, _, icon = GetSpellInfo(crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].cast.n)
        if crCurrentlyCastingSpellBoss[i]~=crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].cast.n then
          crCurrentlyCastingSpellBoss[i]=crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].b[i].cast.n
          if crBossCastMouseOverActive[i] then
            GameTooltip:SetText(GetSpellInfo(crCurrentlyCastingSpellBoss[i]).."\n"..GetSpellDescription(crCurrentlyCastingSpellBoss[i]))
          end
        end
      end
      
      if curspelltime>casttime then
      --если каст докастился, проверять, а не начнется ли каститься новый каст, и сделать ПРЕЖДЕВРЕМЕННЫЙ КАСТ ЕГО!!!!
        if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1] and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].b[i].cast then
          casttime=math.floor((crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].b[i].cast.e-crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].b[i].cast.s)*100)/100
          if crPlayingCombatTimeLast then
            curspelltime=(crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t-crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].b[i].cast.s)+((crPlayingCombatTimeNext-crPlayingCombatTimeLast)*thecurrentposition)
          else
            curspelltime=(crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t-crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].b[i].cast.s)
          end
          _, _, icon = GetSpellInfo(crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].b[i].cast.n)
          if crCurrentlyCastingSpellBoss[i]~=crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].b[i].cast.n then
            crCurrentlyCastingSpellBoss[i]=crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].b[i].cast.n
            if crBossCastMouseOverActive[i] then
              GameTooltip:SetText(GetSpellInfo(crCurrentlyCastingSpellBoss[i]).."\n"..GetSpellDescription(crCurrentlyCastingSpellBoss[i]))
            end
          end
        end
      end

      
      if curspelltime>0 then
        crCastBarBoss15[i]:SetTexture(icon)
        
        crCastBarBoss14[i]:SetText(casttime.." "..crlocsec)

        if casttime>curspelltime then
          crCastBarBoss12[i]:SetWidth((curspelltime*102)/casttime)
          crCastBarBoss11[i]:Show()
        else
          if crCastBarBoss11[i] and crCastBarBoss11[i]:IsShown() then
            crCastBarBoss11[i]:Hide()
          end
        end
      else
        if crCastBarBoss11[i] and crCastBarBoss11[i]:IsShown() then
          crCastBarBoss11[i]:Hide()
        end
      end
    else
      if crCastBarBoss11[i] and crCastBarBoss11[i]:IsShown() then
        crCastBarBoss11[i]:Hide()
      end
    end
  end
end
  if #crsaveddata[crPlayingCombatID].boss<4 then
    --меньше 4, если босса нет, а фрейм открыт - скрываем
    for i=#crsaveddata[crPlayingCombatID].boss+1,4 do
      if crHPBarBoss11[i]:IsShown() then
        crCastBarBoss11[i]:Hide()
        crBossFrameModel1[i]:Hide()
        crBossFrameAssists[i]:Hide()
        crBossFrameName1[i]:Hide()
        crHPBarBoss11[i]:Hide()
        
        --бафы боссов
        local j=1
        while j<=6 do
          if crBossBuffFrame[i][j]:IsShown() then
            crBossBuffFrame[i][j]:Hide()
            crBossBuffText[i][j]:Hide()
          else
            j=50
          end
          j=j+1
        end
      end
    end
  end


end
end
















function crShowCurrentTime(nr,ev,currentposition)
if crsaveddata[nr] then
  local time=0
  if currentposition and crsaveddata[nr].events[ev+1] then
    time=(crsaveddata[nr].events[ev].t-crsaveddata[nr].events[1].t)+((crsaveddata[nr].events[ev+1].t-crsaveddata[nr].events[ev].t))*currentposition
  else
	if crsaveddata[nr].events[ev]==nil then
		return
	end
    time=(crsaveddata[nr].events[ev].t-crsaveddata[nr].events[1].t)
  end
  local min=math.floor(time/60)
  local sec=math.floor((time%60)*100)/100
  if sec<10 then
    sec="0"..sec
  end
  if string.len(sec)<3 then
    sec=sec..".00"
  elseif string.len(sec)<4 then
    sec=sec.."00"
  elseif string.len(sec)<5 then
    sec=sec.."0"
  end
  local add=""
  if crPlaySpeed and crPlaySpeed>1 then
    add=" (x"..crPlaySpeed..")"
  end
  crCurrentTimeShow:SetText(min..":"..sec..add)
end
end


--next event
function crGoToNextEvent()
if crsaveddata[crPlayingCombatID] then
crPlayingCombatEvent=math.floor(crPlaySlider:GetValue())
if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1] then
  crPlayingCombatEvent=crPlayingCombatEvent+1
  crPlaySlider:SetValue(crPlayingCombatEvent)
end
end
end

--previuos event
function crGoToPreviousEvent()
if crsaveddata[crPlayingCombatID] then
crPlayingCombatEvent=math.floor(crPlaySlider:GetValue())
if crPlayingCombatEvent~=1 and crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent-1] then
  crPlayingCombatEvent=crPlayingCombatEvent-1
  crPlaySlider:SetValue(crPlayingCombatEvent)
end
end
end

--go back for n sec
function crGoToBackseconds(sec)
if crsaveddata[crPlayingCombatID] then
local timenow=crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t
if crPlayingCombatEvent>1 then
  local found=0
  while (crPlayingCombatEvent>1 and found==0) do
    crPlayingCombatEvent=crPlayingCombatEvent-1
    if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t<=timenow-sec then
      found=1
    end
  end
  crPlaySlider:SetValue(crPlayingCombatEvent)
end
end
end

--go forward for n sec
function crGoToNextseconds(sec)
if crsaveddata[crPlayingCombatID] then
local timenow=crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t
if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1] then
  local found=0
  while (crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1] and found==0) do
    crPlayingCombatEvent=crPlayingCombatEvent+1
    if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t-sec>=timenow then
      found=1
    end
  end
  crPlaySlider:SetValue(crPlayingCombatEvent)
end
end
end

crClassColors={
{r=0.78, g=0.61,b=0.43,h="|CFFC69B6D",c="warrior"},
{r=0.77, g=0.12,b=0.23,h="|CFFC41F3B",c="deathknight"},
{r=0.96, g=0.55,b=0.73,h="|CFFF48CBA",c="paladin"},
{r=1, g=1,b=1,h="|CFFFFFFFF",c="priest"},
{r=0, g=0.44,b=0.87,h="|CFF1a3caa",c="shaman"},
{r=1, g=0.49,b=0.04,h="|CFFFF7C0A",c="druid"},
{r=1, g=0.96,b=0.41,h="|CFFFFF468",c="rogue"},
{r=0.41, g=0.8,b=0.94,h="|CFF68CCEF",c="mage"},
{r=0.58, g=0.51,b=0.79,h="|CFF9382C9",c="warlock"},
{r=0.67, g=0.83,b=0.45,h="|CFFAAD372",c="hunter"},
{r=0.33, g=0.54,b=0.52,h="|CFF00FF96",c="monk"}
}


function crGetBossModelID(guid)
local id=tonumber(string.sub(guid,6,10),16)
if id~=0 then
  for i=1,#crBossID do
    for j=1,#crBossID[i] do
      for k=1,#crBossID[i][j] do
        for m=1,#crBossID[i][j][k] do
          if crBossID[i][j][k][m]==id then
            if crBossModelID[i][j][k][m] then
              return crBossModelID[i][j][k][m]
            else
              --return crBossModelID[i][j][k][1]
            end
          end
        end
      end
    end
  end
end
return 0
end