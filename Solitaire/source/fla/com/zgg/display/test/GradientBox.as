package com.zgg.display.test
{
	import flash.display.GradientType;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    
	public class GradientBox extends Sprite
	{
		public function GradientBox() 
		{
			var myMatrix:Matrix = new Matrix();
             trace(myMatrix.toString());          // (a=1, b=0, c=0, d=1, tx=0, ty=0)
             
             myMatrix.createGradientBox(200, 200, 0, 50, 50);
             trace(myMatrix.toString());          // (a=0.1220703125, b=0, c=0, d=0.1220703125, tx=150, ty=150)
             
             var colors:Array = [0xFF0000, 0x0000FF];
             var alphas:Array = [100, 100];
             var ratios:Array = [0, 0xFF];
             
             this.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, myMatrix);
             this.graphics.drawRect(0, 0, 300, 200);
		}

	}
}
