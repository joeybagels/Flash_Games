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

	import flash.display.*;
	import flash.text.*;
	
	public class ZTextVO
	{
			private var sText:String		= "";
			private var x:Number			= 0;
			private var y:Number			= 0;
			private var w:Number;
			private var h:Number;
			private var name:String;
			private var textSize			= 14;
			private var selectable:Boolean 	= true;
			private var mouse:Boolean 		= false;
			private var textColor:Number 	= 0x000000;
			private var multiline:Boolean  	= false;
			private var wordWrap:Boolean 	= false;
			private var autoSize:String 	= TextFieldAutoSize.LEFT;
			private var border:Boolean 		= false;
			private var bgColor:Number		= 0x999999;
			private var background:Boolean 	= false;
			private var bMakeBold:Boolean	= true;
			private var sFontName:Object	= undefined;
			private var embedFonts 			= true;
			private var bShadow:Boolean		= false;
			
		public function ZTextVO()
		{

		}
		
		public function set fText(text:String):void
		{
			this.sText = text;
		}
		
		public function set fX(nx:Number):void
		{
			this.x = nx;
		}
		
		public function set fY(ny:Number):void
		{
			this.y = ny;
		}
		
		public function set fH(nh:Number):void
		{
			this.h = nh;
		}
		
		public function set fW(nw:Number):void
		{
			this.w = nw;
		}
		
		public function set fName(newName:String):void
		{
			this.name = newName;
		}
		
		public function set fSize(tsize:Number):void
		{
			this.textSize = tsize;
		}
		
		public function set fSelectable(select:Boolean):void
		{
			this.selectable = select;
		}
		
		public function set fMouse(mouseEnab:Boolean):void
		{
			this.mouse = mouseEnab;
		}
		
		public function set fColor(tColor:Number):void
		{
			this.textColor = tColor;
		}

		public function set fMulti(mline:Boolean):void
		{
			this.multiline = mline;
		}
		
		public function set fWrap(twrap:Boolean):void
		{
			this.wordWrap = twrap;
		}
		
		public function set fAuto(auto:String):void
		{
			this.autoSize = auto;
		}
		
		public function set fBorder(bBorder:Boolean):void
		{
			this.border = bBorder;
		}
		
		public function set fBgcolor(bg:Number):void
		{
			this.bgColor = bg;
		}
		
		public function set fBg(bg:Boolean):void
		{
			this.background = bg;
		}
		
		public function set fBold(bold:Boolean):void
		{
			this.bMakeBold = bold;
		}
		
		public function set fFont(fontie:Object):void
		{
			this.sFontName = fontie;
		}
		
		public function set fEmbed(mbed:Boolean):void
		{
			this.embedFonts = mbed;
		}
		
		public function set fShadow(shad:Boolean):void
		{
			this.bShadow = shad;
		}
		
		
		
		
		public function get fText():String
		{
			return sText;
		}
		
		public function get fX():Number
		{
			return x;
		}
		
		public function get fY():Number
		{
			return y;
		}
		
		public function get fH():Number
		{
			return h;
		}
		
		public function get fW():Number
		{
			return w;
		}
		
		public function get fName():String
		{
			return name;
		}
		
		public function get fSize():Number
		{
			return textSize;
		}
		
		public function get fSelectable():Boolean
		{
			return selectable;
		}
		
		public function get fMouse():Boolean
		{
			return mouse;
		}
		
		public function get fColor():Number
		{
			return textColor;
		}

		public function get fMulti():Boolean
		{
			return multiline;
		}
		
		public function get fWrap():Boolean
		{
			return wordWrap;
		}
		
		public function get fAuto():String
		{
			return autoSize;
		}
		
		public function get fBorder():Boolean
		{
			return border;
		}
		
		public function get fBgcolor():Number
		{
			return bgColor;
		}
		
		public function get fBg():Boolean
		{
			return background;
		}
		
		public function get fBold():Boolean
		{
			return bMakeBold;
		}
		
		public function get fFont():Object
		{
			return sFontName;
		}
		
		public function get fEmbed():Boolean
		{
			return embedFonts;
		}
		
		public function get fShadow():Boolean
		{
			return bShadow;
		}
		
	}
}