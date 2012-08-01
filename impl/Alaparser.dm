var/Alaparser/alaparser;

Alaparser
	New(mainParser = TRUE, base_type = /Command) {
		src.generator = new();
		src.optionParser = new();
		src.commands = new();
		if(mainParser) spawn() _createMainParser(base_type);
	}

	proc
		parse(client/C, str, list/add) {
			var/list/total = new();
			for(var/a in commands + add) {
				total[a] = commands[a];
			}
			for(var/a in add) {
				total[a] = add[a];
			}
			return parser.process(C, str, total);
		}

		_createMainParser(base_type) {
			src.parser = new();
			for(var/p in typesof(base_type)) {
				var/Command/cmd = new p();
				if(!cmd._getAutoCreate() || !cmd.format) {
					del cmd;
				} else {
					commands += "[cmd]";
					commands["[cmd]"] = cmd;
				}
			}
		}

	var
		list/commands;
		Parser/parser;
		ComponentGenerator/generator
		OptionParser/optionParser