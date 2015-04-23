package{
	import com.tontonpiero.gcommand.GConsole;
	import com.tontonpiero.utils.LocalStorage;
	import flash.display.Sprite;
	import flash.events.Event;
	import helpers.KeyboardHelper;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class Main extends Sprite {
		private var player:Player;
		
		public function Main() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			LocalStorage.setup("MiniTron");
			//new GConsole().setup(stage);
			
			new KeyboardHelper(stage);
			
			player = new Player();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void {
			player.move();
			player.draw(graphics);
		}
		
	}
	
}