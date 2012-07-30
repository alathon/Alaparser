client/Command(T) {
	var/ParserOutput/out = mainParser.process(src, T);
	if(!out.getSuccess()) {
		src << "Huh?";
		src << "Best fit for command: [out.getCommand()]";
		src << "You matched [out.getTokenCount()] tokens";
	}
}

world/New() {
	sleep(20);
	alaparser = new();
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

Command
	testoptional
		format = "testopt; ?yahoo; word;"

		command(var/word) {
			world << "testopt: [word]";
		}

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