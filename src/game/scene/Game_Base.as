package game.scene 
{
	import away3d.containers.View3D;
	import away3d.primitives.Cube;
	import away3d.primitives.Trident;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import game.box.*;
	import game.cube.*;
	/**
	 * ...
	 * @author Huaying
	 */
	public class Game_Base extends Sprite
	{
		private var view:View3D;
		private var boxcube:BoxCube;
		private var game_stage:Stage;
		
		public function Game_Base(stage:Stage) 
		{
			game_stage = stage;
			gameStart();
		}
		private function gameStart():void {
			
			view = new View3D( { x:400, y:300 } );
			addChild(view);
			
			//add a trdient
			//var axis:Trident = new Trident(250,true);
			//view.scene.addChild(axis);	
			
			boxcube = new BoxCube(view);
			boxcube.gameStart();
			
			this.addEventListener(Event.ENTER_FRAME, update);
			game_stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		}
		private function onKeyDown(e:KeyboardEvent):void
		{
			boxcube.onKeyDown(e); 
		}
		private function update(e:Event):void {	
			boxcube.update(e);
		}

	}

}