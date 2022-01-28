
function onPortraitsSidebarOpen()
	duiLargePortraits = duiSettings:get('largePortraits')

#if WITH_LEFT_SIDE_PORTRAITS then
	duiLeftSidePortraits = duiSettings:get('leftSidePortraits')
#end

	if worldScreen == e:GetActiveEngine() then
		if game:GetPartyAI() then
			aiButtonToggle = 1
		end
		Infinity_PushMenu('WORLD_LEVEL_UP_BUTTONS')
	end
end

function duiIsActiveSidebarBottom()
	local noJournal = showJournal ~= 1 or not duiLargeJournal
	return worldScreen == e:GetActiveEngine() and noJournal
end