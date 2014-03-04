--[[
	2.0 data analysis
--]]


function SW_UpdateMPSString(val)
	if SW_FrameConsole_Events:IsVisible() then
		SW_SyncPerSec_Text:SetText(val.." m/s");
	end
end

function SW_GetBarColor(meta, bs)
	if bs.UCC then
		if meta and meta.classE then
			return SW_Settings.Colors[ meta.classE ];
		else
			return bs.BC;
		end
	else
		return nil;
	end
end

SW_ViewBuffer = {
	data = {},
	currentIndex = 1,
	lastValidIndex = 1,
	sums = {0,0},
	maxVals = {0,0},
	new = function (self, o)
		o = o or {};
		o.data = {};
		o.currentIndex = 1;
		o.lastValidIndex = 1;
		o.sums = {0,0};
		o.maxVals = {0,0},
		setmetatable(o, self);
		self.__index = self;
		
		return o;
	end,
	reset = function (self)
		self.currentIndex = 0;
		
		if not self.data[1] then
			self.data[1] = {};
		end
		self.data[1].val = 0;
		self.data[1].sortOrder = 100;
		self.data[1].unitID = 0;
		self.scrollOffset = 0;
	end,
	moveNext = function (self)
		self.currentIndex = self.currentIndex + 1;
		if not self.data[self.currentIndex] then
			self.data[self.currentIndex] = {};
		end
		self.target = self.data[self.currentIndex];
		self.target.val = 0;
		self.target.sortOrder = 100;
		self.target.unitID = 0;
	end,
	
	finalize = function (self)
		local data = self.data;
		local sums = self.sums;
		local mv = self.maxVals;
		local sortIndex = 0;
		
		for i=self.currentIndex + 1, #data do
			data[i].val = 0;
			data[i].sortOrder = 100;
		end
		
		table.sort(data, 
		function(a,b)
			if a.sortOrder == b.sortOrder then
				return a.val > b.val;
			else
				return a.sortOrder < b.sortOrder;
			end
		end);
		
		sums[1] = 0;
		sums[2] = 0;
		mv[1] = 0;
		mv[2] = 0;
		
		
		self.scrollOffset = SW_BarFrame1_ScrollSlider:GetValue() - 1;
		if self.currentIndex < 1 then
			SW_BarFrame1_ScrollSlider:SetMinMaxValues(1, 1);
		else
			SW_BarFrame1_ScrollSlider:SetMinMaxValues(1, self.currentIndex);
		end
		for i=1, self.currentIndex do
			sortIndex = data[i].sortOrder;
			if sortIndex > 2 then
				break;
			end
			sums[sortIndex] = sums[sortIndex] + data[i].val;
			if mv[sortIndex] < data[i].val then
				mv[sortIndex] = data[i].val;
			end
		end
	end,
	

	setData = function (self, txt, val, color, sortOrder)
		self.target.txt = txt;
		self.target.val = val;
		self.target.color = color;
		if sortOrder then
			self.target.sortOrder = sortOrder;
		else
			self.target.sortOrder = 1;
		end
	end,
	setUnitID = function (self, ID)
		self.target.unitID = ID;
	end,
	
};

-- used when creating virtual raid and player pets
SW_PetBuffer = {
	
	reset = function (self)
		for k,v in pairs(self) do
			if type(k) == "number" then
				self[k] = nil;
			end
		end
		self.VPR = 0;
	end,
	
	addPet = function (self, ownerID, val)
		self[ownerID] = val;
	end,
	addVPR = function (self, val)
		self.VPR = self.VPR + val;
	end,
}

function SW_GetMergedPetData (unitData, unitMeta, petFil, getFunc, isDone)
	local baseVal = 0;
	if not (petFil.VPP or petFil.VPR) then
		baseVal = getFunc(unitData);
	end
	if not unitMeta.allPets then
		return baseVal;
	end
	
	local ds = SW_DataCollection:getDS();
	if petFil.MB or (petFil.MM and isDone) or (petFil.MR and not isDone) or petFil.VPP or petFil.VPR then
		for k, _ in pairs(unitMeta.allPets) do
			baseVal = baseVal + getFunc(ds[k]);
		end
	end
	if petFil.VPP then
		SW_PetBuffer:addPet(unitMeta.stringID, baseVal);
	elseif petFil.VPR then
		SW_PetBuffer:addVPR(baseVal);
	end
	return baseVal;
end

-- used for "unit lists"
function SW_UpdateGeneralList(isDone, getF, uInf, bSet, petFil, viewBuffer)
	local tmpMeta;
	if not viewBuffer then
		viewBuffer = SW_ViewBuffer;
	end
	SW_PetBuffer:reset();
	viewBuffer:reset();
	
	if not uInf then return; end
	
	for i, v in ipairs(uInf.data) do
		viewBuffer:moveNext();
		tmpMeta = uInf.meta[i];
		if type(tmpMeta) == "table" then 
			if tmpMeta.isPetData then
				if petFil.Active or petFil.Current then
					viewBuffer:setData(SW_STR_PET_PREFIX..tmpMeta.origName, getF(v), SW_GetBarColor(tmpMeta, bSet));
				else
					viewBuffer:setData(tmpMeta.origName, getF(v), SW_GetBarColor(tmpMeta, bSet));
				end
			elseif tmpMeta.allPets then
				if  (petFil.MB or petFil.MM or petFil.MR) then
					viewBuffer:setData(tmpMeta.origName, 
						SW_GetMergedPetData(v, tmpMeta, petFil, getF, isDone), 
						SW_GetBarColor(tmpMeta, bSet)
					);
				elseif petFil.VPP or petFil.VPR then
					viewBuffer:setData(tmpMeta.origName, getF(v), SW_GetBarColor(tmpMeta, bSet));
					SW_GetMergedPetData(v, tmpMeta, petFil, getF, isDone)
				else
					viewBuffer:setData(tmpMeta.origName, getF(v), SW_GetBarColor(tmpMeta, bSet));
				end
			else
				viewBuffer:setData(tmpMeta.origName, getF(v), SW_GetBarColor(tmpMeta, bSet));
			end
			viewBuffer:setUnitID(tmpMeta.stringID);
		elseif  type(tmpMeta) == "number" then -- its the stringID there was no meta info stored
			-- this only happens on NONE filter with NONE char filter
			--SW_printStr(SW_StrTable:getStr(tmpMeta)..getF(v));
			viewBuffer:setData(SW_StrTable:getStr(tmpMeta), getF(v), SW_GetBarColor(nil, bSet));
			viewBuffer:setUnitID(tmpMeta);
		end
	end
	if petFil.VPP then
		for k,v in pairs(SW_PetBuffer) do
			if type(k) == "number" and v > 0 then
				viewBuffer:moveNext();
				viewBuffer:setData(SW_STR_VPP_PREFIX..SW_StrTable:getStr(k), v, SW_GetBarColor(SW_DataCollection.meta[k], bSet));
			end
		end
	elseif petFil.VPR and SW_PetBuffer.VPR > 0 then
		viewBuffer:moveNext();
		viewBuffer:setData(SW_STR_VPR, SW_PetBuffer.VPR, SW_GetBarColor(nil, bSet));
	end
	viewBuffer:finalize();
end

-- IMPORTANT AND DON'T FORGET
-- depending on the analysis a different type of object list can be returned!!
-- also don't forget - some may have the same calls but have different results through filtering

function SW_2_GetDmgInfo(inf, bSet)
	SW_UpdateGeneralList( true, SW_C_UnitData.getDmgDone , SW_DataCollection:getApplicableUnits(inf, bSet) );
end
function SW_2_GetHealInfo(inf, bSet)
	SW_UpdateGeneralList( true, SW_GetHealFuncUnit(bSet) , SW_DataCollection:getApplicableUnits(inf, bSet) );
end
function SW_2_GetDmgGotInfo(inf, bSet)
	SW_UpdateGeneralList( false, SW_C_UnitData.getDmgRecieved , SW_DataCollection:getApplicableUnits(inf, bSet) );
end
function SW_2_GetHealGotInfo(inf, bSet)
	SW_UpdateGeneralList( false, SW_GetHealFuncUnit(bSet, true) , SW_DataCollection:getApplicableUnits(inf, bSet) );
end
function SW_2_GetHealInfoHealer(inf, bSet) 
	SW_UpdateGeneralList( true, SW_GetHealFuncBasicUnit(bSet) , SW_DataCollection:getApplicableUnits(inf, bSet) );
end
function SW_2_GetHealInfoTarget(inf, bSet) 
	SW_UpdateGeneralList( false, SW_GetHealFuncBasicUnit(bSet) , SW_DataCollection:getApplicableUnits(inf, bSet) );
end
function SW_2_GetDeathInfo(inf, bSet)
	SW_UpdateGeneralList( false, SW_C_UnitData.getDeaths , SW_DataCollection:getApplicableUnits(inf, bSet) );
end
function SW_2_DecurseCountInfo(inf, bSet)
	SW_UpdateGeneralList( true, SW_C_UnitData.getDecurseDone , SW_DataCollection:getApplicableUnits(inf, bSet) );
end
function SW_2_DecurseGotCountInfo(inf, bSet)
	SW_UpdateGeneralList( true, SW_C_UnitData.getDecurseRecieved , SW_DataCollection:getApplicableUnits(inf, bSet) );
end
function SW_2_GetDmgInfoDPS(inf, bSet)
	SW_UpdateGeneralList( true, SW_C_UnitData.getDPS , SW_DataCollection:getApplicableUnits(inf, bSet) );
end
function SW_2_GetDmgInfoDPSGot(inf, bSet)
	SW_UpdateGeneralList( false, SW_C_UnitData.getDPSRecieved , SW_DataCollection:getApplicableUnits(inf, bSet) );
end
function SW_2_GetHPS_InfEff(inf, bSet)
	SW_UpdateGeneralList( true, SW_C_UnitData.getHPS , SW_DataCollection:getApplicableUnits(inf, bSet) );
end
function SW_2_GetMaxHit(inf, bSet)
	SW_UpdateGeneralList( true, SW_C_UnitData.getMaxHitDone , SW_DataCollection:getApplicableUnits(inf, bSet) );
end
function SW_2_GetMaxHeal(inf, bSet)
	SW_UpdateGeneralList( true, SW_C_UnitData.getMaxHealDone , SW_DataCollection:getApplicableUnits(inf, bSet) );
end
function SW_2_GetApproxResit(inf, bSet)
	SW_UpdateGeneralList( false, SW_GetResistFunc(bSet, true) , SW_DataCollection:getApplicableUnits(inf, bSet) );
end
function SW_2_GetDamageInfoTarget(inf, bSet) 
	SW_UpdateGeneralList( false, SW_C_BasicUnitData.getDamage , SW_DataCollection:getApplicableUnits(inf, bSet) );
end
-- added in 2.0.5
function SW_2_GetDamageBreakdownTarget(inf, bSet) 
	SW_UpdateGeneralList( true, SW_C_BasicUnitData.getDamage , SW_DataCollection:getApplicableUnits(inf, bSet) );
end
function SW_2_GetDmgScrappedInfo(inf, bSet)
	SW_UpdateGeneralList( true, SW_C_UnitData.getDmgDoneScrapped , SW_DataCollection:getApplicableUnits(inf, bSet) );
end

function SW_2_GetDetails(inf, bSet)
	local skills, unitID, unitName = SW_DataCollection:getSkillList(inf, bSet);
	local dCol = SW_Settings.Colors.Damage;
	local hCol = SW_Settings.Colors.Heal;
	local tmpVal;
	
	SW_ViewBuffer:reset();
	if not skills then return; end
	for k,v in pairs(skills) do
		--if type(k) == "number" then
			tmpVal = SW_C_SkillList.getTotalDmg(v);
			if tmpVal > 0 then
				SW_ViewBuffer:moveNext();
				SW_ViewBuffer:setData(SW_StrTable:getStr(k), tmpVal, dCol, 1);
			end
			tmpVal = SW_C_SkillList.getTotalHeal(v);
			if tmpVal > 0 then
				SW_ViewBuffer:moveNext();
				SW_ViewBuffer:setData(SW_StrTable:getStr(k), tmpVal, hCol, 2);
			end
		--end
	end
	SW_ViewBuffer:finalize();
	return unitID;
end

function SW_2_GetDetailsPerTick(inf, bSet)
	local skills, unitID, unitName = SW_DataCollection:getSkillList(inf, bSet);
	local dCol = SW_Settings.Colors.Damage;
	local hCol = SW_Settings.Colors.Heal;
	local tmpVal;
	
	SW_ViewBuffer:reset();
	if not skills then return; end
	for k,v in pairs(skills) do
		--if type(k) == "number" then
			tmpVal = SW_C_SkillList.getAvgDmg(v);
			if tmpVal > 0 then
				SW_ViewBuffer:moveNext();
				SW_ViewBuffer:setData(SW_StrTable:getStr(k), tmpVal, dCol, 1);
			end
			tmpVal = SW_C_SkillList.getAvgHeal(v);
			if tmpVal > 0 then
				SW_ViewBuffer:moveNext();
				SW_ViewBuffer:setData(SW_StrTable:getStr(k), tmpVal, hCol, 2);
			end
		--end
	end
	SW_ViewBuffer:finalize();
	return unitID;
end

function SW_2_GetSchoolMade(inf, bSet)
	local schoolData, unitID, name = SW_DataCollection:getSchoolDone(inf, bSet);
	SW_ViewBuffer:reset();
	if not schoolData then return; end
	local tmpVal = 0;
	
	for k,v in pairs(schoolData) do
		tmpVal = v:getDmg();
		if tmpVal > 0 then
			SW_ViewBuffer:moveNext();
			SW_ViewBuffer:setData(SW_Schools:getStr(k), tmpVal, SW_GetBarColor(nil, bSet));
		end	
	end
	SW_ViewBuffer:finalize();
	return unitID;
end

function SW_2_GetSchoolGot(inf, bSet)
	local schoolData, unitID, name = SW_DataCollection:getSchoolRecieved(inf, bSet);
	SW_ViewBuffer:reset();
	if not schoolData then return; end
	local tmpVal = 0;
	
	for k,v in pairs(schoolData) do
		tmpVal = v:getDmg();
		if tmpVal > 0 then
			SW_ViewBuffer:moveNext();
			SW_ViewBuffer:setData(SW_Schools:getStr(k), tmpVal, SW_GetBarColor(nil, bSet));
		end	
	end
	SW_ViewBuffer:finalize();
	return unitID;
end
function SW_2_GetSchoolMadeSummary(inf, bSet)
	if SW_SchoolSummData then
		SW_SchoolSummData:nullify();
	else
		SW_SchoolSummData = SW_C_SchoolList:new();	
	end
	
	SW_ViewBuffer:reset();
	local uInf = SW_DataCollection:getApplicableUnits(inf, bSet);
	local oneList;
	
	for i, v in ipairs(uInf.data) do
		oneList = v:getSchoolDone();
		if oneList then
			SW_SchoolSummData:add(oneList);
		end	
	end
	
	for k,v in pairs(SW_SchoolSummData) do
		tmpVal = v:getDmg();
		if tmpVal > 0 then
			SW_ViewBuffer:moveNext();
			SW_ViewBuffer:setData(SW_Schools:getStr(k), tmpVal, SW_GetBarColor(nil, bSet));
		end	
	end
	SW_ViewBuffer:finalize();
	return -1;
	
end
function SW_2_GetSchoolGotSummary(inf, bSet)
	if SW_SchoolSummData then
		SW_SchoolSummData:nullify();
	else
		SW_SchoolSummData = SW_C_SchoolList:new();	
	end
	
	SW_ViewBuffer:reset();
	local uInf = SW_DataCollection:getApplicableUnits(inf, bSet);
	local oneList;
	
	for i, v in ipairs(uInf.data) do
		oneList = v:getSchoolRecieved();
		if oneList then
			SW_SchoolSummData:add(oneList);
		end	
	end
	
	for k,v in pairs(SW_SchoolSummData) do
		tmpVal = v:getDmg();
		if tmpVal > 0 then
			SW_ViewBuffer:moveNext();
			SW_ViewBuffer:setData(SW_Schools:getStr(k), tmpVal, SW_GetBarColor(nil, bSet));
		end	
	end
	SW_ViewBuffer:finalize();
	return -1;
end
function SW_2_GetManaRatio(inf, bSet)
	
	local skills, unitID, unitName = SW_DataCollection:getSkillList(inf, bSet);
	SW_ViewBuffer:reset();
	if not skills then return; end
	
	local manaUsed = 0;
	local dCol = SW_Settings.Colors.Damage;
	local hCol = SW_Settings.Colors.Heal;
	local tmpVal = 0;
	
	
	for k,v in pairs(skills) do
		manaUsed = SW_C_SkillList.getManaUsed(v);
		tmpVal = SW_C_SkillList.getTotalDmg(v);
		if tmpVal > 0 and manaUsed > 0 then
			ratio = math.floor( (tmpVal / manaUsed) * 100 + 0.5) / 100;
			SW_ViewBuffer:moveNext();
			SW_ViewBuffer:setData(SW_StrTable:getStr(k), ratio, dCol, 1);
		end
		tmpVal = SW_C_SkillList.getTotalHeal(v);
		if tmpVal > 0 and manaUsed > 0 then
			ratio = math.floor( (tmpVal / manaUsed) * 100 + 0.5) / 100;
			SW_ViewBuffer:moveNext();
			SW_ViewBuffer:setData(SW_StrTable:getStr(k), ratio, hCol, 2);
		end
	end
	SW_ViewBuffer:finalize();
	return SW_StrTable:hasID(SW_SELF_STRING);
end

--[[ I KNOW this could have more info
	The rest can come after 2.0
	esp. it is not considering skills here that can heal and dmg (the data is collected though)
--]]
function SW_DoSkillMouseOver(b)
	if not (b.unitID and b.skillID) then return; end
	
	local skill = SW_DataCollection:getUnitSkillList(b.unitID);
	if skill then 
		skill = skill[b.skillID];
	end
	if not skill then return; end
	
	local hits = SW_C_SkillList.getHits(skill);
	local ticks = SW_C_SkillList.getTicks(skill);
	local miss = SW_C_SkillList.getMisses(skill);
	local resists = SW_C_SkillList.getResists(skill);
	local nullDmg = SW_C_SkillList.getAllNullDmg(skill);
	local crits = SW_C_SkillList.getCrits(skill);
	local swings = hits + nullDmg;
	local otherNullDmg = nullDmg - resists - miss;
	local critPH = math.floor((crits/hits) * 1000 + 0.5 ) / 10;
	local critPS = math.floor((crits/swings) * 1000 + 0.5 ) / 10;
	local glancing = SW_C_SkillList.getGlancing(skill);
	local crushing = SW_C_SkillList.getCrushing(skill);
	local missedP = math.floor((miss/(hits+ miss)) * 1000 + 0.5 ) / 10; 
	local resistP = math.floor((resists/(hits+ resists)) * 1000 + 0.5 ) / 10; 
	
	local partialDmg = SW_C_SkillList.getPartialTotal(skill);
	local avgDmg = SW_C_SkillList.getAvgDmg(skill);
	local dmg = SW_C_SkillList.getTotalDmg(skill);
	local theoMax = partialDmg + dmg + avgDmg * nullDmg;
	
	local penetration; 
	if theoMax == 0 then
		penetration = 0;
	else
		penetration = math.floor((dmg/theoMax) * 1000 + 0.5 ) / 10; 
	end
	local avgHeal = SW_C_SkillList.getAvgHeal(skill);
	local avg;
	if avgHeal > avgDmg then
		avg = avgHeal;
	else
		avg = avgDmg;
	end
	GameTooltip:SetOwner(b, "ANCHOR_LEFT");
	GameTooltip:AddLine(string.format(SW_TT_SKILL_HEAD, SW_StrTable:getStr(b.skillID), SW_StrTable:getStr(b.unitID)));
	GameTooltip:AddLine(string.format(SW_TT_SKILL_AVGMAX, avg, SW_C_SkillList.getMax(skill)));
	GameTooltip:AddLine(string.format(SW_TT_SKILL_SWINGS, hits, ticks,miss,resists,otherNullDmg));
	GameTooltip:AddLine(string.format(SW_TT_SKILL_CRITS, crits, critPH, critPS));
	GameTooltip:AddLine(string.format(SW_TT_SKILL_RMP, missedP, resistP, penetration));
	
	if glancing  > 0 or crushing > 0 then
		GameTooltip:AddLine(string.format(SW_TT_SKILL_GLCRUSH, glancing, crushing));
	end

	GameTooltip:Show();
	
end
--[[
function SW_DoUnitMouseOver(b)
	if not (b.unitID and b.unitID > 0) then return; end
	local unitData = SW_DataCollection:getDS();
	if unitData then 
		unitData = unitData[b.unitID];
	end
	if not unitData then return; end
	
	local unitMeta = SW_DataCollection.meta[b.unitID];
	local unitName;
	if unitMeta then
		unitName = unitMeta.origName;
	else
		unitName = SW_StrTable:getStr(b.unitID);
	end
	
	--local hits = SW_C_SkillList.getHits(skill);
	--local crits = SW_C_SkillList.getCrits(skill);
	--local critPH = math.floor((crits/hits) * 1000 + 0.5 ) / 10;
	
	GameTooltip:SetOwner(b, "ANCHOR_LEFT");
	GameTooltip:AddLine(string.format(SW_TT_UNIT_HEAD, unitName));
	GameTooltip:AddLine(SW_TT_UNIT_OUT);
	GameTooltip:AddLine(string.format(SW_TT_UNIT_DMGHEAL, unitData:getDmgDone(), unitData:getEffectiveHealDone(), unitData:getRawHealDone(), unitData:getOHInFPercentDone()));
	GameTooltip:AddLine(string.format(SW_TT_UNIT_CRIT, unitData:getDmgCrit(), unitData:getHealCrit()));
	GameTooltip:AddLine(" ");
	GameTooltip:AddLine(SW_TT_UNIT_IN);
	GameTooltip:AddLine(string.format(SW_TT_UNIT_DMGHEAL, unitData:getDmgRecieved(), unitData:getEffectiveHealRecieved(), unitData:getRawHealRecieved(), unitData:getOHInFPercentRecieved()));
	
	
	GameTooltip:Show();
	
	-- the rest is dump to console
	if not IsShiftKeyDown() then 
		return;
	end
	SW_printStr("~~~ Dumping SELECTED segments "..unitName.." ~~~");
	if IsControlKeyDown() then
		SW_DataCollection:getDS():dumpID(b.unitID);
	else
		SW_DataCollection:getDS():dumpDR_ID(b.unitID);
	end
end
--]]

function SW_DoSchoolMouseOverDone(b)
	if not (b.unitID and b.schoolID) then return; end
	
	local schoolData;
	if b.unitID == -1 then
		schoolData = SW_SchoolSummData;
	else
		schoolData = SW_DataCollection:getUnitSchoolDone(b.unitID);
	end
	if schoolData then
		schoolData = schoolData[b.schoolID];
	end
	if not schoolData then return; end
	
	
	local unitName;
	if b.unitID == -1 then
		unitName = FILTERS; -- a blizzard localized var
	else
		local unitMeta = SW_DataCollection.meta[b.unitID];
		if unitMeta then
			unitName = unitMeta.origName;
		else
			unitName = SW_StrTable:getStr(b.unitID);
		end
	end
	
	local mr = schoolData:getMandR();
	local zd = schoolData:getOtherZeroDmg();
	local pr = schoolData:getPartialResists();
	local dmg = schoolData:getDmg();
	local ticks = schoolData:getTicks();
	local trr = math.floor(((mr + zd)/(ticks + mr + zd)) * 1000 + 0.5 ) / 10; 
	local prr = math.floor((pr/(dmg+pr)) * 1000 + 0.5 ) / 10; 
	local avg = math.floor((dmg/ticks) * 10 + 0.5 ) / 10; 
	
	local dmgGuess = (mr + zd) * avg; -- a guess of the dmg that was resisted totally
	local pen = math.floor(((pr + dmgGuess)/(dmgGuess + dmg + pr)) * 1000 + 0.5 ) / 10; 

	
	GameTooltip:SetOwner(b, "ANCHOR_LEFT");
	GameTooltip:AddLine(string.format(SW_TT_SCHOOL_DONE, SW_Schools:getStr(b.schoolID), unitName));
	GameTooltip:AddLine(string.format(SW_TT_SCHOOL_ZERODMG, mr, zd));
	GameTooltip:AddLine(string.format(SW_TT_SCHOOL_PARTIAL, pr));
	GameTooltip:AddLine(string.format(SW_TT_SCHOOL_PERCENT, trr, prr));
	GameTooltip:AddLine(string.format(SW_TT_SCHOOL_AVGAPR, avg, pen));
	
	GameTooltip:Show();
end
function SW_DoSchoolMouseOverRecieved(b)
	if not (b.unitID and b.schoolID) then return; end
	local schoolData;
	if b.unitID == -1 then
		schoolData = SW_SchoolSummData;
	else
		schoolData = SW_DataCollection:getUnitSchoolRecieved(b.unitID);
	end
	if schoolData then
		schoolData = schoolData[b.schoolID];
	end
	if not schoolData then return; end
	
	local unitName;
	if b.unitID == -1 then
		unitName = FILTERS; -- a blizzard localized var
	else
		local unitMeta = SW_DataCollection.meta[b.unitID];
		if unitMeta then
			unitName = unitMeta.origName;
		else
			unitName = SW_StrTable:getStr(b.unitID);
		end
	end
	
	local mr = schoolData:getMandR();
	local zd = schoolData:getOtherZeroDmg();
	local pr = schoolData:getPartialResists();
	local dmg = schoolData:getDmg();
	local ticks = schoolData:getTicks();
	local trr = math.floor(((mr + zd)/(ticks + mr + zd)) * 1000 + 0.5 ) / 10; 
	local prr = math.floor((pr/(dmg+pr)) * 1000 + 0.5 ) / 10; 
	local avg = math.floor((dmg/ticks) * 10 + 0.5 ) / 10;
	-- have to add the avg partial resists aswell, to get the dmg one would resist on full resist
	local avgDmg = math.floor(((dmg/ticks) + (pr/ticks) )* 10 + 0.5 ) / 10; 
	
	local dmgGuess = (mr + zd) * avgDmg; -- a guess of the dmg we resisted totally
	local pen = math.floor(((pr + dmgGuess)/(dmgGuess + dmg + pr)) * 1000 + 0.5 ) / 10; 

	
	GameTooltip:SetOwner(b, "ANCHOR_LEFT");
	GameTooltip:AddLine(string.format(SW_TT_SCHOOL_REC, SW_Schools:getStr(b.schoolID), unitName));
	GameTooltip:AddLine(string.format(SW_TT_SCHOOL_ZERODMG, mr, zd));
	GameTooltip:AddLine(string.format(SW_TT_SCHOOL_PARTIAL, pr));
	GameTooltip:AddLine(string.format(SW_TT_SCHOOL_PERCENT, trr, prr));
	GameTooltip:AddLine(string.format(SW_TT_SCHOOL_AVGAPR, avg, pen));
	
	GameTooltip:Show();
end

function SW_GetResistFunc(bSet, recieved)
	if not SW_SchoolFuncs then
		SW_SchoolFuncs = {};
		SW_SchoolFuncs[0]  = function  (obj)
			return SW_C_UnitData.getResistRating(obj, 0);
		end
		SW_SchoolFuncs[1]  = function  (obj)
			return SW_C_UnitData.getResistRating(obj, 1);
		end
		SW_SchoolFuncs[2]  = function  (obj)
			return SW_C_UnitData.getResistRating(obj, 2);
		end
		SW_SchoolFuncs[3]  = function  (obj)
			return SW_C_UnitData.getResistRating(obj, 3);
		end
		SW_SchoolFuncs[4]  = function  (obj)
			return SW_C_UnitData.getResistRating(obj, 4);
		end
		SW_SchoolFuncs[5]  = function  (obj)
			return SW_C_UnitData.getResistRating(obj, 5);
		end
		SW_SchoolFuncs[6]  = function  (obj)
			return SW_C_UnitData.getResistRating(obj, 6);
		end
		SW_SchoolFuncs[200]  = function  (obj)
			return SW_C_UnitData.getResistRating(obj, 200);
		end
	end
	if not bSet.selSchool then bSet.selSchool = 0; end
	
	return SW_SchoolFuncs[bSet.selSchool];
end
function SW_GetHealFuncUnit(bSet, recieved)
	if recieved then
		if bSet.HealInF then
			if bSet.HealEff then
				return SW_C_UnitData.getEffectiveInFHealRecieved;
			elseif bSet.HealOH then
				return SW_C_UnitData.getOHInFRecieved
			else
				return SW_C_UnitData.getInFHealRecieved
			end
		else
			if bSet.HealEff then
				return SW_C_UnitData.getEffectiveHealRecieved
			elseif bSet.HealOH then
				return SW_C_UnitData.getOHRecieved
			else
				return SW_C_UnitData.getRawHealRecieved
			end
		end
	else
		if bSet.HealInF then
			if bSet.HealEff then
				return SW_C_UnitData.getEffectiveInFHealDone;
			elseif bSet.HealOH then
				return SW_C_UnitData.getOHInFDone
			else
				return SW_C_UnitData.getInFHealDone
			end
		else
			if bSet.HealEff then
				return SW_C_UnitData.getEffectiveHealDone
			elseif bSet.HealOH then
				return SW_C_UnitData.getOHDone
			else
				return SW_C_UnitData.getRawHealDone
			end
		end
	end
end
function SW_GetHealFuncBasicUnit(bSet)
	if bSet.HealInF then
		if bSet.HealEff then
			return SW_C_BasicUnitData.getEffectiveInFHeal;
		elseif bSet.HealOH then
			return SW_C_BasicUnitData.getOHInF
		else
			return SW_C_BasicUnitData.getInFHeal
		end
	else
		if bSet.HealEff then
			return SW_C_BasicUnitData.getEffectiveHeal
		elseif bSet.HealOH then
			return SW_C_BasicUnitData.getOH
		else
			return SW_C_BasicUnitData.getRawHeal
		end
	end
end

---- Inspired and mostly taken form Zharice thanks for the post on sw-stats.com
-- did some minor efficiency changes, and made it localizeable
-- also added the "compare info" to healing
-- also added the ability to compare not only to self
local SW_DeltaStrings = {
	negF = "|cffff2020 [%.1f]" .. FONT_COLOR_CODE_CLOSE,
	posF = "|cff20ff20 [+%.1f]" .. FONT_COLOR_CODE_CLOSE,
	negD = "|cffff2020 [%d]" .. FONT_COLOR_CODE_CLOSE,
	posD = "|cff20ff20 [+%d]" .. FONT_COLOR_CODE_CLOSE,
	eq = "|cffffffff [%d]" .. FONT_COLOR_CODE_CLOSE,
}
function SW_D(val)
    -- Output a delta value.  If positive, output green.  If negative output red.  Otherwise, white.
    local fs;
    local useD = (mod(val,1) == 0);
    if (val < 0) then
		if useD then
			fs = SW_DeltaStrings.negD;
		else
			fs = SW_DeltaStrings.negF;
		end
        --return "|cffff2020" .. " [" .. val .. "]" .. FONT_COLOR_CODE_CLOSE;
    elseif (val > 0) then
		if useD then
			fs = SW_DeltaStrings.posD;
		else
			fs = SW_DeltaStrings.posF;
		end
       --return "|cff20ff20" .. " [+" .. val .. "]" .. FONT_COLOR_CODE_CLOSE;
    else 
		fs = SW_DeltaStrings.eq;
        --return "|cffffffff" .. " [" .. val .. "]" .. FONT_COLOR_CODE_CLOSE;
    end
    return string.format(fs, val);
end

function SW_DoUnitMouseOver(b)
	if not (b.unitID and b.unitID > 0) then return; end
	
	local unitData = SW_DataCollection:getDS()[b.unitID];
	if not unitData then return; end
	
	local unitName = SW_StrTable:getStr(b.unitID);
	local skills = unitData:getSkillList();
	
	GameTooltip:SetOwner(b, "ANCHOR_LEFT");
	GameTooltip:AddLine(unitName, 1, 1, 1, 0);
	GameTooltip:AddLine(SW_TT_UNIT_EXPLAIN1, 1.0, 0.5, 0.5, 0);    

	-- Get self details
	local selfID = SW_StrTable:getID(SW_SELF_STRING);
	local selfDetails = nil;
	
	-- override self info if MOCompUnit is set
	if SW_Settings.MOCompUnit then
		local tmpID = SW_StrTable:hasID(SW_Settings.MOCompUnit);
		if tmpID then
			selfID = tmpID;
		end
	end
	
	if (selfID ~= b.unitID) then
		selfDetails = SW_DataCollection:getUnitSkillList(selfID);
	end

	-- Compute details data

	local dmg = {};
	local healing = {};
	local es = "";
	local exp2Added = false;
	
	if skills then
		for k,v in pairs(skills) do
			local totalDmg = SW_C_SkillList.getTotalDmg(v);
			local hits = SW_C_SkillList.getHits(v);
			local crits = SW_C_SkillList.getCrits(v);
			-- %s = %d%s(%g%%) %d%s/%d%s(%g%s%%), %g%s Avg
			if totalDmg > 0 then
				if (selfDetails ~= nil and selfDetails ~= skills and selfDetails[k] ~= nil) then
					if not exp2Added then
						GameTooltip:AddLine(string.format(SW_TT_UNIT_EXPLAIN2,unitName, SW_StrTable:getStr(selfID)), 1.0, 0.5, 0.5, 0);
						GameTooltip:AddLine(string.format(SW_TT_UNIT_EXPLAIN3,unitName, SW_StrTable:getStr(selfID)), 1.0, 0.5, 0.5, 0);
						exp2Added = true;
					end
					local s = selfDetails[k];
					local selfDmg = SW_C_SkillList.getTotalDmg(s);
					local selfHits = SW_C_SkillList.getHits(s);
					local selfCrits = SW_C_SkillList.getCrits(s);
					--[[
					table.insert(dmg, { "    " .. SW_StrTable:getStr(k) .. " = "
					.. totalDmg .. SW_D(totalDmg - selfDmg) .. " (" .. math.floor((totalDmg/unitData:getDmgDone())*1000 + 0.5)/10.0 .. "%) " -- total dmg
					.. crits .. SW_D(crits - selfCrits) .. "/".. hits .. SW_D(hits - selfHits)
					.. " (" .. math.floor((crits/hits) *1000 + 0.5)/10.0 .. SW_D(math.floor((crits/hits - selfCrits/selfHits) *1000 + 0.5)/10.0) .. "%)" -- crit
					.. ", " .. math.floor((totalDmg/hits)*10)/10.0 .. SW_D(math.floor((totalDmg/hits - selfDmg/selfHits)*10)/10.0) .. " Avg" -- avg
					, totalDmg});
					--]]
					table.insert (dmg, 
						{ 
							string.format(SW_TT_UNIT_SKILL_FORMAT, SW_StrTable:getStr(k), 
								totalDmg, SW_D(totalDmg - selfDmg), (totalDmg/unitData:getDmgDone())*100,
								crits, SW_D(crits - selfCrits), hits, SW_D(hits - selfHits), 
								(crits/hits) *100, SW_D((crits/hits - selfCrits/selfHits) *100),
								totalDmg/hits, SW_D(totalDmg/hits - selfDmg/selfHits))
							
							,totalDmg
						}
					);
				else
					--[[
					table.insert(dmg, { "    " .. SW_StrTable:getStr(k) .. " = "
					.. totalDmg .. " (" .. math.floor((totalDmg/unitData:getDmgDone())*1000 + 0.5)/10.0 .. "%) " -- total dmg
					.. crits .."/".. hits .. " (" .. math.floor((crits/hits) *1000 + 0.5)/10.0 .. "%)" -- crit
					.. ", " .. math.floor((totalDmg/hits)*10)/10.0 .. " Avg" -- avg
					, totalDmg});
					--]]
					table.insert (dmg, 
						{ 
							string.format(SW_TT_UNIT_SKILL_FORMAT, SW_StrTable:getStr(k), 
								totalDmg, es, (totalDmg/unitData:getDmgDone())*100,
								crits, es, hits, es, (crits/hits)*100, es,
								totalDmg/hits, es)
							
							,totalDmg
						}
					);
				end
			end
			local totalHealing = SW_C_SkillList.getTotalHeal(v);
			
			if totalHealing > 0 then
				--[[
				table.insert(healing, { "    " .. SW_StrTable:getStr(k) .. " = "
				.. totalHealing .. " (" .. math.floor((totalHealing/unitData:getRawHealDone())*1000 + 0.5)/10.0 .. "%) " -- total healing
				.. crits .."/".. hits .. " (" .. math.floor((crits/hits) *1000 + 0.5)/10.0 .. "%)" -- crit
				.. ", " .. math.floor((totalHealing/hits)*10)/10.0 .. " Avg" -- avg
				, totalHealing});
				--]]
				if (selfDetails ~= nil and selfDetails ~= skills and selfDetails[k] ~= nil) then
					if not exp2Added then
						GameTooltip:AddLine(string.format(SW_TT_UNIT_EXPLAIN2,unitName, SW_StrTable:getStr(selfID)), 1.0, 0.5, 0.5, 0);
						GameTooltip:AddLine(string.format(SW_TT_UNIT_EXPLAIN3,unitName, SW_StrTable:getStr(selfID)), 1.0, 0.5, 0.5, 0);
						exp2Added = true;
					end
					local s = selfDetails[k];
					local selfHeal = SW_C_SkillList.getTotalHeal(s);
					local selfHits = SW_C_SkillList.getHits(s);
					local selfCrits = SW_C_SkillList.getCrits(s);
	
					table.insert (healing, 
						{ 
							string.format(SW_TT_UNIT_SKILL_FORMAT, SW_StrTable:getStr(k), 
								totalHealing, SW_D(totalHealing - selfHeal), (totalHealing/unitData:getRawHealDone())*100,
								crits, SW_D(crits - selfCrits), hits, SW_D(hits - selfHits), 
								(crits/hits) *100, SW_D((crits/hits - selfCrits/selfHits) *100),
								totalHealing/hits, SW_D(totalHealing/hits - selfHeal/selfHits))
							
							,totalHealing
						}
					);
				else
					table.insert (healing, 
						{ 
							string.format(SW_TT_UNIT_SKILL_FORMAT, SW_StrTable:getStr(k), 
								totalHealing, es, (totalHealing/unitData:getRawHealDone())*100,
								crits, es, hits, es, (crits/hits)*100, es,
								totalHealing/hits, es)
							
							,totalHealing
						}
					);
				end
			end
			
			
		end
	end
	-- Sort by dmg and healing

	table.sort(dmg, 
		function(a,b)
			return a[2] > b[2];
		end);

	table.sort(healing, 
		function(a,b)
			return a[2] > b[2];
		end);

	GameTooltip:AddLine(string.format (SW_TT_UNIT_DMG_HEAD, unitData:getDmgDone(), unitData:getDmgCrit()), 1, 1, 1, 0);
	
	if #dmg == 0 then
		GameTooltip:AddLine(SW_TT_UNIT_NODATA, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 0);
	else
		for k,v in pairs(dmg) do
			GameTooltip:AddLine(v[1]);
		end
	end

	GameTooltip:AddLine(string.format(SW_TT_UNIT_HEAL_HEAD, unitData:getRawHealDone(), unitData:getEffectiveHealDone(), unitData:getOHInFPercentDone(), unitData:getHealCrit()), 1, 1, 1, 0);
	
	if #healing == 0 then
		GameTooltip:AddLine(SW_TT_UNIT_NODATA, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 0);
	else
		for k,v in pairs(healing) do
			GameTooltip:AddLine(v[1]);
		end
	end

	GameTooltip:AddLine(string.format(SW_TT_UNIT_INC_HEAD, unitData:getDmgRecieved()), 1, 1, 1, 0);
	--GameTooltip:AddLine(string.format(SW_TT_UNIT_INC_EH, unitData:getEffectiveInFHealRecieved(), unitData:getRawHealRecieved(), unitData:getOHInFPercentRecieved()), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 0);
	GameTooltip:AddLine(string.format(SW_TT_UNIT_INC_EH, unitData:getEffectiveInFHealRecieved(), unitData:getEffectiveInFHealRecieved() + unitData:getOHInFRecieved(), unitData:getOHInFPercentRecieved()), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 0);
	
	GameTooltip:Show();

	-- the rest is dump to console
	if not IsShiftKeyDown() then 
		return;
	end
	SW_printStr("~~~ Dumping SELECTED segments "..unitName.." ~~~");
	if IsControlKeyDown() then
		SW_DataCollection:getDS():dumpID(b.unitID);
	else
		SW_DataCollection:getDS():dumpDR_ID(b.unitID);
	end
end
