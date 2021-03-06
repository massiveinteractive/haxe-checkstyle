package ;

import checkstyle.checks.LocalVariableNameCheck;

class LocalVariableNameCheckTest extends CheckTestCase {

	public function testCorrectNaming() {
		var check = new LocalVariableNameCheck ();
		assertMsg(check, LocalVariableNameTests.TEST, '');
		assertMsg(check, LocalVariableNameTests.TEST4, '');
	}

	public function testWrongNaming() {
		var check = new LocalVariableNameCheck ();
		assertMsg(check, LocalVariableNameTests.TEST1, 'Invalid local var signature: Count (name should be ~/^[a-z]+[a-zA-Z0-9]*$/)');
		assertMsg(check, LocalVariableNameTests.TEST3, 'Invalid local var signature: Count (name should be ~/^[a-z]+[a-zA-Z0-9]*$/)');
	}

	public function testIgnoreExtern() {
		var check = new LocalVariableNameCheck ();
		check.ignoreExtern = false;

		assertMsg(check, LocalVariableNameTests.TEST, '');
		assertMsg(check, LocalVariableNameTests.TEST1, 'Invalid local var signature: Count (name should be ~/^[a-z]+[a-zA-Z0-9]*$/)');
		assertMsg(check, LocalVariableNameTests.TEST3, 'Invalid local var signature: Count (name should be ~/^[a-z]+[a-zA-Z0-9]*$/)');
		assertMsg(check, LocalVariableNameTests.TEST4, 'Invalid local var signature: Count (name should be ~/^[a-z]+[a-zA-Z0-9]*$/)');
	}

	public function testFormat() {
		var check = new LocalVariableNameCheck ();
		check.format = "^[A-Za-z_]*$";

		assertMsg(check, LocalVariableNameTests.TEST, 'Invalid local var signature: count2 (name should be ~/^[A-Za-z_]*$/)');
		assertMsg(check, LocalVariableNameTests.TEST1, '');
		assertMsg(check, LocalVariableNameTests.TEST3, '');
		assertMsg(check, LocalVariableNameTests.TEST4, '');
	}
}

class LocalVariableNameTests {
	public static inline var TEST:String = "
	class Test {
		public function test() {
			var a:Int;
			var b:Int;
		}
		@SuppressWarnings('checkstyle:LocalVariableName')
		public function test() {
			var I:Int;
		}
	}

	enum Test2 {
		count;
		a;
	}

	typedef Test3 = {
		public function test() {
			var count1:Int;
			var count2:String;
		};
		@SuppressWarnings('checkstyle:LocalVariableName')
		var COUNT6:Int = 1;
	}

	typedef Test4 = {
		@SuppressWarnings('checkstyle:LocalVariableName')
		public function test() {
			var Count1:Int;
		};
	}";

	public static inline var TEST1:String = "
	class Test {
		public function test() {
			var Count:Int = 1;
		}
	}";

	public static inline var TEST3:String =
	"typedef Test = {
		public function test() {
			var Count:Int;
		}
	}";

	public static inline var TEST4:String =
	"extern class Test {
		public function test() {
			var Count:Int = 1;
		}
	}";
}