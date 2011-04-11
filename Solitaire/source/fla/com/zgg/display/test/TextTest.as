package com.zgg.display.test
{
	import com.zgg.display.ZText;
	import com.zgg.display.ZTextVO;
	
	import flash.display.MovieClip;
	
	public class TextTest extends MovieClip
	{
		public function TextTest()
		{
			//single line textfield
			var t1:ZTextVO = new ZTextVO;
			t1.fX		= 38;
			t1.fY		= 51;
			t1.fText 	= "Beep beep.  I'm the robot.";
			var field1:ZText = new ZText(t1);
			addChild(field1);
			
			//single line with shadow and font color
			var t2:ZTextVO = new ZTextVO;
			t2.fX		= 38;
			t2.fY		= 150;
			t2.fSize	= 18;
			t2.fColor	= 0xFF0000;
			t2.fText 	= "Fish heads, fish heads, roly-poly fish heads";
			t2.fShadow 	= true;
			var field2:ZText = new ZText(t2);
			addChild(field2);
			
			//multiline, special font, border, no shadow
			var t3:ZTextVO = new ZTextVO;
			t3.fX		= 38;
			t3.fY		= 240;
			t3.fW		= 125;
			t3.fMulti	= true;
			t3.fWrap	= true;
			t3.fSize	= 16;
			t3.fFont	= ComicSans;
			t3.fText 	= "These are not the droids you're looking for.";
			t3.fBorder 	= true;
			var field3:ZText = new ZText(t3);
			addChild(field3);
			
			
			//single line with updated text
			var t4:ZTextVO 	 = t1;
			t4.fY 			 = 385;
			t4.fText 		 = "Here I am baby";
			var field4:ZText = new ZText(t4);
			addChild(field4);
		}

	}
}