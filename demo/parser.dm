/*

Push all client input over to the parser for processing,
and let the user know if what they typed didn't make any sense.

*/

client/Command(T) {
	var/list/extras;
	if(istype(mob.loc, /room)) {
		var/room/R = mob.loc;
		extras = R.getRoomCommands();
	}
	var/ParserOutput/out = alaparser.parse(src, T, extras);
	if(!out.getMatchSuccess()) {
		src << "Huh?";
	}
}

Command
	var
		level_req = 1;

	preprocess(client/C) {
		if(level_req > C.level) {
			C << "You aren't high enough level!";
			return FALSE;
		}
		return TRUE;
	}