--[[
	Auctioneer Advanced - Price Level Utility module
	Version: 5.0.PRE.3262 (BillyGoat)
	Revision: $Id: MatchBeanCount.lua 3239 2008-07-18 04:55:58Z kandoko $
	URL: http://auctioneeraddon.com/

	This is an Auctioneer Advanced Matcher module that returns an undercut price 
	based on the current market snapshot

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:
		This AddOn's source code is specifically designed to work with
		World of Warcraft's interpreted AddOn system.
		You have an implicit licence to use this AddOn with these facilities
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
--]]
--if not BeanCounter then 
--	AucAdvanced.Print("BeanCounter not loaded")
--	return 
--end
if not AucAdvanced then return end

local libType, libName = "Match", "BeanCount"
local lib,parent,private = AucAdvanced.NewModule(libType, libName)
if not lib then return end
local print,decode,recycle,acquire,clone,scrub,get,set,default = AucAdvanced.GetModuleLocals()

function lib.Processor(callbackType, ...)
	if (callbackType == "tooltip") then
		--Called when the tooltip is being drawn.
		private.ProcessTooltip(...)
	elseif (callbackType == "config") then
		--Called when you should build your Configator tab.
		private.SetupConfigGui(...)
	elseif (callbackType == "listupdate") then
		--Called when the AH Browse screen receives an update.
	elseif (callbackType == "configchanged") then
		--Called when your config options (if Configator) have been changed.
	end
end

function lib.GetMatchArray(hyperlink, marketprice)
	local matchArray = {}
	if not AucAdvanced.Settings.GetSetting("match.beancount.enable") or not BeanCounter or not BeanCounter.API.isLoaded then --check setting is on, beancounter exists, and that the database is sound
		return 
	end
	local linkType,itemId,property,factor = AucAdvanced.DecodeLink(hyperlink)
	if (linkType ~= "item") then return end
	if (factor ~= 0) then property = property.."x"..factor end

	local marketdiff = 0
	local competing = 0
	if not marketprice then marketprice = 0 end
	local matchprice = marketprice
	local increase = AucAdvanced.Settings.GetSetting("match.beancount.success")
	local decrease = AucAdvanced.Settings.GetSetting("match.beancount.failed")
	local maxincrease = AucAdvanced.Settings.GetSetting("match.beancount.maxup")
	local maxdecrease = AucAdvanced.Settings.GetSetting("match.beancount.maxdown")
	local daterange = AucAdvanced.Settings.GetSetting("match.beancount.daterange")
	local matchstacksize = AucAdvanced.Settings.GetSetting("match.beancount.matchstacksize")
	local numdays = AucAdvanced.Settings.GetSetting("match.beancount.numdays")
	numdays = numdays * 86400
	increase = (increase / 100) + 1
	decrease = (decrease / 100) + 1
	itemId = tostring(itemId)

	local success = 0
	local failed = 0

if daterange then
		local now = time()
		local tempnum = 0
		if BeanCounter.Private.playerData["completedAuctions"][itemId] then
			for key in pairs(BeanCounter.Private.playerData["completedAuctions"][itemId]) do
				for i, text in pairs(BeanCounter.Private.playerData["completedAuctions"][itemId][key]) do
					local stack, _, _, _, _, _, _, auctime = strsplit(";", text)
					auctime, stack = tonumber(auctime), tonumber(stack)
					
					if matchstacksize then
						if (stack == AucAdvAppraiserFrame.salebox.stack:GetValue() ) and (now - auctime) < (numdays) then
							tempnum = tempnum + 1
						end
					elseif (now - auctime) < (numdays) then
						tempnum = tempnum + 1
					end
				end
			end
		end
		success = tempnum
		tempnum = 0
		if BeanCounter.Private.playerData["failedAuctions"][itemId] then
			for key in pairs(BeanCounter.Private.playerData["failedAuctions"][itemId]) do
				for i, text in pairs(BeanCounter.Private.playerData["failedAuctions"][itemId][key]) do
					local stack, _, _, _, auctime = strsplit(";", text)
					auctime, stack = tonumber(auctime), tonumber(stack)
					
					if matchstacksize then
						if (stack == AucAdvAppraiserFrame.salebox.stack:GetValue() ) and (now - auctime) < (numdays) then
							tempnum = tempnum + 1
						end
					elseif (now - auctime) < (numdays) then
						tempnum = tempnum + 1
					end
				end
			end
		end
		failed = tempnum
	else
		if BeanCounter and BeanCounter.Private.playerData then
			if BeanCounter.Private.playerData["completedAuctions"][itemId] then
				for key in pairs(BeanCounter.Private.playerData["completedAuctions"][itemId]) do
					success = success + #BeanCounter.Private.playerData["completedAuctions"][itemId][key]
				end
			end
			if BeanCounter.Private.playerData["failedAuctions"][itemId] then
				for key in pairs(BeanCounter.Private.playerData["failedAuctions"][itemId]) do
					failed = failed + #BeanCounter.Private.playerData["failedAuctions"][itemId][key]
				end
			end
		end
	end
	
	increase = math.pow(increase, math.pow(success, 0.8))
	decrease = math.pow(decrease, math.pow(failed, 0.8))
	matchprice = matchprice * increase
	matchprice = matchprice * decrease
	
	if (marketprice > 0) then
		if (matchprice > (marketprice * (maxincrease*0.01))) then
			matchprice = (marketprice * (maxincrease*0.01))
		elseif (matchprice < (marketprice * (maxdecrease*0.01))) then
			matchprice = (marketprice * (maxdecrease*0.01))
		end		
		marketdiff = (((matchprice - marketprice)/marketprice)*100)
		if (marketdiff-floor(marketdiff))<0.5 then
			marketdiff = floor(marketdiff)
		else
			marketdiff = ceil(marketdiff)
		end
	else
		marketdiff = 0
	end
	matchArray.value = matchprice
	matchArray.diff = marketdiff
	matchArray.returnstring = "BeanCount: % change: "..tostring(marketdiff)
	if AucAdvanced.Settings.GetSetting("match.beancount.showhistory") then
		matchArray.returnstring = "BeanCount: Succeeded: "..tostring(success).."\nBeanCount: Failed: "..tostring(failed).."\n"..matchArray.returnstring
	end
	return matchArray
end

local array = {}

function private.ProcessTooltip(frame, name, hyperlink, quality, quantity, cost, additional)

end

--function lib.OnLoad()
	--This function is called when your variables have been loaded.
	--You should also set your Configator defaults here

	print("AucAdvanced: {{"..libType..":"..libName.."}} loaded!")
	AucAdvanced.Settings.SetDefault("match.beancount.enable", false)
	AucAdvanced.Settings.SetDefault("match.beancount.daterange", false)
	AucAdvanced.Settings.SetDefault("match.beancount.matchstacksize", false)
	AucAdvanced.Settings.SetDefault("match.beancount.numdays", 30)
	AucAdvanced.Settings.SetDefault("match.beancount.failed", -0.1)
	AucAdvanced.Settings.SetDefault("match.beancount.success", 0.1)
	AucAdvanced.Settings.SetDefault("match.beancount.maxup", 150)
	AucAdvanced.Settings.SetDefault("match.beancount.maxdown", 50)
	AucAdvanced.Settings.SetDefault("match.beancount.showhistory", true)
--end

--[[ Local functions ]]--

function private.SetupConfigGui(gui)
	-- The defaults for the following settings are set in the lib.OnLoad function
	local id = gui:AddTab(libName, libType.." Modules")
	--gui:MakeScrollable(id)

	gui:AddHelp(id, "what beancount module",
		"What is this BeanCount module?",
		"The BeanCount module uses BeanCounter's data to adjust the price based on the item's past selling history.")

	gui:AddControl(id, "Header",     0,    libName.." options")
	
	gui:AddControl(id, "Subhead",    0,    "Price Adjustments")
	
	gui:AddControl(id, "Checkbox",   0, 1, "match.beancount.enable", "Enable Auc-Match-BeanCount")
	
	gui:AddControl(id, "WideSlider", 0, 1, "match.beancount.failed", -20, 0, 0.1, "Auction failure markdown: %g%%")
	gui:AddTip(id, "This controls how much you want to markdown an auction for every time it has failed to sell.\n"..
		"This is cumulative.  ie a setting of 10% with two failures will set the price at 81% of market")
	
	gui:AddControl(id, "WideSlider", 0, 1, "match.beancount.success", 0, 20, 0.1, "Auction success markup: %g%%")
	gui:AddTip(id, "This controls how much you want to markup an auction for every time it has sold.\n"..
		"This is cumulative.  ie a setting of 10% with two successes will set the price at 121% of market")
		
	gui:AddControl(id, "WideSlider", 0, 1, "match.beancount.maxup", 101, 300, 1, "Maximum: %g%%")
	gui:AddTip(id, "Sets the maximum that you are willing to set the price at, as a % of baseline")
		
	gui:AddControl(id, "WideSlider", 0, 1, "match.beancount.maxdown", 1, 99, 1, "Minimum: %g%%")
	gui:AddTip(id, "Sets the minimum that you are willing to set the price at, as a % of baseline")
		
	gui:AddControl(id, "Checkbox",   0, 1, "match.beancount.showhistory", "Show history of successes and failures")
	gui:AddTip(id, "This will add the number of successes and failures for that item to Appraiser's right-hand panel")
	
	gui:AddControl(id, "Checkbox",   0, 1, "match.beancount.daterange", "Only use recent data")
	gui:AddTip(id, "Only use data from the last x days, as set by the slider.")
	gui:AddControl(id, "WideSlider", 0, 2, "match.beancount.numdays", 1, 300, 1, "Use data from last %g days")
	gui:AddTip(id, "Only use data from the last x days, as set by the slider.")
	
	gui:AddControl(id, "Checkbox",   0, 1, "match.beancount.matchstacksize", "Seprerate data by stack size. Only available if Use recent data is set")
	gui:AddTip(id, "Only use data for the current stack size.")
end

AucAdvanced.RegisterRevision("$URL: http://svn.norganna.org/auctioneer/trunk/BeanCounter/MatchBeanCount.lua $", "$Rev: 3239 $")