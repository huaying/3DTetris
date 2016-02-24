package game.cube 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.primitives.Cube;
	import flash.display.Sprite;
	import flash.geom.Vector3D;

	/**
	 * ...
	 * @author Huaying
	 */
	public class LCube extends TetrisCube
	{		
		public function LCube(view:View3D) 
		{
			this.view = view;	
		}	
		public override  function createCube() : void
		{
			group = new ObjectContainer3D();
			bcube[0] = new Cube( { width:cube_unit, height:cube_unit ,depth:cube_unit} );
			bcube[1] = new Cube( { width:cube_unit, height:cube_unit ,depth:cube_unit} );
			bcube[2] = new Cube( { width:cube_unit, height:cube_unit ,depth:cube_unit} );
			bcube[3] = new Cube( { width:cube_unit, height:cube_unit ,depth:cube_unit} );
			
			bcube[0].position = new Vector3D(0, 0, 0);
			bcube[1].position = new Vector3D(cube_unit, 0, 0);
			bcube[2].position = new Vector3D(2*cube_unit, 0, 0);
			bcube[3].position = new Vector3D(0,0 , cube_unit);
	
			ror_origin = bcube[0].position;
				
			group.addChild(bcube[0]);
			group.addChild(bcube[1]);
			group.addChild(bcube[2]);
			group.addChild(bcube[3]);
			
			view.scene.addChild(group);
	
		}
		public override function createShadowCube():void
		{
			sgroup = new ObjectContainer3D();
			scube[0] = new Cube( { width:cube_unit, height:cube_unit ,depth:cube_unit , material:0xDDE0DA} );
			scube[1] = new Cube( { width:cube_unit, height:cube_unit ,depth:cube_unit , material:0xDDE0DA} );
			scube[2] = new Cube( { width:cube_unit, height:cube_unit ,depth:cube_unit , material:0xDDE0DA} );
			scube[3] = new Cube( { width:cube_unit, height:cube_unit ,depth:cube_unit , material:0xDDE0DA} );
			
			scube[0].position = new Vector3D(0, 0, 0);
			scube[1].position = new Vector3D(cube_unit, 0, 0);
			scube[2].position = new Vector3D(2*cube_unit, 0, 0);
			scube[3].position = new Vector3D(0,0 , cube_unit);
			
			sgroup.addChild(scube[0]);
			sgroup.addChild(scube[1]);
			sgroup.addChild(scube[2]);
			sgroup.addChild(scube[3]);
			
			view.scene.addChild(sgroup);
			
		}
	}

}