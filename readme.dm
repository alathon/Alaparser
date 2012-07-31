/*

Alaparser by Martin Gielsgaard Grunbaum, 2012

Go ahead and use any of this code however you see fit.
A thanks or mention in your project would be nice, but is not required.

*/

/*

What is Alaparser?|
-------------------

Alaparser is a command parser, primarily aimed towards text-based games. It allows you to define
commands that players can run, and a structure for how correct input to a command should look.
This takes care of things like where to look for mobs, optional arguments, looking
for the 2nd thing by a certain name, and so on. These things are normally handled by commands themselves,
which leads to a huge number of repeat-code, the potential for errors, and different commands handling the
same thing in different ways. Bad!

What is a parser in this case?|
-------------------------

A Parser in this library is a datum that can receive input from a client, and will look for viable commands that match
the input. If it finds one, it will execute the command. Adding commands to a parser is much the same as adding verbs to
a mob, in that if you don't add a command to a parser, it won't be able to run that command. You can also have any number
of parsers, and you can attach them to players, or have them be globally accessible, or what have you.

The demo provided has a single global parser with all commands available created automatically. This is one way of doing
things.

How do I set up the library to work?|
-------------------------------------

You must send input to a parser. This requires three things:

1) You've created one or more Parser objects.
2) You've added one or more Command objects to that/those parsers.
3) You've captured player input somewhere, that you can send to the Parser.process(client, text) proc.

In the demo, the last part is done in init.dm under client/Command(), while a Parser and all available
commands are created during world/New().

Once this is done, you're good to go, assuming you've defined some commands.

So how do you define commands?|
-------------------------------

Commands are made up of two parts:
	- The 'format', which tells the library how you want the command structure to look.
	- The command() proc, called when a command is successfully matched.

The format text string is made up of parts. Each part is separated by a ; and represents usually a single
word you want to match.

The format can be simple, like in the following command:

Command
	who
		format = "who";

		command(client/C) {
			C << "----------\n";
			for(var/client/other) {
				C << other.mob
			}
			C << "----------\n";
		}

Here, we specify that in order to call the who command, you must type in 'who'.
Anything not a special keyword is considered a 'text literal' by the Parser, which
means you have to type that word for it to match. The command() proc is always passed
the calling client as the first argument.

Or it can be more complex, like here:

Command
	look
		format = "~look; ?~search(mob@loc)";

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

The above supports a relatively standard 'look' command from a MUD. Remember that each 'part'
of the command is separated by a ;. The squiggly ~ before look tells the Parser that you can type l, lo, loo or look
to match that word. The ? before search tells it that you can omit this second argument, if you so desire. This is why
the command() proc starts by checking whether you decided to give it a mob or not.

'search' is a special match type, that requires you to tell it what to search for (mob in this case), and where to do so (loc),
separated by a @. So the above lets you either type look to look at a room, or type look and then something matching a mob in your
current location, to look at that thing. More on search under 'How does Search work'.

The demo provides uses of each special match type (num, any, word, search), and demonstrates all of the prefix symbols that allow you
to make things optional(?), allow partial matches (~), force a literal to get sent to command(!) and force a case-sensitive match (%).

How does Search Work|
---------------------

The 'search' match type is /MatcherComponent/search, and utilizes a special option called /Option/postfix/range, which is what you can see
inside the () braces, telling it where to look and what to look for. In order to add new places to look besides the two pre-defined 'clients' and 'loc',
you must override Option/postfix/range.getListFromKey(client/C), to return the appropriate list based on the _key value of the option. See the existing
implementation
Things of note|
---------------

- If you want to change how the search match type matches a datum, you must override datum.getMatchKeywords(), which should return a /list
of single-word keywords that identify the datum. By default, atoms return a list with their name in it, and clients a list with their key.
You might want to f.ex do this, if you want to match mobs by one of many keywords.

- The parser doesn't explicitly expect the first part of a command to be a literal, but it probably should be. When deciding between

Procedures you can override|
----------------------------
Matcher.getIgnoredValueTypes():

	This proc should return a /list of type-paths of MatcherComponent datums, which by default
	will not add their matched value to what is sent to Command.command(). By default, literals
	are returned from this proc.

Option/postfix/range.getListFromKey(client/C):

	This proc controls which 'lists' you can search for datums in, through the search match type.
	There are two pre-defined lists, namely 'clients' and 'loc'. You can see how they are used in
	the demo commands, or check out the original definition of getListFromKey() in options/Option.dm.


Documentation TODO:

- How command options are parsed.
- How to add new option prefixes.
- How to add new matcher components.
*/