---- LIST PORTRAIT PICKER ----

ListPortraitPicker = {
	sort = {
		-- default portraits first
		selected = {
			label = PPStrings.PP_SORTDC,
			cmp = function(a, b)
				if a.custom ~= b.custom then
					return b.custom
				end
				return a.key < b.key
			end
		},
		-- custom first
		{
			label = PPStrings.PP_SORTCD,
			cmp = function(a, b)
				if a.custom ~= b.custom then
					return a.custom
				end
				return a.key < b.key
			end
		},
		-- from A to Z
		{
			label = PPStrings.PP_SORTAZ,
			cmp = function(a, b) return a.key < b.key end
		},
		-- from Z to A
		{
			label = PPStrings.PP_SORTZA,
			cmp = function(a, b) return a.key > b.key end
		}
	}
}

function ListPortraitPicker:create()
	local portraits, ncustom = self.getPortraits()
	table.sort(portraits, self.sort.selected.cmp)

	return setmetatable({
		portraits = portraits,
		portraitCountLabel = ("%s\n%s%s\n%s%s"):format(
			t(PPStrings.PP_TOTAL),
			t(PPStrings.PP_DEFAULT), #portraits - ncustom,
			t(PPStrings.PP_CUSTOM), ncustom
		),
		selected = nil,
		invertNameFilter = { false, false },
	}, { __index = self })
end

function ListPortraitPicker.getAvailablePortraits()
	local dups, limit = 0, 10
	local seen = {}

	-- can't just stop after the first duplicate, for example:
	-- 12134|12134|... would only return { 1, 2 }
	-- stop if we haven't seen new portraits for :limit: iterations
	while dups < limit do
		local filename = createCharScreen:GetCurrentPortrait()
		local key = filename:upper()

		if seen[key] then
			dups = dups + 1
		else
			dups = 0
			seen[key] = filename
		end

		createCharScreen:IncCurrentPortrait()
	end

	return seen
end

function ListPortraitPicker:filter(row)
	local portrait = self.portraits[row]
	if portrait == nil then
		return false
	end

	-- filter by lowercase name
	local name = portrait.key
	for i, filter in ipairs({ duiPPNameFilter1, duiPPNameFilter2 }) do
		if filter and filter ~= '' then
			local found = name:find(filter) ~= nil
			if found == self.invertNameFilter[i] then
				return false
			end
		end
	end

	return true
end

function ListPortraitPicker:onSortButtonClicked()
	-- rotate sort method
	table.insert(self.sort, self.sort.selected)
	self.sort.selected = table.remove(self.sort, 1)
	self.selected = nil

	table.sort(self.portraits, self.sort.selected.cmp)
end

function ListPortraitPicker:portraitBackground(row, selectedRow)
	if row == selectedRow and self.selected then
		return "RGCPBUT"
	else
		return "RGCPBUT1"
	end
end

function ListPortraitPicker.getPortraits()
	local available = ListPortraitPicker.getAvailablePortraits()
	local imageExists = {}

	for _, file in pairs(Infinity_GetFilesOfType("bmp")) do
		imageExists[file[1]:upper()] = true
	end

	local builtinPortraits = {}
	local genders = {}

	for _, portrait in pairs(portraits) do
		-- available[filename] is true, if gender matches and file exists
		-- available[portrait] is true, if gender matches but file is missing
		local filename = portrait[1]:upper() .. 'L'
		if available[filename] then
			builtinPortraits[filename] = portrait[1]
			genders[portrait[2] or 0] = true
		end
	end

	-- filter by gender only if we found exactly one valid gender
	local gender = next(genders)
	if gender == nil or next(genders, gender) then
		gender = nil
	else -- map 1 to M, 2 to F, the rest to nil
		gender = ({ 'M', 'F' })[gender]
	end

	local nicks = nicks or {}
	local results = {}
	local ncustom = 0
	local description = '%s\n' .. t(PPStrings.PP_FILENAME):upper() .. '%s'

	for key, filename in pairs(available) do
		if not imageExists[key] then
			print(('WARN: portrait "%s" not found'):format(filename))
			-- goto requires Lua 5.2+, available since at least patch 2.5
			goto continue
		end

		local portrait = { filename = filename, custom = false }
		local name = builtinPortraits[key]

		if not name then
			name = filename
			local suffix = name:sub(-1)

			if suffix == 'L' then
				name = name:sub(1, -2)

				local medium = name .. 'M'
				if imageExists[medium:upper()] then
					portrait.medium = medium
				end
			elseif suffix == 'm' or suffix == 'M' then
				-- skip this 'M' portrait if there is an 'L' version of it
				if available[key:sub(1, -2) .. 'L'] then
					goto continue
				end
			end

			if name:match('^[fmFM]#') then
				if gender and gender ~= name:sub(1, 1):upper() then
					goto continue
				end
				name = name:sub(3)
			end

			portrait.custom = true
			ncustom = ncustom + 1
		end

		portrait.name = nicks[name] or nicks[filename] or name
		portrait.key = portrait.name:lower() -- used for search filter
		portrait.description = description:format(portrait.name:upper(), filename)

		if portrait.medium then
			portrait.description = portrait.description .. ' & ' .. portrait.medium
		end

		table.insert(results, portrait)

		::continue::
	end

	return results, ncustom
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
