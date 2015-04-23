package com.tontonpiero.gcommand {
	import com.tontonpiero.utils.LocalStorage;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	import mx.utils.StringUtil;
	/**
	 * ...
	 * @author tontonpiero
	 */
	public class GConsole extends mcGConsole {
		private var _stage:Stage;
		private var savedCommands:Array;
		private var iCommands:int;
		private var tempCommand:String;
		private var _lines:Array;
		
		public function GConsole() {
			
		}
		
		public function setup(stage:Stage):void {
			_stage = stage;
			_stage.addChild(this);
			txtOut.border = false;
			txtOut.text = "";
			
			txtIn.border = false;
			txtIn.text = "";
			
			_lines = [];
			
			GC.setOutput(out);
			
			if ( !LocalStorage.isReady ) out("Warning : LocalStorage is not initialized");
			
			tabEnabled = false;
			tabChildren = false;
			txtIn.addEventListener(KeyboardEvent.KEY_DOWN, onInputKeyDown, false, 0, true);
			txtIn.addEventListener(KeyboardEvent.KEY_UP, onInputKeyUp, false, 0, true);
			btnAlpha.btnPlus.addEventListener(MouseEvent.CLICK, onBtnAlphaPlusClicked, false, 0, true);
			btnAlpha.btnMoins.addEventListener(MouseEvent.CLICK, onBtnAlphaMoinsClicked, false, 0, true);
			btnSize.btnPlus.addEventListener(MouseEvent.CLICK, onBtnSizeUpClicked, false, 0, true);
			btnSize.btnMoins.addEventListener(MouseEvent.CLICK, onBtnSizeDownClicked, false, 0, true);
			btnHide.addEventListener(MouseEvent.CLICK, onBtnHideClicked, false, 0, true);
			btnMin.addEventListener(MouseEvent.CLICK, onBtnMinClicked, false, 0, true);
			btnMax.addEventListener(MouseEvent.CLICK, onBtnMaxClicked, false, 0, true);
			headerBG.addEventListener(MouseEvent.MOUSE_DOWN, onHeaderBGMouseDown, false, 0, true);
			headerBG.addEventListener(MouseEvent.MOUSE_UP, onHeaderBGMouseOut, false, 0, true);
			headerBG.addEventListener(MouseEvent.MOUSE_OUT, onHeaderBGMouseOut, false, 0, true);
			_stage.addEventListener(Event.RESIZE, handleResize, false, 0, true);
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageInputKeyDown, false, 0, true);
			
			savedCommands = LocalStorage.getGlobalOption("GConsole.commands");
			if ( !savedCommands ) savedCommands = new Array();
			iCommands = savedCommands.length;
			
			handleResize();
			
			GC.addListener(this);
			
			visible = false;
			_stage.focus = txtIn;
		}
		
		private function onBtnMaxClicked(e:MouseEvent):void { LocalStorage.setGlobalOption("GConsole.fullscreen", true); handleResize(); }
		private function onBtnMinClicked(e:MouseEvent):void { LocalStorage.setGlobalOption("GConsole.fullscreen", false); handleResize(); }
		
		private function onStageInputKeyDown(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case 112: if ( visible ) hide(); else show(); break;
				case 33: if ( visible ) alphaUp(); break;
				case 34: if ( visible ) alphaDown(); break;
				case 107: if( visible && e.ctrlKey ) sizeUp(); break;
				case 109: if( visible && e.ctrlKey ) sizeDown(); break;
				case 9: if ( visible ) _stage.focus = txtIn; break;
			}
			//out(e.keyCode);
		}
		
		private function onBtnHideClicked(e:MouseEvent):void {
			hide();
		}
		
		public function hide():void {
			visible = false;
		}
		
		public function show():void {
			visible = true;
			_stage.focus = txtIn;
		}
		
		private function onHeaderBGMouseOut(e:MouseEvent):void {
			if( !LocalStorage.getGlobalOption("GConsole.fullscreen", false) ) {
				stopDrag();
				LocalStorage.setGlobalOption("GConsole.x", x);
				LocalStorage.setGlobalOption("GConsole.y", y);
			}
		}
		
		private function onHeaderBGMouseDown(e:MouseEvent):void {
			if( !LocalStorage.getGlobalOption("GConsole.fullscreen", false) ) startDrag();
		}
		
		private function onBtnAlphaMoinsClicked(e:MouseEvent):void { alphaDown(); }
		private function onBtnAlphaPlusClicked(e:MouseEvent):void { alphaUp(); }
		
		private function alphaDown():void {
			if ( alpha > 0.3 ) {
				LocalStorage.setGlobalOption("GConsole.alpha", alpha - 0.2);
				handleResize();
			}
		}
		private function alphaUp():void {
			if ( alpha < 1 ) {
				LocalStorage.setGlobalOption("GConsole.alpha", alpha + 0.2);
				handleResize();
			}
		}
		
		private function onBtnSizeDownClicked(e:MouseEvent):void { sizeDown(); }
		private function onBtnSizeUpClicked(e:MouseEvent):void { sizeUp(); }
		
		private function sizeUp():void {
			if ( width <= _stage.stageWidth - 60 ) {
				LocalStorage.setGlobalOption("GConsole.width", width + 60);
				LocalStorage.setGlobalOption("GConsole.height", height + 40);
				handleResize();
			}
		}
		private function sizeDown():void {
			if ( width >= 460 ) {
				LocalStorage.setGlobalOption("GConsole.width", width - 60);
				LocalStorage.setGlobalOption("GConsole.height", height - 40);
				handleResize();
			}
		}
		
		private function handleResize(e:Event = null):void {
			var fullscreen:Boolean = LocalStorage.getGlobalOption("GConsole.fullscreen", false);
			var w:Number = fullscreen ? _stage.stageWidth : LocalStorage.getGlobalOption("GConsole.width", 600);
			var h:Number = fullscreen ? _stage.stageHeight : LocalStorage.getGlobalOption("GConsole.height", 400);
			headerBG.width = w;
			outBG.width = txtOut.width = w;
			inBG.width = txtIn.width = w;
			outBG.height = txtOut.height = h - 52;
			inBG.y = txtIn.y = h - 22;
			btnHide.x = w - btnHide.width - 4;
			btnAlpha.x = w - 190;
			btnSize.x = 100;
			btnMin.x = w - 70;
			btnMax.x = w - 70;
			btnMax.visible = !fullscreen;
			btnMin.visible = fullscreen;
			
			alpha = LocalStorage.getGlobalOption("GConsole.alpha", 1);
			
			if ( fullscreen ) {
				x = y = 0;
			}
			else {
				x = LocalStorage.getGlobalOption("GConsole.x", 0);
				y = LocalStorage.getGlobalOption("GConsole.y", 0);
				LocalStorage.setGlobalOption("GConsole.width", w);
				LocalStorage.setGlobalOption("GConsole.height", h);
			}
		}
		
		private function onInputKeyUp(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case 38: case 40: txtIn.setSelection(txtIn.text.length, txtIn.text.length); break;
			}
		}
		
		private function onInputKeyDown(e:KeyboardEvent):void {
			if( !e.ctrlKey ) {
				switch (e.keyCode) {
					case 13: if ( txtIn.text != "" ) execute(); break;// enter
					case 9: if ( txtIn.text != "" ) autoComplete(); e.preventDefault(); break; // tab
					case 38: previousCommand(); break; // tab
					case 40: nextCommand(); break; // tab
				}
			}
		}
		
		private function previousCommand():void {
			if ( iCommands > 0 ) iCommands--;
			if ( savedCommands.length > 0 ) {
				if ( iCommands == savedCommands.length - 1 ) tempCommand = txtIn.text;
				txtIn.text = savedCommands[iCommands];
			}
		}
		
		private function nextCommand():void {
			if ( iCommands < savedCommands.length ) iCommands++;
			if ( savedCommands.length > 0 && iCommands < savedCommands.length ) {
				txtIn.text = savedCommands[iCommands];
			}
			else {
				if ( tempCommand ) txtIn.text = tempCommand;
			}
		}
		
		private function execute():void {
			var commandLine:String = trim(txtIn.text.replace(/\s+/g, " "));
			savedCommands.push(commandLine);
			iCommands = savedCommands.length;
			LocalStorage.setGlobalOption("GConsole.commands", savedCommands);
			GC.execLine(commandLine);
			txtIn.text = "";
		}
		
		private function autoComplete():void {
			var str:String = txtIn.text;
			var commands:Array = GC.getCommands();
			var matches:Array = [];
			for each (var c:String in commands) {
				if ( c.indexOf(str) == 0 ) matches.push(c);
			}
			if ( matches.length == 1 ) {
				txtIn.text = matches[0];
				txtIn.setSelection(txtIn.text.length, txtIn.text.length);
			}
			else if ( matches.length > 1 ) {
				GC.out.apply(null, matches);
			}
		}
		
		private function out(...params):void {
			var isAtBottom:Boolean = txtOut.scrollV == txtOut.maxScrollV;
			var str:String = params.join(" ").replace("4:[GC]", "");
			if ( str.charAt(0) == "|" ) {
				str = str.substr(1, str.length - 1);
				_lines[_lines.length - 1] += str;
				$clear();
				for each (var line:String in _lines) txtOut.htmlText += line;
			}
			else {
				_lines.push(str);
				txtOut.htmlText += str;
			}
			if( isAtBottom ) txtOut.scrollV = txtOut.maxScrollV;
		}
		
		public function $flush():void {
			savedCommands = new Array();
			LocalStorage.setGlobalOption("GConsole.commands", savedCommands);
			GC.out("done");
		}
		
		public function $ls():void {
			var list:Array = GC.getCommands();
			GC.out.apply(null, list);
		}
		
		public function $clear():void {
			txtOut.text = "";
		}
		
		public function $reset():void {
			txtOut.text = "";
			LocalStorage.deleteGlobalOption("GConsole.x");
			LocalStorage.deleteGlobalOption("GConsole.y");
			LocalStorage.deleteGlobalOption("GConsole.alpha");
			LocalStorage.deleteGlobalOption("GConsole.width");
			LocalStorage.deleteGlobalOption("GConsole.height");
			LocalStorage.deleteGlobalOption("GConsole.fullscreen");
			handleResize();
			out("done");
		}
		
		public function $shortcuts():void {
			GC.out("F1\t\t: toogle console visibility");
			GC.out("PAGEUP\t: console alpha up");
			GC.out("PAGEDOWN\t: console alpha down");
			GC.out("CTRL +\t: increase console size");
			GC.out("CTRL -\t: decrease console size");
		}
		
		private function trim(str:String):String {
			return str.replace(/^\$?\s*\"?(.*?)\s*\"?;?$/g, "$1");
		}
		
	}

}