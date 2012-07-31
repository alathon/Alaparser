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
word you want to match. Each part can be prefixed by one of the prefix options (!, %, ~ and ?), and can
potentially have a suffix encased in () brackets.

The format can be simple, like in the following command:

Command
	who
		format = "~who";

		command(client/C) {
			C << "----------\n";
			for(var/client/other) {
				C << other.mob
			}
			C << "----------\n";
		}

Here, we specify that in order to call the who command, you must type in 'who'.
Anything not a special keyword is considered a 'text literal' by the Parser, which
means you have to type that word for it to match. In addition, because we specified
the ~ prefix option (Called the partial option), we could also type 'w', or 'wh'.

The command() proc is always passed the calling client as the first argument. Normally,
every part of a command is sent to the command() proc as an argument, but by default
literals (Such as the above) are not.

The format can also be more complex, like here:

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
of the command is separated by a ;. Again we use ~ to indicate that the client can type l, lo, loo or look
to match that word. The ? before search tells it that you can omit this second argument, if you so desire. This is why
the command() proc starts by checking whether you decided to give it a mob or not. Search is also prefixed by ~, meaning that
you can type in the partial name of a mob to match it.

'search' is a special match type, that requires you to tell it what to search for (mob in this case), and where to do so (loc),
separated by a @. So the above lets you either type look to look at a room, or type look and then something matching a mob in your
current location, to look at that thing. More on search under 'How does Search work'.

The demo provides uses of each special match type (num, any, word, search), and demonstrates all of the prefix symbols that allow you
to make things optional(?), allow partial matches (~), force a value to get sent to command(!) and force a case-sensitive match (%).

How does Search Work|
---------------------

Search is meant to identify a datum, of a specific type, found in a specific place. The format is search(type@place).

The place part is a keyword, which must be one of the potential values that is considered by /Option/postfix/range.getListFromKey(client).
This means that in order to add more 'place' values (Say you wanted a 'group' place, which would return the list of people in your group),
you must override getListFromKey() to take that into account. See the demo override in demo/rangeOption.dm for an example.

The type is any valid DM type-path, without the initial slash(/). So mob for /mob, mob/evil for /mob/evil, etc.

Based upon the list provided by getListFromKey(), the list first has any type not matching the type specified removed. Then each entry in that
list is attempted matched against a single word input from the client. This is done by retrieving a list of keywords that represent that entry,
by calling entry.getMatchKeywords(). For each of the keywords returned by that proc, a text match is attempted. The partial(~) and case-sensitive(%)
option prefixes are respected here; so ~search will allow you to match based on the partial keyword of a datum, while %search will require that you get
the case correct.

You may also provide more than one type, if you separate them with the pipe(|) symbol. Such as:

search(mob|obj|turf|area@world)

Things of note|
---------------
- The parser doesn't explicitly expect the first matcher component of a command to be a literal, but it probably should be. When deciding between commands that all match
the input, it will prioritize non-first literals, or commands that don't have a partial first literal (A literal with a ~). If no match can be found like that,
it will pick the shortest first-literal matched.

- Matching occurs in a greedy fashion. If an optional can be matched, it will. If it can't, it will simply be skipped.

- The 'any' matcher will swallow all subsequent input. Any matcher after an any makes no sense, and will cause the command to fail.

- By default, literals (/MatcherComponent/literal) will not send their matched value to command(). This is the normal behavior.
You can get around this with the force-value prefix (!), but you can also modify the list of ignored value matcher components, by
overriding Matcher.getIgnoredValueTypes(). The procedure will return a list with just the /MatcherComponent/literal type in it by
default.

- In general, proc names prefixed by a _ shouldn't be overridden / used by you, and are internal to the library.

Documentation TODO:

- How command options are parsed.
- How to add new option prefixes.
- How to add new matcher components.
- More examples.
*/