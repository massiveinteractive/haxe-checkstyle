package checkstyle.checks;

import haxe.macro.Printer;
import haxe.macro.Expr.Binop;
import haxe.macro.Expr.Unop;
import checkstyle.LintMessage.SeverityLevel;
import haxeparser.Data.Token;

@name("ArrayAccess")
@desc("Spacing check on array access")
class ArrayAccessCheck extends Check {

	public var shouldNotHaveSpaceBefore:Bool;
	public var shouldNotHaveSpaceInside:Bool;

	public function new() {
		super();
		shouldNotHaveSpaceBefore = true;
		shouldNotHaveSpaceInside = true;
	}

	override function actualRun() {
		var lastExpr = null;

		ExprUtils.walkFile(checker.ast, function(e) {
			if (lastExpr == null) {
				lastExpr = e;
				return;
			}

			switch(e.expr) {
				case EArray(e1, e2):
					if (shouldNotHaveSpaceBefore)
					{
						var e1length = e1.pos.max - e1.pos.min;
						var eString = checker.getString(e.pos.min, e.pos.max);
						if (eString.substr(e1length, 1) == " ")
							logPos('Space between array and square bracket', e.pos, Reflect.field(SeverityLevel, severity));
					}
					
					if (shouldNotHaveSpaceInside)
					{
						var eString = checker.getString(e.pos.min, e.pos.max);
						if (checker.file.content.substr(e2.pos.min-1, 1) == " ")
							logPos('Space between left square-bracket and index', e.pos, Reflect.field(SeverityLevel, severity));
						if (checker.file.content.substr(e2.pos.max, 1) == " ")
							logPos('Space between index and right square-bracket', e.pos, Reflect.field(SeverityLevel, severity));
					}
				default:
			}

			lastExpr = e;
		});
	}
}