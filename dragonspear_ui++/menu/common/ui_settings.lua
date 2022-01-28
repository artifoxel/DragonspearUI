function duiHighlightSelectedText(text, value, selected)
	if value == selected then
		return '^R' .. text .. '^-'
	end
	return text
end

local function boolToInt(value, default)
	if value == true then
		return 1
	elseif value == false then
		return 0
	end
	return default
end

-- private fields
local dirty = {}
local iniSection = 'Dragonspear UI++'

local settings = {
	cheatMode = false,
	leftSideMenu = false,
	classicDialog = false,
	multiPortraitPicker = true,
	largePortraits = false,
	permThief = false,
	largeJournal = true,
	quickLootExpertMode = true, -- advanced or expert
	quickLootRows = 10, -- in expert mode
	quickLootVisible = false,
	disableSpaceKeyInDialog = false,
	compareEquipment = true, -- TODO: ui
	oneClickTravel = false, -- TODO: ui
#if WITH_LEFT_SIDE_PORTRAITS then
	leftSidePortraits = false,
#end
}

-- public
duiSettings = {}

function duiSettings:load()
	for k, v in pairs(settings) do
		local vtype = type(v)

		if vtype == "boolean" then
			v = Infinity_GetINIValue(iniSection, k, v) == 1 and true or false
		elseif vtype == 'number' then
			v = Infinity_GetINIValue(iniSection, k, v)
		else
			v = Infinity_GetINIString(iniSection, k, v)
		end

		assert(v ~= nil)

		settings[k] = v
		dirty[k] = nil
	end
end

function duiSettings:save()
	for k, v in pairs(dirty) do
		Infinity_SetINIValue(iniSection, k, boolToInt(v, v))
		dirty[k] = nil
	end
end

function duiSettings:get(key, default)
	return settings[key] or default
end

function duiSettings:set(key, new, save)
	local old = settings[key]

	-- don't delete old values
	-- don't set non existing
	-- new value has to be different
	-- don't change setting type
	if new == nil or old == nil or old == new or type(old) ~= type(new) then
		local msg = 'WARN: duiSettings:set failed old: %s = "%s", new: %s = "%s"'
		print(msg:format(type(old), old, type(new), new))
		return old
	end

	settings[key] = new
	dirty[key] = new

	if save then
		self:save()
	end

	return new
end

function duiSettings:toggle(key, save)
	local value = settings[key]
	if value == true or value == false then
		return self:set(key, not value, save)
	end
end


function duiSettings:migrate(newVersion)
	local versionKey = 'settings:version'
	local oldVersion = Infinity_GetINIValue(iniSection, versionKey, 0)

	if newVersion == oldVersion then
		return
	end

	if oldVersion == 0 then
		local map = {
			cheatMode = 'CheatMode',
			leftSideMenu = 'LeftSideMenu',
			classicDialog = 'ClassicDialog',
			multiPortraitPicker = 'MultiPortraitPicker',
			largePortraits = 'LargePortraits',
			permThief = 'PermThief',
			disableSpaceKeyInDialog = 'Disable Space Key In Conversations',
			compareEquipment = 'Equipment Comparison',
			oneClickTravel = 'Single Click Travel',
		#if WITH_LEFT_SIDE_PORTRAITS then
			leftSidePortraits = 'Left Side Portrait',
		#end
			-- string values
			largeJournal = 'SelectedJournalSize',
			quickLootExpertMode = 'QuicklootMode',
			quickLootRows = 'QuicklootENumber',
			quickLootVisible = 'QuicklootStartPreference',
		}

		local fromString = {
			['0'] = 0, ['1'] = 1,
			[UIStrings.UI_Advanced] = 0, [UIStrings.UI_Expert] = 1,
			[UIStrings.UI_Small] = 0, [UIStrings.UI_Large] = 1,
			[UIStrings.UI_Hidden] = 0, [UIStrings.UI_Visible] = 1,
			Two = 2, Three = 3, Four = 4, Five = 5, Six = 6, Ten = 10,
		}

		for newKey, oldKey in pairs(map) do
			local value = Infinity_GetINIString('Game Options', oldKey, '')
			if value ~= '' then
				value = fromString[value]

				if value == nil then
					-- use default, false/true => 0/1
					value = settings[newKey]
					value = boolToInt(value, value)
				end

				Infinity_SetINIValue(iniSection, newKey, value)
				Infinity_SetINIValue('Game Options', oldKey, nil)
			end
		end
	end

	Infinity_SetINIValue(iniSection, versionKey, newVersion)
end

duiSettings:migrate(1)
duiSettings:load()