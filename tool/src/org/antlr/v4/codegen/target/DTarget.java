package org.antlr.v4.codegen.target;

import org.antlr.v4.codegen.CodeGenerator;
import org.antlr.v4.codegen.Target;
import org.antlr.v4.tool.ast.GrammarAST;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class DTarget extends Target {
	protected static final String[] dKeywords = {"abstract", "alias", "align", "asm", "assert", "auto",
		"body", "bool", "break", "byte",
		"case", "cast", "catch", "cdouble", "cent", "cfloat", "char", "class", "const", "continue", "creal",
		"dchar", "debug", "default", "delegate", "delete", "deprecated", "do", "double",
		"else", "enum", "export", "extern",
		"false", "final", "finally", "float", "for", "foreach", "foreach_reverse", "function",
		"goto",
		"idouble", "if", "ifloat", "immutable", "import", "in", "inout", "int", "interface", "invariant", "ireal", "is",
		"lazy", "long",
		"macro", "mixin", "module",
		"new", "nothrow", "null",
		"out", "override",
		"package", "pragma", "private", "protected", "public", "pure",
		"real", "ref", "return",
		"scope", "shared", "short", "static", "struct", "super", "switch", "synchronized",
		"template", "this", "throw", "true", "try", "typedef", "typeid", "typeof",
		"ubyte", "ucent", "uint", "ulong", "union", "unittest", "ushort",
		"version", "void",
		"wchar", "while", "with",
		"__FILE__", "__FILE_FULL_PATH__", "__MODULE__", "__LINE__", "__FUNCTION__", "__PRETTY_FUNCTION__",
		"__gshared", "__traits", "__vector", "__parameters"
	};

	private final Set<String> badWords = new HashSet<>();

	protected DTarget(CodeGenerator gen) {
		super(gen, "D");
	}

	@Override
	public String getVersion() {
		return "4.7.1";
	}

	@Override
	protected void appendUnicodeEscapedCodePoint(int codePoint, StringBuilder sb) {

	}

	@Override
	protected boolean visibleGrammarSymbolCausesIssueInGeneratedCode(GrammarAST idNode) {
		return getBadWords().contains(idNode.getText());
	}

	@Override
	public boolean supportsOverloadedMethods() {
		return true;
	}

	@Override
	public int getSerializedATNSegmentLimit() {
		// 65535 is the class file format byte limit for a UTF-8 encoded string literal
		// 3 is the maximum number of bytes it takes to encode a value in the range 0-0xFFFF
		return 65535 / 3;
	}

	private Set<String> getBadWords() {
		if (badWords.isEmpty()) {
			addBadWords();
		}

		return badWords;
	}

	private void addBadWords() {
		badWords.addAll(Arrays.asList(dKeywords));
		badWords.add("rule");
		badWords.add("parserRule");
	}
}
