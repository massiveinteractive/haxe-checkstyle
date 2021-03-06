package checkstyle.checks;

import checkstyle.LintMessage.SeverityLevel;
import haxeparser.Data.Token;

@name("ERegInstantiation")
@desc("Checks instantiation of regular expressions is in between ~/ and /, not with new")
class ERegInstantiationCheck extends Check {

	public function new() {
		super();
	}

	override function actualRun() {
		ExprUtils.walkFile(checker.ast, function(e) {
			if (isPosSuppressed(e.pos)) return;
			switch(e.expr){
				case ENew(
					{pack:[], name:"EReg"},
					[{expr:EConst(CString(re)), pos:_}, {expr:EConst(CString(opt)), pos:_}]
				):
					var lp = checker.getLinePos(e.pos.min);
					log('Bad EReg instantiation, define expression between ~/ and /', lp.line + 1, lp.ofs + 1, Reflect.field(SeverityLevel, severity));
				default:
			}
		});
	}
}