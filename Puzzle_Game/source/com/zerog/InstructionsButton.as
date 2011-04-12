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
	
	
	public class InstructionsButton extends MovieClip {
		function InstructionsButton() {
			this.buttonMode = true;
			
			this.addEventListener(MouseEvent.CLICK,
				function():void {
					Object(parent.parent).showInstructionsFromGame();
				}
			);
		}
	}
}