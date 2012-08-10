
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
		preprocess(mob/M) {
			return TRUE;
		}

		postprocess(mob/M) {
		}

		_go(mob/M, var/Matcher/match) {
			var/list/arguments = list(M) + match._getValues();
			if(length(arguments) > 0) {
				call(src,"command")(arglist(arguments));
			} else {
				call(src,"command")();
			}
		}

		_setComponents(list/L) {
			src._components = L;
		}

		_getFirstComponent() {
			return _components[1];
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
