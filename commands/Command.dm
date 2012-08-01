
Command
	New() {
		format = __replaceText(format," ","");

		if(!src.format) return;
		src._setComponents(alaparser.generator._fromCommand(src));
	}

	var
		_auto_create = TRUE;
		format
		list/_components;

	proc
		preprocess(client/C) {
			return TRUE;
		}

		postprocess(client/C) {
		}

		_go(client/C, var/Matcher/match) {
			var/list/arguments = list(C) + match._getValues();
			if(length(arguments) > 0) {
				call(src,"command")(arglist(arguments));
			} else {
				call(src,"command")();
			}
		}

		_setComponents(list/L) {
			src._components = L;
		}

		_getComponents() {
			. = new /list();
			for(var/MatcherComponent/comp in _components) {
				. += comp.clone();
			}
		}

		command() {
			CRASH("Command.command() default called. [src.type] must override command()!")
		}

		_getAutoCreate() {
			return _auto_create;
		}