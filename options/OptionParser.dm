OptionParser
	proc
		_parsePrefix(list/L, str) {
			var/i = 1;
			while(length(str)) {
				var/next = copytext(str, i, i+1);
				var/Option/opt = src._getPrefixOption(next);
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
			var/list/bodyList = __textToList(body, "@");
			if(length(bodyList) != 2) return L;
			L += new /Option/postfix/range(bodyList[1], bodyList[2]);
		}

		parse(str) {
			. = new /list();
			src._parsePrefix(., str);
			src._parsePostfix(., str);
			world << "Parsing [str] gave the following options:";
			for(var/Option/O in .) {
				world << "[O]";
			}
		}

		_getPrefixOption(t) {
			switch(t) {
				if("!") return new /Option/prefix/forceValue;
				if("?") return new /Option/prefix/optional;
				if("%") return new /Option/prefix/caseSensitive;
				if("~") return new /Option/prefix/partial;
				else return null;
			}
		}