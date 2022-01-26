-- Splits every quest with mixed stateType objectives in two,
-- one containing only completed objectives and the other one the rest.
local function splitCompletedObjectives(quests)
	local i = 1
	local extra = nil

	return function()
		if extra then
			local value = extra
			i, extra = i + 1, nil
			return value
		end

		local quest = quests[i]

		-- end of iterator
		if not quest then
			return nil
		end

		-- inactive quest or nothing to split
		local active = quest.stateType and quest.stateType ~= const.ENTRY_TYPE_NONE
		if not active or #quest.objectives < 2 then
			i = i + 1
			return quest
		end

		local complete = {}
		local inprogress = {}

		-- where to put INFO and USER objectives
		local questComplete = quest.stateType == const.ENTRY_TYPE_COMPLETE
		local other = questComplete and complete or inprogress

		for _, objective in ipairs(quest.objectives) do
			local state = objective.stateType
			if state == const.ENTRY_TYPE_COMPLETE then
				table.insert(complete, objective)
			elseif state == const.ENTRY_TYPE_INPROGRESS then
				table.insert(inprogress, objective)
			elseif state ~= const.ENTRY_TYPE_NONE then
				table.insert(other, objective)
			end
		end

		-- all objectives are in the same category, just return the quest
		if #complete == 0 or #inprogress == 0 then
			i = i + 1
			return quest
		end

		complete = { objectives = complete, stateType = const.ENTRY_TYPE_COMPLETE }
		inprogress = { objectives = inprogress, stateType = const.ENTRY_TYPE_INPROGRESS }

		-- copy missing props from quest
		-- skip children, buildQuestDisplay adds them later
		for k, v in pairs(quest) do
			if not complete[k] and k ~= 'children' then
				-- copy in case v is a table, e.g. chapters
				complete[k] = deepcopy(v)
				inprogress[k] = deepcopy(v)
			end
		end

		extra = inprogress
		return complete
	end
end

function reinitQuests()
	for questIdx, quest in pairs(quests) do
		local noquest = true
		for objIdx,objective in pairs(quest.objectives) do
			local noobjective = true
			for entryIdx,entry in pairs(objective.entries) do
				if quests[questIdx].objectives[objIdx].entries[entryIdx].stateType ~= const.ENTRY_TYPE_NONE and quests[questIdx].objectives[objIdx].entries[entryIdx].stateType ~= nil then
					noobjective = false
				end
			end
			if noobjective then
				quests[questIdx].objectives[objIdx].stateType = const.ENTRY_TYPE_NONE
			end
			if quests[questIdx].objectives[objIdx].stateType ~= const.ENTRY_TYPE_NONE and quests[questIdx].objectives[objIdx].stateType ~= nil then
				noquest = false
			end
		end
		if noquest then
			quests[questIdx].stateType = const.ENTRY_TYPE_NONE
		end
	end
end

function initQuests()
	--instead of always searching the quests, just map entry ids to their quests
	entryToQuest = {}
	for questIdx, quest in pairs(quests) do
		quests[questIdx].stateType = const.ENTRY_TYPE_NONE
		for objIdx,objective in pairs(quest.objectives) do
			quests[questIdx].objectives[objIdx].stateType = const.ENTRY_TYPE_NONE
			for entryIdx,entry in pairs(objective.entries) do
				quests[questIdx].objectives[objIdx].entries[entryIdx].stateType = const.ENTRY_TYPE_NONE
				entryToQuest[entry.id] = questIdx
			end
		end
	end
end

function compareByRecvTime(o1,o2)
	if(not o1.recvTime and not o2.recvTime) then return false end
	if(not o1.recvTime) then return false end
	if(not o2.recvTime) then return true end
	return o1.recvTime > o2.recvTime
end

function buildEntry(text, recvTime, stateType, chapter, timeStamp)
	local entry =
		{
			text = text,
			recvTime = recvTime,
			stateType = stateType,
			timeStamp = timeStamp,
			chapters = {}
		}
	entry.chapters[chapter] = 1
	return entry
end

--Update a journal entry by the strref/journalId
function updateJournalEntry(journalId, recvTime, stateType, chapter, timeStamp)
	if(stateType == const.ENTRY_TYPE_USER) then
		local entry = buildEntry(journalId, recvTime, stateType, chapter, timeStamp)
		table.insert(userNotes,entry)

		--update display data
		buildQuestDisplay()
		return
	end
	--find the quest that is parent to this entry.
	--NOTE this can be placed in a loop if there needs to be more than quest to an entry
	--this would just mean entryToQuest returns a table that we iterate over
	local questId = entryToQuest[journalId]
	if questId == nil or stateType == const.ENTRY_TYPE_INFO then
		--add loose entries into the looseEntries table so they still get displayed.
		for _,entry in pairs(looseEntries) do
			if entry.text == journalId then
				return
			end
		end
		local entry = buildEntry(journalId, recvTime, stateType, chapter, timeStamp)
		table.insert(looseEntries,entry)

		--update display data
		buildQuestDisplay()
		return
	end

	local quest = quests[questId]
	if quest == nil then
		print("JOURNAL ERROR - no quest entry associated with questId "..questId)
		return
	end
	local previous = nil
	--traverse quest to find objective and entry
	for objIdx,objective in pairs(quest.objectives) do
		for entryIdx,entry in pairs(objective.entries) do
			if(entry.id == journalId) then
				--now we know where our quest, objective, and entry are
				--update quest, objective and entry appropriately
				entry.recvTime = recvTime
				entry.stateType = stateType
				if(not entry.chapters) then entry.chapters = {} end
				entry.chapters[chapter] = 1
				entry.timeStamp = timeStamp
				objective.entries[entryIdx] = entry

				objective.recvTime = recvTime
				if(not objective.chapters) then objective.chapters = {} end
				objective.chapters[chapter] = 1
				if(objective.stateType ~= const.ENTRY_TYPE_COMPLETE) then
					objective.stateType = stateType
				end
				quest.objectives[objIdx] = objective

				quest.recvTime = recvTime
				if(not quest.chapters) then quest.chapters = {} end
				quest.chapters[chapter] = 1
				if(quest.stateType ~= const.ENTRY_TYPE_COMPLETE) then
					quest.stateType = stateType
				end

				--mark any previous objective as complete
				if(entry.previous ~= nil) then
					for objIdx2,objective2 in pairs(quest.objectives) do
						for k, prevObj in pairs(entry.previous) do
							if(prevObj == objective2.text) then
								quest.objectives[objIdx2].stateType = const.ENTRY_TYPE_COMPLETE
							end
						end
					end
				end

				quests[questId] = quest

				--remove all in subgroup (except myself!)
				if(stateType == const.JOURNAL_STATE_COMPLETE and entry.subGroup) then
					for k,v in pairs(subGroups[entry.subGroup]) do
						if(v.id ~= entry.id) then
							removeJournalEntry(v.id)
						end
					end
				end

			end
		end
	end
	--sort the objectives.
	table.sort(quest.objectives,compareByRecvTime)

	--update display data
	buildQuestDisplay()
end
function checkEntryComplete(journalId, stateType)
	--Check if a journal entry is part of a quest that's already complete

	--If anything other than an unfinished entry return false.
	if(stateType ~= const.ENTRY_TYPE_INPROGRESS) then return false end

	--Check if my quest is marked complete.
	local questIndex = entryToQuest[journalId]
	if (quests[questIndex].stateType == const.ENTRY_TYPE_COMPLETE) then
		return 1
	else
		return 0
	end
end
--this should maybe be done recursively, but i kinda want direct control over each level
function buildQuestDisplay()
	--this is basically just a flatten
	questDisplay = {}
	journalDisplay = {}

	local journalEntries = {} --temp holding table for sorting the entries

	-- Quests that contain both active and completed objectives mess up the large journal UI
	-- and are misleading in the small journal, hence we're doing the split.
	for quest in splitCompletedObjectives(quests) do
		--skip inactive quests
		if(quest.stateType ~= nil and quest.stateType ~= const.ENTRY_TYPE_NONE) then
			quest.quest = 1 -- tell the renderer what type of entry this is
			table.insert(questDisplay, quest)
			local curQuestIdx = #questDisplay --we'll need to modify current quest with it's children, store a reference.
			local questChildren = {}
			local questText = Infinity_FetchString(quest.text)
			for k2,objective in pairs(quest.objectives) do
				if(objective.stateType ~= const.ENTRY_TYPE_NONE) then
					objective.objective = 1
					objective.parent = curQuestIdx

					-- fix for missing data in bg1 and bg2
					if objective.text == nil or objective.text == questText then
						-- show timestamp only
						objective.text = nil
						objective.timeStamp = objective.entries[1].timeStamp
					elseif #objective.entries == 1 then
						-- if contains only a single entry, show timestamp + text
						objective.timeStamp = objective.entries[1].timeStamp
					else
						-- show text only, children entries will have timestamps
						objective.timeStamp = nil
					end

					if(objective.stateType ~= const.ENTRY_TYPE_INFO) then
						--info entries should not go into quests
						table.insert(questDisplay, objective)
						table.insert(questChildren, #questDisplay)
					end

					local curObjectiveIdx = #questDisplay
					local objectiveChildren = {}
					for k3,entry in pairs(objective.entries) do
						-- sometimes entry state doesn't match the objective state
						-- this causes the entry to appear in the wrong place
						entry.stateType = objective.stateType
						entry.entry = 1

						entry.parent = curObjectiveIdx
						table.insert(questDisplay, entry)
						table.insert(objectiveChildren, #questDisplay)
					end
					questDisplay[curObjectiveIdx].children = objectiveChildren
				end
			end
			questDisplay[curQuestIdx].children = questChildren
		end
	end

	-- add the user entries to the journal display
	for k,entry in pairs(userNotes) do
		entry.entry = 1
		table.insert(journalEntries,entry)
	end

	--add the loose entries (entries without quests) to the journal display
	for k,entry in pairs(looseEntries) do
		entry.entry = 1
		table.insert(journalEntries,entry)
	end


	table.sort(journalEntries, compareByRecvTime)

	for k,entry in pairs(journalEntries) do
		local title  = {}
		title.title = 1
		title.text = entry.timeStamp
		title.chapters = entry.chapters
		table.insert(journalDisplay,title)
		table.insert(journalDisplay, entry)
	end
end
function questContainsSearchString(row)
	if(journalSearchString == nil or journalSearchString == "") then return 1 end --no search string, do nothing
	local text = Infinity_FetchString(questDisplay[row].text)
	if(string.find(string.lower(text),string.lower(journalSearchString))) then return 1 end -- string contains search string.
	if(questDisplay[row].children == nil) then return nil end --no children, does not contain search string.
	for k,v in pairs(questDisplay[row].children) do
		--Infinity_Log(v)
		if(containsSearchString(v)) then return 1 end -- one of children contains search string
	end
	return nil --does not contain search string
end
function containsChapter(tab, chapter)
	if(not tab) then return nil end
	return tab[chapter]
end
function entryEnabled(row, alwaysExpanded)
	local rowTab =  questDisplay[row]
	if(rowTab == nil or rowTab.entry == nil or not containsChapter(rowTab.chapters,chapter)) then return nil end

	local expanded = alwaysExpanded or questDisplay[rowTab.parent].expanded
	if expanded and objectiveEnabled(rowTab.parent) then return 1 else return nil end
end
function getEntryText(row)
	local entry = questDisplay[row]
	local parent = questDisplay[entry.parent]
	if parent and parent.timeStamp then
		return entry.text
	else
		return entry.timeStamp .. "\n" .. entry.text
	end
end

function objectiveEnabled(row)
	local rowTab =  questDisplay[row]
	if(rowTab == nil or rowTab.objective == nil or not containsChapter(rowTab.chapters,chapter)) then return nil end

	if(questEnabled(rowTab.parent) and questDisplay[rowTab.parent].expanded) then return 1 else return nil end
end
function getObjectiveText(row, smallJournal)
	local rowTab =  questDisplay[row]
	if (rowTab == nil) then return nil end

	local text = rowTab.text
	local timestamp = rowTab.timeStamp

	if text == "" or text == nil then
		text = timestamp or t("NO_OBJECTIVE_NORMAL")
	elseif timestamp then
		text = timestamp .. "\n" .. text
	end

	--objectives shouldn't really display a completed state since they don't actually follow a progression.
	--if(getFinished(row)) then
	-- if smallJournal then
	--  text = "^M .. text .. " (Finished)^-"
	-- else
	--	text = "^0xFF666666" .. text .. " (Finished)^-"
	-- end
	--end

	return text
end

--Many thanks to 'lefreut'
function childrenContainsChapter(children)
	for k,v in pairs(children) do
		if containsChapter(questDisplay[v].chapters,chapter) then
			return true
		end
	end
	return nil
end

function questEnabled(row)
	--return (questDisplay[row] and questDisplay[row].quest and containsChapter(questDisplay[row].chapters,chapter) and (#questDisplay[row].children > 0))
	return (questDisplay[row] and questDisplay[row].quest and containsChapter(questDisplay[row].chapters,chapter) and childrenContainsChapter(questDisplay[row].children))
end

function getQuestText(row, smallJournal)
	local rowTab =  questDisplay[row]
	if (rowTab == nil) then return nil end
	local text = Infinity_FetchString(rowTab.text)

	if(getFinished(row)) then
		if smallJournal then
			text = "^5" .. text .. " (" .. t("OBJECTIVE_FINISHED_NORMAL") .. ")^-"
		else
			text = "^0xFF000000" .. text-- .. " (" .. t("OBJECTIVE_FINISHED_NORMAL") .. ")^-"
		end
	end

	return text
end
function getArrowFrame(row)
	if(questDisplay[row] == nil or (questDisplay[row].objective == nil and questDisplay[row].quest == nil)) then return "" end


	if(questDisplay[row].expanded) then
		return 0
	else
		return 1
	end
end
function getArrowEnabled(row)
	if(questDisplay[row].quest == nil and questDisplay[row].objective == nil) then return nil end
	if(questDisplay[row].objective and not objectiveEnabled(row)) then return nil end
	if(questDisplay[row].quest and not questEnabled(row)) then return nil end
	if(questDisplay[row].objective) then return nil end
	return 1
end

function getFinished(row)
	if(questDisplay[row].stateType == const.ENTRY_TYPE_COMPLETE) then return 1 else return nil end
end
function showObjectiveSeperator(row, alwaysExpanded)
	local tab = questDisplay[row]
	if(objectiveEnabled(row) or entryEnabled(row, alwaysExpanded)) then
		--seperator is enabled for objective or entry as long as the next thing is an objective.
		--search until we find something enabled or end of table.
		local idx = row + 1
		while(questDisplay[idx]) do
			if(objectiveEnabled(idx)) then
				return 1
			else
				if(questEnabled(idx) or entryEnabled(idx, alwaysExpanded)) then
					return nil
				end
			end
			idx = idx + 1
		end
	end
end


function getJournalTitleEnabled(row)
	return journalDisplay[row].title and containsChapter(journalDisplay[row].chapters,chapter) and journalContainsSearchString(row)
end
function getJournalTitleText(row)
	return journalDisplay[row].text
end
function getJournalEntryEnabled(row)
	return journalDisplay[row].entry and containsChapter(journalDisplay[row].chapters,chapter) and journalContainsSearchString(row)
end
function getJournalEntryText(row)
	local text = Infinity_FetchString(journalDisplay[row].text)
	if(text == nil or text == "") then
		text = journalDisplay[row].text
	end

	if(journalSearchString and journalSearchString ~= "") then
		--do the search string highlight
		text = highlightString(text, journalSearchString, "^0xFF0000FF")
	end

	return text
end
function getJournalDarken(row)
	local entry = journalDisplay[row]
	if(entry.title) then
		return (row == selectedJournal or row + 1 == selectedJournal)
	end
	if(entry.entry) then
		return (row == selectedJournal or row - 1 == selectedJournal)
	end
end

local function journalRowContainsString(row, search)
	local item = journalDisplay[row]
	local title = nil

	-- check if the corresponding row to this one contains the string.
	if item.title then
		title = journalDisplay[row + 1].text
	elseif item.entry then
		title = journalDisplay[row - 1].Text
	end

	for _, text in ipairs({ item.text, title }) do
		local str = Infinity_FetchString(text)

		-- no stringref, use the text
		if str == nil or str == "" then
			str = text
		end

		if str:lower():find(search) then
			return 1
		end
	end

	-- does not contain search string
	return nil
end

function journalContainsSearchString(row)
	-- no search string, do nothing
	if journalSearchString == nil or journalSearchString == "" then
		return 1
	end
	return journalRowContainsString(row, journalSearchString:lower())
end

function dragJournal()
	local sw, sh = Infinity_GetScreenSize()
	local x, y, w, h = Infinity_GetMenuArea('JOURNAL_SMALL')

	x = math.clamp(x + motionX, 0, sw - w - 80)
	y = math.clamp(y + motionY, 0, sh - h - 120)

	Infinity_SetOffset('JOURNAL_SMALL', x, y)
end

function journalEntryClickable(selectedJournal)
	local entry = journalDisplay[selectedJournal]
	if(entry) then return true end
end
function getJournalEntryRef(selectedJournal)
	local entry = journalDisplay[selectedJournal]
	if(not entry) then return end
	if(entry.title) then
		return journalDisplay[selectedJournal + 1].text
	else
		return entry.text
	end
end
function getJournalBackgroundFrame()
	if(journalMode == const.JOURNAL_MODE_QUESTS) then
		return 0
	else
		return 1
	end
end

journalMode = const.JOURNAL_MODE_QUESTS
journalSearchString = ""

function PauseJournal()
	if worldScreen:CheckIfPaused() then
		return
	end

	if e:GetActiveEngine() ~= worldScreen then
		return
	end

	worldScreen:TogglePauseGame(true)
	return true
end

function CloseAll(side)
	for _, quest in ipairs(questDisplay) do
		if quest.expanded == 1 then
			if side == 1 then
				if quest.stateType ~= const.ENTRY_TYPE_COMPLETE then
					quest.expanded = nil
				end
			elseif side == 2 then
				if quest.stateType == const.ENTRY_TYPE_COMPLETE then
					quest.expanded = nil
				end
			else -- nil, i.e. small journal
				quest.expanded = nil
			end
		end
	end
end

function hideFinished(row)
	return questDisplay[row].stateType ~= const.ENTRY_TYPE_COMPLETE
end

function hideUnfinished(row)
	return questDisplay[row].stateType == const.ENTRY_TYPE_COMPLETE
end

function myNotes(row)
	return journalRowContainsString(row, JFStrings.JF_Notes:lower())
end

function NotMyNotes(row)
	return not myNotes(row) and 1 or nil
end