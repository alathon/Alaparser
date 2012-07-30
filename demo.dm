client/Command(T) {
	var/ParserOutput/out = mainParser.process(src, T);
	if(!out.getSuccess()) {
		src << "Huh?";
	}
}

world/New() {
	__componentGenerator = new();
	generateComponents();
}

var/Parser/mainParser;

proc/generateComponents() {
	mainParser = new /Parser();
	for(var/p in typesof(/Command)-/Command) {
		var/Command/cmd = new p();
		if(!cmd.getAutoCreate() || !cmd.format) {
			del cmd;
		} else {
			mainParser.addCommand(cmd);
		}
	}
}

Option/range
	getListFromKey(client/C) {
		. = new /list();
		switch(_key) {
			if("clients") {
				for(var/client/cli) . += cli;
			}
		}
	}

Command
	testword
		format = "testword; word;";

		command(var/word) {
			world << "testword: [word]";
		}

	testany
		format = "testany; any;";

		command(var/any) {
			world << "testany: [any]";
		}

	testnum
		format = "testnum; num;";

		command(var/num) {
			world << "testnum: [num]";
		}

	testlit
		format = "testlit; yahoo;";

		command(var/a) {
			world << "testlit";
		}

	testmob
		command() { }
	testobj
		command() { }