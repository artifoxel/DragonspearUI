---- LIST PORTRAIT PICKER ----

ListPortraitPicker = {}

function ListPortraitPicker:create(gender)
	return setmetatable({
		portraits = {},
		availablePortraits = {},
		tSort = "",
		sortToggle = 0,
		selected = "",
		selectedRow = 0,
		mediumPortrait = '',
		genderFilter = gender,
		invertNameFilter = { false, false },
		availablePortraits = ListPortraitPicker:getAvailablePortraits(),
	}, { __index = self })
end

function ListPortraitPicker.getAvailablePortraits()
	local seen = {}

	while true do
		local portrait = createCharScreen:GetCurrentPortrait()
		local key = portrait:lower()
		if seen[key] then
			break
		end
		seen[key] = portrait
		createCharScreen:IncCurrentPortrait()
	end

	return seen
end

function ListPortraitPicker:selectedPortraitDescription()
	local text = ''
	local portrait = self.portraits[self.selectedRow]
	if portrait then
		text = t(portrait.name):upper() .. '\n' .. t(PPStrings.PP_FILENAME):upper() .. t(portrait.filename)
		if self.mediumPortrait ~= '' then
			text = text .. ' & ' .. t(self.mediumPortrait)
		end
	end
	return text
end

function ListPortraitPicker:isCurrentPortraitSelected()
	local current = createCharScreen:GetCurrentPortrait()
	return self.selected == current or self.selected:lower() == current:lower()
end

function ListPortraitPicker:selectedPortrait()
	if self.selected ~= '' then
		return createCharScreen:GetCurrentPortrait()
	else
		return 'NOPORTMD'
	end
end


function ListPortraitPicker:filter(row)
	local portrait = self.portraits[row]
	if portrait == nil then
		return false
	end

	-- TODO: seems to be unnecessary
	-- filter out filenames that end with S or M
	-- local fname = portrait.filename
	-- if fname and fname:match('[mMsS]$') then
	-- 	return false
	-- end

	-- filter by name
	local name = portrait.name
	for i, search in ipairs({ duiPPNameFilter1, duiPPNameFilter2 }) do
		if search and search ~= '' then
			local found = string.find(name:lower(), search) ~= nil
			if found == self.invertNameFilter[i] then
				return false
			end
		end
	end

	return true
end

function ListPortraitPicker:sort()
	self.sortToggle = (self.sortToggle + 1) % 4
	self.selected = ''
	self.selectedRow = 0

	local cmp = nil
	if self.sortToggle < 2 then
		return self:update()
	elseif self.sortToggle == 2 then
		self.tSort = PPStrings.PP_SORTAZ
		cmp = function(a, b) return a.name:lower() < b.name:lower() end
	elseif self.sortToggle == 3 then
		self.tSort = PPStrings.PP_SORTZA
		cmp = function(a, b) return a.name:lower() > b.name:lower() end
	end
	table.sort(self.portraits, cmp)
end

function ListPortraitPicker:update()
	self.portraits = {}
	if self.sortToggle == 0 then
		self:addPortraits()
		self:addBGImages()
		self.tSort = PPStrings.PP_SORTDC
	elseif self.sortToggle == 1 then
		self:addBGImages()
		self:addPortraits()
		self.tSort = PPStrings.PP_SORTCD
	end

	-- filter by gender
	local filter = self.genderFilter
	if filter and #filter > 0 then
		local filtered = {}
		for _, p in pairs(self.portraits) do
			if p.gender == filter or p.gender == 'D' then
				table.insert(filtered, p)
			end
		end
		self.portraits = filtered
	end
end

function ListPortraitPicker:addBGImages()
	for i, portrait in ipairs(BGImages or {}) do
		local item = {
			name = portrait[1],
			gender = portrait[2]:match('^[FMD]$') or 'D',
			filename = portrait[3]:lower(),
		}
		if self.availablePortraits[item.filename] then
			table.insert(self.portraits, item)
		end
	end
end

function ListPortraitPicker:addPortraits()
	local genders = { 'M', 'F' }
	for i, portrait in ipairs(portraits) do
		local name = portrait[1]
		local filename = name .. 'L'
		if self.availablePortraits[filename:lower()] then
			table.insert(self.portraits, {
				name = nicks[name] or name,
				gender = genders[portrait[2]] or 'D',
				filename = filename,
			})
		end
	end
end

function ListPortraitPicker:updateMediumPortrait()
	-- if filename ends with 'l', replace 'l' with 'm'
	local fname = self.portraits[self.selectedRow].filename
	if fname and fname:sub(-1) == 'l' then
		self.mediumPortrait = fname:sub(1, -2) .. 'm'
	else
		self.mediumPortrait = ""
	end
end

function ListPortraitPicker:portraitBackground(row)
	if row == self.selectedRow then
		return "RGCPBUT"
	else
		return "RGCPBUT1"
	end
end

---- MULTI-PORTRAIT PICKER ----

portraitArray = {}

-- TODO: do we really need these toggles?
local function ZeroToggleArray()
	for i = 1, 28 do
		_G['togglePort' .. i] = 0
	end
end

function togglePortrait(i)
	local key = 'togglePort' .. i
	local tempTog = _G[key]
	ZeroToggleArray()
	_G[key] = tempTog
end

function OnPortraitArrayClick(thisOne)
	if portraitChoice == thisOne then
		portraitChoice = -1
	else
		portraitChoice = thisOne
	end
end

function IncPortraitArray()
	for index = 1, 28, 1 do
		portraitArray[index] = createCharScreen:GetCurrentPortrait()
		createCharScreen:IncCurrentPortrait()
	end
	ZeroToggleArray()
	portraitChoice = -1
end

function DecPortraitArray()
	for index = 1, 56, 1 do
		createCharScreen:DecCurrentPortrait()
	end
	IncPortraitArray()
end

function GetPortrait(portraitIndex)
	return portraitArray[portraitIndex]
end

function ChoosePortrait()
	if portraitChoice == -1 then
		Infinity_PopMenu()
		createCharScreen:OnCancelButtonClick()
	else
		for index = 29, portraitChoice+1, -1 do
			createCharScreen:DecCurrentPortrait()
		end
	end
end

function IsPortraitChosen()
	if portraitChoice == -1 then
		return 0
	else
		return 1
	end
end
