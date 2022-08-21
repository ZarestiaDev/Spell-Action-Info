function onInit()
	OptionsManager.registerCallback("SAIC", StateChanged);
	StateChanged();
end

function onClose()
	OptionsManager.unregisterCallback("SAIC", StateChanged);
end

function StateChanged()
	if OptionsManager.isOption("SAIC", "on") then
		setVisible(true);
		if LibraryData5E then
			setAnchoredWidth(50);
		else
			setAnchoredWidth(75);
		end
		setComponentsText();
	else
		setVisible(false);
	end
end

function setComponentsText()
	local sComponents = DB.getValue(window.getDatabaseNode(), "components", "");

	-- Exception for e.g. Tome of Battle prerequisites, set all components with digits and no gp to empty
	if sComponents:match("%d") and not sComponents:match("gp") then
		sComponents = "";
	end
	
	-- Getting rid of spaces because of width
	sComponents = sComponents:gsub("%s", "");

	-- Capturing and appending the gold cost with an $ because of width reasons
	if sComponents:match("%d+gp") then
		sComponents = sComponents .. ",$";
	end

	-- Getting rid of paranthesis and text inbewteen for 5e
	sComponents = sComponents:gsub("%b()", "");

	setValue(sComponents);
end