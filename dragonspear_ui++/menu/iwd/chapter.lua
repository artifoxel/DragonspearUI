
chapterBackground = ""

text_CHAPTERSCROLL_title = ""
text_CHAPTERSCROLL = ""
text_CHAPTERSCROLL_timeStart = 0
text_CHAPTERSCROLL_auto = 1
function UpdateChapterScroll(top, height, contentHeight)
	if(text_CHAPTERSCROLL_auto == 0) then
		--defer to default scrolling
		return nil
	end
	local dT = Infinity_GetClockTicks() - text_CHAPTERSCROLL_timeStart
	local newTop = (dT * -0.006) + height
	if(newTop + contentHeight + height < height) then
		return top
	end
	return newTop
end
function setChapterBackground(id)
	chapterBackground = chapterBackgrounds[id]
end
function positionChapterText()
	if chapterBackground == chapterBackgrounds[0] then
		Infinity_SetArea('text_CHAPTERSCROLL_item', 440, 426, 554, 188)
	elseif chapterBackground == chapterBackgrounds[1] then
		Infinity_SetArea('text_CHAPTERSCROLL_item', 700, 218, 312, 322)
	elseif chapterBackground == chapterBackgrounds[2] then
		Infinity_SetArea('text_CHAPTERSCROLL_item', 36, 162, 344, 392)
	elseif chapterBackground == chapterBackgrounds[3] then
		Infinity_SetArea('text_CHAPTERSCROLL_item', 454, 158, 542, 174)
	elseif chapterBackground == chapterBackgrounds[4] then
		Infinity_SetArea('text_CHAPTERSCROLL_item', 436, 352, 568, 256)
	elseif chapterBackground == chapterBackgrounds[5] then
		Infinity_SetArea('text_CHAPTERSCROLL_item', 518, 358, 486, 238)
	elseif chapterBackground == chapterBackgrounds[6] then
		Infinity_SetArea('text_CHAPTERSCROLL_item', 646, 184, 352, 398)
	elseif chapterBackground == chapterBackgrounds[7] then
		Infinity_SetArea('text_CHAPTERSCROLL_item', 122, 480, 802, 138)
	end
end
function getChapterText()
	positionChapterText()
	return text_CHAPTERSCROLL_title
end