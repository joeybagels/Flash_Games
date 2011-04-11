package com.zerog.effects.particles {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;	

	public class ParticleExplosion extends MovieClip
	{
		private var particleMaxSpeed:Number;
		private var particleFadeSpeed:Number;
		private var particleTotal:Number;
		private var particleRange:Number;
		
		public function ParticleExplosion(particleMaxSpeed:Number, particleFadeSpeed:Number, particleTotal:Number = 0, particleRange:Number = NaN)
		{
			this.particleMaxSpeed = particleMaxSpeed;
			this.particleFadeSpeed = particleFadeSpeed;
			this.particleTotal = particleTotal;
			this.particleRange = particleRange;			
		}

		private function handleParticle(e:Event):void {
			var particle:Particle = e.target as Particle;

			//update alpha, x, y
			particle.alpha -= particle.getFadeSpeed();
			particle.x += particle.getSpeedX();
			particle.y += particle.getSpeedY();

			//if fragment is invisible or out of bounds, remove it
			if (particle.alpha <= 0 || 
				(!isNaN(this.particleRange) && particle.x < particle.getBoundyLeft() || particle.x > particle.getBoundyRight() || 
				particle.y < particle.getBoundyTop() || particle.y > particle.getBoundyBottom())) {

				particle.removeEventListener(Event.ENTER_FRAME, handleParticle);
				
				if (particle.parent != null) {
					particle.parent.removeChild(particle);
				}
				
				if (this.numChildren == 0 && this.parent != null) {
					this.parent.removeChild(this);
				}
			}
		}
				
		
		public function createExplosionFromDisplayObjects(targetX:Number, targetY:Number, objects:Array):void {
			for each (var dObject:DisplayObject in objects) {
				createParticle(targetX, targetY, dObject);
			}
		}
		
		public function createExplosionFromBitmap(targetX:Number, targetY:Number, myBmp:BitmapData):void
		{
			//run for loop based on particleTotal
			for (var i:uint = 0; i < particleTotal; i++) {
				createParticle(targetX, targetY, new Bitmap(myBmp));
			}
		}
		
		private function createParticle(targetX:Number, targetY:Number, dObject:DisplayObject):void {
			//create the "main_holder" movieclip that will hold our bitmap
			//var particle = _root.createEmptyMovieClip("main_holder", _root.getNextHighestDepth());
			var particle:Particle = new Particle();
			addChild(particle);
				
			//create an "internal_holder" movieclip inside "main_holder" that we'll use to center the bitmap data
			//var internal_holder:MovieClip = particle.createEmptyMovieClip("internal_holder", particle.getNextHighestDepth());
			var internal_holder:MovieClip = new MovieClip();
			particle.addChild(internal_holder);
				
			//set "internal_holder" x and y position based on bitmap size
			internal_holder.x = -dObject.width/2;
			internal_holder.y = -dObject.height/2;	
				
			//finally, attach the bitmapData "myBmp" to the movieclip "internal_holder"
			//internal_holder.attachBitmap(myBmp, internal_holder.getNextHighestDepth(), "never", true); 
			internal_holder.addChild(dObject);
			
			//set position & rotation, alpha
			particle.x = targetX;
			particle.y = targetY;
			particle.rotation = Math.random() * 360;
			particle.alpha = .5 + Math.random() * .5;
			
			//set particle boundry            
			if (!isNaN(this.particleRange)) {
				particle.setBoundyLeft(targetX - particleRange);
				particle.setBoundyTop(targetY - particleRange);
				particle.setBoundyRight(targetX + particleRange);
				particle.setBoundyBottom(targetY + particleRange);
			}
			
			//set speed/direction of fragment
			particle.setSpeedX((Math.random() * particleMaxSpeed) - (Math.random() * particleMaxSpeed));
			particle.setSpeedY((Math.random() * particleMaxSpeed) - (Math.random() * particleMaxSpeed));
			particle.setSpeedX(particle.getSpeedX() * particleMaxSpeed);
			particle.setSpeedY(particle.getSpeedY() *particleMaxSpeed);
			
			//set fade out speed
			particle.setFadeSpeed(particleFadeSpeed/2 + Math.random() * particleFadeSpeed/2);
			
			//make fragment move using onEnterFrame
			particle.addEventListener(Event.ENTER_FRAME, handleParticle);
		}		
	}
}