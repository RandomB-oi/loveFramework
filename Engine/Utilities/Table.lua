local module = {}

module.find = function(tbl, value)
	if not tbl then return end
	for i, v in pairs(tbl) do
		if v == value then
			return i
		end
	end
end

module.copy = function(tbl)
	if type(tbl) == "table" then
		local new = {}
		
		for index, value in pairs(tbl) do
			new[module.copy(index)]	= module.copy(value)
		end

		return new
	end

	return tbl
end

module.shallowCopy = function(tbl)
	if type(tbl) == "table" then
		local new = {}

		for index, value in pairs(tbl) do
			new[index]	= value
		end

		return new
	end

	return tbl
end

module.unpack = unpack

for i,v in pairs(table) do
	if not module[i] then
		module[i] = v
	end
end

return module