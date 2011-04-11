package com.zgg.display.test
{
	import com.zgg.display.AsTween;
	
	import flash.display.*;
	import flash.events.*;
	
	public class AsTweenTest extends MovieClip
	{
		public var dTween:SimpleButton;
		public var bBmp50:SimpleButton;
		public var bDelayed:SimpleButton;
		public var bKill:SimpleButton;
		public var bMultiple:SimpleButton;
		public var clip:MovieClip = new iCircle;
		public var foot:MovieClip = new footbmp;
		public var square:MovieClip = new mSquare;
		public var mc:MovieClip;
		public var mc2:MovieClip;
		public var t1:AsTween;
		public var t2:AsTween;
		public var t3:AsTween;
		public var t4:AsTween;
		
		public function AsTweenTest()
		{
			dTween.addEventListener(MouseEvent.MOUSE_UP,onDTween);
			bBmp50.addEventListener(MouseEvent.MOUSE_UP,onMoveBMP50);
			bDelayed.addEventListener(MouseEvent.MOUSE_UP,delayedZTween);
			bKill.addEventListener(MouseEvent.MOUSE_UP,onKill);
			bMultiple.addEventListener(MouseEvent.MOUSE_UP,onMultiple);
			
		}

		
		private function onDTween(e:Event):void
		{
			
			/* if(stage.contains(clip) != false) 
			{
			stage.removeChild(clip);
			} */
			clip = new iCircle;
			clip.x = 100;
			clip.y = 100;
			addChild(clip);
			mc = clip;
			t1 = AsTween.zTween(mc, 3, {alpha:0.5, x:220}); 
			//usage: AsTween.zTween(target:Object, duration:Number, tweenVars:Object)
			//tweenVars:Object usage  {tweentype, x, y, delay, overwrite}
		}
		
		private function onMoveBMP50(e:Event):void
		{
			foot = new footbmp;
			foot.x = 345;
			foot.y = 345;
			addChild(foot);
			mc = foot;
			t2 = AsTween.zTween(mc, 2, {alpha:0.5, x:5});
		}
		
		private function delayedZTween(e:Event):void
		{
			/* trace("clip: " + stage.contains(clip));
			if(stage.contains(clip)) 
			{
			stage.removeChild(clip);
			} */
			clip = new iCircle;
			clip.x = 100;
			clip.y = 100;
			addChild(clip);
			mc = clip;
			t3 = AsTween.zTween(mc, 2, {y:300, delay:5, overwrite:false});
		}
		
		private function onKill(e:Event):void
		{
			/* trace("clip: " + stage.contains(clip));
			if(stage.contains(clip)) 
			{
			stage.removeChild(clip);
			} */
			//need to add mc as an array
			AsTween.killTweens(mc, false); //if you add a boolean "true" to the params, it allows final render of active tweens
		}
		
		private function onMultiple(e:Event):void
		{
			square = new mSquare;
			square.x = 200;
			square.y = 200;
			addChild(square);
			clip = new iCircle;
			clip.x = 100;
			clip.y = 100;
			addChild(clip);
			mc = clip;
			mc2 = square;
			var myTweens:Array = [mc, mc2];
			t4 = AsTween.zTween(myTweens, 2, {alpha:0.5});
		}


	}
}