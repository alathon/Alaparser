Option/prefix
	forceValue
	optional
	caseSensitive

Option/range
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
			return new /list();
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


/*

Prefix Options:

MUST HAVE:
! = Force value
? = Optional (Will not fail on failed match)

GOOD TO HAVE:
% = Case sensitive match

Range Options:

mob|obj|turf|atom|area in X

Where X is user-defined range
*/