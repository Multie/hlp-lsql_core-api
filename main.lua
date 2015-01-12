--[[
	Package: hlp-lsql_core-api
	Author: CCodeX
]]

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

local colTypes = {}



function newColumn(obj)
	obj = obj or {}
	local col = {}
	local colmt = {}
	colmt.lsql = {}

	--defaults
	colmt.lsql.PK = obj.PK or false
	colmt.lsql.UQ = obj.UQ or false
	colmt.lsql.NN = obj.NN or false
	colmt.lsql.UN = obj.UN or false
	colmt.lsql.type = obj.type or "int"
	colmt.lsql.relation = obj.relation or false

	--backtrack
	colmt.lsql.upperTable = obj.upperTable or nil

	setmetatable(colmt, col)
	return col
end

function newTable()
	local tbl = {}
	local tblmt = {}
	tblmt.lsql.columns = {}
	tblmt.lsql.entities = {}

	--backtrack
	tblmt.lsql.upperDB = nil

	function tblmt.__newindex(self, key)
		if(key == "addColumn") then
			--check for valid name
			--check for existance
			--check col integrity
			--
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