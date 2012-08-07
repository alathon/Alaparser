Alaparser
=========

What is Alaparser
-----------------
Alaparser is a command-line parser for BYOND MUDs.
It allows you to define a 'format' for commands, that
it will then enforce for you. If a command is successfully
matched, it will then get sent the appropriate arguments, resolved
based on what the client typed in.

This means that things such as references to mobs can be resolved, so
the command doesn't have to care where the mob comes from.

Why use Alaparser over other alternatives on BYOND?
---------------------------------------------------
* The library is built to be extended, and the methods to be overrided.
* Despite that, it works out-of-the-box. Define commands, route client input to the parser,
and off you go.
* Often-sought customizations (Such as how to match a mob or obj, what happens on not matching,
etc) are easy to do and streamlined.
* There is no noticeable performance difference between most of the parsers on BYOND. Alaparser does
about 4000 - 6000 commands a second, on my 3Ghz CPU, with 20 commands defined.
* Ebonshadow's MUD parser and AbyssDragons parser both have bugs which aren't fixed, and won't be updated
to be fixed, as both of those users are long gone.

Example anatomy of a command
----------------------------
<pre>
Command
	look
		format = "~look; ?!at; ?~search(mob@loc)";

		command(client/C, at, mob/M) {
			if(!M) {
				if(at) {
					C `<<` "Look at what?";
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
</pre>

This command defines a standard 'look' command on a MUD, where you can either look
at the room (By typing just 'look'), or look at a mob in the room; and optionally, you
can type 'look at mob' instead of 'look mob'.

The format line is split into parts, each part separated by a semicolon. A part can be one
of several different types, where words that don't match a type are automatically considered
a literal (Such as look, and at); meaning that you need to type that word to match.

The partial(~) denotes a command-part that can be a partial match, so you can type 'l' instead
of 'look'. Or the partial name of a mob instead of the whole thing.

The optional(?) makes a command-part just that - Optional.

The force(!) forces a value that otherwise wouldn't get sent to command(), to do so. Literals are, by
default, never sent to command(). But in this case we force the match of 'at' to get sent, so we know
whether the player typed 'look at', which we want to handle as a special-case.

Documentation
-------------
Documentation is 'on-going'. There is a fairly comprehensive demo as part of the library, that showcases
how to do most regular things.