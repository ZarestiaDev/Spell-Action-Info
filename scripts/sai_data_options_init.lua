RULESET = "";

function onInit()
	RULESET = User.getRulesetName();
	if RULESET == "SFRPG" then
		registerOptionsSFRPG();
	else
		registerOptionsDND();
	end
end

function registerOptionsDND()
	OptionsManager.registerOption2("SAIO",true, "option_header_SAIO", "option_label_SAIO", "option_entry_cycler", 
		{ labels = "option_val_components|option_val_range|option_val_both|option_val_school", values = "components|range|both|school", baselabel = "option_val_off", baseval = "off", default = "off" });
end

function registerOptionsSFRPG()
	OptionsManager.registerOption2("SAIO",true, "option_header_SAIO", "option_label_SAIO", "option_entry_cycler", 
		{ labels = "option_val_range", values = "range", baselabel = "option_val_off", baseval = "off", default = "off" });
end
