package com.zerog.effects.particles {
	import flash.display.MovieClip;	
	
	public class Particle extends MovieClip
	{
		private var boundyLeft:Number;
		private var boundyRight:Number;
		private var boundyTop:Number;
		private var boundyBottom:Number;
		private var speedX:Number;
		private var speedY:Number;		
		private var fadeSpeed:Number;

		public function Particle() {
			super();
		}
		
		public function getFadeSpeed():Number {
			return this.fadeSpeed;
		}

		public function setFadeSpeed(fadeSpeed:Number):void {
			this.fadeSpeed = fadeSpeed;
		}
		
		public function getBoundyLeft():Number {
			return this.boundyLeft;
		}

		public function setBoundyLeft(boundyLeft:Number):void {
			this.boundyLeft = boundyLeft;
		}

		public function getBoundyRight():Number {
			return this.boundyRight;
		}

		public function setBoundyRight(boundyRight:Number):void {
			this.boundyRight = boundyRight;
		}

		public function getBoundyTop():Number {
			return this.boundyTop;
		}

		public function setBoundyTop(boundyTop:Number):void {
			this.boundyTop = boundyTop;
		}

		public function getBoundyBottom():Number {
			return this.boundyBottom;
		}

		public function setBoundyBottom(boundyBottom:Number):void {
			this.boundyBottom = boundyBottom;
		}

		public function getSpeedX():Number {
			return this.speedX;
		}

		public function setSpeedX(speedX:Number):void {
			this.speedX = speedX;
		}

		public function getSpeedY():Number {
			return this.speedY;
		}

		public function setSpeedY(speedY:Number):void {
			this.speedY = speedY;
		}
	}
}