local Utopia = LibStub("AceAddon-3.0"):GetAddon("Utopia", true)
if (not Utopia) then
	return
end
Utopia:UpdateVersion("$Revision: 183 $")
local L = LibStub("AceLocale-3.0"):GetLocale("Utopia")
local d = Utopia.debugprint
local module = Utopia.modules.UpTime
local new, del, copy, deepDel = Utopia.new, Utopia.del, Utopia.copy, Utopia.deepDel
local commPrefix = "Utopia_UpTime"

local matchChat
local function chatFilter(self, event, ...)
	local msg = ...
	if (matchChat and module.sendQueue) then
		local name = strmatch(msg, matchChat)
		if (name) then
			local purge, warned
			for i,info in pairs(module.sendQueue) do
				if (info.target == name) then
					info.mode.state = "OFFLINE"
					if (not purge) then
						purge = new()
						module:Print(format(L["Send failed; %s is offline"], Utopia:ColourPlayer(name)))
					end
					tinsert(purge, i)
				end
			end
			if (purge) then
				for i = #purge,1,-1 do
					module:DeleteFromQueue(purge[i])
				end
			end
			del(purge)
			return true, ...
		end
	end
	return false, ...
end

-- QueueSendFights
function module:QueueSendFights(who, ...)
	if (not self.sendQueue) then
		self.sendQueue = new()
	end

	local n = new()
	n.target = who
	n.items = new()

	local db = self.db.profile
	for i = 1,select("#", ...) do
		local fight = db.history[select(i, ...)]
		if (fight) then
			tinsert(n.items, fight.combatStart)
		end
	end

	matchChat = ERR_CHAT_PLAYER_NOT_FOUND_S:gsub("%%s", "([^']+)")
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", chatFilter)
	tinsert(self.sendQueue, n)
	self:ProcessSendQueue()
	if (self.sendQueue) then
		self.sendTimer = self:ScheduleRepeatingTimer("ProcessSendQueue", 2)
	end
end

-- ProcessSendQueue
function module:ProcessSendQueue()
	if (not self.sendQueue) then
		return
	end

	local purge, sending
	for i,info in ipairs(self.sendQueue) do
		if (not info.mode) then
			self:SendCommMessage(commPrefix, "WTS "..#info.items, "WHISPER", info.target)
			info.mode = new()
			info.mode.state = "WTS"
			info.mode.try = time()
		else
			if (info.mode.state == "WTB") then
				if (not sending) then
					sending = true
					self:SendQueueItem(info)
					if (not purge) then
						purge = new()
					end
					tinsert(purge, i)
				end

			elseif (info.mode.state == "WTS") then
				if (info.mode.try < time() - 5) then
					info.mode.state = "OFFLINE"
					self:Print(format(L["Send failed; %s is not running Utopia_UpTime"], Utopia:ColourPlayer(info.target)))
					if (not purge) then
						purge = new()
					end
					tinsert(purge, i)
				end

			elseif (info.mode.state == "WAITACCEPT") then
				if (info.mode.try < time() - 30) then
					self:Print(format(L["%s did not accept within thirty seconds; cancelled"], info.target))
					if (not purge) then
						purge = new()
					end
					tinsert(purge, i)
				end
			end
		end
	end
	if (purge) then
		for i = #purge,1,-1 do
			self:DeleteFromQueue(purge[i])
		end
	end
	del(purge)

	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", chatFilter)
end

-- OnCommReceived
function module:OnCommReceived(prefix, msg, channel, sender)
	if (sender == playerName) then
		return
	end
	if (prefix == commPrefix) then
		local cmd, str = msg:match("^(%a+) *(.*)$")
		if (not cmd) then
			return
		end

		if (cmd == "WTS") then
			self:SendCommMessage(commPrefix, "GOT"..msg, "WHISPER", sender)
			self:Print(format(L["%s wants to send you %d fight debuff |4log:logs;"], Utopia:ColourPlayer(sender), str))
			self:Print(format(L["|cFF80FF80|Hutopia_accept:%s:%s|h[Click here to accept]|h|r"], sender, str))

		elseif (cmd == "WTB" or cmd == "GOTWTS") then
			local count = tonumber(str)
			if (count) then
				if (self.sendQueue) then
					for i,info in ipairs(self.sendQueue) do
						if (info.mode and strlower(info.target) == strlower(sender) and #info.items == count) then
							if (cmd == "WTB") then
								info.mode.state = "WTB"
								self:ProcessSendQueue()
							elseif (cmd == "GOTWTS") then
								info.mode.state = "WAITACCEPT"
							end
							break
						end
					end
				end
			end

		elseif (cmd == "FIGHT") then
			local valid, fight = self:Deserialize(str)
			if (valid) then
				if (type(fight) == "table" and fight.mobs and fight.players and fight.data) then
					local fightName = module:FightName(fight)
					local link = format("|cFF80FF80|Hutopia_fight:%d:%s|h[%s]|h|r", fight.combatStart, sender, L["View"])
					self:Print(format(L["Received from %s: Fight data for |cFFFF0000%s|r %s"], self:ColourPlayerFromFight(fight, sender), fightName, link))

					fight.received = time()
					fight.receivedFrom = sender
					local db = self.db.profile
					tinsert(db.history, fight)
					Utopia.callbacks:Fire("Utopia_FightAdded", #db.history)
				end
			end
		end
	end
end

-- AcceptFightSendQuery
function module:AcceptFightSendQuery(who, count)
	self:SendCommMessage(commPrefix, "WTB "..count, "WHISPER", who)
end

-- DeleteFromQueue
function module:DeleteFromQueue(index)
	if (self.sendQueue) then
		local old = tremove(self.sendQueue, index)
		old = deepDel(old)

		if (not next(self.sendQueue)) then
			self.sendQueue = del(self.sendQueue)
			self:CancelTimer(self.sendTimer)
			self.sendTimer = nil

			self:Print(format(L["Finished sending"]))

			ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", chatFilter)
		end
	end
end

-- SendQueueItem
function module:SendQueueItem(info)
	local db = self.db.profile

	info.mode = del(info.mode)
	for i,timestamp in ipairs(info.items) do
		for j,fight in ipairs(db.history) do
			if (fight.combatStart == timestamp) then
				local fightName = module:FightName(fight)
				self:Print(format(L["Sending to %s: Fight data for |cFFFF0000%s|r"], Utopia:ColourPlayer(info.target), fightName))

				local str = self:Serialize(fight)
				self:SendCommMessage(commPrefix, "FIGHT "..str, "WHISPER", info.target)
				break
			end
		end
	end
end

module:RegisterComm(commPrefix)
