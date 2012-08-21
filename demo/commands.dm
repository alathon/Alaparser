
Command
    testmulti
        format = "hi|ho";

        command(mob/user) {
            user << "Wuhu!";
        }

    /* Movement */
    east
        format = "~east";

        command(mob/user) {
            var/room/curLoc = user.loc;
            if(curLoc.east != null) {
                user << "You move east.";
                user.Move(curLoc.east);
            } else {
                user << "You can't go east here.";
            }
        }

    west
        format = "~west";

        command(mob/user) {
            var/room/curLoc = user.loc;
            if(curLoc.west != null) {
                user << "You move west.";
                user.Move(curLoc.west);
            } else {
                user << "You can't go west here.";
            }
        }

    /* userommunication */
    say
        format = "say; any;"

        command(mob/user, txt) {
            user.loc.contents - user << "[user] says, '[txt]'";
            user << "You say, '[txt]'"
        }



    tell
        format = "tell; %search(client@clients); any";

        command(mob/user, client/target, txt) {
            if(target == user) {
                user << "You tell yourself (Weirdo), '[txt]'";
                return;
            }

            target << "[user] tells you, '[txt]'"
            user << "You tell [target], '[txt]'"
        }

    /* Random stuff */
    tattoo
        level_req = 5
        format = "tattoo; word; ?on; ?word"

        command(mob/user, text, place) {
            if(!place) {
                switch(rand(1,3)) {
                    if(1) place = "arm";
                    if(2) place = "leg";
                    if(3) place = "spine";
                }
            }
            user << "You tattoo [text] on your [place]";
        }

    jump
        format = "jump; ?!num; ?times"

        command(mob/user, num) {
            if(num) {
                user << "You jump [num] times!";
            } else {
                user << "You jump...";
            }
            user.client.level += max(1,num);
            user << "You level up [num] time[num > 1 ? "s":""] from jumping so much! You are now level [user.client.level]";
        }

    /* Information */
    who
        format = "who";

        command(mob/user) {
            user << "----------\n";
            for(var/client/other) {
                user << other.mob
            }
            user << "----------\n";
        }

    look
        format = "~look | ~gaze | ~eye; ?!at; ?~search(mob@loc)";

        command(mob/user, at, mob/M) {
            if(!M) {
                if(at) {
                    user << "Look at what?";
                    return;
                }

                if(istype(user.loc, /room)) {
                    var/room/R = user.loc;
                    R.describe(user);
                }
            } else {
                M.describe(user);
            }
        }

    /* Other tests */
    literaltest
        format = "'num';";

        command(mob/user) {
            user << "It worked! You can type num!";
        }
