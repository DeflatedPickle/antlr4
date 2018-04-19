package org.antlr.v4.codegen.target;

import org.antlr.v4.codegen.CodeGenerator;
import org.antlr.v4.codegen.Target;
import org.antlr.v4.tool.ast.GrammarAST;

public class DTarget extends Target {
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
		return false;
	}
}
