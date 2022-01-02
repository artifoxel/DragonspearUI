list_GUICG_20_2_idx = 0
function NextOrDone()
	if createCharScreen:GetImportState() == 1 then
		return t("NEXT_BUTTON")
	else
		return t("DONE_BUTTON")
	end
end

#if GAME_VERSION == 'iwd' then
function getPregeneratedCharacters()
	prerollCharacters = prerollCharacters or {}
	createCharScreen:GetImportableCharacters()

	local ret = {}
	for i = 1, #prerollCharacters do
		local c = prerollCharacters[i]
		table.insert(ret, {
			name = c.name,
			portrait = c.image,
			desc = c.description,
			file = c.file,
		})
	end

	return ret
end
#end