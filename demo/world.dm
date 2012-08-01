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
		while(alaparser == null || alaparser.generator == null) {
			sleep(5);
		}
		if(commands && length(commands)) {
			var/list/paths = commands.Copy();
			commands.Cut();
			for(var/path in paths) {
				commands[path] = new path();
			}
		}
	}

	parent_type = /area;
	var
		list/commands = new();
		room/east;
		room/west;

	proc
		getRoomCommands() {
			return commands;
		}

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
		commands = list(/Command/rooms/clap);
		east = /room/two;
		desc = "Room One";

	two
		commands = list(/Command/rooms/zap);
		west = /room/one;
		desc = "Room Two";

Command/rooms
	_auto_create = FALSE;
	clap
		format = "clap";

		command(client/C) {
			C << "You clap your hands!";
			C.mob.loc.contents - C.mob << "[C] claps their hands!";
		}

	zap
		format = "zap; ~search(mob@loc)";

		command(client/C, mob/M) {
			C << "You zap [M]";
			M << "[C] zaps you";
			C.mob.loc.contents - C.mob - M << "[C] zaps [M]";
		}