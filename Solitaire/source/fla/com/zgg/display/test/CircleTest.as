package com.zgg.display.test
{

	import com.zgg.display.ZCircleVO;
	import com.zgg.display.ZCircle;
	
	import flash.display.*;
	
	public class CircleTest extends Sprite
	{
		
		public function CircleTest()
		{
			//ZCirlce usage
			
			//regular fill
			var vo:ZCircleVO = new ZCircleVO();
			vo.fillColor   	= 0xFFCC00;
			vo.fillAlpha   	= 1;
			vo.fStartX     	= 150; //relative to registration pt. of parent display obj.
			vo.fStartY     	= 150; //relative to registration pt. of parent display obj.
			vo.fRadius		= 50;
			var circle1 = new ZCircle(vo);
			addChild(circle1);
			
			//gradient fill
			var vo2:ZCircleVO = new ZCircleVO();
			vo2.fLineWidth  = 5;
			vo2.fLineColor  = 0x666666;
			vo2.fLineAlpha  = .7;
			vo2.fStartX     = 350
			vo2.fStartY     = 250;
			vo2.fRadius		= 150;
			vo2.fFillClrs 	= [0xFF0000, 0x00FF00, 0x0000FF];
			vo2.fFillAlphas = [1, 1, 1];
			vo2.fFillRadian = 45;
			vo2.fFillRatios = [0, 128, 255];
			vo2.fFillArea   = {w:100,h:100};
			var circle2 = new ZCircle(vo2);
			addChild(circle2);
		}

	}
}