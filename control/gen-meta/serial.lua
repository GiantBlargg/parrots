local g_tLuaKeywords = {
	[ "and" ] = true,
	[ "break" ] = true,
	[ "do" ] = true,
	[ "else" ] = true,
	[ "elseif" ] = true,
	[ "end" ] = true,
	[ "false" ] = true,
	[ "for" ] = true,
	[ "function" ] = true,
	[ "if" ] = true,
	[ "in" ] = true,
	[ "local" ] = true,
	[ "nil" ] = true,
	[ "not" ] = true,
	[ "or" ] = true,
	[ "repeat" ] = true,
	[ "return" ] = true,
	[ "then" ] = true,
	[ "true" ] = true,
	[ "until" ] = true,
	[ "while" ] = true,
}

local function serializeImpl( t, tTracking, sIndent )
	local sType = type(t)
	if sType == "table" then
		if tTracking[t] ~= nil then
			error( "Cannot serialize table with recursive entries", 0 )
		end
		tTracking[t] = true

		if next(t) == nil then
			-- Empty tables are simple
			return "{}"
		else
			-- Other tables take more work
			local sResult = "{\n"
			local sSubIndent = sIndent .. "  "
			local tSeen = {}
			for k,v in ipairs(t) do
				tSeen[k] = true
				sResult = sResult .. sSubIndent .. serializeImpl( v, tTracking, sSubIndent ) .. ",\n"
			end
			for k,v in pairs(t) do
				if not tSeen[k] then
					local sEntry
					if type(k) == "string" and not g_tLuaKeywords[k] and string.match( k, "^[%a_][%a%d_]*$" ) then
						sEntry = k .. " = " .. serializeImpl( v, tTracking, sSubIndent ) .. ",\n"
					else
						sEntry = "[ " .. serializeImpl( k, tTracking, sSubIndent ) .. " ] = " .. serializeImpl( v, tTracking, sSubIndent ) .. ",\n"
					end
					sResult = sResult .. sSubIndent .. sEntry
				end
			end
			sResult = sResult .. sIndent .. "}"
			return sResult
		end

	elseif sType == "string" then
		return string.format( "%q", t )

	elseif sType == "number" or sType == "boolean" or sType == "nil" then
		return tostring(t)

	else
		error( "Cannot serialize type "..sType, 0 )

	end
end

function serialize( t )
	local tTracking = {}
	return serializeImpl( t, tTracking, "" )
end

function unserialize( s )
	local func = loadstring( "return "..s, "unserialize")
	if func then
		local ok, result = pcall( func )
		if ok then
			return result
		end
	end
	return nil
end

function save (s,f)
	local file,err = io.open( f, "w" )
	if err then return err end
	file:write(serialize(s))
	file:close()
end

function load(f)
	local file,err = io.open( f, "r" )
	if err then return err end
	local t = unserialize(file:read("*all"))
	file:close()
	return t
end

return _G
