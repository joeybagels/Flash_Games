package com.zerog.effects.laser
{
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class Laser
	{
		private var laserShape:Shape;
		
		public function Laser()
		{
			this.laserShape = new Shape();
		}
		
		public function getLaserShape():Shape {
			return this.laserShape;
		}
		
		public function drawLaser(laserShape:Shape, innerColor:Number, outerColor:Number, destination:Point, source:Point, lineThickness:Number, glow:Number):void {
			
			laserShape.graphics.clear();
			laserShape.graphics.moveTo(destination.x,destination.y);
			
			//draw the other a littel longer
			laserShape.graphics.lineStyle(lineThickness + glow, outerColor, .3);
			laserShape.graphics.lineTo (source.x,source.y);
			
			laserShape.graphics.lineStyle(lineThickness + glow/2, outerColor, .6);
			laserShape.graphics.lineTo (destination.x,destination.y);
			
			laserShape.graphics.lineStyle(lineThickness, innerColor, 1);
			laserShape.graphics.lineTo (source.x,source.y);
		}
	}
}