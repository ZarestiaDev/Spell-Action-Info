function onInit()
	registerOptions();
end

function registerOptions()
	OptionsManager.registerOption2("SAIO",true, "option_header_client", "option_label_SAIO", "option_entry_cycler", 
		{ labels = "option_val_components|option_val_range", values = "components|range", baselabel = "option_val_off", baseval = "off", default = "off" });
end
