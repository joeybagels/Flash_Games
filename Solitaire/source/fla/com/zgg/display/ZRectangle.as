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
// Almost all parameters are optional except width and height, and a color.  
// Ususally, you want to set the x and y outside of this class.  Setting StartX and StartY
// will move the circle relative to the registration point of the containing sprite.  That
// means that the container will still be at 0,0 but the circle will have moved inside the container.

	import flash.display.*;
	import flash.geom.Matrix;
	
	//this class now handles round rectangles as well
	
	public class ZRectangle extends MovieClip 
	{	
		// local vars
		private var _nFill:Number;
		private var _nAlpha:Number;
		private var _lineWidth:Number;
		private var _lineColor:Number;
		private var _lineAlpha:Number;
		private var _startX:Number;
		private var _startY:Number;
		private var _nWidth:Number;
		private var _nHeight:Number;
		private var _nRound:Number;
		private var _sGradType:String;
		private var _tFillColors:Array;
		private var _tFillAlphas:Array;
		private var _tFillRadian:Number;
		private var _tFillRatios:Array;
		private var _sSpread:String;
		private var _toFillArea:Object;
	
		public function ZRectangle (oRect:ZRectVO)

		{
			_nFill			= oRect.fillColor;
			_nAlpha 		= oRect.fillAlpha;
			
			_lineWidth 		= oRect.fLineWidth;
			_lineColor 		= oRect.fLineColor;
			_lineAlpha 		= oRect.fLineAlpha;
			//trace("startY: " + oRect.fStartY);
			_startX 		= oRect.fStartX;
			_startY 		= oRect.fStartY;
			_nWidth 		= oRect.fWidth;
			_nHeight 		= oRect.fHeight;
			_nRound			= oRect.fRound;
			
			_sGradType		= oRect.fGradType;
			_tFillColors	= oRect.fFillClrs;
			_tFillAlphas	= oRect.fFillAlphas;
			_tFillRadian	= oRect.fFillRadian;
			_tFillRatios	= oRect.fFillRatios;
			_sSpread		= oRect.fSpread;
			_toFillArea		= oRect.fFillArea;
			
			
			init();
		}
		
		public function init()
		{
			draw();
		}
		
		// handles the manual lineto drawing
		// of the rectangle coordinates being 
		// passed in
		public function draw()
		{
            var child:Shape = new Shape();
            
            //trace("_toFillArea: " + _toFillArea);
            if(_tFillColors) 
			{
				if(_tFillAlphas == null || _tFillRatios == null || _toFillArea == null)
				{
					throw new Error("If you pass gradient colors, you must also set gradient alpha, ratio and area.");
				} else {
					//draws rectangle with gradient fills
					var gMatrix:Matrix = new Matrix();
					gMatrix.createGradientBox(_toFillArea.w, _toFillArea.h, toRadians(_tFillRadian), _startX, _startY);
					//hardcode example: gMatrix.createGradientBox(200, 40, 0, 0, 0);  

					child.graphics.beginGradientFill(_sGradType, _tFillColors, _tFillAlphas, _tFillRatios, gMatrix, _sSpread);
					//hardcode example: child.graphics.beginGradientFill(GradientType.LINEAR, [0xFF0000,0x00FF00, 0x0000FF], [1, 1, 1], [0, 128, 255], gMatrix);
					
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
					
					if(_nRound > 0)
					{
						child.graphics.drawRoundRect(_startX, _startY, _nWidth, _nHeight, _nRound);
					} else {
						child.graphics.drawRect(_startX, _startY, _nWidth, _nHeight);
					}
	   			
	   				addChild(child);
   				}
			}
			else {
				//trace("running regular fill in ZRectangle");
				//draws rectangle with solid fills
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
				
				if(_nRound > 0)
				{
					child.graphics.drawRoundRect(_startX, _startY, _nWidth, _nHeight, _nRound);
				} else {
					child.graphics.drawRect(_startX, _startY, _nWidth, _nHeight);
				}
				
                child.graphics.endFill();
   			
   				addChild(child);
			}

            

        }
        
		public function toRadians(tnDeg):Number
		{
			return tnDeg * Math.PI/180;
		}

		
	}
}