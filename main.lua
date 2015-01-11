--[[
	Package: hlp-lsql_core-api
	Author: CCodeX
]]

--storage
local sqlTables = {}
local sqlRelations = {}

sqlRelation = {
	table1 = "",
	colone = "",
	table2 = "",
	colmany = "",
}

local function verifyName( name )
	--check for name being a string
	if(not (type(name) == "string")) then
		error("the name must be a string", 2)
	end

	-- checker function
	local function isInString(string,char)
		local a
		local b
		a, b = string.find(string, char)
		if(a) then
			return true
		else
			return false
		end
	end

	-- allowed character sets
	local firstAllowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"
	local afterAllowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789"

	-- check for allowed name length
	if(#name < 2) then
		error("the name must be at least 2 characters long", 2)
	end

	-- check the first character in the name
	if(not isInString(firstAllowed, name[1])) then
		error("the name is not allowed to start with this character: "..name[1], 2)
	end

	--check the rest of the characters in the name
	for i = 2, #name, 1 do
		if(not isInString(afterAllowed, name[i])) then
			error("the name is not allowed to contain this character: "..name[i], 2)
		end
	end	
end

function saveToDisk( file )
	
	-- dump to single table
	local dump = {["tables"] = sqlTables, ["relations"] = sqlRelations}

	-- serialize
	local dumpString = textutils.serialize(dump)

	-- save
	local file = fs.open(file, "w")
	file.write(dumpString)
	file.close()
end
function loadFromDisk( file )

	-- clear current state
	for k,v in pairs(sqlTables) do
		sqlTables[k] = nil
	end
	for k,v in pairs(sqlRelations) do
		sqlRelations[k] = nil
	end

	-- load
	local file = fs.open( file, "r")
	local dumpString = file.readAll()
	file.close()

	-- unserialize
	local dump = textutils.unserialize(dumpString)

	-- insert to state
	for k,v in pairs(dump.tables) do
		sqlTables[k] = v
	end
	for k,v in pairs(dump.relations) do
		sqlRelations[k] = v
	end
end
local filename = "db.dump"
function setFile( file )
	filename = file
end
local function save()
	saveToDisk(filename)
end

--- this checks wether the current state of
--- the tables in memory are valid enough
--- to be saved onto disk
local function checkIntegrity()

end

function newTable( name )

	-- check for valid name
	local e
	local m
	e, m = pcall(verifyName, name)
	if(not e) then
		error(m, 2)
	end

	-- check whether a table is already existant
	if(sqlTables[name] ~= nil) then
		error("a table with this name already exists: "..name, 2)
	end

	-- add new table
	sqlTables[name] = {}

	-- save
	save()
end
function deleteTable( name )
	-- check for valid name
	local e
	local m
	e, m = pcall(verifyName, name)
	if(not e) then
		error(m, 2)
	end

	-- check whether a table is already existant
	if(sqlTables[name] == nil) then
		error("a table with this name does not exist: "..name, 2)
	end

	-- delete table
	sqlTables[name] = nil

	-- save
	save()
end