function TourGuide:ReRegisterGuides()
	if UnitFactionGroup("player") == "Horde" then
		for k,v in pairs(WoWPro_OldList) do
			table.insert(TourGuide.guidelist, v)
		end
	end
end

TourGuide:ReRegisterGuides()