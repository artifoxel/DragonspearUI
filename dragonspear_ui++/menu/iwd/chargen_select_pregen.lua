createPartyOffset = 0
prerollCharacters = {}

function scrollPregens()
    if scrollDirection > 0 then
        scrollPregenUp()
    elseif scrollDirection < 0 then
        scrollPregenDown()
    end
end

function scrollPregenUp()
    if createPartyOffset > 0 then
        createPartyOffset = createPartyOffset - 1
    end
end

function scrollPregenDown()
    if createPartyOffset < (#prerollCharacters - 3) then
        createPartyOffset = createPartyOffset + 1
    end
end

function getPregenCharacterName(slotNumber)
    local ret = ""

    if slotNumber + createPartyOffset < #prerollCharacters+1 then
        ret = prerollCharacters[slotNumber+createPartyOffset]["name"]
    end

    return ret
end

function getPregenCharacterBiography(slotNumber)
    local ret = ""

    if slotNumber + createPartyOffset < #prerollCharacters+1 then
        ret = prerollCharacters[slotNumber+createPartyOffset]["description"]
    end

    return ret
end

function getPregenCharacterPortrait(slotNumber)
    local ret = "noportsm"

    if slotNumber + createPartyOffset < #prerollCharacters+1 then
        ret = prerollCharacters[slotNumber+createPartyOffset]["image"]
    end

    return ret
end

function getPregenCharacterFileName(slotNumber)
    local ret = ""

    if slotNumber + createPartyOffset < #prerollCharacters+1 then
        ret = prerollCharacters[slotNumber+createPartyOffset]["file"]
    end

    return ret
end

function playAsPreroll(slotNumber)
    local fileName = getPregenCharacterFileName(slotNumber)
    if fileName ~= "" then

    end
end

-- from header
lastRandomButtonSequence = -1
function getRandomButtonSequence(buttonImage)
	local ret = 0

	repeat
		if buttonImage == "GUIBUTWS" then
			ret = Infinity_RandomNumber(0, 3)
		elseif buttonImage == "GUIBUTWT" then
			ret = Infinity_RandomNumber(0, 3)
		elseif buttonImage == "GUIBUTNT" then
			ret = Infinity_RandomNumber(0, 3)
		elseif buttonImage == "GUIBUTNS" then
			ret = Infinity_RandomNumber(0, 3)
		elseif buttonImage == "GUIBUTMT" then
			ret = Infinity_RandomNumber(0, 3)
		elseif buttonImage == "GUIBTBUT" then
			ret = Infinity_RandomNumber(0, 4)
		end
		until(lastRandomButtonSequence ~= ret)

	lastRandomButtonSequence = ret

	return ret
end