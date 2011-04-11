package com.zgg.display.test
{
		import fl.transitions.*;
		import fl.transitions.easing.*;
		import flash.events.*;
		import flash.display.*;
 		
	public class TransManagerTest extends MovieClip
	{
		public var clip:MovieClip;
		public var bZoom:SimpleButton;
		public var bSqueeze:SimpleButton;
		public var bFade:SimpleButton;
		public var bPhoto:SimpleButton;
		public var bFly:SimpleButton;
		public var bRotate:SimpleButton;
		
		public function TransManagerTest()
		{
			bZoom.addEventListener(MouseEvent.MOUSE_UP,onZoom);
			bSqueeze.addEventListener(MouseEvent.MOUSE_UP,onSqueeze);
			bFade.addEventListener(MouseEvent.MOUSE_UP,onFade);
			bPhoto.addEventListener(MouseEvent.MOUSE_UP,onPhoto);
			bFly.addEventListener(MouseEvent.MOUSE_UP,onFly);
			bRotate.addEventListener(MouseEvent.MOUSE_UP,onRotate);
		}
		
		private function onZoom(e:Event):void
		{
			if(clip) removeChild(clip);
			var clip:MovieClip = new iCircle;
			clip.x = 100;
			clip.y = 100;
			addChild(clip);
 			var tm = new TransitionManager(clip);
			tm.startTransition({type:Zoom, direction:Transition.IN, duration:3, easing:Elastic.easeOut});
		}
		
		private function onSqueeze(e:Event):void
		{
			var clip:MovieClip = new iCircle;
			clip.x = 200;
			clip.y = 200;
			addChild(clip);
			var tm = new TransitionManager(clip);
			tm.startTransition({type:Squeeze, direction:Transition.IN, duration:4, easing:Elastic.easeOut});
		}
		
		private function onFade(e:Event):void
		{
			var clip:MovieClip = new iCircle;
			clip.x = 150;
			clip.y = 150;
			addChild(clip);
			var tm = new TransitionManager(clip);
			tm.startTransition({type:Fade, direction:Transition.OUT, duration:5, easing:Strong.easeOut});
			//to have element removed from stage after fade out, add an transition 
			//event listener and a function that removes the clip from stage.
			//
		}
		
		private function onPhoto(e:Event):void
		{
			var clip:MovieClip = new iCircle;
			clip.x = 275;
			clip.y = 275;
			addChild(clip);
			var tm = new TransitionManager(clip);
			tm.startTransition({type:Photo, direction:Transition.IN, duration:2, easing:Elastic.easeOut});
		}
		
		private function onFly(e:Event):void
		{
			var clip:MovieClip = new iCircle;
			clip.x = 0;
			clip.y = 0;
			addChild(clip);
			var tm = new TransitionManager(clip);
			tm.startTransition({type:Fly, direction:Transition.IN, duration:6, easing:Elastic.easeOut, startPoint:9});
		}
		
		private function onRotate(e:Event):void
		{
			var clip:MovieClip = new mSquare;
			clip.x = 400;
			clip.y = 400;
			addChild(clip);
			var tm = new TransitionManager(clip);
			tm.startTransition({type:Rotate, direction:Transition.IN, duration:5, easing:Elastic.easeOut});
		}

	}
}