local _
function crd_OnLoad()

  if crsaveddata==nil then crsaveddata={} end

	CombatReplayDataFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

end



function crd_OnUpdate(curtime)



--босса нет в бою
if crcheckbossincombatafterfight and curtime>crcheckbossincombatafterfight+1 then
crcheckbossincombatafterfight=curtime
if UnitName("boss1") and UnitName("boss1")~="" then
else
crcheckbossincombatafterfight=nil
crStopTracking()
end
end


--старт трекера
if crcheckbossincombat and curtime>crcheckbossincombat and crOptTrackBoss then
  crcheckbossincombat=nil
  if UnitName("boss1") and UnitName("boss1")~="" and UnitInRaid("player") and crcombatin==nil then
    crStartTracking()
    crcombatin=GetTime()+0.5
  else
    crlookingforaboss=curtime+1
  end
end


--на случай если босс появился позже
if crlookingforaboss and curtime>crlookingforaboss and crOptTrackBoss then
  crlookingforaboss=crlookingforaboss+1
  if UnitName("boss1") and UnitName("boss1")~="" and UnitInRaid("player") and crcombatin==nil then
    crlookingforaboss=nil
    crStartTracking()
    crcombatin=GetTime()+0.5
  end
end


--раз в 0.5 сек запись евента
if crcombatin and curtime>crcombatin then
  crcombatin=curtime+0.5
  crInsertEvent()
end

end