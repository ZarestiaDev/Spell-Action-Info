local tRulesetExtendedWidth = {
	["5E"] = 100,
	["2E"] = 100,
	["SFRPG"] = 125,
	["3.5E"] = 125,
	["PFRPG"] = 125,
};

function onInit()
	OptionsManager.registerCallback("SAIO", StateChanged);
	StateChanged();

	DB.addHandler(DB.getPath(DB.getChild(window.getDatabaseNode(), "....."), "cl"), "onUpdate", StateChanged);
end

function onClose()
	OptionsManager.unregisterCallback("SAIO", StateChanged);

	DB.addHandler(DB.getPath(DB.getChild(window.getDatabaseNode(), "....."), "cl"), "onUpdate", StateChanged);
end

function StateChanged()
	if OptionsManager.isOption("SAIO", "off") then
		self.setVisible(false);
		return;
	end
	self.setVisible(true);

	if OptionsSAI.RULESET == "3.5E" or OptionsSAI.RULESET == "PFRPG" then
		self.setAnchoredWidth(65);
	else
		self.setAnchoredWidth(50);
	end

	local sAdditionalInfo = "";
	local nodeSpell = window.getDatabaseNode();

	if OptionsManager.isOption("SAIO", "components") then
		sAdditionalInfo = setComponentsInfo(nodeSpell);
	elseif OptionsManager.isOption("SAIO", "range") then
		sAdditionalInfo = setRangeInfo(nodeSpell);
	elseif OptionsManager.isOption("SAIO", "both") then
		sAdditionalInfo = setBothInfo(nodeSpell);
		self.setAnchoredWidth(tRulesetExtendedWidth[OptionsSAI.RULESET]);
	end

	self.setValue(sAdditionalInfo);
end

function setComponentsInfo(nodeSpell)
	local sComponents = DB.getValue(nodeSpell, "components", "");
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

function setRangeInfo(nodeSpell)
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
	local nCL = DB.getValue(DB.getChild(nodeSpell, "....."), "cl", 0);
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

function setBothInfo(nodeSpell)
	local sComponents = setComponentsInfo(nodeSpell);
	local sRange = setRangeInfo(nodeSpell);
	local sSpacer = " | ";

	if (sRange == "" or sComponents == "") then
		sSpacer = "";
	end

	local sBoth = sComponents .. sSpacer .. sRange;

	return sBoth;
end
