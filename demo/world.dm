mob
	proc
		describe(client/C) {
			C << "You look at [src.name]:";
			C << src.desc;
		}

room
	parent_type = /area;

	proc
		describe(client/C) {
			C << "---\n[desc]\n---";
			for(var/atom/A in src) {
				C << A;
			}
		}

	one
		desc = "Room One";

	two
		desc = "Room Two";