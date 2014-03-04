--   Copyright 2011 James C. Jones <pug@pugsplace.net>
--
--   Licensed under the Apache License, Version 2.0 (the "License");
--   you may not use this file except in compliance with the License.
--   You may obtain a copy of the License at
--
--       http://www.apache.org/licenses/LICENSE-2.0
--
--   Unless required by applicable law or agreed to in writing, software
--   distributed under the License is distributed on an "AS IS" BASIS,
--   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--   See the License for the specific language governing permissions and
--   limitations under the License.
-- 

-- Global configs
onTime=100
notOnTime=-0
autoCombatLog=true

-- Globals
cmds={}
names={}

-- Functions
function EPGP_ONTIME_getTable(checkLate)
  OpenCalendar()

  weekday,month,day,year=CalendarGetDate()

  CalendarOpenEvent(0, day, 1)

  title, hour, minute, calendarType, sequenceType, eventType, texture, modStatus, inviteStatus = CalendarGetDayEvent(0, day, 1)

  n=CalendarEventGetNumInvites()

  -- Clear out tables
  cmds={}
  names={}

  for inv = 1, n, 1 do
     name, level, className, classFilename, inviteStatus, modStatus = CalendarEventGetInvite(inv)
     -- Did they accept?
     if (inviteStatus == CALENDAR_INVITESTATUS_ACCEPTED  or
         inviteStatus == CALENDAR_INVITESTATUS_CONFIRMED) then
        row=nil

        mainName=EPGP:GetMain(name)
        inRaid=false

        -- In raid is being in the award list and there being a raid
        if (UnitInRaid("Player") and 
           (
              (nil ~= EPGP:IsMemberInAwardList(mainName) or 
                 (nil ~= EPGP:IsMemberInAwardList(name))
              )
           )
        ) then
           inRaid=true
        end

	-- Main logic
        if (true==checkLate) then
          -- Are they AWOL?
	  if(false == inRaid) then
            row={notOnTime, "AWOL", name, title}
	  end
        else
	  -- Are they on time?
	  if (true == inRaid) then
            row={onTime, "On Time", name, title}
	  end
        end

	if (row ~= nil) then
          -- Add to table
	  cmds[mainName]=row
          table.insert(names, mainName)
        end

     end -- if accepted or confirmed
  end -- for each invite

  CalendarCloseEvent()
end

function EPGP_ONTIME_askAndProcess(cur)
   name=names[cur]
   if nil == name then
      return
   end
   
   d=cmds[name]
   desc=string.format("[%d/%d] Update %s with %d [%s]?", cur, #names, name, d[1], d[2])
   
   StaticPopupDialogs[name] = {
      text = desc,
      button1 = "Yes",
      button2 = "No",
      timeout = 0,
      whileDead = true,
      hideOnEscape = true,
      OnAccept = function(self, data)
         name=names[data]
         d=cmds[name]
         reason=string.format("%s to %s", d[2], d[4])
         amt=d[1]
         
         assert(amt)
         assert(reason)
         
         EPGP:IncEPBy(name, reason, amt, false, false)
         
         -- Continue
         EPGP_ONTIME_askAndProcess(data+1)
      end,
      OnCancel = function(self, data)
         -- Continue
         EPGP_ONTIME_askAndProcess(data+1)
      end,
      
   }
   
   pop=StaticPopup_Show (name)
   pop.data=cur
end


-- Now reveal table
function EPGP_ONTIME_run(checkLate)
  EPGP_ONTIME_getTable(checkLate)

  if #names > 0 then
     DEFAULT_CHAT_FRAME:AddMessage(string.format("Found %d attendees, processing...", #names))
     EPGP_ONTIME_askAndProcess(1)
  else
     DEFAULT_CHAT_FRAME:AddMessage("No raid found")
  end
end

function EPGP_ONTIME_CMD(cmd)
  if ("start" == cmd) then
    EPGP_ONTIME_run(false)
    -- Automatically start the combat log?
    if (true==autoCombatLog) then
      DEFAULT_CHAT_FRAME:AddMessage("Starting combat log...")
      LoggingCombat(true)
    end
  elseif ("late" == cmd) then
    EPGP_ONTIME_run(true)
  else
    DEFAULT_CHAT_FRAME:AddMessage("Syntax: /epgp-ontime [start/late]")
  end
end

SLASH_EPGPONTIME1 = "/epgp-ontime";
SlashCmdList["EPGPONTIME"] = EPGP_ONTIME_CMD;
