package com.zerog.utils.geom
{
	import flash.geom.Point;
	import flash.display.DisplayObjectContainer;
	public class Position
	{
		public function Position() {
		}
	
		public static function getGlobal(mc:DisplayObjectContainer):Point {
			var x:Number = 0;
			var y:Number = 0;
			
			while (mc != null) {
				x += mc.x;
				y += mc.y;
				mc = mc.parent;
			}
			
			return new Point(x,y);
		}
	}
}