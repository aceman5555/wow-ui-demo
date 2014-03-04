local sm = {}
local inRaid = {}
local outRaid = {}
local tracking = false

local frame = CreateFrame("Frame", nil, UIParent)

frame:RegisterEvent("CHAT_MSG_WHISPER")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

frame:SetScript("OnEvent", function (self, event, ...)
	arg1,arg2 = ...
	if (event == "CHAT_MSG_WHISPER") then
		sm:CHAT_MSG_WHISPER(arg1, arg2)
	else
		sm[event](...)
	end
end)

function sm:PLAYER_ENTERING_WORLD()
	DEFAULT_CHAT_FRAME:AddMessage("WOOOOOOOOOOORRRRRRRRRRRLLLLLLLLLLLLLDDDDDDDDDDDDDD");
	if (not SitMe) then
		SitMe = {
			["stuff"] = 1
		}
	end
end

function sm:CHAT_MSG_WHISPER(message, sender)
	if (not tracking) then
		return
	end
end

function sm:start(encounter)
	local index = encounter:find(" ")
	local healers = encounter:sub(1, index - 1)
	local encounter = encounter:sub(index + 1)
	local i;
	local n = 25
	local role

	inRaid = {}
	outRaid = {}


	log("START - Now tracking encounter: " .. healers .. ' ' .. encounter)
	tracking = true

	for i = 1, 40 do
		local name,rank,subgroup = GetRaidRosterInfo(i)

		if (name) then
			role = UnitGroupRolesAssigned(name)
			log(name  .. " " .. subgroup .. " " .. role)

			if (i < 26) then
				table.insert(inRaid, {["name"] = name, ["role"] = role})
				//log(inRaid[table.getn(inRaid)]["name"])
			else
				table.insert(outRaid, {["name"] = name, ["role"] = role})
			end
		end
	end

end

function sm:stop()
	log("STOP - No longer tracking")
	tracking = false
end

function log(msg)
	DEFAULT_CHAT_FRAME:AddMessage("SitMe: |cffffff00" .. msg)
end

function sm:announce(msg, type, target)
	type = type or "RAID"
	SendChatMessage(msg, type, nil, target)
end

function SitMe_SlashCmd(msg)
	if (msg == "" or msg == nil) then
		log("Following commands for /sm:")
		log("stop - ends the currnt tracking time")
		log("[num healers] [encounter name] - starts tracking who wants to sit")
		return
	end
	if (msg:lower() == "stop") then
		sm:stop()
		return
	end
	sm:start(msg)
end

SLASH_SITME1 = "/sm";
SlashCmdList["SITME"] = SitMe_SlashCmd
