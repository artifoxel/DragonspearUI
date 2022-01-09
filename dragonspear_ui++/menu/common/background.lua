function getCampaignBackground()
	local campaign = startEngine:GetCampaign()
	return startCampaignData[campaign].background
end
function getBackgroundSize()
	local screenWidth, screenHeight = Infinity_GetScreenSize()
	Infinity_SetArea('RGDBACK1', nil, nil, screenWidth, screenHeight)
	Infinity_SetArea('RGDBACK2', nil, nil, screenWidth, screenHeight)
#if GAME_VERSION ~= 'iwd' then
	Infinity_SetArea('RGDBACK3', nil, nil, screenWidth, screenHeight)
#end
#if GAME_VERSION == 'eet' then
	Infinity_SetArea('RGDBACK4', nil, nil, screenWidth, screenHeight)
	Infinity_SetArea('RGDBACK5', nil, nil, screenWidth, screenHeight)
	Infinity_SetArea('RGDBACK6', nil, nil, screenWidth, screenHeight)
	Infinity_SetArea('RGDBACK7', nil, nil, screenWidth, screenHeight)
#end
end

function duiSetBackgroundSize(areas)
	local w, h = Infinity_GetScreenSize()
	for _, area in ipairs(areas) do
		Infinity_SetArea(area, nil, nil, w, h)
	end
end
