package helpers {
	import com.tontonpiero.gcommand.GC;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class KeyboardHelper {
		
		public function KeyboardHelper(stage:Stage) {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			//stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			GC.dispatch("onKeyUp", e);
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			GC.dispatch("onKeyDown", e);
		}
		
	}

}