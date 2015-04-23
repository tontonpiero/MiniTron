package com.tontonpiero.gcommand {
	/**
	 * ...
	 * @author tontonpiero
	 */
	public class GListener {
		
		public function GListener() { GC.addListener(this); }
		
		public function dispose():void { GC.removeListener(this); }
		
		public function dispach(event:String, ...params):void { GC.dispatch.apply(this, [this].concat(params)); }
		
	}

}