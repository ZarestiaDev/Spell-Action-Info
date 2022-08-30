RULESET = "";

function onInit()
	OptionsManager.registerCallback("SAIO", StateChanged);
	
	RULESET = User.getRulesetName();
	StateChanged();

	local nodeSpellClass = window.getDatabaseNode().getChild(".....");
	DB.addHandler(DB.getPath(nodeSpellClass, "cl"), "onUpdate", StateChanged);
end

function onClose()
	OptionsManager.unregisterCallback("SAIO", StateChanged);

	local nodeSpellClass = window.getDatabaseNode().getChild(".....");
	DB.addHandler(DB.getPath(nodeSpellClass, "cl"), "onUpdate", StateChanged);
end

function StateChanged()
	if OptionsManager.isOption("SAIO", "off") then
		self.setVisible(false);
	else
		if RULESET == "5E" then
			setAnchoredWidth(50);
		else
			setAnchoredWidth(75);
		end
		self.setVisible(true);
	end

	if OptionsManager.isOption("SAIO", "components") then
		setComponentsInfo();
	elseif OptionsManager.isOption("SAIO", "range") then
		setRangeInfo();
	end
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

	self.setValue(sComponents);
end

function setRangeInfo()
	local nodeSpell = window.getDatabaseNode();
	local sRange = DB.getValue(nodeSpell, "range", ""):lower();

	if RULESET == "5E" then
		sRange = sRange:gsub("%s?%b()", "");
	else
		sRange = setRangeInfo35E(nodeSpell, sRange);
	end

	sRange = sRange:gsub("feet", "ft");
	sRange = sRange:gsub("%.", "");

	sRange = StringManager.capitalize(sRange);

	self.setValue(sRange);
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
