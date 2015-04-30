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
		private var waypoints:Vector.<Point> = new Vector.<Point>();
		
		public function MainPlayer(board:GameBoard) {
			super("main_player", board);
			color = 0x00FF00;
		}
		
		override public function create():void {
			super.create();
			addWaypoint(position);
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
		
		override public function goDown():Boolean { if ( super.goDown() ) { onDirectionChanged(); return true; } else return false; }
		override public function goUp():Boolean { if( super.goUp() ) { onDirectionChanged(); return true; } else return false; }
		override public function goLeft():Boolean { if( super.goLeft() ) { onDirectionChanged(); return true; } else return false; }
		override public function goRight():Boolean { if( super.goRight() ) { onDirectionChanged(); return true; } else return false; }
		
		private function onDirectionChanged():void {
			addWaypoint(position);
		}
		
		private function addWaypoint(position:Point):void {
			waypoints.push(position.clone());
		}
		
		public function closePath():void {
			trace("closePath");
			var polyPoints:Array = new Array();
			var pt:Point;
			var pt2:Point;
			var ok:Boolean = false;
			trace(waypoints);
			while (waypoints.length > 1) {
				pt = waypoints.pop();
				polyPoints.push(pt);
				trace(pt);
				if ( pt.x == position.x ) {
					pt2 = waypoints[waypoints.length - 1];
					var minY:Number = Math.min(pt.y, pt2.y);
					var maxY:Number = Math.max(pt.y, pt2.y);
					if ( position.y >= minY && position.y <= maxY ) {
						ok = true;
						break;
					}
				}
				else if ( pt.y == position.y ) {
					pt2 = waypoints[waypoints.length - 1];
					var minX:Number = Math.min(pt.x, pt2.x);
					var maxX:Number = Math.max(pt.x, pt2.x);
					if ( position.x >= minX && position.x <= maxX ) {
						ok = true;
						break;
					}
				}
			}
			
			if ( ok ) {
				polyPoints.push(position);
				//trace("polyPoints", polyPoints);
				board.drawPoly(color, polyPoints);
			}
		}
		
	}

}