
Command
	/* Movement */
	east
		format = "~east";

		command(client/C) {
			var/room/curLoc = C.mob.loc;
			if(curLoc.east != null) {
				C << "You move east.";
				C.mob.Move(curLoc.east);
			} else {
				C << "You can't go east here.";
			}
		}

	west
		format = "~west";

		command(client/C) {
			var/room/curLoc = C.mob.loc;
			if(curLoc.west != null) {
				C << "You move west.";
				C.mob.Move(curLoc.west);
			} else {
				C << "You can't go west here.";
			}
		}

	/* Communication */
	say
		format = "say; any;"

		command(client/C, txt) {
			C.mob.loc.contents - C.mob << "[C] says, '[txt]'";
			C << "You say, '[txt]'"
		}



	tell
		format = "tell; %search(client@clients); any";

		command(client/C, client/target, txt) {
			if(target == C) {
				C << "You tell yourself (Weirdo), '[txt]'";
				return;
			}

			target << "[C] tells you, '[txt]'"
			C << "You tell [target], '[txt]'"
		}

	/* Random stuff */
	tattoo
		level_req = 5
		format = "tattoo; word; ?on; ?word"

		command(client/C, text, place) {
			if(!place) {
				switch(rand(1,3)) {
					if(1) place = "arm";
					if(2) place = "leg";
					if(3) place = "spine";
				}
			}
			C << "You tattoo [text] on your [place]";
		}

	jump
		format = "jump; ?!num; ?times"

		command(client/C, num) {
			if(num) {
				C << "You jump [num] times!";
			} else {
				C << "You jump...";
			}
			C.level += max(1,num);
			C << "You level up [num] time[num > 1 ? "s":""] from jumping so much! You are now level [C.level]";
		}

	/* Information */
	who
		format = "who";

		command(client/C) {
			C << "----------\n";
			for(var/client/other) {
				C << other.mob
			}
			C << "----------\n";
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

	/* Other tests */
	literaltest
		format = "'num';";

		command(client/C) {
			C << "It worked! You can type num!";
		}