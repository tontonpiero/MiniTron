package minitron.board {
	import com.tontonpiero.agents.Agent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import minitron.agents.moving.MainPlayer;
	
	/**
	 * ...
	 * @author tontonpiero
	 */
	public class GameMap extends Bitmap {
		private var _rect:Rectangle = new Rectangle();
		
		public function GameMap(size:Point) {
			super(new BitmapData(size.x, size.y, false, 0));
		}
		
		public function testPosition(player:MainPlayer):int {
			var pixelColor:uint = bitmapData.getPixel(player.position.x, player.position.y);
			if ( pixelColor == 0 ) return 0;
			if ( pixelColor == player.color ) return 1;
			return 2;
		}
		
		public function drawRect(color:uint, x:Number, y:Number, width:Number, height:Number):void {
			_rect.setTo(x, y, width, height);
			bitmapData.fillRect(_rect, color);
		}
		
		public function drawPoly(color:uint, points:Array):void {
			var shape:Shape = new Shape();
			shape.graphics.beginFill(color, 1);
			var p:Point = points.shift();
			shape.graphics.moveTo(p.x, p.y);
			while (points.length > 0) {
				p = points.shift();
				shape.graphics.lineTo(p.x, p.y);
			}
			shape.graphics.endFill();
			bitmapData.draw(shape);
		}
		
	}

}