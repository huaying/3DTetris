package game.cube 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.primitives.Cube;
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	import game.box.BoxGrid;
	/**
	 * ...
	 * @author Huaying
	 */
	public class TetrisCube extends Sprite
	{
		public static const cube_unit:int = 20;
		public var bcube:Array = [];				//base cube 
		public var scube:Array = [];				//shadow cube
		public var group:ObjectContainer3D;
		public var sgroup:ObjectContainer3D;
		
		internal var view:View3D;
		internal var ror_origin:Vector3D;
		private const COS90:int = 0;
		private const SIN90:int = 1;
		
		public function TetrisCube():void {}
		public function createCube() : void { }
		public function createShadowCube():void { }
		public function deleteLayerCube(layer:int):void {
			for (var i:int = 0 ; i < 4;++i )
			{
				if (layer == bcube[i].y + group.y ) {
					group.removeChild(bcube[i]);
				}
				if (layer < bcube[i].y + group.y ) {
					bcube[i].y -= cube_unit;
				}
			}	
		}
		public  function moveLeft(boxGrid:BoxGrid):void {
			group.x -= cube_unit;
			//adjust ... collision
			if (boxGrid.isCollision(this)) {
				group.x += cube_unit;
			}
			shadowCubeMove(boxGrid);	
		}
		public  function moveRight(boxGrid:BoxGrid):void {
			group.x += cube_unit;
			if (boxGrid.isCollision(this)) {
				group.x -= cube_unit;
			}
			shadowCubeMove(boxGrid);
		}
		public  function moveUp(boxGrid:BoxGrid):void {
			group.z += cube_unit;
			
			//adjust ... collision
			if (boxGrid.isCollision(this)) {
				group.z -= cube_unit;
			}
			shadowCubeMove(boxGrid);
		}
		public  function moveDown(boxGrid:BoxGrid):void {
			group.z -= cube_unit;
			
			//adjust ... collision
			if (boxGrid.isCollision(this)) {
				group.z += cube_unit;
			}
			shadowCubeMove(boxGrid);
		}
		public  function panDown(boxGrid:BoxGrid):void {
			while (!boxGrid.isCollision(this))group.y -= cube_unit;
			group.y += cube_unit;	
		}
		public function shadowCubeMove(boxGrid:BoxGrid):void {
					
			sgroup.position = group.position.clone();
			for (var i:int = 0; i < 4;++i )scube[i].position = bcube[i].position.clone();
			
			while (!boxGrid.isShadowCollision(this))sgroup.y -= cube_unit;
			sgroup.y += cube_unit;	
		}
		public function rorateX(boxGrid:BoxGrid):void { 
			/*
			 *	rotation could modify its position by counting the origin and the collision point 
			 *  but three times at most
			 */
			var v:Vector3D ; 
			var old_bcube_vector:Array = [];
			var y:int , z:int;
			for (var i:int = 0; i < 4;++i )
			{	
				old_bcube_vector[i] = bcube[i].position.clone();
				v = bcube[i].position.subtract(ror_origin);		
				y = v.y * COS90 - v.z * SIN90;
				z = v.y * SIN90 + v.z * COS90;
				bcube[i].position = new Vector3D(v.x, y, z).add(ror_origin);
				//trace(i,v.x, y, z );
			}		
			//adjust ... collision
			if (!adjustCollision(boxGrid)) for (i = 0; i < 4;++i ) bcube[i].position = old_bcube_vector[i];
			
			shadowCubeMove(boxGrid);
		}
		public function rorateY(boxGrid:BoxGrid):void {
		
			//	rotation could modify its position by counting the origin and the collision point 
			//  but three times at most
			//
			var v:Vector3D; 
			var old_bcube_vector:Array = [];
			var x:int , z:int;
			for (var i:int = 0; i < 4;++i )
			{
				old_bcube_vector[i] = bcube[i].position.clone();
				v = bcube[i].position.subtract(ror_origin);	
				x = v.x * COS90 - v.z * SIN90;
				z = v.x * SIN90 + v.z * COS90;
				bcube[i].position = new Vector3D(x, v.y, z).add(ror_origin);
				//trace(i,x, v.y, z );
				
			}	
			//adjust ... collision
			if (!adjustCollision(boxGrid)) for (i = 0; i < 4;++i ) bcube[i].position = old_bcube_vector[i];
			
			shadowCubeMove(boxGrid);
		}
		public function rorateZ(boxGrid:BoxGrid):void {
			/*
			 *	rotation could modify its position by counting the origin and the collision point 
			 *  but three times at most
			 */
			var v:Vector3D; 
			var old_bcube_vector:Array = [];
			var x:int , y:int;
			for (var i:int = 0; i < 4;++i )
			{
				old_bcube_vector[i] = bcube[i].position.clone();
				v = bcube[i].position.subtract(ror_origin);	
				x = v.x * COS90 - v.y * SIN90;
				y = v.x * SIN90 + v.y * COS90;
				bcube[i].position = new Vector3D(x, y, v.z).add(ror_origin);
				//trace(i,x, y, z.y );
			}		
			//adjust ... collision
			if (!adjustCollision(boxGrid)) for (i = 0; i < 4;++i ) bcube[i].position = old_bcube_vector[i];
			
			shadowCubeMove(boxGrid);
		}
		public function adjustCollision(boxGrid:BoxGrid):Boolean { 
			//adjust ...rotation collision
			// every dir only adjuct to correct position 2 times at most
			// if it couldn't be adjust then it's infinite loop
			var adjust_count:int = 2;
			var old_group_vector:Vector3D = group.position.clone();
			var v:Vector3D; 
			while (boxGrid.isCollision(this) && adjust_count>0)
			{				
				v = boxGrid.getCollisionPoint().subtract(boxGrid.posOriToNew(ror_origin.add(group.position)));
				
				if( v.x > 0 ) 	group.x -= cube_unit;
				if(	v.x < 0 )	group.x += cube_unit;
				if(	v.z > 0 )	group.z -= cube_unit;
				if(	v.z < 0 )	group.z += cube_unit;
				if(	v.y > 0 )	group.y -= cube_unit;
				if(	v.y < 0 ) 	group.y += cube_unit;					
				adjust_count--;	
				//trace(v.x, v.y, v.z);
			}
			if (boxGrid.isCollision(this)) { group.position = old_group_vector; return false; }
			else return true;
		}
	}
	
}