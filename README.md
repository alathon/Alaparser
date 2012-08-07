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

Documentation
-------------
Documentation is 'on-going'. There is a fairly comprehensive demo as part of the library, that showcases
how to do most regular things.