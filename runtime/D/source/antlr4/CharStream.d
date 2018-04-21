module antlr4.CharStream;

import std.stdio;

import antlr4.IntStream;
import antlr4.misc.Interval;

interface CharStream : IntStream {
	public string getText(Interval interval);
}
