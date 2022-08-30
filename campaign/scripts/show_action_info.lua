function onInit()
	setActionInfo();
end

function setActionInfo()
	local nodeSpell = window.getDatabaseNode();
	local sAction = DB.getValue(nodeSpell, "castingtime", ""):lower();

	if User.getRulesetName() == "5E" then
		sAction = setActionInfo5E(nodeSpell, sAction);
	else
		sAction = sAction:gsub("%s?action", "");
	end

	if not (sAction:match("minute") or sAction:match("hour")) then
		sAction = sAction:gsub("%d+%s", "");
	end

	sAction = StringManager.capitalizeAll(sAction);
	self.setValue(sAction);
end

function setActionInfo5E(nodeSpell, sAction)
	local sRitual = DB.getValue(nodeSpell, "ritual", 0);
	local sDuration = DB.getValue(nodeSpell, "duration", ""):lower();
	
	sAction = sAction:gsub("bonus action", "bonus");
	if sAction:match("reaction") then
		sAction = "reaction";
	end
	
	if sRitual == 1 and sDuration:match("concentration") then
		sAction = "(R, C) " .. sAction;
	elseif sRitual == 1 then
		sAction = "(R) " .. sAction;
	elseif sDuration:match("concentration") then
		sAction = "(C) " .. sAction;
	end

	return sAction;
end
