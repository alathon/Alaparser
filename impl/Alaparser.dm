var/Alaparser/alaparser;

Alaparser
	New(mainParser = TRUE, base_type = /Command) {
		src.generator = new();
		src.optionParser = new();
		if(mainParser) spawn() _createMainParser(base_type);
	}

	proc
		_createMainParser(base_type) {
			src.parser = new();
			for(var/p in typesof(base_type)) {
				var/Command/cmd = new p();
				if(!cmd._getAutoCreate() || !cmd.format) {
					del cmd;
				} else {
					src.parser.addCommand(cmd);
				}
			}
		}

	var
		Parser/parser;
		ComponentGenerator/generator
		OptionParser/optionParser