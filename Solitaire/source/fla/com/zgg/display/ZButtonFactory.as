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
	
	public class ZButtonFactory extends Sprite
	{
	
		public function ZButtonFactory(taButtons:Object):void
		{
			if(!(taButtons is Array)) //will run even if used for only a simgle button
				{
					createButton(taButtons);
				}
				else
				{
					//looping through all btns
					for(var btns:Number = 0;btns < taButtons.length;btns++)
					{
						createButton(taButtons[btns]);
					}
				}
		}
		

		public function createButton(newBtn:Object):void
		{
			var oNewButton = new ZButton(newBtn as ZButtonVO);
				addChild(oNewButton);
	
		}
		

		
	}
}