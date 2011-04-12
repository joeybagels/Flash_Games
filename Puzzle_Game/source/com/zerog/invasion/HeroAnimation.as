/***************************************************************

	Copyright 2008, Zero G Games Limited.
	
	Redistribution of part or whole of this file and
	the accompanying files is strictly prohibited.
	
	Redistribution of modified versions of this file and
	the accompaying files is also strictly prohibited.
	
****************************************************************/
	
	
	
package com.zerog.invasion {
	import flash.display.*;
	import flash.events.*;
	
	
	public class HeroAnimation extends MovieClip {
		/*
		private var messageLevel:MessageLevel;
		private var messageLevelClear:MessageLevelClear;
		private var messagePlayAgain:MessagePlayAgain;
		*/
		//private var frameLabels:Array = ["cap","thor","ss","thing","iron","wolv","hulk","doom","galac"];
		private var frameLabels:Array = ["ss","cap","thing","iron","thor","wolv","hulk","doom","galac"];
		private var xBase:int;
		private var yBase:int;
		public var optionDirection:int;
		public var optionColor:int;
		
		public var CAP:uint = 15;
		public var DOOM:uint = 16;
		public var GALAC:uint = 17;
		public var HULK:uint = 18;
		public var IRON1:uint = 19;
		public var IRON2:uint = 20;
		public var IRON3:uint = 21;
		public var IRON4:uint = 22;
		public var SS:uint = 23;
		public var THING:uint = 24;
		public var THOR:uint = 25;
		public var WOLV:uint = 26;
		
		function HeroAnimation() {
			stop();
		}
		
		public function setUpperLeft(xPos:int, yPos:int):void {
			xBase = xPos;
			yBase = yPos;
		}
		
		public function playAnim(anim:int, xPos:int, yPos:int, option:int, option2:int):void {
			optionDirection = option;
			optionColor = option2;
			//set position
			var colOffset:Number = 0;
			if (xPos%2 > 0) {
				colOffset = 0.5;
			} else {
				colOffset = 0;
			}
			if (anim == Config.PUP_TYPE_9) {
				this.x = xBase + 4 * Config.BLOCKSIZE;
				this.y = yBase + 4 * Config.BLOCKSIZE;
			} else {
				this.x = xBase + (xPos) * Config.BLOCKSIZE + (Config.BLOCKSIZE / 2);
				this.y = yBase + (yPos) * Config.BLOCKSIZE + (Config.BLOCKSIZE * colOffset) + (Config.BLOCKSIZE / 2);
			}
			//BLOCK_TYPES - anim in array
			//trace("anim=" + anim + ", index=" + (anim - Config.BLOCK_TYPES) + ", label=" + frameLabels[anim - Config.BLOCK_TYPES]);
			gotoAndPlay(frameLabels[anim - Config.BLOCK_TYPES]);
		}
		
		public function animDone():void {
			gotoAndStop(1);
		}
		
		public function gridColorCollision(dir:int):Boolean {
			return Object(parent).gridColorCollision(dir);
		}
		
		//public function gridCollision(xPos:int, yPos:int):void {
		public function gridCollision(dir:int):Boolean {
			return Object(parent).gridDestroyCollision(dir);
		}
		
		public function allCollision():void {
			Object(parent).gridAllCollision();
		}
		
		public function generateParticle(config:Object, useColor:Boolean = false, useRandomColor:Boolean = false):void {
			if (useRandomColor) {
				config.useRandomColor = true;
			}
			if (useColor) {
				config.mR = 1;
				config.mG = 1;
				config.mB = 1;
				config.mA = 1;
				config.oR = 0;
				config.oG = 0;
				config.oB = 0;
				config.oA = 0;
				//red, orange, pink, green, yellow, purple, blue, teal, black
				switch (optionColor) {
					case 0:
					config.mG = 0;
					config.mB = 0;
					config.oR = 240;
					break;
					
					case 1:
					config.mB = 0;
					config.oR = 240;
					config.oG = 200;
					break;
					
					case 2:
					config.mG = 0;
					config.oR = 240;
					config.oB = 240;
					break;
					
					case 3:
					config.mR = 0;
					config.mB = 0;
					config.oG = 240;
					break;
					
					case 4:
					config.mB = 0;
					config.oR = 240;
					config.oG = 240;
					break;
					
					case 5:
					config.mG = 0;
					config.oR = 200;
					config.oB = 220;
					break;
					
					case 6:
					config.mR = 0;
					config.mG = 0;
					config.oB = 240;
					break;
					
					case 7:
					config.mR = 0;
					config.oG = 200;
					config.oB = 240;
					break;
					
					case 8:
					break;
				}
			}
			Object(parent).generateParticle(config);
		}
		/*
		public function showLevelClear():void {
			hide();
			
			messageLevelClear = new MessageLevelClear();
			messageLevelClear.scoreText.text = Config.SCOREPOPUP_PREFIX + Config.SCORE_LEVEL;
			
			this.addChild(messageLevelClear);
		}
		
		public function showGameOver():void {
			hide();
			
			gotoAndStop("gameOver");
		}
		
		public function hide():void {
			if(messageLevel) {
				this.removeChild(messageLevel);
				messageLevel = null;
			}
			if(messageLevelClear) {
				this.removeChild(messageLevelClear);
				messageLevelClear = null;
			}
			
			gotoAndStop("hide");
		}
		
		private function playAgainButtonClicked(mouseEvent:MouseEvent):void {
			Object(parent.parent).gotoGamePage();
		}
		*/
		
	}
}