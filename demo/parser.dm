/*

Push all client input over to the parser for processing,
and let the user know if what they typed didn't make any sense.

*/

client/Command(T) {
	var/ParserOutput/out = alaparser.parser.process(src, T);
	if(!out.getSuccess()) {
		src << "Huh?";
	}
}