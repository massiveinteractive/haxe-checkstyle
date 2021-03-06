package checkstyle.checks;

import haxe.macro.Expr;
import haxe.macro.Expr.Field;
import haxeparser.Data.Definition;
import haxe.macro.Expr.Function;
import haxeparser.Data.ClassFlag;
import checkstyle.LintMessage.SeverityLevel;
import haxeparser.Data.Token;

@name("MethodLength")
@desc("Maximum function length (default 50 lines)")
class MethodLengthCheck extends Check {

	public var maxFunctionLines:Int;

	public function new() {
		super();
		maxFunctionLines = 50;
	}

	override public function actualRun() {
		for (td in checker.ast.decls) {
			switch(td.decl){
				case EClass(d): searchFields(d.data);
				case EAbstract(a): searchFields(a.data);
				case EEnum(d): //trace("Enum");
				case EImport(sl, mode): //trace("Import");
				case ETypedef(d): //trace("typedef");
				case EUsing(path): //trace("Using");
			}
		}
	}

	function searchFields(fs:Array<Field>) {
		for (f in fs) {
			if (isCheckSuppressed(f)) continue;
			switch(f.kind){
				case FFun(ff):
					checkMethod(f);
				default:
			}

			ExprUtils.walkField(f, function(e) {
				switch(e.expr){
					case EFunction(name, ff):
						checkFunction(e);
					default:
				}
			});
		}
	}

	function checkMethod(f:Field) {
		var lp = checker.getLinePos(f.pos.min);
		var lmin = lp.line;
		var lmax = checker.getLinePos(f.pos.max).line;
		if (lmax - lmin > maxFunctionLines) warnFunctionLength(f.name, lp.line + 1, lp.ofs + 1);
	}

	function checkFunction(f:Expr) {
		var lp = checker.getLinePos(f.pos.min);
		var lmin = lp.line;
		var lmax = checker.getLinePos(f.pos.max).line;
		var fname = "(anonymous)";
		switch(f.expr){
			case EFunction(name, ff):
				if (name != null) fname = name;
			default: throw "EFunction only";
		}

		if (lmax - lmin > maxFunctionLines) warnFunctionLength(fname, lp.line + 1, lp.ofs + 1);
	}

	function warnFunctionLength(name:String, pos:Int, ofs:Int) {
		log('Function is too long: ${name} (> ${maxFunctionLines} lines, try splitting into multiple functions)', pos, ofs, Reflect.field(SeverityLevel, severity));
	}
}