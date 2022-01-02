chargen = {

	races = {},
	kits = {},

}
function chargenAcceptOrExport()
	if createCharScreen:GetEngineState() == 4 then
		return t("EXPORT_BUTTON")
	else
		return t("ACCEPT_BUTTON")

	end
end

#if GAME_VERSION == 'iwd' then
function isChargenBackButtonClickable()
	return createCharScreen:GetCurrentStep() > 0 and createCharScreen:IsMainBackButtonClickable()
end
#end