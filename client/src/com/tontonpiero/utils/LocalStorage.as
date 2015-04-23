package com.tontonpiero.utils {
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author tontonpiero
	 */
	public class LocalStorage {
		private static var SO:SharedObject = null;
		static public var isReady:Boolean = false;
		
		public function LocalStorage() { }
		
		public static function setup(id:String):void {
			if ( SO ) return;
			SO = SharedObject.getLocal(id);
			if ( !SO.data["users"] ) {
				SO.data["users"] = { };
				SO.flush();
			}
			isReady = true;
		}
		
		public static function setGlobalOption(key:String, value:*):void {
			if ( !SO ) return;
			SO.data[key] = value;
			SO.flush();
		}
		
		public static function getGlobalOption(key:String, defaultValue:* = null):* {
			if ( !SO ) return defaultValue;
			return SO.data[key] != undefined ? SO.data[key] : defaultValue;
		}
		
		public static function deleteGlobalOption(key:String):void {
			if ( !SO ) return;
			delete SO.data[key];
			SO.flush();
		}
		
		private static function get userData():* {
			if ( !SO || !currentUserId ) return null;
			if ( !SO.data.users ) SO.data.users = { };
			if ( !SO.data.users["u" + currentUserId] ) SO.data.users["u" + currentUserId] = { };
			return SO.data.users["u" + currentUserId];
		}
		
		public static function setUserOption(key:String, value:*):void {
			if ( !SO || !currentUserId ) return;
			userData[key] = value;
		}
		
		public static function getUserOption(key:String, defaultValue:* = null):* {
			if ( !SO || !currentUserId ) return defaultValue;
			return userData[key] != undefined ? userData[key] : defaultValue;
		}
		
		public static function deleteUserOption(key:String):void {
			if ( !SO || !currentUserId ) return;
			delete userData[key];
		}
		
		public static function reset():void {
			if ( !SO ) return;
			SO.clear();
			SO.flush();
		}
		
		static public function get currentUserId():int { return getGlobalOption("userId", 0); }
		static public function set currentUserId(value:int):void { setGlobalOption("userId", value); }
		
	}

}