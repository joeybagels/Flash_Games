package com.zgg.display
{
// ***********************************************
// ©Copyright 2008 by Zero G Games, Inc.
// All rights reserved.
//
// This FLASH code library is the confidential and proprietary information of Zero G Games, Inc.
// You shall not disclose such Confidential Information and shall use it only
// in accordance with the terms of the license agreement you entered into with Zero G Games.
// ***********************************************

	import flash.display.*;
	import flash.text.*;
	
	public class ZText extends Sprite
	{
		public var s:Sprite;
		public var tf:TextField = new TextField;
		public var shadowtf:TextField;
		

		public function ZText(ozt:ZTextVO)
		{
			s = new Sprite;
			s.x	= ozt.fX;
			s.y = ozt.fY;
			addChild(s);
			
			tf.width 		= ozt.fW; //all these are optional except ftext, fFont)
			tf.height 		= ozt.fH;
			tf.selectable 	= ozt.fSelectable;
			tf.mouseEnabled = ozt.fMouse;
			tf.embedFonts 	= ozt.fEmbed;
			tf.textColor 	= ozt.fColor;
			tf.multiline	= ozt.fMulti;
			tf.wordWrap 	= ozt.fWrap;
			tf.autoSize		= ozt.fAuto;
			tf.border 		= ozt.fBorder;
			tf.background 	= ozt.fBg;
			tf.text			= ozt.fText;
			tf.name			= ozt.fName;
			
			if(tf.background) //default is no bg color in the textfield
			{
				tf.backgroundColor = ozt.fBgcolor;
			}
			
			formatTF(ozt,tf); //must do a TextFormat in AS3 to apply font, bold and size
			
			if(ozt.fShadow) //default is no dropshadow
			{
				addShadow(ozt,tf);
			}
		}
	
		public function formatTF(ozt:ZTextVO,tf:TextField)
		{
			var tfFormat:TextFormat = new TextFormat();
			
			if(ozt.fFont != null)
			{
			var myFont = ozt.fFont;
			var newFont:Font = new myFont();
			tfFormat.font 		= newFont.fontName;
			}

			tfFormat.bold 		= ozt.fBold;
			tfFormat.size		= ozt.fSize;
			tf.setTextFormat(tfFormat);

			s.addChild(tf);
		}
		
		public function addShadow(ozt:ZTextVO, tf:TextField)
		{
			//duplicates the main textfield in gray, offset by 2 pixels
			shadowtf = new TextField();
			shadowtf.text 		= tf.text;
			shadowtf.x 			= 1;
			shadowtf.y 			= 1;
			shadowtf.alpha 		= .45;
			shadowtf.width 		= ozt.fW;
			shadowtf.height 	= ozt.fH+2;
			shadowtf.selectable	= ozt.fSelectable;
			shadowtf.embedFonts = ozt.fEmbed;
			shadowtf.wordWrap	= ozt.fWrap;
			shadowtf.multiline	= ozt.fMulti;
			shadowtf.autoSize	= ozt.fAuto;
			shadowtf.border 	= false;
			shadowtf.textColor 	= 0x000000;
			
			if(tf.background == "true")
			{
				shadowtf.backgroundColor = ozt.fBgcolor;
			}
			
			var shadowFormat:TextFormat = new TextFormat();
			if(ozt.fFont != null)
			{
			var myShadowFont 			= ozt.fFont;
			var newShadowFont:Font 		= new myShadowFont();
			shadowFormat.font 			= newShadowFont.fontName;
			}
			shadowFormat.size 			= ozt.fSize;
			shadowFormat.bold			= ozt.fBold;
			shadowtf.setTextFormat(shadowFormat);
			
			s.addChildAt(shadowtf, 0);
		}
		//changes level at which textfield should be set depending on if there will be a shadow
		public function getIndex(shadow:Boolean)
		{
			var t:Number;
			if(shadow)
			{t = 1;}
			else
			{t = 0;}
			return t;
		}
		
		//call this function for changes to textfield if needed after it's initially drawn
		public function updateTextFormat(tfHandle:Object, tf:TextField)
		{
			var myFont = tfHandle.fFont;
			var newFormat:TextFormat = new TextFormat();
			var newFont:Font = new myFont();
			newFormat.font 		= newFont.fontName;
			newFormat.bold 		= tfHandle.fBold;
			newFormat.size		= tfHandle.fSize;
			tf.setTextFormat(newFormat);
		}
		
		//these next three are for button text use
		
		public function setOverColor(newOverColor:Number)
		{
			tf.textColor 	= newOverColor;
		}
		
		public function setDownColor(newDownColor:Number)
		{
			tf.textColor 	= newDownColor;
		}
		
		public function setUpColor(newUpColor:Number)
		{
			tf.textColor 	= newUpColor;
		}
	
		// allows a quick update of the text value
		// and matching shadow effect
		public function updateText(tsText:String):void
		{
			tf.text 		= String(tsText);
			if(shadowtf)
			{
				shadowtf.text 	= String(tsText);
			}
		}
		
		function getTextField(s:Sprite, name:String):TextField
		{
			var target:DisplayObject = s.getChildByName(name);
			var returnTarget:TextField = TextField(target);
			return returnTarget;
		}
	
		public function destroy():void
		{
			s.removeChildAt(0);
			s.removeChildAt(1);
	
			tf				= null;
			shadowtf		= null;
			s	 			= null;
		}

	}
}