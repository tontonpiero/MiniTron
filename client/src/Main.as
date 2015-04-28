package{
	import minitron.agents.moving.MainPlayer;
	import minitron.agents.moving.Player;
	import minitron.agents.moving.RandomPlayer;
	import minitron.agents.idle.Square;
	import com.tontonpiero.agents.Agent;
	import com.tontonpiero.agents.AgentGroup;
	import com.tontonpiero.gcommand.GC;
	import com.tontonpiero.gcommand.GConsole;
	import com.tontonpiero.utils.LocalStorage;
	import flash.display.Sprite;
	import flash.events.Event;
	import helpers.KeyboardHelper;
	import minitron.board.GameBoard;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class Main extends Sprite {
		
		public function Main() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			LocalStorage.setup("MiniTron");
			new GConsole().setup(stage);
			
			new KeyboardHelper(stage);
			
			GC.addListener(this);
			
			var board:GameBoard = new GameBoard();
			addChild(board);
			
			board.x = stage.stageWidth / 2;
			board.y = stage.stageHeight / 2;
			
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function $onAgentStateChange(agent:Agent, oldState:String, newState:String):void {
			if( oldState ) trace(agent, oldState + " ==> " + newState);
		}
		
		private function onEnterFrame(e:Event):void {
			GC.dispatch("onEnterFrame");
			//player.move();
			//player.draw(graphics);
		}
		
	}
	
}