package game.box 
{
	import flash.geom.Vector3D;
	import game.cube.*;
	import game.box.BoxGrid;
	/**
	 * ...
	 * @author Huaying
	 */
	public class BoxGrid 
	{
		public var box_width:Number;
		public var box_height:Number;
		public var box_depth:Number;
		private const cube_unit:Number = 20;
		
		private var grid_used:Array = [];
		private var layer_used:Array = [];
		
		private var collision_point:Vector3D;
		
		private var old_cubes:Array = [];
		
		public function BoxGrid(width:Number , height:Number , depth:Number) 
		{
			box_width = width;
			box_height = height;
			box_depth = depth;
			
			for (var i:int = 0 ; i < box_width ;++i )
			{
				grid_used[i] = new Array(box_height);
				for (var j:int = 0 ; j < box_height ;++j ){
					grid_used[i][j] = new Array(box_depth);
					for (var k:int = 0 ; k < box_depth ;++k )
						grid_used[i][j][k] = false;
				}
			}
			
			for (j = 0 ; j < box_height ;++j )
			{
				layer_used[j] = box_width*box_depth;
			}
		}	
		public function posOriToNew(v:Vector3D):Vector3D {
			//V' = V + (0.5w -0.5 , -0.5  ,0.5d-0.5)
			v = v.add(new Vector3D((0.5 * box_width -0.5 ) * cube_unit  ,  -0.5 * cube_unit  , (0.5 * box_depth - 0.5) * cube_unit));
			v.scaleBy(1.0/cube_unit);
			return v;
		}
		public function posNewToOri(v:Vector3D):Vector3D {
			// V = V' - (0.5w -0.5 , -0.5  ,0.5d-0.5)
			v.scaleBy(cube_unit);
			return v.subtract(new Vector3D((0.5 * box_width -0.5 )*cube_unit  ,  -0.5 *cube_unit  , (0.5 *box_depth-0.5)*cube_unit));
		}
		public function isCollision(cube:TetrisCube):Boolean {
			for (var i:int = 0; i < 4; ++i ) {
				collision_point = posOriToNew(cube.bcube[i].position.add(cube.group.position));  // real[i] pos = cube[i] pos+ group pos;
				
				//case1. border detection			
				if (collision_point.x >= box_width || collision_point.x < 0 || 
					collision_point.z >= box_depth || collision_point.z < 0 ||
					collision_point.y >= box_height || collision_point.y < 0) 						
					return true;
				
				//case2. grid-used detection
				if(grid_used[collision_point.x][collision_point.y][collision_point.z]) return true;
			}
			return false;
		}
		public function isShadowCollision(cube:TetrisCube):Boolean {
			for (var i:int = 0; i < 4; ++i ) {
				collision_point = posOriToNew(cube.scube[i].position.add(cube.sgroup.position));  // real[i] pos = cube[i] pos+ group pos;
				
				//case1. border detection			
				if (collision_point.x >= box_width || collision_point.x < 0 || 
					collision_point.z >= box_depth || collision_point.z < 0 ||
					collision_point.y >= box_height || collision_point.y < 0) 						
					return true;
				
				//case2. grid-used detection
				if(grid_used[collision_point.x][collision_point.y][collision_point.z]) return true;
			}
			return false;
		}
		public function getCollisionPoint():Vector3D {
			return collision_point;
		}
		public function accessGrid(cube:TetrisCube):void {
			
			//record the grid_used
			var v:Vector3D;
			var ol:int;
			for (var i:int = 0; i < 4; ++i ) {
				v = posOriToNew(cube.bcube[i].position.add(cube.group.position));
				grid_used[v.x][v.y][v.z] = true;
				
				
				//elimination judge
				//if (--layer_used[v.y] == 0) {
				if (--layer_used[v.y] < 8) {	
					ol = old_cubes.length;
					for (var j:int = 0; j < ol ;++j ) {
						old_cubes[j].deleteLayerCube(cube.bcube[i].y + cube.group.y);   //delete and down
					}
					for (var h:int = v.y ; h < box_height ; ++h )
						for (var w:int = 0; w < box_width ; ++w )
							for (var d:int = 0; d < box_depth ; ++d )
								if (h == box_height - 1){ grid_used[w][h][d] = false; layer_used[h] = 36;}
								else { grid_used[w][h][d] =  grid_used[w][h + 1][d]; layer_used[h] = layer_used[h + 1]; }
				}
			}
		}
		public function pushOldCube(cube:TetrisCube):void{
			old_cubes.push(cube);				//save these cubes in order to delete.
		}
	}

}