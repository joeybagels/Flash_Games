/***************************************************************

	Copyright 2007, Zero G Games Limited.
	
	Redistribution of part or whole of this file and
	the accompanying files is strictly prohibited.
	
	Redistribution of modified versions of this file and
	the accompaying files is also strictly prohibited.
	
****************************************************************/



package com.zerog {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	
	
	public class Game extends MovieClip {
		public static var gameStage:Stage;
		
		
		public function pause():void {
			NewTimer.pause();
		}
		
		public function unpause():void {
			NewTimer.unpause();
		}
		
		
		public function onRightMouseDown():void {
			var target:DisplayObject = getMouseTarget();
			
			if(!target) return;
			
			target.dispatchEvent(new MouseEvent("mouseRightDown"));
		}
		
		public function onRightMouseUp():void {
			var target:DisplayObject = getMouseTarget();
			
			if(!target) return;
			
			target.dispatchEvent(new MouseEvent("mouseRightUp"));
		}
		
		public function onMiddleMouseDown():void {
			var target:DisplayObject = getMouseTarget();
			
			if(!target) return;
			
			target.dispatchEvent(new MouseEvent("mouseMiddleDown"));
		}
		
		public function onMiddleMouseUp():void {
			var target:DisplayObject = getMouseTarget();
			
			if(!target) return;
			
			target.dispatchEvent(new MouseEvent("mouseMiddleUp"));
		}
		
		
		private function getMouseTarget():DisplayObject {
			var mousePoint:Point = this.localToGlobal(new Point(mouseX, mouseY));
			var objectsUnderPoint:Array = this.getObjectsUnderPoint(mousePoint);
			var i:int;
			
			for(i=objectsUnderPoint.length-1;i>=0;i--) {
				if(!objectsUnderPoint[i].parent.mouseEnabled) continue;
				if(objectsUnderPoint[i].parent.parent && !objectsUnderPoint[i].parent.parent.mouseChildren) continue;
				
				return objectsUnderPoint[i];
			}
			
			return null;
		}
	}
}