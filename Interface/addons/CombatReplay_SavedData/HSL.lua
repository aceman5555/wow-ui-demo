--ы
local _

function crStartTracking()
print ("|cff99ffffCombatReplay|r - tracker started")

crStopReplay()
crHideFrames()


  SetMapToCurrentZone()
  
  table.insert(crsaveddata,1,{})
  table.insert(crcombatlog,1,{})
  
  --удалять бои не для записи
  if crsaveddata and #crsaveddata>crOptCombatSave then
    for i=(crOptCombatSave+1),#crsaveddata do
      crsaveddata[i]=nil
      crcombatlog[i]=nil
    end
  end
  
  
  --создается таблица для последнего евента
  crLastSavedData=nil
  crLastSavedData={}
  
  --запись боссов
  crsaveddata[1].boss={}
  if UnitGUID("boss1") then
    crsaveddata[1].boss={}
    table.insert(crsaveddata[1].boss,{})
    crsaveddata[1].boss[#crsaveddata[1].boss][1]=UnitGUID("boss1")
    crsaveddata[1].boss[#crsaveddata[1].boss][2]=UnitName("boss1")
    if UnitGUID("boss2") and crBossExists(UnitGUID("boss2")) then
      table.insert(crsaveddata[1].boss,{})
      crsaveddata[1].boss[#crsaveddata[1].boss][1]=UnitGUID("boss2")
      crsaveddata[1].boss[#crsaveddata[1].boss][2]=UnitName("boss2")
      if UnitGUID("boss3") and crBossExists(UnitGUID("boss3")) then
        table.insert(crsaveddata[1].boss,{})
        crsaveddata[1].boss[#crsaveddata[1].boss][1]=UnitGUID("boss3")
        crsaveddata[1].boss[#crsaveddata[1].boss][2]=UnitName("boss3")
        if UnitGUID("boss4") and crBossExists(UnitGUID("boss4")) then
          table.insert(crsaveddata[1].boss,{})
          crsaveddata[1].boss[#crsaveddata[1].boss][1]=UnitGUID("boss4")
          crsaveddata[1].boss[#crsaveddata[1].boss][2]=UnitName("boss4")
        end
      end
    end
  end

  --запись зоны
  local mapwidth,mapheight=crGetMapSize()
  crsaveddata[1].map={GetCurrentMapAreaID(),GetRealZoneText(),mapwidth,mapheight}
  
  
  --касты
  crsaveddata[1].casts={}


  --запись игроков
  crsaveddata[1].players={}
  
  --получаем ИД своей зоны
  local myzone="nozone"
  for i=1,GetNumGroupMembers() do
    local name,_,_,_,_,_,zone = GetRaidRosterInfo(i)
    if name==UnitName("player") then
      --моя зона
      myzone=zone
    end
  end
  
  for i=1,GetNumGroupMembers() do
    local name,_,_,_,_,_,zone = GetRaidRosterInfo(i)
    if GetRealZoneText()==zone or zone==myzone then
      --игрок в моей зоне
      local _, class=UnitClass("raid"..i)
      table.insert(crsaveddata[1].players,{name=name, guid=UnitGUID("raid"..i), class=crGetClassCOlorID(class)})
      table.insert(crLastSavedData,{})
      
      table.insert(crsaveddata[1].casts,{})
      table.insert(crsaveddata[1].casts[#crsaveddata[1].casts],{0,0,0})
    end
  end
  
  --запись даты
  --время начала боя
  local _, month, day, year = CalendarGetDate()
  if month<10 then month="0"..month end
  if day<10 then day="0"..day end
  --if year>2000 then year=year-2000 end
  local h,m = GetGameTime()
  if h<10 then h="0"..h end
  if m<10 then m="0"..m end
  local crtimeofcombatstart=h..":"..m..", "..month.."/"..day.."/"..year
  crsaveddata[1].date=crtimeofcombatstart
  
  

  
  

  --запись первого евента
  crsaveddata[1].events={} --здесь держатся евенты
  crInsertEvent()
end


function crInsertEvent()
if UnitInRaid("player") then
  table.insert(crsaveddata[1].events,{})--новая ячейка для записи евента
  
  --время евента
  crsaveddata[1].events[#crsaveddata[1].events].t=GetTime()
  
  --табл для боссов
  crsaveddata[1].events[#crsaveddata[1].events].b={}
  for i=1,#crsaveddata[1].boss do
    table.insert(crsaveddata[1].events[#crsaveddata[1].events].b,{})
  end
  
  --табл для игроков
  crsaveddata[1].events[#crsaveddata[1].events].p={}

    for i=1,GetNumGroupMembers() do
      local name = GetRaidRosterInfo(i)
      local playernr=crGetPlayerPositionInSavedDate(name)
      if playernr and playernr>0 then
        --нужный нам игрок, получаем все данные и записываем его тут
        
        --номер ячейки где хранится имя игрока
        crsaveddata[1].events[#crsaveddata[1].events].p[playernr]={}
        
        --координаты
        local x,y=GetPlayerMapPosition("raid"..i)
        if crLastSavedData[playernr].x==nil or crLastSavedData[playernr].x~=x then
          crsaveddata[1].events[#crsaveddata[1].events].p[playernr].x=x
          crLastSavedData[playernr].x=x
        end
        if crLastSavedData[playernr].y==nil or crLastSavedData[playernr].y~=y then
          crsaveddata[1].events[#crsaveddata[1].events].p[playernr].y=y
          crLastSavedData[playernr].y=y
        end
        
        --icon on the player
        local icon=GetRaidTargetIndex("raid"..i)
        if icon==nil then
          icon=0
        end
        if crLastSavedData[playernr].icon==nil or crLastSavedData[playernr].icon~=icon then
          crsaveddata[1].events[#crsaveddata[1].events].p[playernr].icon=icon
          crLastSavedData[playernr].icon=icon
        end
        
        
        --дебафы
        --name, rank, _, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff("unit", index or ["name", "rank"][, "filter"])

        local d=1
        while d<=40 do
          local deb,_,_,count,_,_,expire,_,_,_,id=UnitDebuff("raid"..i,d)
          if deb and id then
            if (id~=57723 and id~=80354 and id~=95223) then
              if crsaveddata[1].events[#crsaveddata[1].events].p[playernr].deb==nil then
                crsaveddata[1].events[#crsaveddata[1].events].p[playernr].deb={}
              end
              if expire==nil or expire==0 then
                if count==nil or count<=1 then
                  table.insert(crsaveddata[1].events[#crsaveddata[1].events].p[playernr].deb,{id=id})
                else
                  table.insert(crsaveddata[1].events[#crsaveddata[1].events].p[playernr].deb,{c=count,id=id})
                end
              else
                if count==nil or count<=1 then
                  table.insert(crsaveddata[1].events[#crsaveddata[1].events].p[playernr].deb,{exp=expire,id=id})
                else
                  table.insert(crsaveddata[1].events[#crsaveddata[1].events].p[playernr].deb,{c=count,exp=expire,id=id})
                end
              end
            end
          else
            d=41
          end
          d=d+1
        end
        
        --что кастит
        local spell, _, _, _, startTime, endTime = UnitCastingInfo("raid"..i)
        if spell then
          startTime=math.floor(startTime*100)/100000
          endTime=math.floor(endTime*100)/100000
          crsaveddata[1].events[#crsaveddata[1].events].p[playernr].cast={n=spell,s=startTime,e=endTime}
        end
        
        
        --хп
        local hp1=UnitHealth("raid"..i)
        local hp2=UnitHealthMax("raid"..i)
        if crLastSavedData[playernr].hp1==nil or crLastSavedData[playernr].hp1~=hp1 then
          crsaveddata[1].events[#crsaveddata[1].events].p[playernr].hp1=hp1
          crLastSavedData[playernr].hp1=hp1
        end
        if crLastSavedData[playernr].hp2==nil or crLastSavedData[playernr].hp2~=hp2 then
          crsaveddata[1].events[#crsaveddata[1].events].p[playernr].hp2=hp2
          crLastSavedData[playernr].hp2=hp2
        end
        
        
        
        --таргет
        local tar=UnitName("raid"..i.."-target")
        local tar2=UnitGUID("raid"..i.."-target")
        if tar==nil then
          tar=0
          tar2=0
        end
        if crLastSavedData[playernr].t==nil or crLastSavedData[playernr].t.i~=tar2 then
          if tar2==0 then
            crsaveddata[1].events[#crsaveddata[1].events].p[playernr].t={i=tar2}
          else
            crsaveddata[1].events[#crsaveddata[1].events].p[playernr].t={n=tar,i=tar2}
          end
          crLastSavedData[playernr].t={}
          crLastSavedData[playernr].t.i=tar2
        end

      end
    end

    --запись боссов
    local bossesid={"boss1","boss2","boss3","boss4","boss5"}
    for bi=1,#bossesid do
      if UnitGUID(bossesid[bi]) then
        local found=0
        for n=1,#crsaveddata[1].boss do
          if UnitGUID(bossesid[bi])==crsaveddata[1].boss[n][1] then
            found=1
            local btar=UnitName(bossesid[bi].."-target")
            local btar2=UnitGUID(bossesid[bi].."-target")
            if btar==nil then
              btar=0
              btar2=0
            end
            
            crsaveddata[1].events[#crsaveddata[1].events].b[n].hp1=UnitHealth(bossesid[bi])
            crsaveddata[1].events[#crsaveddata[1].events].b[n].hp2=UnitHealthMax(bossesid[bi])
            crsaveddata[1].events[#crsaveddata[1].events].b[n].po1=UnitPower(bossesid[bi])
            crsaveddata[1].events[#crsaveddata[1].events].b[n].po2=UnitPowerMax(bossesid[bi])
            crsaveddata[1].events[#crsaveddata[1].events].b[n].tn=btar
            if btar2~=0 then
              crsaveddata[1].events[#crsaveddata[1].events].b[n].ti=btar2
            end
              
            --buffs of bosses
            local d=1
            while d<=40 do
              local buff,_,_,count,_,_,expire,_,_,_,id=UnitBuff(bossesid[bi],d)
              if buff and id then
                if (id~=9999999) then --тут прописывать баффы боссов что нас не интересуют, 2 раза!
                  if crsaveddata[1].events[#crsaveddata[1].events].b[n].buff==nil then
                    crsaveddata[1].events[#crsaveddata[1].events].b[n].buff={}
                  end
                  if expire==nil or expire==0 then
                    if count==nil or count<=1 then
                      table.insert(crsaveddata[1].events[#crsaveddata[1].events].b[n].buff,{id=id})
                    else
                      table.insert(crsaveddata[1].events[#crsaveddata[1].events].b[n].buff,{c=count,id=id})
                    end
                  else
                    if count==nil or count<=1 then
                      table.insert(crsaveddata[1].events[#crsaveddata[1].events].b[n].buff,{exp=expire,id=id})
                    else
                      table.insert(crsaveddata[1].events[#crsaveddata[1].events].b[n].buff,{c=count,exp=expire,id=id})
                    end
                  end
                end
              else
                d=41
              end
              d=d+1
            end
              
            --что кастит boss
            local spell, _, _, _, startTime, endTime = UnitCastingInfo(bossesid[bi])
            if spell then
              crsaveddata[1].events[#crsaveddata[1].events].b[n].cast={n=spell,s=startTime,e=endTime}
            end
          end
        end
        if found==0 then
          --босс есть но не нашли его в списке на старте, проверим, мб это один из тех что нада трекерить?
          local id=tonumber(string.sub(UnitGUID(bossesid[bi]),6,10),16)
          for nb=1,#crBossNotAvaialbleOnStart do
            if crBossNotAvaialbleOnStart[nb]==id then
              found=1
            end
          end
          if found==1 then
            --add boss to tracker
            table.insert(crsaveddata[1].boss,{})
            crsaveddata[1].boss[#crsaveddata[1].boss][1]=UnitGUID(bossesid[bi])
            crsaveddata[1].boss[#crsaveddata[1].boss][2]=UnitName(bossesid[bi])
          end
        end
      end
    end
    
    --если инфы о боссе не обнаружено - удалять
    for i=1,#crsaveddata[1].events[#crsaveddata[1].events].b do
      if crsaveddata[1].events[#crsaveddata[1].events].b[i].hp1==nil then
        crsaveddata[1].events[#crsaveddata[1].events].b[i]=nil
      end
    end
  

end
end


function crStopTracking()
if crcombatin then
  crcombatin=nil
  --stop tracking events
  print ("|cff99ffffCombatReplay|r - stop tracker")
  crLastSavedData=nil
end
end



function crGetPlayerPositionInSavedDate(name)
local pos=0
if crsaveddata[1].players then
  local j=1
  while j<=#crsaveddata[1].players do
    if crsaveddata[1].players[j].name==name then
      pos=j
      j=100
    end
    j=j+1
  end
end
return pos
end


crClassColorID={"WARRIOR","DEATHKNIGHT","PALADIN","PRIEST","SHAMAN","DRUID","ROGUE","MAGE","WARLOCK","HUNTER","MONK"}
function crGetClassCOlorID(class)
for i=1,#crClassColorID do
  if crClassColorID[i]==class then
    return i
  end
end
return 0
end


function crBossExists(guid)
local id=tonumber(string.sub(guid,6,10),16)
if id~=0 then
  for i=1,#crBossID do
    for j=1,#crBossID[i] do
      for k=1,#crBossID[i][j] do
        for m=1,#crBossID[i][j][k] do
          if crBossID[i][j][k][m]==id then
            return true
          end
        end
      end
    end
  end
end
return false
end


function crGetMapSize()
	-- try custom map size first
	local mapName = GetMapInfo()
	local floor, a1, b1, c1, d1 = GetCurrentMapDungeonLevel()

	--Blizzard's map size
	if not (a1 and b1 and c1 and d1) then
		local zoneIndex, a2, b2, c2, d2 = GetCurrentMapZone()
		a1, b1, c1, d1 = a2, b2, c2, d2
	end

	if not (a1 and b1 and c1 and d1) then return end
	return abs(c1-a1), abs(d1-b1)
end