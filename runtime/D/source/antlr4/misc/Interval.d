module antlr4.misc.Interval;

import std.stdio;
import std.format;
import std.algorithm;

class Interval {
	public static const int INTERVAL_POOL_MAX_VALUE = 1000;

	public static const Interval INVALID = new Interval(-1, -2);

	static Interval[] cache = new Interval[INTERVAL_POOL_MAX_VALUE + 1];

	public int a;
	public int b;

	public static int creates = 0;
	public static int misses = 0;
	public static int hits = 0;
	public static int outOfRange = 0;

    this(int a, int b) {
        this.a = a;
        this.b = b;
    }

	public static Interval of(int a, int b) {
		if (a != b || a < 0 || a > INTERVAL_POOL_MAX_VALUE) {
			return new Interval(a, b);
		}
		if (cache[a] is null) {
			cache[a] = new Interval(a, a);
		}
		return cache[a];
	}

	public int length() {
		if (b < a) return 0;
		return b - a + 1;
	}

	public bool equals(Object o) {
		if (o is null || (cast(Interval) o) !is null) {
			return false;
		}
		Interval other = cast(Interval) o;
		return this.a == other.a && this.b == other.b;
	}

	public int hashCode() {
		int hash = 23;
		hash = hash * 31 + a;
		hash = hash * 31 + b;
		return hash;
	}

	public bool startsBeforeDisjoint(Interval other) {
		return this.a < other.a && this.b < other.a;
	}

	public bool startsBeforeNonDisjoint(Interval other) {
		return this.a <= other.a && this.b >= other.a;
	}

	public bool startsAfter(Interval other) {
	    return this.a > other.a;
	}

	public bool startsAfterDisjoint(Interval other) {
		return this.a > other.b;
	}

	public bool startsAfterNonDisjoint(Interval other) {
		return this.a > other.a && this.a <= other.b;
	}

	public bool disjoint(Interval other) {
		return startsBeforeDisjoint(other) || startsAfterDisjoint(other);
	}

	public bool adjacent(Interval other) {
		return this.a == other.b + 1 || this.b == other.a - 1;
	}

	public bool properlyContains(Interval other) {
		return other.a >= this.a && other.b <= this.b;
	}

	public Interval union_(Interval other) {
		return Interval.of(min(a, other.a), max(b, other.b));
	}

	public Interval intersection(Interval other) {
		return Interval.of(max(a, other.a), min(b, other.b));
	}

	public Interval differenceNotProperlyContained(Interval other) {
		Interval diff = null;
		if ( other.startsBeforeNonDisjoint(this) ) {
			diff = Interval.of(max(this.a, other.b + 1), this.b);
		}

		else if ( other.startsAfterNonDisjoint(this) ) {
			diff = Interval.of(this.a, other.a - 1);
		}
		return diff;
	}

	override public string toString() {
		return format("%i..%i", a, b);
	}
}

