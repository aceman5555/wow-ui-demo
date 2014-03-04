local _
function crl_OnLoad()

  if crcombatlog==nil then crcombatlog={} end

	CombatReplayLoggerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

end





function crl_OnEvent(self,event,...)

if event == "COMBAT_LOG_EVENT_UNFILTERED" and crcombatin then
  local arg1, arg2, hideCaster, guid1, name1, flag1, new1, guid2, name2, flag2, new2, spellid, spellname, arg11,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20 = ...

  -- TEST ==========================
  --1/9 20:36:28.546  ENCOUNTER_START,1601,"Мастер осады Черноплавс",7,25
  if arg2=="ENCOUNTER_START" then
	--print ("Combat start, advanced or no?!")
  end
  if arg2=="ENCOUNTER_END" then
	--print ("Combat end, advanced or no?!")
  end 

  
--TEMP, to track cast without cast time + melee damage
--трекер комбат лога и запись в переменную crcombatlog
  if (arg2=="SPELL_CAST_SUCCESS") then
    table.insert(crcombatlog[1],{e=1,t=GetTime(),g=guid1,id=spellid,n=spellname})
  end
  if (arg2=="SWING_DAMAGE") then
    table.insert(crcombatlog[1],{e=2,t=GetTime(),g=guid1})
  end
  if (arg2=="SWING_MISSED") then
    table.insert(crcombatlog[1],{e=3,t=GetTime(),g=guid1})
  end
  if (arg2=="SPELL_CAST_SUCCESS" and (spellid==2825 or spellid==32182 or spellid==80353 or spellid==90355)) then
    if crsaveddata[1].buffs==nil then
      crsaveddata[1].buffs={}
    end
    local bil=0
    if #crsaveddata[1].buffs>0 then
      for i=1,#crsaveddata[1].buffs do
        if crsaveddata[1].buffs[i].id and (crsaveddata[1].buffs[i].id==2825 or crsaveddata[1].buffs[i].id==32182 or crsaveddata[1].buffs[i].id==80353 or crsaveddata[1].buffs[i].id==90355) then
          if (GetTime()-crsaveddata[1].buffs[i].t)<400 then
            bil=1
          end
        end
      end
    end
    if bil==0 then
      local tf=GetTime()+40
      table.insert(crsaveddata[1].buffs,{id=spellid,n=name1,t=GetTime(),tf=tf})
    end
  end
  
  --при смерти игрока делать засечку на этом евенте
  if arg2=="UNIT_DIED" then
    if crunitraidorparty(guid2,name2) and not UnitIsFeignDeath(name2) then
      if crsaveddata[1].death==nil then
        crsaveddata[1].death={}
      end
      local pn=0
      if crsaveddata[1].players and #crsaveddata[1].players>0 then
        for i=1,#crsaveddata[1].players do
          if crsaveddata[1].players[i].name==name2 then
            pn=i
          end
        end
      end
      if pn>0 then
        table.insert(crsaveddata[1].death,{e=#crsaveddata[1].events,p=pn})
      end
    end
  end

end

end


function crunitraidorparty(guid,name)
    if UnitInRaid(name) then
      local B = tonumber(guid:sub(5,5), 16)
      local maskedB = B % 8
      if maskedB and maskedB==0 then
        return true
      else
        return false
      end
    else
      return false
    end
end