package minitron.board {
	import com.tontonpiero.agents.AgentGroup;
	import com.tontonpiero.gcommand.GC;
	import flash.display.Sprite;
	import flash.geom.Point;
	import minitron.agents.idle.Square;
	import minitron.agents.moving.MainPlayer;
	import minitron.agents.moving.RandomPlayer;
	
	/**
	 * ...
	 * @author tontonpiero
	 */
	public class GameBoard extends Sprite {
		private var agents:AgentGroup;
		public var size:Point = new Point(800, 800);
		public var container_agents:Sprite;
		
		public function GameBoard() {
			container_agents = new Sprite();
			//container_agents.graphics.beginFill(0x161616);
			//container_agents.graphics.drawRect(0, 0, size.x, size.y);
			//container_agents.graphics.endFill();
			addChild(container_agents);
			
			
			var m:Sprite = new Sprite();
			m.graphics.beginFill(0x00FF00);
			m.graphics.drawRect(0, 0, 400, 400);
			m.graphics.endFill();
			m.x = -200;
			m.y = -200;
			addChild(m);
			
			container_agents.mask = m;
			
			agents = new AgentGroup("all");
			agents.add(new MainPlayer(this));
			for (var j:int = 0; j < 12; j++) {
				agents.add(new RandomPlayer(this));
			}
			
			for (var i:int = 0; i < 25; i++) {
				agents.add(new Square(this));
			}
			
			agents.activate();
			
			GC.addListener(this);
		}
		
		public function $onMainPlayerMoved(player:MainPlayer):void {
			container_agents.x = -player.position.x;
			container_agents.y = -player.position.y;
		}
		
		public function drawRect(color:uint, x:Number, y:Number, width:Number, height:Number):void {
			container_agents.graphics.beginFill(color);
			container_agents.graphics.drawRect(x, y, width, height);
			container_agents.graphics.endFill();
		}
		
	}

}