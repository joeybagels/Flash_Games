package com.zgg.display.test
{
	import com.zgg.display.ZButton;
	import com.zgg.display.ZButtonVO;
	import com.zgg.display.ZButtonFactory;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class ZButtonTest extends Sprite
	{
		public function ZButtonTest()
		{
			//Flat Fills
			
			//centered text (is default alignment)
			//this is the button text label
			var bo:Object 	= new Object; //all text params must be passed in via props of one object
			bo.hasText 		= true;  //default is false to accomodate movieclip bg's
			bo.size  		= 18;
			bo.font   		= Times;  //You must define a font if you want text
			bo.x			= 0; //leave x and y at 0,0 for most cases
			bo.y			= 0;
			bo.color   		= 0x000000;
			bo.downColor	= 0xFF0000;
			bo.overColor	= 0x0000FF;
			bo.hasShadow	= true; //shadow size is same as font size. that and offset are hard-coded
			bo.name			= "btn1text";
			//button params
			var bvo:ZButtonVO 	= new ZButtonVO();  //all btn props are made optional by using this class
			bvo.fButtonText		= bo;
			bvo.fBtnText		= "Lovely";
			bvo.fBtnMargin		= 5; //this is the interior margin btwn txt and btn wall
			bvo.fBtnName		= "superZbutton";
			bvo.fBtnX			= 15; //based on top left
			bvo.fBtnY			= 75; //based on top left
			bvo.fBtnWidth		= 100;
			bvo.fBtnHeight		= 50;
			bvo.fbtnFill		= 0xFFFF00; //fills can be solid or gradient. gradient example below
			bvo.fAlpha			= 1;
			bvo.fBorderColor	= 0x666666;
			bvo.fBorderWidth	= 2;  //no border example below
			bvo.fBorderAlpha	= 1;
			bvo.fClickFunction	= goToLink; //callback to function in this class to be executed on click
			var btn1:ZButton 	= new ZButton(bvo);
			addChild(btn1);
			
			//left aligned text
			var bo2:Object 	= new Object;
			bo2.hasText 	= true;
			bo2.size  		= 18;
			bo2.font   		= Times;
			bo2.x			= 0;
			bo2.y			= 0;
			bo2.color   	= 0xFFFFFF;
			bo2.hasShadow	= true;
			bo2.name		= "btn2text";

			var bvo2:ZButtonVO 	= new ZButtonVO();
			bvo2.fButtonText	= bo2;
			bvo2.fBtnText		= "Lovely";
			bvo2.fBtnMargin		= 2;
			bvo2.fBtnAlign		= 'left';
			bvo2.fBtnName		= "superZbutton2";
			bvo2.fBtnX			= 15;
			bvo2.fBtnY			= 195;
			bvo2.fBtnWidth		= 100;
			bvo2.fBtnHeight		= 50;
			bvo2.fbtnFill		= 0x00FF00;
			bvo2.fAlpha			= 1;
			bvo2.fBorderColor	= 0x666666;
			bvo2.fBorderWidth	= 5;
			bvo2.fBorderAlpha	= .5;
			var btn2:ZButton 	= new ZButton(bvo2);
			addChild(btn2);
			
			//right aligned text
			var bo3:Object 	= new Object;
			bo3.hasText 	= true;
			bo3.size  		= 18;
			bo3.font   		= Times;
			bo3.x			= 0;
			bo3.y			= 0;
			bo3.color   	= 0x000000;
			bo3.downColor	= 0xFF0000;
			bo3.overColor	= 0x0000FF;
			bo3.hasShadow	= true;
			bo3.name		= "btn3text";

			var bvo3:ZButtonVO 	= new ZButtonVO();
			bvo3.fButtonText	= bo3;
			bvo3.fBtnText		= "Lovely";
			bvo3.fBtnMargin		= 2;
			bvo3.fBtnAlign		= 'right';
			bvo3.fBtnName		= "superZbutton3";
			bvo3.fBtnX			= 15;
			bvo3.fBtnY			= 335;
			bvo3.fBtnWidth		= 100;
			bvo3.fBtnHeight		= 50;
			bvo3.fbtnFill		= 0xFF99FF;
			bvo3.fAlpha			= 1;
			bvo3.fBorderColor	= 0x333333;
			bvo3.fBorderWidth	= 2;
			bvo3.fBorderAlpha	= 1;
			var btn3:ZButton 	= new ZButton(bvo3);
			addChild(btn3);
			
			
			//Gradient Fill
			
			//no border. default is no border drawn unless its width is defined.
			var bo4:Object 	= new Object;
			bo4.hasText 	= true;
			bo4.size  		= 18;
			bo4.font   		= Times;
			bo4.x			= 0;
			bo4.y			= 0;
			bo4.color   	= 0x000000;
			bo4.downColor	= 0xFF0000;
			bo4.overColor	= 0x0000FF;
			bo4.hasShadow	= true;
			bo4.name		= "btn4text";

			var bvo4:ZButtonVO 	= new ZButtonVO();
			bvo4.fButtonText	= bo4;
			bvo4.fBtnText		= "Lovely";
			bvo4.fBtnMargin		= 2;
			bvo4.fBtnName		= "superZbutton4";
			bvo4.fBtnX			= 150;
			bvo4.fBtnY			= 75;
			bvo4.fBtnWidth		= 100;
			bvo4.fBtnHeight		= 50;
			bvo4.fGradFill		= [0xFF0000, 0x00FF00, 0x0000FF];
			bvo4.fFillAlphas	= [1, 1, 1];
			bvo4.fFillRad		= 45;
			bvo4.fFillRat		= [0, 128, 255];

			var btn4:ZButton 	= new ZButton(bvo4);
			addChild(btn4);
			
			
			//round rect, no shadow
			var bo5:Object 	= new Object;
			bo5.hasText 	= true;
			bo5.size  		= 18;
			bo5.font   		= Times;
			bo5.x			= 0;
			bo5.y			= 0;
			bo5.color   	= 0x000000;
			bo5.downColor	= 0xFF0000;
			bo5.overColor	= 0x0000FF;
			bo5.name		= "btn5text";

			var bvo5:ZButtonVO 	= new ZButtonVO();
			bvo5.fButtonText	= bo5;
			bvo5.fBtnText		= "Lovely";
			bvo5.fBtnMargin		= 2;
			bvo5.fBtnName		= "superZbutton5";
			bvo5.fBtnX			= 150;
			bvo5.fBtnY			= 195;
			bvo5.fbRound		= 10;
			bvo5.fBtnWidth		= 100;
			bvo5.fBtnHeight		= 50;
			bvo5.fGradFill		= [0xCCCCCC, 0x666666];
			bvo5.fFillAlphas	= [1, 1];
			bvo5.fFillRad		= 90;
			bvo5.fFillRat		= [0, 175];
			bvo5.fBorderColor	= 0x333333;
			bvo5.fBorderWidth	= 2;
			bvo5.fBorderAlpha	= 1;

			var btn5:ZButton 	= new ZButton(bvo5);
			addChild(btn5);
			

			//3D rectangle
			var bo6:Object 	= new Object;
			bo6.hasText 	= true;
			bo6.size  		= 18;
			bo6.font   		= Times;
			bo6.x			= 0;
			bo6.y			= 0;
			bo6.color   	= 0x000000;
			bo6.downColor	= 0xFF0000;
			bo6.overColor	= 0x0000FF;
			bo6.hasShadow	= true;
			bo6.name		= "btn6text";

			var bvo6:ZButtonVO 	= new ZButtonVO();
			bvo6.fButtonText	= bo5;
			bvo6.fBtnText		= "Lovely";
			bvo6.fBtnMargin		= 2;
			bvo6.fBtnName		= "superZbutton6";
			bvo6.fBtnX			= 150;
			bvo6.fBtnY			= 335;
			bvo6.fBtnWidth		= 75;
			bvo6.fBtnHeight		= 40;
			bvo6.fThreeD		= true;
			bvo6.fMaincolor		= 0x0000FF; //main fill color
			bvo6.fBgcolor		= 0x000000; //color behind fill and all the lines that make hilites, etc
			bvo6.fHilitecolor	= 0xFF0099;
			bvo6.fLowlitecolor	= 0x333333;
			bvo6.fShadowcolor	= 0xFFFF00;
			bvo6.fRimcolor		= 0x999999;

			var btn6:ZButton 	= new ZButton(bvo6);
			addChild(btn6);
			
			
			//mc as bg image
			var bo7:Object 	= new Object;
			bo7.hasText 	= true; //you can put false if your text is in the mc, then no more txt params needed. 
			bo7.size  		= 18;
			bo7.font   		= Times;
			bo7.x			= 0;
			bo7.y			= 0;
			bo7.color   	= 0x000000;
			bo7.downColor	= 0xFF0000;
			bo7.overColor	= 0x0000FF;
			bo7.name		= "btn7text";

			var bvo7:ZButtonVO 	= new ZButtonVO();
			bvo7.fButtonText	= bo7;
			bvo7.fBtnText		= "Lovely";
			bvo7.fBtnMargin		= 2;
			bvo7.fBtnName		= "superZbutton7";
			bvo7.fBtnX			= 295;
			bvo7.fBtnY			= 45;
			bvo7.fbRound		= 10;
			bvo7.fHasImage		= true;
			bvo7.fBtnImage		= new myButton();

			var btn7:ZButton 	= new ZButton(bvo7);
			addChild(btn7);
			
			
			//round rect, autosized based on textfield and margin set below
			var bo8:Object 	= new Object;
			bo8.hasText 	= true;
			bo8.size  		= 18;
			bo8.font   		= Times;
			bo8.x			= 0;
			bo8.y			= 0;
			bo8.color   	= 0x000000;
			bo8.downColor	= 0xFF0000;
			bo8.overColor	= 0x0000FF;
			bo8.name		= "btn8text";
			bo8.hasShadow	= true;

			var bvo8:ZButtonVO 	= new ZButtonVO();
			bvo8.fButtonText	= bo8;
			bvo8.fBtnText		= "Lovely";
			bvo8.fBtnMargin		= 5;
			bvo8.fBtnName		= "superZbutton8";
			bvo8.fBtnX			= 295;
			bvo8.fBtnY			= 220;
			bvo8.fbRound		= 10;
			bvo8.fGradFill		= [0xCCCCCC, 0x666666];
			bvo8.fFillAlphas	= [1, 1];
			bvo8.fFillRad		= 90;
			bvo8.fFillRat		= [0, 175];
			bvo8.fBorderColor	= 0x333333;
			bvo8.fBorderWidth	= 2;
			bvo8.fBorderAlpha	= 1;

			var btn8:ZButton 	= new ZButton(bvo8);
			addChild(btn8);
			
			
			//round rect, autorollovers
			var bo9:Object 	= new Object;
			bo9.hasText 	= true;
			bo9.size  		= 18;
			bo9.font   		= Times;
			bo9.x			= 0;
			bo9.y			= 0;
			bo9.color   	= 0x000000;
			bo9.downColor	= 0xFF0000;
			bo9.overColor	= 0x0000FF;
			bo9.hasShadow	= true;
			bo9.name		= "btn9text";

			var bvo9:ZButtonVO 	= new ZButtonVO();
			bvo9.fButtonText	= bo9;
			bvo9.fBtnText		= "Lovely";
			bvo9.fBtnMargin		= 5;
			bvo9.fBtnName		= "superZbutton9";
			bvo9.fBtnX			= 295;
			bvo9.fBtnY			= 315;
			bvo9.fBtnWidth		= 75;
			bvo9.fBtnHeight		= 40;
			bvo9.fbRound		= 10;
			bvo9.fbtnFill		= 0x006633;
			bvo9.fBtnOver		= 0x009933;
			bvo9.fBtnDown		= 0x003333;
			bvo9.fAlpha			= 1;
			bvo9.fBorderColor	= 0x999999;
			bvo9.fBorderWidth	= 2;
			bvo9.fBorderAlpha	= .5;

			var btn9:ZButton 	= new ZButton(bvo9);
			addChild(btn9);
			
			
			//3D rect, autorollovers
			var bo10:Object 	= new Object;
			bo10.hasText 	= true;
			bo10.size  		= 18;
			bo10.font   	= Times;
			bo10.x			= 0;
			bo10.y			= 0;
			bo10.color   	= 0x000000;
			bo10.downColor	= 0xFF0000;
			bo10.overColor	= 0x0000FF;
			bo10.hasShadow	= true;
			bo10.name		= "btn10text";

			var bvo10:ZButtonVO 	= new ZButtonVO();
			bvo10.fButtonText	= bo10;
			bvo10.fBtnText		= "Lovely";
			bvo10.fBtnMargin	= 2;
			bvo10.fBtnName		= "superZbutton10";
			bvo10.fBtnX			= 295;
			bvo10.fBtnY			= 365;
			bvo10.fBtnWidth		= 75;
			bvo10.fBtnHeight	= 40;
			bvo10.fThreeD		= true;
			bvo10.fMaincolor	= 0x0000FF;
			bvo10.fBgcolor		= 0xFFFFFF;
			bvo10.fBtnOver		= 0x009933;
			bvo10.fBtnDown		= 0x003333;
			bvo10.fHilitecolor	= 0xFF0099;
			bvo10.fLowlitecolor	= 0x333333;
			bvo10.fShadowcolor	= 0xFFFF00;
			bvo10.fRimcolor		= 0x999999;

			var btn10:ZButton 	= new ZButton(bvo10);
			addChild(btn10);
			
			//glass button
			var bo11:Object 	= new Object;
			bo11.hasText 	= true;
			bo11.size  		= 18;
			bo11.font   	= Times;
			bo11.x			= 0;
			bo11.y			= 0;
			bo11.color   	= 0xCCCCCC;
			bo11.downColor	= 0xFF0000;
			bo11.overColor	= 0x0000FF;
			bo11.hasShadow	= true;
			bo11.name		= "btn11text";

			var bvo11:ZButtonVO = new ZButtonVO();
			bvo11.fButtonText	= bo11;
			bvo11.fBtnText		= "Glass Btn";
			bvo11.fBtnMargin	= 2;
			bvo11.fBtnName		= "superZbutton11";
			bvo11.fBtnX			= 420;
			bvo11.fBtnY			= 65;
			bvo11.fBtnWidth		= 120;
			bvo11.fBtnHeight	= 30;
			bvo11.fglassColors	= [0x0000FF, 0xFFFFFF];
			bvo11.fGradFillOver	= [0x0066FF, 0xFFFFFF];
			bvo11.fGradFillDown	= [0x000099, 0xFFFFFF];
			bvo11.fBorderColor	= 0x333333;
			bvo11.fBorderWidth	= 2;
			bvo11.fBorderAlpha	= 1;

			var btn11:ZButton 	= new ZButton(bvo11);
			addChild(btn11);
			
			//glass button 2
			var bo12:Object = new Object;
			bo12.hasText 	= true;
			bo12.size  		= 18;
			bo12.font   	= Times;
			bo12.x			= 0;
			bo12.y			= 0;
			bo12.color   	= 0xCCCCCC;
			bo12.downColor	= 0xFF0000;
			bo12.overColor	= 0x0000FF;
			bo12.hasShadow	= true;
			bo12.name		= "btn11text";

			var bvo12:ZButtonVO 	= new ZButtonVO();
			bvo12.fButtonText	= bo12;
			bvo12.fBtnText		= "Glass Btn 2";
			bvo12.fBtnMargin	= 2;
			bvo12.fBtnName		= "superZbutton12";
			bvo12.fBtnX			= 420;
			bvo12.fBtnY			= 165;
			bvo12.fBtnWidth		= 120;
			bvo12.fBtnHeight	= 30;
			bvo12.fglassColors	= [0xfb8303, 0x333333];
			bvo12.fGradFillOver	= [0xCC9900, 0x333333];
			bvo12.fGradFillDown	= [0xCC6600, 0x333333];
			bvo12.fBorderColor	= 0x333333;
			bvo12.fBorderWidth	= 2;
			bvo12.fBorderAlpha	= 1;

			var btn12:ZButton 	= new ZButton(bvo12);
			addChild(btn12);
			
			//ZButtonFactory usage
			//single gradient
			var bo13:Object 	= new Object;
			bo13.hasText 	= true;
			bo13.size  		= 18;
			bo13.font   		= Times;
			bo13.x			= 0;
			bo13.y			= 0;
			bo13.color   	= 0x000000;
			bo13.downColor	= 0xFF0000;
			bo13.overColor	= 0x0000FF;
			bo13.hasShadow	= true;
			bo13.name		= "btn9text";

			var bvo13:ZButtonVO 	= new ZButtonVO();
			bvo13.fButtonText	= bo13;
			bvo13.fBtnText		= "Lovely";
			bvo13.fBtnMargin		= 5;
			bvo13.fBtnName		= "superZbutton9";
			bvo13.fBtnX			= 430;
			bvo13.fBtnY			= 315;
			bvo13.fBtnWidth		= 75;
			bvo13.fBtnHeight	= 40;
			bvo13.fbRound		= 10;
			bvo13.fbtnFill		= 0x006633;
			bvo13.fBtnOver		= 0x009933;
			bvo13.fBtnDown		= 0x003333;
			bvo13.fAlpha		= 1;
			bvo13.fBorderColor	= 0x999999;
			bvo13.fBorderWidth	= 2;
			bvo13.fBorderAlpha	= .5;
			
			var bvo14:ZButtonVO 	= new ZButtonVO();
			bvo14.fButtonText	= bo13;
			bvo14.fBtnText		= "Lovely";
			bvo14.fBtnMargin	= 5;
			bvo14.fBtnName		= "superZbutton9";
			bvo14.fBtnX			= 430;
			bvo14.fBtnY			= 375;
			bvo14.fBtnWidth		= 75;
			bvo14.fBtnHeight	= 40;
			bvo14.fbRound		= 10;
			bvo14.fbtnFill		= 0x006633;
			bvo14.fBtnOver		= 0x009933;
			bvo14.fBtnDown		= 0x003333;
			bvo14.fAlpha		= 1;
			bvo14.fBorderColor	= 0x999999;
			bvo14.fBorderWidth	= 2;
			bvo14.fBorderAlpha	= .5;

			var btn13 	= new ZButtonFactory([bvo13, bvo14]);
			addChild(btn13);
			
		}
		
		public function goToLink():void
			{
				var request:URLRequest = new URLRequest("http://www.snopes.com");
				navigateToURL(request);
			}
	}
}