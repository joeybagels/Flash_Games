/***************************************************************

	Copyright 2008, Zero G Games Limited.
	
	Redistribution of part or whole of this file and
	the accompanying files is strictly prohibited.
	
	Redistribution of modified versions of this file and
	the accompaying files is also strictly prohibited.
	
****************************************************************/
	
	
	
package com.zerog.invasion {
	import flash.display.*;
	import flash.events.MouseEvent;
	
	public class Gem extends MovieClip {
		public var indexX:int, indexY:int;
		
		public var type:int;
		public var colorType:int;
		
		public var startFallX:Number;
		public var endFallX:Number;
		
		public var startFallY:Number;
		public var endFallY:Number;
		
		public var curDir:Number;
		//backClip
		
		public var initMoveFactor:Number;
		
		public var nState:int;
		
		public var bQueFlip:Boolean;
		
		public function initialize(x:int, y:int, offsetY:int):void {
			this.indexX = x;
			this.indexY = y;
			
			this.x = x * Config.BLOCKSIZE + Config.BLOCKSIZE / 2;
			this.y = (y - offsetY) * Config.BLOCKSIZE + Config.BLOCKSIZE / 2;
			
			this.cacheAsBitmap = true;
			
			bQueFlip = false;
		}
		
		public function setType(type:int, maxColors:int = 0):void {
			//destroyListeners();
			this.type = type;
			this.curDir = -1;
			
			nState = Config.GEM_STATE_READY;
			
			/*
			gotoAndStop(type + 1);
			if (type == Config.GEM_TYPE_RND_COLOR1 || type == Config.GEM_TYPE_RND_COLOR2) {
				this.colorType = Math.floor(Math.random() * Config.GEMS_TYPES);
				this.backClip.gotoAndStop(18 + colorType + 1);
			} else {
				this.backClip.gotoAndStop(type + 1);
			}
			*/
			if (type == Config.GEM_TYPE_RND_COLOR1 || type == Config.GEM_TYPE_RND_COLOR2) {
				//this.colorType = Math.floor(Math.random() * Config.GEMS_TYPES);
				this.colorType = Math.floor(Math.random() * maxColors);
				if (type == Config.GEM_TYPE_RND_COLOR1) {
					gotoAndStop(Config.POWERUP_TYPES + colorType + 1);
				} else {
					gotoAndStop(Config.POWERUP_TYPES + Config.GEMS_TYPES + colorType + 1);
				}
			} else {
				gotoAndStop(type + 1);
			}
			//trace("got here: " + this.shipAnim);
			/*
			if (this.shipAnim != null) {
				this.shipAnim.gotoAndPlay("idle");
			}
			*/
			
			//if (type == Config.GEM_TYPE_RND_DIR1 || type == Config.GEM_TYPE_RND_DIR2) {
				//trace("add event listener");
				/*
				this.addEventListener(MouseEvent.MOUSE_OVER, onGemMouseOver, true);
				this.addEventListener(MouseEvent.MOUSE_OUT, onGemMouseOut, true);
				*/
				/*
				this.addEventListener(MouseEvent.ROLL_OVER, onGemMouseOver);
				this.addEventListener(MouseEvent.ROLL_OUT, onGemMouseOut);
				*/
			//}
			
			
		}
		
		/*
		public function destroyListeners():void {
			this.removeEventListener(MouseEvent.MOUSE_OVER, onGemMouseOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onGemMouseOut);
		}
		*/
		/*
		public function onGemMouseOver(mouseEvent:MouseEvent):void {
			trace("gem2 over");
		}
		
		public function onGemMouseOut(mouseEvent:MouseEvent):void {
			trace("gem2 out");
		}
		
		public function setDirection(dir:int):void {
			trace("set direction: " + dir);
		}
		*/
		public function idleDone():void {
			//trace("idleDone");
			if (bQueFlip) {
				bQueFlip = false;
				this.shipAnim.gotoAndPlay("flip2");
			} else {
				this.shipAnim.stop();
			}
		}
		public function spotAnim():void {
			this.shipAnim.gotoAndPlay("spot");
		}
		public function flipAnim():void {
			//gotoAndStop(Config.POWERUP_TYPES + Config.POWERUP_TYPES + type + 1);
			//flip.gotoAndPlay(1);
			//if (this.shipAnim) {
			this.shipAnim.gotoAndPlay("flip");
			//}
		}
		public function flip2Anim():void {
			//gotoAndStop(Config.POWERUP_TYPES + Config.POWERUP_TYPES + type + 1);
			//flip.gotoAndPlay(1);
			//trace("  this.shipAnim=" + this.shipAnim);
			//if (this.shipAnim) {
			//this.shipAnim.gotoAndPlay("flip2");
			//}
			bQueFlip = true;
		}
		
		public function destroyAnim():void {
			//gotoAndStop(Config.POWERUP_TYPES + type + 1);
			//destroy.gotoAndPlay(1);
			this.shipAnim.gotoAndPlay("destroy");
			nState = Config.GEM_STATE_DESTROY;
		}
		
		public function setRandomType(gemMax:int):void {
			//setType(Math.floor(Math.random() * Config.GEMS_TYPES));
			var oldType:int = type;
			var newType:int = oldType;
			while (newType == oldType) {
				newType = Math.floor(Math.random() * gemMax);
			}
			setType(newType);
		}
		
		public function setBlockType():void {
			setType(Config.BLOCK_TYPES - 1);
		}
		
		//public function setPowerupType(type:int):void {
		public function setPowerupType():void {
			setType(Config.BLOCK_TYPES + (Math.floor(Math.random() * (Config.POWERUP_TYPES - Config.BLOCK_TYPES))));
			//setType(14);
			/*
			if (Math.random() < 0.5) {
				setType(9);
			} else {
				setType(10);
			}
			*/
		}
		
	}
}






