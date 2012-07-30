OptionParser
	proc
		_parsePrefix(list/L, str) {
			var/i = 1;
			while(length(str)) {
				var/next = copytext(str, i, i+1);
				var/Option/opt = _getPrefixOption(next);
				if(opt == null) break;
				else L += opt;
				if(++i > length(str)) break;
			}
			return L;
		}

		_parsePostfix(list/L, str) {
			var/left = findtext(str, "(");
			var/right = findtext(str, ")");
			if(!left || !right || left > right || right < left) return L;

			var/body = copytext(str, left+1, right);
			var/list/bodyList = __textToList(body, " ");
			if(length(bodyList) != 3) return L;
			if(bodyList[2] != "in") return L;
			L += new /Option/range(bodyList[1], bodyList[3]);
		}

		parse(str) {
			. = new /list();
			_parsePrefix(., str);
			_parsePostfix(., str);
		}

		_getPrefixOption(t) {
			switch(t) {
				if("!") return new /Option/prefix/forceValue;
				if("?") return new /Option/prefix/optional;
				if("%") return new /Option/prefix/caseSensitive;
				else return null;
			}
		}