package game
{
	import flash.display.Sprite;
	import flash.events.Event;
	import game.scene.Game_Base;
	
	/**
	 * ...
	 * @author Huaying
	 */
	[SWF(width="800" , height="600" , frameRate="30" , backgroundColor = "0x000000")]
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);			
		}		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.focus = this;
			var gb:Game_Base = new Game_Base(this.stage);
			addChild(gb);
		
		}
		
	}
	
}