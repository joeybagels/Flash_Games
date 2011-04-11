package com.zerog.effects.electricity
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Example:
	 * 
	 * <code>
	 * import com.zerog.effects.electricity.*;
	 * 
	 * var e:Electricity = new Electricity(200,200);
	 * addChild(e.getAnimatedElectricityBitmap());
	 * 
	 * addEventListener(Event.ENTER_FRAME, onEnterFrame);
	 * 
	 * function onEnterFrame(event:Event):void {
	 *     e.animatedElectricityStep(new Point(0,0), new Point(200,200), 0x000000);
	 * }
	 * </code>
	*/
	public class Electricity
	{
		private var electricityShape:Shape;
		private var filter:ColorMatrixFilter;
		private var bitmapData:BitmapData;
		private var bitmap:Bitmap; 
		private var animationWidth:Number;
		private var animationHeight:Number;
		/**
		 * @param width the width of the electricity animation effect
		 * @param height the height of the electrity animation effect
		 * @param fadeRatio the amount to fade the electricity with each step
		 */
		public function Electricity(animationWidth:Number = 0, animationHeight:Number = 0, fadeRatio:Number = 0.7) {
			this.animationWidth = animationWidth;
			this.animationHeight = animationHeight;
			
			//create the filter to alpha out the lightning
			var matrix:Array = new Array();
			matrix = matrix.concat([1, 0, 0, 0, 0]);// red
			matrix = matrix.concat([0, 1, 0, 0, 0]);// green
			matrix = matrix.concat([0, 0, 1, 0, 0]);// blue
			matrix = matrix.concat([0, 0, 0, fadeRatio, 0]);// alpha
			
			this.filter = new ColorMatrixFilter(matrix);
			
			//create a transparent bitmap that we will draw to
			this.bitmapData = new BitmapData(animationWidth, animationHeight, true, 0x000000);
			this.bitmap = new Bitmap(this.bitmapData);
			
			this.electricityShape = new Shape();
			
		}

		/**
		 * Get the bitmap that the animation is drawn on
		 */
		public function getAnimatedElectricityBitmap():Bitmap {
			return this.bitmap;
		}
		
		public function clearAnimation():void {
			this.bitmapData.fillRect(this.bitmapData.rect,0);
		}
		
		/**
		 * This function should be called consistently to step through the animation
		 */
		public function animatedLightningElectricityStep(source:Point, destination:Point, color:Number, thickness:Number):void {
			this.bitmapData.applyFilter(this.bitmapData, new Rectangle(0, 0, this.animationWidth, this.animationHeight), new Point(0, 0), filter);
			
			drawLightningElectricity(this.electricityShape, color, destination, source, thickness)

			this.bitmapData.draw(this.electricityShape);
		}
		
		/**
		 * This function should be called consistently to step through the animation
		 */
		public function animatedElectricityStep(source:Point, destination:Point, color:Number, thickness:Number):void {
			this.bitmapData.applyFilter(this.bitmapData, new Rectangle(0, 0, this.animationWidth, this.animationHeight), new Point(0, 0), this.filter);
			
			drawElectricity(this.electricityShape, color, destination, source, thickness)

			this.bitmapData.draw(this.electricityShape);
		}
		
		public function drawElectricity(electricityShape:Shape, color:Number, destination:Point, source:Point, lineThickness:Number):void {
			var dx:Number =  destination.x -  source.x;
			var dy:Number =  destination.y -  source.y;
			var dist:Number = Math.floor(Math.sqrt(dx * dx + dy * dy));
			var radians:Number = Math.atan2(dy, dx);
			var theAngle:Number = radians * 180 / Math.PI;
			
			electricityShape.graphics.clear();
			electricityShape.graphics.lineStyle(lineThickness, color);
			electricityShape.graphics.moveTo(destination.x,destination.y);
		
			var traveled:Number = 0;
			//var lineThickness:Number = 3;
			var prevX:Number = destination.x;
			var prevY:Number = destination.y;
			
			while (traveled < dist - 30) {
				
				var speed:Number = Math.random()*2 + 10;
				var tmpAngle:Number = theAngle * Math.PI / 180;
				var bx:Number = traveled * Math.cos (tmpAngle);
				var by:Number = traveled * Math.sin (tmpAngle);
				traveled += speed;
				var theX:Number = (destination.x - bx) + Math.random ()*20 - 10;
				var theY:Number = (destination.y - by) + Math.random ()*10 - 5;
				//lineThickness = (traveled / dist) * 10 + 1;
				
				//draw the outer
				electricityShape.graphics.lineStyle(lineThickness, color);
				electricityShape.graphics.lineTo (theX, theY);
				
				//draw the white inner
				electricityShape.graphics.moveTo(prevX, prevY);
				electricityShape.graphics.lineStyle(Math.floor(lineThickness/3), 0xffffff);
				electricityShape.graphics.lineTo (theX, theY);
				
				//save previous
				prevX = theX;
				prevY = theY;
			}
			
			//draw the outer
			electricityShape.graphics.lineStyle(lineThickness, color);
			electricityShape.graphics.lineTo (source.x, source.y);
				
			//draw the white inner
			electricityShape.graphics.moveTo (prevX, prevY);
			electricityShape.graphics.lineStyle(Math.floor(lineThickness/3), 0xffffff);
			electricityShape.graphics.lineTo (source.x, source.y);
		}
		
		/**
		 * Draws lightning electricity on the given shape
		 */
		public function drawLightningElectricity(electricityShape:Shape, color:Number, destination:Point, source:Point, lineThickness:Number):void {
			var dx:Number =  destination.x -  source.x;
			var dy:Number =  destination.y -  source.y;
			var dist:Number = Math.floor(Math.sqrt(dx * dx + dy * dy));
			var radians:Number = Math.atan2(dy, dx);
			var theAngle:Number = radians * 180 / Math.PI;
			
			electricityShape.graphics.clear();
			electricityShape.graphics.lineStyle(5, color, 1);
			electricityShape.graphics.moveTo(destination.x,destination.y);
		
			var traveled:Number = 0;
			//var lineThickness:Number = 5;
			while (traveled < dist - 30) {
				
				var speed:Number = Math.random()*2 + 10;
				var tmpAngle:Number = theAngle * Math.PI / 180;
				var bx:Number = traveled * Math.cos (tmpAngle);
				var by:Number = traveled * Math.sin (tmpAngle);
				traveled += speed;
				var theX:Number = (destination.x - bx) + Math.random ()*20 - 10;
				var theY:Number = (destination.y - by) + Math.random ()*10 - 5;
				lineThickness = (traveled / dist) * 10 + 1;
				electricityShape.graphics.lineStyle (lineThickness, color, 70);
				electricityShape.graphics.lineTo (theX, theY);
			}
			
			electricityShape.graphics.lineTo (source.x,source.y);
		
		}
	}
}