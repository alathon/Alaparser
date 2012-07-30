// A robust text2list implementation that doesn't error on odd strings
// and has the default option of skipping empty additions.
proc/__textToList(str, delim = ";", skip_empty = TRUE) {
	if(!str) {
		//world << "No str";
		return new /list();
	}

	//world << "textToList for [str]";
	var/next = findtext(str, delim);
	var/last = 0;
	. = new /list();
	//world << "skipEmpty = [skip_empty]";
	while(next != 0) {
		//world << "next = [next]";
		var/txt = copytext(str, last+1, next);
		//world << "txt = [txt]";
		if(skip_empty == FALSE || txt) {
			//world << "Adding [txt]";
			. += txt;
		}
		last = next;
		next = findtext(str, delim, next+1, 0);
	}

	var/txt = copytext(str, last+1);
	if(skip_empty == FALSE || txt) {
		. += txt;
	}
}

// A robust list2text implementation that can skip empty entries.
proc/__listToText(list/L, delim = ";", skip_empty = TRUE) {
	if(!L || !length(L)) return "";

	. = "";
	for(var/entry in L) {
		if(skip_empty == FALSE || entry) {
			. = "[.][entry][delim]";
		}
	}
	if(skip_empty != FALSE) . = copytext(., 1, -(length(delim)));
}

proc/__replaceText(str, replace, with) {
	return __listToText(__textToList(str, replace, FALSE), with, FALSE);
}


proc/__textMatch(text, attempt, case = FALSE, partial = TRUE) {
	var/match = text;
	if(!case) {
		attempt = lowertext(attempt);
		match = lowertext(match);
	}

	if(partial) return (attempt == match || copytext(match, 1, length(attempt)+1) == attempt);
	else return (attempt == match);
}

proc/__isTextNum(n) {
	return ("[text2num(n)]" == "[n]");
}

/* DEBUGGING
proc/iterateListElements(list/L) {
	for(var/a in L) {
		. += "\[[a]\]";
	}
}

mob/verb/TestListToText() {
	var/str1 = list("", "hi", "there", "");
	var/str2 = list("hi  ","   there");
	var/str3 = list("", "", "");
	var/delim = ";"
	world << "List1 skip empty: [__listToText(str1, delim, TRUE)]";
	world << "List1 don't skip empty: [__listToText(str1, delim, FALSE)]";
	world << "List2 skip empty: [__listToText(str2, delim, TRUE)]";
	world << "List2 don't skip empty: [__listToText(str2, delim, FALSE)]";
	world << "List3 skip empty: [__listToText(str3, delim, TRUE)]";
	world << "List3 don't skip empty: [__listToText(str3, delim, FALSE)]";
}

mob/verb/TestTextToList() {
	var/str1 = ";hi;there;";
	var/str2 = "hi  ;   there";
	var/str3 = ";;;";
	var/delim = ";"
	world << "Str1\[[str1]\] skip empty: [iterateListElements(__textToList(str1, delim, TRUE))]";
	world << "Str1\[[str1]\] don't skip empty: [iterateListElements(__textToList(str1, delim, FALSE))]";
	world << "Str2\[[str2]\] skip empty: [iterateListElements(__textToList(str2, delim, TRUE))]";
	world << "Str2\[[str2]\] don't skip empty: [iterateListElements(__textToList(str2, delim, FALSE))]";
	world << "Str3\[[str3]\] skip empty: [iterateListElements(__textToList(str3, delim, TRUE))]";
	world << "Str4\[[str3]\] don't skip empty: [iterateListElements(__textToList(str3, delim, FALSE))]";
}

mob/verb/TestReplace() {
	var/str1 = ";hi;there;";
	var/str2 = "hi  ;   there";
	var/str3 = ";;;";
	world << "Str1\[[str1]\]: [__replaceText(str1, ";", "'")]";
	world << "Str2\[[str2]\]: [__replaceText(str2, ";", "'")]";
	world << "Str3\[[str3]\]: [__replaceText(str3, ";", "'")]";
}
*/