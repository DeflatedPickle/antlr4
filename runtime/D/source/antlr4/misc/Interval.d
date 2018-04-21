module antlr4.misc.Interval;

import std.stdio;
import std.algorithm;

class Interval {
	public static final int INTERVAL_POOL_MAX_VALUE = 1000;

	public static final Interval INVALID = new Interval(-1, -2);

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
		// cache just a..a
		if (a != b || a < 0 || a > INTERVAL_POOL_MAX_VALUE) {
			return new Interval(a, b);
		}
		if (cache[a] == null) {
			cache[a] = new Interval(a, a);
		}
		return cache[a];
	}

	public int length() {
		if (b < a) return 0;
		return b - a + 1;
	}

	override public bool equals(Object o) {
		if (o is null || (cast(Interval) o) !is null) {
			return false;
		}
		Interval other = cast(Interval) o;
		return this.a == other.a && this.b == other.b;
	}

	override public int hashCode() {
		int hash = 23;
		hash = hash * 31 + a;
		hash = hash * 31 + b;
		return hash;
	}

	/** Does this start completely before other? Disjoint */
	public bool startsBeforeDisjoint(Interval other) {
		return this.a < other.a && this.b < other.a;
	}

	/** Does this start at or before other? Nondisjoint */
	public bool startsBeforeNonDisjoint(Interval other) {
		return this.a <= other.a && this.b >= other.a;
	}

	/** Does this.a start after other.b? May or may not be disjoint */
	public bool startsAfter(Interval other) {
	    return this.a > other.a;
	}

	/** Does this start completely after other? Disjoint */
	public bool startsAfterDisjoint(Interval other) {
		return this.a > other.b;
	}

	/** Does this start after other? NonDisjoint */
	public bool startsAfterNonDisjoint(Interval other) {
		return this.a > other.a && this.a <= other.b; // this.b>=other.b implied
	}

	/** Are both ranges disjoint? I.e., no overlap? */
	public bool disjoint(Interval other) {
		return startsBeforeDisjoint(other) || startsAfterDisjoint(other);
	}

	/** Are two intervals adjacent such as 0..41 and 42..42? */
	public bool adjacent(Interval other) {
		return this.a == other.b + 1 || this.b == other.a - 1;
	}

	public bool properlyContains(Interval other) {
		return other.a >= this.a && other.b <= this.b;
	}

	/** Return the interval computed from combining this and other */
	public Interval union_(Interval other) {
		return Interval.of(min(a, other.a), max(b, other.b));
	}

	/** Return the interval in common between this and o */
	public Interval intersection(Interval other) {
		return Interval.of(max(a, other.a), min(b, other.b));
	}

	/** Return the interval with elements from this not in other;
	 *  other must not be totally enclosed (properly contained)
	 *  within this, which would result in two disjoint intervals
	 *  instead of the single one returned by this method.
	 */
	public Interval differenceNotProperlyContained(Interval other) {
		Interval diff = null;
		// other.a to left of this.a (or same)
		if ( other.startsBeforeNonDisjoint(this) ) {
			diff = Interval.of(max(this.a, other.b + 1), this.b);
		}

		// other.a to right of this.a
		else if ( other.startsAfterNonDisjoint(this) ) {
			diff = Interval.of(this.a, other.a - 1);
		}
		return diff;
	}

	override public string toString() {
		return a + ".." + b;
	}
}

