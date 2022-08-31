-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local INFO_DND35e = { "name", "school", "level", "components", "castingtime", "range", "effect", "duration", "save", "sr", "description" };
local INFO_DND5e = { "name", "level", "school", "castingtime", "range", "components", "duration", "description" };
local INFO_SFRPG = { "name", "school", "level", "descriptors", "castingtime", "range", "area", "effect", "target", "duration", "save", "sr", "description" };

function onInit()
    if super and super.onInit then
        super.onInit();
    end

	local sRuleset = User.getRulesetName();
    local nodeSpell = window.getDatabaseNode();

	if sRuleset == "3.5E" then
		createTooltip(nodeSpell, INFO_DND35e);
	elseif sRuleset == "5E" then
		createTooltip(nodeSpell, INFO_DND5e);
	elseif sRuleset == "SFRPG" then
		createTooltip(nodeSpell, INFO_SFRPG);
	end
end

function createTooltip(nodeSpell, tInfo)
	local sText = "";
	for _,info in ipairs(tInfo) do
		sText = sText .. StringManager.capitalize(info) .. ": " .. DB.getValue(nodeSpell, info, "") .. "\n";
	end

	-- Cleanup
	sText = sText:gsub("<p>", "");
	sText = sText:gsub("</p>", "\n");
	sText = sText:gsub("</?b>", "");
	sText = sText:gsub("</?i>", "");
	sText = sText:gsub("</?u>", "");

	sText = sText:gsub("\n*$", "");
	
	self.setTooltipText(sText);
end
