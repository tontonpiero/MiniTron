package com.tontonpiero.gcommand {
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author tontonpiero
	 */
	public class GC {
		static private var listeners:Dictionary = new Dictionary(true);
		static private var _output:Function = _trace;
		static private var _commands:* = {};
		static private var _helper:GHelper;
		static private var _inputCallback:Function = null;
		static public var scripts:* = null;
		static public var dispCommands:Boolean = true;
		
		public function GC() {}
		
		static public function addListener(thisObj:*):void {
			if ( thisObj ) {
				var description:XML = describeType(thisObj);
				//trace(description.toXMLString());
				for each (var m:XML in description.method) {
					if ( m.@name.indexOf("$") == 0 ) {
						var fname:String = m.@name.toString().replace("$", "");
						if ( !_commands[fname] ) {
							_commands[fname] = { count:0, objects:new Dictionary(true), classes:[] };
							if (m.parameter != undefined) {
								_commands[fname].args = [];
								for each (var p:XML in m.parameter) {
									var arg:String = p.@optional.toString() == "true" ? "[" + p.@type + "]" : "&lt;" + p.@type.toString() + "&gt;";
									_commands[fname].args.push(arg);
								}
							}
						}
						else {
							var ok:Boolean = true;
							if (m.parameter != undefined) {
								var i:int = 0;
								for each (var p2:XML in m.parameter) {
									var arg2:String = p2.@optional.toString() == "true" ? "[" + p2.@type + "]" : "&lt;" + p2.@type.toString() + "&gt;";
									if ( !_commands[fname].args[i] || arg2 != _commands[fname].args[i] ) ok = false;
									i++;
								}
							}
							if ( !ok ) {
								GC.out("Error : command \"" + fname + "\" added with differents definitions (command in \"" + m.@declaredBy.toString() + "\" is ignored)");
								continue;
							}
						}
						_commands[fname].count++;
						_commands[fname].objects[thisObj] = true;
						_commands[fname].classes.push(m.@declaredBy.toString());
					}
				}
			}
		}
		
		static public function removeListener(thisObj:*):void {
			if ( thisObj ) {
				var description:XML = describeType(thisObj);
				for each (var m:XML in description.method) {
					if ( m.@name.indexOf("$") == 0 ) {
						var fname:String = m.@name.toString().replace("$", "");
						if ( _commands[fname].count > 1 ) {
							_commands[fname].count--;
						}
						else delete _commands[fname];
					}
				}
			}
		}
		
		static public function dispatch(command:String, ...params):void {
			if ( !command ) return;
			if ( !_helper ) _helper = new GHelper();
			//var strCommand:String = "$<font color='#008000'>" + command + "</font> ";
			//if ( params.length > 0 ) strCommand += "<font color='#800000'>\"" + params.join("\" \"") + "\"</font>";
			var strCommand:String = "$" + command + " ";
			if ( params.length > 0 ) strCommand += "\"" + params.join("\" \"") + "\"";
			if ( _inputCallback != null ) {
				var tempCallback:Function = _inputCallback;
				_inputCallback = null;
				tempCallback.call(null, command + (params.length > 0 ? " \"" + params.join("\" \"") + "\"" : ""));
				return;
			}
			if( dispCommands ) out(strCommand);
			if( _commands[command] ) {
				var obj:*;
				var method:String = "$" + command;
				for (obj in _commands[command].objects) {
					if ( obj && obj.hasOwnProperty(method) ) {
						try {
							obj[method].apply(obj, params);
						}
						catch (err:Error){
							out(err.message);
						}
					}
				}
			}
			else if ( scripts[command] ) {
				var oldVal:Boolean = dispCommands;
				dispCommands = false;
				for each (var line:String in scripts[command]) {
					for (var i:int = 0; i < params.length; i++) {
						line = line.replace("$" + i, params[i])
					}
					execLine(line);
				}
				dispCommands = oldVal;
			}
			else {
				//out("Error : unhandled command");
			}
		}
		
		static public function execLine(commandLine:String):void {
			var params:Array = extractParams(commandLine);
			dispatch.apply(null, params);
		}
		
		static private function extractParams(commandLine:String):Array {
			var info:Array = commandLine.match(/\"/g);
			if ( !info || info.length == 0 || info.length % 2 == 1 ) return commandLine.split(" ");
			var len:int = commandLine.length;
			var params:Array = new Array();
			var currentParam:String = "";
			var ing:Boolean = false;
			for (var i:int = 0; i < len; i++) 
			{
				var prevChar:String = i > 0 ? commandLine.charAt(i - 1) : null;
				var char:String = commandLine.charAt(i);
				var nextChar:String = i < len - 1 ? commandLine.charAt(i + 1) : null;
				
				if ( ing ) {
					if ( char == "\"" && (nextChar == " " || !nextChar) ) {
						params.push(currentParam);
						currentParam = "";
						ing = false;
					}
					else {
						currentParam += char;
					}
				}
				else {
					if ( char == "\"" && prevChar == " " ) {
						ing = true;
						currentParam = "";
					}
					else if ( char == " " ) {
						if ( currentParam.length > 0 ) params.push(currentParam);
						currentParam = "";
					}
					else {
						currentParam += char;
					}
				}
			}
			if ( currentParam.length > 0 ) params.push(currentParam);
			
			return params;
		}
		
		static private function _trace(...params):void {
			trace.apply(null, ["4:[GC]"].concat(params));
		}
		
		static public function out(...params):void {
			if( _output != null ) _output.apply(null, params);
		}
		
		static public function error(error:String):void {
			if ( error.indexOf("Error") != 0 ) error = "Error : " + error;
			if( _output != null ) _output.call(null, error);
		}
		
		static public function setOutput(output:*):void {
			GC._output = output;
		}
		
		static public function getCommands():Array {
			if ( !_helper ) _helper = new GHelper();
			var commands:Array = [];
			for (var c:String in _commands) {
				commands.push(c);
			}
			return commands.sort();
		}
		
		static public function getCommandDetails(command:String):* {
			return _commands[command] ? _commands[command] : null;
		}
		
		static public function input(callback:Function):void {
			GC._inputCallback = callback;
			GC.out("&gt; ");
		}
		
	}

}