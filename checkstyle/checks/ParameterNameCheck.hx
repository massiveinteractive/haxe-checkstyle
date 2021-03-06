package checkstyle.checks;

import haxe.macro.Expr;
import haxeparser.Data;

@name("ParameterName")
@desc("Checks on naming conventions of parameters")
class ParameterNameCheck extends NameCheckBase {

	public function new() {
		super();
		format = "^[a-z]+[a-zA-Z0-9]*$";
	}

	override function checkClassType(d:Definition<ClassFlag, Array<Field>>, pos:Position) {
		if (ignoreExtern && (d.flags.indexOf(HExtern) > -1)) return;
		checkFields(d.data);
	}

	override function checkEnumType(d:Definition<EnumFlag, Array<EnumConstructor>>, pos:Position) {
		if (ignoreExtern && (d.flags.indexOf(EExtern) > -1)) return;
		checkEnumFields(d.data);
	}

	override function checkAbstractType(d:Definition<AbstractFlag, Array<Field>>, pos:Position) {
		checkFields(d.data);
	}

	override function checkTypedefType(d:Definition<EnumFlag, ComplexType>, pos:Position) {
		if (ignoreExtern && (d.flags.indexOf(EExtern) > -1)) return;

		switch (d.data) {
			case TAnonymous(f):
				checkFields(f);
			default:
		}
	}

	function checkFields(d:Array<Field>) {
		for (field in d) {
			if (isCheckSuppressed(field)) continue;
			switch (field.kind) {
				case FFun(f):
					checkField(f.args, field.pos);
				default:
			}
		}
	}

	function checkEnumFields(d:Array<EnumConstructor>) {
		for (field in d) {
			for (arg in field.args) {
				matchTypeName("parameter name", arg.name, field.pos);
			}
		}
	}

	function checkField(args:Array<FunctionArg>, pos:Position) {
		if (args == null || args.length <= 0) return;

		for (arg in args) {
			matchTypeName("parameter name", arg.name, pos);
		}
	}
}