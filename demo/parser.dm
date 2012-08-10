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
	var/ParserOutput/out = alaparser.parse(src.mob, T, extras);
	if(!out.getMatchSuccess()) {
		src << "Huh?";
	}
}

Command
	var
		level_req = 1;

	preprocess(mob/user) {
		if(level_req > user.client.level) {
			user << "You aren't high enough level!";
			return FALSE;
		}
		return TRUE;
	}
