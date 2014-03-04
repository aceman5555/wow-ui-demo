-- standalone config lib, for super fast prototype config pages.

local major = "LibConfigBoss-1.0"
local minor = tonumber(("$Rev: 69 $"):match("(%d+)")) or 1
if not LibStub then error("LibConfigBoss-1.0 requires LibStub.") end

local lib, old = LibStub:NewLibrary(major, minor)
if not lib then return end

local proto = {}

local indent = 10;
local blizzheight = 550
local blizzwidth = 650

local function tablecopy(t) 
	local t2 = {}
	for k,v in pairs(t) do
		t2[k] = v;
	end	
	return t2;
end

-- generate a new config panel specifying name (unique, internal) and a title (display only)
function lib:NewConfig(name, title, width, height)
	if (not name or not title or name == "" or title == "") then
		error("NewConfig(name, title [, totalwidth, totalheight]), name and title both required");
	end	
	local obj = tablecopy(proto);
	obj.frameid = "ConfigBoss"..name;

	obj.placeholder = CreateFrame("Frame", obj.frameid .. "placeholder", UIParent);
	obj.placeholder.name = title;
	obj.panel = CreateFrame( "ScrollFrame", obj.frameid , obj.placeholder );
	obj.panel:SetPoint("TOPLEFT", 5, -5);
	obj.window = CreateFrame( "Frame", obj.frameid.."window", obj.panel);
	obj.panel:SetScrollChild(obj.window)
	obj.window:SetPoint("TOPLEFT", 0, 0);
	
	-- scale

	if(height) then 
		obj.height = height;	
	else
		obj.height = blizzheight;
	end
	if(width) then
		obj.width = width;	
	else
		obj.width = blizzwidth;
	end

	obj.panel:SetHeight(obj.height);
	obj.panel:SetWidth(obj.width);

	-- add teh scrollbar
	obj.scrollbar = CreateFrame( "Slider", obj.frameid.."scrollbar", obj.panel, "MinimalScrollBarTemplate" );
	obj.scrollbar:SetPoint("TOPRIGHT", 0, -15)
	obj.scrollbar:SetHeight(obj.height-30);	
	obj.scrollbar:SetValueStep(1);	
	obj.scrollbar:Enable();

	obj.panel:SetScript("OnScrollRangeChanged", function()
		obj.scrollbar:SetMinMaxValues(0,obj.panel:GetVerticalScrollRange());
	end);
	
	obj.panel:SetScript("OnMouseWheel", function(self, delta)
		obj.scrollbar:SetValue(obj.scrollbar:GetValue()-delta*10)
	end);


	obj:SetColumnWidths(300);
	return obj
end

-- add a generated panel to blizzard options frame
function proto:AddToBlizzardOptions()
	InterfaceOptions_AddCategory(self.placeholder);
end

-- set Column widths for the config page.
-- e.g. configboss:SetColumnWidths(100,100) will set the widths of Columns 1 and 2 to 100px
-- also defines the number of Columns, based on number of Column widths given
function proto:SetColumnWidths(...)
	
	self.columnwidths = {}
	self.columnoffsetx = {}
	self.columnoffsetx[1] = indent;
	self.columnoffsety = {}
	local i = 0;
	local args = {...}
	repeat	
		i=i+1;
		self.columnwidths[i] = args[i];
		self.columnoffsetx[i+1] = args[i] + self.columnoffsetx[i]
		self.columnoffsety[i]=indent;
		
	until (not args[i+1])
	
	self:AutoWidth()
	
end

-- add a config item
-- fields
-- column: column integer
-- name: unique identifier
-- title: display text
-- type: slider, color picker, checkbox
-- default: default value
-- database: table where config value is stored
-- callback: function executed upon value change
--	 		callback has the parameters yourfunc(configobject, configitemname, value)
-- the following may be required for some types:
-- min, max
function proto:AddConfigItem(t)
	-- lots of fun to be had here
end

function proto:AutoHeight()
	local max = 0;
	for _,v in pairs(self.columnoffsety) do
		if (v > max) then
			max = v
		end
	end
	self.window:SetHeight(max)
	self.panel:SetVerticalScroll(0);
	self.panel:UpdateScrollChildRect()
	self.scrollbar:SetMinMaxValues(0, self.panel:GetVerticalScrollRange());
	self.scrollbar:SetValue(0);
	
end

function proto:AutoWidth()
	local total = 0;
	for _, v in pairs(self.columnwidths) do
		total = total + v;
	end
	self.window:SetWidth(total)
end

function proto:GetYOffset(column, height)
	local o = -(self.columnoffsety[column]);
	self.columnoffsety[column] = self.columnoffsety[column] + height;
	self:AutoHeight();
	return o;
end

function proto:GetXOffset(column)
	return self.columnoffsetx[column]
end

function proto:AddCheckbox(column, name, title, default, database, callback)
	local height = 20;
	local cb = CreateFrame("CheckButton", self.frameid .. "option" .. name, self.window, "ChatConfigCheckButtonTemplate");
	cb:SetPoint("TOPLEFT", self:GetXOffset(column) , self:GetYOffset(column, height));
	getglobal(self.frameid .. "option"..name.."Text"):SetText(title);

	-- default state
	if(not database[name]) then
		database[name] = default;
	end
	cb:SetChecked(database[name])

	-- event handling
	cb:SetScript("OnClick", 
	  function()
	    if(cb:GetChecked()) then
	    	database[name] = 1;
	    else
			database[name] = 0;
	    end 
    	if(callback) then
    		callback(self, name, database[name])
    	end
	  end
	);	
end

function proto:AddText(column, name, title)
	local height=20
	local text = self.window:CreateFontString(self.frameid .. "optiontext" .. name,"OVERLAY")
	text:SetTextColor(1,1,0.5,1)
	text:SetPoint("TOPLEFT", self:GetXOffset(column), self:GetYOffset(column, height));
	text:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
	text:SetText(title);		
	text:Show()
end

function proto:AddSpace(column, pixels)
	self:GetYOffset(column, pixels)
end

function proto:AddSlider(column, name, title, default, database, callback, min, max )
	local height = 50;

	-- default state
	if(not database[name]) then
		database[name] = default;
	end
	
	-- create widget
	local slider = CreateFrame("Slider", self.frameid.."option"..name, self.window, "OptionsSliderTemplate")
	
	slider:SetWidth(self.columnwidths[column]-20)
	
	slider:SetPoint("TOPLEFT", self:GetXOffset(column), self:GetYOffset(column, height)-10);
	
	slider.tooltipText = database[name];
	
	getglobal(slider:GetName() .. 'Low'):SetText(min);
	getglobal(slider:GetName() .. 'High'):SetText(max);
	getglobal(slider:GetName() .. 'Text'):SetText(title);
	
	slider:SetMinMaxValues(min, max);
	slider:SetValueStep(1);
	slider:SetValue(database[name]);
	
	slider:SetScript("OnValueChanged", 
		function(self, value)
			database[name] = value;
			slider.tooltipText = value;
			(slider:GetScript("OnEnter"))(self)
			if(callback) then
				callback(self, name, database[name])
			end
		end
	);			

end



-- fillfunc should return a table of key/value pairs for display in the list
function proto:AddDropDown(column, name, title, default, database, callback, fillfunc)
	local height = 50
	if(not database[name]) then
		database[name] = default;
	end	
	local dropdown = CreateFrame("Frame", self.frameid .. "optiondropdown" .. name, self.window, "UIDropDownMenuTemplate")
	local ddinit = function(self, level, menuList) 
	  for k,v in pairs(fillfunc()) do
	    local info = UIDropDownMenu_CreateInfo()
	    info.text = k
	    info.value = v
	    info.func = function (item)
	    				database[name] = v
	    				UIDropDownMenu_SetSelectedValue(dropdown, v, false) 
	    				if(callback) then
	    					callback(self, name, v)
	    				end
	    			end
	    UIDropDownMenu_AddButton(info, level)
	  end
	  UIDropDownMenu_SetSelectedValue(dropdown, database[name], false)	  
	end
	UIDropDownMenu_Initialize(dropdown, ddinit)
	self:AddText(column, name.."textabove", title)
	dropdown:SetPoint("TOPLEFT", self:GetXOffset(column)-20, self:GetYOffset(column, height));
	UIDropDownMenu_SetWidth(dropdown, self.columnwidths[column] - 20, 0) 
	
end

-- { [r]=#, [g]=#, [b]=#, [a]=# }
function proto:AddColorPicker(column, name, title, default, database, callback)
	local height = 30
	local page = self;
	if(not database[name]) then
		database[name] = default;
	end	
	local col = database[name]
	local cf = CreateFrame("Frame", self.frameid .. "optioncolor" .. name, self.window)
	self:AddText(column, name.."textabove", title)
	cf:SetPoint("TOPLEFT", self:GetXOffset(column), self:GetYOffset(column, height));
	cf:SetWidth(self.columnwidths[column]-20);
	cf:SetHeight(height-5);
	cf.texture = cf:CreateTexture()
	cf.texture:SetAllPoints(cf)
	cf.texture:SetTexture(col.r,col.g,col.b,col.a)
	
	cf:SetScript("OnMouseUp", function()
		ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = true, col.a;
		ColorPickerFrame.previousValues = {col.r,col.g,col.b,col.a};
		ColorPickerFrame.func = function()
			col.r, col.g, col.b = ColorPickerFrame:GetColorRGB();
			cf.texture:SetTexture(col.r,col.g,col.b,col.a)
			if(callback) then
				callback(page, name, col)
			end
		end
		ColorPickerFrame.opacityFunc = function()
			col.a = OpacitySliderFrame:GetValue();
			cf.texture:SetTexture(col.r,col.g,col.b,col.a)
			if(callback) then
				callback(page, name, col)
			end
		end
		ColorPickerFrame.cancelFunc = function(restore)
			col.r, col.g, col.b, col.a = unpack(restore);
			cf.texture:SetTexture(col.r,col.g,col.b,col.a)
			if(callback) then
				callback(page, name, col)
			end			
		end
		ColorPickerFrame:SetColorRGB(col.r,col.g,col.b);
		ColorPickerFrame:Hide(); ColorPickerFrame:Show();
		ColorPickerFrame:SetFrameStrata("FULLSCREEN_DIALOG");ColorPickerFrame:Raise();
	end);
		    	
end