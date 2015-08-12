package checkstyle.reporter;

import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;
import checkstyle.LintMessage.SeverityLevel;

class JSONReporter implements IReporter {

	var report:GlobalReport;
	var fileReport:FileReport;
	var path:String;

	public function new(path:String, s:String) {
		this.path = path;
	}

	public function start() {
		report = [];
	}

	public function finish() {
		
	}

	public function fileStart(f:LintFile) {
		fileReport = {
			fileName: f.name,
			messages: []
		};
		report.push(fileReport);
	}

	public function fileFinish(f:LintFile) {
		sys.io.File.saveContent(path, haxe.Json.stringify(report));
	}

	public function addMessage(m:LintMessage) {
		var reportMessage:ReportMessage = {
			line: m.line,
			column: m.column,
			severity: severityString(m.severity),
			message: m.message
		};
		fileReport.messages.push(reportMessage);
	}
	
	static function severityString(s:SeverityLevel):String {
		return switch(s) {
			case INFO: return "info";
			case WARNING: return "warning";
			case ERROR: return "error";
		}
	}
}

typedef ReportMessage = {
	line: Int,
	column: Int,
	severity: String,
	message: String
};

typedef FileReport = {
	fileName: String,
	messages: Array<ReportMessage>
};

typedef GlobalReport = Array<FileReport>;