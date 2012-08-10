/*

Redefine getListFromKey() to get clients from the clients list,
and also define a 'world' search list, that includes all mobs in the world.
We also provide 'room' to be the same thing as 'loc'.

*/
Option/postfix/range
	getListFromKey(mob/user) {
		. = new /list();
		switch(_key) {
			if("clients") {
				for(var/client/cli in clients) . += cli;
			}
			if("loc","room") {
				for(var/atom/A in user.loc) . += A;
			}
			if("world") {
				for(var/mob/M in world) . += M;
			}
		}
	}
