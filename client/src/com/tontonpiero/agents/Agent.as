package com.tontonpiero.agents {
	import com.tontonpiero.gcommand.GC;
	import com.tontonpiero.gcommand.GListener;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class Agent extends GListener {
		static private var _agents:* = {};
		
		public var type:String = "unknown";
		public var id:String = null;
		public var speed:Number = 1;
		public var oldPosition:Point = new Point();
		public var position:Point = new Point();
		public var direction:Point = new Point();
		public var state:String = null;
		public var hasMoved:Boolean = false;
		
		public function Agent(type:String, id:String = null) {
			super();
			this.type = type;
			if ( !id ) {
				while (id == null || _agents[id]) {
					id = int(Math.random() * 1000000000).toString(36).toUpperCase();
				}
			}
			this.id = id;
			_agents[id] = this;
			
			create();
		}
		
		public function setState(newState:String):void {
			var oldState:String = state;
			if ( state != newState ) {
				state = newState;
				GC.dispatch("onAgentStateChange", this, oldState, newState);
			}
		}
		
		public function create():void {
			setState(AgentState.INACTIVE);
		}
		
		public function activate():void {
			if ( state == AgentState.INACTIVE ) setState(AgentState.IDLE);
		}
		
		public function deactivate():void {
			setState(AgentState.INACTIVE);
		}
		
		public function destroy():void {
			setState(AgentState.DESTROYED);
			dispose();
		}
		
		public function think():void {}
		
		public function move():void {}
		
		public function draw():void {}
		
		public function $onEnterFrame():void {
			hasMoved = false;
			if ( state == AgentState.DESTROYED ) return;
			if( state != AgentState.INACTIVE ) {
				think();
				
				if ( state == AgentState.MOVING ) {
					oldPosition.x = position.x;
					oldPosition.y = position.y;
					move();
					if ( oldPosition.x != position.x || oldPosition.y != position.y ) hasMoved = true;
				}
				draw();
			}
		}
		
		public function toString():String { return "[Agent #" + id + " type=\"" + type + "\"]"; }
		
	}

}