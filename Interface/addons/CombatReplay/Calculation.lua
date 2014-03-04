--ы
function crPrepareVariabiles(nr)
print ("|cff99ffffCombatReplay|r - elaborating all data")

--оределение координат и размер поля + смена ника на цифру
local xmin=100
local ymin=100
local xmax=0
local ymax=0
if crsaveddata and crsaveddata[nr] and crsaveddata[nr] and crsaveddata[nr].events then


  --для каждого евента босса переменная
  local bhp1={"","","",""}
  local bhp2={"","","",""}
  local bpo1={"","","",""}
  local bpo2={"","","",""}
  local btn={"","","",""}
  local bti={"","","",""}
    
  for i=1,#crsaveddata[nr].events do
    --проверять таргеты каждого босса и убирать ники
    --таргет, если он существует и ГУИД совпадает игроком - удалять имя и гуид и создавать переменную "ИД"
    for n=1,#crsaveddata[nr].events[i].b do
      --пробегаем по данным боссов и удаляем ненужное
      if crsaveddata[nr].events[i].b[n] and crsaveddata[nr].events[i].b[n].hp1 then
        if crsaveddata[nr].events[i].b[n].hp1==bhp1[n] then
          crsaveddata[nr].events[i].b[n].hp1=nil
        else
          bhp1[n]=crsaveddata[nr].events[i].b[n].hp1
        end
        if crsaveddata[nr].events[i].b[n].hp2==bhp2[n] then
          crsaveddata[nr].events[i].b[n].hp2=nil
        else
          bhp2[n]=crsaveddata[nr].events[i].b[n].hp2
        end
        if crsaveddata[nr].events[i].b[n].po1==bpo1[n] then
          crsaveddata[nr].events[i].b[n].po1=nil
        else
          bpo1[n]=crsaveddata[nr].events[i].b[n].po1
        end
        if crsaveddata[nr].events[i].b[n].po2==bpo2[n] then
          crsaveddata[nr].events[i].b[n].po2=nil
        else
          bpo2[n]=crsaveddata[nr].events[i].b[n].po2
        end
        if crsaveddata[nr].events[i].b[n].tn==btn[n] then
          crsaveddata[nr].events[i].b[n].tn=nil
        else
          btn[n]=crsaveddata[nr].events[i].b[n].tn
        end
        if crsaveddata[nr].events[i].b[n].ti==bti[n] then
          crsaveddata[nr].events[i].b[n].ti=nil
        else
          bti[n]=crsaveddata[nr].events[i].b[n].ti
        end
        if crsaveddata[nr].events[i].b[n].cast then
          crsaveddata[nr].events[i].b[n].cast.s=math.floor(crsaveddata[nr].events[i].b[n].cast.s*100)/100000
          crsaveddata[nr].events[i].b[n].cast.e=math.floor(crsaveddata[nr].events[i].b[n].cast.e*100)/100000
        end
      else
        --данных нет, значит босс ни у кого не в целе, значит ячейка нил!
        crsaveddata[nr].events[i].b[n]=nil
      end
    
      if crsaveddata[nr].events[i].b[n] and crsaveddata[nr].events[i].b[n].ti then
        --проверка на игрока
        local p=1
        while p<=25 do
          if crsaveddata[nr].players[p] and crsaveddata[nr].players[p].guid and crsaveddata[nr].players[p].guid==crsaveddata[nr].events[i].b[n].ti then
            crsaveddata[nr].events[i].b[n].ti=nil
            crsaveddata[nr].events[i].b[n].tn=nil
            crsaveddata[nr].events[i].b[n].tid=p
            p=40
          end
          p=p+1
        end
      end
    end
    --перебираем всех игроков
    for j=1,#crsaveddata[nr].events[i].p do
    
      --таргет, если он существует и ГУИД совпадает с боссом или же игроком - удалять имя и гуид и создавать переменную "ИД"
      if crsaveddata[nr].events[i].p[j] and crsaveddata[nr].events[i].p[j].t and crsaveddata[nr].events[i].p[j].t.i then
        --проверка на босса
        local boss=0
        for bs=1,#crsaveddata[nr].boss do
          if crsaveddata[nr].events[i].p[j].t.i==crsaveddata[nr].boss[bs][1] then
            crsaveddata[nr].events[i].p[j].t.i=nil
            crsaveddata[nr].events[i].p[j].t.n=nil
            crsaveddata[nr].events[i].p[j].t.id=50+bs
            boss=1
          end
        end
        if boss==0 and crsaveddata[nr].events[i].p[j] then
          --проверка на игрока
          local p=1
          while p<=25 do
            if crsaveddata[nr].events[i].p[j] and crsaveddata[nr].events[i].p[j].t and crsaveddata[nr].events[i].p[j].t.i and crsaveddata[nr].players[p] and crsaveddata[nr].players[p].guid and crsaveddata[nr].players[p].guid==crsaveddata[nr].events[i].p[j].t.i then
              crsaveddata[nr].events[i].p[j].t.i=nil
              crsaveddata[nr].events[i].p[j].t.n=nil
              crsaveddata[nr].events[i].p[j].t.id=p
              p=40
            end
            p=p+1
          end
        end
      end
              
      --координаты
      if crsaveddata[nr].events[i].p[j] and crsaveddata[nr].events[i].p[j].x and crsaveddata[nr].events[i].p[j].x~=0 then
        if crsaveddata[nr].events[i].p[j].x<xmin then
          xmin=crsaveddata[nr].events[i].p[j].x
        elseif crsaveddata[nr].events[i].p[j].x>xmax then
          xmax=crsaveddata[nr].events[i].p[j].x
        end
      end
      if crsaveddata[nr].events[i].p[j] and crsaveddata[nr].events[i].p[j].y and crsaveddata[nr].events[i].p[j].y~=0 then
        if crsaveddata[nr].events[i].p[j].y<ymin then
          ymin=crsaveddata[nr].events[i].p[j].y
        elseif crsaveddata[nr].events[i].p[j].y>ymax then
          ymax=crsaveddata[nr].events[i].p[j].y
        end
      end
    end
  end
  --check every players info for each event, if there is no info for 50 events - update it to avoid too much cpu usage on playing combat
  for p=1,#crsaveddata[nr].events[1].p do
    local icon=0
    local hp2=0
    local nodataicon=0
    local nodatahp2=0
    for e=1,#crsaveddata[nr].events do
      if crsaveddata[nr].events[e].p[p] then
        if crsaveddata[nr].events[e].p[p].icon then
          icon=crsaveddata[nr].events[e].p[p].icon
          nodataicon=0
        else
          nodataicon=nodataicon+1
        end
        
        if crsaveddata[nr].events[e].p[p].hp2 then
          hp2=crsaveddata[nr].events[e].p[p].hp2
          nodatahp2=0
        else
          nodatahp2=nodatahp2+1
        end
        
        if nodataicon==50 then
          crsaveddata[nr].events[e].p[p].icon=icon
          nodataicon=0
        end
        if nodatahp2==50 then
          crsaveddata[nr].events[e].p[p].hp2=hp2
          nodatahp2=0
        end
      end
    end
  end
  --ыытест
  --todo: target info in the same way?
  
  --пролистываем каждого босса, если его хп не меняются - сохраняем в одну переменную
  for b=1,#crsaveddata[nr].events[1].b do
    local changedHp2=0
    local hp2=0
    local nodatahp2=0
    for e=1,#crsaveddata[nr].events do
      if crsaveddata[nr].events[e].b[b] then
        if crsaveddata[nr].events[e].b[b].hp2 then
          if hp2~=0 then
            changedHp2=1
          end
          hp2=crsaveddata[nr].events[e].b[b].hp2
          nodatahp2=0
        else
          nodatahp2=nodatahp2+1
        end

        if nodatahp2==50 then
          crsaveddata[nr].events[e].b[b].hp2=hp2
          nodatahp2=0
        end
      end
    end
    if changedHp2==0 and hp2~=0 then
      --ХП не менялось
      crsaveddata[nr].boss[b].hp2=hp2
      for e=1,#crsaveddata[nr].events do
        if crsaveddata[nr].events[e].b[b] then
          crsaveddata[nr].events[e].b[b].hp2=nil
        end
      end
    end
  end
  --пролистываем каждого босса, если его ПОВЕР не меняется - сохраняем в одну переменную
  for b=1,#crsaveddata[nr].events[1].b do
    local changedpo1=0
    local changedpo2=0
    local po1=0
    local po2=0
    local nodatapo1=0
    local nodatapo2=0
    for e=1,#crsaveddata[nr].events do
      if crsaveddata[nr].events[e].b[b] then
        if crsaveddata[nr].events[e].b[b].po1 then
          if po1~=0 then
            changedpo1=1
          end
          po1=crsaveddata[nr].events[e].b[b].po1
          nodatapo1=0
        else
          nodatapo1=nodatapo1+1
        end

        if nodatapo1==50 then
          crsaveddata[nr].events[e].b[b].po1=po1
          nodatapo1=0
        end
        
        if crsaveddata[nr].events[e].b[b].po2 then
          if po2~=0 then
            changedpo2=1
          end
          po2=crsaveddata[nr].events[e].b[b].po2
          nodatapo2=0
        else
          nodatapo2=nodatapo2+1
        end

        if nodatapo2==50 then
          crsaveddata[nr].events[e].b[b].po2=po2
          nodatapo2=0
        end
      end
    end
    if changedpo1==0 and changedpo2==0 then
      --Power не менялось
      crsaveddata[nr].boss[b].po1=po1
      crsaveddata[nr].boss[b].po2=po2
      for e=1,#crsaveddata[nr].events do
        if crsaveddata[nr].events[e].b[b] then
          crsaveddata[nr].events[e].b[b].po1=nil
          crsaveddata[nr].events[e].b[b].po2=nil
        end
      end
    elseif changedpo1==0 then
      --Power не менялось
      crsaveddata[nr].boss[b].po1=po1
      for e=1,#crsaveddata[nr].events do
        if crsaveddata[nr].events[e].b[b] then
          crsaveddata[nr].events[e].b[b].po1=nil
        end
      end
    elseif changedpo2==0 then
      --Power не менялось
      crsaveddata[nr].boss[b].po2=po2
      for e=1,#crsaveddata[nr].events do
        if crsaveddata[nr].events[e].b[b] then
          crsaveddata[nr].events[e].b[b].po2=nil
        end
      end
    end
  end
  
  --пролистываем каждого игрока, если его хп не меняются - сохраняем в одну переменную
  for p=1,#crsaveddata[nr].events[1].p do
    local changedHp2=0
    local hp2=0
    local nodatahp2=0
    for e=1,#crsaveddata[nr].events do
      if crsaveddata[nr].events[e].p[p] then
        if crsaveddata[nr].events[e].p[p].hp2 then
          if hp2~=0 then
            changedHp2=1
          end
          hp2=crsaveddata[nr].events[e].p[p].hp2
          nodatahp2=0
        else
          nodatahp2=nodatahp2+1
        end

        if nodatahp2==50 then
          crsaveddata[nr].events[e].p[p].hp2=hp2
          nodatahp2=0
        end
      end
    end
    if changedHp2==0 and hp2~=0 then
      --ХП не менялось
      crsaveddata[nr].players[p].hp2=hp2
      for e=1,#crsaveddata[nr].events do
        if crsaveddata[nr].events[e].p[p] then
          crsaveddata[nr].events[e].p[p].hp2=nil
        end
      end
    end
  end
  --

  local tempTableSpellId={}
  
  --пролистываем лог и записываем все инстансы
  local quickCursor={}
  if #crcombatlog[nr]>0 and crsaveddata[nr] and crsaveddata[nr].players and #crsaveddata[nr].players>0 then
    for i=1,#crcombatlog[nr] do
      if crcombatlog[nr][i].e==1 then
        tempTableSpellId[crcombatlog[nr][i].id]=crcombatlog[nr][i].n
        local plPos=cr_CalcGetPlayerPosition(crcombatlog[nr][i].g, nr)
        if plPos then
          --у нас есть номер игрока
          if quickCursor[plPos]==nil then
            quickCursor[plPos]=1
          end
          --ищем евент что совпадает по времени примерно
          local j=quickCursor[plPos]
          local castbil=0
          while j<=#crsaveddata[nr].events do
            if crsaveddata[nr].events[j].p[plPos] and crsaveddata[nr].events[j].p[plPos].cast and crsaveddata[nr].events[j].p[plPos].cast.e>crcombatlog[nr][i].t then
              --длительность каста
              local castlong=0
              castbil=1
            
              --мы перешли через каст, присваиваем переменную
              quickCursor[plPos]=j
              --local spellname=GetSpellInfo(crcombatlog[nr][i].id) --заменили на crcombatlog[nr][i].n
              local bil=0
              --проверка совпадает ли этот каст
              if crcombatlog[nr][i].n==crsaveddata[nr].events[j].p[plPos].cast.n then
                bil=1
                castlong=math.floor((crsaveddata[nr].events[j].p[plPos].cast.e-crsaveddata[nr].events[j].p[plPos].cast.s)*100)/100
                --print ("совпал 1",castlong,crcombatlog[nr][i].n)
              end
              --проверка совпадают ли следующие 3 сек с кастом
              local tmp=j
              local currentname=crsaveddata[nr].events[j].p[plPos].cast.n
              while tmp~=0 and bil==0 do
                tmp=tmp+1
                if crsaveddata[nr].events[tmp]==nil or crsaveddata[nr].events[tmp].p[plPos]==nil or (crsaveddata[nr].events[tmp].p[plPos].cast and crsaveddata[nr].events[tmp].p[plPos].cast.s>crcombatlog[nr][i].t+2 and currentname~=crsaveddata[nr].events[tmp].p[plPos].cast.n) then
                  tmp=0
                else
                  if crsaveddata[nr].events[tmp].p[plPos].cast and crcombatlog[nr][i].n==crsaveddata[nr].events[tmp].p[plPos].cast.n then
                    bil=1
                    castlong=math.floor((crsaveddata[nr].events[tmp].p[plPos].cast.e-crsaveddata[nr].events[tmp].p[plPos].cast.s)*100)/100
                    --print ("совпал 2",castlong,crcombatlog[nr][i].n)
                  end
                end
              end
              tmp=j
              --проверка совпадают ли предыдущие 3 сек с кастом
              while tmp~=0 and bil==0 do
                tmp=tmp-1
                if crsaveddata[nr].events[tmp]==nil or crsaveddata[nr].events[tmp].p[plPos]==nil or (crsaveddata[nr].events[tmp].p[plPos].cast and crsaveddata[nr].events[tmp].p[plPos].cast.e<crcombatlog[nr][i].t-3 and currentname~=crsaveddata[nr].events[tmp].p[plPos].cast.n) then
                  tmp=0
                else
                  if crsaveddata[nr].events[tmp].p[plPos].cast and crcombatlog[nr][i].n==crsaveddata[nr].events[tmp].p[plPos].cast.n then
                    bil=1
                    castlong=math.floor((crsaveddata[nr].events[tmp].p[plPos].cast.e-crsaveddata[nr].events[tmp].p[plPos].cast.s)*100)/100
                    --print ("совпал 3",castlong,crcombatlog[nr][i].n)
                  end
                end
              end
              if bil==0 then
                --КАСТА НЕ БЫЛО, добавлять в таблицу
                table.insert(crsaveddata[nr].casts[plPos],{crcombatlog[nr][i].id,crcombatlog[nr][i].t,0})
              else
                --каст был но добавлять в табл все равно
                table.insert(crsaveddata[nr].casts[plPos],{crcombatlog[nr][i].id,crcombatlog[nr][i].t,castlong})
              end
              j=#crsaveddata[nr].events
            end
          j=j+1
          end
          --игрок вообще ничего не кастил за бой, надо записать все равно!
          if castbil==0 then
            table.insert(crsaveddata[nr].casts[plPos],{crcombatlog[nr][i].id,crcombatlog[nr][i].t,0})
          end
        end
      end
    end
  end
  

 
  --у всех игроков меняем спелл нейм на спелл ИД
  for i=1,#crsaveddata[nr].events do
    for j=1,#crsaveddata[nr].events[i].p do
      if crsaveddata[nr].events[i].p[j] and crsaveddata[nr].events[i].p[j].cast then
        --спелнейм меняем на иконку
        for k,v in pairs(tempTableSpellId) do
          if v==crsaveddata[nr].events[i].p[j].cast.n then
            crsaveddata[nr].events[i].p[j].cast.n=k
            break
          end
        end
       end
    end
  end
  
  --у всех боссов меняем спелл нейм на спелл ИД
  for i=1,#crsaveddata[nr].events do
    for n=1,#crsaveddata[nr].events[i].b do
      if crsaveddata[nr].events[i].b[n] and crsaveddata[nr].events[i].b[n].cast then
        for k,v in pairs(tempTableSpellId) do
          if v==crsaveddata[nr].events[i].b[n].cast.n then
            crsaveddata[nr].events[i].b[n].cast.n=k
            break
          end
        end
      end
    end
  end
  
end


--пример 0.1, 0.15 // 0.95, 0.67
--поле 400 на 200
--мое поле 690 на 690 => (crCenterFrameSizeDef-10)

local width=(xmax-xmin)
local height=(ymax-ymin)
local xadd=0
local yadd=0

local scale=0
if width>height then
  --растягиваем по горизонтали
  scale=(crCenterFrameSizeDef-10)/width
  --вертикаль нужно поставить в центр
  yadd=((width-height)*scale)/2
else
  --растягиваем по вертикали
  scale=(crCenterFrameSizeDef-10)/height
  --горизонталь в центр
  xadd=((height-width)*scale)/2
end


crsaveddata[nr].scale=scale
crsaveddata[nr].xmin=xmin --отступ для отнимания
crsaveddata[nr].ymin=ymin --отступ для отнимания
crsaveddata[nr].xadd=xadd+5 --чтобы центральней было, добавлять эту переменную
crsaveddata[nr].yadd=yadd+5 --чтобы центральней было, добавлять эту переменную



--удаляем обработанное инфо:
table.wipe(crcombatlog[nr])

end




function crDamageCeil(dmg,boss)
if dmg==nil then
	return ""
else
	local he=0

	if (string.len(dmg)) > 6 and boss then
		local maxnumcif=string.len(dmg)-6
		local dopcif=tonumber(string.sub(dmg, maxnumcif+1, maxnumcif+1))
		he=string.sub(dmg, 1, string.len(dmg)-6)
		if dopcif and dopcif>0 then
      --if string.len(dopcif)==1 then
      --  dopcif="0"..dopcif
      --end
			he=he.."."..dopcif
		end
		he=he.."M"


	elseif (string.len(dmg)) > 3 then
    if dmg>=30000 then
      he=string.sub(dmg, 1, string.len(dmg)-3)
      he=he.."k"
    else
      dmg=dmg*10
      he=string.sub(dmg, 1, string.len(dmg)-3)
      he=he/10
      he=he.."k"
    end
	else
		he=dmg
	end
	return he
end
end


function cr_CalcGetPlayerPosition(guid,nr)
for i=1,#crsaveddata[nr].players do
  if crsaveddata[nr].players[i] and crsaveddata[nr].players[i].guid==guid then
    return i
  end
end
return false
end