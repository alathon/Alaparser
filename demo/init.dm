/*

A clients list to store a global list of clients.

*/
var/list/clients = new();

mob/Login() {
	. = ..();
	src.Move(locate(/room/one));
	if(client) {
		clients += src.client;
	}
}

mob/Logout() {
	if(client) clients -= src.client;
	. = ..();
}

client/var/level = 1;

/*

Lets create 3 mobs (two with identical names),
and initialize the Alaparser object.

*/
world/New() {
	var/mob/One = new(locate(/room/one));
	One.desc = "This is the REAL One";
	var/mob/SecondOne = new(locate(/room/one));
	SecondOne.desc = "This is the SECOND One";
	var/mob/Two = new(locate(/room/two));
	One.name = "One";
	SecondOne.name = "One";
	Two.name = "Two";
}