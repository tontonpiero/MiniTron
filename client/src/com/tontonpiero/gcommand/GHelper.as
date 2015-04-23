package com.tontonpiero.gcommand {
	import com.tontonpiero.utils.LocalStorage;
	/**
	 * ...
	 * @author tontonpiero
	 */
	public class GHelper extends GListener {
		private var _record:Array = null;
		
		public function GHelper() {
			super();
			
			GC.scripts = LocalStorage.getGlobalOption("GCommand.scripts", { } );
		}
		
		/**
		 * Get help of the specified command
		 * @param	command
		 */
		public function $help(command:String = null):void {
			if( command ) {
				var data:* = GC.getCommandDetails(command);
				if( data ) {
					GC.out("classe(s)\t: \"" + data.classes.join("\" \"") + "\"");
					GC.out("usage\t\t: \"" + command + (data.args ? " " + data.args.join(" ") : "") + "\"");
				}
				else {
					GC.out("command \"" + command + "\" not found");
				}
			}
			else {
				GC.out("type \"ls\" to list commands");
				GC.out("type \"help &lt;command&gt;\" to get a command usage");
			}
		}
		
		public function $rec():void {
			GC.out("Recording script... (type \"/save &lt;name&gt;\" to end record and save script)");
			GC.out("-----------------------------------------");
			GC.input(onGCInput);
			_record = new Array();
		}
		
		private function onGCInput(text:String):void {
			if ( text.indexOf("/save") == 0 ) {
				var params:Array = text.split(" ");
				if ( params.length <= 1 ) {
					GC.error("missing script name");
				}
				else {
					var name:String = params[1].replace(/\"/g, "");
					var command:* = GC.getCommandDetails(name);
					if ( command ) {
						GC.error("command \"" + name + "\" already exists");
					}
					else {
						GC.scripts[name] = _record;
						LocalStorage.setGlobalOption("GCommand.scripts", GC.scripts);
						GC.out("Script \"" + name + "\" has been saved !");
						return;
					}
				}
			}
			else {
				GC.out("|<font color='#C46200'>" + text + "</font>");
				_record.push(text);
			}
			GC.input(onGCInput);
		}
		
		private function trim(str:String):String {
			return str.replace(/^\$?\s*\"?(.*?)\s*\"?;?$/g, "$1");
		}
		
		public function $delScripts():void {
			LocalStorage.deleteGlobalOption("GCommand.scripts");
			GC.scripts = { };
			GC.out("done");
		}
		
		/*public function $recEnd(name:String):void {
			var command:* = GC.getCommandDetails(name);
			if ( command ) {
				GC.error("command \"" + name + "\" already exists");
			}
			else {
				GC.out("Script \"" + name + "\" saved !");
			}
		}*/
		
	}

}