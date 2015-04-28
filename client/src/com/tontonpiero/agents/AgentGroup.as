package com.tontonpiero.agents {
	
	/**
	 * ...
	 * @author tontonpiero
	 */
	public class AgentGroup extends Agent {
		private var _agents:Vector.<Agent> = new Vector.<Agent>();
		
		public function AgentGroup(type:String) {
			super(type);
		}
		
		public function add(agent:Agent):Agent {
			if ( _agents.indexOf(agent) < 0 ) _agents.push(agent);
			return agent;
		}
		
		public function remove(agent:Agent):Agent {
			var index:int = _agents.indexOf(agent);
			if ( index >= 0 ) _agents.splice(index, 1);
			return agent;
		}
		
		override public function activate():void {
			super.activate();
			for each (var agent:Agent in _agents) agent.activate();
		}
		
		override public function deactivate():void {
			super.deactivate();
			for each (var agent:Agent in _agents) agent.activate();
		}
		
		override public function destroy():void {
			super.destroy();
			for each (var agent:Agent in _agents) agent.destroy();
		}
		
	}

}