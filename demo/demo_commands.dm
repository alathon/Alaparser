Command
	say
		format = "say; any;"

		command(client/C, txt) {
			C.mob.loc << "[C] says, '[txt]'";
		}

	tattoo
		format = "tattoo; word; ?on; ?word"

		command(client/C, text, place) {
			C << "You tattoo [text] on [place]";
		}

	jump
		format = "jump; ?!num; ?times"

		command(client/C, num) {
			if(num) {
				C << "You jump [num] times!";
			} else {
				C << "You jump...";
			}
		}

	who
		format = "who";

		command(client/C) {
			C << "----------\n";
			for(var/client/other) {
				C << other.mob
			}
			C << "----------\n";
		}

	tell
		format = "tell; search(client@clients); any";

		command(client/C, client/target, txt) {
			if(target == C) {
				C << "Talking to yourself again?";
				return;
			}

			target << "[C] tells you, '[txt]'"
			C << "You tell [target], '[txt]'"
		}

	look
		format = "~look; ?!at; ?~search(mob@loc)";

		command(client/C, at, mob/M) {
			if(!M) {
				if(at) {
					C << "Look at what?";
					return;
				}

				if(istype(C.mob.loc, /room)) {
					var/room/R = C.mob.loc;
					R.describe(C);
				}
			} else {
				M.describe(C);
			}
		}