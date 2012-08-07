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
the input. If it finds one, it will execute the command. The parser accepts a list of commands to try matching, allowing you
to add commands to the list supplied depending on the situation. This means you can f.ex have objs or rooms supply extra commands
that are only available around them. The general usecase is to utilize the global parser 'alaparser', which you should initialize
on world/New() or somewhere else appropriate, by calling alaparser = new().

The demo provided demonstrates how to f.ex get rooms to add available commands when you're in them. Try 'clap' in room one, and
'zap' a mob in room two.

How do I set up the library to work?|
-------------------------------------

You must send input to a Parser. The easiest way to 'just get going' is
to use the standard 'alaparser' object, which the library defines and creates
for you. You will need to send client input to alaparser.parse(client, text).

Any text sent by a client which is *not* caught by a verb, will be sent to client/Command().
As such, you can capture client input in client/Command() and send it to the parser. See demo/parser.dm
for clarification.

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

The 'search' match type is /MatcherComponent/search, and utilizes a special option called /Option/postfix/range, which is what you can see
inside the () braces, telling it where to look and what to look for. In order to add new places to look besides the two pre-defined 'clients' and 'loc',
you must override Option/postfix/range.getListFromKey(client/C), to return the appropriate list based on the _key value of the option. See the existing
implementation for an example of how to do that.

The basic format of the range option after the search keyword is (type@key) where key must be matched in getListFromKey(), and type must be a valid type-path,
without the initial /. If you only wanted to search for /mob/evil f.ex, you could use mob/evil as the type.


Things of note|
---------------
- If you need to define a literal using one of the protected component names (num, any, word, search f.ex), you can do so by
surrounding it with 's. Such as: format = "'num'" will allow you to type num to run the command, instead of interpreting it as
a num argument.

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

- To run f.ex a check on level or similar, you can override Command/preprocess(client/C). Returning FALSE here denies
running the command.

Documentation TODO:

- How command options are parsed.
- How to add new option prefixes.
- How to add new matcher components.
- More examples.
*/