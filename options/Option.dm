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
                if(src._isCorrectType(entry)) . += entry;
            }
        }

        _isCorrectType(entry) {
            for(var/typeVal in _types) {
                if(istype(entry, typeVal)) {
                    return TRUE;
                }
            }
            return FALSE;
        }

        _generateTypes() {
            src._types = new();
            var/list/entries = __textToList(src._typeFilterStr, "|");
            for(var/a in entries) {
                src._types += text2path("/[a]");
            }
        }

        getListFromKey(mob/M) {
            . = new /list();
            switch(_key) {
                if("clients") {
                    for(var/client/cli) . += cli;
                }
                if("loc") {
                    for(var/atom/A in M.loc) . += A;
                }
            }
        }

        _getPossibles(mob/M) {
            . = getListFromKey(M);
            . = _filterList(.);
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
