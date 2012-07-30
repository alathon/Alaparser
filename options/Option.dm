Option/prefix
	forceValue
	optional
	caseSensitive
	partial

Option/postfix/range
	proc
		_filterList(list/L) {
			. = new /list();
			for(var/entry in L) {
				if(_isCorrectType(entry)) . += entry;
			}
		}

		_isCorrectType(entry) {
			for(var/typeVal in _types) {
				if(istype(entry, typeVal)) return TRUE;
			}
			return FALSE;
		}

		_generateTypes() {
			src._types = __textToList(src._typeFilterStr, "|");
		}

		getListFromKey(client/C) {
			. = new /list();
			switch(_key) {
				if("clients") {
					for(var/client/cli) . += cli;
				}
				if("loc") {
					for(var/atom/A in C.mob.loc) . += A;
				}
			}
		}

		getPossibles(client/C) {
			return _filterList(getListFromKey(C));
		}

	var
		list/_types
		_typeFilterStr;
		_key;

	New(typeFilterStr, key) {
		src._typeFilterStr = typeFilterStr;
		src._key = key;
		_generateTypes();
	}