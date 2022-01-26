luaEdit = ""
luaEditDebugDump = 0
luaEditHistory = {}
luaEditMaxHistory = 10
luaEditHistoryIndex = 0
luaEditShowHistoryList = 0
luaEditHistoryListSelected = 0
function updateLuaHistory()
	local i = 2
	local tempTab = {}
	tempTab[1] = luaEdit
	while ( i <= luaEditMaxHistory ) do
		tempTab[i] = luaEditHistory[i-1]
		i = i + 1
	end
	luaEditHistory = tempTab
end
function loadLuaHistory()
	local i = 1
	while (i <= luaEditMaxHistory ) do
		luaEditHistory[i] = Infinity_GetINIString("Lua Edit","String"..i-1, "")
		i = i + 1
	end
end
function saveLuaHistory()
	local i = 1
	while (i <= luaEditMaxHistory ) do
		Infinity_SetINIValue("Lua Edit","String"..i-1, luaEditHistory[i])
		i = i + 1
	end
end
function luaEditHistoryUp()
	if(luaEditHistoryIndex <= 1) then return end
	luaEditHistoryIndex = luaEditHistoryIndex - 1
	luaEdit = luaEditHistory[luaEditHistoryIndex]
end
function luaEditHistoryDown()
	if(luaEditHistoryIndex == luaEditMaxHistory) then return end
	if(luaEditHistory[luaEditHistoryIndex + 1] == "") then return end
	luaEditHistoryIndex = luaEditHistoryIndex + 1
	luaEdit = luaEditHistory[luaEditHistoryIndex]
end

cheatGoldAmt = 1000000
cheatXpAmt = 500000

cheatAreaDisplayList = {}
