package minitron.agents.moving {
	import flash.display.Sprite;
	import flash.geom.Point;
	import minitron.board.GameBoard;
	
	/**
	 * ...
	 * @author tontonpiero
	 */
	public class RandomPlayer extends Player {
		
		public function RandomPlayer(board:GameBoard) {
			super("random_player", board);
			color = Math.random() * 0xFFFFFF;
		}
		
		override public function create():void {
			super.create();
			
			if( board ) position = new Point(Math.random() * board.size.x, Math.random() * board.size.y);
		}
		
		override public function think():void {
			super.think();
			
			var rnd:Number = (Math.random() * 50) | 0;
			switch (rnd) {
				case 1: goLeft(); break;
				case 2: goRight(); break;
				case 3: goUp(); break;
				case 4: goDown(); break;
			}
		}
		
	}

}