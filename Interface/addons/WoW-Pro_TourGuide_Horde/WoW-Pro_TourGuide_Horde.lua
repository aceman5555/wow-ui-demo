function TourGuide:UnRegisterGuides()
        if UnitFactionGroup("player") == "Horde" then
                WoWPro_OldList = TourGuide.guidelist
               
                TourGuide.guidelist = {}
               
                table.remove(WoWPro_OldList, 1)
                table.insert(TourGuide.guidelist, "")
                table.insert(TourGuide.guidelist, "No Guide")
        end
end

TourGuide:UnRegisterGuides()