package com.zgg.display
{
	
// ***********************************************
// �Copyright 2008 by Zero G Games, Inc.
// All rights reserved.
//
// This FLASH code library is the confidential and proprietary information of Zero G Games, Inc.
// You shall not disclose such Confidential Information and shall use it only
// in accordance with the terms of the license agreement you entered into with Zero G Games.
// ***********************************************

// To use, call an instance of ZCircleVO and use that object to set
// the desired parameters. Then just call this class and pass in that object.
// Ususally, you want to set the x and y outside of this class.  Setting StartX and StartY
// will move the circle relative to the registration point of the containing sprite.  That
// means that the container will still be at 0,0 but the circle will have moved inside the container.

	import flash.display.*;
	import flash.geom.Matrix;
    
	public class ZCircle extends MovieClip
	{
		private var _nFill:Number;
		private var _nAlpha:Number;
		private var _lineWidth:Number;
		private var _lineColor:Number;
		private var _lineAlpha:Number;
		private var _startX:Number;
		private var _startY:Number;
		private var _nWidth:Number;
		private var _nHeight:Number;
		private var _nRadius:Number;
		private var _sGradType:String;
		private var _tFillColors:Array;
		private var _tFillAlphas:Array;
		private var _tFillRadian:Number;
		private var _tFillRatios:Array;
		private var _sSpread:String;
		private var _toFillArea:Object;
        
		public function ZCircle(oCirc:Object)
		{

			_nFill			= oCirc.fillColor;
			_nAlpha 		= oCirc.fillAlpha;
			
			_lineWidth 		= oCirc.fLineWidth;
			_lineColor 		= oCirc.fLineColor;
			_lineAlpha 		= oCirc.fLineAlpha;

			_startX 		= oCirc.fStartX;
			_startY 		= oCirc.fStartY;
			_nRadius		= oCirc.fRadius;
			
			_sGradType		= oCirc.fGradType;
			_tFillColors	= oCirc.fFillClrs;
			_tFillAlphas	= oCirc.fFillAlphas;
			_tFillRadian	= oCirc.fFillRadian;
			_tFillRatios	= oCirc.fFillRatios;
			_sSpread		= oCirc.fSpread;
			_toFillArea		= oCirc.fFillArea;
			
			init();
		}
		
		public function init()
		{
			draw();
		}
		
		
		public function draw()
		{
            var child:Shape = new Shape();
            
            if(_tFillColors) 
			{
				if(_tFillAlphas == null || _tFillRatios == null || _toFillArea == null)
				{
					throw new Error("If you pass gradient colors, you must also set gradient alpha, ratio and area.");
				} else {
					//draws circle with gradient fills
					var gMatrix:Matrix = new Matrix();
					
					//hardcode example: gMatrix.createGradientBox(200, 40, 0, 0, 0);  
					gMatrix.createGradientBox(_toFillArea.w, _toFillArea.h, toRadians(_tFillRadian), _startX, _startY);
					
					//hardcode example: child.graphics.beginGradientFill(GradientType.LINEAR, [0xFF0000,0x00FF00, 0x0000FF], [1, 1, 1], [0, 128, 255], gMatrix);
					child.graphics.beginGradientFill(_sGradType, _tFillColors, _tFillAlphas, _tFillRatios, gMatrix, _sSpread);
					
					if(_lineWidth > 0)
					{
					child.graphics.lineStyle(_lineWidth,_lineColor);
					}
					
					// eliminating a nice bug
					// where lines have trailing
					// pixels
		            if(_lineAlpha > .01)
					{
						_nWidth--;
						_nHeight--;
					}

					child.graphics.drawCircle(_startX, _startY, _nRadius);
					
	   				addChild(child);
   				}
			}
			else {

				//draws circle with solid fills
				child.graphics.beginFill(_nFill,_nAlpha);
				if(_lineWidth > 0)
					{
	            		child.graphics.lineStyle(_lineWidth,_lineColor);
	    			}
	    			
	            // eliminating a nice bug
				// where lines have trailing
				// pixels
	            if(_lineAlpha > .01)
				{
					_nWidth--;
					_nHeight--;
				}
				
				child.graphics.drawCircle(_startX, _startY, _nRadius);
				
                child.graphics.endFill();
   				trace("child.x in ZCircle: " + child.x);
   				addChild(child);
			}

            

        }
        
		public function toRadians(tnDeg):Number
		{
			return tnDeg * Math.PI/180;
		}

	}
}