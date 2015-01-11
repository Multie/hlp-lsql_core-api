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
	-- check table names

	-- check table rawcontents

	-- check definition

	-- check relational dependencies
end

---
--- creates a new table 
---
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

###################################################################################################################################################


function newTable()
	local tbl = {}
	local tblmt = {}
	tblmt.columns = {}
	tblmt.entities = {}
	function tblmt.__newindex(self, key)
		if(key == "addColumn") then

		elseif(key == "dropColumn") then

		elseif(key == "updateColumn") then

		end
	end
	setmetatable(tblmt, tbl)
	return tbl
end

function newDatabase( file )
	local db = {}
	local dbmt = {}
	dbmt.lsql = {}
	dbmt.lsql.path = file
	dbmt.lsql.tables = {}
	function dbmt.__newindex(self, key)
		if(key == "addTable") then
			local function addTable(name, sqlTable)
				--check for valid name
				--check for existance
				--check table integrity
				--add table definition to database
			end
			return addTable
		elseif(key == "renameTable") then
			local function renameTable(newName, sqlTable)
				--check for valid name
				--check for existance
				--change table name in database
			end
			return renameTable
		elseif(key == "dropTable") then
			local function dropTable(sqlTable)
				--check for valid name
				--check for existance
				--drop table name from database
			end
			return dropTable
		else
			if(type(key) ~= string) then
				error("database handle only allows for strings as table names, got "..type(key), 2)
			end
			for k,v in pairs(lsql.tables) do
				if(k == key) then
					return v
				end
			end
			error("your database does not contain a table called: "..key, 2)
		end
	end
	setmetatable(dbmt, db)
	return db
end