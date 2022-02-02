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

local function toggleSortKey(a, b)
	return a.label < b.label
end

-- private fields
local dirty = {}
local iniSection = 'Dragonspear UI++'
local helpSuffixes = { '1', '_HELP' }

local settings = {
	-- doesn't appear in the toggles list, if no label or value is not boolean
	-- help = help or label .. '1' or label .. '_HELP'
	cheatMode               = { value = true,  label = "RG_UI_CHEAT" },
	classicDialog           = { value = false, label = "RG_UI_CLASSIC_DIALOG" },
	multiPortraitPicker     = { value = true,  label = "RG_UI_MPPICKER" },
	largePortraits          = { value = false, label = "RG_UI_LPORTRAITS" },
	permThief               = { value = false, label = "RG_UI_THIEFBUTT" },
	disableSpaceKeyInDialog = { value = false, label = "RG_UI_DIALOG_DISABLE_SPACE" },

	-- TODO: translation
	compareEquipment        = { value = true,  label = "RG_UI_COMPARE_EQUIPMENT" },
	oneClickTravel          = { value = false, label = "RG_UI_ONE_CLICK_TRAVEL" },

#if WITH_LEFT_SIDE_PORTRAITS then
	leftSidePortraits       = { value = false, label = "RG_UI_LEFTPORTRAITS" },
#end

	-- displayed as string buttons in the UI
	largeJournal        = { value = true },
	quickLootExpertMode = { value = true }, -- advanced or expert
	quickLootRows       = { value = 10 }, -- in expert mode

	-- these don't show up in the UI settings
	quickLootVisible = { value = false },
	leftSideMenu     = { value = false },
}

-- public
duiSettings = {}

function duiSettings:load()
	for k, item in pairs(settings) do
		local v = item.value
		local vtype = type(v)

		if vtype == "boolean" then
			v = Infinity_GetINIValue(iniSection, k, v) == 1 and true or false
		elseif vtype == 'number' then
			v = Infinity_GetINIValue(iniSection, k, v)
		else
			v = Infinity_GetINIString(iniSection, k, v)
		end

		item.value = v
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
	local setting = assert(settings[key], "Invalid settings key: " .. key)
	return setting.value or default
end

function duiSettings:set(key, new, save)
	local old = settings[key].value

	-- don't delete old values
	-- don't set non existing
	-- new value has to be different
	-- don't change setting type
	if new == nil or old == nil or old == new or type(old) ~= type(new) then
		local msg = 'WARN: duiSettings:set failed old: %s = "%s", new: %s = "%s"'
		print(msg:format(type(old), old, type(new), new))
		return old
	end

	settings[key].value = new
	dirty[key] = new

	if save then
		self:save()
	end

	return new
end

function duiSettings:toggle(key, save)
	local value = settings[key].value
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

function duiSettings:buildToggles()
	local toggles = {}
	local togglesByKey = {}

	for key, setting in pairs(settings) do
		if setting.label ~= nil and type(setting.value) == "boolean" then
			local toggle = {
				key = key,
				label = t(setting.label),
				help = setting.help and t(setting.help) or "",
				value = setting.value,
				clickable = true,
			}

			if #toggle.help == 0 then
				for _, suffix in ipairs(helpSuffixes) do
					local help = setting.label .. suffix
					if uiStrings[help] then
						toggle.help = t(help)
						break
					end
				end
			end

			table.insert(toggles, toggle)
			togglesByKey[key] = toggle
		end
	end

	if Infinity_GetINIValue('Keymap Action', 'Thieving', 0) == 0 then
		local toggle = togglesByKey.permThief
		toggle.clickable = false
		toggle.help = t('RG_UI_THIEFBUTT1') .. '\n\n^W' .. t('RG_UI_THIEFBUTT_WARN')
	end

	table.sort(toggles, toggleSortKey)

	return toggles
end

duiSettings:migrate(1)
duiSettings:load()