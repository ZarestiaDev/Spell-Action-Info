-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
    if super and super.onInit then
        super.onInit();
    end
	
	onDisplayChanged();
end

function onDisplayChanged()
	if super and super.onDisplayChanged then
        super.onDisplayChanged();
    end
	
	sDisplayMode = DB.getValue(getDatabaseNode(), ".......spelldisplaymode", "");
	if sDisplayMode == "action" then
		-- Zarestia adding display change, casting time & components shown in action display
		header.subwindow.action_info.setVisible(true);
		if not OptionsManager.isOption("SAIO", "off") then
			header.subwindow.additional_info.setVisible(true);
		end
	else
		-- Zarestia adding display change, casting time & components not shown in summary display
		header.subwindow.action_info.setVisible(false);
		header.subwindow.additional_info.setVisible(false);
	end
end
