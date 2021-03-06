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
	if minisheet then
		return;
	end
	
	sDisplayMode = DB.getValue(getDatabaseNode(), ".......spelldisplaymode", "");

	if sDisplayMode == "action" then
		header.subwindow.shortdescription.setVisible(false);
		header.subwindow.actionsmini.setVisible(true);
		-- Zarestia adding display change, casting time & components shown in action display
		header.subwindow.action_text_label.setVisible(true);
		if OptionsManager.isOption("SAIC", "on") then
			header.subwindow.components_text_label.setVisible(true);
		end
	else
		header.subwindow.shortdescription.setVisible(true);
		header.subwindow.actionsmini.setVisible(false);
		-- Zarestia adding display change, casting time & components not shown in summary display
		header.subwindow.action_text_label.setVisible(false);
		header.subwindow.components_text_label.setVisible(false);
	end
end
