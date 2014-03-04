LZG = LibStub("AceAddon-3.0"):NewAddon("LZG") --We use Ace cause we're too cool for school
local LZGConfig = LibStub("AceConfig-3.0");
if (LZGDB == nil) then LZGDB = {}; end; --Makes sure our settings var actually exists. WoW handles getting what we set on it into a file all by itself.
function itemPrice(item, quantity) --Just checks the average value on AH
  if not item then return 0 end
  if not quantity then quantity = 1 end
  if GetAuctionBuyout then simp = GetAuctionBuyout(item);
  elseif AucAdvanced and AucAdvanced.Modules and AucAdvanced.Modules.Util.Appraiser and AucAdvanced.Modules.Util.Appraiser.GetPrice then simp = AucAdvanced.Modules.Util.Appraiser.GetPrice(item, nil, true) end
	return math.floor(simp / 10000) * quantity; --300g20s10p is returned as 3002010 so that's why we clip the last four numbers off.
end
function LZGCheck()--Prints the prices of the items we track.
	print("Approximate Price->Item to get 100ep")
	print("=============================")
	local prices = {};
	for i,v in pairs(LZGDB.list) do 
		local _,link,_ = GetItemInfo(v[1]);
		table.insert(prices, {["gold"] = itemPrice(v[1], v[2]), ["link"] = link}); --1 is itemName, 2 is quantity, 3 is the item's [link].
	end
	table.sort(prices, function(a,b) return a.gold>b.gold end)
	table.foreach(prices, function(t) print(prices[t].gold.." -> "..prices[t].link); end)
end
function LZG:OnInitialize()--Sets things up when the addon is loaded (Everytime the enters the world.(/reload and at login)).
	if (LZGDB.list == nil) then LZGDB.list = {}; end;
	LZGoptions = {
		name = "EPGP Donation Calculator",
		type = "group",
		args = {
			enable = {
				name = "Enable Addon",
				desc = "Enables / disables the addon",
				type = "toggle",
				order = 0;
				set = function(info,val) if LZG:IsEnabled() then LZG:Disable() else LZG:Enable() end; end,
				get = function(info) return LZG:IsEnabled() end
			},
			addnew={
				name = "Add New...",
				type = "group",
				args={
					itemName = {
						name = "Item Name or ID",
						desc = "Name or ID of the item you want to add.\nChains are also accepted here. For information on making them check the Curse page.",
						type = "input",
						set = function(info,val) addParse(val) end,
						get = nil
					}
				}
			},
			chain = {
				order = -1;
				name = "Current Chain",
				desc = "Copy this to send your list to a friend!!",
				type = "input",
				--set = function(info,val)  end,
				get = function(info) return getChain(); end
			},
		}
	}
	local tries = 0;
	local hits  = 0;
	for _,v in pairs(LZGDB.list) do
		local name,_ = GetItemInfo(v[1]);
		if (name) then
			--I'm not proud of this. :\
			local template = assert(loadstring("return { name = \""..name.."\", type = \"group\", args={ quantity = { name = \"Quantity\", desc = \"How many of this item you need to fufill your donation requirment.\", type = \"input\", set = function(info,val) updateQuantity(info[1], val) end,	get = function(info) return \""..v[2].."\" end,}, remove = {name = \"Remove\", type = \"execute\", func = function(info) removeItem("..v[1]..") end},},}"));
			LZGoptions.args[tostring(v[1])] = template();
			hits = hits + 1;
		end
		tries = tries + 1;
	end
	if (hits ~= tries) then print("Some of the items on your list don't seem to exist according to the Blizz API. As this is very unlikely I advise running a scan on the AH then using /reload"); end;
	LZGConfig:RegisterOptionsTable("EPGP Donation Calculator", LZGoptions)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("EPGP Donation Calculator", "EPGP Donation Calculator")
	self.optionsFrame.default = function() wipe(LZGDB); self.optionsFrame.refresh(); print("Donation Calc settings have been cleared!"); end; 
end
function LZG:OnEnable()--We don't have a use for these but Ace expects them afaik.
	SLASH_LZG1 = '/lzg'; --Set our only slash command
	function SlashCmdList.LZG(msg, editbox) --Handler for slash commands. 
		if msg == "config" then InterfaceOptionsFrame_OpenToCategory("EPGP Donation Calculator"); return; end
		LZGCheck();
	end
	return true;
end
function LZG:OnDisable()--See LZG:OnEnable's comment.
	return true;
end
function addParse(input) --Takes the input entered into the control panel and does horrible unspeakable things to it.
	if (tonumber(input) ~= nil) then 		--User gave us an ItemID if this succeeds
		input = tonumber(input);
		local _,link,_ = GetItemInfo(input);
		if (link) then
			table.insert(LZGDB.list, {input, 1})
			addConfigEntry({input, 1});
		end
		return true;
	elseif(strsub(input,1,1) ~= "{") then		--Is likely a Name and not a chain
		local _,link,_ = GetItemInfo(input);
		if (link) then
			table.insert(LZGDB.list, {input, 1})
			local _, _, spellId = string.find(link, "^|c%x+|Hspell:(.+)|h%[.*%]")
			addConfigEntry({spellId, 1});
		else
			print("I wasn't able to find that item. To use an item by name you must have had one in your bags since you logged in. Blame Blizz for their shit API or buy me some beer so I'll be able to build an internal database of every item we could feasibly need to track.")
			print("Alternatively you can look up the items ID on WoWHead.")
		end
		return true;
	else										--Assume input is a chain if it gets here
		local func, errorMessage = loadstring("return {"..input.."}");
		if(not func) then
		   print(errorMessage);
		end
		local success, errorMessage = pcall(func);
		if(not success) then
		   print(errorMessage);
		end
		chains = func();
		for i,link in ipairs(chains) do					--Looks at all the links and adds them if they are valid
			if(type(link) == "table") then					--Must be a table otherwise the string was malformed
				if (tonumber(link[1]) ~= nil) then			--The first part pf the chain is an itemID which must be numeric
					if (tonumber(link[2]) ~= nil) then		--The second is quantity and should be a relatively small number
						local itemId	= tonumber(link[1]);
						local quantity	= tonumber(link[2]);
						local _,link,_ = GetItemInfo(itemId);
						if (link) then
							if not LZGDB.list then LZGDB.list = {}; end;
							table.insert(LZGDB.list, {itemId, quantity})
							addConfigEntry({itemId, quantity});
						else
							print("Item "..itemId.." in chainlink "..i.." is not a valid item ID. Operations on chain will continue though")
						end
					else
						print("Quantity in chainlink "..i.." is malformed. Operations on chain will continue though");
					end
				else
					print("Item ID in chainlink "..i.." is malformed. Operations on chain will continue though");
				end
			else --How did it get here? If it does then this is very odd
				print("Quite curiously the chain you entered compiled but was malformed, I'll continue with this operation but I'm quite confused.");
			end
		end
	end
end
function addConfigEntry(v) --Add entry in the config, expects {itemId, quantity}
		local name,_ = GetItemInfo(v[1]);
		--I'm not proud of this. :\
		local template = assert(loadstring("return { name = \""..name.."\", type = \"group\", args={ quantity = { name = \"Quantity\", desc = \"How many of this item you need to fufill your donation requirment.\", type = \"input\", set = function(info,val) updateQuantity(info[1], val) end,	get = function(info) return \""..v[2].."\" end,}, remove = {name = \"Remove\", type = \"execute\", func = function(info) removeItem("..v[1]..") end},},}"));
		LZGoptions.args[tostring(v[1])] = template();
end
function updateQuantity(info, val)
	info	= tonumber(info);
	val		= tonumber(val);
	for i,v in pairs(LZGDB.list) do
		if info == v[1] then
			LZGDB.list[i] = {v[1], val};
		end
	end
	local name,_ = GetItemInfo(info);
	local template = assert(loadstring("return { name = \""..name.."\", type = \"group\", args={ quantity = { name = \"Quantity\", desc = \"How many of this item you need to fufill your donation requirment.\", type = \"input\", set = function(info,val) updateQuantity(info[1], val) end,	get = function(info) return \""..val.."\" end,}, remove = {name = \"Remove\", type = \"execute\", func = function(info) removeItem("..info..") end},},}"));
	LZGoptions.args[tostring(info)] = template();
	return true;
end
function removeItem(input)
	for i,v in pairs(LZGDB.list) do
		if input == v[1] then
			tremove(LZGDB.list, i)
		end
	end
	LZGoptions.args[tostring(input)] = nil;
	return true;
end
function getChain()
	local chain = "{";
	for _,v in pairs(LZGDB.list) do
		chain = chain..v[1]..","..v[2].."}, {";
	end
	return strsub(chain, 1, strlen(chain) - 3);
end