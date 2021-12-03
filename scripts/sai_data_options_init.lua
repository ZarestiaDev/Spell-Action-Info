function onInit()
	registerOptions();
end

function registerOptions()
	OptionsManager.registerOption2("SAIC",true, "option_header_client", "option_label_SAIC", "option_entry_cycler", 
		{ labels = "option_val_on", values = "on", baselabel = "option_val_off", baseval = "off", default = "off" });
end