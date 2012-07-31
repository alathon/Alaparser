mob
	proc
		describe(client/C) {
			C << "You look at [src.name]:";
			C << src.desc;
		}

room
	Entered(atom/A) {
		if(istype(A, /mob)) {
			var/mob/M = A;
			src.contents - M << "[M] enters the room.";
			M << "You enter [src.name]";
			if(M.client) M.client.Command("look");
		}
	}

	New() {
		if(east) east = locate(east);
		if(west) west = locate(west);
	}

	parent_type = /area;
	var
		room/east;
		room/west;

	proc
		describe(client/C) {
			var/desc;
			var/exits;
			exits += "[istype(east, /room)?"East":""] "
			exits += "[istype(west, /room)?"West":""]";
			desc += "---\n[src.desc]\n---";
			desc += "Exits: [exits]\n";
			for(var/atom/A in src) {
				desc += "[A]\n";
			}
			C << desc;
		}

	one
		east = /room/two;
		desc = "Room One";

	two
		west = /room/one;
		desc = "Room Two";