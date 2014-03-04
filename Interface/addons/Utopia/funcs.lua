local Utopia = LibStub("AceAddon-3.0"):GetAddon("Utopia", true)
if (not Utopia) then
	return
end
Utopia:UpdateVersion("$Revision: 191 $")

--[===[@debug@
ZDEBUG = 1
--@end-debug@]===]
local function d(fmt, ...)
	if (ZDEBUG) then
		fmt = fmt:gsub("(%%[sdqxf])", "|cFF60FF60%1|r")
		ChatFrame1:AddMessage("|cFFFF8080DEBUG:|r "..format(fmt, ...), 0.8, 0.8, 0.8)
	end
end
Utopia.debugprint = d

local new, del, copy, deepDel
do
--[===[@debug@
	--local freed = {}
	local protect = {
		__newindex = function(self)
			--local stack = freed[self]
			--if (stack) then
			--	ChatFrame1:AddMessage("Attempt to access a recycled table freed from: "..stack)
			--end
			error("Attempt to assign to a recycled table")
		end,
		__index = function(self)
			--local stack = freed[self]
			--if (stack) then
			--	ChatFrame1:AddMessage("Attempt to access a recycled table freed from: "..stack)
			--end
			error("Attempt to access a recycled table")
		end,
	}
--@end-debug@]===]

	local next, select, pairs, type = next, select, pairs, type
	local list = setmetatable({},{__mode='k'})

	function new(...)
		local t = next(list)
		if t then
			list[t] = nil
--[===[@debug@
			--freed[t] = nil
			setmetatable(t, nil)
			assert(not next(t))
--@end-debug@]===]
			for i = 1, select('#', ...) do
				t[i] = select(i, ...)
			end
			return t
		else
			t = {...}
			return t
		end
	end
	function del(t)
		if (t) then
			setmetatable(t, nil)

			wipe(t)
			t[''] = true
			t[''] = nil
			list[t] = true
--[===[@debug@
			--freed[t] = debugstack()
			assert(not next(t))
			setmetatable(t, protect)
--@end-debug@]===]
		end
	end
	function deepDel(t)
		if (t) then
			setmetatable(t, nil)

			for k,v in pairs(t) do
				if type(v) == "table" then
					deepDel(v)
				end
				t[k] = nil
			end
			t[''] = true
			t[''] = nil
			list[t] = true
--[===[@debug@
			--freed[t] = debugstack()
			assert(not next(t))
			setmetatable(t, protect)
--@end-debug@]===]
		end
	end
--[===[@debug@
	local rec
--@end-debug@]===]
	function copy(old)
		if (not old) then
			return
		end
--[===[@debug@
		local delrec
		if (not rec) then
			delrec = true
			rec = new()
		end
--@end-debug@]===]
		local n = new()
		for k,v in pairs(old) do
			if (type(v) == "table") then
--[===[@debug@
				assert(not rec[v], "copy() recursion")
--@end-debug@]===]
				n[k] = copy(v)

--[===[@debug@
				rec[v] = true
--@end-debug@]===]
			else
				n[k] = v
			end
		end
		setmetatable(n, getmetatable(old))
--[===[@debug@
		if (delrec) then
			rec = del(rec)
		end
--@end-debug@]===]
		return n
	end
end
Utopia.new, Utopia.del, Utopia.copy, Utopia.deepDel = new, del, copy, deepDel

do
	local format, min, max = string.format, math.min, math.max
	local r, g, b, sr, sg, sb
	local function push(c)
		local ret = format("|cFF%02X%02X%02X%s", r * 255, g * 255, b * 255, c)
		r = max(0, min(1, r + sr))
		g = max(0, min(1, g + sg))
		b = max(0, min(1, b + sb))
		return ret
	end

	function Utopia.Gradient(str, r1, g1, b1, r2, g2, b2)
		r, g, b = r1, g1, b1
		sr = (r2 - r1) / (#str - 1)
		sg = (g2 - g1) / (#str - 1)
		sb = (b2 - b1) / (#str - 1)
		return str:gsub(".", push)
	end
end

local UnitFullName
do
	local UnitName, format = UnitName, format
	function Utopia.UnitFullName(unit)
		local name, server = UnitName(unit)
		if (server and server ~= "") then
			return format("%s-%s", name, server)
		end
		return name
	end
	UnitFullName = Utopia.UnitFullName
end

do
	local classColours = {}
	for class, c in pairs(CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS) do
		classColours[class] = format("|cFF%02X%02X%02X", c.r * 255, c.g * 255, c.b * 255)
	end

	function Utopia.ClassColour(class)
		return classColours[class] or "|cFF808080"
	end

	function Utopia:ColourPlayer(unit)
		local name = UnitFullName(unit) or unit
		if (UnitIsPlayer(unit)) then
			local _, class = UnitClass(unit)
			return format("%s%s|r", class and classColours[class] or "|cFF808080", name)
		else
			local r, g, b = Utopia:ReactionColour(unit)
			return format("|cFF%02X%02X%02X%s|r", r * 255, g * 255, b * 255, name)
		end
	end
end

-- SmoothColourStr
function Utopia.SmoothColourStr(percentage, light)
	local r, g, b = Utopia.SmoothColour(percentage, light)
	return format("|cFF%02X%02X%02X", r * 255, g * 255, b * 255)
end

-- SmoothColour
function Utopia.SmoothColour(percentage, light)
	local r, g
	if (percentage < 0.5) then
		g = min(1, max(0, 2*percentage))
		r = 1
		if (light) then
			g = g / 2 + 0.5
		end
	else
		g = 1
		r = min(1, max(0, 2*(1 - percentage)))
		if (light) then
			r = r / 2 + 0.5
		end
	end
	return r, g, light and 0.5 or 0
end

-- rotate
-- Positive angle is clockwise rotation
function Utopia.rotate(angle)
	local hcos, hsin = 0.5 * cos(angle), 0.5 * sin(angle)
	local mhcos, mhsin = -hcos, -hsin
	local ULx, ULy, LLx, LLy = hcos - mhsin, mhsin + hcos, hcos - hsin, mhsin + mhcos
	local URx, URy, LRx, LRy = mhcos - mhsin, hsin + hcos, mhcos - hsin, hsin + mhcos
	return ULx+0.5, ULy+0.5, LLx+0.5, LLy+0.5, URx+0.5, URy+0.5, LRx+0.5, LRy+0.5
end

function Utopia.propercase(str)
	return str and (strupper(strsub(str, 1, 1))..strlower(strsub(str, 2)))
end

-- SetFormattedNumber
function Utopia.SetFormattedNumber(self, num)
	local low = num % 1000
	if (num >= 1000) then
		local mid = floor(num / 1000) % 1000
		if (num >= 1000000) then
			local high = floor(num / 1000000) % 1000
			self:SetFormattedText("%d,%03d,%03d", high, mid, low)
		else
			self:SetFormattedText("%d,%03d", mid, low)
		end
	else
		self:SetFormattedText("%d", num)
	end
end
