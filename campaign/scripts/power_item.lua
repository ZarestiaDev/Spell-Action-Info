-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
    if super and super.onInit then
        super.onInit();
    end

    --Check to see if we should automatically parse attack description
    local nodeAttack = getDatabaseNode();
    local nParse = DB.getValue(nodeAttack, "parse", 0);
    if nParse ~= 0 then
        DB.setValue(nodeAttack, "parse", "number", 0);
        PowerManager.parsePCPower(nodeAttack);
    end
    
    onDisplayChanged();
    windowlist.onChildWindowAdded(self);
end

function onDisplayChanged()
    if super and super.onDisplayChanged then
        super.onDisplayChanged();
    end

    sDisplayMode = DB.getValue(getDatabaseNode(), "...powerdisplaymode", "");
    if sDisplayMode == "summary" then
        header.subwindow.action_info.setVisible(false);
        header.subwindow.additional_info.setVisible(false);
    elseif sDisplayMode == "action" then
        header.subwindow.action_info.setVisible(true);
        if not OptionsManager.isOption("SAIO", "off") then
            header.subwindow.additional_info.setVisible(true);
        end
    else
        header.subwindow.action_info.setVisible(false);
        header.subwindow.additional_info.setVisible(false);
    end
end