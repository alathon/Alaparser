Command
	look
		format = "look; ?search(mob@loc)";

		command(client/C, mob/M) {
			if(!M) {
				if(istype(C.mob.loc, /room)) {
					var/room/R = C.mob.loc;
					R.describe(C);
				}
			} else {
				M.describe(C);
			}
		}