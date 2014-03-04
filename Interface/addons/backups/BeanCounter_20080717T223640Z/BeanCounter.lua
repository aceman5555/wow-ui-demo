--[[
	Auctioneer Addon for World of Warcraft(tm).
	Version: 5.0.PRE.3117 (BillyGoat)
	Revision: $Id: BeanCounter.lua 3109 2008-05-15 19:51:36Z kandoko $

	BeanCounterCore - BeanCounter: Auction House History
	URL: http://auctioneeraddon.com/
	
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
		since that is it's designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
]]

--AucAdvanced.Modules["Util"]["BeanCounter"]

local libName = "BeanCounter"
local libType = "Util"
local lib 
BeanCounter={}
lib = BeanCounter
lib.API = {}
local private = {
	--BeanCounterCore
	playerName = UnitName("player"),
	realmName = GetRealmName(),
	AucModule, --registers as an auctioneer module if present and stores module local functions
	faction = nil,
	version = 2.00,
	wealth, --This characters current net worth. This will be appended to each transaction.
	compressed = false,
	
	playerData, --Alias for BeanCounterDB[private.realmName][private.playerName]
	serverData, --Alias for BeanCounterDB[private.realmName]
		
	--BeanCounter Bids/posts
	PendingBids = {},
	PendingPosts = {},
	
	--BeanCounterMail 
	reconcilePending = {},
	inboxStart = {},
	}
	
lib.Private = private --allow beancounter's sub lua's access
--Taken from AucAdvCore
function BeanCounter.Print(...)
	local output, part
	for i=1, select("#", ...) do
		part = select(i, ...)
		part = tostring(part):gsub("{{", "|cffddeeff"):gsub("}}", "|r")
		if (output) then output = output .. " " .. part
		else output = part end
	end
	DEFAULT_CHAT_FRAME:AddMessage(output, 0.3, 0.9, 0.8)
end

local print = BeanCounter.Print

local function debugPrint(...) 
    if private.getOption("util.beancounter.debugCore") then
        private.debugPrint("BeanCounterCore",...)
    end
end

--used to allow beancounter to recive Processor events from Auctioneer. Allows us to send a search request to BC GUI
if AucAdvanced and AucAdvanced.NewModule then
	private.AucModule = AucAdvanced.NewModule(libType, libName) --register as an Adv Module for callbacks
	local get, set, default = select(7, AucAdvanced.GetModuleLocals()) --Get locals for use getting settings
	private.AucModule.locals = {["get"] = get, ["set"] = set, ["default"] = default}
end
function private.AucModule.Processor(callbackType, ...)
	if (callbackType == "querysent") and lib.API.isLoaded then --if BeanCounter has disabled itself  dont try looking for auction House links
		local item = ...
		if item.name then BeanCounter.externalSearch(item.name) end
	end
end

lib.API.isLoaded = false
function lib.OnLoad(addon)
	private.initializeDB() --create or initialize the saved DB
	--Check if user is trying to use old client with newer database or if the database has failed to update
	if private.version and BeanCounterDB and BeanCounterDB[private.realmName][private.playerName].version then
		if private.version < BeanCounterDB[private.realmName][private.playerName].version then
			private.CreateErrorFrames("bean older", private.version, BeanCounterDB[private.realmName][private.playerName].version)
			return
		elseif private.version ~= BeanCounterDB[private.realmName][private.playerName].version then
			private.CreateErrorFrames("failed update", private.version, BeanCounterDB[private.realmName][private.playerName].version)
			return
		end
	end
	--Continue loading if the Database is ready
	lib.MakeGuiConfig() --create the configurator GUI frame
	private.CreateFrames() --create our framework used for AH and GUI
	private.slidebar() --create slidebar icon
	
	private.scriptframe:RegisterEvent("PLAYER_MONEY")
	private.scriptframe:RegisterEvent("PLAYER_ENTERING_WORLD")
	private.scriptframe:RegisterEvent("MAIL_INBOX_UPDATE")
	private.scriptframe:RegisterEvent("UI_ERROR_MESSAGE")
	private.scriptframe:RegisterEvent("MAIL_SHOW")
	private.scriptframe:RegisterEvent("MAIL_CLOSED")
	private.scriptframe:RegisterEvent("UPDATE_PENDING_MAIL")
	private.scriptframe:RegisterEvent("MERCHANT_SHOW")	
	private.scriptframe:RegisterEvent("MERCHANT_UPDATE")
	private.scriptframe:RegisterEvent("MERCHANT_CLOSED")
			
	private.scriptframe:SetScript("OnUpdate", private.onUpdate)
	
	-- Hook all the methods we need
	Stubby.RegisterAddOnHook("Blizzard_AuctionUi", "BeanCounter", private.AuctionUI) --To be standalone we cannot depend on AucAdv for lib.Processor
	--mail
	Stubby.RegisterFunctionHook("TakeInboxMoney", -100, private.PreTakeInboxMoneyHook);
	Stubby.RegisterFunctionHook("TakeInboxItem", -100, private.PreTakeInboxItemHook);
	--Bids
	Stubby.RegisterFunctionHook("PlaceAuctionBid", 50, private.postPlaceAuctionBidHook)
	--Posting
	Stubby.RegisterFunctionHook("StartAuction", -50, private.preStartAuctionHook)
	--Vendor
	--hooksecurefunc("BuyMerchantItem", private.merchantBuy)
	lib.API.isLoaded = true
end

--Create the database
function private.initializeDB()  
	if not BeanCounterDB  then
		BeanCounterDB  = {}
		BeanCounterDB["settings"] = {}
		BeanCounterDB["ItemIDArray"] = {}
	end
	if not BeanCounterDB[private.realmName] then
		BeanCounterDB[private.realmName] = {}
		
	end
	if not BeanCounterDB[private.realmName][private.playerName] then
		BeanCounterDB[private.realmName][private.playerName] = {}
		BeanCounterDB[private.realmName][private.playerName]["version"] = private.version
		
		BeanCounterDB[private.realmName][private.playerName]["faction"] = "unkown" --faction is recorded when we get the login event
		BeanCounterDB[private.realmName][private.playerName]["wealth"] = GetMoney()
		
		BeanCounterDB[private.realmName][private.playerName]["vendorbuy"] = {}
		BeanCounterDB[private.realmName][private.playerName]["vendorsell"] = {}
		
		BeanCounterDB[private.realmName][private.playerName]["postedAuctions"] = {}
		BeanCounterDB[private.realmName][private.playerName]["completedAuctions"] = {}
		BeanCounterDB[private.realmName][private.playerName]["failedAuctions"] = {}
		
		BeanCounterDB[private.realmName][private.playerName]["postedBids"] = {}
		--BeanCounterDB[private.realmName][private.playerName]["postedBuyouts"] = {} removed as unneccessary
		BeanCounterDB[private.realmName][private.playerName]["completedBids/Buyouts"]  = {}
		BeanCounterDB[private.realmName][private.playerName]["failedBids"]  = {}
		
		BeanCounterDB[private.realmName][private.playerName]["mailbox"] = {}
	end
	
	
	 --OK we now have our Database ready, lets create an Alias to make refrencing easier
	private.playerData = BeanCounterDB[private.realmName][private.playerName]
	private.serverData = BeanCounterDB[private.realmName]
	private.wealth = private.playerData["wealth"]
	private.UpgradeDatabaseVersion() 
	private.prunePostedDB() --Check the postedDB tablesand remove any entries that are older than 31 Days
	 
end

--[[ Configator Section ]]--
--See BeanCounterConfig.lua
function private.getOption(option)
	return lib.GetSetting(option)
end
function private.setOption(...)
	return lib.SetSetting(...)
end

--[[Sidebar Section]]--
local sideIcon
function private.slidebar()
	if LibStub then
		local SlideBar = LibStub:GetLibrary("SlideBar", true)
		if SlideBar then
			sideIcon = SlideBar.AddButton("BeanCounter", "Interface\\AddOns\\BeanCounter\\Textures\\BeanCounterIcon")
			sideIcon:RegisterForClicks("LeftButtonUp","RightButtonUp")
			sideIcon:SetScript("OnClick", private.GUI)
			sideIcon.tip = {
				"BeanCounter",
				"BeanCounter tracks your trading activities so that you may review your expenditures and income, perform searches and use this data to determine your successes and failures.",
				"{{Click}} to view your activity report.",
				"{{Right-Click}} to edit the configuration.",
			}
		end
	end
end

--[[ Local functions ]]--
function private.onUpdate()
	private.mailonUpdate()
end

function private.onEvent(frame, event, arg, ...)
	if (event == "PLAYER_MONEY") then
		private.wealth = GetMoney()
		private.playerData["wealth"] = private.wealth
	
	elseif (event == "PLAYER_ENTERING_WORLD") then --used to record one time info when player loads 
		private.scriptframe:UnregisterEvent("PLAYER_ENTERING_WORLD") --no longer care about this event after we get our current wealth
		private.wealth = GetMoney()
		private.playerData["wealth"] = private.wealth
		
	elseif (event == "MAIL_INBOX_UPDATE") or (event == "MAIL_SHOW") or (event == "MAIL_CLOSED") then
		private.mailMonitor(event, arg, ...)
	
	elseif (event == "MERCHANT_CLOSED") or (event == "MERCHANT_SHOW") or (event == "MERCHANT_UPDATE") then
			--private.vendorOnevent(event, arg, ...)
			
	elseif (event == "UPDATE_PENDING_MAIL") then 
		private.hasUnreadMail()
		--we also use this event to get faction data since the faction often returns nil if called after "PLAYER_ENTERING_WORLD"
		private.faction = UnitFactionGroup(UnitName("player"))
		private.playerData["faction"] =  private.faction or "unknown"
		
	elseif (event == "ADDON_LOADED") then
		if arg == "BeanCounter" then
		   lib.OnLoad()
		end
	end
end


--[[ Utility Functions]]--
--External Search Stub, allows other addons searches to search to display in BC or get results of a BC search
--Can be item Name or link or itemID 
--If itemID or link search will be much faster than a plain text lookup
function lib.externalSearch(name, settings, queryReturn, count)
	--print("|CFFFF3300 WARNING: |CFFFFFFFF A module just called a depreciated  Beancounter API")
	--print(" |CFFFF3300 BeanCounter.externalSearch() ")
	--print("Please update the module to use the function |CFFFFFF00 BeanCounter.API.search()  ")
	return lib.API.search(name, settings, queryReturn, count) or {}
end

--will return any length arguments into a ; seperated string
function private.packString(...)
local String
	for n = 1, select("#", ...) do
		local msg = select(n, ...)
		if msg == nil then 
			msg = "<nil>" 
		elseif msg == true then
			msg = "boolean true"
		elseif msg == false then
			msg = "boolean false"
		end
		if n == 1 then  --This prevents a seperator from being the first character.  :foo:foo:
			String = msg
		else
			String = strjoin(";",String,msg)
		end
	end
	return(String)
end
--Will split any string and return a table value, replace gsub with tbl compare, slightly faster this way.
function private.unpackString(text)
	local tbl = {strsplit(";", text)}
	for i,v in pairs(tbl) do
		if v == "<nil>" then tbl[i] = "0" end --0 needs to be a string, we convert to # if its needed in the calling function, and this prevents string/number comparisions if nil is a text place holder
	end
	return tbl
end
--Add data to DB
--~ local color = {["cff9d9d9d"] = 0, ["cffffffff"] = 1, ["cff1eff00"] = 2, ["cff0070dd"] = 3, ["cffa335ee"] = 4, ["cffff8000"] = 5, ["cffe6cc80"] = 6}
function private.databaseAdd(key, itemID, itemLink, value, compress)
	if not key or not itemID or not itemLink or not value then print("database add error: Missing required data") print("Database", key, "itemID", itemID, "itemLink", itemLink, "Data", data) return end
	
	local itemString, suffix = itemLink:match("^|c%x+|H(item:%d+.+:(.-):.+)|h%[.+%].-")
	--if this will be a compressed entry replace uniqueID with 0
	if compress then 
		itemString  = itemString:gsub("^(item:%d+:.+:.-):.*", "%1:0")
	end	
	
	if private.playerData[key][itemID] then --if ltemID exsists
		if private.playerData[key][itemID][itemString] then
			table.insert(private.playerData[key][itemID][itemString], value)
		else
			private.playerData[key][itemID][itemString] = {value}
		end
	else
		private.playerData[key][itemID]={[itemString] = {value}}
	end
	--Insert into the ItemName:ItemID dictionary array
	if itemID and suffix and itemLink then
		--debugPrint("Added to name array", itemID, suffix, itemLink)
		BeanCounterDB["ItemIDArray"][itemID..":"..suffix] =  itemLink
	end
end
--remove item (for pending bids only atm)
function private.databaseRemove(key, itemID, itemLink, NAME, COUNT)
	if key == "postedBids" then
	local itemString, suffix = itemLink:match("^|c%x+|H(item:%d+.+:(.-):.+)|h%[.+%].-")
		if private.playerData[key][itemID] and private.playerData[key][itemID][itemString] then
			for i, v in pairs(private.playerData[key][itemID][itemString]) do
				local tbl = private.unpackString(v)
				if tbl and itemID  and NAME then
					if tbl[3] == NAME and tonumber(tbl[1]) == COUNT then
						--debugPrint("Removing entry from postedBids this is a match", itemID, ITEM,"vs",tbl[1], NAME,"vs" ,tbl[4], tbl[2], "vs",  COUNT)
						table.remove(private.playerData[key][itemID][itemString], i)--Just remove the key
							break
					end
				end
			end
		end
	end
end
--Get item Info or a specific subset. accepts itemID or "itemString" or "itemName ONLY IF THE ITEM IS IN PLAYERS BAG" or "itemLink"
function private.getItemInfo(link, cmd) 
--debugPrint(link, cmd)
local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(link)
	if not cmd and itemLink then --return all
		return itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture
	
	elseif itemLink and (cmd == "itemid") then
		local itemID = itemLink:match("|c%x+|Hitem:(%d-):.-|h%[.-%]|h|r")
		return itemID, itemLink
	
	elseif itemName and itemTexture  and (cmd == "name") then
		return itemName, itemTexture
	
	elseif itemStackCount and (cmd == "stack") then
		return itemStackCount
	end
end
--[[ DATABASE MAINTIANACE FUNCTIONS
]]
--Recreate/refresh ItemIName to ItemID array
function private.refreshItemIDArray()
	for player, v in pairs(private.serverData)do
		for DB,data in pairs(private.serverData[player]) do
			if DB ~= "mailbox" and type(data) == "table" then
				for itemID, value in pairs(data) do
					for itemString, text in pairs(value) do
						local key, suffix = itemString:match("^item:(%d-):.+:(.+):.-")
						if not BeanCounterDB["ItemIDArray"][key..":"..suffix] then
							local _, itemLink = private.getItemInfo(itemString, "itemid")
							if itemLink then
								debugPrint("Added to array, missing value",  itemLink)
								BeanCounterDB["ItemIDArray"][key..":"..suffix] = itemLink
							end
						end
					end
				end
			end
		end
	end
end
--Moves entrys older than 31 days into compressed( non uniqueID) Storage
--Array refresh needs to run before this function
function private.compactDB()
	for DB,data in pairs(private.playerData) do -- just do current player to make process as fast as possible
		if  DB == "failedBids" or DB == "failedAuctions" or DB == "completedAuctions" or DB == "completedBids/Buyouts" then
			for itemID, value in pairs(data) do
				for itemString, index in pairs(value) do
					if "0" ~= itemString:match(".*:(.-)$") then --ignore the already compacted keys 
						local itemLink = lib.API.getItemLink(itemString)
						if index[1] and time() - index[1]:match(".*;(%d-);.-$") >= 2678400 then --we have an old index entry lets process this array
							while index[1] and time() - index[1]:match(".*;(%d-);.-$") >= 2678400 do --While the entrys remain 31 days old process
								debugPrint("Compressed", itemLink, index[1])
								private.databaseAdd(DB, itemID, itemLink, index[1], true) --store using the compress option set to true
								table.remove(index, 1)
							end
						end
					end
				--remove itemStrings that are now empty, all the keys have been moved to compressed format
				if #index == 0 then debugPrint("Removed empty table:", itemString) private.playerData[DB][itemID][itemString] = nil end 
				end
			end
		end
	end
end
--Sort all array entries by Date oldest to newest
--Helps make compact more efficent needs to run once per week or so
function private.sortArrayByDate(announce)
	for player, v in pairs(private.serverData)do
		for DB, data in pairs(private.serverData[player]) do
			if  DB == "failedBids" or DB == "failedAuctions" or DB == "completedAuctions" or DB == "completedBids/Buyouts" then
				for itemID, value in pairs(data) do
					for itemString, index in pairs(value) do
						table.sort(index,  function(a,b) return a:match(".*;(%d+);.-") < b:match(".*;(%d+);.-") end)
						private.serverData[player][DB][itemID][itemString] = index
					end
				end
			end
		end
	end
	if announce then print("Finished sorting database") end
end
--Prune Old keys from postedXXXX tables
--First we find a itemID that needs pruning then we check all other keys for that itemID and prune.
function private.prunePostedDB()
	--Used to clean up post DB
end

function private.debugPrint(...)
	if private.getOption("util.beancounter.debug") then
		print(...)
	end
end

--[[Bootstrap Code]]
private.scriptframe = CreateFrame("Frame")
private.scriptframe:RegisterEvent("ADDON_LOADED")
private.scriptframe:SetScript("OnEvent", private.onEvent)
