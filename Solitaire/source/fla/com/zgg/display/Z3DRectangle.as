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

	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class Z3DRectangle extends Sprite 
	{
	
		private var nMaincolor:Number 		= 0;
		private var nHighlightcolor:Number 	= 0;
		private var nLowlightcolor:Number 	= 0;
		private var nShadowcolor:Number 	= 0;
		private var bBgcolor:Number 		= 0;
		private var nRimcolor:Number		= 0;
		private var nStartX:Number 			= 0;
		private var nStartY:Number 			= 0;
		private var nWidth:Number 			= 0;
		private var nHeight:Number 			= 0;
		private var bRevShadow:Boolean		= false;
	
		public function Z3DRectangle (o3DRect:ZRectVO) 
		{
			
			// we have to save due to resizing
			nMaincolor 		= o3DRect.fMaincolor;
			nHighlightcolor	= o3DRect.fHighlightcolor;
			nLowlightcolor	= o3DRect.fLowlightcolor;
			nShadowcolor 	= o3DRect.fShadowcolor;
			bBgcolor 		= o3DRect.fBgcolor;
			nRimcolor 		= o3DRect.fRimcolor;
			
			nStartX			= o3DRect.fStartX;
			nStartY			= o3DRect.fStartY;
			nWidth			= Number(o3DRect.fWidth);
			nHeight			= Number(o3DRect.fHeight);
			
			bRevShadow		= o3DRect.fReverseshadow;
	
			// draw immediately		
			draw();
		}
	
		public function resize(o3DRect:Object):void
		{
			// repositioning / sizing rectangle coordinates
			nStartX			= o3DRect.fStartX;
			nStartY			= o3DRect.fStartY;
			nWidth			= o3DRect.fWidth;
			nHeight			= o3DRect.fWeight;
		
			draw();
		}
	
		// this method handles the actual drawing action
		// the rectangle can either be extruding upward
		// or extruding inward
		private function draw():void
		{		
			
			// checking to make sure we have a 
			// valid outline color
			if(nRimcolor == 0)
				nRimcolor = 0x000000;
			
			// checking which direction we want the 
			// rectangle reflecting light
			if(bRevShadow)
			{
				// shadow rectangle
				var obgRec:ZRectVO = new ZRectVO;
				obgRec.fillColor   = nRimcolor;
				obgRec.fillAlpha   = 1;
				obgRec.fLineAlpha  = 0;
				obgRec.fLineWidth  = 0;
				obgRec.fStartX	   = nStartX;
				obgRec.fStartY	   = nStartY;
				obgRec.fWidth	   = nWidth;
				obgRec.fHeight	   = nHeight;
				var tempRect = new ZRectangle(obgRec);
				addChild(tempRect);
		
				// main rectangle
				var obgRec2:ZRectVO = new ZRectVO;
				obgRec2.fillColor   = nRimcolor;
				obgRec2.fillAlpha   = 1;
				obgRec2.fLineAlpha  = 0;
				obgRec2.fLineWidth  = 0;
				obgRec2.fStartX		= nStartX+1;
				obgRec2.fStartY		= nStartY+1;
				obgRec2.fWidth	    = nWidth-1;
				obgRec2.fHeight	    = nHeight-1;
				var tempRect2 = new ZRectangle(obgRec2);
				addChild(tempRect2);

				// LINES    ------------------------------------------------------
				//(tnLineWidth,tnLineColor,tnLineAlpha,tnStartX,tnStartY,tnEndX,tnEndY)
				// highlight trim
				var line:ZLine = new ZLine(1,nLowlightcolor,1,nStartX+1,(nStartY + nHeight),(nStartX + nWidth)-1,(nStartY + nHeight));
				addChild(line);
				var line2:ZLine = new ZLine(1,nHighlightcolor,1,nStartX+1,(nStartY + nHeight)-1,(nStartX + nWidth)-1,(nStartY + nHeight)-1);
				addChild(line2);		
				var line3:ZLine = new ZLine(1,nHighlightcolor,1,(nStartX + nWidth)-1,nStartY+1,(nStartX + nWidth)-1,(nStartY+nHeight)-1);
				addChild(line3);
				var line4:ZLine = new ZLine(1,nLowlightcolor,1,(nStartX + nWidth),nStartY+1,(nStartX + nWidth),(nStartY+nHeight));
				addChild(line4);
				
				// darker trim
				var line5:ZLine = new ZLine(1,nShadowcolor,1,nStartX+1,nStartY+1,(nStartX + nWidth)-1,nStartY+1);
				addChild(line5);
				var line6:ZLine = new ZLine(1,nShadowcolor,1,nStartX+1,nStartY+1,nStartX+1,(nStartY+nHeight)-2);
				addChild(line6);
			}
			else
			{
				// shadow rectangle
				var obgRec3:ZRectVO = new ZRectVO;
				obgRec3.fillColor   = nRimcolor;
				obgRec3.fillAlpha   = 1;
				obgRec3.fLineAlpha  = 0;
				obgRec3.fLineWidth  = 0;
				obgRec3.fStartX	   = nStartX+1;
				obgRec3.fStartY	   = nStartY+1;
				obgRec3.fWidth	   = nWidth;
				obgRec3.fHeight	   = nHeight;
				var tempRect3 = new ZRectangle(obgRec3);
				addChild(tempRect3);
		
				// main rectangle
				var obgRec4:ZRectVO = new ZRectVO;
				obgRec4.fillColor   = nRimcolor;
				obgRec4.fillAlpha   = 1;
				obgRec4.fLineAlpha  = 0;
				obgRec4.fLineWidth  = 0;
				obgRec4.fStartX		= nStartX;
				obgRec4.fStartY		= nStartY;
				obgRec4.fWidth	    = nWidth;
				obgRec4.fHeight	    = nHeight;
				var tempRect4 = new ZRectangle(obgRec4);
				addChild(tempRect4);
				
				// LINES    ------------------------------------------------------
						
				// highlight trim
				var line7:ZLine = new ZLine(1,nLowlightcolor,1,nStartX+1,(nStartY + nHeight),(nStartX + nWidth)-1,(nStartY + nHeight));
				addChild(line7);
				var line8:ZLine = new ZLine(1,nHighlightcolor,1,nStartX+1,(nStartY + nHeight)-1,(nStartX + nWidth)-1,(nStartY + nHeight)-1);
				addChild(line8);		
				var line9:ZLine = new ZLine(1,nHighlightcolor,1,(nStartX + nWidth)-1,nStartY+1,(nStartX + nWidth)-1,(nStartY+nHeight)-1);
				addChild(line9);
				var line10:ZLine = new ZLine(1,nLowlightcolor,1,(nStartX + nWidth),nStartY+1,(nStartX + nWidth),(nStartY+nHeight));
				addChild(line10);
				
				// darker trim
				var line11:ZLine = new ZLine(1,nShadowcolor,1,nStartX+1,nStartY+1,(nStartX + nWidth)-1,nStartY+1);
				addChild(line11);
				var line12:ZLine = new ZLine(1,nShadowcolor,1,nStartX+1,nStartY+1,nStartX+1,(nStartY+nHeight)-2);
				addChild(line12);

			}
		}
	}
}