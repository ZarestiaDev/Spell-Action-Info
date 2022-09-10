function onInit()
	OptionsManager.registerCallback("SAIO", StateChanged);
	
	StateChanged();

	DB.addHandler(DB.getPath(window.getDatabaseNode().getChild("....."), "cl"), "onUpdate", StateChanged);
end

function onClose()
	OptionsManager.unregisterCallback("SAIO", StateChanged);

	DB.addHandler(DB.getPath(window.getDatabaseNode().getChild("....."), "cl"), "onUpdate", StateChanged);
end

function StateChanged()
	if OptionsManager.isOption("SAIO", "off") then
		self.setVisible(false);
	else
		if OptionsSAI.RULESET == "5E" or OptionsSAI.RULESET == "SFRPG" or OptionsSAI.RULESET == "2E" then
			self.setAnchoredWidth(50);
		else
			self.setAnchoredWidth(65);
		end
		self.setVisible(true);
	end

	local sAdditionalInfo = "";

	if OptionsManager.isOption("SAIO", "components") then
		sAdditionalInfo = setComponentsInfo();
	elseif OptionsManager.isOption("SAIO", "range") then
		sAdditionalInfo = setRangeInfo();
	elseif OptionsManager.isOption("SAIO", "both") then
		sAdditionalInfo = setBothInfo();
	end

	self.setValue(sAdditionalInfo);
end

function setComponentsInfo()
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
	sComponents = sComponents:gsub("%s?%b()", "");

	return sComponents;
end

function setRangeInfo()
	local nodeSpell = window.getDatabaseNode();
	local sRange = DB.getValue(nodeSpell, "range", ""):lower();

	if OptionsSAI.RULESET == "5E" then
		sRange = setRangeInfo5E(sRange);
	else
		sRange = setRangeInfo35E(nodeSpell, sRange);
	end

	sRange = sRange:gsub("feet", "ft");
	sRange = sRange:gsub("%.", "");
	sRange = StringManager.capitalize(sRange);

	return sRange;
end

function setRangeInfo5E(sRange)
	sRange = sRange:gsub("%s?%b()", "");

	return sRange;
end

function setRangeInfo35E(nodeSpell, sRange)
	local nodeSpellClass = nodeSpell.getChild(".....");
	local nCL = DB.getValue(nodeSpellClass, "cl", 0);
	local nRange;

	if sRange:match("close") then
		nCL = math.floor(nCL/2);
		nRange = 25 + 5*nCL;
		sRange = nRange .. " ft";
	elseif sRange:match("medium") then
		nRange = 100 + 10*nCL;
		sRange = nRange .. " ft";
	elseif sRange:match("long") then
		nRange = 400 + 40*nCL;
		sRange = nRange .. " ft";
	elseif sRange:match("touch") then
		sRange = "touch";
	elseif sRange:match("personal") then
		sRange = "personal";
	end

	return sRange;
end

function setBothInfo()
	if OptionsSAI.RULESET == "5E" or OptionsSAI.RULESET == "2E" then
		self.setAnchoredWidth(100);
	else
		self.setAnchoredWidth(125);
	end

	local sRange = setRangeInfo();
	local sComponents = setComponentsInfo();
	local sSpacer = " | ";

	if (sRange == "" or sComponents == "") then
		sSpacer = "";
	end

	local sBoth = sComponents .. sSpacer .. sRange;

	return sBoth;
end
