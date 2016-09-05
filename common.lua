local common = {}

function common.findValue(t, value)
	for key, other in pairs(t) do
		if other == value then
			return key
		end
	end

	return nil
end

function common.removeValue(t, value)
	local key = common.findValue(t, value)

	if key ~= nil then
		t[key] = nil
	end

	return key
end

function common.findArrayValue(t, value)
	for key, other in ipairs(t) do
		if other == value then
			return key
		end
	end

	return nil
end

function common.removeArrayValue(t, value)
	local key = common.findArrayValue(t, value)

	if key ~= nil then
		t[key] = nil
	end

	return key
end

return common
