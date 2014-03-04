if (ar_whisper == nil) then
  ar_whisper = 'off'
end  
  
if (ar_emote == nil) then
  ar_emote = 'off'
end

local function acceptRezz(self, event, target)
  -- if rezzing char is out of combat
  if UnitAffectingCombat(target)==nil then
    -- accept resurrection
		AcceptResurrect()
		-- print message who rezzed you
		print("Automatically rezzed by "..target)
		
		
		local msg = "Thank you"
		 
    if (GetLocale() == "deDE") then
      msg = "Danke"
    end
		
    -- send him/her a thank you whisper
		if (ar_whisper == 'on') then
		  SendChatMessage(msg..", "..target, "WHISPER", nil, target)
		end
		
		-- send him/her a thank you emote		
		if (ar_emote == 'on') then
		  DoEmote("thank", target)
		end
	end                                                                         	
end

--slash command handler
SLASH_AUTOREZ1, SLASH_AUTOREZ2 = '/ar', '/autorez';

local function handler(msg, editbox)
   
   -- if the suffix of the slash command is 'status'
  if (msg == 'status') then
    -- initialise pw_addonstate and pw_soundstate, unfortunately
    if ar_emote == nil then ar_emote = 'off' end
    if ar_whisper == nil then ar_whisper = 'off' end
    
    -- print status
    print('AutoRez status: \n Emote: '..ar_emote..' \n Whisper: '..ar_whisper)
    
  elseif (msg == 'emote on') then
    ar_emote = 'on'
    print("AutoRez: "..msg)
  elseif (msg == 'emote off') then
    ar_emote = 'off'
    print("AutoRez: "..msg)
  elseif (msg == 'whisper on') then
    ar_whisper = 'on'  
    print("AutoRez: "..msg)
  elseif (msg == 'whisper off') then
    ar_whisper = 'off'
    print("AutoRez: "..msg)
  -- if slash command was not followed by suffix, toggle status
  elseif (msg == '') then
    --print help
    print("AutoRez options/parameters \n - status: print status of emote and whisper replies \n - emote [on/off]: Toggle emote output after rez \n - whisper [on/off]: Toggle whisper output after rez")
  end
end


SlashCmdList["AUTOREZ"] = handler; -- Also a valid assignment strategy

local AutoRezz = CreateFrame("Frame", "AutoRezz")
AutoRezz:RegisterEvent("RESURRECT_REQUEST");
AutoRezz:SetScript("OnEvent", acceptRezz);

