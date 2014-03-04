--ы
function crShowOptions()
crStopReplay()

crframecenter:Hide()
crframetop:Hide()
crframeleft:Hide()
crframeright:Hide()
crframebottom:Hide()
crframeoptions:Show()

if crOptTrackBoss then crframeoptions_CheckButton1:SetChecked() else crframeoptions_CheckButton1:SetChecked(false) end
if crPlayerIconPositionShow then crframeoptions_CheckButton2:SetChecked() else crframeoptions_CheckButton2:SetChecked(false) end
if crOptTrackLfr then crframeoptions_CheckButton3:SetChecked() else crframeoptions_CheckButton3:SetChecked(false) end
if crShowPlayersHpDynamic then crframeoptions_CheckButton4:SetChecked() else crframeoptions_CheckButton4:SetChecked(false) end


--слайдер для размеров квадратов-игроков

    getglobal("crPlayersSizeSliderHigh"):SetText("50")
    getglobal("crPlayersSizeSliderLow"):SetText("3")
    crPlayersSizeSlider:SetMinMaxValues(3, 50)
    crPlayersSizeSlider:SetValueStep(1)
    crPlayersSizeSlider:SetWidth(200)
    crPlayersSizeSlider:SetValue(crPlayersSizeOnMap)
    crPlayersSizeSlider:SetScript("OnValueChanged", function(self)
      crPlayersSizeOnMap=math.floor(crPlayersSizeSlider:GetValue())
      crframeoptions_PlayersSize:SetText(crlocplayerssize..": "..crPlayersSizeOnMap)
      for i=1,25 do
        crPlayersFrames[i]:SetWidth(crPlayersSizeOnMap)
        crPlayersFrames[i]:SetHeight(crPlayersSizeOnMap)
        crPlayersFramesIcons[i]:SetWidth(crPlayersSizeOnMap-2)
        crPlayersFramesIcons[i]:SetHeight(crPlayersSizeOnMap-2)
        if crPlayerIconPositionShow then
          crPlayersFramesIcons[i]:SetPoint("CENTER",0,crPlayersSizeOnMap+1)
        else
          crPlayersFramesIcons[i]:SetPoint("CENTER",0,0)
        end
        crPlayersFramesNames[i]:SetPoint("CENTER",0,crPlayersSizeOnMap/2+8)
      end
      end )







end


function crCloseOptions()

crframeoptions:Hide()
crframecenter:Show()
crframetop:Show()
crframeleft:Show()
crframeright:Show()
crframebottom:Show()

if #crsaveddata>0 then
  if crPlayingCombatID then
    crShowEventFrame(crPlayingCombatID,crPlayingCombatEvent)
  else
    crShowEventFrame(1)
  end
end

end


function crajustsizelefthp()
for i=1,#crPlayersButtonsColor do
	crPlayersButtonsColor[i]:SetWidth(128)
end
end


function crOptPlayerIconChange()
if crPlayerIconPositionShow then
  crPlayerIconPositionShow=false
else
  crPlayerIconPositionShow=true
end
for i=1,25 do
    if crPlayerIconPositionShow then
      crPlayersFramesIcons[i]:SetPoint("CENTER",0,crPlayersSizeOnMap+1)
    else
      crPlayersFramesIcons[i]:SetPoint("CENTER",0,0)
    end
end
end