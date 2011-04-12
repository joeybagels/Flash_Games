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
	
    //import flash.display.GradientType;
    import flash.geom.ColorTransform;
	
	public class ParticleFactory extends MovieClip {
		
		private var aGenerators:Array;
		
		
		private var gravity:Number = 1.3;
		private var minScale:Number = 0.5;
		private var maxScale:Number = 1.5;
		private var minSpeedX:Number = -20;
		private var maxSpeedX:Number = 20;
		private var minSpeedY:Number = -20;
		private var maxSpeedY:Number = 20;
		private var minOpacity:Number = 0.5;
		private var maxOpacity:Number = 1;
		private var alphaDecay:Number = 0.05;
		
		private var mR:Number = 1;
		private var mG:Number = 0;
		private var mB:Number = 0;
		private var mA:Number = 1;
		private var oR:Number = 255;
		private var oG:Number = 0;
		private var oB:Number = 0;
		private var oA:Number = 0;
		
		private var gravityX:Number = 1.3;
		private var gravityY:Number = 1.3;
		
		private var mcParent:MovieClip;
		
		function ParticleFactory(myParent:MovieClip) {
			aGenerators = new Array();
			mcParent = myParent;
		}
		
		public function clearGenerators():void {
			aGenerators = new Array();
		}
		
		public function generateParticle(config:Object):void {
			//particleFactory.generateParticle(config);
			//trace("generateParticle() layer=" + config.layer);
			if (config == null || config.layer == null) {
				return;
			}
			if (config.num == null) {
				config.num = 40;
			}
			if (config.pace == null) {
				config.pace = 10;
			}
			if (config.gravity == null) {
				config.gravity = gravity;
			}
			if (config.minScale == null) {
				config.minScale = minScale;
			}
			if (config.maxScale == null) {
				config.maxScale = maxScale;
			}
			if (config.minSpeedX == null) {
				config.minSpeedX = minSpeedX;
			}
			if (config.maxSpeedX == null) {
				config.maxSpeedX = maxSpeedX;
			}
			if (config.minSpeedY == null) {
				config.minSpeedY = minSpeedY;
			}
			if (config.maxSpeedY == null) {
				config.maxSpeedY = maxSpeedY;
			}
			if (config.minOpacity == null) {
				config.minOpacity = minOpacity;
			}
			if (config.maxOpacity == null) {
				config.maxOpacity = maxOpacity;
			}
			if (config.alphaDecay == null) {
				config.alphaDecay = alphaDecay;
			}
			if (config.mR == null) {
				config.mR = mR;
			}
			if (config.mG == null) {
				config.mG = mG;
			}
			if (config.mB == null) {
				config.mB = mB;
			}
			if (config.mA == null) {
				config.mA = mA;
			}
			if (config.oR == null) {
				config.oR = oR;
			}
			if (config.oG == null) {
				config.oG = oG;
			}
			if (config.oB == null) {
				config.oB = oB;
			}
			if (config.oA == null) {
				config.oA = oA;
			}
			if (config.useRandomColor == null) {
				config.useRandomColor = false;
			}
			if (config.useTypeColor == null) {
				config.useTypeColor = false;
			}
			config.countdown = config.pace;
			
			if (config.gravityXLoc == null || config.gravityYLoc == null) {
				config.bUseGravityPoint = false;
			} else {
				config.bUseGravityPoint = true;
				
				if (config.gravityX == null) {
					config.gravityX = gravityX;
				}
				if (config.gravityY == null) {
					config.gravityY = gravityY;
				}

			}
			
			aGenerators.push(config);
			//trace("gen=" + aGenerators.length);
		}
		
		
		public function updateDisplay():void {
			var numGem:int = aGenerators.length;
			if (numGem > 0) {
				for (var x:int = numGem-1; x > -1; x--) {
					aGenerators[x].countdown--;
					if (aGenerators[x].countdown < 0) {
						aGenerators[x].countdown = aGenerators[x].pace
						if (aGenerators[x].pace <= 0) {
							do {
								generateStar(x);
								aGenerators[x].num--;
							} while (aGenerators[x].num > 0);
						}
						if (aGenerators[x].num > 0) {
							generateStar(x);
							aGenerators[x].num--;
						} else {
							aGenerators.splice(x, 1);
						}
					}
				}
			}
		}
		
		
		
		
		
		public function generateStar(gen:int):void {
			var thisTwinkle;
			if (aGenerators[gen].bUseGravityPoint) {
				thisTwinkle = new Star2();
			} else {
				thisTwinkle = new Star();
			}
		
			var thisStageTwinkle = MovieClip(aGenerators[gen].layer).addChild(thisTwinkle);
			thisStageTwinkle.addEventListener(Event.ENTER_FRAME, twinkleEnterFrame);
			if (aGenerators[gen].x == null) {
				thisStageTwinkle.x = MovieClip(aGenerators[gen].layer).stage.mouseX;
			} else {
				thisStageTwinkle.x = aGenerators[gen].x;
			}
			if (aGenerators[gen].y == null) {
				thisStageTwinkle.y = MovieClip(aGenerators[gen].layer).stage.mouseY;
			} else {
				thisStageTwinkle.y = aGenerators[gen].y;
			}
			thisStageTwinkle.gen = gen;
			// scale 
			// targeting the starPieces directly causes the tween alpha to not work.  
			// could do alpha degradation within enterFrame, but this is good enough for now
			/*
			var scale1 = minScale + Math.random()*(maxScale-minScale);
			var scale2 = minScale + Math.random()*(maxScale-minScale);
			var scale3 = minScale + Math.random()*(maxScale-minScale);
			// thisTwinkle.scaleX = thisTwinkle.scaleY = scale1;
			thisTwinkle.starPiece1.scaleX = thisTwinkle.starPiece1.scaleY = scale1;
			thisTwinkle.starPiece2.scaleX = thisTwinkle.starPiece2.scaleY = scale2;
			thisTwinkle.starPiece3.scaleX = thisTwinkle.starPiece3.scaleY = scale3;
			*/
			var scale1 = aGenerators[gen].minScale + Math.random()*(aGenerators[gen].maxScale-aGenerators[gen].minScale);
			thisTwinkle.scaleX = thisTwinkle.scaleY = scale1;
			
			
			// opacity
			// targeting the starPieces directly causes the tween alpha to not work.  
			// could do alpha degradation within enterFrame, but this is good enough for now
			/*
			var opacity1 = minOpacity + Math.random()*(maxOpacity - minOpacity);
			var opacity2 = minOpacity + Math.random()*(maxOpacity - minOpacity);
			var opacity3 =minOpacity + Math.random()*(maxOpacity - minOpacity);
			thisTwinkle.starPiece1.alpha = opacity1
			thisTwinkle.starPiece2.alpha = opacity2
			thisTwinkle.starPiece3.alpha = opacity3
			*/
			var opacity1 = aGenerators[gen].minOpacity + Math.random()*(aGenerators[gen].maxOpacity - aGenerators[gen].minOpacity);
			thisTwinkle.alpha = opacity1;
			
			thisTwinkle.gravity = aGenerators[gen].gravity;
			thisTwinkle.alphaDecay = aGenerators[gen].alphaDecay;
			
			// start frame
			
			var startFrame1:Number = (Math.floor(Math.random()*50));
			var startFrame2:Number = (Math.floor(Math.random()*50));
			var startFrame3:Number = (Math.floor(Math.random()*50));
			thisTwinkle.starPiece1.gotoAndPlay(startFrame1);
			thisTwinkle.starPiece2.gotoAndPlay(startFrame2);
			thisTwinkle.starPiece3.gotoAndPlay(startFrame3);
			
			//thisStageTwinkle.speedX = -4 + Math.random() * 8;
			//thisStageTwinkle.speedX = Math.random()*(aGenerators[gen].maxSpeedX-aGenerators[gen].minSpeedX) + aGenerators[gen].minSpeedX;
			thisStageTwinkle.speedX = 0;//aGenerators[gen].minSpeedX + (Math.random()*(aGenerators[gen].maxSpeedX-aGenerators[gen].minSpeedX));
			thisStageTwinkle.speedY = 0;//aGenerators[gen].minSpeedY + (Math.random()*(aGenerators[gen].maxSpeedY-aGenerators[gen].minSpeedY));
			
			thisStageTwinkle.explodeX = 5 + Math.random() * 5;
			thisStageTwinkle.explodeY = 5 + Math.random() * 5;
			
			if (Math.round(Math.random()) == 0) {
				thisStageTwinkle.explodeX *= -1;
			}
			
			if (Math.round(Math.random()) == 0) {
				thisStageTwinkle.explodeY *= -1;
			}
			
			
			thisStageTwinkle.explodeCount = 10;
			
			if (aGenerators[gen].bUseGravityPoint) {
				thisTwinkle.bUseGravityPoint = true;
				thisTwinkle.gravityX = aGenerators[gen].gravityX;
				thisTwinkle.gravityY = aGenerators[gen].gravityY;
				thisTwinkle.gravityXLoc = aGenerators[gen].gravityXLoc;
				thisTwinkle.gravityYLoc = aGenerators[gen].gravityYLoc;
				//trace("star("+gen+") loc=" + thisTwinkle.x+","+thisTwinkle.y + ", grav=" + thisTwinkle.gravityX + "," + thisTwinkle.gravityY + ", sp=" + thisStageTwinkle.speedX + "," + thisStageTwinkle.speedY);
			} else {
				thisTwinkle.bUseGravityPoint = false;
			}
			
            //var rOffset:Number = transform.colorTransform.redOffset + 25;
            //var bOffset:Number = transform.colorTransform.redOffset - 25;
			//R,G,B,A multiplier, RGBA offset
			if (aGenerators[gen].useRandomColor) {
				aGenerators[gen].typeColor = Math.floor(Math.random() * 8);
				aGenerators[gen].useTypeColor = true;
			}
			if (aGenerators[gen].useTypeColor) {
				aGenerators[gen].mR = 1;
				aGenerators[gen].mG = 1;
				aGenerators[gen].mB = 1;
				aGenerators[gen].mA = 1;
				aGenerators[gen].oR = 0;
				aGenerators[gen].oG = 0;
				aGenerators[gen].oB = 0;
				aGenerators[gen].oA = 0;
				//red, orange, pink, green, yellow, purple, blue, teal, black
				switch (aGenerators[gen].typeColor) {
					case 0:
					aGenerators[gen].mG = 0;
					aGenerators[gen].mB = 0;
					aGenerators[gen].oR = 240;
					break;
					
					case 1:
					aGenerators[gen].mB = 0;
					aGenerators[gen].oR = 240;
					aGenerators[gen].oG = 200;
					break;
					
					case 2:
					aGenerators[gen].mG = 0;
					aGenerators[gen].oR = 240;
					aGenerators[gen].oB = 240;
					break;
					
					case 3:
					aGenerators[gen].mR = 0;
					aGenerators[gen].mB = 0;
					aGenerators[gen].oG = 240;
					break;
					
					case 4:
					aGenerators[gen].mB = 0;
					aGenerators[gen].oR = 240;
					aGenerators[gen].oG = 240;
					break;
					
					case 5:
					aGenerators[gen].mG = 0;
					aGenerators[gen].oR = 200;
					aGenerators[gen].oB = 220;
					break;
					
					case 6:
					aGenerators[gen].mR = 0;
					aGenerators[gen].mG = 0;
					aGenerators[gen].oB = 240;
					break;
					
					case 7:
					aGenerators[gen].mR = 0;
					aGenerators[gen].oG = 200;
					aGenerators[gen].oB = 240;
					break;
					
					case 8:
					//black
					break;
					
					case 9:
					//random grey
					var tGrey:int = Math.floor(Math.random() * 256);
					aGenerators[gen].mR = tGrey;
					aGenerators[gen].oG = tGrey;
					aGenerators[gen].oB = tGrey;
					break;
				}
			}
            thisStageTwinkle.transform.colorTransform = new ColorTransform(aGenerators[gen].mR, aGenerators[gen].mG, aGenerators[gen].mB, aGenerators[gen].mA, aGenerators[gen].oR, aGenerators[gen].oG, aGenerators[gen].oB, aGenerators[gen].oA);
			//see if i can knock out the white color with -255, or try changing the movieclip graphics
			//then see about putting the 1.0 value back for the multiplier
			//look in the movieclip
			//look into color tween or transform over time?
			//add parameters
			
		}
		
		public function twinkleEnterFrame(evt:Event):void {
			
			//insert use of gravity point here, and flag
			if (evt.target.bUseGravityPoint) {
				if (evt.target.explodeCount > 0) {
					//trace("exlode " + evt.target.explodeCount)
					evt.target.x += evt.target.explodeX;
					evt.target.y += evt.target.explodeY;
					
					evt.target.explodeCount--;
					
					if (evt.target.explodeCount == 0) {
								
						//get the vector between current location
						//and destination
						var xVector:Number = evt.target.gravityXLoc - evt.target.x;
						var yVector:Number = evt.target.gravityYLoc - evt.target.y;
					//	trace("xVector " + xVector)
					//	trace("yVector " + yVector);
						
						//normalize vector
						var length:Number = Math.sqrt(xVector * xVector + yVector * yVector);
						
						//trace("length " + length)
						if (length < Number.MIN_VALUE)
						{	
							length = 0;
						}
				
						var invLength:Number = 1.0 / length;
						//trace("invLength " + invLength)
						xVector *= invLength;
						yVector *= invLength;
					//trace("xVector " + xVector)
						//trace("yVector " + yVector);
						
						//trace("gravity X = " + config.gravityX)
						
										//trace("gravity X = " + config.gravityX + " gravity Y " + config.gravityY);
						evt.target.gravityX *= Math.abs(xVector);
						evt.target.gravityY *= Math.abs(yVector);
						//trace("gravity X = " + config.gravityX + " gravity Y " + config.gravityY);
						
					}
					
				}
				else {
					//trace("gPart move[" + evt.target.gen + "]= " + evt.target.x + "," + evt.target.y);
					evt.target.speedX += evt.target.gravityX;
					evt.target.speedY += evt.target.gravityY;
					evt.target.x += evt.target.speedX;
					evt.target.y += evt.target.speedY;
					//trace("      move[" + evt.target.gen + "]= " + evt.target.x + "," + evt.target.y);
					var tReachedX:Boolean;
					var tReachedY:Boolean;
					if (evt.target.gravityX > 0 && evt.target.x >= evt.target.gravityXLoc) {
						evt.target.x = evt.target.gravityXLoc;
						tReachedX = true;
					} else if (evt.target.gravityX < 0 && evt.target.x <= evt.target.gravityXLoc) {
						evt.target.x = evt.target.gravityXLoc;
						tReachedX = true;
					}
					if (evt.target.gravityY > 0 && evt.target.y >= evt.target.gravityYLoc) {
						evt.target.y = evt.target.gravityYLoc;
						tReachedY = true;
					} else if (evt.target.gravityY < 0 && evt.target.y <= evt.target.gravityYLoc) {
						evt.target.y = evt.target.gravityYLoc;
						tReachedY = true;
					}
					if (tReachedX && tReachedY) {
						evt.target.reachedGravityLoc = true;
					}
					//evt.target.alpha -= evt.target.alphaDecay;
					//if (evt.target.isComplete && evt.target.reachedGravityLoc) {
					if (evt.target.isComplete) {
						//trace("die: " + evt.target)
						evt.target.removeEventListener(Event.ENTER_FRAME, twinkleEnterFrame);
						evt.target.parent.removeChild(evt.target);
					} else if (evt.target.reachedGravityLoc) {
						Object(mcParent).particleGravityReached();
					}
				}
			} else {
				evt.target.speedY += evt.target.gravity;
				evt.target.y += evt.target.speedY;
				evt.target.x += evt.target.speedX;
				evt.target.alpha -= evt.target.alphaDecay;
				if (evt.target.isComplete) {
					//trace("die: " + evt.target)
					evt.target.removeEventListener(Event.ENTER_FRAME, twinkleEnterFrame);
					evt.target.parent.removeChild(evt.target);
				}
			}
		}
		
		
	}
}

/*
import flash.display.Sprite;
    import flash.display.GradientType;
    import flash.geom.ColorTransform;
    import flash.events.MouseEvent;

    public class ColorTransformExample extends Sprite {
        public function ColorTransformExample() {
            var target:Sprite = new Sprite();
            draw(target);
            addChild(target);
            target.useHandCursor = true;
            target.buttonMode = true;
            target.addEventListener(MouseEvent.CLICK, clickHandler)
        }
        public function draw(sprite:Sprite):void {
            var red:uint = 0xFF0000;
            var green:uint = 0x00FF00;
            var blue:uint = 0x0000FF;
            var size:Number = 100;
            sprite.graphics.beginGradientFill(GradientType.LINEAR, [red, blue, green], [1, 0.5, 1], [0, 200, 255]);
            sprite.graphics.drawRect(0, 0, 100, 100);
        }
        public function clickHandler(event:MouseEvent):void {
            var rOffset:Number = transform.colorTransform.redOffset + 25;
            var bOffset:Number = transform.colorTransform.redOffset - 25;
            this.transform.colorTransform = new ColorTransform(1, 1, 1, 1, rOffset, 0, bOffset, 0);
        }
    }

*/




/*

var gravity = 1.3;
var minScale = .5;
var maxScale = 1.5;
var minSpeedY = -20;
var maxSpeedY = -10;
var minOpacity = .5;
var maxOpacity = 1;


// stage.addEventListener(MouseEvent.MOUSE_MOVE,stageMouseMove);
stage.addEventListener(Event.ENTER_FRAME,stageEnterFrame);

//function stageMouseMove(evt:MouseEvent) {
function stageEnterFrame(evt:Event){
	generateStar(evt);
	generateStar(evt);
	generateStar(evt);
}

function generateStar(evt:Event){
	var thisTwinkle = new Star();

	var thisStageTwinkle = evt.target.addChild(thisTwinkle);
	thisStageTwinkle.addEventListener(Event.ENTER_FRAME, twinkleEnterFrame);
	thisStageTwinkle.x = evt.target.stage.mouseX;
	thisStageTwinkle.y = evt.target.stage.mouseY;
	
	// scale 
	// targeting the starPieces directly causes the tween alpha to not work.  
	// could do alpha degradation within enterFrame, but this is good enough for now
	/*
	var scale1 = minScale + Math.random()*(maxScale-minScale);
	var scale2 = minScale + Math.random()*(maxScale-minScale);
	var scale3 = minScale + Math.random()*(maxScale-minScale);
	// thisTwinkle.scaleX = thisTwinkle.scaleY = scale1;
	thisTwinkle.starPiece1.scaleX = thisTwinkle.starPiece1.scaleY = scale1;
	thisTwinkle.starPiece2.scaleX = thisTwinkle.starPiece2.scaleY = scale2;
	thisTwinkle.starPiece3.scaleX = thisTwinkle.starPiece3.scaleY = scale3;
	*/
/*
	var scale1 = minScale + Math.random()*(maxScale-minScale);
	thisTwinkle.scaleX = thisTwinkle.scaleY = scale1;
	
	
	// opacity
	// targeting the starPieces directly causes the tween alpha to not work.  
	// could do alpha degradation within enterFrame, but this is good enough for now
	/*
	var opacity1 = minOpacity + Math.random()*(maxOpacity - minOpacity);
	var opacity2 = minOpacity + Math.random()*(maxOpacity - minOpacity);
	var opacity3 =minOpacity + Math.random()*(maxOpacity - minOpacity);
	thisTwinkle.starPiece1.alpha = opacity1
	thisTwinkle.starPiece2.alpha = opacity2
	thisTwinkle.starPiece3.alpha = opacity3
	*/
/*
	var opacity1 = minOpacity + Math.random()*(maxOpacity - minOpacity);
	thisTwinkle.alpha = opacity1
	
	
	// start frame
	
	var startFrame1:Number = (Math.floor(Math.random()*50));
	var startFrame2:Number = (Math.floor(Math.random()*50));
	var startFrame3:Number = (Math.floor(Math.random()*50));
	thisTwinkle.starPiece1.gotoAndPlay(startFrame1);
	thisTwinkle.starPiece2.gotoAndPlay(startFrame2);
	thisTwinkle.starPiece3.gotoAndPlay(startFrame3);
	
	thisStageTwinkle.speedY = Math.random()*(maxSpeedY-minSpeedY) + minSpeedY;
	thisStageTwinkle.speedX = -4 + Math.random() * 8;
}

function twinkleEnterFrame(evt:Event) {
	evt.target.speedY += gravity;
	evt.target.y += evt.target.speedY;
	evt.target.x += evt.target.speedX;
	evt.target.alpha -= .05;
	if (evt.target.isComplete) {
		//trace("die: " + evt.target)
		evt.target.removeEventListener(Event.ENTER_FRAME, twinkleEnterFrame);
		evt.target.parent.removeChild(evt.target);
	}
}
*/