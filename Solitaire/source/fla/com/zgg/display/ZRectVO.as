package com.zgg.display
{
	import flash.display.*;
	
// ***********************************************
// �Copyright 2008 by Zero G Games, Inc.
// All rights reserved.
//
// This FLASH code library is the confidential and proprietary information of Zero G Games, Inc.
// You shall not disclose such Confidential Information and shall use it only
// in accordance with the terms of the license agreement you entered into with Zero G Games.
// ***********************************************


	
	// this class allows obj params to be used to draw a rectangle or round rectangle
	public class ZRectVO 
	{
		private var nFill:Number 	 	= 0x999999;
		private var nAlpha:Number 	 	= 0;
		private var lineWidth:Number 	= 0;
		private var lineColor:Number 	= 0x000000;
		private var lineAlpha:Number 	= 0;
		private var startX:Number	 	= 0;
		private var startY:Number	 	= 0;
		private var newX:Number		 	= 0;
		private var newY:Number		 	= 0;
		private var nWidth:Number	 	= 25;
		private var nHeight:Number	 	= 25;
		private var nRound:Number	   	= 0;
		private var sGradType:*  		= GradientType.LINEAR;
		private var tFillColors:Array  	= null;
		private var tFillAlphas:Array  	= null;
		private var tFillRadian:Number 	= 0;
		private var tFillRatios:Array  	= null;
		private var sSpread:String		= SpreadMethod.PAD;
		private var toFillArea:Object 	= undefined;
		private var nReverseshadow 	   	= true;
		private var nMaincolor;
		private var nHighlightcolor	   	= 0xFFFFFF;
		private var nLowlightcolor	   	= 0x333333;
		private var nShadowcolor	 	= 0x666666;
		private var nBgcolor			= 0x999999;
		private var nRimcolor			= 0;
	
		public function ZRectVO () 
		{
			
		}	

		
		public function set fillColor(fill:Number):void
		{
			this.nFill = fill;
		}
		
		public function set fillAlpha(alpha:Number):void
		{
			this.nAlpha = alpha;
		}
		
		public function set fLineWidth(lWidth:Number):void
		{
			this.lineWidth = lWidth;
		}
		
		public function set fLineColor(lColor:Number):void
		{
			this.lineColor = lColor;
		}
		
		public function set fLineAlpha(lAlpha:Number):void
		{
			lineAlpha = lAlpha;
		}
		
		public function set fStartX(x:Number):void
		{
			startX = x;
		}
		
		public function set fStartY(y:Number):void
		{
			startY = y;
		}
		
		public function set fNewX(nx:Number):void
		{
			newX = nx;
		}
		
		public function set fNewY(ny:Number):void
		{
			newY = ny;
		}
		
		public function set fWidth(w:Number):void
		{
			nWidth = w;
		}
		
		public function set fHeight(h:Number):void
		{
			nHeight = h;
		}
		
		public function set fRound(round:Number):void
		{
			nRound = round;
		}
		
		public function set fGradType(gtype:String):void
		{
			sGradType = gtype;
		}
		
		public function set fFillClrs(fc:Array):void
		{
			tFillColors = fc;
		}
		
		public function set fFillAlphas(fa:Array):void
		{
			tFillAlphas = fa;
		}
		
		public function set fFillRadian(fillRadian:Number):void
		{
			tFillRadian = fillRadian;
		}
		
		public function set fFillRatios(fillRatios:Array):void
		{
			tFillRatios = fillRatios;
		}
		
		public function set fSpread(spread:String):void
		{
			sSpread = spread;
		}
		
		public function set fFillArea(fillArea:Object):void
		{
			toFillArea  = fillArea;
		}
		
		public function set fReverseshadow(rshadow:Boolean):void
		{
			nReverseshadow = rshadow;
		}
		
		public function set fMaincolor(mcolor:Number):void
		{
			nMaincolor = mcolor;
		}
		
		public function set fHighlightcolor(hilitecolor:Number):void
		{
			nHighlightcolor = hilitecolor;
		}
		
		public function set fLowlightcolor(lolitecolor:Number):void
		{
			nLowlightcolor = lolitecolor;
		}
		
		public function set fShadowcolor(shadowcolor:Number):void
		{
			nShadowcolor = shadowcolor;
		}
		
		public function set fBgcolor(bgcolor:Number):void
		{
			nBgcolor = bgcolor;
		}
		
		public function set fRimcolor(rimcolor:Number):void
		{
			nRimcolor = rimcolor;
		}
		
		
		
		public function get fillColor():Number
		{
			return nFill;
		}
		
		public function get fillAlpha():Number
		{
			return nAlpha;
		}
		
		public function get fLineWidth():Number
		{
			return lineWidth;
		}
		
		public function get fLineColor():Number
		{
			return lineColor;
		}
		
		public function get fLineAlpha():Number
		{
			return lineAlpha;
		}
		
		public function get fStartX():Number
		{
			return startX;
		}
		
		public function get fStartY():Number
		{
			return startY;
		}
		
		public function get fNewX():Number
		{
			return newX;
		}
		
		public function get fNewY():Number
		{
			return newY;
		}
		
		public function get fWidth():Number
		{
			return nWidth;
		}
		
		public function get fHeight():Number
		{
			return nHeight;
		}
		
		public function get fRound():Number
		{
			return nRound;
		}
		
		public function get fGradType():String
		{
			return sGradType;
		}
		
		public function get fFillClrs():Array
		{
			return tFillColors;
		}
		
		public function get fFillAlphas():Array
		{
			return tFillAlphas;
		}
		
		public function get fFillRadian():Number
		{
			return tFillRadian;
		}
		
		public function get fFillRatios():Array
		{
			return tFillRatios;
		}
		
		public function get fSpread():String
		{
			return sSpread;
		}
		
		public function get fFillArea():Object
		{
			return toFillArea;
		}
		
		public function get fReverseshadow()
		{
			return nReverseshadow;
		}
		
		public function get fMaincolor()
		{
			return nMaincolor;
		}
		
		public function get fHighlightcolor()
		{
			return nHighlightcolor;
		}
		
		public function get fLowlightcolor()
		{
			return nLowlightcolor;
		}
		
		public function get fShadowcolor()
		{
			return nShadowcolor;
		}
		
		public function get fBgcolor()
		{
			return nBgcolor;
		}
		
		public function get fRimcolor()
		{
			return nRimcolor;
		}
	}
}