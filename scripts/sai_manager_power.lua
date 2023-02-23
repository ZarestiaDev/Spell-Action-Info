-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	setSAIPowerHandlers(OptionsSAI.RULESET);
end

function setSAIPowerHandlers(sRuleset)
	local tPowerHandlers = {};

	if sRuleset == "3.5E" or sRuleset == "PFRPG" then
		tPowerHandlers = {
			fnGetActorNode = PowerManager35E.getPowerActorNode,
			fnUsePower = PowerManager35E.usePower,
			fnParse = PowerManager35E.parsePower,
			fnUpdateDisplay = PowerManagerSAI.updatePowerDisplay35E,
		};
	elseif sRuleset == "SFRPG" then
		tPowerHandlers = {
			fnGetActorNode = PowerManagerSFRPG.getPowerActorNode,
			fnUsePower = PowerManagerSFRPG.usePower,
			fnParse = PowerManagerSFRPG.parsePower,
			fnUpdateDisplay = PowerManagerSAI.updatePowerDisplaySFRPG,
		};
	elseif sRuleset == "5E" then
		tPowerHandlers = {
			fnGetActorNode = PowerManager5E.getPowerActorNode,
			fnParse = PowerManager5E.parsePower,
			fnUpdateDisplay = PowerManagerSAI.updatePowerDisplay5E,
		};
	end
	PowerManagerCore.registerPowerHandlers(tPowerHandlers);
end

function updatePowerDisplay35E(w)
	if w.minisheet then
		return;
	end
	if not w.header or not w.header.subwindow then
		return;
	end
	if not w.header.subwindow.shortdescription or not w.header.subwindow.actionsmini then
		return;
	end

	local nodeActor = PowerManagerCore.getPowerActorNode(w.getDatabaseNode());
	if ActorManager.isPC(nodeActor) then
		sDisplayMode = DB.getValue(nodeActor, "spelldisplaymode", "");
	else
		sDisplayMode = "action";
	end

	if sDisplayMode == "action" then
		w.header.subwindow.shortdescription.setVisible(false);
		w.header.subwindow.actionsmini.setVisible(true);
		w.header.subwindow.actioninfo.setVisible(true);
		if not OptionsManager.isOption("SAIO", "off") then
			w.header.subwindow.additionalinfo.setVisible(true);
		end
	else
		w.header.subwindow.shortdescription.setVisible(true);
		w.header.subwindow.actionsmini.setVisible(false);
		w.header.subwindow.actioninfo.setVisible(false);
		w.header.subwindow.additionalinfo.setVisible(false);
	end
end

function updatePowerDisplaySFRPG(w)
	if w.minisheet then
		return;
	end
	if not w.header or not w.header.subwindow then
		return;
	end
	if not w.header.subwindow.shortdescription or not w.header.subwindow.actionsmini then
		return;
	end

	local nodeActor = PowerManagerCore.getPowerActorNode(w.getDatabaseNode());
	if ActorManager.isPC(nodeActor) then
		if SpellManager.isAbilityPower(w.getDatabaseNode()) then
			sDisplayMode = DB.getValue(nodeActor, "abilitydisplaymode", "");
		else
			sDisplayMode = DB.getValue(nodeActor, "spelldisplaymode", "");
		end
	else
		sDisplayMode = "action";
	end

	if sDisplayMode == "action" then
		w.header.subwindow.shortdescription.setVisible(false);
		w.header.subwindow.actionsmini.setVisible(true);
		w.header.subwindow.actioninfo.setVisible(true);
		if not OptionsManager.isOption("SAIO", "off") then
			w.header.subwindow.additionalinfo.setVisible(true);
		end
	else
		w.header.subwindow.shortdescription.setVisible(true);
		w.header.subwindow.actionsmini.setVisible(false);
		w.header.subwindow.actioninfo.setVisible(false);
		w.header.subwindow.additionalinfo.setVisible(false);
	end
end

function updatePowerDisplay5E(w)
	if w.minisheet then
		return;
	end
	if not w.header or not w.header.subwindow then
		return;
	end
	if not w.header.subwindow.group or not w.header.subwindow.shortdescription or not w.header.subwindow.actionsmini then
		return;
	end

	local nodeActor = PowerManagerCore.getPowerActorNode(w.getDatabaseNode());
	local sDisplayMode = DB.getValue(nodeActor, "powerdisplaymode", "");
	if sDisplayMode == "summary" then
		w.header.subwindow.group.setVisible(false);
		w.header.subwindow.shortdescription.setVisible(true);
		w.header.subwindow.actionsmini.setVisible(false);
		w.header.subwindow.actioninfo.setVisible(false);
		w.header.subwindow.additionalinfo.setVisible(false);
	elseif sDisplayMode == "action" then
		w.header.subwindow.group.setVisible(false);
		w.header.subwindow.shortdescription.setVisible(false);
		w.header.subwindow.actionsmini.setVisible(true);
		w.header.subwindow.actioninfo.setVisible(true);
		if not OptionsManager.isOption("SAIO", "off") then
			w.header.subwindow.additionalinfo.setVisible(true);
		end
	else
		w.header.subwindow.group.setVisible(true);
		w.header.subwindow.shortdescription.setVisible(false);
		w.header.subwindow.actionsmini.setVisible(false);
		w.header.subwindow.actioninfo.setVisible(false);
		w.header.subwindow.additionalinfo.setVisible(false);
	end
end
