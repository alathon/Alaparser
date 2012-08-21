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

		command(mob/user) {
			user << "You clap your hands!";
			user.loc.contents - user << "[user] claps their hands!";
		}

	zap
		format = "zap; ~search(mob@loc)";

		command(mob/user, mob/M) {
			user << "You zap [M]";
			M << "[user] zaps you";
			user.loc.contents - user - M << "[user] zaps [M]";
		}
