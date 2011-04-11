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

	import flash.display.Sprite;
	import com.zgg.display.ZRectangle;
	import com.zgg.display.ZRectVO;
	
	public class ZRectFactory extends Sprite
	{
		
		public function ZRectFactory(taRectangles:Object):void
		{
				if(!(taRectangles is Array))
				{
					trace("running Zfactory in single object");
					createRect(taRectangles);
				}
				else
				{
					//looping through all rects
					for(var rects:Number = 0;rects < taRectangles.length; rects++)
					{
						trace("running Zfactory in array parsing");
						createRect(taRectangles[rects]);
					}
				}
		}
	
		private function createRect(newRect:Object):void
		{
			//	var oRect:ZRectVO = new ZRectVO();
				trace("Zfactory startX: " + newRect.fStartX);
				var oBackFile = new ZRectangle(newRect as ZRectVO);
				addChild(oBackFile);

		}
	
	}
}