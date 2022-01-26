QFilter = Infinity_GetINIValue('Journal', 'Quest Filter', 0)

function setQuestFilter(value)
	QFilter = value
	saveQFilter = true
end

function highlightFilter_Small(text)
	if QFilter == 0 and text == 'All' then
		return '^M' .. text .. '^-'
	elseif QFilter == 1 and text == 'Active' then
		return '^M' .. text .. '^-'
	elseif QFilter == 2 and text == 'Completed' then
		return '^M' .. text .. '^-'
	end
	return '^5' .. text .. '^-'
end


function CheckForOpenedQuests_Small()
	QuestOpen = 0
	for i=1,#questDisplay,1 do
		if questDisplay[i].expanded == 1  then
			QuestOpen = 1
		end
	end
end

function findQuestPopUp()
	FindTitle = string.sub(FindTitle,1,15)
	for i=1,#questDisplay,1 do
		local rowTab =  questDisplay[i]
		local text = Infinity_FetchString(rowTab.text)
		if string.find(string.lower(text), string.lower(FindTitle)) then
			questDisplay[i].expanded = 1
			questDisplay[i+1].expanded = 1
			QFilter = 3
		end
	end
end

function questEnabled_Small(row)
	if questEnabled(row) then
		if QFilter == 0 then
			return true
		elseif QFilter == 1 then
			return not getFinished(row)
		elseif QFilter == 2 then
			return getFinished(row)
		elseif QFilter == 3 then
			return item.expanded == 1
		end
	end
end

function getArrowEnabled_Small(row)
	local item = questDisplay[row]
	if item.quest == nil and item.objective == nil then return nil end
	if item.objective and not objectiveEnabled(row) then return nil end
	if item.quest and not questEnabled_Small(row) then return nil end
	return 1
end

function processQuestsWithStyle_Small()
	out = ""
	for k,v in pairs(quests_old) do
		local questStrref = v[3]
		out = out .. "createQuest    ( " .. questStrref .. " )\n"

		for k2,v2 in pairs(journals_quests_old) do
			if(v2[2] == k) then
				local subgroup = v2[const.ENTRIES_IDX_SUBGROUP]
				if(subgroup == 0) then subgroup = "nil" end
				out = out .. "createEntry    ( " .. questStrref .. ", -1, " .. v2[1] .. ", {}, " .. subgroup .." )\n"
			end
		end
	end
	Infinity_Log(out)
end

function getJournalEditedColours(text)
	local notes = JFStrings.JF_Notes
	local edited = JFStrings.JF_Edited
	local prefix = nil

	if text:sub(1, #notes - 1) == notes:sub(1, #notes  - 1) then
		prefix, text = notes, text:sub(#notes + 1)
	elseif text:sub(1, #edited - 1) == edited:sub(1, #edited - 1) then
		prefix, text = edited, text:sub(#edited + 1)
	else
		return text
	end

	local color = getJournalDarken(rowNumber) and '^$' or '^M'
	return color .. prefix .. "^-" .. text
end