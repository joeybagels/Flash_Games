/***************************************************************

	Copyright 2008, Zero G Games Limited.
	
	Redistribution of part or whole of this file and
	the accompanying files is strictly prohibited.
	
	Redistribution of modified versions of this file and
	the accompaying files is also strictly prohibited.
	
****************************************************************/
	
	
	
package com.zerog.invasion {
	import flash.display.*;
	
	
	public class GemBackground extends MovieClip {
		public var finished:Boolean;
		
		
		function GemBackground() {
			finished = false;
			
			stop();
		}
		
		
		public function setFinished():void {
			finished = true;
			
			gotoAndStop("finished");
		}
	}
}