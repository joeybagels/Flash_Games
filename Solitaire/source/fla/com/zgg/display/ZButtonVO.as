package com.zgg.display
{
	import flash.display.MovieClip;
	
	public class ZButtonVO
	{
		//text object
		private var buttonText:Object	= new Object;
		private var btnText:String		= "";
		//shape and position
		private var hasImage:Boolean	= false;
		private var btnImage:MovieClip	= null;
		private var btnAlign:String		= 'center';
		private var btnMargin:Number	= 2;
		private var btnToggle:Boolean	= false;
		private var btnName:String		= "";
		private var btnWidth:Number		= 0;
		private var btnHeight:Number	= 0;
		private var btnX:Number			= 0;
		private var	btnY:Number			= 0;
		private var nRound:Number		= 0;
		//3D rect
		private var bThreeD:Boolean				= false;
		private var nMaincolor:Number 			= 0;
		private var nHighlightcolor:Number		= 0;
		private var nLowlightcolor:Number		= 0;
		private var nShadowcolor:Number 		= 0;
		private var nBgcolor:Number 			= 0;
		private var nRimcolor:Number 			= 0;
		private var bRevShadow:Boolean			= false;
		//fills
		private var btnFill:Number			= 0x333333;
		private var nAlpha:Number			= 0;
		private var btnOver:Number			= 0; //only for auto-creation of rollover states
		private var btnDown:Number			= 0; //only for auto-creation of rollover states
		private var lAlpha:Number			= 0;
		private var lColor:Number			= 0x000000;
		private var lWidth:Number			= 0;
		private var gradColors:Array		= null;
		private var gradColorsOver:Array	= null; //only for auto-creation of rollover states
		private var gradColorsDown:Array	= null; //only for auto-creation of rollover states
		private var fillAlphas:Array		= null;
		private var fillRadian:Number   	= 0;
		private var fillRatios:Array		= null;
		private var glassColors:Array		= null;
		
		//callback function
		private var clickFunction:Function	= null;

					
		public function ZButtonVO()
		{
			
		}
		
		public function set fButtonText(bto:Object):void
		{
			this.buttonText 		= bto;
			
			if(bto.hasText)
			this.buttonText.hasText = bto.hasText;
			
			this.buttonText.fX 		= bto.x;
			this.buttonText.fY 		= bto.y;
			this.buttonText.fW 		= bto.w;
			
			if(bto.multi)
			this.buttonText.fMulti 		= bto.multi;
			if(bto.wrap)
			this.buttonText.fWrap 		= bto.wrap;
			if(bto.size)
			this.buttonText.fSize 		= bto.size;
			if(bto.font)
			this.buttonText.fFont 		= bto.font;
			this.buttonText.fColor 		= bto.color;
			if(bto.border)
			this.buttonText.fOverColor 	= bto.overColor;
			if(bto.border)
			this.buttonText.fDownColor 	= bto.downColor;
			if(bto.border)
			this.buttonText.fBorder 	= bto.tborder;
		}
		
		public function set fBtnText(s:String):void
		{
			this.btnText = s;
		}
		
		public function set fHasImage(hasImg:Boolean):void
		{
			this.hasImage = hasImg;
		}
		
		public function set fBtnImage(img:MovieClip):void
		{
			this.btnImage = img;
		}
		
		public function set fBtnAlign(align:String):void
		{
			this.btnAlign = align;
		}
		
		public function set fBtnMargin(margin:Number):void
		{
			this.btnMargin = margin;
		}
		
		public function set fBtnToggle(toggle:Boolean):void
		{
			this.btnToggle = toggle;
		}
		
		public function set fBtnName(name:String):void
		{
			this.btnName = name;
		}
		
		public function set fBtnWidth(width:Number):void
		{
			this.btnWidth = width;
		}
		
		public function set fBtnHeight(height:Number):void
		{
			this.btnHeight = height;
		}
		
		public function set fBtnX(bx:Number):void
		{
			this.btnX = bx;
		}
		
		public function set fBtnY(by:Number):void
		{
			this.btnY = by;
		}
		
		public function set fbRound(round:Number):void
		{
			this.nRound = round;
		}
		
		public function set fbtnFill(bFill:Number):void
		{
			this.btnFill = bFill;
		}
		
		public function set fAlpha(solidAlpha:Number):void
		{
			this.nAlpha = solidAlpha;
		}
		
		public function set fBtnOver(doRollClrs:Number):void
		{
			this.btnOver = doRollClrs;
		}
		
		public function set fBtnDown(doDownClrs:Number):void
		{
			this.btnDown = doDownClrs;
		}
		
		public function set fBorderColor(lcolor:Number):void
		{
			this.lColor = lcolor;
		}
		
		public function set fBorderAlpha(lalpha:Number):void
		{
			this.lAlpha = lalpha;
		}
		
		public function set fBorderWidth(lwidth:Number):void
		{
			this.lWidth = lwidth;
		}
		
		public function set fGradFill(nGrad:Array):void
		{
			this.gradColors = nGrad;
		}
		
		public function set fGradFillOver(nGradOver:Array):void
		{
			this.gradColorsOver = nGradOver;
		}
		
		public function set fGradFillDown(nGradDown:Array):void
		{
			this.gradColorsDown = nGradDown;
		}
		
		public function set fFillAlphas(nAlphas:Array):void
		{
			this.fillAlphas = nAlphas;
		}
		
		public function set fFillRad(nRads:Number):void
		{
			this.fillRadian = nRads;
		}
		
		public function set fFillRat(nRat:Array):void
		{
			this.fillRatios = nRat;
		}
		
		public function set fglassColors(nGlass:Array):void
		{
			this.glassColors = nGlass;
		}
		
		public function set fThreeD(td:Boolean):void
		{
			this.bThreeD = td;
		}
		
		public function set fMaincolor(tdmc:Number):void
		{
			this.nMaincolor = tdmc;
		}
		
		public function set fHilitecolor(tdhilite:Number):void
		{
			this.nHighlightcolor = tdhilite;
		}
		
		public function set fLowlitecolor(tdlolite:Number):void
		{
			this.nLowlightcolor = tdlolite;
		}
		
		public function set fShadowcolor(tdshadow:Number):void
		{
			this.nShadowcolor = tdshadow;
		}
		
		public function set fBgcolor(tdbg:Number):void
		{
			this.nBgcolor = tdbg;
		}
		
		public function set fRimcolor(tdrim:Number):void
		{
			this.nRimcolor = tdrim;
		}
		
		public function set fReverseshadow(tdrevshad:Boolean):void
		{
			this.bRevShadow = tdrevshad;
		}
		
		public function set fClickFunction(f:Function):void
		{
			this.clickFunction = f;
		}
		


		public function get fButtonText():Object
		{
			return buttonText;
		}
		
		public function get fBtnText():String
		{
			return btnText;
		}
		
		public function get fHasImage():Boolean
		{
			return hasImage;
		}
		
		public function get fBtnImage():MovieClip
		{
			return btnImage;
		}

		public function get fBtnAlign():String
		{
			return btnAlign;
		}
		
		public function get fBtnMargin():Number
		{
			return btnMargin;
		}
		
		public function get fBtnToggle():Boolean
		{
			return btnToggle;
		}
		
		public function get fBtnName():String
		{
			return btnName;
		}
		
		public function get fBtnWidth():Number
		{
			return btnWidth;
		}
		
		public function get fBtnHeight():Number
		{
			return btnHeight;;
		}
		
		public function get fBtnX():Number
		{
			return btnX;
		}
		
		public function get fBtnY():Number
		{
			return btnY;
		}
		
		public function get fbRound():Number
		{
			return nRound;
		}
		
		public function get fbtnFill():Number
		{
			return btnFill;
		}
		
		public function get fBtnOver():Number
		{
			return btnOver;
		}
		
		public function get fBtnDown():Number
		{
			return btnDown;
		}
		
		public function get fAlpha():Number
		{
			return nAlpha;
		}
		
		public function get fBorderColor():Number
		{
			return lColor;
		}
		
		public function get fBorderAlpha():Number
		{
			return lAlpha;
		}
		
		public function get fBorderWidth():Number
		{
			return lWidth;
		}
		
		public function get fGradFill():Array
		{
			return gradColors;
		}
		
		public function get fGradFillOver():Array
		{
			return gradColorsOver;
		}
		
		public function get fGradFillDown():Array
		{
			return gradColorsDown;
		}
		
		public function get fFillAlphas():Array
		{
			return fillAlphas;
		}
		
		public function get fFillRad():Number
		{
			return fillRadian;
		}
		
		public function get fFillRat():Array
		{
			return fillRatios;
		}
		
		public function get fglassColors():Array
		{
			return glassColors;
		}
		
		public function get fThreeD():Boolean
		{
			return bThreeD;
		}
		
		public function get fMaincolor():Number
		{
			return nMaincolor;
		}
		
		public function get fHilitecolor():Number
		{
			return nHighlightcolor;
		}
		
		public function get fLowlitecolor():Number
		{
			return nLowlightcolor;
		}
		
		public function get fShadowcolor():Number
		{
			return nShadowcolor;
		}
		
		public function get fBgcolor():Number
		{
			return nBgcolor;
		}
		
		public function get fRimcolor():Number
		{
			return nRimcolor;
		}
		
		public function get fReverseshadow():Boolean
		{
			return bRevShadow;
		}
		
		public function get fClickFunction():Function
		{
			return clickFunction;
		}

	}
}