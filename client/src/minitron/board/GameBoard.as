package minitron.board {
	import com.tontonpiero.agents.Agent;
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
		public var map:GameMap;
		
		public function GameBoard() {
			scaleX = scaleY = 1.5;
			
			map = new GameMap(size);
			addChild(map);
			
			var m:Sprite = new Sprite();
			m.graphics.beginFill(0x00FF00);
			m.graphics.drawRect(0, 0, 400, 400);
			m.graphics.endFill();
			m.x = -200;
			m.y = -200;
			addChild(m);
			
			map.mask = m;
			
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
			map.x = -player.position.x;
			map.y = -player.position.y;
			
			var res:int = map.testPosition(player);
			if ( res == 1 ) player.closePath();
		}
		
		public function drawRect(color:uint, x:Number, y:Number, width:Number, height:Number):void {
			map.drawRect(color, x, y, width, height);
		}
		
		public function drawPoly(color:uint, points:Array):void {
			map.drawPoly(color, points);
		}
		
	}

}