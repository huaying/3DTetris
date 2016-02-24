package game.box 
{
	import away3d.containers.View3D;
	import away3d.containers.Scene3D;
	import away3d.cameras.Camera3D;
	import away3d.materials.WireColorMaterial;
	import away3d.primitives.Cube;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import game.cube.*;
	
	/**
	 * ...
	 * @author Huaying
	 */
	public class BoxCube extends Sprite
	{
		private var view:View3D;
		private var view_stat:int ;
		private var game_flg:Boolean = false;
		private var boxCube:Cube;
		private var boxGrid:BoxGrid;
		private var box_width:Number;
		private var box_height:Number;
		private var box_depth:Number;
		private const cube_unit:Number = 20;
		private var cur_cube:TetrisCube;
	
		public function BoxCube(view:View3D) 
		{
			this.view = view;
			setCamDir(0);		
			createBox();
			boxGrid = new BoxGrid(box_width, box_height, box_depth);
		}
		public function setCamDir(stat:int):void {
			switch(stat) {
				case 0 :
					view.camera = new Camera3D( { zoom:45, focus:50, y:1000 , z: -700 , x:0 } );
					view.camera.lookAt(new Vector3D(0, 0, 120)); break;
				case 1 :
					view.camera = new Camera3D( { zoom:45, focus:50, y:1000 , z: 0 , x:-700 } );
					view.camera.lookAt(new Vector3D(120, 0, 0)); break;
				case 2 :
					view.camera = new Camera3D( { zoom:45, focus:50, y:1000 , z: 700 , x:0 } );
					view.camera.lookAt(new Vector3D(0, 0, -120)); break;
				case 3 :
					view.camera = new Camera3D( { zoom:45, focus:50, y:1000 , z: 0 , x:700 } );
					view.camera.lookAt(new Vector3D(-120, 0, 0)); break;
			}
			view_stat = stat;
		}
		public function rorCamLeft():void {
			setCamDir((++view_stat)%4);
		}
		public function rorCamRight():void {
			setCamDir((--view_stat)%4);
		}
		public function gameStart():void {
			putCube();
			game_flg = true;
			
			var game_timer:Timer = new Timer(1500,0);
			game_timer.addEventListener(TimerEvent.TIMER, timeToFall);	
			game_timer.start();
		}
		private function createBox():void {
			setBoxSize(6,14,6);
			boxCube = new Cube( { width:box_width*cube_unit , height:box_height*cube_unit , depth:box_depth*cube_unit ,bothsides:true} );
			boxCube.position = new Vector3D(0, 0.5* box_height*cube_unit , 0);
			
			boxCube.cubeMaterials.left = new WireColorMaterial(0x333333, { alpha:.5 , wireAlpha:0 } );
			boxCube.cubeMaterials.right = new WireColorMaterial(0x333333, { alpha:.5 ,wireAlpha:0});
			boxCube.cubeMaterials.front = new WireColorMaterial(0x666666, { alpha:.5 , wireAlpha:0 } );
			boxCube.cubeMaterials.back = new WireColorMaterial(0x666666, { alpha:.5 , wireAlpha:0 } );
			boxCube.cubeMaterials.top = new WireColorMaterial(0xAAAAAA, { alpha:.5 , wireAlpha:0 } );
			boxCube.cubeMaterials.bottom = new WireColorMaterial(0xFFFFFF, { alpha:0 , wireAlpha:0 } );
		
			view.scene.addChild(boxCube);
		}
		private function setBoxSize(width:Number , height:Number , depth:Number ):void {
			box_width = width;
			box_height = height;
			box_depth = depth;
		}
		private function putCube():void {
			var rnd:int = Math.round(Math.random() * 6) ;
			switch(rnd) {
				case 0: cur_cube = new ICube(view); break;
				case 1:	cur_cube = new LCube(view); break;
				case 2:	cur_cube = new NCube(view); break;
				case 3:	cur_cube = new OCube(view); break;
				case 4:	cur_cube = new TCube(view); break;
				case 5:	cur_cube = new XCube(view); break;
				case 6:	cur_cube = new ZCube(view); break;
			}
			cur_cube.createCube();
			cur_cube.group.position = boxGrid.posNewToOri(new Vector3D(2,13,3));
			if (boxGrid.isCollision(cur_cube))  game_flg = false;  	//game over
			
			cur_cube.createShadowCube();
			cur_cube.shadowCubeMove(boxGrid);
		}
		private function nextCube():void {
			boxGrid.pushOldCube(cur_cube);
			boxGrid.accessGrid(cur_cube);
			view.scene.removeChild(cur_cube.sgroup);
			putCube();
		}
		private function timeToFall(e:TimerEvent):void {
				if (game_flg) {
					cur_cube.group.y -= cube_unit;
					
					//end of this cur_cube
					if (boxGrid.isCollision(cur_cube)) {
						cur_cube.group.y += cube_unit;
						nextCube();
					}	
				}				
		}
		
		public function onKeyDown(e:KeyboardEvent):void
		{
			if (game_flg)
			{
				switch(e.keyCode) {
					//move
					case Keyboard.UP	: 
						switch(view_stat) {
							case 0: cur_cube.moveUp(boxGrid); break;
							case 1: cur_cube.moveRight(boxGrid); break;
							case 2: cur_cube.moveDown(boxGrid); break;
							case 3: cur_cube.moveLeft(boxGrid); break;
						}
						break;
                    case Keyboard.DOWN	: 
						switch(view_stat) {
							case 0: cur_cube.moveDown(boxGrid); break;
							case 1: cur_cube.moveLeft(boxGrid); break;
							case 2: cur_cube.moveUp(boxGrid); break;
							case 3: cur_cube.moveRight(boxGrid); break;
						}
						break;
                    case Keyboard.LEFT	: 
						switch(view_stat) {
							case 0: cur_cube.moveLeft(boxGrid); break;
							case 1: cur_cube.moveUp(boxGrid); break;
							case 2: cur_cube.moveRight(boxGrid); break;
							case 3: cur_cube.moveDown(boxGrid); break;
						}
						break;
                    case Keyboard.RIGHT	:
						switch(view_stat) {
							case 0: cur_cube.moveRight(boxGrid); break;
							case 1: cur_cube.moveDown(boxGrid); break;
							case 2: cur_cube.moveLeft(boxGrid); break;
							case 3: cur_cube.moveUp(boxGrid); break;
						}
						break;
					case Keyboard.SPACE : cur_cube.panDown(boxGrid); nextCube(); break;
					
					//rotation
					case Keyboard.Z	: 
						cur_cube.rorateX(boxGrid); break;
					case Keyboard.X	: 
						cur_cube.rorateY(boxGrid); break;
					case Keyboard.C	: 
						cur_cube.rorateZ(boxGrid); break;	
						
					//rortate Dir
					case Keyboard.Q : rorCamLeft(); break;
					case Keyboard.W : rorCamRight(); break;
				}
			}
		}
		public function update(e:Event):void {			
			view.render();
		}
	}

}