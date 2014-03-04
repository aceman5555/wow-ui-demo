--ы
function crRangeCheckRaid()

crRaidRangeEditBox:ClearFocus()

if crRangeCheckRaidActive==nil then

  --начинаем трекерить рендж и кнопка мигает
  crRangeCheckRaidActive=GetTime()
  crRangeCheckRaidTable={}
  crTempColorShow=1
  print ("|cff99ffffCombatReplay|r - Range check now active! Click one more time to stop it.")
  crShowEventFrame(crPlayingCombatID,crPlayingCombatEvent)
  
else
  --перестаем трекерить рендж
  crRangeCheckRaidActive=nil
  crButtonToolRange:SetAlpha(1)
  table.wipe(crRangeCheckRaidTable)
  
  --убрать выделения игроков красным
  if crsaveddata[crPlayingCombatID] then
    for i=1,25 do
      if crPlayersFramesColor[i] and crsaveddata[crPlayingCombatID].players[i] then
        crPlayersFramesColor[i]:SetTexture(crClassColors[crsaveddata[crPlayingCombatID].players[i].class].r, crClassColors[crsaveddata[crPlayingCombatID].players[i].class].g, crClassColors[crsaveddata[crPlayingCombatID].players[i].class].b, 1)
      end
    end
  end
  
  --убрать надпись о том сколько человек фейлит сейчас
  if crRangeDistanceBottom2 then
    crRangeDistanceBottom2:Hide()
  end
  
end

end

function crFillRangeRaidCheckTable()
if crRangeCheckRaidActive then

  --ДУМАЮ НЕ РАБОТАЕТ ЭТА КОПИЯ
  --создаем копию текущей таблицы
  local t2 = {}
  for k,v in pairs(crRangeCheckRaidTable) do
    t2[k] = v
  end

  table.wipe(crRangeCheckRaidTable)
  --для каждого игрока проверяем дистанцию, если он еще не в "красном списке"
  local i=1
  local j=1
  local plDistFail=0
  while i<25 do
    if crLastShownPlayersCoordX[i] then
      j=i+1
      while j<=25 do
        if crLastShownPlayersCoordX[j] and (crRangeCheckRaidTable[j]==nil or crRangeCheckRaidTable[i]==nil) then
          --проверка растояния между этими игроками если меньше то добавление ОБОИХ в таблицу
          local range=math.ceil(math.sqrt(math.pow(crsaveddata[crPlayingCombatID].map[3]*(crLastShownPlayersCoordX[j]-crLastShownPlayersCoordX[i]),2)+math.pow(crsaveddata[crPlayingCombatID].map[4]*(crLastShownPlayersCoordY[j]-crLastShownPlayersCoordY[i]),2))*10)/10
          --меньше ли установленного ренджа?
          if (range<=crRaidRangeEditBox:GetNumber()) then
            crRangeCheckRaidTable[i]=1
            crRangeCheckRaidTable[j]=1
          end
        end
        j=j+1
      end
      
      --возвращаем цвет класса если игрок уже не в фейл табл но был там
      if crRangeCheckRaidTable[i]==nil and t2[i] then
        if i==crPlayersActive[1] or i==crPlayersActive[2] then
          crPlayersFramesColor[i]:SetTexture(0, 1, 0, 1)
        else
          crPlayersFramesColor[i]:SetTexture(crClassColors[crsaveddata[crPlayingCombatID].players[i].class].r, crClassColors[crsaveddata[crPlayingCombatID].players[i].class].g, crClassColors[crsaveddata[crPlayingCombatID].players[i].class].b, 1)
        end
      end
    end
    i=i+1
  end
  
  --проверяем 25го игрока
  if crRangeCheckRaidTable[i]==nil and t2[i] then
    crPlayersFramesColor[i]:SetTexture(crClassColors[crsaveddata[crPlayingCombatID].players[i].class].r, crClassColors[crsaveddata[crPlayingCombatID].players[i].class].g, crClassColors[crsaveddata[crPlayingCombatID].players[i].class].b, 1)
  end


  -- how much players failed
  for i=1,25 do
    if crRangeCheckRaidTable[i] then
      plDistFail=plDistFail+1
    end
  end
  
  if plDistFail>0 then
    crRangeDistanceBottom2:SetText("Players with range <"..crRaidRangeEditBox:GetNumber()..": "..plDistFail)
    if crRangeDistanceBottom2:IsShown()==nil then
      crRangeDistanceBottom2:Show()
    end
  else
    crRangeDistanceBottom2:Hide()
  end

end
end


function crGetRangeBetweenPlayers(nr,ev,thecurrentposition)
local player1 = crPlayersActive[1]
local player2 = crPlayersActive[2]
if player1 and player2 then
  if ev==nil then
    ev=math.floor(crPlaySlider:GetValue())
  end
  if nr==nil then
    nr=crPlayingCombatID
  end

          --реальные координаты
          local rx=0
          local ry=0
          local rx2=0
          local ry2=0
          --получаем данные координат
          local x=0
          local y=0
          local m=ev
          local bil=0
          while (m>0 and bil<2) do
            if x==0 and crsaveddata[nr].events[m].p[player1] and crsaveddata[nr].events[m].p[player1].x and crsaveddata[nr].events[m].p[player1].x~=0 then
              x=(crsaveddata[nr].events[m].p[player1].x-crsaveddata[nr].xmin)*crsaveddata[nr].scale+crsaveddata[nr].xadd
              rx=crsaveddata[nr].events[m].p[player1].x
              bil=bil+1
            end
            if y==0 and crsaveddata[nr].events[m].p[player1] and crsaveddata[nr].events[m].p[player1].y and crsaveddata[nr].events[m].p[player1].y~=0 then
              y=(crsaveddata[nr].events[m].p[player1].y-crsaveddata[nr].ymin)*crsaveddata[nr].scale*(-1)-crsaveddata[nr].yadd
              ry=crsaveddata[nr].events[m].p[player1].y
              bil=bil+1
            end
            m=m-1
          end
          local x2=0
          local y2=0
          m=ev
          bil=0
          while (m>0 and bil<2) do
            if x2==0 and crsaveddata[nr].events[m].p[player2] and crsaveddata[nr].events[m].p[player2].x and crsaveddata[nr].events[m].p[player2].x~=0 then
              x2=(crsaveddata[nr].events[m].p[player2].x-crsaveddata[nr].xmin)*crsaveddata[nr].scale+crsaveddata[nr].xadd
              rx2=crsaveddata[nr].events[m].p[player2].x
              bil=bil+1
            end
            if y2==0 and crsaveddata[nr].events[m].p[player2] and crsaveddata[nr].events[m].p[player2].y and crsaveddata[nr].events[m].p[player2].y~=0 then
              y2=(crsaveddata[nr].events[m].p[player2].y-crsaveddata[nr].ymin)*crsaveddata[nr].scale*(-1)-crsaveddata[nr].yadd
              ry2=crsaveddata[nr].events[m].p[player2].y
              bil=bil+1
            end
            m=m-1
          end


  local range=math.ceil(math.sqrt(math.pow(crsaveddata[nr].map[3]*(rx-rx2),2)+math.pow(crsaveddata[nr].map[4]*(ry-ry2),2))*10)/10
  if (range % 1 ==0) then
    range=range..".0"
  end

  crDrawRouteLine(crRangeLine, crframecenter, x, y, x2, y2, 25,"TOPLEFT",range)
  crRangeLine:Show()
  if range~="0.0" then
    crRangeDistanceBottom:Show()
    crRangeDistanceBottom:SetText(crlocrangebetween.." "..crClassColors[crsaveddata[nr].players[player1].class].h..crsaveddata[nr].players[player1].name.."|r "..crlocand.." "..crClassColors[crsaveddata[nr].players[player2].class].h..crsaveddata[nr].players[player2].name.."|r: "..range.." "..crlocyd)
  else
    crRangeDistanceBottom:Hide()
  end

end
end




-- C        - Canvas Frame (for anchoring)
-- sx,sy    - Coordinate of start of line
-- ex,ey    - Coordinate of end of line
-- w        - Width of line
-- relPoint - Relative point on canvas to interpret coords (Default BOTTOMLEFT)
function crDrawRouteLine(T, C, sx, sy, ex, ey, w, relPoint,range)

   if (not relPoint) then relPoint = "BOTTOMLEFT"; end

   -- Determine dimensions and center point of line
   local dx,dy = ex - sx, ey - sy;
   local cx,cy = (sx + ex) / 2, (sy + ey) / 2;


   -- Normalize direction if necessary
   if (dx < 0) then
      dx,dy = -dx,-dy;
   end

   -- Calculate actual length of line
   local l = sqrt((dx * dx) + (dy * dy));

   -- Quick escape if it's zero length
   if (l == 0) then
      T:SetTexCoord(0,0,0,0,0,0,0,0);
      T:SetPoint("BOTTOMLEFT", C, relPoint, cx,cy);
      T:SetPoint("TOPRIGHT",   C, relPoint, cx,cy);
      crRangeLineText:Hide()
      return;
   end

   -- Sin and Cosine of rotation, and combination (for later)
   local s,c = -dy / l, dx / l;
   local sc = s * c;

   -- Calculate bounding box size and texture coordinates
   local Bwid, Bhgt, BLx, BLy, TLx, TLy, TRx, TRy, BRx, BRy;
   if (dy >= 0) then
      Bwid = ((l * c) - (w * s)) * TAXIROUTE_LINEFACTOR_2;
      Bhgt = ((w * c) - (l * s)) * TAXIROUTE_LINEFACTOR_2;
      BLx, BLy, BRy = (w / l) * sc, s * s, (l / w) * sc;
      BRx, TLx, TLy, TRx = 1 - BLy, BLy, 1 - BRy, 1 - BLx; 
      TRy = BRx;
   else
      Bwid = ((l * c) + (w * s)) * TAXIROUTE_LINEFACTOR_2;
      Bhgt = ((w * c) + (l * s)) * TAXIROUTE_LINEFACTOR_2;
      BLx, BLy, BRx = s * s, -(l / w) * sc, 1 + (w / l) * sc;
      BRy, TLx, TLy, TRy = BLx, 1 - BRx, 1 - BLx, 1 - BLy;
      TRx = TLy;
   end

   -- Set texture coordinates and anchors
   T:ClearAllPoints();
   T:SetTexCoord(TLx, TLy, BLx, BLy, TRx, TRy, BRx, BRy);
   T:SetPoint("BOTTOMLEFT", C, relPoint, cx - Bwid, cy - Bhgt);
   T:SetPoint("TOPRIGHT",   C, relPoint, cx + Bwid, cy + Bhgt);
   
   --отображает надпись о рендже возле полоски
   crRangeLineText:Show()
   crRangeLineText:SetText(range)

   if s>0 and c>0 then
    crRangeLineText:SetPoint("TOPLEFT",cx+10*s,cy+10*c)
   else
    crRangeLineText:SetPoint("TOPLEFT",cx-10*s,cy-10*c)
   end

    
end