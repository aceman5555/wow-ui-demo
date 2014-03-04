
-- Hook the CreateFrame function to register all created tooltips with TipTac
hooksecurefunc("CreateFrame", function(type, name, parent, template)
	
	-- not LibExtraTip tooltip? (Auctioneer/Informant)
	if (not strfind(tostring(name), "LibExtraTip")) then
		return;
	end
	
	-- Get tooltip frame
	local tooltip = _G[name];
	
	-- Register tooltip frame with TipTac
	TipTac:AddModifiedTip(tooltip);
end);