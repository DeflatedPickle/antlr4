module antlr4.IntStream;

import std.stdio;

interface IntStream {
    public static const int EOF = -1;

	public static const string UNKNOWN_SOURCE_NAME = "<unknown>";

	void consume();

	int LA(int i);

	int mark();

	void release(int marker);

	int index();

	void seek(int index);

	int size();

	public string getSourceName();
}
