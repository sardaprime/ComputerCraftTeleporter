-- Self service teleporter for DAOS Minecraft Club
-- By MrJ, based on code by Direwolf20

os.loadAPI("button")
local dualMonitor = false
local monitors = {}
local m = {}
local playerName = "MrJ"
local mainMenuBool = true
local page = 1
local pages = 0
local players = {}
local playerCount = 0

function scanPlayers()
	players = {}
	playerCount = 0
	_, users = commands.xp(0, "@a")
	for a,b in pairs(users) do
		local name = ""
		strStart, strEnd = string.find(b,"to ")
		name = string.sub(b,strEnd+1)
		players[playerCount] = name
		playerCount = playerCount+1
	end
	choosePlayer()
end

function choosePlayer()
	local screenx, screeny,x,y
	local npp = 12 --names per page
	local row = 12
	
	pages = math.ceil(playerCount/npp)
	-- pages = 2
	-- print("Player count: " ..playerCount)
	
	-- players[1] = "Direwolf20"
	-- players[2] = "Soaryn"
	-- players[3] = "Pahimar"
	-- players[4] = "RWTema"
	-- players[5] = "cpw"
	-- players[6] = "Vaskii"
	-- players[7] = "MineMaarten"
	-- players[8] = "Rorax"
	-- players[9] = "boni"
	-- players[10] = "Quetzi"
	-- players[11] = "azanor"
	-- players[12] = "Vswe"
	-- players[13] = "WayofFlowingTime"
	-- players[14] = "XCompWiz"
	-- players[15] = "jadedcat"
	
	button.clearTable()
	m.setBackgroundColor(colors.black)
	m.clear()
	m.setTextColor(colors.white)
	m.setCursorPos(1,1)
	button.label(4,1,"Choose target player for teleport:")
	button.setTable("Quit",mainMenu,"",18,23,18,18)
	button.setTable("Next Page", nextPage, "", 27, 37, 18, 18)
	button.setTable("Prev Page", prevPage, "", 4, 14, 18, 18)
	button.label(14,3, "Page: "..tostring(page).." of "..tostring(pages))
		
	screenx = 2
	screeny = 1
	playerCount = 0
	for i,j in pairs(players) do
		playerCount = playerCount + 1
		if playerCount > npp*(page-1) and playerCount < npp*page+1 then
			row = 4+(screeny)
			button.setTable(j, teleport, j, screenx, screenx+17, row, row)
			if screenx == 21 then 
				screenx = 2 
				screeny = screeny + 2
			else 
				screenx = screenx+19 
			end
		end
	end
	button.screen()	
	x,y,side = getClick()
	while not button.checkxy(x,y) do
		x,y = getClick()
	end
end

function nextPage()
	if page+1 <= pages then
		page = page+1
	end
	choosePlayer()
end

function prevPage()
	if page-1 >= 1 then
		page = page-1
	end
   choosePlayer()
end  

function teleport(playerName)
	--if playerName == "MrJ" then
		--playerName = "-650 4 1100"
	--end
	print("Teleporting to: "..playerName)
	commands.exec("tp @p "..playerName)
	m.clear()
end

function connectMonitors()
	monitors = {peripheral.find("monitor")}
	for funcName,_ in pairs(monitors[1]) do
		m[funcName] = function(...)
			for i=1,#monitors-1 do monitors[i][funcName](unpack(arg)) end
			return monitors[#monitors][funcName](unpack(arg))
		end
	end
end

function mainMenu()
	mainMenuBool = true
	page = 1
	button.clearTable()
	m.setBackgroundColor(colors.black)
	m.clear()
	m.setTextColor(colors.white)
	m.setCursorPos(1,1)
	button.label(9,1,"Welcome to the Teleporter")
	button.label(17,2,"by MrJ")
	button.setTable("Start", new, "", 10, 30, 9, 11)
	button.screen()
end

function new()
	scanPlayers()
	mainMenuBool = false
	button.clearTable()
	m.clear()
	mainMenu()
	button.screen()
end

function getClick()
	local event, side, x, y = os.pullEvent("monitor_touch")
	return x,y,side
end

function waitPlayer()
   local tempColor
   local valid = false
   x,y = getClick()
   if button.checkxy(x,y) then
	return true
	end
   if mainMenuBool then
	return true
	end
end

connectMonitors()
mainMenu()
while true do
	waitPlayer()
end