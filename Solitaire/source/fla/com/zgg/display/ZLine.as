package com.zgg.display
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
// ***********************************************
// �Copyright 2008 by Zero G Games, Inc.
// All rights reserved.
//
// This FLASH code library is the confidential and proprietary information of Zero G Games, Inc.
// You shall not disclose such Confidential Information and shall use it only
// in accordance with the terms of the license agreement you entered into with Zero G Games.
// ***********************************************

	public class ZLine extends Sprite
	{
		
		private var oLine:Shape = new Shape;
	
		public function ZLine (tnLineWidth:Number,
								tnLineColor:Number,
								tnLineAlpha:Number,
								tnStartX:Number,
								tnStartY:Number,
								tnEndX:Number,
								tnEndY:Number) 
		{
					
			oLine = draw(tnLineWidth,
							tnLineColor,
							tnLineAlpha,
							tnStartX,
							tnStartY,
							tnEndX,
							tnEndY);
		}
	
		private function draw(tnLineWidth:Number,
								tnLineColor:Number,
								tnLineAlpha:Number,
								tnStartX:Number,
								tnStartY:Number,
								tnEndX:Number,
								tnEndY:Number)
		{
	
			oLine.graphics.lineStyle(tnLineWidth,tnLineColor,tnLineAlpha);
			oLine.graphics.moveTo(tnStartX,tnStartY);
			oLine.graphics.lineTo(tnEndX,tnEndY);
			oLine.graphics.endFill();
            addChild(oLine);
			return oLine;
		}
	}	
}