client/Command(T) {
	var/ParserOutput/out = mainParser.process(src, T);
	if(!out.getSuccess()) {
		src << "Huh?";
		src << "Best fit for command: [out.getCommand()]";
		src << "You matched [out.getTokenCount()] tokens";
	}
}

world/New() {
	var/mob/One = new();
	var/mob/SecondOne = new();
	var/mob/Two = new();
	One.name = "One";
	SecondOne.name = "One";
	Two.name = "Two";

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
	testforced
		format = "!testforce";

		command(var/forced) {
			world << "testforce: [forced]";
		}

	testoptional
		format = "testopt; ?yahoo; word;"

		command(var/yahoo, var/word) {
			world << "testopt: [word] (yahoo: [yahoo])";
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
		format = "testmob; search(mob@loc)";

		command(var/mob/M) {
			world << "You found [M]";
		}

	testclient
		format = "testclient; search(client@clients)";

		command(var/client/C) {
			world << "Client: [C]";
		}