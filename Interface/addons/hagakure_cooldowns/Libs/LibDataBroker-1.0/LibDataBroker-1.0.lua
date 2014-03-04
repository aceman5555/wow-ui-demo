LibDataBroker = LibDataBroker or {}

LibDataBroker.attributestorage, LibDataBroker.namestorage, LibDataBroker.proxystorage = LibDataBroker.attributestorage or {}, LibDataBroker.namestorage or {}, LibDataBroker.proxystorage or {}
local attributestorage, namestorage = LibDataBroker.attributestorage, LibDataBroker.namestorage

-- Rift conversion to callbacks stuff
LibDataBroker.FireAttributeChanged = LibDataBroker.FireAttributeChanged or Utility.Event.Create("LibDataBroker", "AttributeChanged")
LibDataBroker.FireObjectCreated = LibDataBroker.FireObjectCreated or Utility.Event.Create("LibDataBroker", "ObjectCreated")

LibDataBroker.domt = {
	__metatable = "access denied",
	__index = function(self, key) return attributestorage[self] and attributestorage[self][key] end,
}

LibDataBroker.domt.__newindex = function(self, key, value)
	if not attributestorage[self] then attributestorage[self] = {} end
	if attributestorage[self][key] == value then return end
	attributestorage[self][key] = value
	local name = namestorage[self]
	if not name then return end
		
	--[[
	callbacks:Fire("LibDataBroker_AttributeChanged", name, key, value, self)
	callbacks:Fire("LibDataBroker_AttributeChanged_"..name, name, key, value, self)
	callbacks:Fire("LibDataBroker_AttributeChanged_"..name.."_"..key, name, key, value, self)
	callbacks:Fire("LibDataBroker_AttributeChanged__"..key, name, key, value, self)
	]]--
	
	-- Rift conversion code
	LibDataBroker.FireAttributeChanged(name, key, value, self)
end

function LibDataBroker:NewDataObject(name, dataobj)
	if self.proxystorage[name] then return end

	if dataobj then
		assert(type(dataobj) == "table", "Invalid dataobj, must be nil or a table")
		self.attributestorage[dataobj] = {}
		for i,v in pairs(dataobj) do
			self.attributestorage[dataobj][i] = v
			dataobj[i] = nil
		end
	end
	dataobj = setmetatable(dataobj or {}, self.domt)
	self.proxystorage[name], self.namestorage[dataobj] = dataobj, name
	-- self.callbacks:Fire("LibDataBroker_DataObjectCreated", name, dataobj)
	
	-- Rift conversion code
	LibDataBroker.FireObjectCreated(name, dataobj)
	
	return dataobj
end

function LibDataBroker:DataObjectIterator()
	return pairs(self.proxystorage)
end

function LibDataBroker:GetDataObjectByName(dataobjectname)
	return self.proxystorage[dataobjectname]
end

function LibDataBroker:GetNameByDataObject(dataobject)
	return self.namestorage[dataobject]
end

local next = pairs(attributestorage)
function LibDataBroker:pairs(dataobject_or_name)
	local t = type(dataobject_or_name)
	assert(t == "string" or t == "table", "Usage: ldb:pairs('dataobjectname') or ldb:pairs(dataobject)")

	local dataobj = self.proxystorage[dataobject_or_name] or dataobject_or_name
	assert(attributestorage[dataobj], "Data object not found")

	return next, attributestorage[dataobj], nil
end

local ipairs_iter = ipairs(attributestorage)
function LibDataBroker:ipairs(dataobject_or_name)
	local t = type(dataobject_or_name)
	assert(t == "string" or t == "table", "Usage: ldb:ipairs('dataobjectname') or ldb:ipairs(dataobject)")

	local dataobj = self.proxystorage[dataobject_or_name] or dataobject_or_name
	assert(attributestorage[dataobj], "Data object not found")

	return ipairs_iter, attributestorage[dataobj], 0
end