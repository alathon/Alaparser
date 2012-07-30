mob/Login() {
	. = ..();
	src.Move(locate(/room/one));
}

client/Command(T) {
	var/ParserOutput/out = mainParser.process(src, T);
	if(!out.getSuccess()) {
		src << "Huh?";
	}
}

world/New() {
	var/mob/One = new(locate(/room/one));
	One.desc = "This is the REAL One";
	var/mob/SecondOne = new(locate(/room/one));
	SecondOne.desc = "This is the SECOND One";
	var/mob/Two = new(locate(/room/one));
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