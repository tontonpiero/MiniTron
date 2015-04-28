package minitron.agents.moving {
	import com.tontonpiero.gcommand.GC;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import minitron.agents.moving.Player;
	import minitron.board.GameBoard;
	/**
	 * ...
	 * @author tontonpiero
	 */
	public class MainPlayer extends Player {
		
		public function MainPlayer(board:GameBoard) {
			super("main_player", board);
			color = 0x00FF00;
		}
		
		public function $onKeyDown(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case 37: goLeft(); break;
				case 38: goUp(); break;
				case 39: goRight(); break;
				case 40: goDown(); break;
			}
		}
		
		override public function move():void {
			super.move();
			GC.dispatch("onMainPlayerMoved", this);
		}
		
	}

}