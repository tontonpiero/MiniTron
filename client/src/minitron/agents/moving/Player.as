package minitron.agents.moving {
	import com.tontonpiero.agents.Agent;
	import com.tontonpiero.agents.AgentState;
	import flash.geom.Point;
	import minitron.board.GameBoard;
	
	/**
	 * ...
	 * @author tontonpiero
	 */
	public class Player extends Agent {
		protected var board:GameBoard;
		public var color:uint = 0;
		
		public function Player(type:String = "player", board:GameBoard = null) {
			this.board = board;
			super(type);
		}
		
		override public function create():void {
			super.create();
			position = new Point(200, 200);
			direction = new Point(0, -1);
		}
		
		override public function activate():void {
			super.activate();
			setState(AgentState.MOVING);
		}
		
		override public function move():void {
			super.move();
			position.offset(direction.x * speed, direction.y * speed);
			var width:Number = board.size.x;
			var height:Number = board.size.y;
			if ( position.x >= width ) position.x -= width;
			if ( position.x < 0 ) position.x += width;
			if ( position.y >= height ) position.y -= height;
			if ( position.y < 0 ) position.y += height;
		}
		
		override public function draw():void {
			super.draw();
			if ( board ) {
				board.drawRect(color, position.x, position.y, 1, 1);
			}
		}
		
		public function goLeft():Boolean { if ( direction.x == 0 ) { direction.x = -1; direction.y = 0; return true; } else return false; }
		public function goUp():Boolean { if ( direction.y == 0 ) { direction.x = 0; direction.y = -1; return true; } else return false; }
		public function goRight():Boolean { if ( direction.x == 0 ) { direction.x = 1; direction.y = 0; return true; } else return false; }
		public function goDown():Boolean { if ( direction.y == 0 ) { direction.x = 0; direction.y = 1; return true; } else return false; }
		
	}

}