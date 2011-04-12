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
	import flash.media.*;
	import flash.net.*;
	
	
	public class MuteButton extends MovieClip {
		function MuteButton() {
			if(SoundMixer.soundTransform.volume == 0) {
				showOff();
			} else {
				showOn();
			}
			
			this.addEventListener(MouseEvent.CLICK, buttonClicked);
			this.buttonMode = true;
		}
		
		
		private function buttonClicked(mouseEvent:MouseEvent):void {
			var sharedObject:SharedObject = SharedObject.getLocal("mute", '/');
			var soundTransform:SoundTransform = new SoundTransform();
			
			sharedObject.objectEncoding = ObjectEncoding.AMF0;
			
			if(SoundMixer.soundTransform.volume == 0) {
				sharedObject.data.isMute = false;
				
				soundTransform.volume = 1;
				SoundMixer.soundTransform = soundTransform;
				
				showOn();
				
			} else {
				sharedObject.data.isMute = true;
				
				soundTransform.volume = 0;
				SoundMixer.soundTransform = soundTransform;
				
				showOff();
			}
		}
		
		private function showOff():void {
			gotoAndStop("off");
		}
		
		private function showOn():void {
			gotoAndStop("on");
		}
	}
}