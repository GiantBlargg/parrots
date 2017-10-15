local serial = require 'gen-meta/serial'
local sha2 = require 'gen-meta/sha2'

function hash(f)
	local file = assert(io.open (f, 'rb'))
	local x = sha2.new256()
	for b in file:lines(2^12) do
		x:add(b)
	end
	file:close()
	return x:close()
end

meta = serial.load("manifest.lua")

hashes = {}
for _,value in ipairs(meta.files) do
	hashes[value] = hash(value)
end
meta.files=hashes

serial.save(meta, "repo")
