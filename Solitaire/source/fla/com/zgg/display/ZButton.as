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

//Almost all parameters are optional except you must have either text or 
//width and height, and a color.  If you want text, there are 4 addt'l params required in
//addition to the actual text.
//The 3D rectangle can have rollover colors, but not gradients.
//Buttons that use a movieclip a a background should have any desired rollover states
//created on the timeline with the frame labels set below.
//Glass buttons require rollover and down colors.  They should be 45px or less in height.
// Ususally, you want to set the x and y outside of this class.  Setting StartX and StartY
// will move the circle relative to the registration point of the containing sprite.  That
// means that the container will still be at 0,0 but the circle will have moved inside the 
// container. This will affect tweens.

	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	public class ZButton extends Sprite
	{
		//button container
		public var sButton:Sprite;
		//optional callback function, ie navigateToUrl
		public var fClick:Function;
		//text params
		private var tButtonText:Object 		= new Object;
		private var sbText:String 			= new String;
		private var bHasImage:Boolean 		= new Boolean;
		private var mcImage:MovieClip 		= new MovieClip;
		private var tButtonAlign:String 	= new String;
		private var tButtonMargin:Number 	= new Number;
		private var tbToggle:Boolean		= new Boolean;
		private var tButtonName:String 		= new String;
		private var nW:Number 				= new Number;
		private var nH:Number 				= new Number;
		private var nX:Number 				= new Number;
		private var	nY:Number 				= new Number;
		private var nbRound:Number			= new Number;
		//color fills
		private var nFill:Number			= new Number;
		private var nAlpha:Number			= new Number;
		private var nBtnOver:Number			= new Number; //only needed if autocreation of rollovers is desired
		private var nBtnDown:Number			= new Number; //only needed if autocreation of rollovers is desired
		private var nBorderColor:Number		= new Number;
		private var nBorderAlpha:Number		= new Number;
		private var nBorderWidth:Number		= new Number;
		private var gradClrs:Array			= new Array;
		private var gradClrsOver:Array		= new Array; //only needed if autocreation of rollovers is desired
		private var gradClrsDown:Array		= new Array; //only needed if autocreation of rollovers is desired
		private var gradAlphas:Array		= new Array;
		private var gradRadian:Number		= new Number;
		private var gradRatios:Array		= new Array;
		private var nGlassColors:Array		= new Array; //glass button color triggers glass button creation
		//3D button params
		private var nThreeDBtn				= new Boolean;
		private var nMaincolor 				= new Number;
		private var nHighlightcolor			= new Number;
		private var nLowlightcolor			= new Number;
		private var nShadowcolor 			= new Number;
		private var nBgcolor 				= new Number;
		private var nRimcolor 				= new Number;
		private var bRevShadow				= new Boolean;
		
		private var sOrigin:Sprite;
		private var sText:Sprite;
		private var imageContainer:Sprite;
		private var btf:ZTextVO;
		private var field:ZText;
		private var baseFillRect:ZRectangle;
		private var overFillRect:ZRectangle;
		private var downFillRect:ZRectangle;
		private var baseTDfillRect:ZRectangle;
		private var overTDfillRect:ZRectangle;
		private var downTDfillRect:ZRectangle;
		private var glassFillRect:ZRectangle;
		private var glassFillOverRect:ZRectangle;
		private var glassFillDownRect:ZRectangle;
		private var hiliteRect:ZRectangle;
		private var loliteRect:ZRectangle;
		
		protected var __bLocked:Boolean = false;	//this allows the button to be locked by a function in
													//another class. Locking will disable the button.
		
		public function ZButton(oButton:ZButtonVO)
		{	//all the possible params to set.
			//text object
			tButtonText 			= oButton.fButtonText;
			tButtonText.bT			= oButton.fButtonText.hasText; //required if you want text
			tButtonText.fX			= oButton.fButtonText.fX; //required if you want text
			tButtonText.fY			= oButton.fButtonText.fY; //required if you want text
			tButtonText.fW			= oButton.fButtonText.fW; //required if you want text
			tButtonText.fName		= oButton.fButtonText.name; //define if you will want to apply later textFormats
			tButtonText.fMulti		= oButton.fButtonText.multi;
			tButtonText.fWrap		= oButton.fButtonText.wrap;
			tButtonText.fSize		= oButton.fButtonText.size;
			tButtonText.fFont		= oButton.fButtonText.font;
			tButtonText.fShadow		= oButton.fButtonText.hasShadow;
			tButtonText.fColor 		= oButton.fButtonText.color;
			tButtonText.fDownColor 	= oButton.fButtonText.downColor;
			tButtonText.fOverColor	= oButton.fButtonText.overColor;
			tButtonText.fBorder		= oButton.fButtonText.tborder;
			//shape and position
			sbText					= oButton.fBtnText;
			bHasImage				= oButton.fHasImage;
			mcImage					= oButton.fBtnImage;
			tButtonAlign 			= oButton.fBtnAlign;
			tButtonMargin 			= oButton.fBtnMargin;
			tbToggle 				= oButton.fBtnToggle;
			tButtonName 			= oButton.fBtnName;
			nW						= oButton.fBtnWidth;
			nH 						= oButton.fBtnHeight;
			nX 						= oButton.fBtnX;
			nY 						= oButton.fBtnY;
			nbRound					= oButton.fbRound;
			//3D rect
			nThreeDBtn				= oButton.fThreeD;
			nMaincolor 				= oButton.fMaincolor;
			nHighlightcolor			= oButton.fHilitecolor;
			nLowlightcolor			= oButton.fLowlitecolor;
			nShadowcolor 			= oButton.fShadowcolor;
			nBgcolor 				= oButton.fBgcolor;
			nRimcolor 				= oButton.fRimcolor;
			bRevShadow				= oButton.fReverseshadow;
			//fills
			nFill					= oButton.fbtnFill;
			nBtnOver				= oButton.fBtnOver; //if no value is passed in, states aren't drawn
			nBtnDown				= oButton.fBtnDown;
			nAlpha					= oButton.fAlpha;
			nBtnOver				= oButton.fBtnOver;
			nBtnDown				= oButton.fBtnDown;
			nBorderColor			= oButton.fBorderColor;
			nBorderAlpha			= oButton.fBorderAlpha;
			nBorderWidth			= oButton.fBorderWidth;
			gradClrs				= oButton.fGradFill;
			gradClrsOver			= oButton.fGradFillOver; //if no value is passed in, states aren't drawn
			gradClrsDown			= oButton.fGradFillDown;
			gradAlphas				= oButton.fFillAlphas;
			gradRadian				= oButton.fFillRad;
			gradRatios				= oButton.fFillRat;
			nGlassColors			= oButton.fglassColors;

			fClick					= oButton.fClickFunction;
			
			init();
		}
		
		private function init()
		{
			//give instance a name
			if (this.name == "" || this.name == null) 
			{
				this.name = String(tButtonName);
			}
			
			//create containers
			sButton = new Sprite;
			addChild(sButton);
			
			imageContainer = new Sprite;
			sButton.addChild(imageContainer);
	
			sText = new Sprite;
			sButton.addChild(sText);
	
	
			// positioning outer container
			sButton.x			= nX;
			sButton.y			= nY;
			
			
			//adding provided movieclip, plain fill or gradient fill
			if(bHasImage)
				{
					addImage();
				} else {
					drawFill();
				}
	
			//add text
			if(tButtonText.hasText != false || sbText != "")
			{
				addText(tButtonText);
				//text for glass buttons gets added later, in the draw function for glass btns
			}
			
			//draw hit area rect if not a toggle button
			if(tbToggle == false)
			{
				var rect:ZRectVO = new ZRectVO();
				rect.fillColor   = 0x000000;
				rect.fillAlpha	 = .01;
				rect.fFillArea	 = {w:nW,h:nH};
				rect.fStartX     = 0;
				rect.fStartY     = 0;
				rect.fWidth      = nW;
				rect.fHeight     = nH;
				rect.fRound		 = nbRound;
				rect.fLineAlpha	 = .01;
				var hitRect = new ZRectangle(rect);
				sButton.addChild(hitRect);

				sButton.hitArea			= hitRect;
				sButton.buttonMode 		= true;
				sButton.useHandCursor 	= false;
	
				addListeners(sButton);
			}
		}
		
		
		// adding button image
		private function addImage()
		{
			mcImage.x = 0;
			mcImage.y = 0;
			nH = mcImage.height;
			nW = mcImage.width;

			imageContainer.addChild(mcImage);
		}
		
		private function drawFill()
		{
			if(nW == 0 && nH == 0) //if no button size is provided,
			{
				//don't draw yet. draw the textfield first to get its size and draw based on that.
			} else {
			
				if(!nThreeDBtn  && !nGlassColors)
				{	//check to see if rollover color is not set
					
						var fill:ZRectVO = new ZRectVO();
						fill.fillColor   = nFill;
						fill.fillAlpha   = nAlpha;
						fill.fFillArea	 = {w:nW,h:nH};
						fill.fFillClrs	 = gradClrs;
						fill.fFillAlphas = gradAlphas;
						fill.fFillRadian = gradRadian;
						fill.fFillRatios = gradRatios;
						fill.fStartX     = 0;
						fill.fStartY     = 0;
						fill.fWidth      = nW;
						fill.fHeight     = nH;
						fill.fRound		 = nbRound;
						fill.fLineAlpha	 = nBorderAlpha;
						fill.fLineColor	 = nBorderColor;
						fill.fLineWidth	 = nBorderWidth;
						var fillRect:ZRectangle = new ZRectangle(fill);
						imageContainer.addChild(fillRect);

					if(nBtnOver != 0)
					{
						var overFill:ZRectVO = new ZRectVO();
						overFill.fillColor   = nBtnOver;
						overFill.fillAlpha   = nAlpha;
						overFill.fFillArea	 = {w:nW,h:nH};
						overFill.fFillClrs	 = gradClrsOver;
						overFill.fFillAlphas = gradAlphas;
						overFill.fFillRadian = gradRadian;
						overFill.fFillRatios = gradRatios;
						overFill.fStartX     = 0;
						overFill.fStartY     = 0;
						overFill.fWidth      = nW;
						overFill.fHeight     = nH;
						overFill.fRound		 = nbRound;
						overFillRect = new ZRectangle(overFill);
						imageContainer.addChildAt(overFillRect, 1);
						overFillRect.visible = false;
						
						var downFill:ZRectVO = new ZRectVO();
						downFill.fillColor   = nBtnDown;
						downFill.fillAlpha   = nAlpha;
						downFill.fFillArea	 = {w:nW,h:nH};
						downFill.fFillClrs	 = gradClrsDown;
						downFill.fFillAlphas = gradAlphas;
						downFill.fFillRadian = gradRadian;
						downFill.fFillRatios = gradRatios;
						downFill.fStartX     = 0;
						downFill.fStartY     = 0;
						downFill.fWidth      = nW;
						downFill.fHeight     = nH;
						downFill.fRound		 = nbRound;
						downFillRect = new ZRectangle(downFill);
						imageContainer.addChildAt(downFillRect, 2);
						downFillRect.visible = false;
					}
				
				} else if(!nGlassColors) {
					
					//Draw 3D rect
						var tDfill:ZRectVO = new ZRectVO();
						tDfill.fReverseshadow 	= bRevShadow;
						tDfill.fMaincolor		= nMaincolor;
						tDfill.fHighlightcolor	= nHighlightcolor;
						tDfill.fLowlightcolor	= nLowlightcolor;
						tDfill.fShadowcolor	 	= nShadowcolor;
						tDfill.fBgcolor		 	= nBgcolor;
						tDfill.fRimcolor		= nRimcolor;
						tDfill.fStartX     		= 0;
						tDfill.fStartY    	 	= 0;
						tDfill.fWidth      		= nW;
						tDfill.fHeight     		= nH;
						var tDfillRect = new Z3DRectangle(tDfill);
						imageContainer.addChild(tDfillRect);
						
					
					if(nBtnOver != 0)
					{
						var overTDfill:ZRectVO = new ZRectVO();
						overTDfill.fRimcolor		= nBtnOver;
						overTDfill.fStartX     		= 0;
						overTDfill.fStartY    	 	= 0;
						overTDfill.fWidth      		= nW;
						overTDfill.fHeight     		= nH;
						var overTDfillRect = new Z3DRectangle(overTDfill);
						imageContainer.addChildAt(overTDfillRect, 1);
						overTDfillRect.visible = false;
						
						var downTDfill:ZRectVO = new ZRectVO();
						downTDfill.fRimcolor		= nBtnDown;
						downTDfill.fStartX     		= 0;
						downTDfill.fStartY    	 	= 0;
						downTDfill.fWidth      		= nW;
						downTDfill.fHeight     		= nH;
						var downTDfillRect = new Z3DRectangle(downTDfill);
						imageContainer.addChildAt(downTDfillRect, 2);
						downTDfillRect.visible = false;
					
					}

				} else {
					//glass button
					var b:Number;
					if(nH >= 1 || nH <= 20)
					{b=25}
					else if(nH >= 21 || nH <= 30)
					{b=30}
					else if(nH >= 31 || nH <= 45)
					{b=35}
					var newMiter = b;
					
					var glassFill:ZRectVO = new ZRectVO();
						glassFill.fFillArea	 	= {w:nW,h:nH};
						glassFill.fFillClrs	 	= nGlassColors;
						glassFill.fFillAlphas 	= [1, 1];
						glassFill.fFillRadian 	= 90;
						glassFill.fFillRatios 	= [0, 200];
						glassFill.fStartX     	= 0;
						glassFill.fStartY     	= 0;
						glassFill.fWidth      	= nW;
						glassFill.fHeight     	= nH;
						glassFill.fRound		= newMiter;
						glassFill.fLineAlpha	= nBorderAlpha;
						glassFill.fLineColor	= nBorderColor;
						glassFill.fLineWidth	= nBorderWidth;
						glassFillRect = new ZRectangle(glassFill);
						imageContainer.addChildAt(glassFillRect, 0);
						//over
					var glassFillOver:ZRectVO = new ZRectVO();
						glassFillOver.fFillArea	 	= {w:nW,h:nH};
						glassFillOver.fFillClrs	 	= gradClrsOver;
						glassFillOver.fFillAlphas 	= [1, 1];
						glassFillOver.fFillRadian 	= 90;
						glassFillOver.fFillRatios 	= [0, 200];
						glassFillOver.fStartX     	= 0;
						glassFillOver.fStartY     	= 0;
						glassFillOver.fWidth      	= nW;
						glassFillOver.fHeight     	= nH;
						glassFillOver.fRound		= newMiter;
						glassFillOver.fLineAlpha	= nBorderAlpha;
						glassFillOver.fLineColor	= nBorderColor;
						glassFillOver.fLineWidth	= nBorderWidth;
						glassFillOverRect = new ZRectangle(glassFillOver);
						imageContainer.addChildAt(glassFillOverRect, 1);
						glassFillOverRect.visible	= false;
						
						//down
					var glassFillDown:ZRectVO = new ZRectVO();
						glassFillDown.fFillArea	 	= {w:nW,h:nH};
						glassFillDown.fFillClrs	 	= gradClrsDown;
						glassFillDown.fFillAlphas 	= [1, 1];
						glassFillDown.fFillRadian 	= 90;
						glassFillDown.fFillRatios 	= [0, 200];
						glassFillDown.fStartX     	= 0;
						glassFillDown.fStartY     	= 0;
						glassFillDown.fWidth      	= nW;
						glassFillDown.fHeight     	= nH;
						glassFillDown.fRound		= newMiter;
						glassFillDown.fLineAlpha	= nBorderAlpha;
						glassFillDown.fLineColor	= nBorderColor;
						glassFillDown.fLineWidth	= nBorderWidth;
						glassFillDownRect = new ZRectangle(glassFillDown);
						imageContainer.addChildAt(glassFillDownRect, 2);
						glassFillDownRect.visible = false;
						
						//add text under hilite and lolites
						addText(tButtonText);
						
						var hilite:ZRectVO 	= new ZRectVO();
						hilite.fFillArea	= {w:(glassFill.fWidth - (newMiter * .4)),h:(glassFill.fHeight/3)};
						hilite.fFillClrs	= [0xF2F2F2, 0xD9D9D9];
						hilite.fFillAlphas 	= [.8, .1];
						hilite.fFillRadian 	= 90;
						hilite.fFillRatios 	= [0, 255];
						hilite.fWidth      	= (glassFill.fWidth - (newMiter * .55));
						hilite.fStartX     	= ((glassFill.fWidth/2) - (hilite.fWidth/2));
						hilite.fStartY     	= ((glassFill.fHeight)/15);
						hilite.fHeight     	= (glassFill.fHeight/3);
						hilite.fRound		= (newMiter/2);
						hiliteRect = new ZRectangle(hilite);
						imageContainer.addChildAt(hiliteRect, 3); //must be added to text container to be on top of text

						
						var lolite:ZRectVO 	= new ZRectVO();
						lolite.fFillArea	= {w:(glassFill.fWidth - (newMiter * .55)),h:(glassFill.fHeight/6)};
						//lolite.fGradType	= GradientType.RADIAL;
						lolite.fSpread		= SpreadMethod.REFLECT;
						lolite.fFillClrs	= [0xFFFFFF, 0xFFFFFF];
						lolite.fFillAlphas 	= [.1, .5];
						lolite.fFillRadian 	= 90;
						lolite.fFillRatios 	= [0, 255];
						lolite.fWidth      	= (glassFill.fWidth - (newMiter * .55));
						lolite.fStartX     	= ((glassFill.fWidth/2) - (lolite.fWidth/2));
						lolite.fHeight     	= (glassFill.fHeight/3);
						lolite.fStartY     	= ((glassFill.fHeight - glassFill.fHeight/10) - (lolite.fHeight));
						lolite.fRound		= (newMiter/2);
						loliteRect = new ZRectangle(lolite);
						loliteRect.alpha = .2;
						imageContainer.addChildAt(loliteRect, 4);  //must be added to text container to be on top of text

				}
				
			}
		}
	
		// adding button text (all three states)
		private function addText(tButtonText)
		{
				btf = new ZTextVO;
				btf.fW			= tButtonText.fWidth;
				btf.fMulti		= tButtonText.fMulti;
				btf.fWrap		= tButtonText.fWrap;
				btf.fSize		= tButtonText.fSize;
				btf.fFont		= tButtonText.fFont;
				btf.fText 		= tButtonText.fText;
				btf.fColor 		= tButtonText.fColor;
				btf.fShadow		= tButtonText.fShadow;
				btf.fName		= tButtonText.fName;	//useful for changing textformat later
				btf.fText		= sbText;

			//Determine postion text before adding as child to text container
			if(tButtonText.fX != 0 && tButtonText.fY != 0)
			{
				//If x and y are provided, use them
				btf.fX			= tButtonText.fX + tButtonMargin;
				btf.fY			= tButtonText.fY;
				
				field = new ZText(btf);
				sText.addChildAt(field, 0);
			}
			else
			{
				field = new ZText(btf);
				//If x and y are not set then use default 0,0
				if(nW == 0 && nH == 0)
				{
					getDynamicSize();
					drawFill();
				}
				
				//Now adjust for provided margin size and alignment
				switch(tButtonAlign)
				{
					case 'left':
					//trace("inside left");
						field.x = Number(tButtonMargin);
						if(nH >= sButton.height)
							field.y = (sButton.height / 2) - (field.height/2);
						else if(nH <= sButton.height)
							field.y = (nH / 2) - (field.height/2);
						else
							field.y = 0;
						break;
						
					case 'right':
					//trace("inside right");
						field.x = ((sButton.width) - (field.width)) - Number(tButtonMargin);
						if(nH >= sButton.height)
							field.y = (sButton.height / 2) - (field.height/2);
						else if(nH < sButton.height)
							field.y = (nH / 2) - (field.height/2);
						else
							field.y = 0;
						break;
						
					case 'center':
					//trace("inside center");
						if(sButton.width > 0)
						{
							if(nW >= sButton.width)
								field.x = (sButton.width/2) - (field.width/2);
							else if(sButton.width > nW)
								field.x = (nW/2) - (field.width/2);
							else
								field.x = 0;
							if(nH >= sButton.height)
								field.y = (sButton.height/2) - (field.height / 2);
							else if(sButton.height > nH)
								field.y = (nH/2) - (field.height/2);
							else
								field.y = 0;
						}
						else
						{
							if(nW > sButton.width && sButton.width != 0)
								field.x = (sButton.width/2) - (field.width / 2);
		
							if(nH > sButton.height && sButton.height != 0)
								field.y = (nH/2) - (field.height / 2);
						}
						break;
				}
			}	
			//Finally addChild
			sText.addChildAt(field, 0);
		}
		
		
		private function getDynamicSize()
		{
			nW = field.width + tButtonMargin;
			nH = field.height;
		}
	
	
		// adding button mouse overs
		private function addListeners(sButton:Sprite):void
		{
			sButton.hitArea.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			sButton.hitArea.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			sButton.hitArea.addEventListener(MouseEvent.MOUSE_UP, upHandler);
			sButton.hitArea.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			//executes function in class that instantiates the button - basically a callback
			if(fClick != null) sButton.hitArea.addEventListener(MouseEvent.CLICK, handleClickFunction);
			
		}
			
		protected function onMouseOver(e:MouseEvent):void
		{
			//textfield can be accessed at trace(field.getTextField(field.s, "tButtonText.fName"));
			if(bHasImage)
			{
				mcImage.gotoAndPlay('over');
			}
			
			if(tButtonText.fOverColor)
			{
				field.setOverColor(tButtonText.fOverColor); //textfield rollover color
			}
			
			if(nBtnDown != 0 || gradClrsOver != null) //checks to see if over state was created
			{
				imageContainer.getChildAt(1).visible = true;
				imageContainer.getChildAt(2).visible = false;
			}
		}

		protected function onMouseOut(e:MouseEvent):void
		{
			if(bHasImage)
			{
				mcImage.gotoAndPlay('out');
			}
			
			field.setUpColor(tButtonText.color);
			
			if(nBtnDown != 0 || gradClrsOver != null) //checks to see if over state was created before showing
			{
				if(!nThreeDBtn && !nGlassColors)  //3D and glass have different layering order
				{
					imageContainer.getChildAt(1).visible = false;
					downFillRect.visible = false;
				} else {
					imageContainer.getChildAt(1).visible = false;
					imageContainer.getChildAt(2).visible = false;
				}
			}

		}

		protected function downHandler(e:MouseEvent):void
		{
			if(bHasImage)
			{
				mcImage.gotoAndPlay('down');
			}
			
			if(tButtonText.fDownColor)
			{
				field.setDownColor(tButtonText.fDownColor);
			}
			
			if(nBtnDown != 0 || gradClrsOver != null) //checks to see if down state was created before showing
			{
				if(!nThreeDBtn && !nGlassColors)  //3D and glass have different layering order
				{
					imageContainer.getChildAt(1).visible = false;
					downFillRect.visible = true;
				} else {
					imageContainer.getChildAt(1).visible = false;
					imageContainer.getChildAt(2).visible = true;
				}
			}
		}

		// add custom function here
		protected function upHandler(e:MouseEvent):void
		{
			if(bHasImage)
			{
				mcImage.gotoAndPlay('over');
			}
			
			field.setUpColor(tButtonText.color);
			
			if(nBtnDown != 0 || gradClrsOver != null)
			{
				imageContainer.getChildAt(1).visible = true;
				imageContainer.getChildAt(2).visible = false;
			}
		}
		
		protected function handleClickFunction(e:MouseEvent):void
		{
			fClick();
		}
		
		public function disable()
		{
			__bLocked = true;
			
			if(bHasImage)
			{
			mcImage.gotoAndPlay("disable");
			}
		}
		
		public function enable()
		{
			__bLocked = false;
			
			if(bHasImage)
			{
			mcImage.gotoAndPlay("up");
			}
		}
		
		public function set blocked(b:Boolean):void
		{
			__bLocked = b;
		}
	}
}
