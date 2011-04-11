package com.zgg.display.test
{
	import com.zgg.display.Z3DRectangle;
	import com.zgg.display.ZRectFactory;
	import com.zgg.display.ZRectVO;
	import com.zgg.display.ZRectangle;
	
	import flash.display.*;
	
	public class RectangleTest extends Sprite
	{
		
		public function RectangleTest()
		{
			//ZRectangle usage
			
			//regular fill
			var vo:ZRectVO = new ZRectVO();
			vo.fillColor   = 0xFFCC00;
			vo.fillAlpha   = 1;
			vo.fStartX     = 10;
			vo.fStartY     = 150;
			vo.fWidth      = 100;
			vo.fHeight     = 50;
			var rect = new ZRectangle(vo);
			addChild(rect);
			
			//gradient fill
			var vo2:ZRectVO = new ZRectVO();
			vo2.fLineWidth  = 5;
			vo2.fLineColor  = 0x666666;
			vo2.fLineAlpha  = .7;
			vo2.fStartX     = 10
			vo2.fStartY     = 10;
			vo2.fWidth 		= 100;
			vo2.fHeight 	= 100;
			vo2.fFillClrs 	= [0xFF0000, 0x00FF00, 0x0000FF];
			vo2.fFillAlphas = [1, 1, 1];
			vo2.fFillRadian = 45;
			vo2.fFillRatios = [0, 128, 255];
			vo2.fFillArea   = {w:100,h:100};
			var rect2 = new ZRectangle(vo2);
			addChild(rect2);
			
			//round rect, gradient fill
			var vo3:ZRectVO = new ZRectVO();
			vo3.fLineWidth 	 = 2;
			vo3.fLineColor 	 = 0x333333;
			vo3.fStartX	 	 = 395;
			vo3.fStartY	 	 = 65;
			vo3.fWidth	 	 = 100;
			vo3.fHeight	 	 = 75;
			vo3.fRound  	 = 10;
			vo3.fFillClrs 	 = [0xCCCCCC, 0x666666];
			vo3.fFillAlphas = [1, 1];
			vo3.fFillRatios = [0, 100];
			vo3.fFillArea   = {w:100,h:75};
			var rect5 = new ZRectangle(vo3);
			addChild(rect5);
			
			//ZRectFactory usage
			//single gradient rectangle
			var oZRF:ZRectVO = new ZRectVO();
			oZRF.fStartX	 = 210;
			oZRF.fStartY	 = 65;
			oZRF.fWidth		 = 100;
			oZRF.fHeight	 = 100;
			oZRF.fFillClrs   = [0xFF0000, 0xCCCCCC, 0x333333];
			oZRF.fFillAlphas = [1, 1, 1];
			oZRF.fFillRatios = [0, 128, 255];
			oZRF.fFillRadian = 90;
			oZRF.fFillArea   = {w:100,h:100};
			var rect3 = new ZRectFactory(oZRF);
			addChild(rect3);
			
			
			//multiple rects as array
			var arrObjRf1:ZRectVO 	= new ZRectVO();
			arrObjRf1.fStartX 		= 210;
			arrObjRf1.fStartY 		= 175;
			var arrObjRf2:ZRectVO 	= new ZRectVO();
			arrObjRf2.fStartX 		= 210;
			arrObjRf2.fStartY 		= 230;
			var arrObjRf3:ZRectVO 	= new ZRectVO();
			arrObjRf3.fStartX 		= 210;
			arrObjRf3.fStartY 		= 290;
			var rectArr:Array 	 	= [arrObjRf1, arrObjRf2, arrObjRf3];
			var rect4 = new ZRectFactory(rectArr);
			addChild(rect4);
			
		
			//3D rectangle
			var vo4:ZRectVO 	 = new ZRectVO();
			vo4.fReverseshadow 	 = true;
			vo4.fMaincolor		 = 0xCCCCCC;
			vo4.fHighlightcolor	 = 0xFF0099;
			vo4.fLowlightcolor	 = 0x333333;
			vo4.fShadowcolor	 = 0xFFFF00;
			vo4.fBgcolor		 = 0x000000;
			vo4.fRimcolor		 = 0x999999;
			vo4.fStartX			 = 400;
			vo4.fStartY			 = 300;
			vo4.fWidth			 = 60;
			vo4.fHeight			 = 20;
			var rect6:Z3DRectangle = new Z3DRectangle(vo4);
			addChild(rect6);
		}

	}
}