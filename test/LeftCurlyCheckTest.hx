package ;

import checkstyle.checks.LeftCurlyCheck;

class LeftCurlyCheckTest extends CheckTestCase {

	public function testCorrectBraces() {
		var check = new LeftCurlyCheck ();
		assertMsg(check, LeftCurlyTests.TEST, '');
		assertMsg(check, LeftCurlyTests.TEST4, '');
		assertMsg(check, LeftCurlyTests.TEST6, '');
		assertMsg(check, LeftCurlyTests.TEST8, '');
		assertMsg(check, LeftCurlyTests.TEST9, '');
		assertMsg(check, LeftCurlyTests.TEST14, '');
	}

	public function testWrongBraces() {
		var check = new LeftCurlyCheck ();
		assertMsg(check, LeftCurlyTests.TEST1, 'Left curly should be at EOL (only linebreak or comment after curly)');
		assertMsg(check, LeftCurlyTests.TEST2, 'Left curly should be at EOL (only linebreak or comment after curly)');
		assertMsg(check, LeftCurlyTests.TEST3, 'Left curly should be at EOL (only linebreak or comment after curly)');
		assertMsg(check, LeftCurlyTests.TEST3, 'Left curly should be at EOL (only linebreak or comment after curly)');
		assertMsg(check, LeftCurlyTests.TEST5, 'Left curly should be at EOL (only linebreak or comment after curly)');
		assertMsg(check, LeftCurlyTests.TEST7, 'Left curly should be at EOL (only linebreak or comment after curly)');
		assertMsg(check, LeftCurlyTests.TEST10, 'Left curly should be at EOL (only linebreak or comment after curly)');
		assertMsg(check, LeftCurlyTests.TEST11, 'Left curly placement exceeds 120 character limit');
	}

	public function testBraceOnNL() {
		var check = new LeftCurlyCheck ();
		check.option = LeftCurlyCheck.NL;

		assertMsg(check, LeftCurlyTests.TEST, 'Left curly should be on new line (only whitespace before curly)');
		assertMsg(check, LeftCurlyTests.TEST13, '');

		check.tokens = [LeftCurlyCheck.OBJECT_DECL];
		assertMsg(check, LeftCurlyTests.TEST4, 'Left curly should be on new line (only whitespace before curly)');
		assertMsg(check, LeftCurlyTests.TEST14, 'Left curly should be on new line (only whitespace before curly)');

		check.tokens = [LeftCurlyCheck.IF];
		assertMsg(check, LeftCurlyTests.TEST1, '');
		assertMsg(check, LeftCurlyTests.TEST13, '');

		check.tokens = [LeftCurlyCheck.FOR];
		assertMsg(check, LeftCurlyTests.TEST5, '');
		assertMsg(check, LeftCurlyTests.TEST13, '');

		check.tokens = [LeftCurlyCheck.FUNCTION];
		assertMsg(check, LeftCurlyTests.TEST13, '');
	}
}

class LeftCurlyTests {
	public static inline var TEST:String = "
	class Test {
		function test() {
			if (true) {
				return;
			}

			if (true) return;
			else {
				return;
			}

			if (true) { // comment
				return;
			}
			else if (false) {
				return;
			}

			for (i in 0...10) {
				return i;
			}

			while (true) {
				return;
			}
		}
		@SuppressWarnings('checkstyle:LeftCurly')
		function test1()
		{
			if (true)
			{
				return;
			}

			for (i in 0...10)
			{
				return i;
			}

			while (true)
			{
				return;
			}
		}
	}";

	public static inline var TEST1:String = "
	class Test {
		function test() {
			if (true)
			{
				return;
			}
		}
	}";

	public static inline var TEST2:String = "
	class Test {
		function test() {
			if (true)
			{ // comment
				return;
			}
			else
				return;
		}
	}";

	public static inline var TEST3:String = "
	class Test {
		function test()
		{
			if (true) {
				return;
			}
			else {
				return;
			}
		}
	}";

	public static inline var TEST4:String = "
	class Test {
		function test() {
			if (true) return { x:1,
				y:2,
				z:3 };
		}
	}";

	public static inline var TEST5:String = "
	class Test {
		function test() {
			for (i in 0...10)
			{
				return i;
			}
		}
	}";

	public static inline var TEST6:String = "
	class Test {
		function test() {
			for (i in 0...10) if (i < 5) {
				return i;
			}
		}
	}";

	public static inline var TEST7:String = "
	class Test {
		function test() {
			while (true) { return i; }
		}
	}";

	public static inline var TEST8:String = "
	class Test {
		function test() {
			while (true) {
				return i;
			}
		}
	}";

	public static inline var TEST9:String = "
	class Test {
		function test() {
			for (i in 0....10) return i;
		}
	}";

	public static inline var TEST10:String = "
	class Test
	{
		function test() {
			if (true) return;
		}
	}";

	public static inline var TEST11:String = "
	class Test {
		function test():Array<Array<Array<Array<Array<Array<Array<Array<Array<Array<Array<Array<Array<Array<Array<String>>>>>>>>>>>>>>> {
		}
	}";

	public static inline var TEST12:String = "
	class Test {
		function test() {
			var struct = {x:10, y:10, z:20};
		}
	}";

	public static inline var TEST13:String = "
	class Test
	{
		function test()
		{
			if (true)
			{ // comment
				return;
			}
			else
			{
				if (false)
				{
					return;
				}
			}
		}
	}";

	public static inline var TEST14:String = "
	typedef Test = {
		x:Int,
		y:Int,
		z:Int,
		point:{x:Int, y:Int, z:Int}
	}";
}