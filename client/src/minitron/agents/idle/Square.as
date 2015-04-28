package minitron.agents.idle {
	import com.tontonpiero.agents.Agent;
	import com.tontonpiero.agents.AgentState;
	import flash.display.Sprite;
	import flash.geom.Point;
	import minitron.board.GameBoard;
	
	/**
	 * ...
	 * @author tontonpiero
	 */
	public class Square extends Agent {
		private var size:int;
		private var board:GameBoard;
		private var i:Number = 0;
		
		public function Square(board:GameBoard = null) {
			this.board = board;
			super("square");
		}
		
		override public function create():void {
			super.create();
			i = Math.random() * 360;
			size = 2 * Math.floor(5 + Math.random() * 25);
			if( board ) position = new Point(Math.random() * board.size.x, Math.random() * board.size.y);
		}
		
		override public function draw():void {
			super.draw();
			if ( board ) {
				i += 0.3;
				i = i % 360;
				var delta:Number = 128 + 50 * Math.cos(i);
				
				var color:uint = ( ( delta << 16 ) | ( delta << 8 ) | delta );
				board.drawRect(color, position.x - size / 2, position.y - size / 2, size, size);
			}
			//setState(AgentState.INACTIVE);
		}
		
	}

}