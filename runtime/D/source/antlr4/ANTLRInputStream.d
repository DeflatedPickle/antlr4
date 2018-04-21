module antlr4.ANTLRInputStream;

import std.stdio;
import core.stdc.string;

import antlr4.IntStream;
import antlr4.CharStream;
import antlr4.misc.Interval;

class ANTLRInputStream : CharStream {
    public static const int READ_BUFFER_SIZE = 1024;
   	public static const int INITIAL_BUFFER_SIZE = 1024;

	protected char[] data;

	protected int n;

	protected int p = 0;

	public string name;

    this() {
    }

	this(string input) {
		this.data = cast(char[]) input;
		this.n = strlen(input);
	}

	this(char[] data, int numberOfActualCharsInArray) {
		this.data = data;
		this.n = numberOfActualCharsInArray;
	}

    this(LockingTextReader r) {
        this(r, INITIAL_BUFFER_SIZE, READ_BUFFER_SIZE);
    }

    this(LockingTextReader r, int initialSize) {
        this(r, initialSize, READ_BUFFER_SIZE);
    }

    this(LockingTextReader r, int initialSize, int readChunkSize) {
        load(r, initialSize, readChunkSize);
    }

/*	this(InputStream input) {
		this(new InputStreamReader(input), INITIAL_BUFFER_SIZE);
	}

	this(InputStream input, int initialSize) {
		this(new InputStreamReader(input), initialSize);
	}

	this(InputStream input, int initialSize, int readChunkSize) {
		this(new InputStreamReader(input), initialSize, readChunkSize);
	}*/

	public void load(LockingTextReader r, int size, int readChunkSize) {
		if (r is null) {
			return;
		}
		if (size <= 0) {
			size = INITIAL_BUFFER_SIZE;
		}
		if (readChunkSize <= 0) {
			readChunkSize = READ_BUFFER_SIZE;
   		}
   		try {
   			data = new char[size];
   			int numRead=0;
   			int p = 0;
   			do {
   				if (p+readChunkSize > data.length) {
   					data.length *= 2;
   				}
   				numRead = r.read(data, p, readChunkSize);
   				p += numRead;
   			} while (numRead != IntStream.EOF);
   			n = p + 1;
   		}
   		finally {
   			r.close();
   		}
   	}

	public void reset() {
		p = 0;
	}

    public void consume() {
		if (p >= n) {
			assert(LA(1) == IntStream.EOF);
			throw new Exception("cannot consume EOF");
		}

        if (p < n) {
            p++;
        }
    }

    public int LA(int i) {
		if (i == 0) {
			return 0;
		}
		if (i < 0) {
			i++;
			if ((p + i - 1) < 0) {
				return IntStream.EOF;
			}
		}

		if ((p + i - 1) >= n) {
            return IntStream.EOF;
        }
		return data[p + i - 1];
    }

	public int LT(int i) {
		return LA(i);
	}

    public int index() {
        return p;
    }

	public int size() {
		return n;
	}

	public int mark() {
		return -1;
    }

	public void release(int marker) {
	}

	public void seek(int index) {
		if (index <= p) {
			p = index;
			return;
		}
		index = min(index, n);
		while (p < index) {
			consume();
		}
	}

	public string getText(Interval interval) {
		int start = interval.a;
		int stop = interval.b;
		if (stop >= n) {
		    stop = n - 1;
		}
		int count = stop - start + 1;
		if (start >= n) {
		    return "";
		}
		return new string(data, start, count);
	}

	public string getSourceName() {
		if (name is null || name.empty) {
			return UNKNOWN_SOURCE_NAME;
		}

		return name;
	}

    override public string toString() {
        return new string(data);
    }
}
