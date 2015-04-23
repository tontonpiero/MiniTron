package com.tontonpiero.gcommand {
	/**
	 * ...
	 * @author tontonpiero
	 */
	public class GListener {
		
		public function GListener() { GC.addListener(this); }
		
		public function dispose():void { GC.removeListener(this); }
		
	}

}