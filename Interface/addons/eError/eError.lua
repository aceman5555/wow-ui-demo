UIErrorsFrame:Hide()

SLASH_EERROR1 = "/error"

SlashCmdList["EERROR"] = function()
	if isShowing then
	    UIErrorsFrame:Hide()
	    isShowing = nil
	else
	    isShowing = 1
	    UIErrorsFrame:Show()
	end
end