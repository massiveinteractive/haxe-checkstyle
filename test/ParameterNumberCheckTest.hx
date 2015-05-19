package ;

import checkstyle.checks.ParameterNumberCheck;

class ParameterNumberCheckTest extends CheckTestCase {

	public function testNoParams() {
		var msg = checkMessage(ParameterNumberTests.TEST1, new ParameterNumberCheck());
		assertEquals('', msg);
	}

	public function test7Parameters() {
		var msg = checkMessage(ParameterNumberTests.TEST2, new ParameterNumberCheck());
		assertEquals('', msg);
	}

	public function test8Parameters() {
		var msg = checkMessage(ParameterNumberTests.TEST3, new ParameterNumberCheck());
		assertEquals('Too many parameters for function: test2 (> 7)', msg);
	}

	public function testMaxParameter() {
		var check = new ParameterNumberCheck();
		check.maxParameter = 8;
		var msg = checkMessage(ParameterNumberTests.TEST3, check);
		assertEquals('', msg);

		check.maxParameter = 3;

		var msg = checkMessage(ParameterNumberTests.TEST4, check);
		assertEquals('', msg);

		msg = checkMessage(ParameterNumberTests.TEST3, check);
		assertEquals('Too many parameters for function: test2 (> 3)', msg);
	}

	public function testInterface() {
		var msg = checkMessage(ParameterNumberTests.TEST5, new ParameterNumberCheck());
		assertEquals('Too many parameters for function: test4 (> 7)', msg);
	}
}

class ParameterNumberTests {
	public static inline var TEST1:String = "
	class Test {
		var testVar1:Int;
		public function test():Void {}
	}";

	public static inline var TEST2:String =
	"class Test {
		public function test1(param1:Int,
								param2:Int,
								param3:Int,
								param4:Int,
								param5:Int,
								param6:Int,
								param7:Int) {
			return;
		}
	}";

	public static inline var TEST3:String =
	"class Test {
		public function test2(param1:Int,
								param2:Int,
								param3:Int,
								param4:Int,
								param5:Int,
								param6:Int,
								param7:Int,
								param8:Int) {
			return;
		}
	}";
	
	public static inline var TEST4:String =
	"class Test {
		public function test3(param1:Int,
								param2:Int,
								param3:Int) {
			return;
		}
	}";

	public static inline var TEST5:String =
	"interface ITest {
		public function test4(param1:Int,
								param2:Int,
								param3:Int,
								param4:Int,
								param5:Int,
								param6:Int,
								param7:Int,
								param8:Int);
	}";
}
