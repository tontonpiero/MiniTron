package {
	import com.tontonpiero.gcommand.GListener;
	import flash.display.Graphics;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class Player extends GListener {
		public var position:Point;
		public var direction:Point;
		
		public function Player() {
			super();
			position = new Point(400, 400);
			direction = new Point(0, -1);
		}
		
		public function $onKeyDown(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case 37: if ( direction.x == 0 ) { direction.x = -1; direction.y = 0; } break;// left
				case 38: if ( direction.y == 0 ) { direction.x = 0; direction.y = -1; } break;// up
				case 39: if ( direction.x == 0 ) { direction.x = 1; direction.y = 0; } break;// right
				case 40: if ( direction.y == 0 ) { direction.x = 0; direction.y = 1; } break;// down
			}
		}
		
		public function move():void {
			position = position.add(direction);
		}
		
		public function draw(graphic:Graphics):void {
			graphic.beginFill(0x00FF00);
			graphic.drawRect(position.x, position.y, 1, 1);
			graphic.endFill();
		}
	}

}