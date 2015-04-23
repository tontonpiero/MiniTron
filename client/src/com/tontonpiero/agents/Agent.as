package com.tontonpiero.agents {
	import com.tontonpiero.gcommand.GC;
	import com.tontonpiero.gcommand.GListener;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class Agent extends GListener {
		public var speed:Number = 1;
		public var position:Point;
		public var direction:Point;
		public var state:String = AgentState.INACTIVE;
		
		public function Agent() {
			
		}
		
		public function activate():void {
			if ( state == AgentState.INACTIVE ) setState(AgentState.IDLE);
		}
		
		public function setState(newState:String):void {
			if ( state != newState ) {
				state = newState;
				//dispach("
			}
		}
		
		public function deactivate():void {
			
		}
		
		public function destroy():void {
			
		}
		
		public function think():void {
			
		}
		
		public function move():void {
			
		}
		
		public function draw():void {
			
		}
		
	}

}