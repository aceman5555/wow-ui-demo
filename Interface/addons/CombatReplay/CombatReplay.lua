local _
function cr_OnLoad()

crlocalem()
if GetLocale()=="deDE" or GetLocale()=="ruRU" or GetLocale()=="itIT" or GetLocale()=="zhTW" or GetLocale()=="zhCN" or GetLocale()=="frFR" or GetLocale()=="koKR" or GetLocale()=="esES" or GetLocale()=="esMX" or GetLocale()=="ptBR" then
crlocale()
end


	crversion=5.423

  if crPlayersSizeOnMap==nil then crPlayersSizeOnMap=12 end
  if crOptTrackLfr==nil then crOptTrackLfr=false end
  if crCenterFrameSizeDef==nil then crCenterFrameSizeDef=700 end
  if crOptTrackBoss==nil then crOptTrackBoss=true end
  if crPlayerIconPositionShow==nil then crPlayerIconPositionShow=true end
  if crOptCombatSave==nil then crOptCombatSave=3 end
  if crRaidRangeCheckValue==nil then crRaidRangeCheckValue=8 end
  if crShowPlayersHpDynamic==nil then crShowPlayersHpDynamic=true end
  
  
  
  --some useful variabiles
  crInstanceSpellsShow={}
  crPlayersActive={}
  crCurrentlyCastingSpellBoss={}
  crBossCastMouseOverActive={}
  crRangeCheckRaidTable={}
  crLastShownPlayersCoordX={}
  crLastShownPlayersCoordY={}
  
  
  crBossAssists={}


	SLASH_CombatReplayFrame1 = "/cr"
	SLASH_CombatReplayFrame2 = "/replay"
	SLASH_CombatReplayFrame3 = "/combatreplay"
	SLASH_CombatReplayFrame4 = "/повтор"
	SLASH_CombatReplayFrame5 = "/кр"
	SLASH_CombatReplayFrame6 = "/ск"
	SlashCmdList["CombatReplayFrame"] = CombatReplayFrame_Command


  CombatReplayFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	CombatReplayFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	CombatReplayFrame:RegisterEvent("PLAYER_ALIVE")
	CombatReplayFrame:RegisterEvent("ADDON_LOADED")
	
  CombatReplayFrame:RegisterEvent("VARIABLES_LOADED")
  CombatReplayFrame:RegisterEvent("UI_SCALE_CHANGED")

	
	


end





function cr_OnUpdate(curtime)



--бой воспроизводится, постоянное обновление
if crPlayingCombatUpdateTime and curtime>crPlayingCombatUpdateTime then
  local changedEvent=0
  crPlayingCombatUpdateTime=curtime+0.03
  if curtime>crPlayingCombatTimeNext then
    --перескакиваю через евент
    if crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+2] then
      crPlayingCombatEvent=crPlayingCombatEvent+1
      crPlayingCombatTimeLast=crPlayingCombatTimeNext
      crPlayingCombatTimeNext=curtime+((crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent+1].t-crsaveddata[crPlayingCombatID].events[crPlayingCombatEvent].t)/crPlaySpeed)
      --set Slider
      crCurrentClickedSLiderTime=nil
      changedEvent=1
      crPlaySlider:SetValue(crPlayingCombatEvent)
    else
      crStopReplay()
    end
  end
  crShowEventPlaying(changedEvent)
end


--выбран тултип "рендж чек"
if crRangeCheckRaidActive and curtime>crRangeCheckRaidActive then
  if crTempColorShow==nil then
    crTempColorShow=1
    crRangeCheckRaidActive=curtime+0.6
    crButtonToolRange:SetAlpha(1)
  else
    crRangeCheckRaidActive=curtime+0.3
    crTempColorShow=nil
    crButtonToolRange:SetAlpha(0.1)
  end
end



end






function cr_OnEvent(self,event,...)



  local arg1, arg2, arg3,arg4,arg5,arg6 = ...


  if event == "PLAYER_REGEN_DISABLED" and crOptTrackBoss then
  
  if (crwasresurrected and GetTime()<crwasresurrected+4) or crcheckbossincombatafterfight then
    crcheckbossincombatafterfight=nil
  else
    --проверка, мы в рейд инсте?
    local _, instanceType, pppl, _, maxPlayers, dif = GetInstanceInfo()
    if ((pppl and (pppl==3 or pppl==5 or pppl==4 or pppl==6 or pppl==14 or (pppl==7 and crOptTrackLfr))) or (select(3,GetInstanceInfo())==7 and crOptTrackLfr)) then
      --начался бой, через 2 сек проверяю босса и тогда трекерю
      crcheckbossincombat=GetTime()+2
    end
  end
  end
  
  if (event == "VARIABLES_LOADED" or event == "UI_SCALE_CHANGED") then
    crmain1:SetScale(0.7 / UIParent:GetScale())
  end



  if event == "PLAYER_REGEN_ENABLED" then
  crcheckbossincombatafterfight=GetTime()
  --если жив и вышел с боя
  if UnitIsDeadOrGhost("player")==nil then
    --конец боя
    crcheckbossincombatafterfight=nil
    crStopTracking()
  end
  end



  if event == "PLAYER_ALIVE" then
    crwasresurrected=1
  end


  --on login calculate all old data
  if event == "ADDON_LOADED" then
    if arg1=="CombatReplay_SavedData" then
      if crsaveddata and #crsaveddata>0 then
        for i=1,#crsaveddata do
          if crsaveddata[i].scale==nil then
            crPrepareVariabiles(i)
            --improve only 1 combat for relog
            break
          end
        end
      end
    end
  end



end --конец основной функции аддона








function CombatReplayFrame_Command(msg)

if crcombatin==nil then

  crmain1:Show()
  crframecenter:Show()
  crframetop:Show()
  crframeleft:Show()
  crframeright:Show()
  crframebottom:Show()

  crframeopen()

  if crsaveddata[1] then
    crShowCombat(1)
  else
    crCurrentTimeShow:SetText(crlocnocombatsaved)
  end

else
  print ("|cff99ffffCombatReplay|r - "..crloccannotbeopened)
end

end

function crHideFrames()

crStopReplay()

--откл. рендж чек
crRangeCheckRaidActive=1
crRangeCheckRaid()


crmain1:Hide()
crframecenter:Hide()
crframeoptions:Hide()
crframetop:Hide()
crframeleft:Hide()
crframeright:Hide()
crframebottom:Hide()

end


function crResetData()
if crcombatin==nil then
crsaveddata=nil
crcombatlog=nil
crsaveddata={}
crcombatlog={}
crPlayingCombatID=1
cropendropdowncombats()
else
print ("|cff99ffffCombatReplay|r - "..crlocnotincombatreset)
end
end